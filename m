From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] efi: arm-stub: Correct FDT and initrd allocation rules for arm64
Date: Thu,  9 Feb 2017 10:16:29 +0000
Message-ID: <1486635389-26974-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
Cc: timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On arm64, we have made some changes over the past year to the way the
kernel itself is allocated and to how it deals with the initrd and FDT.
This patch brings the allocation logic in the EFI stub in line with that,
which is necessary because the introduction of KASLR has created the
possibility for the initrd to be allocated in a place where the kernel
may not be able to map it. (This is currently a theoretical scenario,
since it only affects systems where the size of RAM exceeds the size of
the linear mapping.)

So adhere to the arm64 boot protocol, and make sure that the initrd is
fully inside a 1GB aligned 32 GB window that covers the kernel as well.

The FDT may be anywhere in memory on arm64 now that we map it via the
fixmap, so we can lift the address restriction there completely.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm/include/asm/efi.h              | 14 +++++++++++++-
 arch/arm64/include/asm/efi.h            | 19 ++++++++++++++++++-
 drivers/firmware/efi/libstub/arm-stub.c |  7 ++++---
 3 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/arch/arm/include/asm/efi.h b/arch/arm/include/asm/efi.h
index 0b06f5341b45..62620451f60b 100644
--- a/arch/arm/include/asm/efi.h
+++ b/arch/arm/include/asm/efi.h
@@ -84,6 +84,18 @@ static inline void efifb_setup_from_dmi(struct screen_info *si, const char *opt)
  */
 #define ZIMAGE_OFFSET_LIMIT	SZ_128M
 #define MIN_ZIMAGE_OFFSET	MAX_UNCOMP_KERNEL_SIZE
-#define MAX_FDT_OFFSET		ZIMAGE_OFFSET_LIMIT
+
+/* on ARM, the FDT should be located in the first 128 MB of RAM */
+static inline unsigned long efi_get_max_fdt_addr(unsigned long dram_base)
+{
+		return dram_base + ZIMAGE_OFFSET_LIMIT;
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
index 0b6b1633017f..6a6c8a0d1424 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -46,7 +46,24 @@ int efi_set_mapping_permissions(struct mm_struct *mm, efi_memory_desc_t *md);
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
+ * On arm64, the initrd must be completely inside a 1 GB aligned 32 GB window
+ * that covers Image as well. Since we allocate from the top down, set a max
+ * address that is virtually guaranteed to produce a suitable allocation even
+ * when the physical address of Image is randomized.
+ */
+static inline unsigned long efi_get_max_initrd_addr(unsigned long dram_base,
+						    unsigned long image_addr)
+{
+	return ALIGN(image_addr, SZ_1G) + 31UL * SZ_1G;
+}
 
 #define efi_call_early(f, ...)		sys_table_arg->boottime->f(__VA_ARGS__)
 #define __efi_call_early(f, ...)	f(__VA_ARGS__)
diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index b4f7d78f9e8b..557281fe375f 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -333,8 +333,9 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
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
@@ -344,7 +345,7 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 
 	new_fdt_addr = fdt_addr;
 	status = allocate_new_fdt_and_exit_boot(sys_table, handle,
-				&new_fdt_addr, dram_base + MAX_FDT_OFFSET,
+				&new_fdt_addr, efi_get_max_fdt_addr(dram_base),
 				initrd_addr, initrd_size, cmdline_ptr,
 				fdt_addr, fdt_size);
 
-- 
2.7.4
