From: David Howells <dhowells@redhat.com>
Subject: [PATCH 04/16] efi: Lock down the kernel if booted in secure boot
 mode
Date: Wed, 16 Nov 2016 21:47:45 +0000
Message-ID: <147933286579.19316.5236862894522647474.stgit@warthog.procyon.org.uk>
References: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <147933283664.19316.12454053022687659937.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: keyrings@vger.kernel.org
Cc: dhowells@redhat.com, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

UEFI Secure Boot provides a mechanism for ensuring that the firmware will
only load signed bootloaders and kernels.  Certain use cases may also
require that all kernel modules also be signed.  Add a configuration option
that to lock down the kernel - which includes requiring validly signed
modules - if the kernel is secure-booted.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/x86/Kconfig        |   12 ++++++++++++
 arch/x86/kernel/setup.c |    7 +++++++
 kernel/module.c         |    2 +-
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index bada636d1065..5b19997d88d0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1786,6 +1786,18 @@ config EFI_MIXED
 
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
index 9c337b0e8ba7..9521acce8378 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -69,6 +69,7 @@
 #include <linux/crash_dump.h>
 #include <linux/tboot.h>
 #include <linux/jiffies.h>
+#include <linux/security.h>
 
 #include <video/edid.h>
 
@@ -1160,6 +1161,12 @@ void __init setup_arch(char **cmdline_p)
 
 	io_delay_init();
 
+	if (boot_params.secure_boot &&
+	    IS_ENABLED(CONFIG_EFI_SECURE_BOOT_LOCK_DOWN)) {
+		lock_kernel_down();
+		pr_info("Secure boot enabled\n");
+	}
+
 	/*
 	 * Parse the ACPI tables for possible boot-time SMP configuration.
 	 */
diff --git a/kernel/module.c b/kernel/module.c
index f57dd63186e6..2a021c340efd 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2744,7 +2744,7 @@ static int module_sig_check(struct load_info *info, int flags)
 	}
 
 	/* Not having a signature is only an error if we're strict. */
-	if (err == -ENOKEY && !sig_enforce)
+	if (err == -ENOKEY && !sig_enforce && !kernel_is_locked_down())
 		err = 0;
 
 	return err;

