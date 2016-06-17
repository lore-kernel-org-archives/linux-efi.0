From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [PATCH] x86: fix unused efi_get_time function
Date: Fri, 17 Jun 2016 16:51:29 +0200
Message-ID: <20160617145152.3569706-1-arnd@arndb.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: y2038-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Nothing calls the efi_get_time function on x86, but it does suffer
from the 32-bit time_t overflow in 2038.

To avoid that if anyone starts calling it, this changes the function
to use timespec64 and mktime64 instead.

Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
The obvious alternative would be to remove the function, I'll send
that patch as well, so you can pick one or the other.

 arch/x86/platform/efi/efi.c | 6 +++---
 include/linux/efi.h         | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 56400d03409f..d72d5de02f61 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -97,7 +97,7 @@ static efi_status_t __init phys_efi_set_virtual_address_map(
 	return status;
 }
 
-void efi_get_time(struct timespec *now)
+void efi_get_time(struct timespec64 *now)
 {
 	efi_status_t status;
 	efi_time_t eft;
@@ -107,8 +107,8 @@ void efi_get_time(struct timespec *now)
 	if (status != EFI_SUCCESS)
 		pr_err("Oops: efitime: can't read time!\n");
 
-	now->tv_sec = mktime(eft.year, eft.month, eft.day, eft.hour,
-			     eft.minute, eft.second);
+	now->tv_sec = mktime64(eft.year, eft.month, eft.day, eft.hour,
+			       eft.minute, eft.second);
 	now->tv_nsec = 0;
 }
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index acb6adace01e..dca8810d6b49 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -975,7 +975,7 @@ extern u64 efi_mem_desc_end(efi_memory_desc_t *md);
 extern int efi_mem_desc_lookup(u64 phys_addr, efi_memory_desc_t *out_md);
 extern void efi_initialize_iomem_resources(struct resource *code_resource,
 		struct resource *data_resource, struct resource *bss_resource);
-extern void efi_get_time(struct timespec *now);
+extern void efi_get_time(struct timespec64 *now);
 extern void efi_reserve_boot_services(void);
 extern int efi_get_fdt_params(struct efi_fdt_params *params);
 extern struct kobject *efi_kobj;
-- 
2.9.0
