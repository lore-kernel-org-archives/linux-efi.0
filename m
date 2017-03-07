From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] EFI fixes
Date: Tue, 7 Mar 2017 21:21:08 +0100
Message-ID: <20170307202107.GA7091@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Linus,

Please pull the latest efi-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git efi-urgent-for-linus

   # HEAD: d1eb98143c56f24fef125f5bbed49ae0b52fb7d6 efi/arm: Fix boot crash with CONFIG_CPUMASK_OFFSTACK=y

A boot crash fix, and a secure boot related boot messages fix.

 Thanks,

	Ingo

------------------>
Ard Biesheuvel (2):
      efi/libstub: Treat missing SecureBoot variable as Secure Boot disabled
      efi/arm: Fix boot crash with CONFIG_CPUMASK_OFFSTACK=y


 drivers/firmware/efi/arm-runtime.c        | 1 +
 drivers/firmware/efi/libstub/secureboot.c | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 349dc3e1e52e..974c5a31a005 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -65,6 +65,7 @@ static bool __init efi_virtmap_init(void)
 	bool systab_found;
 
 	efi_mm.pgd = pgd_alloc(&efi_mm);
+	mm_init_cpumask(&efi_mm);
 	init_new_context(NULL, &efi_mm);
 
 	systab_found = false;
diff --git a/drivers/firmware/efi/libstub/secureboot.c b/drivers/firmware/efi/libstub/secureboot.c
index 6def402bf569..5da36e56b36a 100644
--- a/drivers/firmware/efi/libstub/secureboot.c
+++ b/drivers/firmware/efi/libstub/secureboot.c
@@ -45,6 +45,8 @@ enum efi_secureboot_mode efi_get_secureboot(efi_system_table_t *sys_table_arg)
 	size = sizeof(secboot);
 	status = get_efi_var(efi_SecureBoot_name, &efi_variable_guid,
 			     NULL, &size, &secboot);
+	if (status == EFI_NOT_FOUND)
+		return efi_secureboot_mode_disabled;
 	if (status != EFI_SUCCESS)
 		goto out_efi_err;
 
@@ -78,7 +80,5 @@ enum efi_secureboot_mode efi_get_secureboot(efi_system_table_t *sys_table_arg)
 
 out_efi_err:
 	pr_efi_err(sys_table_arg, "Could not determine UEFI Secure Boot status.\n");
-	if (status == EFI_NOT_FOUND)
-		return efi_secureboot_mode_disabled;
 	return efi_secureboot_mode_unknown;
 }
