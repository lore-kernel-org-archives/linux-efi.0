From: Maksym Kokhan <maksym.kokhan@globallogic.com>
Subject: [PATCH 6/8] arm64: convert to generic builtin command line
Date: Thu, 27 Sep 2018 19:56:48 +0300
Message-ID: <1538067408-5967-1-git-send-email-maksym.kokhan@globallogic.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Daniel Walker <dwalker@fifo99.com>, Daniel Walker <danielwa@cisco.com>, Andrii Bordunov <aborduno@cisco.com>, Ruslan Bilovol <rbilovol@cisco.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Daniel Walker <danielwa@cisco.com>

This updates the arm64 code to use the CONFIG_GENERIC_CMDLINE
option.

Cc: Daniel Walker <dwalker@fifo99.com>
Cc: Daniel Walker <danielwa@cisco.com>
Signed-off-by: Daniel Walker <danielwa@cisco.com>
Signed-off-by: Maksym Kokhan <maksym.kokhan@globallogic.com>
---
 arch/arm64/Kconfig        | 17 +----------------
 arch/arm64/kernel/setup.c |  3 +++
 2 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 1b1a0e9..e596414 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -166,6 +166,7 @@ config ARM64
 	select SWIOTLB
 	select SYSCTL_EXCEPTION_TRACE
 	select THREAD_INFO_IN_TASK
+	select GENERIC_CMDLINE
 	help
 	  ARM 64-bit (AArch64) Linux support.
 
@@ -1231,22 +1232,6 @@ config ARM64_ACPI_PARKING_PROTOCOL
 	  protocol even if the corresponding data is present in the ACPI
 	  MADT table.
 
-config CMDLINE
-	string "Default kernel command string"
-	default ""
-	help
-	  Provide a set of default command-line options at build time by
-	  entering them here. As a minimum, you should specify the the
-	  root device (e.g. root=/dev/nfs).
-
-config CMDLINE_FORCE
-	bool "Always use the default kernel command string"
-	help
-	  Always use the default kernel command string, even if the boot
-	  loader passes other arguments to the kernel.
-	  This is useful if you cannot or don't want to change the
-	  command-line options your boot loader passes to the kernel.
-
 config EFI_STUB
 	bool
 
diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
index 5b4fac4..33b929b 100644
--- a/arch/arm64/kernel/setup.c
+++ b/arch/arm64/kernel/setup.c
@@ -42,6 +42,7 @@
 #include <linux/psci.h>
 #include <linux/sched/task.h>
 #include <linux/mm.h>
+#include <linux/cmdline.h>
 
 #include <asm/acpi.h>
 #include <asm/fixmap.h>
@@ -295,6 +296,8 @@ void __init setup_arch(char **cmdline_p)
 
 	setup_machine_fdt(__fdt_pointer);
 
+	cmdline_add_builtin(boot_command_line, NULL, COMMAND_LINE_SIZE);
+
 	parse_early_param();
 
 	/*
-- 
2.7.4
