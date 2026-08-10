Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9E223DB312;
	Mon, 10 Aug 2026 12:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786366008; cv=none; b=ITYb2g7fVe6LRrRXLtVcbgvYaj+BF2IGy2IkZSwgw2U5HczYmYG6sAZHhphzJxQ9Ph1JS4SZVbdqvVCWQEnQ5ZChH9PZUJ5D1YoOIxYIMQrHuDAKQT9IrPgKQrDVqFNSpnNLJtrN5IG4sQujdOgLmKWZ4JYs9uFAhpWbgnIL3do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786366008; c=relaxed/simple;
	bh=w3AkX1cNI7U+KnOmO/E3TFEW+R3ax9tsX1BdupY7GHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fTusE50b5HpseLgTpKNIG7O4WPYEIuurwzQfQ06hlCoCQOEnEwUjv0vgSvPkQXPL4xMZu/Zsvu0IXIMSOyCx7nXwd+G8uxMRuTazeGZKfqCDomgsJBTOCiLe8RRLRwh8whbRMtIKmOKEK/eORT606WcZnUCRX9vGEndiTwhDcpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=NA+ud+IT; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="NA+ud+IT"
Received: from weh-cvm-dev-vm.y50bckvjo0hefgfnzfztsfttff.phxx.internal.cloudapp.net (unknown [20.169.55.37])
	by linux.microsoft.com (Postfix) with ESMTPSA id 4CF2620B7167;
	Mon, 10 Aug 2026 05:46:21 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4CF2620B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1786365982;
	bh=RgM3z2Rl04aIU4U49t9CliFe/Yd/6cXT96zvgcI1vjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NA+ud+ITkTRSQNRx12ntKdqv8gVGO03WW5j8wbo4aCealRkyc/dATmSPbMjsHttv1
	 9x9kqn9A0YWt2Q59++XjC6CUP5udyrY29Y65fSLf/ldGWbkhilijmGOrifeniL51cI
	 DLTErDB1MzX2p6+d2dclvmD4VwXljQ4ttlmRa410=
From: Wei Hu <weh@linux.microsoft.com>
To: linux-hyperv@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Wei Hu <weh@microsoft.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	linux-efi@vger.kernel.org,
	linux-arch@vger.kernel.org
Subject: [PATCH v2 12/13] hyperv: add MSHV Dom0 root-partition boot enablement (EFI HvLoader)
Date: Mon, 10 Aug 2026 12:45:06 +0000
Message-ID: <20260810124527.1409634-13-weh@linux.microsoft.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260810124527.1409634-1-weh@linux.microsoft.com>
References: <20260810124527.1409634-1-weh@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Wei Hu <weh@microsoft.com>

Port the EFI HvLoader protocol handshake (efi-mshv stub + SETUP_MSHV) and
the hyperv_resvd_new memory reservation so an upstream kernel can boot as
a Microsoft Hypervisor (MSHV) root partition. Mainline lacks this
Linux-side enablement, so lxhvloader declines to hand off a stock kernel
as root.

Signed-off-by: Wei Hu <weh@microsoft.com>
---
 MAINTAINERS                                   |   2 +
 arch/x86/hyperv/hv_init.c                     |   3 +
 arch/x86/include/uapi/asm/setup_data.h        |   3 +-
 arch/x86/kernel/cpu/mshyperv.c                |  81 ++++++-
 drivers/firmware/efi/libstub/Makefile         |   5 +-
 .../firmware/efi/libstub/efi-mshv-common.c    | 148 ++++++++++++
 drivers/firmware/efi/libstub/efi-mshv.h       | 109 +++++++++
 drivers/firmware/efi/libstub/x86-efi-mshv.c   | 217 ++++++++++++++++++
 drivers/firmware/efi/libstub/x86-stub.c       |  18 +-
 drivers/hv/hv_common.c                        |  82 +++++++
 include/asm-generic/mshyperv.h                |   7 +
 include/linux/efi.h                           |   1 +
 12 files changed, 672 insertions(+), 4 deletions(-)
 create mode 100644 drivers/firmware/efi/libstub/efi-mshv-common.c
 create mode 100644 drivers/firmware/efi/libstub/efi-mshv.h
 create mode 100644 drivers/firmware/efi/libstub/x86-efi-mshv.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 716acfc3d7c1..0da3c7929aef 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12098,6 +12098,8 @@ F:	arch/x86/include/asm/mshyperv.h
 F:	arch/x86/include/asm/trace/hyperv.h
 F:	arch/x86/kernel/cpu/mshyperv.c
 F:	drivers/clocksource/hyperv_timer.c
+F:	drivers/firmware/efi/libstub/*-efi-mshv.c
+F:	drivers/firmware/efi/libstub/efi-mshv*
 F:	drivers/hid/hid-hyperv.c
 F:	drivers/hv/
 F:	drivers/input/serio/hyperv-keyboard.c
diff --git a/arch/x86/hyperv/hv_init.c b/arch/x86/hyperv/hv_init.c
index 55a8b6de2865..4ee8035cb990 100644
--- a/arch/x86/hyperv/hv_init.c
+++ b/arch/x86/hyperv/hv_init.c
@@ -557,6 +557,9 @@ void __init hyperv_init(void)
 
 		hv_remap_tsc_clocksource();
 		hv_sleep_notifiers_register();
+
+		/* mark ram reserved for hypervisor as owned by hypervisor */
+		hv_mark_resources();
 	} else {
 		hypercall_msr.guest_physical_address = vmalloc_to_pfn(hv_hypercall_pg);
 		wrmsrq(HV_X64_MSR_HYPERCALL, hypercall_msr.as_uint64);
diff --git a/arch/x86/include/uapi/asm/setup_data.h b/arch/x86/include/uapi/asm/setup_data.h
index 2671c4e1b3a0..e88f7bf709ab 100644
--- a/arch/x86/include/uapi/asm/setup_data.h
+++ b/arch/x86/include/uapi/asm/setup_data.h
@@ -14,7 +14,8 @@
 #define SETUP_IMA			8
 #define SETUP_RNG_SEED			9
 #define SETUP_KEXEC_KHO			10
-#define SETUP_ENUM_MAX			SETUP_KEXEC_KHO
+#define SETUP_MSHV			11
+#define SETUP_ENUM_MAX			SETUP_MSHV
 
 #define SETUP_INDIRECT			(1<<31)
 #define SETUP_TYPE_MAX			(SETUP_ENUM_MAX | SETUP_INDIRECT)
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 185d4f677ec0..63504b22b5ba 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -13,6 +13,8 @@
 #include <linux/export.h>
 #include <linux/hardirq.h>
 #include <linux/efi.h>
+#include <linux/memblock.h>
+#include <linux/crash_dump.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/kexec.h>
@@ -22,6 +24,7 @@
 #include <asm/cpuid/api.h>
 #include <hyperv/hvhdk.h>
 #include <asm/mshyperv.h>
+#include <asm/e820/api.h>
 #include <asm/desc.h>
 #include <asm/idtentry.h>
 #include <asm/irq_regs.h>
@@ -496,6 +499,76 @@ EXPORT_SYMBOL_GPL(hv_get_hypervisor_version);
  * Reserved vectors hard coded in the hypervisor. If used outside, the hypervisor
  * will either crash or hang or attempt to break into debugger.
  */
+bool mshv_loader_new = true;
+
+static int hv_resvd_ranges[HV_MAX_RESVD_RANGES] = {
+					[0 ... HV_MAX_RESVD_RANGES - 1] = -1};
+
+/*
+ * Parse eg "hyperv_resvd=3,7,20" where 3, 7, and 20 are indexes into the e820
+ * table for ranges that are reserved by the loader for the hypervisor
+ */
+static int __init hv_parse_hyperv_resvd(char *arg)
+{
+	int idx, max = ARRAY_SIZE(hv_resvd_ranges);
+	int i = 0;
+
+	mshv_loader_new = false;
+
+	if (is_kdump_kernel())
+		return 0;
+
+	if (hv_resvd_ranges[0] != -1) {
+		pr_err("Hyper-V: multiple hyperv_resvd not supported\n");
+		return 0;
+	}
+
+	while (get_option(&arg, &idx)) {
+		if (i >= max) {
+			pr_err("Hyper-V: resvd ranges tbl full %d\n", idx);
+			break;
+		}
+
+		hv_resvd_ranges[i++] = idx;
+	}
+
+	return 0;
+}
+early_param("hyperv_resvd", hv_parse_hyperv_resvd);
+
+/*
+ * Reserve memory that the hypervisor is using early on. The ranges are marked
+ * reserved by a custom bootloader, change that to usable and reserve that
+ * range. Note, the bootloader sanitizes the e820 before passing on here.
+ */
+static void __init hv_resv_mshv_memory(void)
+{
+	u64 start, end, size;
+	int i, idx, max = ARRAY_SIZE(hv_resvd_ranges);
+	int resource_index = 0;
+
+	for (i = 0; i < max && hv_resvd_ranges[i] != -1; i++) {
+		idx = hv_resvd_ranges[i];
+		if (idx < 0 || idx >= e820_table->nr_entries) {
+			pr_info("Hyper-V: invalid resvd idx %d\n", idx);
+			continue;
+		}
+
+		start = e820_table->entries[idx].addr;
+		size = e820_table->entries[idx].size;
+		end = start + size - 1;
+
+		memblock_reserve(start, size);
+		e820_table->entries[idx].type = E820_TYPE_RAM;
+		pr_info("Hyper-V reserve [mem %#018Lx-%#018Lx]\n", start, end);
+
+		hv_mshv_res[resource_index].name = "Hypervisor Code and Data";
+		hv_mshv_res[resource_index].flags = IORESOURCE_BUSY | IORESOURCE_SYSTEM_RAM;
+		hv_mshv_res[resource_index].start = start;
+		hv_mshv_res[resource_index++].end = end;
+	}
+}
+
 static void hv_reserve_irq_vectors(void)
 {
 	#define HYPERV_DBG_FASTFAIL_VECTOR	0x29
@@ -547,8 +620,14 @@ static void __init ms_hyperv_init_platform(void)
 
 	hv_identify_partition_type();
 
-	if (hv_root_partition())
+	if (hv_root_partition()) {
+		/* very first thing, reserve/log exclusive hypervisor memory */
+		if (mshv_loader_new)
+			hv_dump_mshv_memory();
+		else
+			hv_resv_mshv_memory();
 		hv_reserve_irq_vectors();
+	}
 
 	if (cc_platform_has(CC_ATTR_SNP_SECURE_AVIC))
 		ms_hyperv.hints |= HV_DEPRECATING_AEOI_RECOMMENDED;
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 77a2b2d74f3f..ee61b4fcf701 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -87,7 +87,10 @@ lib-$(CONFIG_X86)		+= x86-stub.o smbios.o
 lib-$(CONFIG_X86_64)		+= x86-5lvl.o
 lib-$(CONFIG_RISCV)		+= kaslr.o riscv.o riscv-stub.o
 lib-$(CONFIG_LOONGARCH)		+= loongarch.o loongarch-stub.o
-
+ifdef CONFIG_X86_64
+lib-$(subst m,y,$(CONFIG_MSHV_ROOT)) += efi-mshv-common.o
+lib-$(CONFIG_MSHV_ROOT)	+= x86-efi-mshv.o
+endif
 CFLAGS_arm32-stub.o		:= -DTEXT_OFFSET=$(TEXT_OFFSET)
 
 zboot-obj-y			:= zboot-decompress-gzip.o
diff --git a/drivers/firmware/efi/libstub/efi-mshv-common.c b/drivers/firmware/efi/libstub/efi-mshv-common.c
new file mode 100644
index 000000000000..ab6307f7443c
--- /dev/null
+++ b/drivers/firmware/efi/libstub/efi-mshv-common.c
@@ -0,0 +1,148 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include "efistub.h"
+#include "efi-mshv.h"
+
+struct efi_hvloader_protocol *efi_mshv;
+
+efi_status_t mshv_efi_init(void)
+{
+	efi_status_t status;
+	static efi_guid_t hv_proto_guid = EFI_MSHV_MEDIA_PROTOCOL_GUID;
+
+	status = efi_bs_call(locate_protocol,
+			     &hv_proto_guid, NULL, (void **)&efi_mshv);
+	if (status == EFI_NOT_FOUND) {
+		/* If the protocol is not installed we are in a standard Linux boot */
+		return status;
+	} else if (status != EFI_SUCCESS) {
+		mshv_efi_reboot("LocateProtocol failed unexpectedly with code %d",
+				status);
+	}
+
+	status = efi_mshv->get_loader_init_status();
+	if (status != EFI_SUCCESS)
+		mshv_efi_reboot("mshv protocol installed but seems to have failed with code %d",
+				status);
+
+	return EFI_SUCCESS;
+}
+
+void mshv_get_hv_ranges(efi_memory_desc_t **mem_map, unsigned long *map_sz,
+			unsigned long *desc_sz)
+{
+	efi_status_t status;
+
+	status = efi_mshv->get_hv_ranges((void **)mem_map, map_sz, desc_sz);
+	if (status != EFI_SUCCESS)
+		mshv_efi_reboot("failed to retrieve mshv ranges: error code %d",
+				status);
+}
+
+/*
+ * Concatenate the hypervisor reserved ranges to the command line.
+ *
+ * The reserved ranges are formatted as follows:
+ * 'hyperv_resvd_new=<size>!<address>,<size>!<address>,...'
+ *
+ * @mem_map:		EFI memory map with the hypervisor reserved ranges
+ * @map_sz:		size of the memory map
+ * @desc_sz:		size of each descriptor in the memory map
+ * @old_cmdline:	old command line
+ * @buf:		buffer to hold the new command line
+ */
+efi_status_t mshv_efi_update_cmdline(efi_memory_desc_t *mem_map,
+				     unsigned long map_sz,
+					     unsigned long desc_sz,
+					     const char *old_cmdline,
+					     char *buf, unsigned long buf_sz)
+{
+	unsigned long cmdline_len = 0;
+	int i, nr_desc, written;
+
+	if (old_cmdline) {
+		cmdline_len = strnlen(old_cmdline, buf_sz);
+		if (cmdline_len == buf_sz)
+			return EFI_BUFFER_TOO_SMALL;
+		memcpy(buf, old_cmdline, cmdline_len);
+	}
+
+	written = snprintf(buf + cmdline_len, buf_sz - cmdline_len,
+			   "%shyperv_resvd_new=", cmdline_len ? " " : "");
+	if (written < 0 || written >= buf_sz - cmdline_len)
+		return EFI_BUFFER_TOO_SMALL;
+	cmdline_len += written;
+
+	nr_desc = map_sz / desc_sz;
+	for (i = 0; i < nr_desc; ++i) {
+		efi_memory_desc_t *d;
+		u64 start, sz;
+
+		d = efi_memdesc_ptr(mem_map, desc_sz, i);
+		start = d->phys_addr;
+		sz = d->num_pages << PAGE_SHIFT;
+
+		written = snprintf(buf + cmdline_len, buf_sz - cmdline_len,
+				   "%s0x%llx!0x%llx", i ? "," : "",
+				   sz, start);
+		if (written < 0 || written >= buf_sz - cmdline_len)
+			return EFI_BUFFER_TOO_SMALL;
+		cmdline_len += written;
+	}
+
+	return EFI_SUCCESS;
+}
+
+efi_status_t mshv_set_efi_rt_range(struct efi_boot_memmap *map)
+{
+	u32 nr_desc;
+	int i;
+	efi_status_t status;
+
+	if (!efi_mshv)
+		return EFI_SUCCESS;
+
+	nr_desc = map->map_size / map->desc_size;
+
+	for (i = 0; i < nr_desc; i++) {
+		efi_memory_desc_t *d;
+
+		d = efi_memdesc_ptr(map->map, map->desc_size, i);
+		switch (d->type) {
+		case EFI_RUNTIME_SERVICES_CODE:
+		case EFI_RUNTIME_SERVICES_DATA:
+			status = efi_mshv->register_range(d->phys_addr >> PAGE_SHIFT,
+								d->num_pages);
+			if (status != EFI_SUCCESS)
+				return status;
+			break;
+		default:
+			/* default case: range is not relevant to mshv */
+			break;
+		}
+	}
+
+	return EFI_SUCCESS;
+}
+
+/*
+ * Launch mshv, if enabled.
+ *
+ * If mshv reports a bad status at this point, abort the boot.
+ * To get more information about the failure, the HV loader's internal
+ * logging can be used, which is exposed via efi_hv->get_next_log_msg(...).
+ *
+ */
+efi_status_t mshv_launch(void)
+{
+	struct hvl_return_data ret;
+
+	if (!efi_mshv)
+		return EFI_SUCCESS;
+
+	efi_mshv->launch_hv(NULL, &ret);
+	/* TODO: Where/how do we dump the hv loader logs? */
+	if (ret.launch_data.launch_status != 0)
+		efi_rt_call(reset_system, EFI_RESET_COLD, EFI_ABORTED, 0, NULL);
+	return EFI_SUCCESS;
+}
diff --git a/drivers/firmware/efi/libstub/efi-mshv.h b/drivers/firmware/efi/libstub/efi-mshv.h
new file mode 100644
index 000000000000..3d8f534808ed
--- /dev/null
+++ b/drivers/firmware/efi/libstub/efi-mshv.h
@@ -0,0 +1,109 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _DRIVERS_FIRMWARE_EFI_MSHV_H
+#define _DRIVERS_FIRMWARE_EFI_MSHV_H
+
+#include "efistub.h"
+
+#if IS_ENABLED(CONFIG_MSHV_ROOT)
+
+extern struct efi_hvloader_protocol *efi_mshv;
+
+static inline void mshv_efi_reboot(const char *fmt, ...)
+{
+	va_list args;
+
+	va_start(args, fmt);
+	efi_printk(fmt, args);
+	va_end(args);
+
+	efi_bs_call(stall, 5 * EFI_USEC_PER_SEC);
+	efi_rt_call(reset_system, EFI_RESET_COLD, EFI_ABORTED, 0, NULL);
+}
+
+efi_status_t mshv_efi_init(void);
+void mshv_get_hv_ranges(efi_memory_desc_t **mem_map, unsigned long *map_sz,
+			unsigned long *desc_sz);
+efi_status_t mshv_efi_update_cmdline(efi_memory_desc_t *mem_map,
+				     unsigned long map_sz,
+					     unsigned long desc_sz,
+					     const char *cmdline,
+					     char *buf, unsigned long buf_sz);
+
+#ifdef CONFIG_X86_64
+efi_status_t mshv_efi_setup(struct boot_params *boot_params);
+#endif /* CONFIG_X86_64 */
+
+efi_status_t mshv_set_efi_rt_range(struct efi_boot_memmap *map);
+efi_status_t mshv_launch(void);
+
+struct hvl_dbg_data {
+	u8 unused[552];
+} __packed;
+
+struct hvl_launch_data {
+	u64 launch_status;
+	u64 launch_substatus1;
+} __packed;
+
+struct hvl_load_data {
+	u32 is_unsafe_config:1;
+	u32 reserved:31;
+} __packed;
+
+struct hvl_return_data {
+	u32 crash_dump_area_page_count;
+	u32 unused;
+	u64 crashdump_area_spa;
+	union {
+		struct hvl_launch_data launch_data;
+		struct hvl_load_data load_data;
+	};
+	struct hvl_dbg_data debug_data;
+	void *spa_page_range_array;
+	u32 range_count;
+
+	struct {
+		u32 base_checksum;
+		u32 base_timestamp;
+		u32 patch_checksum;
+		u32 patch_timestamp;
+		u32 base_hpat_entries_used;
+		u32 patch_hpat_entries_used;
+		u32 patch_sequence_number;
+	} patch_details;
+} __packed;
+
+struct efi_hvloader_protocol {
+	void (__efiapi * launch_hv)(void *, struct hvl_return_data *);
+	efi_status_t (__efiapi * register_range)(u64, u64);
+	efi_status_t (__efiapi * get_memory_map)(unsigned long *, void *,
+						 unsigned long *,
+						unsigned long *, u32 *);
+	efi_status_t (__efiapi * get_hv_ranges)(void **,
+						unsigned long *,
+						unsigned long *);
+	efi_status_t (__efiapi * get_loader_init_status)(void);
+	efi_char16_t *(__efiapi * get_next_log_msg)(size_t *);
+};
+
+#else /* CONFIG_MSHV_ROOT */
+#ifdef CONFIG_X86_64
+static inline efi_status_t mshv_efi_setup(struct boot_params *boot_params)
+{
+	return EFI_SUCCESS;
+}
+#endif /* CONFIG_X86_64 */
+
+static inline efi_status_t mshv_set_efi_rt_range(struct efi_boot_memmap *map)
+{
+	return EFI_SUCCESS;
+}
+
+static inline efi_status_t mshv_launch(void)
+{
+	return EFI_SUCCESS;
+}
+#endif /* !CONFIG_MSHV_ROOT */
+
+#endif /* _DRIVERS_FIRMWARE_EFI_MSHV_H */
diff --git a/drivers/firmware/efi/libstub/x86-efi-mshv.c b/drivers/firmware/efi/libstub/x86-efi-mshv.c
new file mode 100644
index 000000000000..771ce3e05c26
--- /dev/null
+++ b/drivers/firmware/efi/libstub/x86-efi-mshv.c
@@ -0,0 +1,217 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <asm/setup.h>
+
+#include "efistub.h"
+#include "efi-mshv.h"
+
+/* Initial number of MSHV reserved ranges, extended as needed */
+#define MSHV_RESERVED_RANGES_COUNT 16
+
+struct mshv_setup_data {
+	struct setup_data sd;
+	struct setup_indirect si;
+} __packed;
+
+static int mshv_realloc_ranges(struct resource **data,
+			       unsigned long *data_sz, int nr_ranges)
+{
+	struct resource *new_data;
+	unsigned long new_sz;
+	int status;
+
+	new_sz = sizeof(struct resource) * nr_ranges;
+	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA, new_sz,
+			     (void **)&new_data);
+	if (status != EFI_SUCCESS) {
+		efi_err("mshv failed to allocate setup_data\n");
+		return status;
+	}
+
+	memset(new_data, 0, new_sz);
+	if (*data) {
+		memcpy(new_data, *data, *data_sz);
+		efi_bs_call(free_pool, *data);
+	}
+
+	*data = new_data;
+	*data_sz = new_sz;
+
+	return EFI_SUCCESS;
+}
+
+static efi_status_t mshv_populate_ranges(struct boot_params *boot_params,
+					 efi_memory_desc_t *mem_map,
+					 unsigned long map_sz,
+					 unsigned long desc_sz)
+{
+	unsigned long cmdline_ptr;
+	char *mshv_cmdline;
+	efi_status_t status;
+
+	cmdline_ptr = boot_params->hdr.cmd_line_ptr;
+	cmdline_ptr |= (u64)boot_params->ext_cmd_line_ptr << 32;
+
+	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA,
+			     COMMAND_LINE_SIZE, (void **)&mshv_cmdline);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	status = mshv_efi_update_cmdline(mem_map, map_sz, desc_sz,
+					 (char *)cmdline_ptr, mshv_cmdline,
+					 COMMAND_LINE_SIZE);
+	if (status != EFI_SUCCESS)
+		goto free_cmdline;
+
+	boot_params->hdr.cmd_line_ptr = (u32)((unsigned long)mshv_cmdline);
+	boot_params->ext_cmd_line_ptr = (u32)((unsigned long)mshv_cmdline >> 32);
+	boot_params->hdr.cmdline_size = COMMAND_LINE_SIZE;
+
+	return EFI_SUCCESS;
+
+free_cmdline:
+	efi_bs_call(free_pool, mshv_cmdline);
+	return status;
+}
+
+/*
+ * Prepare for running as root partition with mshv.
+ * - Open the hypervisor loader EFI protocol, used for launching mshv after
+ *   'exit boot services'.
+ * - Get mshv reserved memory ranges from the loader, and populates those
+ *   via a command line parameter 'hyperv_resvd_new'.
+ * If mshv_efi_setup() fails, boot continues as a bare-metal boot.
+ */
+efi_status_t mshv_efi_setup(struct boot_params *boot_params)
+{
+	struct mshv_setup_data *sd_block;
+	efi_memory_desc_t *mem_map;
+	unsigned long map_sz, desc_sz;
+	u64 start, end;
+	struct resource *mshv_range, *prev;
+	struct resource *mshv_reserved;
+	unsigned long mshv_reserved_sz = 0;
+	u32 nr_desc;
+	int i, nr_ranges, max_ranges;
+	efi_status_t status;
+
+	mem_map = NULL;
+	mshv_reserved = NULL;
+
+	status = mshv_efi_init();
+	if (status == EFI_NOT_FOUND) {
+		/*
+		 * If the protocol is not installed
+		 * we are in a standard Linux boot
+		 */
+		return EFI_SUCCESS;
+	}
+
+	/*
+	 * Get mshv memory map to figure out mshv reserved ranges.
+	 */
+
+	map_sz = 0;
+	mshv_get_hv_ranges((void *)&mem_map, &map_sz, &desc_sz);
+
+	/*
+	 * Build an array of kernel 'struct resource' objects that contain mshv
+	 * reserved ranges. This array is populated via a command line parameter
+	 * called 'hyperv_resvd_new'.
+	 */
+
+	status = mshv_realloc_ranges(&mshv_reserved,
+				     &mshv_reserved_sz,
+				MSHV_RESERVED_RANGES_COUNT);
+	if (status != EFI_SUCCESS)
+		mshv_efi_reboot("failed to allocate space for hv ranges with code %d",
+				status);
+
+	max_ranges = MSHV_RESERVED_RANGES_COUNT;
+	mshv_range = mshv_reserved;
+	prev = NULL;
+	nr_desc = map_sz / desc_sz;
+	if (!nr_desc)
+		mshv_efi_reboot("hypervisor loader returned no reserved ranges");
+
+	for (i = 0, nr_ranges = 0; i < nr_desc; i++) {
+		efi_memory_desc_t *d;
+
+		d = efi_memdesc_ptr(mem_map, desc_sz, i);
+
+		/* Merge adjacent ranges */
+		if (prev && ((prev->end + 1) == d->phys_addr)) {
+			prev->end += (d->num_pages << PAGE_SHIFT);
+			continue;
+		}
+
+		mshv_range->name = "Hypervisor Code and Data";
+		mshv_range->flags = IORESOURCE_BUSY | IORESOURCE_SYSTEM_RAM;
+		mshv_range->start = d->phys_addr;
+		mshv_range->end = d->phys_addr + (d->num_pages << PAGE_SHIFT) - 1;
+
+		prev = mshv_range++;
+		nr_ranges++;
+		if (nr_ranges >= max_ranges) {
+			/* Extend the array to accommodate more ranges */
+			max_ranges += MSHV_RESERVED_RANGES_COUNT;
+			status = mshv_realloc_ranges(&mshv_reserved, &mshv_reserved_sz,
+						     max_ranges);
+			if (status != EFI_SUCCESS)
+				mshv_efi_reboot("failed to allocate hv ranges: %d", status);
+
+			prev = &mshv_reserved[nr_ranges - 1];
+			mshv_range = prev + 1;
+		}
+	}
+
+	status = mshv_populate_ranges(boot_params, mem_map, map_sz, desc_sz);
+	if (status != EFI_SUCCESS)
+		mshv_efi_reboot("failed to update command line with code %d",
+				status);
+
+	/* Build an indirect setup_data for each mshv reserved range. */
+	status = efi_bs_call(allocate_pool, EFI_LOADER_DATA,
+			     nr_ranges * sizeof(struct mshv_setup_data),
+				(void **)&sd_block);
+	if (status != EFI_SUCCESS)
+		mshv_efi_reboot("failed to allocate space for hv ranges: error code %d", status);
+
+	memset((void *)sd_block, 0, nr_ranges * sizeof(struct mshv_setup_data));
+	if (!boot_params->hdr.setup_data) {
+		boot_params->hdr.setup_data = (unsigned long)sd_block;
+	} else {
+		struct setup_data *data;
+
+		data = (struct setup_data *)(unsigned long)boot_params->hdr.setup_data;
+		while (data->next)
+			data = (struct setup_data *)(unsigned long)data->next;
+		data->next = (unsigned long)sd_block;
+	}
+
+	for (i = 0; i < nr_ranges; i++) {
+		start = mshv_reserved[i].start;
+		end = mshv_reserved[i].end;
+
+		sd_block[i].sd.type = SETUP_INDIRECT;
+		sd_block[i].sd.len  = sizeof(struct setup_indirect);
+		sd_block[i].sd.next = (__u64)&sd_block[i + 1];
+
+		sd_block[i].si.type = SETUP_MSHV;
+		sd_block[i].si.reserved = 0;
+		sd_block[i].si.len = end - start + 1;
+		sd_block[i].si.addr = start;
+	}
+
+	/*
+	 * Remove the trailing 'next' pointer which is currently
+	 * outside of the struct mshv_setup_data buffer.
+	 */
+
+	sd_block[nr_ranges - 1].sd.next = 0;
+
+	efi_bs_call(free_pool, mem_map);
+	efi_bs_call(free_pool, mshv_reserved);
+
+	return EFI_SUCCESS;
+}
diff --git a/drivers/firmware/efi/libstub/x86-stub.c b/drivers/firmware/efi/libstub/x86-stub.c
index cef32e2c82d8..eab2539488ee 100644
--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -20,6 +20,7 @@
 
 #include "efistub.h"
 #include "x86-stub.h"
+#include "efi-mshv.h"
 
 extern char _bss[], _ebss[];
 
@@ -737,6 +738,7 @@ static efi_status_t exit_boot_func(struct efi_boot_memmap *map,
 				   void *priv)
 {
 	const char *signature;
+	efi_status_t status;
 	struct exit_boot_struct *p = priv;
 
 	signature = efi_is_64bit() ? EFI64_LOADER_SIGNATURE
@@ -751,6 +753,11 @@ static efi_status_t exit_boot_func(struct efi_boot_memmap *map,
 			  &p->efi->efi_memmap, &p->efi->efi_memmap_hi);
 	p->efi->efi_memmap_size		= map->map_size;
 
+	/* Notify hypervisor of efi runtime services pages */
+	status = mshv_set_efi_rt_range(map);
+	if (status != EFI_SUCCESS)
+		return status;
+
 	return EFI_SUCCESS;
 }
 
@@ -918,7 +925,7 @@ void __noreturn efi_stub_entry(efi_handle_t handle,
 	const struct linux_efi_initrd *initrd = NULL;
 	unsigned long kernel_entry;
 	struct setup_header *hdr;
-	efi_status_t status;
+	efi_status_t status, mshv_status;
 
 	efi_system_table = sys_table_arg;
 	/* Check if we were booted by the EFI firmware */
@@ -1011,6 +1018,8 @@ void __noreturn efi_stub_entry(efi_handle_t handle,
 	/* Ask the firmware to clear memory on unclean shutdown */
 	efi_enable_reset_attack_mitigation();
 
+	mshv_status = mshv_efi_setup(boot_params);
+
 	efi_random_get_seed();
 
 	efi_retrieve_eventlog();
@@ -1035,6 +1044,13 @@ void __noreturn efi_stub_entry(efi_handle_t handle,
 	 */
 	sev_enable(boot_params);
 
+	/*
+	 * Launch the hypervisor before switching to 5 level paging.
+	 * The hypervisor does not support being launched with LA57 enabled.
+	 */
+	if (mshv_status == EFI_SUCCESS)
+		mshv_status = mshv_launch();
+
 	efi_5level_switch();
 
 	enter_kernel(kernel_entry, boot_params);
diff --git a/drivers/hv/hv_common.c b/drivers/hv/hv_common.c
index 6b67ac616789..ab301dd602fb 100644
--- a/drivers/hv/hv_common.c
+++ b/drivers/hv/hv_common.c
@@ -26,6 +26,10 @@
 #include <linux/kmsg_dump.h>
 #include <linux/sizes.h>
 #include <linux/slab.h>
+#include <linux/memblock.h>
+#include <linux/crash_dump.h>
+#include <linux/kstrtox.h>
+#include <linux/string.h>
 #include <linux/dma-map-ops.h>
 #include <linux/set_memory.h>
 #include <hyperv/hvhdk.h>
@@ -863,3 +867,81 @@ const char *hv_result_to_string(u64 status)
 	return "Unknown";
 }
 EXPORT_SYMBOL_GPL(hv_result_to_string);
+
+struct resource hv_mshv_res[HV_MAX_RESVD_RANGES];
+u32 ranges_nr;
+
+/*
+ * Parse "hyperv_resvd_new=<size>!<address>,<size>!<address>,...", specifying a
+ * list of memory ranges that are reserved by the loader for the hypervisor.
+ */
+static int __init hv_parse_hyperv_resvd_new(char *arg)
+{
+	int i = 0;
+
+	if (is_kdump_kernel())
+		return 0;
+
+	while (arg && *arg) {
+		unsigned long long region_start, region_sz;
+		char *range, *addr_str;
+
+		if (i >= HV_MAX_RESVD_RANGES) {
+			pr_err("Hyper-V: too many hyperv_resvd_new ranges specified\n");
+			break;
+		}
+
+		/* Each range is "<size>!<address>", ranges separated by ','. */
+		range = strsep(&arg, ",");
+		addr_str = strchr(range, '!');
+		if (!addr_str) {
+			pr_err("Hyper-V: invalid format for hyperv_resvd_new: %s\n", range);
+			break;
+		}
+		*addr_str++ = '\0';
+
+		if (kstrtoull(range, 16, &region_sz) || !region_sz ||
+		    kstrtoull(addr_str, 16, &region_start) || !region_start) {
+			pr_err("Hyper-V: invalid format for hyperv_resvd_new\n");
+			break;
+		}
+
+		memblock_reserve(region_start, region_sz);
+
+		hv_mshv_res[i].name = "Hypervisor Code and Data";
+		hv_mshv_res[i].flags = IORESOURCE_BUSY | IORESOURCE_SYSTEM_RAM;
+		hv_mshv_res[i].start = region_start;
+		hv_mshv_res[i].end = region_start + region_sz - 1;
+
+		++i;
+	}
+
+	ranges_nr = i;
+
+	return 0;
+}
+early_param("hyperv_resvd_new", hv_parse_hyperv_resvd_new);
+
+/*
+ * Log memory ranges that the hypervisor uses. The ranges are marked
+ * by a custom bootloader.
+ */
+void __init hv_dump_mshv_memory(void)
+{
+	u64 start, end;
+	int i;
+
+	for (i = 0; i < ranges_nr; i++) {
+		start = hv_mshv_res[i].start;
+		end = hv_mshv_res[i].end;
+		pr_info("Hyper-V reserve [mem %#018Lx-%#018Lx]\n", start, end);
+	}
+}
+
+void __init hv_mark_resources(void)
+{
+	int i, max = ARRAY_SIZE(hv_mshv_res);
+
+	for (i = 0; i < max && hv_mshv_res[i].end; i++)
+		insert_resource(&iomem_resource, &hv_mshv_res[i]);
+}
diff --git a/include/asm-generic/mshyperv.h b/include/asm-generic/mshyperv.h
index bf601d67cecb..83e0dff5371a 100644
--- a/include/asm-generic/mshyperv.h
+++ b/include/asm-generic/mshyperv.h
@@ -212,6 +212,13 @@ int hv_common_cpu_init(unsigned int cpu);
 int hv_common_cpu_die(unsigned int cpu);
 void hv_identify_partition_type(void);
 
+#define HV_MAX_RESVD_RANGES 32
+extern struct resource hv_mshv_res[HV_MAX_RESVD_RANGES];
+extern u32 ranges_nr;
+
+void __init hv_dump_mshv_memory(void);
+void __init hv_mark_resources(void);
+
 /**
  * hv_cpu_number_to_vp_number() - Map CPU to VP.
  * @cpu_number: CPU number in Linux terms
diff --git a/include/linux/efi.h b/include/linux/efi.h
index ccbc35479684..be3fb83194b9 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -391,6 +391,7 @@ void efi_native_runtime_setup(void);
 #define EFI_LOAD_FILE_PROTOCOL_GUID		EFI_GUID(0x56ec3091, 0x954c, 0x11d2,  0x8e, 0x3f, 0x00, 0xa0, 0xc9, 0x69, 0x72, 0x3b)
 #define EFI_LOAD_FILE2_PROTOCOL_GUID		EFI_GUID(0x4006c0c1, 0xfcb3, 0x403e,  0x99, 0x6d, 0x4a, 0x6c, 0x87, 0x24, 0xe0, 0x6d)
 #define EFI_RT_PROPERTIES_TABLE_GUID		EFI_GUID(0xeb66918a, 0x7eef, 0x402a,  0x84, 0x2e, 0x93, 0x1d, 0x21, 0xc3, 0x8a, 0xe9)
+#define EFI_MSHV_MEDIA_PROTOCOL_GUID		EFI_GUID(0x098d423a, 0x6ca5, 0x4ad4, 0x90, 0xfa, 0x72, 0xc3, 0xce, 0x22, 0xc8, 0xd0)
 #define EFI_DXE_SERVICES_TABLE_GUID		EFI_GUID(0x05ad34ba, 0x6f02, 0x4214,  0x95, 0x2e, 0x4d, 0xa0, 0x39, 0x8e, 0x2b, 0xb9)
 #define EFI_SMBIOS_PROTOCOL_GUID		EFI_GUID(0x03583ff6, 0xcb36, 0x4940,  0x94, 0x7e, 0xb9, 0xb3, 0x9f, 0x4a, 0xfa, 0xf7)
 #define EFI_MEMORY_ATTRIBUTE_PROTOCOL_GUID	EFI_GUID(0xf4560cf6, 0x40ec, 0x4b4a,  0xa1, 0x92, 0xbf, 0x1d, 0x57, 0xd0, 0xb1, 0x89)
-- 
2.43.0

