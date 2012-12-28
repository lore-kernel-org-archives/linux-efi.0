From: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/3] rtc-efi: register rtc-efi device when EFI enabled
Date: Sat, 29 Dec 2012 00:26:39 +0800
Message-ID: <1356712001-12198-1-git-send-email-jlee@suse.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

UEFI time services, GetTime(), SetTime(), GetWakeupTime(), SetWakeupTime() are also
supported by other non-IA64 architecutre with UEFI BIOS, e.g. x86.

This patch changed RTC_DRV_EFI configuration to depend on EFI but not just IA64. It
checks efi_enabled flag and efi-rtc driver should enabled.

Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
---
 arch/x86/platform/efi/efi.c |   20 ++++++++++++++++++++
 drivers/rtc/Kconfig         |    2 +-
 2 files changed, 21 insertions(+), 1 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index ad44391..f08d28b 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -41,6 +41,9 @@
 #include <linux/io.h>
 #include <linux/reboot.h>
 #include <linux/bcd.h>
+#if (defined CONFIG_RTC_DRV_EFI || defined CONFIG_RTC_DRV_EFI_MODULE)
+#include <linux/platform_device.h>
+#endif
 
 #include <asm/setup.h>
 #include <asm/efi.h>
@@ -961,6 +964,23 @@ void __init efi_enter_virtual_mode(void)
 	kfree(new_memmap);
 }
 
+#if (defined CONFIG_RTC_DRV_EFI || defined CONFIG_RTC_DRV_EFI_MODULE)
+static struct platform_device rtc_efi_dev = {
+	.name = "rtc-efi",
+	.id = -1,
+};
+
+static int __init rtc_init(void)
+{
+	if (efi_enabled && platform_device_register(&rtc_efi_dev) < 0)
+		pr_err("unable to register rtc-efi device...\n");
+
+	/* not necessarily an error */
+	return 0;
+}
+arch_initcall(rtc_init);
+#endif
+
 /*
  * Convenience functions to obtain memory types and attributes
  */
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index d0cea02..7796f0a 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -621,7 +621,7 @@ config RTC_DRV_DA9055
 
 config RTC_DRV_EFI
 	tristate "EFI RTC"
-	depends on IA64
+	depends on EFI
 	help
 	  If you say yes here you will get support for the EFI
 	  Real Time Clock.
-- 
1.6.4.2
