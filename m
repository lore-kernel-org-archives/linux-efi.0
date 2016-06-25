From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 7/7] x86/efi: Remove unused efi_get_time function
Date: Sat, 25 Jun 2016 08:20:30 +0100
Message-ID: <1466839230-12781-8-git-send-email-matt@codeblueprint.co.uk>
References: <1466839230-12781-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466839230-12781-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>

Nothing calls the efi_get_time function on x86, but it does suffer
from the 32-bit time_t overflow in 2038.

This removes the function, we can always put it back in case we need
it later.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Acked-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 arch/x86/platform/efi/efi.c | 15 ---------------
 include/linux/efi.h         |  1 -
 2 files changed, 16 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index f93545e7dc54..d898b334ff46 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -98,21 +98,6 @@ static efi_status_t __init phys_efi_set_virtual_address_map(
 	return status;
 }
 
-void efi_get_time(struct timespec *now)
-{
-	efi_status_t status;
-	efi_time_t eft;
-	efi_time_cap_t cap;
-
-	status = efi.get_time(&eft, &cap);
-	if (status != EFI_SUCCESS)
-		pr_err("Oops: efitime: can't read time!\n");
-
-	now->tv_sec = mktime(eft.year, eft.month, eft.day, eft.hour,
-			     eft.minute, eft.second);
-	now->tv_nsec = 0;
-}
-
 void __init efi_find_mirror(void)
 {
 	efi_memory_desc_t *md;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index a5f6f75936eb..d4687122383e 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -990,7 +990,6 @@ extern u64 efi_mem_desc_end(efi_memory_desc_t *md);
 extern int efi_mem_desc_lookup(u64 phys_addr, efi_memory_desc_t *out_md);
 extern void efi_initialize_iomem_resources(struct resource *code_resource,
 		struct resource *data_resource, struct resource *bss_resource);
-extern void efi_get_time(struct timespec *now);
 extern void efi_reserve_boot_services(void);
 extern int efi_get_fdt_params(struct efi_fdt_params *params);
 extern struct kobject *efi_kobj;
-- 
2.7.3
