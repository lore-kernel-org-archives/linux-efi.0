From: Ingo Molnar <mingo@kernel.org>
Subject: [GIT PULL] EFI changes for v4.13
Date: Mon, 3 Jul 2017 10:00:21 +0200
Message-ID: <20170703080021.klqu4h6lvfuedxhg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-efi@vger.kernel.org

Linus,

Please pull the latest efi-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git efi-core-for-linus

   # HEAD: 6c64447ec58b0bac612732303f7ab04562124587 x86/xen/efi: Initialize only the EFI struct members used by Xen

The main changes in this cycle were:

  - Rework the EFI capsule loader to allow for workarounds for non-compliant
    firmware (Ard Biesheuvel)

  - Implement a capsule loader quirk for Quark X102x (Jan Kiszka)

  - Enable SMBIOS/DMI support for the ARM architecture (Ard Biesheuvel)

  - Add CONFIG_EFI_PGT_DUMP=y support for x86-32 and kexec (Sai Praneeth)

  - Fixes for EFI support for Xen dom0 guests running under x86-64 hosts
    (Daniel Kiper)

 Thanks,

	Ingo

------------------>
Ard Biesheuvel (4):
      efi/capsule-loader: Use a cached copy of the capsule header
      efi/capsule-loader: Redirect calls to efi_capsule_setup_info() via weak alias
      efi/capsule-loader: Use page addresses rather than struct page pointers
      efi/arm: Enable DMI/SMBIOS

Daniel Kiper (2):
      efi: Process the MEMATTR table only if EFI_MEMMAP is enabled
      x86/xen/efi: Initialize only the EFI struct members used by Xen

Fabian Frederick (1):
      efi/capsule: Remove NULL test on kmap()

Geliang Tang (1):
      efi/efi_test: Use memdup_user() helper

Jan Kiszka (5):
      efi/capsule: Fix return code on failing kmap/vmap
      efi/capsule: Remove pr_debug() on ENOMEM or EFAULT
      efi/capsule: Clean up pr_err/_info() messages
      efi/capsule: Adjust return type of efi_capsule_setup_info()
      efi/capsule: Add support for Quark security header

Sai Praneeth (1):
      x86/efi: Extend CONFIG_EFI_PGT_DUMP support to x86_32 and kexec as well


 arch/arm/Kconfig                      |  17 +++++
 arch/arm/include/asm/dmi.h            |  19 +++++
 arch/arm64/kernel/efi.c               |  15 ----
 arch/x86/platform/efi/efi.c           |   3 +-
 arch/x86/platform/efi/efi_32.c        |   9 ++-
 arch/x86/platform/efi/efi_64.c        |   5 +-
 arch/x86/platform/efi/quirks.c        | 137 ++++++++++++++++++++++++++++++++++
 arch/x86/xen/efi.c                    |  45 +++--------
 drivers/firmware/efi/Kconfig          |   9 +++
 drivers/firmware/efi/arm-runtime.c    |  16 ++++
 drivers/firmware/efi/capsule-loader.c | 117 ++++++++++++-----------------
 drivers/firmware/efi/capsule.c        |  11 +--
 drivers/firmware/efi/efi.c            |   3 +-
 drivers/firmware/efi/test/efi_test.c  |  11 +--
 include/linux/efi.h                   |  14 +++-
 15 files changed, 295 insertions(+), 136 deletions(-)
 create mode 100644 arch/arm/include/asm/dmi.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 4c1a35f15838..dabcaeb2ee3e 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -2061,6 +2061,23 @@ config EFI
 	  is only useful for kernels that may run on systems that have
 	  UEFI firmware.
 
+config DMI
+	bool "Enable support for SMBIOS (DMI) tables"
+	depends on EFI
+	default y
+	help
+	  This enables SMBIOS/DMI feature for systems.
+
+	  This option is only useful on systems that have UEFI firmware.
+	  However, even with this option, the resultant kernel should
+	  continue to boot on existing non-UEFI platforms.
+
+	  NOTE: This does *NOT* enable or encourage the use of DMI quirks,
+	  i.e., the the practice of identifying the platform via DMI to
+	  decide whether certain workarounds for buggy hardware and/or
+	  firmware need to be enabled. This would require the DMI subsystem
+	  to be enabled much earlier than we do on ARM, which is non-trivial.
+
 endmenu
 
 menu "CPU Power Management"
diff --git a/arch/arm/include/asm/dmi.h b/arch/arm/include/asm/dmi.h
new file mode 100644
index 000000000000..df2d2ff06f5b
--- /dev/null
+++ b/arch/arm/include/asm/dmi.h
@@ -0,0 +1,19 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_DMI_H
+#define __ASM_DMI_H
+
+#include <linux/io.h>
+#include <linux/slab.h>
+
+#define dmi_early_remap(x, l)		memremap(x, l, MEMREMAP_WB)
+#define dmi_early_unmap(x, l)		memunmap(x)
+#define dmi_remap(x, l)			memremap(x, l, MEMREMAP_WB)
+#define dmi_unmap(x)			memunmap(x)
+#define dmi_alloc(l)			kzalloc(l, GFP_KERNEL)
+
+#endif
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 5d17f377d905..82cd07592519 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -11,7 +11,6 @@
  *
  */
 
-#include <linux/dmi.h>
 #include <linux/efi.h>
 #include <linux/init.h>
 
@@ -117,20 +116,6 @@ int __init efi_set_mapping_permissions(struct mm_struct *mm,
 				   set_permissions, md);
 }
 
-static int __init arm64_dmi_init(void)
-{
-	/*
-	 * On arm64, DMI depends on UEFI, and dmi_scan_machine() needs to
-	 * be called early because dmi_id_init(), which is an arch_initcall
-	 * itself, depends on dmi_scan_machine() having been called already.
-	 */
-	dmi_scan_machine();
-	if (dmi_available)
-		dmi_set_dump_stack_arch_desc();
-	return 0;
-}
-core_initcall(arm64_dmi_init);
-
 /*
  * UpdateCapsule() depends on the system being shutdown via
  * ResetSystem().
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 43b96f5f78ba..f084d8718ac4 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -1014,7 +1014,6 @@ static void __init __efi_enter_virtual_mode(void)
 	 * necessary relocation fixups for the new virtual addresses.
 	 */
 	efi_runtime_update_mappings();
-	efi_dump_pagetable();
 
 	/* clean DUMMY object */
 	efi_delete_dummy_variable();
@@ -1029,6 +1028,8 @@ void __init efi_enter_virtual_mode(void)
 		kexec_enter_virtual_mode();
 	else
 		__efi_enter_virtual_mode();
+
+	efi_dump_pagetable();
 }
 
 /*
diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
index 3481268da3d0..52f7faa1538f 100644
--- a/arch/x86/platform/efi/efi_32.c
+++ b/arch/x86/platform/efi/efi_32.c
@@ -44,7 +44,14 @@ int __init efi_alloc_page_tables(void)
 }
 
 void efi_sync_low_kernel_mappings(void) {}
-void __init efi_dump_pagetable(void) {}
+
+void __init efi_dump_pagetable(void)
+{
+#ifdef CONFIG_EFI_PGT_DUMP
+	ptdump_walk_pgd_level(NULL, swapper_pg_dir);
+#endif
+}
+
 int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 {
 	return 0;
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index eb8dff15a7f6..8ff1f95627f9 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -589,7 +589,10 @@ void __init efi_runtime_update_mappings(void)
 void __init efi_dump_pagetable(void)
 {
 #ifdef CONFIG_EFI_PGT_DUMP
-	ptdump_walk_pgd_level(NULL, efi_pgd);
+	if (efi_enabled(EFI_OLD_MEMMAP))
+		ptdump_walk_pgd_level(NULL, swapper_pg_dir);
+	else
+		ptdump_walk_pgd_level(NULL, efi_pgd);
 #endif
 }
 
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index e0cf95a83f3f..8a99a2e96537 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -15,12 +15,66 @@
 #include <asm/e820/api.h>
 #include <asm/efi.h>
 #include <asm/uv/uv.h>
+#include <asm/cpu_device_id.h>
 
 #define EFI_MIN_RESERVE 5120
 
 #define EFI_DUMMY_GUID \
 	EFI_GUID(0x4424ac57, 0xbe4b, 0x47dd, 0x9e, 0x97, 0xed, 0x50, 0xf0, 0x9f, 0x92, 0xa9)
 
+#define QUARK_CSH_SIGNATURE		0x5f435348	/* _CSH */
+#define QUARK_SECURITY_HEADER_SIZE	0x400
+
+/*
+ * Header prepended to the standard EFI capsule on Quark systems the are based
+ * on Intel firmware BSP.
+ * @csh_signature:	Unique identifier to sanity check signed module
+ * 			presence ("_CSH").
+ * @version:		Current version of CSH used. Should be one for Quark A0.
+ * @modulesize:		Size of the entire module including the module header
+ * 			and payload.
+ * @security_version_number_index: Index of SVN to use for validation of signed
+ * 			module.
+ * @security_version_number: Used to prevent against roll back of modules.
+ * @rsvd_module_id:	Currently unused for Clanton (Quark).
+ * @rsvd_module_vendor:	Vendor Identifier. For Intel products value is
+ * 			0x00008086.
+ * @rsvd_date:		BCD representation of build date as yyyymmdd, where
+ * 			yyyy=4 digit year, mm=1-12, dd=1-31.
+ * @headersize:		Total length of the header including including any
+ * 			padding optionally added by the signing tool.
+ * @hash_algo:		What Hash is used in the module signing.
+ * @cryp_algo:		What Crypto is used in the module signing.
+ * @keysize:		Total length of the key data including including any
+ * 			padding optionally added by the signing tool.
+ * @signaturesize:	Total length of the signature including including any
+ * 			padding optionally added by the signing tool.
+ * @rsvd_next_header:	32-bit pointer to the next Secure Boot Module in the
+ * 			chain, if there is a next header.
+ * @rsvd:		Reserved, padding structure to required size.
+ *
+ * See also QuartSecurityHeader_t in
+ * Quark_EDKII_v1.2.1.1/QuarkPlatformPkg/Include/QuarkBootRom.h
+ * from https://downloadcenter.intel.com/download/23197/Intel-Quark-SoC-X1000-Board-Support-Package-BSP
+ */
+struct quark_security_header {
+	u32 csh_signature;
+	u32 version;
+	u32 modulesize;
+	u32 security_version_number_index;
+	u32 security_version_number;
+	u32 rsvd_module_id;
+	u32 rsvd_module_vendor;
+	u32 rsvd_date;
+	u32 headersize;
+	u32 hash_algo;
+	u32 cryp_algo;
+	u32 keysize;
+	u32 signaturesize;
+	u32 rsvd_next_header;
+	u32 rsvd[2];
+};
+
 static efi_char16_t efi_dummy_name[6] = { 'D', 'U', 'M', 'M', 'Y', 0 };
 
 static bool efi_no_storage_paranoia;
@@ -504,3 +558,86 @@ bool efi_poweroff_required(void)
 {
 	return acpi_gbl_reduced_hardware || acpi_no_s5;
 }
+
+#ifdef CONFIG_EFI_CAPSULE_QUIRK_QUARK_CSH
+
+static int qrk_capsule_setup_info(struct capsule_info *cap_info, void **pkbuff,
+				  size_t hdr_bytes)
+{
+	struct quark_security_header *csh = *pkbuff;
+
+	/* Only process data block that is larger than the security header */
+	if (hdr_bytes < sizeof(struct quark_security_header))
+		return 0;
+
+	if (csh->csh_signature != QUARK_CSH_SIGNATURE ||
+	    csh->headersize != QUARK_SECURITY_HEADER_SIZE)
+		return 1;
+
+	/* Only process data block if EFI header is included */
+	if (hdr_bytes < QUARK_SECURITY_HEADER_SIZE +
+			sizeof(efi_capsule_header_t))
+		return 0;
+
+	pr_debug("Quark security header detected\n");
+
+	if (csh->rsvd_next_header != 0) {
+		pr_err("multiple Quark security headers not supported\n");
+		return -EINVAL;
+	}
+
+	*pkbuff += csh->headersize;
+	cap_info->total_size = csh->headersize;
+
+	/*
+	 * Update the first page pointer to skip over the CSH header.
+	 */
+	cap_info->pages[0] += csh->headersize;
+
+	return 1;
+}
+
+#define ICPU(family, model, quirk_handler) \
+	{ X86_VENDOR_INTEL, family, model, X86_FEATURE_ANY, \
+	  (unsigned long)&quirk_handler }
+
+static const struct x86_cpu_id efi_capsule_quirk_ids[] = {
+	ICPU(5, 9, qrk_capsule_setup_info),	/* Intel Quark X1000 */
+	{ }
+};
+
+int efi_capsule_setup_info(struct capsule_info *cap_info, void *kbuff,
+			   size_t hdr_bytes)
+{
+	int (*quirk_handler)(struct capsule_info *, void **, size_t);
+	const struct x86_cpu_id *id;
+	int ret;
+
+	if (hdr_bytes < sizeof(efi_capsule_header_t))
+		return 0;
+
+	cap_info->total_size = 0;
+
+	id = x86_match_cpu(efi_capsule_quirk_ids);
+	if (id) {
+		/*
+		 * The quirk handler is supposed to return
+		 *  - a value > 0 if the setup should continue, after advancing
+		 *    kbuff as needed
+		 *  - 0 if not enough hdr_bytes are available yet
+		 *  - a negative error code otherwise
+		 */
+		quirk_handler = (typeof(quirk_handler))id->driver_data;
+		ret = quirk_handler(cap_info, &kbuff, hdr_bytes);
+		if (ret <= 0)
+			return ret;
+	}
+
+	memcpy(&cap_info->header, kbuff, sizeof(cap_info->header));
+
+	cap_info->total_size += cap_info->header.imagesize;
+
+	return __efi_capsule_setup_info(cap_info);
+}
+
+#endif
diff --git a/arch/x86/xen/efi.c b/arch/x86/xen/efi.c
index 30bb2e80cfe7..a18703be9ead 100644
--- a/arch/x86/xen/efi.c
+++ b/arch/x86/xen/efi.c
@@ -54,38 +54,6 @@ static efi_system_table_t efi_systab_xen __initdata = {
 	.tables		= EFI_INVALID_TABLE_ADDR  /* Initialized later. */
 };
 
-static const struct efi efi_xen __initconst = {
-	.systab                   = NULL, /* Initialized later. */
-	.runtime_version	  = 0,    /* Initialized later. */
-	.mps                      = EFI_INVALID_TABLE_ADDR,
-	.acpi                     = EFI_INVALID_TABLE_ADDR,
-	.acpi20                   = EFI_INVALID_TABLE_ADDR,
-	.smbios                   = EFI_INVALID_TABLE_ADDR,
-	.smbios3                  = EFI_INVALID_TABLE_ADDR,
-	.sal_systab               = EFI_INVALID_TABLE_ADDR,
-	.boot_info                = EFI_INVALID_TABLE_ADDR,
-	.hcdp                     = EFI_INVALID_TABLE_ADDR,
-	.uga                      = EFI_INVALID_TABLE_ADDR,
-	.uv_systab                = EFI_INVALID_TABLE_ADDR,
-	.fw_vendor                = EFI_INVALID_TABLE_ADDR,
-	.runtime                  = EFI_INVALID_TABLE_ADDR,
-	.config_table             = EFI_INVALID_TABLE_ADDR,
-	.get_time                 = xen_efi_get_time,
-	.set_time                 = xen_efi_set_time,
-	.get_wakeup_time          = xen_efi_get_wakeup_time,
-	.set_wakeup_time          = xen_efi_set_wakeup_time,
-	.get_variable             = xen_efi_get_variable,
-	.get_next_variable        = xen_efi_get_next_variable,
-	.set_variable             = xen_efi_set_variable,
-	.query_variable_info      = xen_efi_query_variable_info,
-	.update_capsule           = xen_efi_update_capsule,
-	.query_capsule_caps       = xen_efi_query_capsule_caps,
-	.get_next_high_mono_count = xen_efi_get_next_high_mono_count,
-	.reset_system             = xen_efi_reset_system,
-	.set_virtual_address_map  = NULL, /* Not used under Xen. */
-	.flags			  = 0     /* Initialized later. */
-};
-
 static efi_system_table_t __init *xen_efi_probe(void)
 {
 	struct xen_platform_op op = {
@@ -102,7 +70,18 @@ static efi_system_table_t __init *xen_efi_probe(void)
 
 	/* Here we know that Xen runs on EFI platform. */
 
-	efi = efi_xen;
+	efi.get_time                 = xen_efi_get_time;
+	efi.set_time                 = xen_efi_set_time;
+	efi.get_wakeup_time          = xen_efi_get_wakeup_time;
+	efi.set_wakeup_time          = xen_efi_set_wakeup_time;
+	efi.get_variable             = xen_efi_get_variable;
+	efi.get_next_variable        = xen_efi_get_next_variable;
+	efi.set_variable             = xen_efi_set_variable;
+	efi.query_variable_info      = xen_efi_query_variable_info;
+	efi.update_capsule           = xen_efi_update_capsule;
+	efi.query_capsule_caps       = xen_efi_query_capsule_caps;
+	efi.get_next_high_mono_count = xen_efi_get_next_high_mono_count;
+	efi.reset_system             = xen_efi_reset_system;
 
 	efi_systab_xen.tables = info->cfg.addr;
 	efi_systab_xen.nr_tables = info->cfg.nent;
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 2e78b0b96d74..394db40ed374 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -112,6 +112,15 @@ config EFI_CAPSULE_LOADER
 
 	  Most users should say N.
 
+config EFI_CAPSULE_QUIRK_QUARK_CSH
+	boolean "Add support for Quark capsules with non-standard headers"
+	depends on X86 && !64BIT
+	select EFI_CAPSULE_LOADER
+	default y
+	help
+	  Add support for processing Quark X1000 EFI capsules, whose header
+	  layout deviates from the layout mandated by the UEFI specification.
+
 config EFI_TEST
 	tristate "EFI Runtime Service Tests Support"
 	depends on EFI
diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 974c5a31a005..1cc41c3d6315 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -11,6 +11,7 @@
  *
  */
 
+#include <linux/dmi.h>
 #include <linux/efi.h>
 #include <linux/io.h>
 #include <linux/memblock.h>
@@ -166,3 +167,18 @@ void efi_virtmap_unload(void)
 	efi_set_pgd(current->active_mm);
 	preempt_enable();
 }
+
+
+static int __init arm_dmi_init(void)
+{
+	/*
+	 * On arm64/ARM, DMI depends on UEFI, and dmi_scan_machine() needs to
+	 * be called early because dmi_id_init(), which is an arch_initcall
+	 * itself, depends on dmi_scan_machine() having been called already.
+	 */
+	dmi_scan_machine();
+	if (dmi_available)
+		dmi_set_dump_stack_arch_desc();
+	return 0;
+}
+core_initcall(arm_dmi_init);
diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index 9ae6c116c474..ec8ac5c4dd84 100644
--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -20,15 +20,9 @@
 
 #define NO_FURTHER_WRITE_ACTION -1
 
-struct capsule_info {
-	bool		header_obtained;
-	int		reset_type;
-	long		index;
-	size_t		count;
-	size_t		total_size;
-	struct page	**pages;
-	size_t		page_bytes_remain;
-};
+#ifndef phys_to_page
+#define phys_to_page(x)		pfn_to_page((x) >> PAGE_SHIFT)
+#endif
 
 /**
  * efi_free_all_buff_pages - free all previous allocated buffer pages
@@ -41,65 +35,70 @@ struct capsule_info {
 static void efi_free_all_buff_pages(struct capsule_info *cap_info)
 {
 	while (cap_info->index > 0)
-		__free_page(cap_info->pages[--cap_info->index]);
+		__free_page(phys_to_page(cap_info->pages[--cap_info->index]));
 
 	cap_info->index = NO_FURTHER_WRITE_ACTION;
 }
 
-/**
- * efi_capsule_setup_info - obtain the efi capsule header in the binary and
- *			    setup capsule_info structure
- * @cap_info: pointer to current instance of capsule_info structure
- * @kbuff: a mapped first page buffer pointer
- * @hdr_bytes: the total received number of bytes for efi header
- **/
-static ssize_t efi_capsule_setup_info(struct capsule_info *cap_info,
-				      void *kbuff, size_t hdr_bytes)
+int __efi_capsule_setup_info(struct capsule_info *cap_info)
 {
-	efi_capsule_header_t *cap_hdr;
 	size_t pages_needed;
 	int ret;
 	void *temp_page;
 
-	/* Only process data block that is larger than efi header size */
-	if (hdr_bytes < sizeof(efi_capsule_header_t))
-		return 0;
-
-	/* Reset back to the correct offset of header */
-	cap_hdr = kbuff - cap_info->count;
-	pages_needed = ALIGN(cap_hdr->imagesize, PAGE_SIZE) >> PAGE_SHIFT;
+	pages_needed = ALIGN(cap_info->total_size, PAGE_SIZE) / PAGE_SIZE;
 
 	if (pages_needed == 0) {
-		pr_err("%s: pages count invalid\n", __func__);
+		pr_err("invalid capsule size");
 		return -EINVAL;
 	}
 
 	/* Check if the capsule binary supported */
-	ret = efi_capsule_supported(cap_hdr->guid, cap_hdr->flags,
-				    cap_hdr->imagesize,
+	ret = efi_capsule_supported(cap_info->header.guid,
+				    cap_info->header.flags,
+				    cap_info->header.imagesize,
 				    &cap_info->reset_type);
 	if (ret) {
-		pr_err("%s: efi_capsule_supported() failed\n",
-		       __func__);
+		pr_err("capsule not supported\n");
 		return ret;
 	}
 
-	cap_info->total_size = cap_hdr->imagesize;
 	temp_page = krealloc(cap_info->pages,
 			     pages_needed * sizeof(void *),
 			     GFP_KERNEL | __GFP_ZERO);
-	if (!temp_page) {
-		pr_debug("%s: krealloc() failed\n", __func__);
+	if (!temp_page)
 		return -ENOMEM;
-	}
 
 	cap_info->pages = temp_page;
-	cap_info->header_obtained = true;
 
 	return 0;
 }
 
 /**
+ * efi_capsule_setup_info - obtain the efi capsule header in the binary and
+ *			    setup capsule_info structure
+ * @cap_info: pointer to current instance of capsule_info structure
+ * @kbuff: a mapped first page buffer pointer
+ * @hdr_bytes: the total received number of bytes for efi header
+ *
+ * Platforms with non-standard capsule update mechanisms can override
+ * this __weak function so they can perform any required capsule
+ * image munging. See quark_quirk_function() for an example.
+ **/
+int __weak efi_capsule_setup_info(struct capsule_info *cap_info, void *kbuff,
+				  size_t hdr_bytes)
+{
+	/* Only process data block that is larger than efi header size */
+	if (hdr_bytes < sizeof(efi_capsule_header_t))
+		return 0;
+
+	memcpy(&cap_info->header, kbuff, sizeof(cap_info->header));
+	cap_info->total_size = cap_info->header.imagesize;
+
+	return __efi_capsule_setup_info(cap_info);
+}
+
+/**
  * efi_capsule_submit_update - invoke the efi_capsule_update API once binary
  *			       upload done
  * @cap_info: pointer to current instance of capsule_info structure
@@ -107,26 +106,17 @@ static ssize_t efi_capsule_setup_info(struct capsule_info *cap_info,
 static ssize_t efi_capsule_submit_update(struct capsule_info *cap_info)
 {
 	int ret;
-	void *cap_hdr_temp;
-
-	cap_hdr_temp = vmap(cap_info->pages, cap_info->index,
-			VM_MAP, PAGE_KERNEL);
-	if (!cap_hdr_temp) {
-		pr_debug("%s: vmap() failed\n", __func__);
-		return -EFAULT;
-	}
 
-	ret = efi_capsule_update(cap_hdr_temp, cap_info->pages);
-	vunmap(cap_hdr_temp);
+	ret = efi_capsule_update(&cap_info->header, cap_info->pages);
 	if (ret) {
-		pr_err("%s: efi_capsule_update() failed\n", __func__);
+		pr_err("capsule update failed\n");
 		return ret;
 	}
 
 	/* Indicate capsule binary uploading is done */
 	cap_info->index = NO_FURTHER_WRITE_ACTION;
-	pr_info("%s: Successfully upload capsule file with reboot type '%s'\n",
-		__func__, !cap_info->reset_type ? "RESET_COLD" :
+	pr_info("Successfully upload capsule file with reboot type '%s'\n",
+		!cap_info->reset_type ? "RESET_COLD" :
 		cap_info->reset_type == 1 ? "RESET_WARM" :
 		"RESET_SHUTDOWN");
 	return 0;
@@ -171,37 +161,30 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
 	if (!cap_info->page_bytes_remain) {
 		page = alloc_page(GFP_KERNEL);
 		if (!page) {
-			pr_debug("%s: alloc_page() failed\n", __func__);
 			ret = -ENOMEM;
 			goto failed;
 		}
 
-		cap_info->pages[cap_info->index++] = page;
+		cap_info->pages[cap_info->index++] = page_to_phys(page);
 		cap_info->page_bytes_remain = PAGE_SIZE;
+	} else {
+		page = phys_to_page(cap_info->pages[cap_info->index - 1]);
 	}
 
-	page = cap_info->pages[cap_info->index - 1];
-
 	kbuff = kmap(page);
-	if (!kbuff) {
-		pr_debug("%s: kmap() failed\n", __func__);
-		ret = -EFAULT;
-		goto failed;
-	}
 	kbuff += PAGE_SIZE - cap_info->page_bytes_remain;
 
 	/* Copy capsule binary data from user space to kernel space buffer */
 	write_byte = min_t(size_t, count, cap_info->page_bytes_remain);
 	if (copy_from_user(kbuff, buff, write_byte)) {
-		pr_debug("%s: copy_from_user() failed\n", __func__);
 		ret = -EFAULT;
 		goto fail_unmap;
 	}
 	cap_info->page_bytes_remain -= write_byte;
 
 	/* Setup capsule binary info structure */
-	if (!cap_info->header_obtained) {
-		ret = efi_capsule_setup_info(cap_info, kbuff,
+	if (cap_info->header.headersize == 0) {
+		ret = efi_capsule_setup_info(cap_info, kbuff - cap_info->count,
 					     cap_info->count + write_byte);
 		if (ret)
 			goto fail_unmap;
@@ -211,11 +194,10 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
 	kunmap(page);
 
 	/* Submit the full binary to efi_capsule_update() API */
-	if (cap_info->header_obtained &&
+	if (cap_info->header.headersize > 0 &&
 	    cap_info->count >= cap_info->total_size) {
 		if (cap_info->count > cap_info->total_size) {
-			pr_err("%s: upload size exceeded header defined size\n",
-			       __func__);
+			pr_err("capsule upload size exceeded header defined size\n");
 			ret = -EINVAL;
 			goto failed;
 		}
@@ -249,7 +231,7 @@ static int efi_capsule_flush(struct file *file, fl_owner_t id)
 	struct capsule_info *cap_info = file->private_data;
 
 	if (cap_info->index > 0) {
-		pr_err("%s: capsule upload not complete\n", __func__);
+		pr_err("capsule upload not complete\n");
 		efi_free_all_buff_pages(cap_info);
 		ret = -ECANCELED;
 	}
@@ -328,8 +310,7 @@ static int __init efi_capsule_loader_init(void)
 
 	ret = misc_register(&efi_capsule_misc);
 	if (ret)
-		pr_err("%s: Failed to register misc char file note\n",
-		       __func__);
+		pr_err("Unable to register capsule loader device\n");
 
 	return ret;
 }
diff --git a/drivers/firmware/efi/capsule.c b/drivers/firmware/efi/capsule.c
index 6eedff45e6d7..901b9306bf94 100644
--- a/drivers/firmware/efi/capsule.c
+++ b/drivers/firmware/efi/capsule.c
@@ -214,7 +214,7 @@ efi_capsule_update_locked(efi_capsule_header_t *capsule,
  *
  * Return 0 on success, a converted EFI status code on failure.
  */
-int efi_capsule_update(efi_capsule_header_t *capsule, struct page **pages)
+int efi_capsule_update(efi_capsule_header_t *capsule, phys_addr_t *pages)
 {
 	u32 imagesize = capsule->imagesize;
 	efi_guid_t guid = capsule->guid;
@@ -247,16 +247,13 @@ int efi_capsule_update(efi_capsule_header_t *capsule, struct page **pages)
 		efi_capsule_block_desc_t *sglist;
 
 		sglist = kmap(sg_pages[i]);
-		if (!sglist) {
-			rv = -ENOMEM;
-			goto out;
-		}
 
 		for (j = 0; j < SGLIST_PER_PAGE && count > 0; j++) {
-			u64 sz = min_t(u64, imagesize, PAGE_SIZE);
+			u64 sz = min_t(u64, imagesize,
+				       PAGE_SIZE - (u64)*pages % PAGE_SIZE);
 
 			sglist[j].length = sz;
-			sglist[j].data = page_to_phys(*pages++);
+			sglist[j].data = *pages++;
 
 			imagesize -= sz;
 			count--;
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index b372aad3b449..045d6d311bde 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -528,7 +528,8 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
 		}
 	}
 
-	efi_memattr_init();
+	if (efi_enabled(EFI_MEMMAP))
+		efi_memattr_init();
 
 	/* Parse the EFI Properties table if it exists */
 	if (efi.properties_table != EFI_INVALID_TABLE_ADDR) {
diff --git a/drivers/firmware/efi/test/efi_test.c b/drivers/firmware/efi/test/efi_test.c
index 8cd578f62059..08129b7b80ab 100644
--- a/drivers/firmware/efi/test/efi_test.c
+++ b/drivers/firmware/efi/test/efi_test.c
@@ -71,18 +71,13 @@ copy_ucs2_from_user_len(efi_char16_t **dst, efi_char16_t __user *src,
 	if (!access_ok(VERIFY_READ, src, 1))
 		return -EFAULT;
 
-	buf = kmalloc(len, GFP_KERNEL);
-	if (!buf) {
+	buf = memdup_user(src, len);
+	if (IS_ERR(buf)) {
 		*dst = NULL;
-		return -ENOMEM;
+		return PTR_ERR(buf);
 	}
 	*dst = buf;
 
-	if (copy_from_user(*dst, src, len)) {
-		kfree(buf);
-		return -EFAULT;
-	}
-
 	return 0;
 }
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index ec36f42a2add..8269bcb8ccf7 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -137,6 +137,18 @@ struct efi_boot_memmap {
 #define EFI_CAPSULE_POPULATE_SYSTEM_TABLE	0x00020000
 #define EFI_CAPSULE_INITIATE_RESET		0x00040000
 
+struct capsule_info {
+	efi_capsule_header_t	header;
+	int			reset_type;
+	long			index;
+	size_t			count;
+	size_t			total_size;
+	phys_addr_t		*pages;
+	size_t			page_bytes_remain;
+};
+
+int __efi_capsule_setup_info(struct capsule_info *cap_info);
+
 /*
  * Allocation types for calls to boottime->allocate_pages.
  */
@@ -1403,7 +1415,7 @@ extern int efi_capsule_supported(efi_guid_t guid, u32 flags,
 				 size_t size, int *reset);
 
 extern int efi_capsule_update(efi_capsule_header_t *capsule,
-			      struct page **pages);
+			      phys_addr_t *pages);
 
 #ifdef CONFIG_EFI_RUNTIME_MAP
 int efi_runtime_map_init(struct kobject *);
