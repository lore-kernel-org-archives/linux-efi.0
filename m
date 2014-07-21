From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [RFC PATCH 06/10] arm64/efi: efistub: avoid using linker defined constants
Date: Mon, 21 Jul 2014 17:16:21 +0200
Message-ID: <1405955785-13477-7-git-send-email-ard.biesheuvel@linaro.org>
References: <1405955785-13477-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405955785-13477-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, victor.kamensky-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, steve.capper-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

When we build the stub as a separate executable, we cannot refer to symbols
like _edata or _end to find out how large the kernel is. Use image->image_size
instead, this covers the entire static memory footprint including BSS.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/kernel/efi-stub.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
index 1317fef8dde9..8401d7795395 100644
--- a/arch/arm64/kernel/efi-stub.c
+++ b/arch/arm64/kernel/efi-stub.c
@@ -11,7 +11,6 @@
  */
 #include <linux/efi.h>
 #include <asm/efi.h>
-#include <asm/sections.h>
 
 efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
 				 unsigned long *image_addr,
@@ -22,14 +21,12 @@ efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
 				 efi_loaded_image_t *image)
 {
 	efi_status_t status;
-	unsigned long kernel_size, kernel_memsize = 0;
 
 	/* Relocate the image, if required. */
-	kernel_size = _edata - _text;
 	if (*image_addr != (dram_base + TEXT_OFFSET)) {
-		kernel_memsize = kernel_size + (_end - _edata);
 		status = efi_relocate_kernel(sys_table, image_addr,
-					     kernel_size, kernel_memsize,
+					     image->image_size,
+					     image->image_size,
 					     dram_base + TEXT_OFFSET,
 					     PAGE_SIZE);
 		if (status != EFI_SUCCESS) {
@@ -38,10 +35,10 @@ efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
 		}
 		if (*image_addr != (dram_base + TEXT_OFFSET)) {
 			pr_efi_err(sys_table, "Failed to alloc kernel memory\n");
-			efi_free(sys_table, kernel_memsize, *image_addr);
+			efi_free(sys_table, image->image_size, *image_addr);
 			return EFI_LOAD_ERROR;
 		}
-		*image_size = kernel_memsize;
+		*image_size = image->image_size;
 	}
 
 
-- 
1.8.3.2
