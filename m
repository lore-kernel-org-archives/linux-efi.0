From: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 2/6] x86/efi: use efi_memory_descriptor in convenience functions
Date: Sat, 13 Sep 2014 11:36:12 -0700
Message-ID: <1410633376-8822-3-git-send-email-ricardo.neri-calderon@linux.intel.com>
References: <1410633376-8822-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410633376-8822-1-git-send-email-ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Glenn P. Williamson" <glenn.p.williamson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Rather than duplicating the code to lookup for the memory descriptor of
a given physical address, use the utility function efi_memory_descriptor.

Signed-off-by: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 arch/x86/platform/efi/efi.c | 26 ++++++--------------------
 drivers/firmware/efi/efi.c  | 36 +++++++++++++++---------------------
 2 files changed, 21 insertions(+), 41 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 782d617..d45decf 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -924,36 +924,22 @@ efi_memory_desc_t *efi_memory_descriptor(unsigned long phys_addr)
 u32 efi_mem_type(unsigned long phys_addr)
 {
 	efi_memory_desc_t *md;
-	void *p;
 
-	if (!efi_enabled(EFI_MEMMAP))
-		return 0;
+	md = efi_memory_descriptor(phys_addr);
+	if (md)
+		return md->type;
 
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		md = p;
-		if ((md->phys_addr <= phys_addr) &&
-		    (phys_addr < (md->phys_addr +
-				  (md->num_pages << EFI_PAGE_SHIFT))))
-			return md->type;
-	}
 	return 0;
 }
 
 u64 efi_mem_attributes(unsigned long phys_addr)
 {
 	efi_memory_desc_t *md;
-	void *p;
 
-	if (!efi_enabled(EFI_MEMMAP))
-		return 0;
+	md = efi_memory_descriptor(phys_addr);
+	if (md)
+		return md->attribute;
 
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		md = p;
-		if ((md->phys_addr <= phys_addr) &&
-		    (phys_addr < (md->phys_addr +
-				  (md->num_pages << EFI_PAGE_SHIFT))))
-			return md->attribute;
-	}
 	return 0;
 }
 
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 64ecbb5..29c85fe 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -206,29 +206,23 @@ subsys_initcall(efisubsys_init);
  */
 void __iomem *efi_lookup_mapped_addr(u64 phys_addr)
 {
-	struct efi_memory_map *map;
-	void *p;
-	map = efi.memmap;
-	if (!map)
+	efi_memory_desc_t *md;
+
+	md = efi_memory_descriptor(phys_addr);
+
+	if (!md)
 		return NULL;
-	if (WARN_ON(!map->map))
+
+	if (!md->virt_addr)
 		return NULL;
-	for (p = map->map; p < map->map_end; p += map->desc_size) {
-		efi_memory_desc_t *md = p;
-		u64 size = md->num_pages << EFI_PAGE_SHIFT;
-		u64 end = md->phys_addr + size;
-		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
-		    md->type != EFI_BOOT_SERVICES_CODE &&
-		    md->type != EFI_BOOT_SERVICES_DATA)
-			continue;
-		if (!md->virt_addr)
-			continue;
-		if (phys_addr >= md->phys_addr && phys_addr < end) {
-			phys_addr += md->virt_addr - md->phys_addr;
-			return (__force void __iomem *)(unsigned long)phys_addr;
-		}
-	}
-	return NULL;
+
+	if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
+	    md->type != EFI_BOOT_SERVICES_CODE &&
+	    md->type != EFI_BOOT_SERVICES_DATA)
+		return NULL;
+
+	phys_addr += md->virt_addr - md->phys_addr;
+	return (__force void __iomem *)(unsigned long)phys_addr;
 }
 
 static __initdata efi_config_table_type_t common_tables[] = {
-- 
1.9.1
