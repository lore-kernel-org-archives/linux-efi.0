From: David Howells <dhowells@redhat.com>
Subject: [PATCH 4/5] efi: Lock down the kernel if booted in secure boot mode
Date: Thu, 06 Apr 2017 13:50:20 +0100
Message-ID: <149148302052.3427.16543191336748545619.stgit@warthog.procyon.org.uk>
References: <149148299794.3427.549144000807596903.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <149148299794.3427.549144000807596903.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: ard.biesheuvel@linaro.org
Cc: dhowells@redhat.com, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

UEFI Secure Boot provides a mechanism for ensuring that the firmware will
only load signed bootloaders and kernels.  Certain use cases may also
require that all kernel modules also be signed.  Add a configuration option
that to lock down the kernel - which includes requiring validly signed
modules - if the kernel is secure-booted.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-efi@vger.kernel.org
---

 drivers/firmware/efi/Kconfig       |    1 +
 drivers/firmware/efi/secure_boot.c |   10 +++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 4b902ffbfcf4..6da8345d8c49 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -87,6 +87,7 @@ config EFI_RUNTIME_WRAPPERS
 config EFI_SECURE_BOOT
 	bool "Support UEFI Secure Boot and lock down the kernel in secure boot mode"
 	default n
+	select LOCK_DOWN_KERNEL
 	help
 	  UEFI Secure Boot provides a mechanism for ensuring that the firmware
 	  will only load signed bootloaders and kernels.  Secure boot mode may
diff --git a/drivers/firmware/efi/secure_boot.c b/drivers/firmware/efi/secure_boot.c
index 730518061a14..7292a3b832e3 100644
--- a/drivers/firmware/efi/secure_boot.c
+++ b/drivers/firmware/efi/secure_boot.c
@@ -12,6 +12,7 @@
 #include <linux/efi.h>
 #include <linux/kernel.h>
 #include <linux/printk.h>
+#include <linux/security.h>
 
 /*
  * Decide what to do when UEFI secure boot mode is enabled.
@@ -23,10 +24,17 @@ void __init efi_set_secure_boot(enum efi_secureboot_mode mode)
 		case efi_secureboot_mode_disabled:
 			pr_info("Secure boot disabled\n");
 			break;
+
 		case efi_secureboot_mode_enabled:
 			set_bit(EFI_SECURE_BOOT, &efi.flags);
-			pr_info("Secure boot enabled\n");
+			if (IS_ENABLED(CONFIG_LOCK_DOWN_KERNEL)) {
+				lock_kernel_down();
+				pr_info("Secure boot enabled and kernel locked down\n");
+			} else {
+				pr_info("Secure boot enabled\n");
+			}
 			break;
+
 		default:
 			pr_info("Secure boot could not be determined\n");
 			break;
