From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2] efi: add 'offset' param to efi_low_alloc()
Date: Wed, 29 Jul 2015 12:04:18 +0200
Message-ID: <1438164259-14470-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1438164259-14470-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438164259-14470-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

In some cases, e.g., when allocating memory for the arm64 kernel,
we need memory at a certain offset from an aligned boundary. So add
an offset parameter to efi_low_alloc(), and update the existing
callers to pass zero by default.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/kernel/efi-stub.c                   |  2 +-
 arch/x86/boot/compressed/eboot.c               |  4 ++--
 drivers/firmware/efi/libstub/efi-stub-helper.c | 20 +++++++++++++++-----
 include/linux/efi.h                            |  2 +-
 4 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
index f5374065ad53..d85a0b2098b3 100644
--- a/arch/arm64/kernel/efi-stub.c
+++ b/arch/arm64/kernel/efi-stub.c
@@ -29,7 +29,7 @@ efi_status_t __init handle_kernel_image(efi_system_table_t *sys_table,
 	if (*image_addr != (dram_base + TEXT_OFFSET)) {
 		kernel_memsize = kernel_size + (_end - _edata);
 		status = efi_low_alloc(sys_table, kernel_memsize + TEXT_OFFSET,
-				       SZ_2M, reserve_addr);
+				       SZ_2M, 0, reserve_addr);
 		if (status != EFI_SUCCESS) {
 			pr_efi_err(sys_table, "Failed to relocate kernel\n");
 			return status;
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 2c82bd150d43..33d1a72f4266 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1077,7 +1077,7 @@ struct boot_params *make_boot_params(struct efi_config *c)
 		return NULL;
 	}
 
-	status = efi_low_alloc(sys_table, 0x4000, 1,
+	status = efi_low_alloc(sys_table, 0x4000, 1, 0,
 			       (unsigned long *)&boot_params);
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table, "Failed to alloc lowmem for boot params\n");
@@ -1424,7 +1424,7 @@ struct boot_params *efi_main(struct efi_config *c,
 	}
 
 	gdt->size = 0x800;
-	status = efi_low_alloc(sys_table, gdt->size, 8,
+	status = efi_low_alloc(sys_table, gdt->size, 8, 0,
 			   (unsigned long *)&gdt->address);
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table, "Failed to alloc mem for gdt\n");
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index f07d4a67fa76..67d1759781c5 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -226,7 +226,7 @@ fail:
  */
 efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 			   unsigned long size, unsigned long align,
-			   unsigned long *addr)
+			   unsigned long offset, unsigned long *addr)
 {
 	unsigned long map_size, desc_size;
 	efi_memory_desc_t *map;
@@ -269,10 +269,19 @@ efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 		 * checks pointers against NULL. Skip the first 8
 		 * bytes so we start at a nice even number.
 		 */
-		if (start == 0x0)
+		if (start + offset == 0x0)
 			start += 8;
 
-		start = round_up(start, align);
+		/*
+		 * Check if the offset exceeds the misalignment of this region.
+		 * In that case, we can round down instead of up, and the
+		 * resulting start value will be correctly aligned and still
+		 * point past the start of the region.
+		 */
+		if (offset >= (start & (align - 1)))
+			start = round_down(start, align) + offset;
+		else
+			start = round_up(start, align) + offset;
 		if ((start + size) > end)
 			continue;
 
@@ -580,7 +589,7 @@ efi_status_t efi_relocate_kernel(efi_system_table_t *sys_table_arg,
 	 * possible.
 	 */
 	if (status != EFI_SUCCESS) {
-		status = efi_low_alloc(sys_table_arg, alloc_size, alignment,
+		status = efi_low_alloc(sys_table_arg, alloc_size, alignment, 0,
 				       &new_addr);
 	}
 	if (status != EFI_SUCCESS) {
@@ -684,7 +693,8 @@ char *efi_convert_cmdline(efi_system_table_t *sys_table_arg,
 
 	options_bytes++;	/* NUL termination */
 
-	status = efi_low_alloc(sys_table_arg, options_bytes, 0, &cmdline_addr);
+	status = efi_low_alloc(sys_table_arg, options_bytes, 0, 0,
+			       &cmdline_addr);
 	if (status != EFI_SUCCESS)
 		return NULL;
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index faafa1ad6ea7..e738e97632ba 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1245,7 +1245,7 @@ efi_status_t efi_get_memory_map(efi_system_table_t *sys_table_arg,
 
 efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 			   unsigned long size, unsigned long align,
-			   unsigned long *addr);
+			   unsigned long offset, unsigned long *addr);
 
 efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
 			    unsigned long size, unsigned long align,
-- 
1.9.1
