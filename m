From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] efi: x86: make "efi facility" use slightly more generic
Date: Tue, 14 Jan 2014 17:41:25 +0000
Message-ID: <1389721285-32390-1-git-send-email-leif.lindholm@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Currently, efi_enabled() is defined to be a dummy macro always returning
1 unless CONFIG_X86. Change this logic to use a
CONFIG_ARCH_USES_EFI_FACILITY to enable use by other architectures.

Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/x86/Kconfig             |    1 +
 drivers/firmware/efi/Kconfig |    3 +++
 include/linux/efi.h          |    2 +-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 50e1eab..8c0520d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1582,6 +1582,7 @@ config EFI
 	bool "EFI runtime service support"
 	depends on ACPI
 	select UCS2_STRING
+	select ARCH_USES_EFI_FACILITY
 	---help---
 	  This enables the kernel to use EFI runtime services that are
 	  available (such as the EFI variable services).
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 6aecbc8..1053c8f 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -40,3 +40,6 @@ endmenu
 
 config UEFI_CPER
 	bool
+
+config ARCH_USES_EFI_FACILITY
+	bool
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 11ce678..b74c8a5 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -655,7 +655,7 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_64BIT		5	/* Is the firmware 64-bit? */
 
 #ifdef CONFIG_EFI
-# ifdef CONFIG_X86
+# ifdef CONFIG_ARCH_USES_EFI_FACILITY
 extern int efi_enabled(int facility);
 # else
 static inline int efi_enabled(int facility)
-- 
1.7.10.4
