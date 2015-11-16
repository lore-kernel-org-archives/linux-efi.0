From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 09/12] ARM: implement create_mapping_late() for EFI use
Date: Mon, 16 Nov 2015 19:32:34 +0100
Message-ID: <1447698757-8762-10-git-send-email-ard.biesheuvel@linaro.org>
References: <1447698757-8762-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447698757-8762-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ryan.harkin-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This implements create_mapping_late(), which we will use to populate
the UEFI Runtime Services page tables.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm/include/asm/mach/map.h |  1 +
 arch/arm/mm/mmu.c               | 19 +++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/arch/arm/include/asm/mach/map.h b/arch/arm/include/asm/mach/map.h
index f98c7f32c9c8..14fe67bd0272 100644
--- a/arch/arm/include/asm/mach/map.h
+++ b/arch/arm/include/asm/mach/map.h
@@ -42,6 +42,7 @@ enum {
 extern void iotable_init(struct map_desc *, int);
 extern void vm_reserve_area_early(unsigned long addr, unsigned long size,
 				  void *caller);
+extern void create_mapping_late(struct mm_struct *mm, struct map_desc *md);
 
 #ifdef CONFIG_DEBUG_LL
 extern void debug_ll_addr(unsigned long *paddr, unsigned long *vaddr);
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 87dc49dbe231..0b7b61e31bc3 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -724,6 +724,14 @@ static void __init *early_alloc(unsigned long sz)
 	return early_alloc_aligned(sz, sz);
 }
 
+static void *__init late_alloc(unsigned long sz)
+{
+	void *ptr = (void *)__get_free_pages(PGALLOC_GFP, get_order(sz));
+
+	BUG_ON(!ptr);
+	return ptr;
+}
+
 static pte_t * __init pte_alloc(pmd_t *pmd, unsigned long addr,
 				unsigned long prot,
 				void *(*alloc)(unsigned long sz))
@@ -955,6 +963,17 @@ static void __init create_mapping(struct map_desc *md)
 	__create_mapping(&init_mm, md, early_alloc);
 }
 
+void __init create_mapping_late(struct mm_struct *mm, struct map_desc *md)
+{
+#ifdef CONFIG_ARM_LPAE
+	pud_t *pud = pud_alloc(mm, pgd_offset(mm, md->virtual), md->virtual);
+	if (WARN_ON(!pud))
+		return;
+	pmd_alloc(mm, pud, 0);
+#endif
+	__create_mapping(mm, md, late_alloc);
+}
+
 /*
  * Create the architecture specific mappings
  */
-- 
1.9.1
