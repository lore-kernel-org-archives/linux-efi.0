From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 1/1] efi/libstub/arm: default EFI_ARMSTUB_DTB_LOADER to y
Date: Tue, 18 Sep 2018 14:36:52 -0700
Message-ID: <20180918213652.5648-2-ard.biesheuvel@linaro.org>
References: <20180918213652.5648-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180918213652.5648-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Scott Branden <scott.branden@broadcom.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Scott Branden <scott.branden@broadcom.com>

Default EFI_ARMSTUB_DTB_LOADER to y to allow the dtb= command
line parameter to function with efi loader.

Required for development purposes and to boot on existing bootloaders
that do not support devicetree provided by the firmware or by the
bootloader.

Fixes: 3d7ee348aa41 ("efi/libstub/arm: Add opt-in Kconfig option ...")
Signed-off-by: Scott Branden <scott.branden@broadcom.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/Kconfig | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index d8e159feb573..89110dfc7127 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -90,14 +90,17 @@ config EFI_ARMSTUB
 config EFI_ARMSTUB_DTB_LOADER
 	bool "Enable the DTB loader"
 	depends on EFI_ARMSTUB
+	default y
 	help
 	  Select this config option to add support for the dtb= command
 	  line parameter, allowing a device tree blob to be loaded into
 	  memory from the EFI System Partition by the stub.
 
-	  The device tree is typically provided by the platform or by
-	  the bootloader, so this option is mostly for development
-	  purposes only.
+	  If the device tree is provided by the platform or by
+	  the bootloader this option may not be needed.
+	  But, for various development reasons and to maintain existing
+	  functionality for bootloaders that do not have such support
+	  this option is necessary.
 
 config EFI_BOOTLOADER_CONTROL
 	tristate "EFI Bootloader Control"
-- 
2.17.1
