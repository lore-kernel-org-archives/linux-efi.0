Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBD44485505;
	Tue,  1 Sep 2026 16:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788281855; cv=none; b=jyK9kVh/YvGu5RaZdFgefPfiTODq1kg3/FEQZ0qh27ytOsyRFJbS8A9j8nq8C/eJwRkUJ3FGfIwa7kRToYS/1Cg/iMUFdJTK0dm78VWcKMoXScQud3sIC+232hbO5sZJN9gR8if3yJdc7SBSKAKmWlmj6YYl5eCipI3M65diL6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788281855; c=relaxed/simple;
	bh=ziuWZRHDWh2PU3/BB3TR4+/uqBnepWg0Ao5P6VoLQgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q2FBGqJtzzNJCQBF7dHLzNHzDzIWsZ1eHllfQpLOpe861V1WG4rL1B4vyTdhBmJU7VydBL9gnKhz4bVCdZ6b3Rmi8aCYHHeX9okeHM/TB/V78DOR0X1nZHKX8h9O43fD5BiVFCNg59CiooZSD6uPiyg1Prag0hUqbgDXyUaxWm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=HGjFoByZ; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="HGjFoByZ"
Received: by linux.microsoft.com (Postfix, from userid 1130)
	id 0C2EC20B713B; Tue,  1 Sep 2026 09:56:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0C2EC20B713B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1788281815;
	bh=PyfYnkH7UX4a6l5GYM+ronzmhwCwStnMtn2lvCR7eAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HGjFoByZUo1tYxbGkGVnOWikojULOmwtFj71D5WPTpV8AmwrVzx72KSoq5FKdx9vi
	 1j2OuH7Qbq9ndac+AzEmYG1yedhTEnatx4zL/ACXTmkEa2KeMi2+FaLids0c8mt7Cw
	 EctTiu2q46rGnNDkPBOQnzToYq+VrdgrnsPSnhUQ=
From: Thara Gopinath <tgopinath@linux.microsoft.com>
To: kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	ardb@kernel.org,
	ilias.apalodimas@linaro.org
Cc: James.Bottomley@HansenPartnership.com,
	"longli@microsoft.com--cc=tzimmermann"@suse.de, javierm@redhat.com,
	lszubowi@redhat.com, francescopompo2@gmail.com,
	tgopinath@microsoft.com, x86@kernel.org,
	linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-efi@vger.kernel.org,
	Thara Gopinath <tgopinath@linux.microsoft.com>,
	Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
Subject: [RFC PATCH 07/12] drivers: hv: hv_vsm_boot: load secure kernel image from firmware
Date: Tue,  1 Sep 2026 09:55:21 -0700
Message-ID: <20260901165647.3160413-8-tgopinath@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901165647.3160413-1-tgopinath@linux.microsoft.com>
References: <20260901165647.3160413-1-tgopinath@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

LVBS bring-up requires loading a secure kernel image into VTL1 before
starting it. Add the VTL0-side loader that stages the image in the
memory region reserved by hv_vsm_securekernel, in preparation for the
VTL1 bring-up.

The image is a 64-bit ELF fetched via request_firmware("vsm_sk"). It
is expected to ship inside the signed UKI/initramfs so it is
authenticated end-to-end via Secure Boot before the loader consumes
it; sourcing it from an unauthenticated location would break the LVBS
trust model.

The loader validates the ELF header, stages the PT_LOAD segments into
the reserved region and records the entry point as a physical address
for use at VTL1 start time.

If VSM support has been advertised to the hypervisor but no secure
kernel region was reserved on the command line, panic: LVBS bring-up
is committed at this point and there is no safe way to continue.

Signed-off-by: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
Signed-off-by: Thara Gopinath <tgopinath@linux.microsoft.com>
---
 drivers/hv/hv_vsm.h      |  17 ++++
 drivers/hv/hv_vsm_boot.c | 201 ++++++++++++++++++++++++++++++++++++++-
 include/hyperv/vsm.h     |  21 ++++
 3 files changed, 238 insertions(+), 1 deletion(-)
 create mode 100644 drivers/hv/hv_vsm.h
 create mode 100644 include/hyperv/vsm.h

diff --git a/drivers/hv/hv_vsm.h b/drivers/hv/hv_vsm.h
new file mode 100644
index 0000000000000..88f099f88eeb4
--- /dev/null
+++ b/drivers/hv/hv_vsm.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2023-2026, Microsoft Corporation.
+ *
+ * Author: Thara Gopinath <tgopinath@linux.microsoft.com>
+ *
+ */
+
+#ifndef _HV_VSM_H
+#define _HV_VSM_H
+
+#include <linux/ioport.h>
+#include <linux/types.h>
+
+extern struct resource sk_res;
+
+#endif /* _HV_VSM_H */
diff --git a/drivers/hv/hv_vsm_boot.c b/drivers/hv/hv_vsm_boot.c
index 99e4dc8695837..dc20f935da5b2 100644
--- a/drivers/hv/hv_vsm_boot.c
+++ b/drivers/hv/hv_vsm_boot.c
@@ -6,6 +6,7 @@
  * Copyright (c) 2023-2025, Microsoft Corporation.
  *
  * Author: Thara Gopinath <tgopinath@linux.microsoft.com>
+ *         Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
  *
  */
 
@@ -13,10 +14,26 @@
 
 #include <linux/hyperv.h>
 #include <linux/cpumask.h>
+#include <linux/namei.h>
+#include <linux/acpi.h>
+#include <linux/firmware.h>
+#include <hyperv/vsm.h>
+#include <asm/e820/types.h>
 #include <asm/mshyperv.h>
 #include "mshv.h"
+#include "hv_vsm.h"
 
 #define HV_VTL1_ENABLE_BIT	BIT(1)
+/*
+ * Firmware name looked up via request_firmware() under /lib/firmware/.
+ *
+ * The secure kernel image is expected to be delivered inside the signed
+ * UKI/initramfs so that it is authenticated end-to-end via Secure Boot
+ * before request_firmware() returns it.
+ */
+#define SK_FW_NAME		"vsm_sk"
+
+static void *vsm_skm_va;
 
 static int hv_vsm_get_register(u32 reg_name, u64 *result)
 {
@@ -38,6 +55,167 @@ static int hv_vsm_get_register(u32 reg_name, u64 *result)
 	return 0;
 }
 
+static Elf64_Addr __init hv_vsm_elf_min_load_paddr(void *image)
+{
+	Elf64_Ehdr *ehdr = image;
+	Elf64_Phdr *phdr = image + ehdr->e_phoff;
+	Elf64_Addr paddr = U64_MAX;
+	int i;
+
+	for (i = 0; i < ehdr->e_phnum; i++, phdr++) {
+		if (phdr->p_type != PT_LOAD)
+			continue;
+
+		if (phdr->p_paddr < paddr)
+			paddr = phdr->p_paddr;
+	}
+
+	return paddr;
+}
+
+static size_t __init hv_vsm_elf_binary_size(void *image)
+{
+	Elf64_Ehdr *ehdr = image;
+	Elf64_Phdr *phdr = image + ehdr->e_phoff;
+	Elf64_Addr min_paddr, max_paddr = 0;
+	int i;
+
+	min_paddr = hv_vsm_elf_min_load_paddr(image);
+	if (min_paddr == U64_MAX)
+		return 0;
+
+	for (i = 0; i < ehdr->e_phnum; i++, phdr++) {
+		if (phdr->p_type != PT_LOAD)
+			continue;
+
+		max_paddr = max(max_paddr, phdr->p_paddr + phdr->p_memsz);
+	}
+
+	return max_paddr - min_paddr;
+}
+
+static int __init hv_vsm_load_elf(void *image, Elf64_Addr *sk_entry_pa)
+{
+	Elf64_Ehdr *ehdr = image;
+	Elf64_Phdr *phdr = image + ehdr->e_phoff;
+	Elf64_Addr min_paddr;
+	Elf64_Xword first_load_align = 0;
+	size_t size;
+	void *base_addr;
+	int i;
+
+	/* Find alignment of the first PT_LOAD segment. */
+	for (i = 0; i < ehdr->e_phnum; i++) {
+		if (phdr[i].p_type == PT_LOAD) {
+			first_load_align = phdr[i].p_align;
+			break;
+		}
+	}
+	if (!first_load_align) {
+		pr_err("Secure kernel does not have loadable segments\n");
+		return -EINVAL;
+	}
+
+	/* Align the base load address up to the first PT_LOAD segment alignment */
+	base_addr = PTR_ALIGN(vsm_skm_va + first_load_align, first_load_align);
+
+	size = hv_vsm_elf_binary_size(image);
+	if (vsm_skm_va + VSM_SK_INITIAL_MAP_SIZE - base_addr < size) {
+		pr_err("secure kernel does not fit: %zu > %td\n", size,
+		       vsm_skm_va + VSM_SK_INITIAL_MAP_SIZE - base_addr);
+		return -EFBIG;
+	}
+
+	pr_debug("secure kernel binary size: %#zx\n", size);
+
+	min_paddr = hv_vsm_elf_min_load_paddr(image);
+	pr_debug("secure kernel minimal paddr: %#llx\n", min_paddr);
+
+	pr_debug("loading secure kernel ELF segments:\n");
+
+	/* Validate PT_LOAD alignment first, before touching any target memory. */
+	for (i = 0; i < ehdr->e_phnum; i++) {
+		if (phdr[i].p_type != PT_LOAD)
+			continue;
+		if (phdr[i].p_align % SZ_2M) {
+			pr_err("LOAD segment is not aligned by 2MB\n");
+			return -EINVAL;
+		}
+	}
+
+	for (i = 0; i < ehdr->e_phnum; i++, phdr++) {
+		void *load_addr;
+
+		if (phdr->p_type != PT_LOAD)
+			continue;
+
+		/*
+		 * Adjust the load address by min_paddr to compensate the
+		 * offset.
+		 */
+		load_addr = base_addr + (phdr->p_paddr - min_paddr);
+
+		pr_debug("  p_offset: %#016llx, p_filesz: %#016llx, p_memsz: %#016llx to pa %#016llx\n",
+			 phdr->p_offset, phdr->p_filesz, phdr->p_memsz,
+			 virt_to_phys(load_addr));
+		memcpy(load_addr, image + phdr->p_offset, phdr->p_filesz);
+
+		if (phdr->p_memsz == phdr->p_filesz)
+			continue;
+
+		pr_debug("    zeroing %#016llx bytes at pa %#016llx\n",
+			 phdr->p_memsz - phdr->p_filesz,
+			 virt_to_phys(load_addr + phdr->p_filesz));
+		memset(load_addr + phdr->p_filesz, 0,
+		       phdr->p_memsz - phdr->p_filesz);
+	}
+
+	*sk_entry_pa = virt_to_phys(base_addr + (ehdr->e_entry - min_paddr));
+	pr_debug("secure kernel entry pa: %#llx\n", *sk_entry_pa);
+
+	return 0;
+}
+
+static int __init hv_vsm_load_secure_kernel(Elf64_Addr *sk_entry_pa)
+{
+	const struct firmware *fw;
+	Elf64_Ehdr *ehdr;
+	int ret;
+
+	ret = request_firmware(&fw, SK_FW_NAME, NULL);
+	if (ret) {
+		pr_err("Failed to load %s firmware: %d\n", SK_FW_NAME, ret);
+		return ret;
+	}
+
+	ehdr = (Elf64_Ehdr *)fw->data;
+	if (fw->size < sizeof(*ehdr) ||
+	    memcmp(ehdr->e_ident, ELFMAG, SELFMAG) ||
+	    (ehdr->e_type != ET_EXEC && ehdr->e_type != ET_DYN)) {
+		pr_err("Not a valid ELF file: %s\n", SK_FW_NAME);
+		ret = -ENOEXEC;
+		goto out_release;
+	}
+
+	if (ehdr->e_ident[EI_CLASS] != ELFCLASS64) {
+		pr_err("Not a 64-bit compatible ELF file: %s\n", SK_FW_NAME);
+		ret = -ENOEXEC;
+		goto out_release;
+	}
+
+	if (!elf_check_arch(ehdr)) {
+		pr_err("Not a valid ELF file: %s\n", SK_FW_NAME);
+		ret = -ENOEXEC;
+		goto out_release;
+	}
+
+	ret = hv_vsm_load_elf((void *)fw->data, sk_entry_pa);
+
+out_release:
+	release_firmware(fw);
+	return ret;
+}
+
 static int __init hv_vsm_enable_partition_vtl(void)
 {
 	u64 status = 0;
@@ -85,6 +263,7 @@ static int __init hv_vsm_bootstrap_vtl(void)
 {
 	u16 partition_enabled_vtl_set = 0, partition_mbec_enabled_vtl_set = 0;
 	u8 partition_max_vtl;
+	Elf64_Addr sk_entry_pa;
 	int ret;
 
 	/* Check and enable VTL1 at the partition level */
@@ -120,7 +299,25 @@ static int __init hv_vsm_bootstrap_vtl(void)
 			return -EINVAL;
 		}
 	}
-	return 0;
+
+	return hv_vsm_load_secure_kernel(&sk_entry_pa);
+}
+
+static void __init hv_vsm_get_sk_mem(void)
+{
+	/*
+	 * The reserved secure kernel region is mandatory once VSM support has
+	 * been advertised. Without it we cannot load the secure kernel and
+	 * bringing up VTL1 is impossible, so fail hard rather than continuing
+	 * in an unusable state.
+	 */
+	if (!sk_res.start)
+		panic("No memory reserved in cmdline for secure kernel");
+
+	vsm_skm_va = phys_to_virt(sk_res.start);
+
+	pr_info("secure kernel region: %#llx-%#llx (%lld MB)\n",
+		sk_res.start, sk_res.end, resource_size(&sk_res) >> 20);
 }
 
 static bool __init vsm_arch_has_vsm_access(void)
@@ -143,6 +340,8 @@ static int __init hv_vsm_boot_init(void)
 	if (!vsm_arch_has_vsm_access())
 		return 0;
 
+	hv_vsm_get_sk_mem();
+
 	/*
 	 * Copy the current cpu mask and pin rest of the running code to boot cpu.
 	 * Important since we want boot cpu of VTL0 to be the boot cpu for VTL1.
diff --git a/include/hyperv/vsm.h b/include/hyperv/vsm.h
new file mode 100644
index 0000000000000..51555c09413d5
--- /dev/null
+++ b/include/hyperv/vsm.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Common definitions shared by generic and arch code for enabling VTL1
+ * and the Virtual Secure Mode (VSM) framework on Microsoft Hyper-V.
+ *
+ * Copyright (c) 2025-2026, Microsoft Corporation.
+ *
+ * Author: Thara Gopinath <tgopinath@linux.microsoft.com>
+ */
+
+#ifndef _HYPERV_VSM_H
+#define _HYPERV_VSM_H
+
+/*
+ * Size of memory that is initially mapped for the secure kernel by the
+ * VTL0-side loader. The secure kernel image itself may be larger than
+ * this and map additional memory on its own.
+ */
+#define VSM_SK_INITIAL_MAP_SIZE		(16 * 1024 * 1024)
+
+#endif /* _HYPERV_VSM_H */
-- 
2.34.1

