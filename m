From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 5/5] arm64: mm: fold init_pgd() into __create_pgd_mapping()
Date: Wed, 29 Jun 2016 14:51:30 +0200
Message-ID: <1467204690-10790-6-git-send-email-ard.biesheuvel@linaro.org>
References: <1467204690-10790-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467204690-10790-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The routine __create_pgd_mapping() does nothing except calling init_pgd(),
which has no other callers. So fold the latter into the former. Also, drop
a comment that has gone stale.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/mm/mmu.c | 24 +++++---------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index f233c885042d..8cf4da36909a 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -240,16 +240,14 @@ static void alloc_init_pud(pgd_t *pgd, unsigned long addr, unsigned long end,
 	pud_clear_fixmap();
 }
 
-/*
- * Create the page directory entries and any necessary page tables for the
- * mapping specified by 'md'.
- */
-static void init_pgd(pgd_t *pgd, phys_addr_t phys, unsigned long virt,
-				    phys_addr_t size, pgprot_t prot,
-				    phys_addr_t (*pgtable_alloc)(void),
-				    bool allow_block_mappings)
+static void __create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
+				 unsigned long virt, phys_addr_t size,
+				 pgprot_t prot,
+				 phys_addr_t (*pgtable_alloc)(void),
+				 bool allow_block_mappings)
 {
 	unsigned long addr, length, end, next;
+	pgd_t *pgd = pgd_offset_raw(pgdir, virt);
 
 	/*
 	 * If the virtual and physical address don't have the same offset
@@ -281,16 +279,6 @@ static phys_addr_t late_pgtable_alloc(void)
 	return __pa(ptr);
 }
 
-static void __create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
-				 unsigned long virt, phys_addr_t size,
-				 pgprot_t prot,
-				 phys_addr_t (*alloc)(void),
-				 bool allow_block_mappings)
-{
-	init_pgd(pgd_offset_raw(pgdir, virt), phys, virt, size, prot, alloc,
-		 allow_block_mappings);
-}
-
 /*
  * This function can only be used to modify existing table entries,
  * without allocating new levels of table. Note that this permits the
-- 
2.7.4
