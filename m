From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [PATCH] x86: remove unused efi_get_time function
Date: Fri, 17 Jun 2016 16:56:58 +0200
Message-ID: <20160617145713.3737965-1-arnd@arndb.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Nothing calls the efi_get_time function on x86, but it does suffer
from the 32-bit time_t overflow in 2038.

This removes the function, we can always put it back in case we need
it later.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
 arch/x86/platform/efi/efi.c | 15 ---------------
 include/linux/efi.h         |  1 -
 2 files changed, 16 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 56400d03409f..105e34747116 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -97,21 +97,6 @@ static efi_status_t __init phys_efi_set_virtual_address_map(
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
index acb6adace01e..a402a527592f 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -975,7 +975,6 @@ extern u64 efi_mem_desc_end(efi_memory_desc_t *md);
 extern int efi_mem_desc_lookup(u64 phys_addr, efi_memory_desc_t *out_md);
 extern void efi_initialize_iomem_resources(struct resource *code_resource,
 		struct resource *data_resource, struct resource *bss_resource);
-extern void efi_get_time(struct timespec *now);
 extern void efi_reserve_boot_services(void);
 extern int efi_get_fdt_params(struct efi_fdt_params *params);
 extern struct kobject *efi_kobj;
-- 
2.9.0
