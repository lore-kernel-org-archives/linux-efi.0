Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29D5F484239;
	Tue,  1 Sep 2026 16:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788281854; cv=none; b=knq5RGPLwVqEroSniBn2k901utUPCau0EtAoThLBmLJVlbibvJjNSiZ2og2ccZIIi3czDvT+ZVPkxjw3BZhmPl6Jg0F9aYITkGuUyc+FB0fbyVzZNLQ2Yq80Fz6i5AeUUVVNx5oHJxrivBtWePqXHxkgbslK8VBswmcinzd7Gsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788281854; c=relaxed/simple;
	bh=Iqe6izHv2sjvSqP3sRxw8kvU2zTeZp9vlAzd2EYirTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TWRpM5BnHLYA/L2WLPYqQHiFmzg3UjN64/F5ybilyNjbvazCkpRhs7VmeH5L8eUgSGkm0c4eid2g9eu15Bbf1pwPRa39u5133HwhFU9ycUKsHQigQ30n10NlpwmKUuezDTjaoxR8gGzneDPe0mhBgi4jHyXRGQ51FENeHYx3T0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Uyfr1+RQ; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Uyfr1+RQ"
Received: by linux.microsoft.com (Postfix, from userid 1130)
	id CAFDF20B712B; Tue,  1 Sep 2026 09:56:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CAFDF20B712B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1788281814;
	bh=w84MF6kutcf25MX1Bag58CHWArSB1QOCs7TafbfwmXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uyfr1+RQ3QeKLT9GhHlFhdpLb0xn6vXYmdZrajpZ3mUJVPfgtXdNC1wPiJ6wK/Jwe
	 oDqBXJXQiua4AAlMwSaUgvYhuwVDktKOqWb9nsK9tXFvQf1HJyddVJqlB+Q0Cwh2YH
	 8obBRFKr9SF0oI1qbAqmUF6+otceT5J/S4VL27ak=
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
	Anna Trikalinou <atrikalinou@microsoft.com>
Subject: [RFC PATCH 03/12] drivers: hv: Reserve memory for VSM secure kernel during early boot
Date: Tue,  1 Sep 2026 09:55:17 -0700
Message-ID: <20260901165647.3160413-4-tgopinath@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260901165647.3160413-1-tgopinath@linux.microsoft.com>
References: <20260901165647.3160413-1-tgopinath@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The VSM secure kernel runs in VTL1 and cannot use the normal Linux
kernel memory allocators — its memory must be reserved before the
general-purpose allocator takes ownership of the physical address space.

Add hv_vsm_securekernel.c to handle this early boot reservation. The
driver parses a new "securekernel=<size>[K|M|G][@<addr>]" kernel command
line argument to allow explicit control over the reserved region's size
and base address. If the argument is absent or specifies a region smaller
than the computed minimum, the driver falls back to an automatic
allocation.

The minimum reservation is calculated as:

  16 MB (base) + (num_possible_cpus * 4 MB per-CPU)

Memory is reserved via memblock_phys_alloc_range() with 2 MB alignment
(SECKERNEL_ALIGN) and registered as an IORESOURCE_SYSTEM_RAM entry named
"vsm" in the iomem resource tree so it is visible in /proc/iomem and
protected from reuse.

The reservation is skipped if sk_res.start is already set, preventing
duplicate reservations if the setup hook is called more than once.

Co-developed-by: Anna Trikalinou <atrikalinou@microsoft.com>
Signed-off-by: Anna Trikalinou <atrikalinou@microsoft.com>
Signed-off-by: Thara Gopinath <tgopinath@linux.microsoft.com>
---
 drivers/hv/Makefile              |   1 +
 drivers/hv/hv_vsm_securekernel.c | 188 +++++++++++++++++++++++++++++++
 2 files changed, 189 insertions(+)
 create mode 100644 drivers/hv/hv_vsm_securekernel.c

diff --git a/drivers/hv/Makefile b/drivers/hv/Makefile
index 888a748cc7cb9..880c570832381 100644
--- a/drivers/hv/Makefile
+++ b/drivers/hv/Makefile
@@ -25,3 +25,4 @@ obj-$(subst m,y,$(CONFIG_MSHV_ROOT)) += hv_proc.o
 ifneq ($(CONFIG_MSHV_ROOT)$(CONFIG_MSHV_VTL),)
 	obj-y += mshv_common.o
 endif
+obj-$(subst m,y,$(CONFIG_HYPERV_VSM)) += hv_vsm_securekernel.o
diff --git a/drivers/hv/hv_vsm_securekernel.c b/drivers/hv/hv_vsm_securekernel.c
new file mode 100644
index 0000000000000..f90f6204b4d18
--- /dev/null
+++ b/drivers/hv/hv_vsm_securekernel.c
@@ -0,0 +1,188 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2024, Microsoft Corporation.
+ *
+ * Authors:
+ *   Anna Trikalinou <atrikalinou@microsoft.com>
+ *   Thara Gopinath <tgopinath@linux.microsoft.com>
+ */
+
+#include <linux/memblock.h>
+
+/* Define Memory Reservation for Secure Kernel */
+#define SECKERNEL_ALIGN			SZ_2M
+#define SECKERNEL_ADDR_MAX		(max_low_pfn_mapped << PAGE_SHIFT)
+/* Secure kernel map (16MB minimum)
+ * Region		Offset		Size
+ * VSM PAGES		0		< 2MB
+ * SKERNEL		?(ELF)		16MB+ (based on config)
+ */
+#define SECKERNEL_BASE_SIZE		(16 * 1024 * 1024)
+#define SECKERNEL_PERCPU_SIZE		(4 * 1024 * 1024)
+
+/* Estimate amount of memory needed for Secure Kernel */
+#define SECKERNEL_MIN_SIZE (SECKERNEL_BASE_SIZE + num_possible_cpus() * SECKERNEL_PERCPU_SIZE)
+
+struct resource sk_res = {
+	.name  = "vsm",
+	.start = 0,
+	.end   = 0,
+	.flags = IORESOURCE_BUSY | IORESOURCE_SYSTEM_RAM,
+	.desc  = IORES_DESC_RESERVED
+};
+
+/*
+ * That function parses "simple" securekernel command lines like
+ *
+ *	securekernel=size[@offset]
+ *
+ * It returns 0 on success and -EINVAL on failure.
+ */
+static int __init parse_securekernel_simple(char *cmdline,
+					    unsigned long long *securekernel_size,
+					    unsigned long long *securekernel_base)
+{
+	char *cur = cmdline;
+
+	*securekernel_size = memparse(cmdline, &cur);
+	if (cmdline == cur) {
+		pr_warn("securekernel: memory value expected\n");
+		return -EINVAL;
+	}
+
+	if (*cur == '@') {
+		*securekernel_base = memparse(cur + 1, &cur);
+	} else if (*cur != ' ' && *cur != '\0') {
+		pr_warn("securekernel: unrecognized char: %c\n", *cur);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static __init char *get_last_securekernel(char *cmdline, const char *name)
+{
+	char *p = cmdline, *sk_cmdline = NULL;
+
+	/* find securekernel and use the last one if there are more */
+	p = strstr(p, name);
+	while (p) {
+		sk_cmdline = p;
+		p = strstr(p + 1, name);
+	}
+
+	if (!sk_cmdline)
+		return NULL;
+
+	return sk_cmdline;
+}
+
+static int __init __parse_securekernel(char *cmdline,
+				       unsigned long long *securekernel_size,
+				       unsigned long long *securekernel_base,
+				       const char *name)
+{
+	char *sk_cmdline;
+
+	if (!securekernel_size || !securekernel_base)
+		return -EINVAL;
+
+	*securekernel_size = 0;
+	*securekernel_base = 0;
+
+	sk_cmdline = get_last_securekernel(cmdline, name);
+
+	if (!sk_cmdline)
+		return -EINVAL;
+
+	sk_cmdline += strlen(name);
+
+	return parse_securekernel_simple(sk_cmdline, securekernel_size, securekernel_base);
+}
+
+/*
+ * That function is the entry point for command line parsing and should be
+ * called from the arch-specific code.
+ */
+static int __init parse_securekernel(char *cmdline,
+				     unsigned long long *securekernel_size,
+				     unsigned long long *securekernel_base)
+{
+	return __parse_securekernel(cmdline, securekernel_size, securekernel_base,
+					"securekernel=");
+}
+
+static int __init hv_vsm_seckernel_mem_init(char *__unused)
+{
+	unsigned long long securekernel_size = 0, securekernel_base = 0;
+	int ret;
+
+	/* Secure Kernel memory is already reserved. Avoid duplicate reservation */
+	if (sk_res.start)
+		return 0;
+	/*
+	 * Reserve Secure Kernel memory.
+	 * Check command line first, if secure kernel memory was defined
+	 */
+	ret = parse_securekernel(boot_command_line, &securekernel_size,
+				 &securekernel_base);
+
+	if (ret != 0 || securekernel_size < SECKERNEL_MIN_SIZE) {
+		if (ret != 0)
+			pr_info("%s: securekernel cmd line not defined. Falling back to default.\n",
+				__func__);
+		else if (securekernel_size < SECKERNEL_MIN_SIZE)
+			pr_info("%s: securekernel cmd line too small. Falling back to default.\n",
+				__func__);
+
+		securekernel_size = SECKERNEL_MIN_SIZE;
+		securekernel_base = 0;
+	}
+
+	/* If securekernel_base was specified from command line,
+	 * try to reserve memory starting from that address
+	 */
+	if (securekernel_base) {
+		unsigned long long start, end;
+
+		end = securekernel_base + securekernel_size;
+		if (end >  SECKERNEL_ADDR_MAX || end < securekernel_base) {
+			pr_warn("%s: Invalid Securekernel base address %llx. Falling back to default.\n",
+				__func__, securekernel_base);
+			securekernel_base = 0;
+		} else {
+			start = memblock_phys_alloc_range(securekernel_size, SECKERNEL_ALIGN,
+							  securekernel_base,
+							  securekernel_base + securekernel_size);
+			if (start != securekernel_base) {
+				pr_warn("%s: memory reservation @ %llx failed-memory is in use\n",
+					__func__, securekernel_base);
+				pr_warn("%s:Falling back to default mem allocation\n", __func__);
+				securekernel_base = 0;
+			}
+		}
+	}
+	/* Default: Find the base address automatically */
+	if (!securekernel_base) {
+		securekernel_base = memblock_phys_alloc_range(securekernel_size, SECKERNEL_ALIGN,
+							      0, SECKERNEL_ADDR_MAX);
+		if (!securekernel_base) {
+			pr_err("%s: Securekernel reservation failed-VSM will not be enabled.\n",
+			       __func__);
+			return -EINVAL;
+		}
+	}
+
+	pr_info("Reserving %ldMB of memory at 0x%llx(%ld MB) for securekernel(System RAM:%ldMB)\n",
+		(unsigned long)(securekernel_size >> 20),
+		securekernel_base,
+		(unsigned long)(securekernel_base >> 20),
+		(unsigned long)(memblock_phys_mem_size() >> 20));
+
+	sk_res.start = securekernel_base;
+	sk_res.end   = securekernel_base + securekernel_size - 1;
+	insert_resource(&iomem_resource, &sk_res);
+
+	return 0;
+}
+__setup("securekernel", hv_vsm_seckernel_mem_init);
-- 
2.34.1

