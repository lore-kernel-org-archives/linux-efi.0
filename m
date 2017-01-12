From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/4] efi/x86: move efi_print_memmap to drivers/firmware/efi/memmap.c
Date: Thu, 12 Jan 2017 17:41:21 +0800
Message-ID: <20170112094214.964092881@redhat.com>
References: <20170112094118.815108042@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=efi-add-print-memmap.patch
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, mika.penttila-MRsr7dthA9VWk0Htik3J/w@public.gmane.org, bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/platform/efi/efi.c   |   16 ----------------
 drivers/firmware/efi/memmap.c |   16 ++++++++++++++++
 2 files changed, 16 insertions(+), 16 deletions(-)

--- linux-x86.orig/arch/x86/platform/efi/efi.c
+++ linux-x86/arch/x86/platform/efi/efi.c
@@ -210,22 +210,6 @@ int __init efi_memblock_x86_reserve_rang
 	return 0;
 }
 
-void __init efi_print_memmap(void)
-{
-	efi_memory_desc_t *md;
-	int i = 0;
-
-	for_each_efi_memory_desc(md) {
-		char buf[64];
-
-		pr_info("mem%02u: %s range=[0x%016llx-0x%016llx] (%lluMB)\n",
-			i++, efi_md_typeattr_format(buf, sizeof(buf), md),
-			md->phys_addr,
-			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1,
-			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
-	}
-}
-
 static int __init efi_systab_init(void *phys)
 {
 	if (efi_enabled(EFI_64BIT)) {
--- linux-x86.orig/drivers/firmware/efi/memmap.c
+++ linux-x86/drivers/firmware/efi/memmap.c
@@ -10,6 +10,22 @@
 #include <linux/io.h>
 #include <asm/early_ioremap.h>
 
+void __init efi_print_memmap(void)
+{
+	efi_memory_desc_t *md;
+	int i = 0;
+
+	for_each_efi_memory_desc(md) {
+		char buf[64];
+
+		pr_info("mem%02u: %s range=[0x%016llx-0x%016llx] (%lluMB)\n",
+			i++, efi_md_typeattr_format(buf, sizeof(buf), md),
+			md->phys_addr,
+			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1,
+			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
+	}
+}
+
 /**
  * __efi_memmap_init - Common code for mapping the EFI memory map
  * @data: EFI memory map data
