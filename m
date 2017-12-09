From: Vincent Legoll <vincent.legoll-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] efi: make EFI a menuconfig to ease disabling it all
Date: Sat,  9 Dec 2017 16:52:52 +0100
Message-ID: <20171209155252.6403-1-vincent.legoll@gmail.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Vincent Legoll <vincent.legoll-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

No need to get into the submenu to disable all related
config entries.

This makes it easier to disable all EFI config options
without entering the submenu. It will also enable one
to see that en/dis-abled state from the outside menu.

This is only intended to change menuconfig UI, not change
the config dependencies.

Signed-off-by: Vincent Legoll <vincent.legoll-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efi/Kconfig | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 2b4c39fdfa91..8727b1aa8ef6 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -1,6 +1,9 @@
-menu "EFI (Extensible Firmware Interface) Support"
+menuconfig EFI_MENU
+	bool "EFI (Extensible Firmware Interface) Support"
 	depends on EFI
 
+if EFI_MENU
+
 config EFI_VARS
 	tristate "EFI Variable Support via sysfs"
 	depends on EFI
@@ -81,9 +84,6 @@ config EFI_PARAMS_FROM_FDT
 	  the EFI runtime support gets system table address, memory
           map address, and other parameters from the device tree.
 
-config EFI_RUNTIME_WRAPPERS
-	bool
-
 config EFI_ARMSTUB
 	bool
 
@@ -161,7 +161,10 @@ config RESET_ATTACK_MITIGATION
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
