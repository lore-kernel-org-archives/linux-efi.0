From: Vincent Legoll <vincent.legoll@gmail.com>
Subject: [PATCH] efi: make EFI a menuconfig to ease disabling it all
Date: Sat, 16 Dec 2017 11:46:54 +0100
Message-ID: <20171216104654.10790-2-vincent.legoll@gmail.com>
References: <f1007c70-caa4-8ca9-3d52-532e4302cc6e@gmail.com>
 <20171216104654.10790-1-vincent.legoll@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171216104654.10790-1-vincent.legoll@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kees Cook <keescook@chromium.org>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Vincent Legoll <vincent.legoll@gmail.com>
List-Id: linux-efi@vger.kernel.org

No need to get into the submenu to disable all related
config entries.

This makes it easier to disable all EFI config options
without entering the submenu. It will also enable one
to see that en/dis-abled state from the outside menu.

This is only intended to change menuconfig UI, not change
the config dependencies.

v2: added "default y" to menuconfig to avoid breaking existing
configs.

Signed-off-by: Vincent Legoll <vincent.legoll@gmail.com>
---
 drivers/firmware/efi/Kconfig | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 2b4c39fdfa91..2ad237b24afb 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -1,5 +1,9 @@
-menu "EFI (Extensible Firmware Interface) Support"
+menuconfig EFI_MENU
+	bool "EFI (Extensible Firmware Interface) Support"
 	depends on EFI
+	default y
+
+if EFI_MENU
 
 config EFI_VARS
 	tristate "EFI Variable Support via sysfs"
@@ -81,9 +85,6 @@ config EFI_PARAMS_FROM_FDT
 	  the EFI runtime support gets system table address, memory
           map address, and other parameters from the device tree.
 
-config EFI_RUNTIME_WRAPPERS
-	bool
-
 config EFI_ARMSTUB
 	bool
 
@@ -161,7 +162,10 @@ config RESET_ATTACK_MITIGATION
 	  still contains secrets in RAM, booting another OS and extracting the
 	  secrets.
 
-endmenu
+endif # EFI_MENU
+
+config EFI_RUNTIME_WRAPPERS
+	bool
 
 config UEFI_CPER
 	bool
-- 
2.14.1
