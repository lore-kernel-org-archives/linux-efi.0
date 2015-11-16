From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 07/12] ARM: split off core mapping logic from create_mapping
Date: Mon, 16 Nov 2015 19:32:32 +0100
Message-ID: <1447698757-8762-8-git-send-email-ard.biesheuvel@linaro.org>
References: <1447698757-8762-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447698757-8762-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ryan.harkin-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

In order to be able to reuse the core mapping logic of create_mapping
for mapping the UEFI Runtime Services into a private set of page tables,
split it off from create_mapping() into a separate function
__create_mapping which we will wire up in a subsequent patch.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm/mm/mmu.c | 56 +++++++++++---------
 1 file changed, 31 insertions(+), 25 deletions(-)

diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index de19f90221e2..3100de92148b 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -818,7 +818,8 @@ static void __init alloc_init_pud(pgd_t *pgd, unsigned long addr,
 }
 
 #ifndef CONFIG_ARM_LPAE
-static void __init create_36bit_mapping(struct map_desc *md,
+static void __init create_36bit_mapping(struct mm_struct *mm,
+					struct map_desc *md,
 					const struct mem_type *type)
 {
 	unsigned long addr, length, end;
@@ -859,7 +860,7 @@ static void __init create_36bit_mapping(struct map_desc *md,
 	 */
 	phys |= (((md->pfn >> (32 - PAGE_SHIFT)) & 0xF) << 20);
 
-	pgd = pgd_offset_k(addr);
+	pgd = pgd_offset(mm, addr);
 	end = addr + length;
 	do {
 		pud_t *pud = pud_offset(pgd, addr);
@@ -876,33 +877,13 @@ static void __init create_36bit_mapping(struct map_desc *md,
 }
 #endif	/* !CONFIG_ARM_LPAE */
 
-/*
- * Create the page directory entries and any necessary
- * page tables for the mapping specified by `md'.  We
- * are able to cope here with varying sizes and address
- * offsets, and we take full advantage of sections and
- * supersections.
- */
-static void __init create_mapping(struct map_desc *md)
+static void __init __create_mapping(struct mm_struct *mm, struct map_desc *md)
 {
 	unsigned long addr, length, end;
 	phys_addr_t phys;
 	const struct mem_type *type;
 	pgd_t *pgd;
 
-	if (md->virtual != vectors_base() && md->virtual < TASK_SIZE) {
-		pr_warn("BUG: not creating mapping for 0x%08llx at 0x%08lx in user region\n",
-			(long long)__pfn_to_phys((u64)md->pfn), md->virtual);
-		return;
-	}
-
-	if ((md->type == MT_DEVICE || md->type == MT_ROM) &&
-	    md->virtual >= PAGE_OFFSET && md->virtual < FIXADDR_START &&
-	    (md->virtual < VMALLOC_START || md->virtual >= VMALLOC_END)) {
-		pr_warn("BUG: mapping for 0x%08llx at 0x%08lx out of vmalloc space\n",
-			(long long)__pfn_to_phys((u64)md->pfn), md->virtual);
-	}
-
 	type = &mem_types[md->type];
 
 #ifndef CONFIG_ARM_LPAE
@@ -910,7 +891,7 @@ static void __init create_mapping(struct map_desc *md)
 	 * Catch 36-bit addresses
 	 */
 	if (md->pfn >= 0x100000) {
-		create_36bit_mapping(md, type);
+		create_36bit_mapping(mm, md, type);
 		return;
 	}
 #endif
@@ -925,7 +906,7 @@ static void __init create_mapping(struct map_desc *md)
 		return;
 	}
 
-	pgd = pgd_offset_k(addr);
+	pgd = pgd_offset(mm, addr);
 	end = addr + length;
 	do {
 		unsigned long next = pgd_addr_end(addr, end);
@@ -938,6 +919,31 @@ static void __init create_mapping(struct map_desc *md)
 }
 
 /*
+ * Create the page directory entries and any necessary
+ * page tables for the mapping specified by `md'.  We
+ * are able to cope here with varying sizes and address
+ * offsets, and we take full advantage of sections and
+ * supersections.
+ */
+static void __init create_mapping(struct map_desc *md)
+{
+	if (md->virtual != vectors_base() && md->virtual < TASK_SIZE) {
+		pr_warn("BUG: not creating mapping for 0x%08llx at 0x%08lx in user region\n",
+			(long long)__pfn_to_phys((u64)md->pfn), md->virtual);
+		return;
+	}
+
+	if ((md->type == MT_DEVICE || md->type == MT_ROM) &&
+	    md->virtual >= PAGE_OFFSET && md->virtual < FIXADDR_START &&
+	    (md->virtual < VMALLOC_START || md->virtual >= VMALLOC_END)) {
+		pr_warn("BUG: mapping for 0x%08llx at 0x%08lx out of vmalloc space\n",
+			(long long)__pfn_to_phys((u64)md->pfn), md->virtual);
+	}
+
+	__create_mapping(&init_mm, md);
+}
+
+/*
  * Create the architecture specific mappings
  */
 void __init iotable_init(struct map_desc *io_desc, int nr)
-- 
1.9.1
