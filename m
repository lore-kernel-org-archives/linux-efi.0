From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 09/11] efi/x86: earlyprintk - Add 64bit efi fb address support
Date: Thu, 27 Sep 2018 10:50:36 +0200
Message-ID: <20180927085039.8391-10-ard.biesheuvel@linaro.org>
References: <20180927085039.8391-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180927085039.8391-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Aaron Ma <aaron.ma@canonical.com>, Alistair Strachan <astrachan@google.com>, Ben Hutchings <ben@decadent.org.uk>, Bhupesh Sharma <bhsharma@redhat.com>, Hans de Goede <hdegoede@redhat.com>, Ivan Hu <ivan.hu@canonical.com>, Jeremy Linton <jeremy.linton@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Robinson <pbrobinson@redhat.com>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Stefan Agner <stefan@agner.ch>
List-Id: linux-efi@vger.kernel.org

From: Aaron Ma <aaron.ma@canonical.com>

EFI GOP uses 64-bit frame buffer address in some BIOS.
Add 64bit address support in efi earlyprintk.

Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
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
2.18.0
