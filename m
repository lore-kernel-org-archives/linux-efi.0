From: Scott Branden <scott.branden@broadcom.com>
Subject: [PATCH] efi/libstub/arm: default EFI_ARMSTUB_DTB_LOADER to y
Date: Tue, 11 Sep 2018 13:26:38 -0700
Message-ID: <1536697598-3692-1-git-send-email-scott.branden@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, leif.lindholm@linaro.org, agraf@suse.de, Scott Branden <scott.branden@broadcom.com>
List-Id: linux-efi@vger.kernel.org

Default EFI_ARMSTUB_DTB_LOADER to y to allow the dtb= command
line parameter to function with efi loader.

Required for development purposes and to boot on existing bootloaders
that do not support devicetree provided by the platform or by the bootloader.

Fixes: 3d7ee348aa41 ("efi/libstub/arm: Add opt-in Kconfig option for the DTB loader")
Signed-off-by: Scott Branden <scott.branden@broadcom.com>
---
 drivers/firmware/efi/Kconfig | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index d8e159f..0a84d01 100644
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
2.5.0
