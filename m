From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 03/24] efi: Lock down the kernel if booted in secure boot
 mode
Date: Wed, 05 Apr 2017 18:10:22 +0100
Message-ID: <149141222203.31282.13064649683905796284.stgit@warthog.procyon.org.uk>
References: <149141219387.31282.6648284836568938717.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <149141219387.31282.6648284836568938717.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

UEFI Secure Boot provides a mechanism for ensuring that the firmware will
only load signed bootloaders and kernels.  Certain use cases may also
require that all kernel modules also be signed.  Add a configuration option
that to lock down the kernel - which includes requiring validly signed
modules - if the kernel is secure-booted.

Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---

 arch/x86/Kconfig        |   12 ++++++++++++
 arch/x86/kernel/setup.c |    8 +++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cc98d5a294ee..21f39855661d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1817,6 +1817,18 @@ config EFI_MIXED
 
 	   If unsure, say N.
 
+config EFI_SECURE_BOOT_LOCK_DOWN
+	def_bool n
+	depends on EFI
+	prompt "Lock down the kernel when UEFI Secure Boot is enabled"
+	---help---
+	  UEFI Secure Boot provides a mechanism for ensuring that the firmware
+	  will only load signed bootloaders and kernels.  Certain use cases may
+	  also require that all kernel modules also be signed and that
+	  userspace is prevented from directly changing the running kernel
+	  image.  Say Y here to automatically lock down the kernel when a
+	  system boots with UEFI Secure Boot enabled.
+
 config SECCOMP
 	def_bool y
 	prompt "Enable seccomp to safely compute untrusted bytecode"
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 396285bddb93..85dfa745c442 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -69,6 +69,7 @@
 #include <linux/crash_dump.h>
 #include <linux/tboot.h>
 #include <linux/jiffies.h>
+#include <linux/security.h>
 
 #include <video/edid.h>
 
@@ -1185,7 +1186,12 @@ void __init setup_arch(char **cmdline_p)
 			break;
 		case efi_secureboot_mode_enabled:
 			set_bit(EFI_SECURE_BOOT, &efi.flags);
-			pr_info("Secure boot enabled\n");
+			if (IS_ENABLED(CONFIG_EFI_SECURE_BOOT_LOCK_DOWN)) {
+				lock_kernel_down();
+				pr_info("Secure boot enabled and kernel locked down\n");
+			} else {
+				pr_info("Secure boot enabled\n");
+			}
 			break;
 		default:
 			pr_info("Secure boot could not be determined\n");
