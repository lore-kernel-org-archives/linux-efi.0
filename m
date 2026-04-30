Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7DB9344DAE;
	Thu, 30 Apr 2026 03:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777520984; cv=none; b=MEofspUUAEsQDJSFGk5Zi5KiYrCf2CkHcAD7ibmVBBGFlqRZ5Hb++DJ8bA4SINcqxrLfnkYWl3Y0BJAq6wwz50lBRWmTK+Vmw3jRxHhQ2unva2bJecUw6lE6V6nSJOJN/seuNzdtee83Dm2Pf8dfAmJomS5uXXPt7zoZEQKn/n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777520984; c=relaxed/simple;
	bh=zfhZ2KqdUCRvQf3GQfUOIuGNLqo8qxkZHAbF2RhlsN8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=nkRHFyn/Vj7POQDxUYySO8gjYqsJUltxcFo8wcaqCIx9Mm6MyKVrwQSMygKl7gNXoPTBzQtrATGgXBvyPT1q3P5Nxh1nx+Kc2z/1qcQdMGIZtV/V/w2LwJNtt+Z7wA2vohf5JDlTlm+nvKDVXkdS3bIdmKxw8rSPzqljyWNSRj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=t32V3S+4; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="t32V3S+4"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4EEF31A9A;
	Wed, 29 Apr 2026 20:49:35 -0700 (PDT)
Received: from ergosum.cambridge.arm.com (ergosum.cambridge.arm.com [10.1.196.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4158D3F7B4;
	Wed, 29 Apr 2026 20:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777520980; bh=zfhZ2KqdUCRvQf3GQfUOIuGNLqo8qxkZHAbF2RhlsN8=;
	h=From:To:Cc:Subject:Date:From;
	b=t32V3S+4YcnT4TGwDOmXXTACjsbWnJkakGUNLnVj0ACP+1c254em2woHTzUWAHQMB
	 GgZM2hkxGgoZM0NK/ZZWARy0PYcKtfrNNN8bICjyFJcpj6yI88wn4OCVDMlLbu84bR
	 5fRu1F04HIwVj8jqPQacY93KP2aRFNrDs4hXq3Gw=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] arm64/mm: Rename ptdesc_t
Date: Thu, 30 Apr 2026 04:49:33 +0100
Message-Id: <20260430034933.541634-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ptdesc_t sounds very similar to the core MM struct ptdesc which is actually
the memory descriptor for page table allocations. Hence rename this typedef
element as pxxval_t instead for better clarity and separation.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
This patch applies on v7.1-rc1

Took the liberty in including David's tag from an internal discussion.

 arch/arm64/include/asm/io.h            |  2 +-
 arch/arm64/include/asm/pgtable-types.h | 14 +++++++-------
 arch/arm64/include/asm/ptdump.h        |  8 ++++----
 arch/arm64/include/asm/tlbflush.h      |  4 ++--
 arch/arm64/kernel/efi.c                |  4 ++--
 arch/arm64/kernel/pi/map_kernel.c      |  2 +-
 arch/arm64/kernel/pi/map_range.c       |  4 ++--
 arch/arm64/kernel/pi/pi.h              |  2 +-
 arch/arm64/mm/mmap.c                   |  4 ++--
 arch/arm64/mm/pageattr.c               |  2 +-
 arch/arm64/mm/ptdump.c                 |  2 +-
 11 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 8cbd1e96fd50..dd548a93342d 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -270,7 +270,7 @@ static inline void __iomem *ioremap_prot(phys_addr_t phys, size_t size,
 					 pgprot_t user_prot)
 {
 	pgprot_t prot;
-	ptdesc_t user_prot_val = pgprot_val(user_prot);
+	pxxval_t user_prot_val = pgprot_val(user_prot);
 
 	if (WARN_ON_ONCE(!(user_prot_val & PTE_USER)))
 		return NULL;
diff --git a/arch/arm64/include/asm/pgtable-types.h b/arch/arm64/include/asm/pgtable-types.h
index 265e8301d7ba..53b5ada823ee 100644
--- a/arch/arm64/include/asm/pgtable-types.h
+++ b/arch/arm64/include/asm/pgtable-types.h
@@ -17,13 +17,13 @@
  * Generic page table descriptor format from which
  * all level specific descriptors can be derived.
  */
-typedef u64 ptdesc_t;
+typedef u64 pxxval_t;
 
-typedef ptdesc_t pteval_t;
-typedef ptdesc_t pmdval_t;
-typedef ptdesc_t pudval_t;
-typedef ptdesc_t p4dval_t;
-typedef ptdesc_t pgdval_t;
+typedef pxxval_t pteval_t;
+typedef pxxval_t pmdval_t;
+typedef pxxval_t pudval_t;
+typedef pxxval_t p4dval_t;
+typedef pxxval_t pgdval_t;
 
 /*
  * These are used to make use of C type-checking..
@@ -54,7 +54,7 @@ typedef struct { pgdval_t pgd; } pgd_t;
 #define pgd_val(x)	((x).pgd)
 #define __pgd(x)	((pgd_t) { (x) } )
 
-typedef struct { ptdesc_t pgprot; } pgprot_t;
+typedef struct { pxxval_t pgprot; } pgprot_t;
 #define pgprot_val(x)	((x).pgprot)
 #define __pgprot(x)	((pgprot_t) { (x) } )
 
diff --git a/arch/arm64/include/asm/ptdump.h b/arch/arm64/include/asm/ptdump.h
index baff24004459..f4113b7c881c 100644
--- a/arch/arm64/include/asm/ptdump.h
+++ b/arch/arm64/include/asm/ptdump.h
@@ -26,8 +26,8 @@ struct ptdump_info {
 };
 
 struct ptdump_prot_bits {
-	ptdesc_t	mask;
-	ptdesc_t	val;
+	pxxval_t	mask;
+	pxxval_t	val;
 	const char	*set;
 	const char	*clear;
 };
@@ -36,7 +36,7 @@ struct ptdump_pg_level {
 	const struct ptdump_prot_bits *bits;
 	char name[4];
 	int num;
-	ptdesc_t mask;
+	pxxval_t mask;
 };
 
 /*
@@ -53,7 +53,7 @@ struct ptdump_pg_state {
 	const struct mm_struct *mm;
 	unsigned long start_address;
 	int level;
-	ptdesc_t current_prot;
+	pxxval_t current_prot;
 	bool check_wx;
 	unsigned long wx_pages;
 	unsigned long uxn_pages;
diff --git a/arch/arm64/include/asm/tlbflush.h b/arch/arm64/include/asm/tlbflush.h
index c0bf5b398041..968a78d0c69e 100644
--- a/arch/arm64/include/asm/tlbflush.h
+++ b/arch/arm64/include/asm/tlbflush.h
@@ -725,9 +725,9 @@ static inline void arch_tlbbatch_add_pending(struct arch_tlbflush_unmap_batch *b
 	sme_dvmsync_add_pending(batch, mm);
 }
 
-static inline bool __pte_flags_need_flush(ptdesc_t oldval, ptdesc_t newval)
+static inline bool __pte_flags_need_flush(pxxval_t oldval, pxxval_t newval)
 {
-	ptdesc_t diff = oldval ^ newval;
+	pxxval_t diff = oldval ^ newval;
 
 	/* invalid to valid transition requires no flush */
 	if (!(oldval & PTE_VALID))
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index a81cb4aa4738..3d322252b4bf 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -31,7 +31,7 @@ static bool region_is_misaligned(const efi_memory_desc_t *md)
  * executable, everything else can be mapped with the XN bits
  * set. Also take the new (optional) RO/XP bits into account.
  */
-static __init ptdesc_t create_mapping_protection(efi_memory_desc_t *md)
+static __init pxxval_t create_mapping_protection(efi_memory_desc_t *md)
 {
 	u64 attr = md->attribute;
 	u32 type = md->type;
@@ -85,7 +85,7 @@ static __init ptdesc_t create_mapping_protection(efi_memory_desc_t *md)
 
 int __init efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md)
 {
-	ptdesc_t prot_val = create_mapping_protection(md);
+	pxxval_t prot_val = create_mapping_protection(md);
 	bool page_mappings_only = (md->type == EFI_RUNTIME_SERVICES_CODE ||
 				   md->type == EFI_RUNTIME_SERVICES_DATA);
 
diff --git a/arch/arm64/kernel/pi/map_kernel.c b/arch/arm64/kernel/pi/map_kernel.c
index a852264958c3..168858e75f75 100644
--- a/arch/arm64/kernel/pi/map_kernel.c
+++ b/arch/arm64/kernel/pi/map_kernel.c
@@ -165,7 +165,7 @@ static void noinline __section(".idmap.text") set_ttbr0_for_lpa2(phys_addr_t ttb
 static void __init remap_idmap_for_lpa2(void)
 {
 	/* clear the bits that change meaning once LPA2 is turned on */
-	ptdesc_t mask = PTE_SHARED;
+	pxxval_t mask = PTE_SHARED;
 
 	/*
 	 * We have to clear bits [9:8] in all block or page descriptors in the
diff --git a/arch/arm64/kernel/pi/map_range.c b/arch/arm64/kernel/pi/map_range.c
index de52cd85c691..f7cbad6e3bbc 100644
--- a/arch/arm64/kernel/pi/map_range.c
+++ b/arch/arm64/kernel/pi/map_range.c
@@ -31,7 +31,7 @@ void __init map_range(phys_addr_t *pte, u64 start, u64 end, phys_addr_t pa,
 		      u64 va_offset)
 {
 	u64 cmask = (level == 3) ? CONT_PTE_SIZE - 1 : U64_MAX;
-	ptdesc_t protval = pgprot_val(prot) & ~PTE_TYPE_MASK;
+	pxxval_t protval = pgprot_val(prot) & ~PTE_TYPE_MASK;
 	int lshift = (3 - level) * PTDESC_TABLE_SHIFT;
 	u64 lmask = (PAGE_SIZE << lshift) - 1;
 
@@ -88,7 +88,7 @@ void __init map_range(phys_addr_t *pte, u64 start, u64 end, phys_addr_t pa,
 	}
 }
 
-asmlinkage phys_addr_t __init create_init_idmap(pgd_t *pg_dir, ptdesc_t clrmask)
+asmlinkage phys_addr_t __init create_init_idmap(pgd_t *pg_dir, pxxval_t clrmask)
 {
 	phys_addr_t ptep = (phys_addr_t)pg_dir + PAGE_SIZE; /* MMU is off */
 	pgprot_t text_prot = PAGE_KERNEL_ROX;
diff --git a/arch/arm64/kernel/pi/pi.h b/arch/arm64/kernel/pi/pi.h
index aec3172d4003..2eb24a4205f6 100644
--- a/arch/arm64/kernel/pi/pi.h
+++ b/arch/arm64/kernel/pi/pi.h
@@ -35,4 +35,4 @@ void map_range(phys_addr_t *pte, u64 start, u64 end, phys_addr_t pa,
 
 asmlinkage void early_map_kernel(u64 boot_status, phys_addr_t fdt);
 
-asmlinkage phys_addr_t create_init_idmap(pgd_t *pgd, ptdesc_t clrmask);
+asmlinkage phys_addr_t create_init_idmap(pgd_t *pgd, pxxval_t clrmask);
diff --git a/arch/arm64/mm/mmap.c b/arch/arm64/mm/mmap.c
index 92b2f5097a96..bc3fef91a8ce 100644
--- a/arch/arm64/mm/mmap.c
+++ b/arch/arm64/mm/mmap.c
@@ -34,7 +34,7 @@ static pgprot_t protection_map[16] __ro_after_init = {
 	[VM_SHARED | VM_EXEC | VM_WRITE | VM_READ]	= PAGE_SHARED_EXEC
 };
 
-static ptdesc_t gcs_page_prot __ro_after_init = _PAGE_GCS_RO;
+static pxxval_t gcs_page_prot __ro_after_init = _PAGE_GCS_RO;
 
 /*
  * You really shouldn't be using read() or write() on /dev/mem.  This might go
@@ -87,7 +87,7 @@ arch_initcall(adjust_protection_map);
 
 pgprot_t vm_get_page_prot(vm_flags_t vm_flags)
 {
-	ptdesc_t prot;
+	pxxval_t prot;
 
 	/* Short circuit GCS to avoid bloating the table. */
 	if (system_supports_gcs() && (vm_flags & VM_SHADOW_STACK)) {
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index ce035e1b4eaf..e691e258b0e4 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -21,7 +21,7 @@ struct page_change_data {
 	pgprot_t clear_mask;
 };
 
-static ptdesc_t set_pageattr_masks(ptdesc_t val, struct mm_walk *walk)
+static pxxval_t set_pageattr_masks(pxxval_t val, struct mm_walk *walk)
 {
 	struct page_change_data *masks = walk->private;
 
diff --git a/arch/arm64/mm/ptdump.c b/arch/arm64/mm/ptdump.c
index ab9899ca1e5f..235e5d6a3d76 100644
--- a/arch/arm64/mm/ptdump.c
+++ b/arch/arm64/mm/ptdump.c
@@ -194,7 +194,7 @@ void note_page(struct ptdump_state *pt_st, unsigned long addr, int level,
 	struct ptdump_pg_state *st = container_of(pt_st, struct ptdump_pg_state, ptdump);
 	struct ptdump_pg_level *pg_level = st->pg_level;
 	static const char units[] = "KMGTPE";
-	ptdesc_t prot = 0;
+	pxxval_t prot = 0;
 
 	/* check if the current level has been folded dynamically */
 	if (st->mm && ((level == 1 && mm_p4d_folded(st->mm)) ||
-- 
2.30.2

