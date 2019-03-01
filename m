From: Takashi Iwai <tiwai@suse.de>
Subject: [PATCH] efi: Downgrade "EFI_MEMMAP is not enabled" message
Date: Fri,  1 Mar 2019 14:40:33 +0100
Message-ID: <20190301134033.2100-1-tiwai@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "Lee, Chun-Yi" <jlee@suse.com>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Since 38ac0287b7f4 ("fbdev/efifb: Honour UEFI memory map attributes
when mapping the FB"), efifb_probe() checks its memory range via
efi_mem_desc_lookup(), and this leads to a spurious error message
"EFI_MEMMAP is not enabled" at every boot on KVM.  This is quite
annoying since the error message appears even if you set "quiet" boot
option.

Actually there are only a few places that call efi_mem_desc_lookup()
function, and the other callers do give the explicit error messages
when the function returns an error in anyway.  That is, the error
message in the function is more or less moot.

So let's downgrade the error message for stop annoying users.

Fixes: 38ac0287b7f4 ("fbdev/efifb: Honour UEFI memory map attributes when mapping the FB")
Bugzilla: https://bugzilla.suse.com/show_bug.cgi?id=1127339
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/firmware/efi/efi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 55b77c576c42..50ac33097458 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -409,7 +409,7 @@ int efi_mem_desc_lookup(u64 phys_addr, efi_memory_desc_t *out_md)
 	efi_memory_desc_t *md;
 
 	if (!efi_enabled(EFI_MEMMAP)) {
-		pr_err_once("EFI_MEMMAP is not enabled.\n");
+		pr_debug("EFI_MEMMAP is not enabled.\n");
 		return -EINVAL;
 	}
 
-- 
2.16.4
