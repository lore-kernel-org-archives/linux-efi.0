Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAD08480DE4;
	Tue, 14 Jul 2026 14:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784038069; cv=none; b=Dams7/INaieIqDwO89tsqDAL4nT4tM0C3E4ZjKXg1QKyLqy1dWWiT81WJDrVnDxpuR2mMmvyplN7YUz8XpecSf0cbqrpY3ySSrtm/OLHqpFxKVw+EePZ149Q2Hzmb7PpzYxCoT35eCLgmtq2WA86ENqJImEGsMsUEkY6IEtZajo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784038069; c=relaxed/simple;
	bh=eNgm2wK/htg6bJpbLSoGRu/x8u/9VaQ86dX9GXxA/zM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UV2uGorX2zVIsI8lLYPlywc8PgivBB7i5Pg9jjIrITE4xg9UPBeeQ4JoFxXTfgKymBCqaTdFfVu2Y6DrCESDHjJiK5Z9erzCTDJGXshlTDx5+we6Jnv4OYYrjPTwLWVxRH+9+yJreNFBp9FgVTm1+oNQG+IONY464fL96UJk/sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=dz+aSvQ4; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="dz+aSvQ4"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 76CD11CE0;
	Tue, 14 Jul 2026 07:07:40 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4C05B3F7B4;
	Tue, 14 Jul 2026 07:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784038064; bh=eNgm2wK/htg6bJpbLSoGRu/x8u/9VaQ86dX9GXxA/zM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=dz+aSvQ4IIcP5/jB1TnLsl+9MnbX6Bwx+0Lqjr8x5S3Rd06ehciwldTY2ZsmAHOfx
	 2p1hk4Zezbl29IQIBcUEBscEe0HFjjITDWWe4jQ+rPyb/sbhmBJo91kiol4raAMUFc
	 aSB5BRahC2yYplDRD719ZRvsn/Bk4aIHLvc9u2go=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 14 Jul 2026 15:04:09 +0100
Subject: [PATCH 20/22] arm64: mm: drop ctor/dtor calls for kernel page
 tables
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-remove_pgtable_cdtor-v1-20-44be8a7685d7@arm.com>
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
In-Reply-To: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
To: linux-mm@kvack.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Russell King <linux@armlinux.org.uk>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Ryan Roberts <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org, 
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, linux-s390@vger.kernel.org, 
 "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org, 
 Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, linux-um@lists.infradead.org, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ning Sun <ning.sun@intel.com>, 
 x86@kernel.org, tboot-devel@lists.sourceforge.net, 
 Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org, 
 Vishal Moola <vishal.moola@gmail.com>, Alistair Popple <apopple@nvidia.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784037902; l=9717;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=eNgm2wK/htg6bJpbLSoGRu/x8u/9VaQ86dX9GXxA/zM=;
 b=5eP0RdQOzgReDDpM+wlyav4lmQqmzUAUIXx1RW3HbowrbhPLxRPz5GfX/Bq9XXmijz2/LPmIY
 buMwtuXHOIlAyPhXdjAIkFQlvZ539XeVYb71j+kHGgtFElURkk2a/ok
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=

Thanks to recent changes:

* pagetable_*_ctor() and pagetable_dtor() do nothing for kernel page
  tables.

* efi_mm is also treated like a kernel mm by the page table logic,
  including ctors.

We can therefore drop the calls to ctors when allocating special
kernel page tables in mmu.c, as well as the dtor call when freeing
hotplug page tables.

Since we no longer need the owning mm or page table level when
allocating them, we can also remove both the init_mm/special_mm
wrappers and the pgtable_level callback argument.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/mm/mmu.c | 82 +++++++++++++++--------------------------------------
 1 file changed, 23 insertions(+), 59 deletions(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index f723bcf68174..f1400c6f68ba 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -103,7 +103,7 @@ pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 }
 EXPORT_SYMBOL(phys_mem_access_prot);
 
-static phys_addr_t __init early_pgtable_alloc(enum pgtable_level pgtable_level)
+static phys_addr_t __init early_pgtable_alloc(void)
 {
 	phys_addr_t phys;
 
@@ -195,7 +195,7 @@ static bool pte_range_has_valid_noncont(pte_t *ptep)
 static int alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
 			       unsigned long end, phys_addr_t phys,
 			       pgprot_t prot,
-			       phys_addr_t (*pgtable_alloc)(enum pgtable_level),
+			       phys_addr_t (*pgtable_alloc)(void),
 			       int flags)
 {
 	unsigned long next;
@@ -210,7 +210,7 @@ static int alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
 		if (flags & NO_EXEC_MAPPINGS)
 			pmdval |= PMD_TABLE_PXN;
 		BUG_ON(!pgtable_alloc);
-		pte_phys = pgtable_alloc(PGTABLE_LEVEL_PTE);
+		pte_phys = pgtable_alloc();
 		if (pte_phys == INVALID_PHYS_ADDR)
 			return -ENOMEM;
 		ptep = pte_set_fixmap(pte_phys);
@@ -251,7 +251,7 @@ static int alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
 
 static int init_pmd(pmd_t *pmdp, unsigned long addr, unsigned long end,
 		    phys_addr_t phys, pgprot_t prot,
-		    phys_addr_t (*pgtable_alloc)(enum pgtable_level), int flags)
+		    phys_addr_t (*pgtable_alloc)(void), int flags)
 {
 	unsigned long next;
 
@@ -303,7 +303,7 @@ static bool pmd_range_has_valid_noncont(pmd_t *pmdp)
 static int alloc_init_cont_pmd(pud_t *pudp, unsigned long addr,
 			       unsigned long end, phys_addr_t phys,
 			       pgprot_t prot,
-			       phys_addr_t (*pgtable_alloc)(enum pgtable_level),
+			       phys_addr_t (*pgtable_alloc)(void),
 			       int flags)
 {
 	int ret;
@@ -322,7 +322,7 @@ static int alloc_init_cont_pmd(pud_t *pudp, unsigned long addr,
 		if (flags & NO_EXEC_MAPPINGS)
 			pudval |= PUD_TABLE_PXN;
 		BUG_ON(!pgtable_alloc);
-		pmd_phys = pgtable_alloc(PGTABLE_LEVEL_PMD);
+		pmd_phys = pgtable_alloc();
 		if (pmd_phys == INVALID_PHYS_ADDR)
 			return -ENOMEM;
 		pmdp = pmd_set_fixmap(pmd_phys);
@@ -361,7 +361,7 @@ static int alloc_init_cont_pmd(pud_t *pudp, unsigned long addr,
 
 static int alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 			  phys_addr_t phys, pgprot_t prot,
-			  phys_addr_t (*pgtable_alloc)(enum pgtable_level),
+			  phys_addr_t (*pgtable_alloc)(void),
 			  int flags)
 {
 	int ret = 0;
@@ -376,7 +376,7 @@ static int alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 		if (flags & NO_EXEC_MAPPINGS)
 			p4dval |= P4D_TABLE_PXN;
 		BUG_ON(!pgtable_alloc);
-		pud_phys = pgtable_alloc(PGTABLE_LEVEL_PUD);
+		pud_phys = pgtable_alloc();
 		if (pud_phys == INVALID_PHYS_ADDR)
 			return -ENOMEM;
 		pudp = pud_set_fixmap(pud_phys);
@@ -428,7 +428,7 @@ static int alloc_init_pud(p4d_t *p4dp, unsigned long addr, unsigned long end,
 
 static int alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
 			  phys_addr_t phys, pgprot_t prot,
-			  phys_addr_t (*pgtable_alloc)(enum pgtable_level),
+			  phys_addr_t (*pgtable_alloc)(void),
 			  int flags)
 {
 	int ret;
@@ -443,7 +443,7 @@ static int alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
 		if (flags & NO_EXEC_MAPPINGS)
 			pgdval |= PGD_TABLE_PXN;
 		BUG_ON(!pgtable_alloc);
-		p4d_phys = pgtable_alloc(PGTABLE_LEVEL_P4D);
+		p4d_phys = pgtable_alloc();
 		if (p4d_phys == INVALID_PHYS_ADDR)
 			return -ENOMEM;
 		p4dp = p4d_set_fixmap(p4d_phys);
@@ -480,7 +480,7 @@ static int alloc_init_p4d(pgd_t *pgdp, unsigned long addr, unsigned long end,
 static int __create_pgd_mapping_locked(pgd_t *pgdir, phys_addr_t phys,
 				       unsigned long virt, phys_addr_t size,
 				       pgprot_t prot,
-				       phys_addr_t (*pgtable_alloc)(enum pgtable_level),
+				       phys_addr_t (*pgtable_alloc)(void),
 				       int flags)
 {
 	int ret;
@@ -513,7 +513,7 @@ static int __create_pgd_mapping_locked(pgd_t *pgdir, phys_addr_t phys,
 static int __create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
 				unsigned long virt, phys_addr_t size,
 				pgprot_t prot,
-				phys_addr_t (*pgtable_alloc)(enum pgtable_level),
+				phys_addr_t (*pgtable_alloc)(void),
 				int flags)
 {
 	int ret;
@@ -529,7 +529,7 @@ static int __create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
 static void early_create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
 				     unsigned long virt, phys_addr_t size,
 				     pgprot_t prot,
-				     phys_addr_t (*pgtable_alloc)(enum pgtable_level),
+				     phys_addr_t (*pgtable_alloc)(void),
 				     int flags)
 {
 	int ret;
@@ -540,55 +540,20 @@ static void early_create_pgd_mapping(pgd_t *pgdir, phys_addr_t phys,
 		panic("Failed to create page tables\n");
 }
 
-static phys_addr_t __pgd_pgtable_alloc(struct mm_struct *mm, gfp_t gfp,
-				       enum pgtable_level pgtable_level)
+static phys_addr_t pgd_pgtable_alloc_gfp(gfp_t gfp)
 {
 	/* Page is zeroed by init_clear_pgtable() so don't duplicate effort. */
 	struct ptdesc *ptdesc = pagetable_alloc(gfp & ~__GFP_ZERO, 0);
-	phys_addr_t pa;
 
 	if (!ptdesc)
 		return INVALID_PHYS_ADDR;
 
-	pa = page_to_phys(ptdesc_page(ptdesc));
-
-	switch (pgtable_level) {
-	case PGTABLE_LEVEL_PTE:
-		BUG_ON(!pagetable_pte_ctor(mm, ptdesc));
-		break;
-	case PGTABLE_LEVEL_PMD:
-		BUG_ON(!pagetable_pmd_ctor(mm, ptdesc));
-		break;
-	case PGTABLE_LEVEL_PUD:
-		pagetable_pud_ctor(ptdesc);
-		break;
-	case PGTABLE_LEVEL_P4D:
-		pagetable_p4d_ctor(ptdesc);
-		break;
-	case PGTABLE_LEVEL_PGD:
-		VM_WARN_ON(1);
-		break;
-	}
-
-	return pa;
-}
-
-static phys_addr_t
-pgd_pgtable_alloc_init_mm_gfp(enum pgtable_level pgtable_level, gfp_t gfp)
-{
-	return __pgd_pgtable_alloc(&init_mm, gfp, pgtable_level);
-}
-
-static phys_addr_t __maybe_unused
-pgd_pgtable_alloc_init_mm(enum pgtable_level pgtable_level)
-{
-	return pgd_pgtable_alloc_init_mm_gfp(pgtable_level, GFP_PGTABLE_KERNEL);
+	return page_to_phys(ptdesc_page(ptdesc));
 }
 
-static phys_addr_t
-pgd_pgtable_alloc_special_mm(enum pgtable_level pgtable_level)
+static phys_addr_t pgd_pgtable_alloc(void)
 {
-	return  __pgd_pgtable_alloc(NULL, GFP_PGTABLE_KERNEL, pgtable_level);
+	return pgd_pgtable_alloc_gfp(GFP_PGTABLE_KERNEL);
 }
 
 static void split_contpte(pte_t *ptep)
@@ -609,7 +574,7 @@ static int split_pmd(pmd_t *pmdp, pmd_t pmd, gfp_t gfp, bool to_cont)
 	pte_t *ptep;
 	int i;
 
-	pte_phys = pgd_pgtable_alloc_init_mm_gfp(PGTABLE_LEVEL_PTE, gfp);
+	pte_phys = pgd_pgtable_alloc_gfp(gfp);
 	if (pte_phys == INVALID_PHYS_ADDR)
 		return -ENOMEM;
 	ptep = (pte_t *)phys_to_virt(pte_phys);
@@ -656,7 +621,7 @@ static int split_pud(pud_t *pudp, pud_t pud, gfp_t gfp, bool to_cont)
 	pmd_t *pmdp;
 	int i;
 
-	pmd_phys = pgd_pgtable_alloc_init_mm_gfp(PGTABLE_LEVEL_PMD, gfp);
+	pmd_phys = pgd_pgtable_alloc_gfp(gfp);
 	if (pmd_phys == INVALID_PHYS_ADDR)
 		return -ENOMEM;
 	pmdp = (pmd_t *)phys_to_virt(pmd_phys);
@@ -1035,7 +1000,7 @@ void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
 		flags = NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
 	early_create_pgd_mapping(mm->pgd, phys, virt, size, prot,
-				 pgd_pgtable_alloc_special_mm, flags);
+				 pgd_pgtable_alloc, flags);
 }
 
 static void update_mapping_prot(phys_addr_t phys, unsigned long virt,
@@ -1249,7 +1214,7 @@ static void __init declare_vma(struct vm_struct *vma,
 
 static phys_addr_t kpti_ng_temp_alloc __initdata;
 
-static phys_addr_t __init kpti_ng_pgd_alloc(enum pgtable_level pgtable_level)
+static phys_addr_t __init kpti_ng_pgd_alloc(void)
 {
 	kpti_ng_temp_alloc -= PAGE_SIZE;
 	return kpti_ng_temp_alloc;
@@ -1357,7 +1322,7 @@ static int __init map_entry_trampoline(void)
 	memset(tramp_pg_dir, 0, PGD_SIZE);
 	early_create_pgd_mapping(tramp_pg_dir, pa_start, TRAMP_VALIAS,
 				 entry_tramp_text_size(), prot,
-				 pgd_pgtable_alloc_init_mm, NO_BLOCK_MAPPINGS);
+				 pgd_pgtable_alloc, NO_BLOCK_MAPPINGS);
 
 	/* Map both the text and data into the kernel page table */
 	for (i = 0; i < DIV_ROUND_UP(entry_tramp_text_size(), PAGE_SIZE); i++)
@@ -1445,7 +1410,6 @@ static void free_hotplug_page_range(struct page *page, size_t size,
 
 static void free_hotplug_pgtable_page(struct page *page)
 {
-	pagetable_dtor(page_ptdesc(page));
 	free_hotplug_page_range(page, PAGE_SIZE, NULL);
 }
 
@@ -1958,7 +1922,7 @@ int arch_add_memory(int nid, u64 start, u64 size,
 		flags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
 	ret = __create_pgd_mapping(swapper_pg_dir, start, __phys_to_virt(start),
-				   size, params->pgprot, pgd_pgtable_alloc_init_mm,
+				   size, params->pgprot, pgd_pgtable_alloc,
 				   flags);
 	if (ret)
 		goto err;

-- 
2.51.2

