From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 13/13] efi: arm: enable DMI/SMBIOS
Date: Fri,  2 Jun 2017 13:52:07 +0000
Message-ID: <20170602135207.21708-14-ard.biesheuvel@linaro.org>
References: <20170602135207.21708-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170602135207.21708-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

Wire up the existing arm64 support for SMBIOS tables (aka DMI) for ARM as
well, by moving the arm64 init code to drivers/firmware/efi/arm-runtime.c
(which is shared between ARM and arm64), and adding a asm/dmi.h header to
ARM that defines the mapping routines for the firmware tables.

This allows userspace to access these tables to discover system information
exposed by the firmware. It also sets the hardware name used in crash
dumps, e.g.,

  Unable to handle kernel NULL pointer dereference at virtual address 00000000
  pgd = ed3c0000
  [00000000] *pgd=bf1f3835
  Internal error: Oops: 817 [#1] SMP THUMB2
  Modules linked in:
  CPU: 0 PID: 759 Comm: bash Not tainted 4.10.0-09601-g0e8f38792120-dirty #112
  Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
  ^^^

NOTE: This does *NOT* enable or encourage the use of DMI quirks, i.e., the
      the practice of identifying the platform via DMI to decide whether
      certain workarounds for buggy hardware and/or firmware need to be
      enabled. This would require the DMI subsystem to be enabled much
      earlier than we do on ARM, which is non-trivial.

Cc: Matt Fleming <matt@codeblueprint.co.uk>
Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/Kconfig                   | 17 +++++++++++++++++
 arch/arm/include/asm/dmi.h         | 19 +++++++++++++++++++
 arch/arm64/kernel/efi.c            | 15 ---------------
 drivers/firmware/efi/arm-runtime.c | 16 ++++++++++++++++
 4 files changed, 52 insertions(+), 15 deletions(-)
 create mode 100644 arch/arm/include/asm/dmi.h

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 4c1a35f15838..dabcaeb2ee3e 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -2061,6 +2061,23 @@ config EFI
 	  is only useful for kernels that may run on systems that have
 	  UEFI firmware.
 
+config DMI
+	bool "Enable support for SMBIOS (DMI) tables"
+	depends on EFI
+	default y
+	help
+	  This enables SMBIOS/DMI feature for systems.
+
+	  This option is only useful on systems that have UEFI firmware.
+	  However, even with this option, the resultant kernel should
+	  continue to boot on existing non-UEFI platforms.
+
+	  NOTE: This does *NOT* enable or encourage the use of DMI quirks,
+	  i.e., the the practice of identifying the platform via DMI to
+	  decide whether certain workarounds for buggy hardware and/or
+	  firmware need to be enabled. This would require the DMI subsystem
+	  to be enabled much earlier than we do on ARM, which is non-trivial.
+
 endmenu
 
 menu "CPU Power Management"
diff --git a/arch/arm/include/asm/dmi.h b/arch/arm/include/asm/dmi.h
new file mode 100644
index 000000000000..df2d2ff06f5b
--- /dev/null
+++ b/arch/arm/include/asm/dmi.h
@@ -0,0 +1,19 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_DMI_H
+#define __ASM_DMI_H
+
+#include <linux/io.h>
+#include <linux/slab.h>
+
+#define dmi_early_remap(x, l)		memremap(x, l, MEMREMAP_WB)
+#define dmi_early_unmap(x, l)		memunmap(x)
+#define dmi_remap(x, l)			memremap(x, l, MEMREMAP_WB)
+#define dmi_unmap(x)			memunmap(x)
+#define dmi_alloc(l)			kzalloc(l, GFP_KERNEL)
+
+#endif
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 5d17f377d905..82cd07592519 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -11,7 +11,6 @@
  *
  */
 
-#include <linux/dmi.h>
 #include <linux/efi.h>
 #include <linux/init.h>
 
@@ -117,20 +116,6 @@ int __init efi_set_mapping_permissions(struct mm_struct *mm,
 				   set_permissions, md);
 }
 
-static int __init arm64_dmi_init(void)
-{
-	/*
-	 * On arm64, DMI depends on UEFI, and dmi_scan_machine() needs to
-	 * be called early because dmi_id_init(), which is an arch_initcall
-	 * itself, depends on dmi_scan_machine() having been called already.
-	 */
-	dmi_scan_machine();
-	if (dmi_available)
-		dmi_set_dump_stack_arch_desc();
-	return 0;
-}
-core_initcall(arm64_dmi_init);
-
 /*
  * UpdateCapsule() depends on the system being shutdown via
  * ResetSystem().
diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 974c5a31a005..1cc41c3d6315 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -11,6 +11,7 @@
  *
  */
 
+#include <linux/dmi.h>
 #include <linux/efi.h>
 #include <linux/io.h>
 #include <linux/memblock.h>
@@ -166,3 +167,18 @@ void efi_virtmap_unload(void)
 	efi_set_pgd(current->active_mm);
 	preempt_enable();
 }
+
+
+static int __init arm_dmi_init(void)
+{
+	/*
+	 * On arm64/ARM, DMI depends on UEFI, and dmi_scan_machine() needs to
+	 * be called early because dmi_id_init(), which is an arch_initcall
+	 * itself, depends on dmi_scan_machine() having been called already.
+	 */
+	dmi_scan_machine();
+	if (dmi_available)
+		dmi_set_dump_stack_arch_desc();
+	return 0;
+}
+core_initcall(arm_dmi_init);
-- 
2.9.3
