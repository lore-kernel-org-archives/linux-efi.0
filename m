From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 30/30] efi: Lock down the kernel if booted in secure boot mode
Date: Thu,  9 Nov 2017 17:34:27 +0000
Message-ID: <151024886689.28329.1546645765141944290.stgit@warthog.procyon.org.uk>
References: <151024863544.28329.2436580122759221600.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <151024863544.28329.2436580122759221600.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

UEFI Secure Boot provides a mechanism for ensuring that the firmware will
only load signed bootloaders and kernels.  Certain use cases may also
require that all kernel modules also be signed.  Add a configuration option
that to lock down the kernel - which includes requiring validly signed
modules - if the kernel is secure-booted.

Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Acked-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---

 arch/x86/kernel/setup.c |    6 ++++--
 security/Kconfig        |   14 ++++++++++++++
 security/lock_down.c    |    1 +
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 7c2162f9e769..4e38327efb2e 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -64,6 +64,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/ctype.h>
 #include <linux/uaccess.h>
+#include <linux/security.h>
 
 #include <linux/percpu.h>
 #include <linux/crash_dump.h>
@@ -1039,6 +1040,9 @@ void __init setup_arch(char **cmdline_p)
 	if (efi_enabled(EFI_BOOT))
 		efi_init();
 
+	efi_set_secure_boot(boot_params.secure_boot);
+	init_lockdown();
+
 	dmi_scan_machine();
 	dmi_memdev_walk();
 	dmi_set_dump_stack_arch_desc();
@@ -1197,8 +1201,6 @@ void __init setup_arch(char **cmdline_p)
 	/* Allocate bigger log buffer */
 	setup_log_buf(1);
 
-	efi_set_secure_boot(boot_params.secure_boot);
-
 	reserve_initrd();
 
 	acpi_table_upgrade();
diff --git a/security/Kconfig b/security/Kconfig
index 1e997be94ba2..a4fa8b826039 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -222,6 +222,20 @@ config ALLOW_LOCKDOWN_LIFT_BY_SYSRQ
 	  Allow the lockdown on a kernel to be lifted, by pressing a SysRq key
 	  combination on a wired keyboard.
 
+config LOCK_DOWN_IN_EFI_SECURE_BOOT
+	bool "Lock down the kernel in EFI Secure Boot mode"
+	default n
+	select LOCK_DOWN_KERNEL
+	depends on EFI
+	help
+	  UEFI Secure Boot provides a mechanism for ensuring that the firmware
+	  will only load signed bootloaders and kernels.  Secure boot mode may
+	  be determined from EFI variables provided by the system firmware if
+	  not indicated by the boot parameters.
+
+	  Enabling this option turns on results in kernel lockdown being
+	  triggered if EFI Secure Boot is set.
+
 
 source security/selinux/Kconfig
 source security/smack/Kconfig
diff --git a/security/lock_down.c b/security/lock_down.c
index 2c6b00f0c229..527f7e51dc8d 100644
--- a/security/lock_down.c
+++ b/security/lock_down.c
@@ -12,6 +12,7 @@
 #include <linux/security.h>
 #include <linux/export.h>
 #include <linux/sysrq.h>
+#include <linux/efi.h>
 #include <asm/setup.h>
 
 #ifdef CONFIG_ALLOW_LOCKDOWN_LIFT_BY_SYSRQ
