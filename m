From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/2] arm64/efi: use efi_low_alloc() with offset to allocate kernel
Date: Wed, 29 Jul 2015 12:04:19 +0200
Message-ID: <1438164259-14470-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1438164259-14470-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1438164259-14470-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Now that efi_low_alloc() supports an offset parameter, we can use it
to allocate memory for the kernel at TEXT_OFFSET bytes above a 2 MB
aligned boundary directly. This prevents issues when the base of
DRAM is at 0x0, which efi_low_alloc() refuses to use as the address
of an allocation. It also helps when fewer than TEXT_OFFSET bytes are
occupied by the firmware at the base of DRAM, since efi_low_alloc()
will now do the rounding for us, and return 'base of DRAM + TEXT_OFFSET'
directly, regardless of whether any regions below it are in use.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/kernel/efi-stub.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
index d85a0b2098b3..e3085b391570 100644
--- a/arch/arm64/kernel/efi-stub.c
+++ b/arch/arm64/kernel/efi-stub.c
@@ -23,21 +23,22 @@ efi_status_t __init handle_kernel_image(efi_system_table_t *sys_table,
 {
 	efi_status_t status;
 	unsigned long kernel_size, kernel_memsize = 0;
+	unsigned long new_image_addr;
 
 	/* Relocate the image, if required. */
 	kernel_size = _edata - _text;
 	if (*image_addr != (dram_base + TEXT_OFFSET)) {
 		kernel_memsize = kernel_size + (_end - _edata);
-		status = efi_low_alloc(sys_table, kernel_memsize + TEXT_OFFSET,
-				       SZ_2M, 0, reserve_addr);
+		status = efi_low_alloc(sys_table, kernel_memsize, SZ_2M,
+				       TEXT_OFFSET, &new_image_addr);
 		if (status != EFI_SUCCESS) {
 			pr_efi_err(sys_table, "Failed to relocate kernel\n");
 			return status;
 		}
-		memcpy((void *)*reserve_addr + TEXT_OFFSET, (void *)*image_addr,
+		memcpy((void *)new_image_addr, (void *)*image_addr,
 		       kernel_size);
-		*image_addr = *reserve_addr + TEXT_OFFSET;
-		*reserve_size = kernel_memsize + TEXT_OFFSET;
+		*image_addr = new_image_addr;
+		*image_size = kernel_memsize;
 	}
 
 
-- 
1.9.1
