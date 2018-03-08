From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 03/12] efi/arm*: Stop printing addresses of virtual mappings
Date: Thu,  8 Mar 2018 08:00:11 +0000
Message-ID: <20180308080020.22828-4-ard.biesheuvel@linaro.org>
References: <20180308080020.22828-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180308080020.22828-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

With the recent %p -> %px changes, we now get something like this in
the kernel boot log on ARM/arm64 EFI systems:

     Remapping and enabling EFI services.
       EFI remap 0x00000087fb830000 =>         (ptrval)
       EFI remap 0x00000087fbdb0000 =>         (ptrval)
       EFI remap 0x00000087fffc0000 =>         (ptrval)

The physical addresses of the UEFI runtime regions will also be
printed when booting with the efi=debug command line option, and the
virtual addresses can be inspected via /sys/kernel/debug/efi_page_tables
(if enabled). So let's just remove the lines above.

Acked-by: Leif Lindholm <leif.lindholm@linaro.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/arm-runtime.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 86a1ad17a32e..13561aeb7396 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -83,10 +83,7 @@ static bool __init efi_virtmap_init(void)
 			return false;
 
 		ret = efi_create_mapping(&efi_mm, md);
-		if  (!ret) {
-			pr_info("  EFI remap %pa => %p\n",
-				&phys, (void *)(unsigned long)md->virt_addr);
-		} else {
+		if (ret) {
 			pr_warn("  EFI remap %pa: failed to create mapping (%d)\n",
 				&phys, ret);
 			return false;
-- 
2.15.1
