From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 1/7] arm64: efistub: drop __init annotation from handle_kernel_image()
Date: Thu,  4 Feb 2016 16:50:24 +0100
Message-ID: <1454601030-9093-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1454601030-9093-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454601030-9093-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org
Cc: will.deacon-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, jeremy.linton-5wv7dgnIgG8@public.gmane.org, suzuki.poulose-5wv7dgnIgG8@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

After moving arm64-stub.c to libstub/, all of its sections are emitted
as .init.xxx sections automatically, and the __init annotation of
handle_kernel_image() causes it to end up in .init.init.text, which is
not recognized as an __init section by the linker scripts. So drop the
annotation.

Acked-by: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Acked-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Tested-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/libstub/arm64-stub.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index 78dfbd34b6bf..9e0342745e4f 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -13,13 +13,13 @@
 #include <asm/efi.h>
 #include <asm/sections.h>
 
-efi_status_t __init handle_kernel_image(efi_system_table_t *sys_table_arg,
-					unsigned long *image_addr,
-					unsigned long *image_size,
-					unsigned long *reserve_addr,
-					unsigned long *reserve_size,
-					unsigned long dram_base,
-					efi_loaded_image_t *image)
+efi_status_t handle_kernel_image(efi_system_table_t *sys_table_arg,
+				 unsigned long *image_addr,
+				 unsigned long *image_size,
+				 unsigned long *reserve_addr,
+				 unsigned long *reserve_size,
+				 unsigned long dram_base,
+				 efi_loaded_image_t *image)
 {
 	efi_status_t status;
 	unsigned long kernel_size, kernel_memsize = 0;
-- 
2.5.0
