From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] EFI changes for v4.12
Date: Mon, 1 May 2017 12:04:00 +0200
Message-ID: <20170501100359.zydv2peyolmw6p6a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Linus,

Please pull the latest efi-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git efi-core-for-linus

   # HEAD: 197decefdb79d6f1350ba0316ce26ba737372d0c efi/libstub/arm: Don't use TASK_SIZE when randomizing the RT space

The main changes in this cycle were:

  - Move BGRT handling to drivers/acpi so it can be shared between x86 and ARM

  - Bring the EFI stub's initrd and FDT allocation logic in line with
    the latest changes to the arm64 boot protocol

  - Improvements and fixes to the EFI stub's command line parsing routines

  - Randomize the virtual mapping of the UEFI runtime services on ARM/arm64

  - ... and other misc enhancements, cleanups and fixes.

 Thanks,

	Ingo

------------------>
Ard Biesheuvel (8):
      efi/arm-stub: Correct FDT and initrd allocation rules for arm64
      efi/arm-stub: Round up FDT allocation to mapping size
      efi/arm32-stub: Allow boot-time allocations in the vmlinux region
      efi/libstub: Fix harmless command line parsing bug
      efi/libstub: Unify command line param parsing
      efi/libstub/arm/arm64: Disable debug prints on 'quiet' cmdline arg
      ef/libstub/arm/arm64: Randomize the base of the UEFI rt services region
      efi/libstub/arm: Don't use TASK_SIZE when randomizing the RT space

Baoquan He (1):
      x86/efi: Clean up a minor mistake in comment

Bhupesh Sharma (2):
      x86/efi/bgrt: Move efi-bgrt handling out of arch/x86
      efi/bgrt: Enable ACPI BGRT handling on arm64

Evgeny Kalugin (1):
      efi/pstore: Return error code (if any) from efi_pstore_write()


 arch/arm/include/asm/efi.h                         |  14 +-
 arch/arm64/include/asm/efi.h                       |  24 +++-
 arch/arm64/kernel/acpi.c                           |   3 +
 arch/x86/kernel/acpi/boot.c                        |   6 -
 arch/x86/platform/efi/Makefile                     |   1 -
 arch/x86/platform/efi/efi_64.c                     |   2 +-
 drivers/acpi/Kconfig                               |   2 +-
 drivers/acpi/bgrt.c                                |   6 +
 drivers/firmware/efi/Makefile                      |   1 +
 .../platform => drivers/firmware}/efi/efi-bgrt.c   |   0
 drivers/firmware/efi/efi-pstore.c                  |   6 +-
 drivers/firmware/efi/libstub/arm-stub.c            |  87 +++++++-----
 drivers/firmware/efi/libstub/arm32-stub.c          | 150 ++++++++++++++++++---
 drivers/firmware/efi/libstub/arm64-stub.c          |   4 +-
 drivers/firmware/efi/libstub/efi-stub-helper.c     |  32 +++--
 drivers/firmware/efi/libstub/efistub.h             |   9 ++
 drivers/firmware/efi/libstub/fdt.c                 |  57 ++++----
 drivers/firmware/efi/libstub/secureboot.c          |   2 +
 include/linux/efi-bgrt.h                           |   5 +
 include/linux/efi.h                                |   5 +-
 20 files changed, 299 insertions(+), 117 deletions(-)
 rename {arch/x86/platform => drivers/firmware}/efi/efi-bgrt.c (100%)

diff --git a/arch/arm/include/asm/efi.h b/arch/arm/include/asm/efi.h
index e4e6a9d6a825..17f1f1a814ff 100644
--- a/arch/arm/include/asm/efi.h
+++ b/arch/arm/include/asm/efi.h
@@ -85,6 +85,18 @@ static inline void efifb_setup_from_dmi(struct screen_info *si, const char *opt)
  */
 #define ZIMAGE_OFFSET_LIMIT	SZ_128M
 #define MIN_ZIMAGE_OFFSET	MAX_UNCOMP_KERNEL_SIZE
-#define MAX_FDT_OFFSET		ZIMAGE_OFFSET_LIMIT
+
+/* on ARM, the FDT should be located in the first 128 MB of RAM */
+static inline unsigned long efi_get_max_fdt_addr(unsigned long dram_base)
+{
+	return dram_base + ZIMAGE_OFFSET_LIMIT;
+}
+
+/* on ARM, the initrd should be loaded in a lowmem region */
+static inline unsigned long efi_get_max_initrd_addr(unsigned long dram_base,
+						    unsigned long image_addr)
+{
+	return dram_base + SZ_512M;
+}
 
 #endif /* _ASM_ARM_EFI_H */
diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index e7445281e534..8f3043aba873 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_EFI_H
 #define _ASM_EFI_H
 
+#include <asm/boot.h>
 #include <asm/cpufeature.h>
 #include <asm/io.h>
 #include <asm/mmu_context.h>
@@ -46,7 +47,28 @@ int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
  * 2MiB so we know it won't cross a 2MiB boundary.
  */
 #define EFI_FDT_ALIGN	SZ_2M   /* used by allocate_new_fdt_and_exit_boot() */
-#define MAX_FDT_OFFSET	SZ_512M
+
+/* on arm64, the FDT may be located anywhere in system RAM */
+static inline unsigned long efi_get_max_fdt_addr(unsigned long dram_base)
+{
+	return ULONG_MAX;
+}
+
+/*
+ * On arm64, we have to ensure that the initrd ends up in the linear region,
+ * which is a 1 GB aligned region of size '1UL << (VA_BITS - 1)' that is
+ * guaranteed to cover the kernel Image.
+ *
+ * Since the EFI stub is part of the kernel Image, we can relax the
+ * usual requirements in Documentation/arm64/booting.txt, which still
+ * apply to other bootloaders, and are required for some kernel
+ * configurations.
+ */
+static inline unsigned long efi_get_max_initrd_addr(unsigned long dram_base,
+						    unsigned long image_addr)
+{
+	return (image_addr & ~(SZ_1G - 1UL)) + (1UL << (VA_BITS - 1));
+}
 
 #define efi_call_early(f, ...)		sys_table_arg->boottime->f(__VA_ARGS__)
 #define __efi_call_early(f, ...)	f(__VA_ARGS__)
diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
index 64d9cbd61678..e25c11e727fe 100644
--- a/arch/arm64/kernel/acpi.c
+++ b/arch/arm64/kernel/acpi.c
@@ -18,6 +18,7 @@
 #include <linux/acpi.h>
 #include <linux/bootmem.h>
 #include <linux/cpumask.h>
+#include <linux/efi-bgrt.h>
 #include <linux/init.h>
 #include <linux/irq.h>
 #include <linux/irqdomain.h>
@@ -233,6 +234,8 @@ void __init acpi_boot_table_init(void)
 			early_init_dt_scan_chosen_stdout();
 	} else {
 		parse_spcr(earlycon_init_is_deferred);
+		if (IS_ENABLED(CONFIG_ACPI_BGRT))
+			acpi_table_parse(ACPI_SIG_BGRT, acpi_parse_bgrt);
 	}
 }
 
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index b2879cc23db4..70854988a963 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -1564,12 +1564,6 @@ int __init early_acpi_boot_init(void)
 	return 0;
 }
 
-static int __init acpi_parse_bgrt(struct acpi_table_header *table)
-{
-	efi_bgrt_init(table);
-	return 0;
-}
-
 int __init acpi_boot_init(void)
 {
 	/* those are executed after early-quirks are executed */
diff --git a/arch/x86/platform/efi/Makefile b/arch/x86/platform/efi/Makefile
index 066619b0700c..f1d83b34c329 100644
--- a/arch/x86/platform/efi/Makefile
+++ b/arch/x86/platform/efi/Makefile
@@ -1,6 +1,5 @@
 OBJECT_FILES_NON_STANDARD_efi_thunk_$(BITS).o := y
 
 obj-$(CONFIG_EFI) 		+= quirks.o efi.o efi_$(BITS).o efi_stub_$(BITS).o
-obj-$(CONFIG_ACPI_BGRT) += efi-bgrt.o
 obj-$(CONFIG_EARLY_PRINTK_EFI)	+= early_printk.o
 obj-$(CONFIG_EFI_MIXED)		+= efi_thunk_$(BITS).o
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index a4695da42d77..6cbf9e036aa8 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -47,7 +47,7 @@
 #include <asm/pgalloc.h>
 
 /*
- * We allocate runtime services regions bottom-up, starting from -4G, i.e.
+ * We allocate runtime services regions top-down, starting from -4G, i.e.
  * 0xffff_ffff_0000_0000 and limit EFI VA mapping space to 64G.
  */
 static u64 efi_va = EFI_VA_START;
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 83e5f7e1a20d..dad02c0f21b9 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -440,7 +440,7 @@ config ACPI_CUSTOM_METHOD
 
 config ACPI_BGRT
 	bool "Boottime Graphics Resource Table support"
-	depends on EFI && X86
+	depends on EFI && (X86 || ARM64)
         help
 	  This driver adds support for exposing the ACPI Boottime Graphics
 	  Resource Table, which allows the operating system to obtain
diff --git a/drivers/acpi/bgrt.c b/drivers/acpi/bgrt.c
index ca28aa572aa9..df1c629205e7 100644
--- a/drivers/acpi/bgrt.c
+++ b/drivers/acpi/bgrt.c
@@ -81,6 +81,12 @@ static struct attribute_group bgrt_attribute_group = {
 	.bin_attrs = bgrt_bin_attributes,
 };
 
+int __init acpi_parse_bgrt(struct acpi_table_header *table)
+{
+	efi_bgrt_init(table);
+	return 0;
+}
+
 static int __init bgrt_init(void)
 {
 	int ret;
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index ad67342313ed..0329d319d89a 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -9,6 +9,7 @@
 #
 KASAN_SANITIZE_runtime-wrappers.o	:= n
 
+obj-$(CONFIG_ACPI_BGRT) 		+= efi-bgrt.o
 obj-$(CONFIG_EFI)			+= efi.o vars.o reboot.o memattr.o
 obj-$(CONFIG_EFI)			+= capsule.o memmap.o
 obj-$(CONFIG_EFI_VARS)			+= efivars.o
diff --git a/arch/x86/platform/efi/efi-bgrt.c b/drivers/firmware/efi/efi-bgrt.c
similarity index 100%
rename from arch/x86/platform/efi/efi-bgrt.c
rename to drivers/firmware/efi/efi-bgrt.c
diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index f402ba2eed46..6b5acefce6b3 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -274,9 +274,9 @@ static int efi_pstore_write(enum pstore_type_id type,
 	for (i = 0; i < DUMP_NAME_LEN; i++)
 		efi_name[i] = name[i];
 
-	efivar_entry_set_safe(efi_name, vendor, PSTORE_EFI_ATTRIBUTES,
-			      !pstore_cannot_block_path(reason),
-			      size, psi->buf);
+	ret = efivar_entry_set_safe(efi_name, vendor, PSTORE_EFI_ATTRIBUTES,
+				    !pstore_cannot_block_path(reason),
+				    size, psi->buf);
 
 	if (reason == KMSG_DUMP_OOPS)
 		efivar_run_worker();
diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index d4056c6be1ec..8181ac179d14 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -18,7 +18,27 @@
 
 #include "efistub.h"
 
-bool __nokaslr;
+/*
+ * This is the base address at which to start allocating virtual memory ranges
+ * for UEFI Runtime Services. This is in the low TTBR0 range so that we can use
+ * any allocation we choose, and eliminate the risk of a conflict after kexec.
+ * The value chosen is the largest non-zero power of 2 suitable for this purpose
+ * both on 32-bit and 64-bit ARM CPUs, to maximize the likelihood that it can
+ * be mapped efficiently.
+ * Since 32-bit ARM could potentially execute with a 1G/3G user/kernel split,
+ * map everything below 1 GB. (512 MB is a reasonable upper bound for the
+ * entire footprint of the UEFI runtime services memory regions)
+ */
+#define EFI_RT_VIRTUAL_BASE	SZ_512M
+#define EFI_RT_VIRTUAL_SIZE	SZ_512M
+
+#ifdef CONFIG_ARM64
+# define EFI_RT_VIRTUAL_LIMIT	TASK_SIZE_64
+#else
+# define EFI_RT_VIRTUAL_LIMIT	TASK_SIZE
+#endif
+
+static u64 virtmap_base = EFI_RT_VIRTUAL_BASE;
 
 efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg,
 			     void *__image, void **__fh)
@@ -118,8 +138,6 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 	if (sys_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
 		goto fail;
 
-	pr_efi(sys_table, "Booting Linux Kernel...\n");
-
 	status = check_platform_features(sys_table);
 	if (status != EFI_SUCCESS)
 		goto fail;
@@ -153,17 +171,15 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 		goto fail;
 	}
 
-	/* check whether 'nokaslr' was passed on the command line */
-	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE)) {
-		static const u8 default_cmdline[] = CONFIG_CMDLINE;
-		const u8 *str, *cmdline = cmdline_ptr;
+	if (IS_ENABLED(CONFIG_CMDLINE_EXTEND) ||
+	    IS_ENABLED(CONFIG_CMDLINE_FORCE) ||
+	    cmdline_size == 0)
+		efi_parse_options(CONFIG_CMDLINE);
 
-		if (IS_ENABLED(CONFIG_CMDLINE_FORCE))
-			cmdline = default_cmdline;
-		str = strstr(cmdline, "nokaslr");
-		if (str == cmdline || (str > cmdline && *(str - 1) == ' '))
-			__nokaslr = true;
-	}
+	if (!IS_ENABLED(CONFIG_CMDLINE_FORCE) && cmdline_size > 0)
+		efi_parse_options(cmdline_ptr);
+
+	pr_efi(sys_table, "Booting Linux Kernel...\n");
 
 	si = setup_graphics(sys_table);
 
@@ -176,10 +192,6 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 		goto fail_free_cmdline;
 	}
 
-	status = efi_parse_options(cmdline_ptr);
-	if (status != EFI_SUCCESS)
-		pr_efi_err(sys_table, "Failed to parse EFI cmdline options\n");
-
 	secure_boot = efi_get_secureboot(sys_table);
 
 	/*
@@ -213,8 +225,9 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 	if (!fdt_addr)
 		pr_efi(sys_table, "Generating empty DTB\n");
 
-	status = handle_cmdline_files(sys_table, image, cmdline_ptr,
-				      "initrd=", dram_base + SZ_512M,
+	status = handle_cmdline_files(sys_table, image, cmdline_ptr, "initrd=",
+				      efi_get_max_initrd_addr(dram_base,
+							      *image_addr),
 				      (unsigned long *)&initrd_addr,
 				      (unsigned long *)&initrd_size);
 	if (status != EFI_SUCCESS)
@@ -222,9 +235,29 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 
 	efi_random_get_seed(sys_table);
 
+	if (!nokaslr()) {
+		/*
+		 * Randomize the base of the UEFI runtime services region.
+		 * Preserve the 2 MB alignment of the region by taking a
+		 * shift of 21 bit positions into account when scaling
+		 * the headroom value using a 32-bit random value.
+		 */
+		static const u64 headroom = EFI_RT_VIRTUAL_LIMIT -
+					    EFI_RT_VIRTUAL_BASE -
+					    EFI_RT_VIRTUAL_SIZE;
+		u32 rnd;
+
+		status = efi_get_random_bytes(sys_table, sizeof(rnd),
+					      (u8 *)&rnd);
+		if (status == EFI_SUCCESS) {
+			virtmap_base = EFI_RT_VIRTUAL_BASE +
+				       (((headroom >> 21) * rnd) >> (32 - 21));
+		}
+	}
+
 	new_fdt_addr = fdt_addr;
 	status = allocate_new_fdt_and_exit_boot(sys_table, handle,
-				&new_fdt_addr, dram_base + MAX_FDT_OFFSET,
+				&new_fdt_addr, efi_get_max_fdt_addr(dram_base),
 				initrd_addr, initrd_size, cmdline_ptr,
 				fdt_addr, fdt_size);
 
@@ -251,18 +284,6 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 	return EFI_ERROR;
 }
 
-/*
- * This is the base address at which to start allocating virtual memory ranges
- * for UEFI Runtime Services. This is in the low TTBR0 range so that we can use
- * any allocation we choose, and eliminate the risk of a conflict after kexec.
- * The value chosen is the largest non-zero power of 2 suitable for this purpose
- * both on 32-bit and 64-bit ARM CPUs, to maximize the likelihood that it can
- * be mapped efficiently.
- * Since 32-bit ARM could potentially execute with a 1G/3G user/kernel split,
- * map everything below 1 GB.
- */
-#define EFI_RT_VIRTUAL_BASE	SZ_512M
-
 static int cmp_mem_desc(const void *l, const void *r)
 {
 	const efi_memory_desc_t *left = l, *right = r;
@@ -312,7 +333,7 @@ void efi_get_virtmap(efi_memory_desc_t *memory_map, unsigned long map_size,
 		     unsigned long desc_size, efi_memory_desc_t *runtime_map,
 		     int *count)
 {
-	u64 efi_virt_base = EFI_RT_VIRTUAL_BASE;
+	u64 efi_virt_base = virtmap_base;
 	efi_memory_desc_t *in, *prev = NULL, *out = runtime_map;
 	int l;
 
diff --git a/drivers/firmware/efi/libstub/arm32-stub.c b/drivers/firmware/efi/libstub/arm32-stub.c
index e1f0b28e1dcb..becbda445913 100644
--- a/drivers/firmware/efi/libstub/arm32-stub.c
+++ b/drivers/firmware/efi/libstub/arm32-stub.c
@@ -9,6 +9,8 @@
 #include <linux/efi.h>
 #include <asm/efi.h>
 
+#include "efistub.h"
+
 efi_status_t check_platform_features(efi_system_table_t *sys_table_arg)
 {
 	int block;
@@ -63,6 +65,132 @@ void free_screen_info(efi_system_table_t *sys_table_arg, struct screen_info *si)
 	efi_call_early(free_pool, si);
 }
 
+static efi_status_t reserve_kernel_base(efi_system_table_t *sys_table_arg,
+					unsigned long dram_base,
+					unsigned long *reserve_addr,
+					unsigned long *reserve_size)
+{
+	efi_physical_addr_t alloc_addr;
+	efi_memory_desc_t *memory_map;
+	unsigned long nr_pages, map_size, desc_size, buff_size;
+	efi_status_t status;
+	unsigned long l;
+
+	struct efi_boot_memmap map = {
+		.map		= &memory_map,
+		.map_size	= &map_size,
+		.desc_size	= &desc_size,
+		.desc_ver	= NULL,
+		.key_ptr	= NULL,
+		.buff_size	= &buff_size,
+	};
+
+	/*
+	 * Reserve memory for the uncompressed kernel image. This is
+	 * all that prevents any future allocations from conflicting
+	 * with the kernel. Since we can't tell from the compressed
+	 * image how much DRAM the kernel actually uses (due to BSS
+	 * size uncertainty) we allocate the maximum possible size.
+	 * Do this very early, as prints can cause memory allocations
+	 * that may conflict with this.
+	 */
+	alloc_addr = dram_base + MAX_UNCOMP_KERNEL_SIZE;
+	nr_pages = MAX_UNCOMP_KERNEL_SIZE / EFI_PAGE_SIZE;
+	status = efi_call_early(allocate_pages, EFI_ALLOCATE_MAX_ADDRESS,
+				EFI_BOOT_SERVICES_DATA, nr_pages, &alloc_addr);
+	if (status == EFI_SUCCESS) {
+		if (alloc_addr == dram_base) {
+			*reserve_addr = alloc_addr;
+			*reserve_size = MAX_UNCOMP_KERNEL_SIZE;
+			return EFI_SUCCESS;
+		}
+		/*
+		 * If we end up here, the allocation succeeded but starts below
+		 * dram_base. This can only occur if the real base of DRAM is
+		 * not a multiple of 128 MB, in which case dram_base will have
+		 * been rounded up. Since this implies that a part of the region
+		 * was already occupied, we need to fall through to the code
+		 * below to ensure that the existing allocations don't conflict.
+		 * For this reason, we use EFI_BOOT_SERVICES_DATA above and not
+		 * EFI_LOADER_DATA, which we wouldn't able to distinguish from
+		 * allocations that we want to disallow.
+		 */
+	}
+
+	/*
+	 * If the allocation above failed, we may still be able to proceed:
+	 * if the only allocations in the region are of types that will be
+	 * released to the OS after ExitBootServices(), the decompressor can
+	 * safely overwrite them.
+	 */
+	status = efi_get_memory_map(sys_table_arg, &map);
+	if (status != EFI_SUCCESS) {
+		pr_efi_err(sys_table_arg,
+			   "reserve_kernel_base(): Unable to retrieve memory map.\n");
+		return status;
+	}
+
+	for (l = 0; l < map_size; l += desc_size) {
+		efi_memory_desc_t *desc;
+		u64 start, end;
+
+		desc = (void *)memory_map + l;
+		start = desc->phys_addr;
+		end = start + desc->num_pages * EFI_PAGE_SIZE;
+
+		/* Skip if entry does not intersect with region */
+		if (start >= dram_base + MAX_UNCOMP_KERNEL_SIZE ||
+		    end <= dram_base)
+			continue;
+
+		switch (desc->type) {
+		case EFI_BOOT_SERVICES_CODE:
+		case EFI_BOOT_SERVICES_DATA:
+			/* Ignore types that are released to the OS anyway */
+			continue;
+
+		case EFI_CONVENTIONAL_MEMORY:
+			/*
+			 * Reserve the intersection between this entry and the
+			 * region.
+			 */
+			start = max(start, (u64)dram_base);
+			end = min(end, (u64)dram_base + MAX_UNCOMP_KERNEL_SIZE);
+
+			status = efi_call_early(allocate_pages,
+						EFI_ALLOCATE_ADDRESS,
+						EFI_LOADER_DATA,
+						(end - start) / EFI_PAGE_SIZE,
+						&start);
+			if (status != EFI_SUCCESS) {
+				pr_efi_err(sys_table_arg,
+					"reserve_kernel_base(): alloc failed.\n");
+				goto out;
+			}
+			break;
+
+		case EFI_LOADER_CODE:
+		case EFI_LOADER_DATA:
+			/*
+			 * These regions may be released and reallocated for
+			 * another purpose (including EFI_RUNTIME_SERVICE_DATA)
+			 * at any time during the execution of the OS loader,
+			 * so we cannot consider them as safe.
+			 */
+		default:
+			/*
+			 * Treat any other allocation in the region as unsafe */
+			status = EFI_OUT_OF_RESOURCES;
+			goto out;
+		}
+	}
+
+	status = EFI_SUCCESS;
+out:
+	efi_call_early(free_pool, memory_map);
+	return status;
+}
+
 efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
 				 unsigned long *image_addr,
 				 unsigned long *image_size,
@@ -71,10 +199,7 @@ efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
 				 unsigned long dram_base,
 				 efi_loaded_image_t *image)
 {
-	unsigned long nr_pages;
 	efi_status_t status;
-	/* Use alloc_addr to tranlsate between types */
-	efi_physical_addr_t alloc_addr;
 
 	/*
 	 * Verify that the DRAM base address is compatible with the ARM
@@ -85,27 +210,12 @@ efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
 	 */
 	dram_base = round_up(dram_base, SZ_128M);
 
-	/*
-	 * Reserve memory for the uncompressed kernel image. This is
-	 * all that prevents any future allocations from conflicting
-	 * with the kernel. Since we can't tell from the compressed
-	 * image how much DRAM the kernel actually uses (due to BSS
-	 * size uncertainty) we allocate the maximum possible size.
-	 * Do this very early, as prints can cause memory allocations
-	 * that may conflict with this.
-	 */
-	alloc_addr = dram_base;
-	*reserve_size = MAX_UNCOMP_KERNEL_SIZE;
-	nr_pages = round_up(*reserve_size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
-	status = sys_table->boottime->allocate_pages(EFI_ALLOCATE_ADDRESS,
-						     EFI_LOADER_DATA,
-						     nr_pages, &alloc_addr);
+	status = reserve_kernel_base(sys_table, dram_base, reserve_addr,
+				     reserve_size);
 	if (status != EFI_SUCCESS) {
-		*reserve_size = 0;
 		pr_efi_err(sys_table, "Unable to allocate memory for uncompressed kernel.\n");
 		return status;
 	}
-	*reserve_addr = alloc_addr;
 
 	/*
 	 * Relocate the zImage, so that it appears in the lowest 128 MB
diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index eae693eb3e91..b4c2589d7c91 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -16,8 +16,6 @@
 
 #include "efistub.h"
 
-extern bool __nokaslr;
-
 efi_status_t check_platform_features(efi_system_table_t *sys_table_arg)
 {
 	u64 tg;
@@ -52,7 +50,7 @@ efi_status_t handle_kernel_image(efi_system_table_t *sys_table_arg,
 	u64 phys_seed = 0;
 
 	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE)) {
-		if (!__nokaslr) {
+		if (!nokaslr()) {
 			status = efi_get_random_bytes(sys_table_arg,
 						      sizeof(phys_seed),
 						      (u8 *)&phys_seed);
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 919822b7773d..b0184360efc6 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -32,6 +32,18 @@
 
 static unsigned long __chunk_size = EFI_READ_CHUNK_SIZE;
 
+static int __section(.data) __nokaslr;
+static int __section(.data) __quiet;
+
+int __pure nokaslr(void)
+{
+	return __nokaslr;
+}
+int __pure is_quiet(void)
+{
+	return __quiet;
+}
+
 #define EFI_MMAP_NR_SLACK_SLOTS	8
 
 struct file_info {
@@ -409,17 +421,17 @@ static efi_status_t efi_file_close(void *handle)
  * environments, first in the early boot environment of the EFI boot
  * stub, and subsequently during the kernel boot.
  */
-efi_status_t efi_parse_options(char *cmdline)
+efi_status_t efi_parse_options(char const *cmdline)
 {
 	char *str;
 
-	/*
-	 * Currently, the only efi= option we look for is 'nochunk', which
-	 * is intended to work around known issues on certain x86 UEFI
-	 * versions. So ignore for now on other architectures.
-	 */
-	if (!IS_ENABLED(CONFIG_X86))
-		return EFI_SUCCESS;
+	str = strstr(cmdline, "nokaslr");
+	if (str == cmdline || (str && str > cmdline && *(str - 1) == ' '))
+		__nokaslr = 1;
+
+	str = strstr(cmdline, "quiet");
+	if (str == cmdline || (str && str > cmdline && *(str - 1) == ' '))
+		__quiet = 1;
 
 	/*
 	 * If no EFI parameters were specified on the cmdline we've got
@@ -436,14 +448,14 @@ efi_status_t efi_parse_options(char *cmdline)
 	 * Remember, because efi= is also used by the kernel we need to
 	 * skip over arguments we don't understand.
 	 */
-	while (*str) {
+	while (*str && *str != ' ') {
 		if (!strncmp(str, "nochunk", 7)) {
 			str += strlen("nochunk");
 			__chunk_size = -1UL;
 		}
 
 		/* Group words together, delimited by "," */
-		while (*str && *str != ',')
+		while (*str && *str != ' ' && *str != ',')
 			str++;
 
 		if (*str == ',')
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index 71c4d0e3c4ed..83f268c05007 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -24,6 +24,15 @@
 #define EFI_ALLOC_ALIGN		EFI_PAGE_SIZE
 #endif
 
+extern int __pure nokaslr(void);
+extern int __pure is_quiet(void);
+
+#define pr_efi(sys_table, msg)		do {				\
+	if (!is_quiet()) efi_printk(sys_table, "EFI stub: "msg);	\
+} while (0)
+
+#define pr_efi_err(sys_table, msg) efi_printk(sys_table, "EFI stub: ERROR: "msg)
+
 void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
 
 efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg, void *__image,
diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index 260c4b4b492e..41f457be64e8 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -206,6 +206,10 @@ static efi_status_t exit_boot_func(efi_system_table_t *sys_table_arg,
 	return update_fdt_memmap(p->new_fdt_addr, map);
 }
 
+#ifndef MAX_FDT_SIZE
+#define MAX_FDT_SIZE	SZ_2M
+#endif
+
 /*
  * Allocate memory for a new FDT, then add EFI, commandline, and
  * initrd related fields to the FDT.  This routine increases the
@@ -233,7 +237,6 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 	u32 desc_ver;
 	unsigned long mmap_key;
 	efi_memory_desc_t *memory_map, *runtime_map;
-	unsigned long new_fdt_size;
 	efi_status_t status;
 	int runtime_entry_count = 0;
 	struct efi_boot_memmap map;
@@ -262,41 +265,29 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 	       "Exiting boot services and installing virtual address map...\n");
 
 	map.map = &memory_map;
+	status = efi_high_alloc(sys_table, MAX_FDT_SIZE, EFI_FDT_ALIGN,
+				new_fdt_addr, max_addr);
+	if (status != EFI_SUCCESS) {
+		pr_efi_err(sys_table,
+			   "Unable to allocate memory for new device tree.\n");
+		goto fail;
+	}
+
 	/*
-	 * Estimate size of new FDT, and allocate memory for it. We
-	 * will allocate a bigger buffer if this ends up being too
-	 * small, so a rough guess is OK here.
+	 * Now that we have done our final memory allocation (and free)
+	 * we can get the memory map key needed for exit_boot_services().
 	 */
-	new_fdt_size = fdt_size + EFI_PAGE_SIZE;
-	while (1) {
-		status = efi_high_alloc(sys_table, new_fdt_size, EFI_FDT_ALIGN,
-					new_fdt_addr, max_addr);
-		if (status != EFI_SUCCESS) {
-			pr_efi_err(sys_table, "Unable to allocate memory for new device tree.\n");
-			goto fail;
-		}
-
-		status = update_fdt(sys_table,
-				    (void *)fdt_addr, fdt_size,
-				    (void *)*new_fdt_addr, new_fdt_size,
-				    cmdline_ptr, initrd_addr, initrd_size);
+	status = efi_get_memory_map(sys_table, &map);
+	if (status != EFI_SUCCESS)
+		goto fail_free_new_fdt;
 
-		/* Succeeding the first time is the expected case. */
-		if (status == EFI_SUCCESS)
-			break;
+	status = update_fdt(sys_table, (void *)fdt_addr, fdt_size,
+			    (void *)*new_fdt_addr, MAX_FDT_SIZE, cmdline_ptr,
+			    initrd_addr, initrd_size);
 
-		if (status == EFI_BUFFER_TOO_SMALL) {
-			/*
-			 * We need to allocate more space for the new
-			 * device tree, so free existing buffer that is
-			 * too small.
-			 */
-			efi_free(sys_table, new_fdt_size, *new_fdt_addr);
-			new_fdt_size += EFI_PAGE_SIZE;
-		} else {
-			pr_efi_err(sys_table, "Unable to construct new device tree.\n");
-			goto fail_free_new_fdt;
-		}
+	if (status != EFI_SUCCESS) {
+		pr_efi_err(sys_table, "Unable to construct new device tree.\n");
+		goto fail_free_new_fdt;
 	}
 
 	priv.runtime_map = runtime_map;
@@ -340,7 +331,7 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 	pr_efi_err(sys_table, "Exit boot services failed.\n");
 
 fail_free_new_fdt:
-	efi_free(sys_table, new_fdt_size, *new_fdt_addr);
+	efi_free(sys_table, MAX_FDT_SIZE, *new_fdt_addr);
 
 fail:
 	sys_table->boottime->free_pool(runtime_map);
diff --git a/drivers/firmware/efi/libstub/secureboot.c b/drivers/firmware/efi/libstub/secureboot.c
index 5da36e56b36a..8c34d50a4d80 100644
--- a/drivers/firmware/efi/libstub/secureboot.c
+++ b/drivers/firmware/efi/libstub/secureboot.c
@@ -12,6 +12,8 @@
 #include <linux/efi.h>
 #include <asm/efi.h>
 
+#include "efistub.h"
+
 /* BIOS variables */
 static const efi_guid_t efi_variable_guid = EFI_GLOBAL_VARIABLE_GUID;
 static const efi_char16_t const efi_SecureBoot_name[] = {
diff --git a/include/linux/efi-bgrt.h b/include/linux/efi-bgrt.h
index 2fd3993c370b..e6f624b53c3d 100644
--- a/include/linux/efi-bgrt.h
+++ b/include/linux/efi-bgrt.h
@@ -6,6 +6,7 @@
 #ifdef CONFIG_ACPI_BGRT
 
 void efi_bgrt_init(struct acpi_table_header *table);
+int __init acpi_parse_bgrt(struct acpi_table_header *table);
 
 /* The BGRT data itself; only valid if bgrt_image != NULL. */
 extern size_t bgrt_image_size;
@@ -14,6 +15,10 @@ extern struct acpi_table_bgrt bgrt_tab;
 #else /* !CONFIG_ACPI_BGRT */
 
 static inline void efi_bgrt_init(struct acpi_table_header *table) {}
+static inline int __init acpi_parse_bgrt(struct acpi_table_header *table)
+{
+	return 0;
+}
 
 #endif /* !CONFIG_ACPI_BGRT */
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 94d34e0be24f..ec36f42a2add 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1435,9 +1435,6 @@ static inline int efi_runtime_map_copy(void *buf, size_t bufsz)
 
 /* prototypes shared between arch specific and generic stub code */
 
-#define pr_efi(sys_table, msg)     efi_printk(sys_table, "EFI stub: "msg)
-#define pr_efi_err(sys_table, msg) efi_printk(sys_table, "EFI stub: ERROR: "msg)
-
 void efi_printk(efi_system_table_t *sys_table_arg, char *str);
 
 void efi_free(efi_system_table_t *sys_table_arg, unsigned long size,
@@ -1471,7 +1468,7 @@ efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 				  unsigned long *load_addr,
 				  unsigned long *load_size);
 
-efi_status_t efi_parse_options(char *cmdline);
+efi_status_t efi_parse_options(char const *cmdline);
 
 efi_status_t efi_setup_gop(efi_system_table_t *sys_table_arg,
 			   struct screen_info *si, efi_guid_t *proto,
