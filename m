From: Maksym Kokhan <maksym.kokhan@globallogic.com>
Subject: [PATCH 5/8] arm: convert to generic builtin command line
Date: Thu, 27 Sep 2018 19:56:33 +0300
Message-ID: <1538067393-5926-1-git-send-email-maksym.kokhan@globallogic.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Russell King <linux@armlinux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Daniel Walker <dwalker@fifo99.com>, Daniel Walker <danielwa@cisco.com>, Andrii Bordunov <aborduno@cisco.com>, Ruslan Bilovol <rbilovol@cisco.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Daniel Walker <danielwa@cisco.com>

This updates the arm 32bit code to use the CONFIG_GENERIC_CMDLINE
option.

Cc: Daniel Walker <dwalker@fifo99.com>
Cc: Daniel Walker <danielwa@cisco.com>
Signed-off-by: Daniel Walker <danielwa@cisco.com>
Signed-off-by: Maksym Kokhan <maksym.kokhan@globallogic.com>
---
 arch/arm/Kconfig              | 38 +-------------------------------------
 arch/arm/kernel/atags_parse.c | 14 ++++----------
 arch/arm/kernel/devtree.c     |  2 ++
 3 files changed, 7 insertions(+), 47 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index e8cd55a..a1dca346d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -38,6 +38,7 @@ config ARM
 	select GENERIC_CLOCKEVENTS_BROADCAST if SMP
 	select GENERIC_CPU_AUTOPROBE
 	select GENERIC_EARLY_IOREMAP
+	select GENERIC_CMDLINE
 	select GENERIC_IDLE_POLL_SETUP
 	select GENERIC_IRQ_PROBE
 	select GENERIC_IRQ_SHOW
@@ -1924,43 +1925,6 @@ config ARM_ATAG_DTB_COMPAT_CMDLINE_EXTEND
 
 endchoice
 
-config CMDLINE
-	string "Default kernel command string"
-	default ""
-	help
-	  On some architectures (EBSA110 and CATS), there is currently no way
-	  for the boot loader to pass arguments to the kernel. For these
-	  architectures, you should supply some command-line options at build
-	  time by entering them here. As a minimum, you should specify the
-	  memory size and the root device (e.g., mem=64M root=/dev/nfs).
-
-choice
-	prompt "Kernel command line type" if CMDLINE != ""
-	default CMDLINE_FROM_BOOTLOADER
-	depends on ATAGS
-
-config CMDLINE_FROM_BOOTLOADER
-	bool "Use bootloader kernel arguments if available"
-	help
-	  Uses the command-line options passed by the boot loader. If
-	  the boot loader doesn't provide any, the default kernel command
-	  string provided in CMDLINE will be used.
-
-config CMDLINE_EXTEND
-	bool "Extend bootloader kernel arguments"
-	help
-	  The command-line arguments provided by the boot loader will be
-	  appended to the default kernel command string.
-
-config CMDLINE_FORCE
-	bool "Always use the default kernel command string"
-	help
-	  Always use the default kernel command string, even if the boot
-	  loader passes other arguments to the kernel.
-	  This is useful if you cannot or don't want to change the
-	  command-line options your boot loader passes to the kernel.
-endchoice
-
 config XIP_KERNEL
 	bool "Kernel Execute-In-Place from ROM"
 	depends on !ARM_LPAE && !ARCH_MULTIPLATFORM
diff --git a/arch/arm/kernel/atags_parse.c b/arch/arm/kernel/atags_parse.c
index c10a3e8..4cf1c5b 100644
--- a/arch/arm/kernel/atags_parse.c
+++ b/arch/arm/kernel/atags_parse.c
@@ -24,6 +24,7 @@
 #include <linux/root_dev.h>
 #include <linux/screen_info.h>
 #include <linux/memblock.h>
+#include <linux/cmdline.h>
 
 #include <asm/setup.h>
 #include <asm/system_info.h>
@@ -32,7 +33,7 @@
 
 #include "atags.h"
 
-static char default_command_line[COMMAND_LINE_SIZE] __initdata = CONFIG_CMDLINE;
+static char default_command_line[COMMAND_LINE_SIZE] __initdata;
 
 #ifndef MEM_SIZE
 #define MEM_SIZE	(16*1024*1024)
@@ -124,16 +125,9 @@ __tagtable(ATAG_REVISION, parse_tag_revision);
 
 static int __init parse_tag_cmdline(const struct tag *tag)
 {
-#if defined(CONFIG_CMDLINE_EXTEND)
-	strlcat(default_command_line, " ", COMMAND_LINE_SIZE);
 	strlcat(default_command_line, tag->u.cmdline.cmdline,
 		COMMAND_LINE_SIZE);
-#elif defined(CONFIG_CMDLINE_FORCE)
-	pr_warn("Ignoring tag cmdline (using the default kernel command line)\n");
-#else
-	strlcpy(default_command_line, tag->u.cmdline.cmdline,
-		COMMAND_LINE_SIZE);
-#endif
+
 	return 0;
 }
 
@@ -228,7 +222,7 @@ setup_machine_tags(phys_addr_t __atags_pointer, unsigned int machine_nr)
 	}
 
 	/* parse_early_param needs a boot_command_line */
-	strlcpy(boot_command_line, from, COMMAND_LINE_SIZE);
+	cmdline_add_builtin(boot_command_line, from, COMMAND_LINE_SIZE);
 
 	return mdesc;
 }
diff --git a/arch/arm/kernel/devtree.c b/arch/arm/kernel/devtree.c
index ecaa68d..85442b5 100644
--- a/arch/arm/kernel/devtree.c
+++ b/arch/arm/kernel/devtree.c
@@ -19,6 +19,7 @@
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
 #include <linux/smp.h>
+#include <linux/cmdline.h>
 
 #include <asm/cputype.h>
 #include <asm/setup.h>
@@ -258,6 +259,7 @@ const struct machine_desc * __init setup_machine_fdt(unsigned int dt_phys)
 		mdesc->dt_fixup();
 
 	early_init_dt_scan_nodes();
+	cmdline_add_builtin(boot_command_line, NULL, COMMAND_LINE_SIZE);
 
 	/* Change machine number to match the mdesc we're using */
 	__machine_arch_type = mdesc->nr;
-- 
2.7.4
