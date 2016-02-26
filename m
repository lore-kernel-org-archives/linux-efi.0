From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2] efi: get rid of EFI_SYSTEM_TABLES status bit
Date: Fri, 26 Feb 2016 15:20:34 +0100
Message-ID: <1456496435-12679-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The EFI_SYSTEM_TABLES status bit is set by all EFI supporting architectures
upon discovery of the EFI system table, but the bit is never tested in any
code we have in the tree. So remove it.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/ia64/kernel/efi.c             | 2 --
 arch/x86/platform/efi/efi.c        | 2 --
 drivers/firmware/efi/arm-runtime.c | 1 -
 include/linux/efi.h                | 1 -
 4 files changed, 6 deletions(-)

diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
index caae3f4e4341..e3456698a2a7 100644
--- a/arch/ia64/kernel/efi.c
+++ b/arch/ia64/kernel/efi.c
@@ -531,8 +531,6 @@ efi_init (void)
 	       efi.systab->hdr.revision >> 16,
 	       efi.systab->hdr.revision & 0xffff, vendor);
 
-	set_bit(EFI_SYSTEM_TABLES, &efi.flags);
-
 	palo_phys      = EFI_INVALID_TABLE_ADDR;
 
 	if (efi_config_init(arch_tables) != 0)
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index ad285404ea7f..48dd701dacf6 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -352,8 +352,6 @@ static int __init efi_systab_init(void *phys)
 		       efi.systab->hdr.revision >> 16,
 		       efi.systab->hdr.revision & 0xffff);
 
-	set_bit(EFI_SYSTEM_TABLES, &efi.flags);
-
 	return 0;
 }
 
diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 6ae21e41a429..16c7d2a71156 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -105,7 +105,6 @@ static int __init arm_enable_runtime_services(void)
 		pr_err("Failed to remap EFI System Table\n");
 		return -ENOMEM;
 	}
-	set_bit(EFI_SYSTEM_TABLES, &efi.flags);
 
 	if (!efi_virtmap_init()) {
 		pr_err("No UEFI virtual mapping was installed -- runtime services will not be available\n");
diff --git a/include/linux/efi.h b/include/linux/efi.h
index e747eb08b2be..99bc85f708d4 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -975,7 +975,6 @@ extern int __init efi_setup_pcdp_console(char *);
  * possible, remove EFI-related code altogether.
  */
 #define EFI_BOOT		0	/* Were we booted from EFI? */
-#define EFI_SYSTEM_TABLES	1	/* Can we use EFI system tables? */
 #define EFI_CONFIG_TABLES	2	/* Can we use EFI config tables? */
 #define EFI_RUNTIME_SERVICES	3	/* Can we use runtime services? */
 #define EFI_MEMMAP		4	/* Can we use EFI memory map? */
-- 
2.5.0
