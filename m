From: Aaron Ma <aaron.ma@canonical.com>
Subject: [PATCH v2] x86/efi: earlyprintk - Add 64bit efi fb address support
Date: Thu, 13 Sep 2018 02:00:08 +0800
Message-ID: <1536775208-8064-1-git-send-email-aaron.ma@canonical.com>
References: <1536423828-5693-1-git-send-email-aaron.ma@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1536423828-5693-1-git-send-email-aaron.ma@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: ard.biesheuvel@linaro.org, tglx@linutronix.de, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, aaron.ma@canonical.com
List-Id: linux-efi@vger.kernel.org

EFI GOP uses 64-bit frame buffer address in some BIOS.
Add 64bit address support in efi earlyprintk.

V2:
Fix type of address.

Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
---
 arch/x86/platform/efi/early_printk.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/efi/early_printk.c b/arch/x86/platform/efi/early_printk.c
index 5fdacb322ceb..7476b3b097e1 100644
--- a/arch/x86/platform/efi/early_printk.c
+++ b/arch/x86/platform/efi/early_printk.c
@@ -26,12 +26,14 @@ static bool early_efi_keep;
  */
 static __init int early_efi_map_fb(void)
 {
-	unsigned long base, size;
+	u64 base, size;
 
 	if (!early_efi_keep)
 		return 0;
 
 	base = boot_params.screen_info.lfb_base;
+	if (boot_params.screen_info.capabilities & VIDEO_CAPABILITY_64BIT_BASE)
+		base |= (u64)boot_params.screen_info.ext_lfb_base << 32;
 	size = boot_params.screen_info.lfb_size;
 	efi_fb = ioremap(base, size);
 
@@ -46,9 +48,11 @@ early_initcall(early_efi_map_fb);
  */
 static __ref void *early_efi_map(unsigned long start, unsigned long len)
 {
-	unsigned long base;
+	u64 base;
 
 	base = boot_params.screen_info.lfb_base;
+	if (boot_params.screen_info.capabilities & VIDEO_CAPABILITY_64BIT_BASE)
+		base |= (u64)boot_params.screen_info.ext_lfb_base << 32;
 
 	if (efi_fb)
 		return (efi_fb + start);
-- 
2.17.1
