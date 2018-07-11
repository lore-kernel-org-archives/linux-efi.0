From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 6/8] efi/libstub/arm: add opt-in Kconfig option for the DTB loader
Date: Wed, 11 Jul 2018 11:40:38 +0200
Message-ID: <20180711094040.12506-7-ard.biesheuvel@linaro.org>
References: <20180711094040.12506-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180711094040.12506-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

There are various ways a platform can provide a device tree binary
to the kernel, with different levels of sophistication:
- ideally, the UEFI firmware, which is tightly coupled with the
  platform, provides a device tree image directly as a UEFI
  configuration table, and typically permits the contents to be
  manipulated either via menu options or via UEFI environment
  variables that specify a replacement image,
- GRUB for ARM has a 'devicetree' directive which allows a device
  tree image to be loaded from any location accessible to GRUB, and
  supersede the one provided by the firmware,
- the EFI stub implements a dtb= command line option that allows a
  device tree image to be loaded from a file residing in the same
  file system as the one the kernel image was loaded from.

The dtb= command line option was never intended to be more than a
development feature, to allow the other options to be implemented
in parallel. So let's make it an opt-in feature that is disabled
by default, but can be re-enabled at will.

Note that we already disable the dtb= command line option when we
detect that we are running with UEFI Secure Boot enabled.

Acked-by: Leif Lindholm <leif.lindholm@linaro.org>
Reviewed-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/Kconfig            | 12 ++++++++++++
 drivers/firmware/efi/libstub/arm-stub.c |  7 ++++---
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 781a4a337557..fc1cb2961d5b 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -87,6 +87,18 @@ config EFI_RUNTIME_WRAPPERS
 config EFI_ARMSTUB
 	bool
 
+config EFI_ARMSTUB_DTB_LOADER
+	bool "Enable the DTB loader"
+	depends on EFI_ARMSTUB
+	help
+	  Select this config option to add support for the dtb= command
+	  line parameter, allowing a device tree blob to be loaded into
+	  memory from the EFI System Partition by the stub.
+
+	  The device tree is typically provided by the platform or by
+	  the bootloader, and so this option is mostly for development
+	  purposes only.
+
 config EFI_BOOTLOADER_CONTROL
 	tristate "EFI Bootloader Control"
 	depends on EFI_VARS
diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 01a9d78ee415..c98b1856fc3d 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -202,9 +202,10 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 	 * 'dtb=' unless UEFI Secure Boot is disabled.  We assume that secure
 	 * boot is enabled if we can't determine its state.
 	 */
-	if (secure_boot != efi_secureboot_mode_disabled &&
-	    strstr(cmdline_ptr, "dtb=")) {
-		pr_efi(sys_table, "Ignoring DTB from command line.\n");
+	if (!IS_ENABLED(CONFIG_EFI_ARMSTUB_DTB_LOADER) ||
+	     secure_boot != efi_secureboot_mode_disabled) {
+		if (strstr(cmdline_ptr, "dtb="))
+			pr_efi(sys_table, "Ignoring DTB from command line.\n");
 	} else {
 		status = handle_cmdline_files(sys_table, image, cmdline_ptr,
 					      "dtb=",
-- 
2.17.1
