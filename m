From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 06/13] efi: register iomem resources for UEFI reserved regions
Date: Tue, 18 Nov 2014 13:57:05 +0100
Message-ID: <1416315432-8534-7-git-send-email-ard.biesheuvel@linaro.org>
References: <1416315432-8534-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1416315432-8534-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, geoff.levand-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Register memory regions reserved by UEFI as IORESOURCE_MEM resources,
so that they are reserved for other uses, and also makes them turn up
in /proc/iomem.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/virtmap.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/firmware/efi/virtmap.c b/drivers/firmware/efi/virtmap.c
index d1f1d416944f..98735fb43581 100644
--- a/drivers/firmware/efi/virtmap.c
+++ b/drivers/firmware/efi/virtmap.c
@@ -13,6 +13,7 @@
 #include <linux/rwsem.h>
 #include <linux/spinlock.h>
 #include <linux/atomic.h>
+#include <linux/bootmem.h>
 
 #include <asm/efi.h>
 #include <asm/pgtable.h>
@@ -52,6 +53,39 @@ static pgprot_t efi_md_access_prot(efi_memory_desc_t *md, pgprot_t prot)
 	return pgprot_device(prot);
 }
 
+static __init void efi_register_mem_resource(efi_memory_desc_t *md)
+{
+	struct resource *res, *parent;
+
+	res = alloc_bootmem_low(sizeof(*res));
+	res->start = md->phys_addr;
+	res->end = res->start + (md->num_pages << EFI_PAGE_SHIFT) - 1;
+	res->flags = IORESOURCE_MEM;
+
+	if (md->type == EFI_MEMORY_MAPPED_IO &&
+	    (md->attribute & EFI_MEMORY_RUNTIME)) {
+		/*
+		 * Device regions with the EFI_MEMORY_RUNTIME attribute
+		 * are owned by the UEFI firmware, so make sure they are
+		 * tagged as exclusive: this will also prevent access
+		 * via /dev/mem if CONFIG_STRICT_DEVMEM is in effect.
+		 */
+		res->name = "UEFI Runtime I/O";
+		res->flags |= IORESOURCE_EXCLUSIVE;
+	} else {
+		res->name  = "UEFI Reserved";
+	}
+
+	/*
+	 * Try to register this resource at the top level. If it conflicts with
+	 * an existing entry ('System RAM', most likely), register it as its
+	 * child instead.
+	 */
+	parent = request_resource_conflict(&iomem_resource, res);
+	if (parent)
+		request_resource(parent, res);
+}
+
 void __init efi_virtmap_init(void)
 {
 	efi_memory_desc_t *md;
@@ -63,6 +97,8 @@ void __init efi_virtmap_init(void)
 		u64 paddr, npages, size;
 		pgprot_t prot;
 
+		if (!efi_mem_is_usable_region(md))
+			efi_register_mem_resource(md);
 		if (!(md->attribute & EFI_MEMORY_RUNTIME))
 			continue;
 		if (WARN(md->virt_addr == 0,
-- 
1.8.3.2
