From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/2] arm64/efi: efistub: get text offset and image size from the Image header
Date: Mon, 14 Jul 2014 18:17:51 +0200
Message-ID: <1405354671-14031-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1405354671-14031-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1405354671-14031-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The EFI stub for arm64 needs to behave like an ordinary bootloader in the sense
that it needs to use the EFI environment and the Image header at runtime and
not rely on the linker or preprocessor to produce values for text offset,
image size and kernel size. This patch also fixes the corner case where Image
happens to be loaded at exactly the right offset, but the allocation is
actually too small to satisfy the requirement imposed by image_size as set in
the header.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/kernel/Makefile   |  2 --
 arch/arm64/kernel/efi-stub.c | 29 ++++++++++++++++-------------
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index cdaedad3afe5..99b676eeeb0f 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -4,8 +4,6 @@
 
 CPPFLAGS_vmlinux.lds	:= -DTEXT_OFFSET=$(TEXT_OFFSET)
 AFLAGS_head.o		:= -DTEXT_OFFSET=$(TEXT_OFFSET)
-CFLAGS_efi-stub.o 	:= -DTEXT_OFFSET=$(TEXT_OFFSET) \
-			   -I$(src)/../../../scripts/dtc/libfdt
 
 CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_insn.o = -pg
diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
index 9b61d66e2d20..4ba90b2ef677 100644
--- a/arch/arm64/kernel/efi-stub.c
+++ b/arch/arm64/kernel/efi-stub.c
@@ -11,8 +11,7 @@
  */
 #include <linux/efi.h>
 #include <asm/efi.h>
-#include <asm/sections.h>
-
+#include <asm/image_hdr.h>
 
 efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
 				 unsigned long *image_addr,
@@ -23,24 +22,28 @@ efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
 				 efi_loaded_image_t *image)
 {
 	efi_status_t status;
-	unsigned long kernel_size, kernel_memsize = 0;
+	struct arm64_image_hdr *hdr = (struct arm64_image_hdr *)*image_addr;
+
+	/* make sure image_addr points to an arm64 kernel Image */
+	if (!arm64_image_hdr_check(hdr)) {
+		pr_efi_err(sys_table, "Kernel Image header check failed\n");
+		return EFI_LOAD_ERROR;
+	}
 
 	/* Relocate the image, if required. */
-	kernel_size = _edata - _text;
-	if (*image_addr != (dram_base + TEXT_OFFSET)) {
-		kernel_memsize = kernel_size + (_end - _edata) + TEXT_OFFSET;
-		status = efi_low_alloc(sys_table, kernel_memsize, SZ_2M,
+	if (*image_addr != (dram_base + hdr->text_offset) ||
+	    image->image_size < hdr->image_size) {
+		*reserve_size = hdr->text_offset + hdr->image_size;
+		status = efi_low_alloc(sys_table, *reserve_size, SZ_2M,
 				       reserve_addr);
 		if (status != EFI_SUCCESS) {
 			pr_efi_err(sys_table, "Failed to relocate kernel\n");
+			*reserve_size = 0;
 			return status;
 		}
-		memcpy((void *)*reserve_addr + TEXT_OFFSET, (void *)*image_addr,
-		       kernel_size);
-		*image_addr = *reserve_addr + TEXT_OFFSET;
-		*reserve_size = kernel_memsize;
+		memcpy((void *)*reserve_addr + hdr->text_offset,
+		       (void *)*image_addr, image->image_size);
+		*image_addr = *reserve_addr + hdr->text_offset;
 	}
-
-
 	return EFI_SUCCESS;
 }
-- 
1.8.3.2
