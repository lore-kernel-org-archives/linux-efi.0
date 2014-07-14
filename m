From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] efi/arm64: efistub: don't abort if base of DRAM is occupied
Date: Mon, 14 Jul 2014 17:25:21 +0200
Message-ID: <1405351521-12010-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

If we fail to relocate the kernel Image to its preferred offset of TEXT_OFFSET
bytes above the base of DRAM, accept the lowest alternative mapping available
instead of aborting. We may lose a bit of memory at the low end, but we can
still proceed normally otherwise.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
This is a proposed bug fix for arm64 platforms that fail to boot through EFI
due to the fact that some bits of EFI itself are occupying the low end of DRAM. 

Note that this code now triggers an 'unused function' warning for
efi_relocate_kernel(), as that is no longer used. This warning will disappear
automatically once the already queued up EFISTUB refactoring patches will
get merged for 3.17.

 arch/arm64/kernel/efi-stub.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
index 60e98a639ac5..5165b3accefe 100644
--- a/arch/arm64/kernel/efi-stub.c
+++ b/arch/arm64/kernel/efi-stub.c
@@ -60,20 +60,16 @@ static efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
 	kernel_size = _edata - _text;
 	if (*image_addr != (dram_base + TEXT_OFFSET)) {
 		kernel_memsize = kernel_size + (_end - _edata);
-		status = efi_relocate_kernel(sys_table, image_addr,
-					     kernel_size, kernel_memsize,
-					     dram_base + TEXT_OFFSET,
-					     PAGE_SIZE);
+		status = efi_low_alloc(sys_table, kernel_memsize + TEXT_OFFSET,
+				       SZ_2M, reserve_addr);
 		if (status != EFI_SUCCESS) {
 			pr_efi_err(sys_table, "Failed to relocate kernel\n");
 			return status;
 		}
-		if (*image_addr != (dram_base + TEXT_OFFSET)) {
-			pr_efi_err(sys_table, "Failed to alloc kernel memory\n");
-			efi_free(sys_table, kernel_memsize, *image_addr);
-			return EFI_ERROR;
-		}
-		*image_size = kernel_memsize;
+		memcpy((void *)*reserve_addr + TEXT_OFFSET, (void *)*image_addr,
+		       kernel_size);
+		*image_addr = *reserve_addr + TEXT_OFFSET;
+		*reserve_size = kernel_memsize;
 	}


-- 
1.8.3.2
