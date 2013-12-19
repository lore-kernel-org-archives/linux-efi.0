From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [RFC PATCH 06/14] rtc-efi: register rtc-efi device when EFI enabled
Date: Thu, 19 Dec 2013 15:51:47 +0800
Message-ID: <1387439515-8926-7-git-send-email-jlee@suse.com>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1387439515-8926-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Alessandro Zummo <a.zummo@towertech.it>, Matt Fleming <matt@console-pimps.org>
Cc: Elliott@hp.com, samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>, werner@suse.com, trenn@suse.de, JBeulich@suse.com, linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com, x86@kernel.org, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, linux-acpi@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>, Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Garrett <matthew.garrett@nebula.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-efi@vger.kernel.org

UEFI time services, GetTime(), SetTime(), GetWakeupTime(), SetWakeupTime() are also
supported by other non-IA64 architecutre with UEFI BIOS, e.g. x86.

This patch changed RTC_DRV_EFI configuration to depend on EFI but not just IA64. It
checks efi_enabled flag and efi-rtc driver should enabled.

Cc: Matt Fleming <matt.fleming@intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jan Beulich <JBeulich@suse.com>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 arch/x86/platform/efi/efi.c |   17 +++++++++++++++++
 drivers/rtc/Kconfig         |    2 +-
 2 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 7a7a692..42d6052 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -42,6 +42,7 @@
 #include <linux/io.h>
 #include <linux/reboot.h>
 #include <linux/bcd.h>
+#include <linux/platform_device.h>
 
 #include <asm/setup.h>
 #include <asm/efi.h>
@@ -876,6 +877,22 @@ void __init efi_enter_virtual_mode(void)
 			 0, NULL);
 }
 
+static struct platform_device rtc_efi_dev = {
+	.name = "rtc-efi",
+	.id = -1,
+};
+
+static int __init rtc_init(void)
+{
+	if (efi_enabled(EFI_RUNTIME_SERVICES) &&
+	    platform_device_register(&rtc_efi_dev) < 0)
+		pr_err("unable to register rtc-efi device...\n");
+
+	/* not necessarily an error */
+	return 0;
+}
+arch_initcall(rtc_init);
+
 /*
  * Convenience functions to obtain memory types and attributes
  */
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 349dbc4..bee13de 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -726,7 +726,7 @@ config RTC_DRV_DA9055
 
 config RTC_DRV_EFI
 	tristate "EFI RTC"
-	depends on IA64
+	depends on EFI
 	help
 	  If you say yes here you will get support for the EFI
 	  Real Time Clock.
-- 
1.6.4.2
