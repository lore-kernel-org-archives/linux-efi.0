Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D48364746B9;
	Mon, 14 Sep 2026 13:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789393933; cv=none; b=BLkhPX0SbvwrtMkaB7GfzVTpcpmZfjWTs9sZDQ2swN9aq9LJ5aQo3xMjCgEvGLwE4lB7S035ng+lkHnna0USWvJI/L5pXp5EzzspG3rFlqtpB2t4WilmRxryfEA+kuYPv1NMQNIzPl4ntPnnA90ovx9QZFTg/r3ZO7w0AovAFVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789393933; c=relaxed/simple;
	bh=U3OoYFi46tsLbNiRnAhlwuKl1ZZiEGdCyFfL9y3VjKk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Q3oPsXlkF5fcIBZ7zr6DWoE2detx8x0XXVqb8LBwmFA6dGOeftHvO5/2baO1L0n9FqryEGsqXC3YdLHWpttT8QlWOnxCnGXNg94g5aIWkWOCcNmi00J1Jw1pPuHCpZNw/QUnTVP01k3Jf0szhPVF0Zl8pms2mMmHmRnlGT40A/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=lORZSJjc; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="lORZSJjc"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4246E1576;
	Mon, 14 Sep 2026 06:52:05 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6251E3F9A2;
	Mon, 14 Sep 2026 06:52:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789393928; bh=U3OoYFi46tsLbNiRnAhlwuKl1ZZiEGdCyFfL9y3VjKk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=lORZSJjcU9RfORWdesr8lMmLoqjTVw8UOnkzg3TBjYegXheb/mFaKSQ8dKds/z4OY
	 gRk7z0xpfxPUGKmvtPziB8s3QFPNmHZ+3qtj++b7MymtLVeueyuAHUAmf5Od/xZSB4
	 PX6ioPXxONnlk16Yc4+83MRkdKSfUioW81rdZ0Kw=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Date: Mon, 14 Sep 2026 14:51:31 +0100
Subject: [PATCH 1/6] arm64: use hw_pte_t for HW PTE pointers
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-pte0_arm-v1-1-bb53b663e396@arm.com>
References: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
In-Reply-To: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-efi@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
 Muhammad Usama Anjum <usama.anjum@arm.com>
X-Mailer: b4 0.16.0

With pte_t * used for HW PTE pointers, the compiler cannot distinguish
them from SW PTE value pointers. The generic HW PTE interfaces already
use hw_pte_t *, so arm64 HW PTE pointers must use that type before
ARCH_HAS_HW_PTE_T can make it distinct.

Convert HW PTE pointers to hw_pte_t *, retaining pte_t for SW PTE
values. Helpers shared with PMD and PUD operations keep explicit casts
because this series does not introduce distinct entry types for those
levels.

arm64 still uses the hw_pte_t alias in this patch. The new pointer
spelling therefore denotes the same type until the final opt-in.

Include linux/pgtable_types.h in pi.h to make hw_pte_t visible.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 arch/arm64/include/asm/hugetlb.h  |  19 ++---
 arch/arm64/include/asm/pgalloc.h  |   2 +-
 arch/arm64/include/asm/pgtable.h  | 143 ++++++++++++++++++++------------------
 arch/arm64/include/asm/vmalloc.h  |   2 +-
 arch/arm64/kernel/efi.c           |   3 +-
 arch/arm64/kernel/pi/map_kernel.c |   4 +-
 arch/arm64/kernel/pi/map_range.c  |   9 +--
 arch/arm64/kernel/pi/pi.h         |   3 +-
 arch/arm64/mm/contpte.c           |  49 +++++++------
 arch/arm64/mm/fault.c             |   5 +-
 arch/arm64/mm/fixmap.c            |   6 +-
 arch/arm64/mm/hugetlbpage.c       |  48 +++++++------
 arch/arm64/mm/kasan_init.c        |   4 +-
 arch/arm64/mm/mmu.c               |  46 +++++++-----
 arch/arm64/mm/pageattr.c          |   4 +-
 arch/arm64/mm/trans_pgd.c         |   4 +-
 16 files changed, 190 insertions(+), 161 deletions(-)

diff --git a/arch/arm64/include/asm/hugetlb.h b/arch/arm64/include/asm/hugetlb.h
index d038ff14d16ca..15b3cf53aa2ca 100644
--- a/arch/arm64/include/asm/hugetlb.h
+++ b/arch/arm64/include/asm/hugetlb.h
@@ -36,33 +36,34 @@ pte_t arch_make_huge_pte(pte_t entry, unsigned int shift, vm_flags_t flags);
 #define arch_make_huge_pte arch_make_huge_pte
 #define __HAVE_ARCH_HUGE_SET_HUGE_PTE_AT
 extern void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
-			    pte_t *ptep, pte_t pte, unsigned long sz);
+			    hw_pte_t *ptep, pte_t pte, unsigned long sz);
 #define __HAVE_ARCH_HUGE_PTEP_SET_ACCESS_FLAGS
 extern int huge_ptep_set_access_flags(struct vm_area_struct *vma,
-				      unsigned long addr, pte_t *ptep,
+				      unsigned long addr, hw_pte_t *ptep,
 				      pte_t pte, int dirty);
 #define __HAVE_ARCH_HUGE_PTEP_GET_AND_CLEAR
 extern pte_t huge_ptep_get_and_clear(struct mm_struct *mm, unsigned long addr,
-				     pte_t *ptep, unsigned long sz);
+				     hw_pte_t *ptep, unsigned long sz);
 #define __HAVE_ARCH_HUGE_PTEP_SET_WRPROTECT
 extern void huge_ptep_set_wrprotect(struct mm_struct *mm,
-				    unsigned long addr, pte_t *ptep);
+				    unsigned long addr, hw_pte_t *ptep);
 #define __HAVE_ARCH_HUGE_PTEP_CLEAR_FLUSH
 extern pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
-				   unsigned long addr, pte_t *ptep);
+				   unsigned long addr, hw_pte_t *ptep);
 #define __HAVE_ARCH_HUGE_PTE_CLEAR
 extern void huge_pte_clear(struct mm_struct *mm, unsigned long addr,
-			   pte_t *ptep, unsigned long sz);
+			   hw_pte_t *ptep, unsigned long sz);
 #define __HAVE_ARCH_HUGE_PTEP_GET
-extern pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
+extern pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr,
+			   hw_pte_t *ptep);
 
 #define huge_ptep_modify_prot_start huge_ptep_modify_prot_start
 extern pte_t huge_ptep_modify_prot_start(struct vm_area_struct *vma,
-					 unsigned long addr, pte_t *ptep);
+					 unsigned long addr, hw_pte_t *ptep);
 
 #define huge_ptep_modify_prot_commit huge_ptep_modify_prot_commit
 extern void huge_ptep_modify_prot_commit(struct vm_area_struct *vma,
-					 unsigned long addr, pte_t *ptep,
+					 unsigned long addr, hw_pte_t *ptep,
 					 pte_t old_pte, pte_t new_pte);
 
 #include <asm-generic/hugetlb.h>
diff --git a/arch/arm64/include/asm/pgalloc.h b/arch/arm64/include/asm/pgalloc.h
index 1b4509d3382c6..80063dd4d2722 100644
--- a/arch/arm64/include/asm/pgalloc.h
+++ b/arch/arm64/include/asm/pgalloc.h
@@ -106,7 +106,7 @@ static inline void __pmd_populate(pmd_t *pmdp, phys_addr_t ptep,
  * of the mm address space.
  */
 static inline void
-pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmdp, pte_t *ptep)
+pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmdp, hw_pte_t *ptep)
 {
 	VM_BUG_ON(mm && mm != &init_mm);
 	__pmd_populate(pmdp, __pa(ptep),
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index e89ec5f4787b4..652ce413be389 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -358,7 +358,7 @@ static inline pte_t pte_clear_uffd(pte_t pte)
 }
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
 
-static inline void __set_pte_nosync(pte_t *ptep, pte_t pte)
+static inline void __set_pte_nosync(hw_pte_t *ptep, pte_t pte)
 {
 	WRITE_ONCE(*ptep, pte);
 }
@@ -373,13 +373,13 @@ static inline void __set_pte_complete(pte_t pte)
 		queue_pte_barriers();
 }
 
-static inline void __set_pte(pte_t *ptep, pte_t pte)
+static inline void __set_pte(hw_pte_t *ptep, pte_t pte)
 {
 	__set_pte_nosync(ptep, pte);
 	__set_pte_complete(pte);
 }
 
-static inline pte_t __ptep_get(pte_t *ptep)
+static inline pte_t __ptep_get(hw_pte_t *ptep)
 {
 	return READ_ONCE(*ptep);
 }
@@ -403,7 +403,8 @@ bool pgattr_change_is_safe(pteval_t old, pteval_t new);
  *   PTE_DIRTY || (PTE_WRITE && !PTE_RDONLY)
  */
 
-static inline void __check_safe_pte_update(struct mm_struct *mm, pte_t *ptep,
+static inline void __check_safe_pte_update(struct mm_struct *mm,
+					   hw_pte_t *ptep,
 					   pte_t pte)
 {
 	pte_t old_pte;
@@ -669,7 +670,8 @@ static inline pgprot_t pud_pgprot(pud_t pud)
 }
 
 static inline void __set_ptes_anysz(struct mm_struct *mm, unsigned long addr,
-				    pte_t *ptep, pte_t pte, unsigned int nr,
+				    hw_pte_t *ptep, pte_t pte,
+				    unsigned int nr,
 				    unsigned long pgsize)
 {
 	unsigned long stride = pgsize >> PAGE_SHIFT;
@@ -707,7 +709,7 @@ static inline void __set_ptes_anysz(struct mm_struct *mm, unsigned long addr,
 }
 
 static inline void __set_ptes(struct mm_struct *mm, unsigned long addr,
-			      pte_t *ptep, pte_t pte, unsigned int nr)
+			      hw_pte_t *ptep, pte_t pte, unsigned int nr)
 {
 	__set_ptes_anysz(mm, addr, ptep, pte, nr, PAGE_SIZE);
 }
@@ -715,14 +717,16 @@ static inline void __set_ptes(struct mm_struct *mm, unsigned long addr,
 static inline void __set_pmds(struct mm_struct *mm, unsigned long addr,
 			      pmd_t *pmdp, pmd_t pmd, unsigned int nr)
 {
-	__set_ptes_anysz(mm, addr, (pte_t *)pmdp, pmd_pte(pmd), nr, PMD_SIZE);
+	__set_ptes_anysz(mm, addr, (hw_pte_t *)pmdp, pmd_pte(pmd), nr,
+			 PMD_SIZE);
 }
 #define set_pmd_at(mm, addr, pmdp, pmd) __set_pmds(mm, addr, pmdp, pmd, 1)
 
 static inline void __set_puds(struct mm_struct *mm, unsigned long addr,
 			      pud_t *pudp, pud_t pud, unsigned int nr)
 {
-	__set_ptes_anysz(mm, addr, (pte_t *)pudp, pud_pte(pud), nr, PUD_SIZE);
+	__set_ptes_anysz(mm, addr, (hw_pte_t *)pudp, pud_pte(pud), nr,
+			 PUD_SIZE);
 }
 #define set_pud_at(mm, addr, pudp, pud) __set_puds(mm, addr, pudp, pud, 1)
 
@@ -850,16 +854,16 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
 }
 
 /* Find an entry in the third-level page table. */
-#define pte_offset_phys(dir,addr)	(pmd_page_paddr(READ_ONCE(*(dir))) + pte_index(addr) * sizeof(pte_t))
+#define pte_offset_phys(dir, addr)	(pmd_page_paddr(READ_ONCE(*(dir))) + pte_index(addr) * sizeof(hw_pte_t))
 
-#define pte_set_fixmap(addr)		((pte_t *)set_fixmap_offset(FIX_PTE, addr))
+#define pte_set_fixmap(addr)		((hw_pte_t *)set_fixmap_offset(FIX_PTE, addr))
 #define pte_set_fixmap_offset(pmd, addr)	pte_set_fixmap(pte_offset_phys(pmd, addr))
 #define pte_clear_fixmap()		clear_fixmap(FIX_PTE)
 
 #define pmd_page(pmd)			phys_to_page(__pmd_to_phys(pmd))
 
 /* use ONLY for statically allocated translation tables */
-#define pte_offset_kimg(dir,addr)	((pte_t *)__phys_to_kimg(pte_offset_phys((dir), (addr))))
+#define pte_offset_kimg(dir, addr)	((hw_pte_t *)__phys_to_kimg(pte_offset_phys((dir), (addr))))
 
 #if CONFIG_PGTABLE_LEVELS > 2
 
@@ -1238,12 +1242,14 @@ static inline pmd_t pmd_modify(pmd_t pmd, pgprot_t newprot)
 }
 
 extern int __ptep_set_access_flags_anysz(struct vm_area_struct *vma,
-					 unsigned long address, pte_t *ptep,
+					 unsigned long address,
+					 hw_pte_t *ptep,
 					 pte_t entry, int dirty,
 					 unsigned long pgsize);
 
 static inline int __ptep_set_access_flags(struct vm_area_struct *vma,
-					  unsigned long address, pte_t *ptep,
+					  unsigned long address,
+					  hw_pte_t *ptep,
 					  pte_t entry, int dirty)
 {
 	return __ptep_set_access_flags_anysz(vma, address, ptep, entry, dirty,
@@ -1256,7 +1262,7 @@ static inline int pmdp_set_access_flags(struct vm_area_struct *vma,
 					unsigned long address, pmd_t *pmdp,
 					pmd_t entry, int dirty)
 {
-	return __ptep_set_access_flags_anysz(vma, address, (pte_t *)pmdp,
+	return __ptep_set_access_flags_anysz(vma, address, (hw_pte_t *)pmdp,
 					     pmd_pte(entry), dirty, PMD_SIZE);
 }
 #endif
@@ -1283,13 +1289,13 @@ static inline bool pud_user_accessible_page(struct mm_struct *mm, unsigned long
  */
 
 static inline void __pte_clear(struct mm_struct *mm,
-			       unsigned long addr, pte_t *ptep)
+			       unsigned long addr, hw_pte_t *ptep)
 {
 	__set_pte(ptep, __pte(0));
 }
 
 static inline bool __ptep_test_and_clear_young(struct vm_area_struct *vma,
-		unsigned long address, pte_t *ptep)
+		unsigned long address, hw_pte_t *ptep)
 {
 	pte_t old_pte, pte;
 
@@ -1305,7 +1311,7 @@ static inline bool __ptep_test_and_clear_young(struct vm_area_struct *vma,
 }
 
 static inline bool __ptep_clear_flush_young(struct vm_area_struct *vma,
-		unsigned long address, pte_t *ptep)
+		unsigned long address, hw_pte_t *ptep)
 {
 	bool young = __ptep_test_and_clear_young(vma, address, ptep);
 
@@ -1331,13 +1337,13 @@ static inline bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
 {
 	/* Operation applies to PMD table entry only if FEAT_HAFT is enabled */
 	VM_WARN_ON(pmd_table(READ_ONCE(*pmdp)) && !system_supports_haft());
-	return __ptep_test_and_clear_young(vma, address, (pte_t *)pmdp);
+	return __ptep_test_and_clear_young(vma, address, (hw_pte_t *)pmdp);
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG */
 
 static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
 					       unsigned long address,
-					       pte_t *ptep,
+					       hw_pte_t *ptep,
 					       unsigned long pgsize)
 {
 	pte_t pte = __pte(xchg_relaxed(&pte_val(*ptep), 0));
@@ -1362,13 +1368,13 @@ static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
 }
 
 static inline pte_t __ptep_get_and_clear(struct mm_struct *mm,
-				       unsigned long address, pte_t *ptep)
+				       unsigned long address, hw_pte_t *ptep)
 {
 	return __ptep_get_and_clear_anysz(mm, address, ptep, PAGE_SIZE);
 }
 
 static inline void __clear_full_ptes(struct mm_struct *mm, unsigned long addr,
-				pte_t *ptep, unsigned int nr, int full)
+				hw_pte_t *ptep, unsigned int nr, int full)
 {
 	for (;;) {
 		__ptep_get_and_clear(mm, addr, ptep);
@@ -1380,7 +1386,7 @@ static inline void __clear_full_ptes(struct mm_struct *mm, unsigned long addr,
 }
 
 static inline pte_t __get_and_clear_full_ptes(struct mm_struct *mm,
-				unsigned long addr, pte_t *ptep,
+				unsigned long addr, hw_pte_t *ptep,
 				unsigned int nr, int full)
 {
 	pte_t pte, tmp_pte;
@@ -1403,12 +1409,12 @@ static inline pte_t __get_and_clear_full_ptes(struct mm_struct *mm,
 static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
 					    unsigned long address, pmd_t *pmdp)
 {
-	return pte_pmd(__ptep_get_and_clear_anysz(mm, address, (pte_t *)pmdp, PMD_SIZE));
+	return pte_pmd(__ptep_get_and_clear_anysz(mm, address, (hw_pte_t *)pmdp, PMD_SIZE));
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 static inline void ___ptep_set_wrprotect(struct mm_struct *mm,
-					unsigned long address, pte_t *ptep,
+					unsigned long address, hw_pte_t *ptep,
 					pte_t pte)
 {
 	pte_t old_pte;
@@ -1426,13 +1432,13 @@ static inline void ___ptep_set_wrprotect(struct mm_struct *mm,
  * dirty status (PTE_DBM && !PTE_RDONLY) to the software PTE_DIRTY bit.
  */
 static inline void __ptep_set_wrprotect(struct mm_struct *mm,
-					unsigned long address, pte_t *ptep)
+					unsigned long address, hw_pte_t *ptep)
 {
 	___ptep_set_wrprotect(mm, address, ptep, __ptep_get(ptep));
 }
 
 static inline void __wrprotect_ptes(struct mm_struct *mm, unsigned long address,
-				pte_t *ptep, unsigned int nr)
+				hw_pte_t *ptep, unsigned int nr)
 {
 	unsigned int i;
 
@@ -1441,7 +1447,7 @@ static inline void __wrprotect_ptes(struct mm_struct *mm, unsigned long address,
 }
 
 static inline void __clear_young_dirty_pte(struct vm_area_struct *vma,
-					   unsigned long addr, pte_t *ptep,
+					   unsigned long addr, hw_pte_t *ptep,
 					   pte_t pte, cydp_t flags)
 {
 	pte_t old_pte;
@@ -1460,7 +1466,8 @@ static inline void __clear_young_dirty_pte(struct vm_area_struct *vma,
 }
 
 static inline void __clear_young_dirty_ptes(struct vm_area_struct *vma,
-					    unsigned long addr, pte_t *ptep,
+					    unsigned long addr,
+					    hw_pte_t *ptep,
 					    unsigned int nr, cydp_t flags)
 {
 	pte_t pte;
@@ -1485,7 +1492,7 @@ static inline void __clear_young_dirty_ptes(struct vm_area_struct *vma,
 static inline void pmdp_set_wrprotect(struct mm_struct *mm,
 				      unsigned long address, pmd_t *pmdp)
 {
-	__ptep_set_wrprotect(mm, address, (pte_t *)pmdp);
+	__ptep_set_wrprotect(mm, address, (hw_pte_t *)pmdp);
 }
 
 #define pmdp_establish pmdp_establish
@@ -1558,7 +1565,8 @@ extern void arch_swap_restore(swp_entry_t entry, struct folio *folio);
  * On AArch64, the cache coherency is handled via the __set_ptes() function.
  */
 static inline void update_mmu_cache_range(struct vm_fault *vmf,
-		struct vm_area_struct *vma, unsigned long addr, pte_t *ptep,
+		struct vm_area_struct *vma, unsigned long addr,
+		hw_pte_t *ptep,
 		unsigned int nr)
 {
 	/*
@@ -1613,21 +1621,21 @@ static inline bool pud_sect_supported(void)
 #define __HAVE_ARCH_PTEP_MODIFY_PROT_TRANSACTION
 #define ptep_modify_prot_start ptep_modify_prot_start
 extern pte_t ptep_modify_prot_start(struct vm_area_struct *vma,
-				    unsigned long addr, pte_t *ptep);
+				    unsigned long addr, hw_pte_t *ptep);
 
 #define ptep_modify_prot_commit ptep_modify_prot_commit
 extern void ptep_modify_prot_commit(struct vm_area_struct *vma,
-				    unsigned long addr, pte_t *ptep,
+				    unsigned long addr, hw_pte_t *ptep,
 				    pte_t old_pte, pte_t new_pte);
 
 #define modify_prot_start_ptes modify_prot_start_ptes
 extern pte_t modify_prot_start_ptes(struct vm_area_struct *vma,
-				    unsigned long addr, pte_t *ptep,
+				    unsigned long addr, hw_pte_t *ptep,
 				    unsigned int nr);
 
 #define modify_prot_commit_ptes modify_prot_commit_ptes
 extern void modify_prot_commit_ptes(struct vm_area_struct *vma, unsigned long addr,
-				    pte_t *ptep, pte_t old_pte, pte_t pte,
+				    hw_pte_t *ptep, pte_t old_pte, pte_t pte,
 				    unsigned int nr);
 
 #ifdef CONFIG_ARM64_CONTPTE
@@ -1638,33 +1646,35 @@ extern void modify_prot_commit_ptes(struct vm_area_struct *vma, unsigned long ad
  * a private implementation detail of the public ptep API (see below).
  */
 extern void __contpte_try_fold(struct mm_struct *mm, unsigned long addr,
-				pte_t *ptep, pte_t pte);
+				hw_pte_t *ptep, pte_t pte);
 extern void __contpte_try_unfold(struct mm_struct *mm, unsigned long addr,
-				pte_t *ptep, pte_t pte);
-extern pte_t contpte_ptep_get(pte_t *ptep, pte_t orig_pte);
-extern pte_t contpte_ptep_get_lockless(pte_t *orig_ptep);
+				hw_pte_t *ptep, pte_t pte);
+extern pte_t contpte_ptep_get(hw_pte_t *ptep, pte_t orig_pte);
+extern pte_t contpte_ptep_get_lockless(hw_pte_t *orig_ptep);
 extern void contpte_set_ptes(struct mm_struct *mm, unsigned long addr,
-				pte_t *ptep, pte_t pte, unsigned int nr);
+				hw_pte_t *ptep, pte_t pte, unsigned int nr);
 extern void contpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
-				pte_t *ptep, unsigned int nr, int full);
+				hw_pte_t *ptep, unsigned int nr, int full);
 extern pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
-				unsigned long addr, pte_t *ptep,
+				unsigned long addr, hw_pte_t *ptep,
 				unsigned int nr, int full);
 bool contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
-				unsigned long addr, pte_t *ptep, unsigned int nr);
+				unsigned long addr, hw_pte_t *ptep,
+				unsigned int nr);
 bool contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
-				unsigned long addr, pte_t *ptep, unsigned int nr);
+				unsigned long addr, hw_pte_t *ptep,
+				unsigned int nr);
 extern void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
-				pte_t *ptep, unsigned int nr);
+				hw_pte_t *ptep, unsigned int nr);
 extern int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
-				unsigned long addr, pte_t *ptep,
+				unsigned long addr, hw_pte_t *ptep,
 				pte_t entry, int dirty);
 extern void contpte_clear_young_dirty_ptes(struct vm_area_struct *vma,
-				unsigned long addr, pte_t *ptep,
+				unsigned long addr, hw_pte_t *ptep,
 				unsigned int nr, cydp_t flags);
 
 static __always_inline void contpte_try_fold(struct mm_struct *mm,
-				unsigned long addr, pte_t *ptep, pte_t pte)
+				unsigned long addr, hw_pte_t *ptep, pte_t pte)
 {
 	/*
 	 * Only bother trying if both the virtual and physical addresses are
@@ -1687,14 +1697,14 @@ static __always_inline void contpte_try_fold(struct mm_struct *mm,
 }
 
 static __always_inline void contpte_try_unfold(struct mm_struct *mm,
-				unsigned long addr, pte_t *ptep, pte_t pte)
+				unsigned long addr, hw_pte_t *ptep, pte_t pte)
 {
 	if (unlikely(pte_valid_cont(pte)))
 		__contpte_try_unfold(mm, addr, ptep, pte);
 }
 
 #define pte_batch_hint pte_batch_hint
-static inline unsigned int pte_batch_hint(pte_t *ptep, pte_t pte)
+static inline unsigned int pte_batch_hint(hw_pte_t *ptep, pte_t pte)
 {
 	if (!pte_valid_cont(pte))
 		return 1;
@@ -1721,7 +1731,7 @@ static inline unsigned int pte_batch_hint(pte_t *ptep, pte_t pte)
  */
 
 #define ptep_get ptep_get
-static inline pte_t ptep_get(pte_t *ptep)
+static inline pte_t ptep_get(hw_pte_t *ptep)
 {
 	pte_t pte = __ptep_get(ptep);
 
@@ -1732,7 +1742,7 @@ static inline pte_t ptep_get(pte_t *ptep)
 }
 
 #define ptep_get_lockless ptep_get_lockless
-static inline pte_t ptep_get_lockless(pte_t *ptep)
+static inline pte_t ptep_get_lockless(hw_pte_t *ptep)
 {
 	pte_t pte = __ptep_get(ptep);
 
@@ -1742,7 +1752,7 @@ static inline pte_t ptep_get_lockless(pte_t *ptep)
 	return contpte_ptep_get_lockless(ptep);
 }
 
-static inline void set_pte(pte_t *ptep, pte_t pte)
+static inline void set_pte(hw_pte_t *ptep, pte_t pte)
 {
 	/*
 	 * We don't have the mm or vaddr so cannot unfold contig entries (since
@@ -1759,7 +1769,7 @@ static inline void set_pte(pte_t *ptep, pte_t pte)
 
 #define set_ptes set_ptes
 static __always_inline void set_ptes(struct mm_struct *mm, unsigned long addr,
-				pte_t *ptep, pte_t pte, unsigned int nr)
+				hw_pte_t *ptep, pte_t pte, unsigned int nr)
 {
 	pte = pte_mknoncont(pte);
 
@@ -1773,7 +1783,7 @@ static __always_inline void set_ptes(struct mm_struct *mm, unsigned long addr,
 }
 
 static inline void pte_clear(struct mm_struct *mm,
-				unsigned long addr, pte_t *ptep)
+				unsigned long addr, hw_pte_t *ptep)
 {
 	contpte_try_unfold(mm, addr, ptep, __ptep_get(ptep));
 	__pte_clear(mm, addr, ptep);
@@ -1781,7 +1791,7 @@ static inline void pte_clear(struct mm_struct *mm,
 
 #define clear_full_ptes clear_full_ptes
 static inline void clear_full_ptes(struct mm_struct *mm, unsigned long addr,
-				pte_t *ptep, unsigned int nr, int full)
+				hw_pte_t *ptep, unsigned int nr, int full)
 {
 	if (likely(nr == 1)) {
 		contpte_try_unfold(mm, addr, ptep, __ptep_get(ptep));
@@ -1793,7 +1803,7 @@ static inline void clear_full_ptes(struct mm_struct *mm, unsigned long addr,
 
 #define get_and_clear_full_ptes get_and_clear_full_ptes
 static inline pte_t get_and_clear_full_ptes(struct mm_struct *mm,
-				unsigned long addr, pte_t *ptep,
+				unsigned long addr, hw_pte_t *ptep,
 				unsigned int nr, int full)
 {
 	pte_t pte;
@@ -1810,13 +1820,13 @@ static inline pte_t get_and_clear_full_ptes(struct mm_struct *mm,
 
 #define __HAVE_ARCH_PTEP_GET_AND_CLEAR
 static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
-				unsigned long addr, pte_t *ptep)
+				unsigned long addr, hw_pte_t *ptep)
 {
 	contpte_try_unfold(mm, addr, ptep, __ptep_get(ptep));
 	return __ptep_get_and_clear(mm, addr, ptep);
 }
 
-static inline bool ptep_try_set(pte_t *ptep, pte_t new_pte)
+static inline bool ptep_try_set(hw_pte_t *ptep, pte_t new_pte)
 {
 	pteval_t old = 0;
 
@@ -1846,7 +1856,7 @@ static inline void flush_tlb_before_set(unsigned long addr)
 
 #define test_and_clear_young_ptes test_and_clear_young_ptes
 static inline bool test_and_clear_young_ptes(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep, unsigned int nr)
+		unsigned long addr, hw_pte_t *ptep, unsigned int nr)
 {
 	if (likely(nr == 1 && !pte_cont(__ptep_get(ptep))))
 		return __ptep_test_and_clear_young(vma, addr, ptep);
@@ -1856,14 +1866,14 @@ static inline bool test_and_clear_young_ptes(struct vm_area_struct *vma,
 
 #define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep)
+		unsigned long addr, hw_pte_t *ptep)
 {
 	return test_and_clear_young_ptes(vma, addr, ptep, 1);
 }
 
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
 static inline bool ptep_clear_flush_young(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep)
+		unsigned long addr, hw_pte_t *ptep)
 {
 	pte_t orig_pte = __ptep_get(ptep);
 
@@ -1875,7 +1885,7 @@ static inline bool ptep_clear_flush_young(struct vm_area_struct *vma,
 
 #define clear_flush_young_ptes clear_flush_young_ptes
 static inline bool clear_flush_young_ptes(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep, unsigned int nr)
+		unsigned long addr, hw_pte_t *ptep, unsigned int nr)
 {
 	if (likely(nr == 1 && !pte_cont(__ptep_get(ptep))))
 		return __ptep_clear_flush_young(vma, addr, ptep);
@@ -1885,7 +1895,8 @@ static inline bool clear_flush_young_ptes(struct vm_area_struct *vma,
 
 #define wrprotect_ptes wrprotect_ptes
 static __always_inline void wrprotect_ptes(struct mm_struct *mm,
-				unsigned long addr, pte_t *ptep, unsigned int nr)
+				unsigned long addr, hw_pte_t *ptep,
+				unsigned int nr)
 {
 	if (likely(nr == 1)) {
 		/*
@@ -1909,14 +1920,14 @@ static __always_inline void wrprotect_ptes(struct mm_struct *mm,
 
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT
 static inline void ptep_set_wrprotect(struct mm_struct *mm,
-				unsigned long addr, pte_t *ptep)
+				unsigned long addr, hw_pte_t *ptep)
 {
 	wrprotect_ptes(mm, addr, ptep, 1);
 }
 
 #define __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 static inline int ptep_set_access_flags(struct vm_area_struct *vma,
-				unsigned long addr, pte_t *ptep,
+				unsigned long addr, hw_pte_t *ptep,
 				pte_t entry, int dirty)
 {
 	pte_t orig_pte = __ptep_get(ptep);
@@ -1931,7 +1942,7 @@ static inline int ptep_set_access_flags(struct vm_area_struct *vma,
 
 #define clear_young_dirty_ptes clear_young_dirty_ptes
 static inline void clear_young_dirty_ptes(struct vm_area_struct *vma,
-					  unsigned long addr, pte_t *ptep,
+					  unsigned long addr, hw_pte_t *ptep,
 					  unsigned int nr, cydp_t flags)
 {
 	if (likely(nr == 1 && !pte_cont(__ptep_get(ptep))))
diff --git a/arch/arm64/include/asm/vmalloc.h b/arch/arm64/include/asm/vmalloc.h
index 4ec1acd3c1b34..28d3e89f90e43 100644
--- a/arch/arm64/include/asm/vmalloc.h
+++ b/arch/arm64/include/asm/vmalloc.h
@@ -45,7 +45,7 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
 
 #define arch_vmap_pte_range_unmap_size arch_vmap_pte_range_unmap_size
 static inline unsigned long arch_vmap_pte_range_unmap_size(unsigned long addr,
-							   pte_t *ptep)
+							   hw_pte_t *ptep)
 {
 	/*
 	 * The caller handles alignment so it's sufficient just to check
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 0ec90fd1754ed..68ff21310604d 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -111,7 +111,8 @@ struct set_perm_data {
 	bool			has_bti;
 };
 
-static int __init set_permissions(pte_t *ptep, unsigned long addr, void *data)
+static int __init set_permissions(hw_pte_t *ptep, unsigned long addr,
+				  void *data)
 {
 	struct set_perm_data *spd = data;
 	const efi_memory_desc_t *md = spd->md;
diff --git a/arch/arm64/kernel/pi/map_kernel.c b/arch/arm64/kernel/pi/map_kernel.c
index fb44cbdd2f292..2b7e7be5fd6f3 100644
--- a/arch/arm64/kernel/pi/map_kernel.c
+++ b/arch/arm64/kernel/pi/map_kernel.c
@@ -26,7 +26,7 @@ static void __init map_segment(pgd_t *pg_dir, phys_addr_t *pgd, u64 va_offset,
 {
 	map_range(pgd, ((u64)start + va_offset) & ~PAGE_OFFSET,
 		  ((u64)end + va_offset) & ~PAGE_OFFSET, (u64)start,
-		  prot, root_level, (pte_t *)pg_dir, may_use_cont, 0);
+		  prot, root_level, (hw_pte_t *)pg_dir, may_use_cont, 0);
 }
 
 static void __init unmap_segment(pgd_t *pg_dir, u64 va_offset, void *start,
@@ -209,7 +209,7 @@ static void *__init map_fdt(phys_addr_t fdt)
 	 */
 	map_range(&ptep, fdt, (u64)_text > fdt ? min((u64)_text, efdt) : efdt,
 		  fdt, PAGE_KERNEL, IDMAP_ROOT_LEVEL,
-		  (pte_t *)init_idmap_pg_dir, false, 0);
+		  (hw_pte_t *)init_idmap_pg_dir, false, 0);
 	dsb(ishst);
 
 	return (void *)fdt;
diff --git a/arch/arm64/kernel/pi/map_range.c b/arch/arm64/kernel/pi/map_range.c
index 761b14893f748..94f06da76e333 100644
--- a/arch/arm64/kernel/pi/map_range.c
+++ b/arch/arm64/kernel/pi/map_range.c
@@ -27,7 +27,8 @@
  * 			in the VA space
  */
 void __init map_range(phys_addr_t *pte, u64 start, u64 end, phys_addr_t pa,
-		      pgprot_t prot, int level, pte_t *tbl, bool may_use_cont,
+		      pgprot_t prot, int level, hw_pte_t *tbl,
+		      bool may_use_cont,
 		      u64 va_offset)
 {
 	u64 cmask = (level == 3) ? CONT_PTE_SIZE - 1 : U64_MAX;
@@ -62,7 +63,7 @@ void __init map_range(phys_addr_t *pte, u64 start, u64 end, phys_addr_t pa,
 				*pte += PTRS_PER_PTE * sizeof(pte_t);
 			}
 			map_range(pte, start, next, pa, prot, level + 1,
-				  (pte_t *)(__pte_to_phys(*tbl) + va_offset),
+				  (hw_pte_t *)(__pte_to_phys(*tbl) + va_offset),
 				  may_use_cont, va_offset);
 		} else {
 			/*
@@ -100,10 +101,10 @@ asmlinkage phys_addr_t __init create_init_idmap(pgd_t *pg_dir, ptval_t clrmask)
 	/* MMU is off; pointer casts to phys_addr_t are safe */
 	map_range(&ptep, (u64)_stext, (u64)__initdata_begin,
 		  (phys_addr_t)_stext, text_prot, IDMAP_ROOT_LEVEL,
-		  (pte_t *)pg_dir, false, 0);
+		  (hw_pte_t *)pg_dir, false, 0);
 	map_range(&ptep, (u64)__initdata_begin, (u64)_end,
 		  (phys_addr_t)__initdata_begin, data_prot, IDMAP_ROOT_LEVEL,
-		  (pte_t *)pg_dir, false, 0);
+		  (hw_pte_t *)pg_dir, false, 0);
 
 	return ptep;
 }
diff --git a/arch/arm64/kernel/pi/pi.h b/arch/arm64/kernel/pi/pi.h
index 5dfd8484d2005..a7d09a2fa8f9f 100644
--- a/arch/arm64/kernel/pi/pi.h
+++ b/arch/arm64/kernel/pi/pi.h
@@ -2,6 +2,7 @@
 // Copyright 2023 Google LLC
 // Author: Ard Biesheuvel <ardb@google.com>
 
+#include <linux/pgtable_types.h>
 #include <linux/types.h>
 
 #define __prel64_initconst	__section(".init.rodata.prel64")
@@ -30,7 +31,7 @@ void relocate_kernel(u64 offset);
 int scs_patch(const u8 eh_frame[], int size, bool skip_dry_run);
 
 void map_range(phys_addr_t *pte, u64 start, u64 end, phys_addr_t pa,
-	       pgprot_t prot, int level, pte_t *tbl, bool may_use_cont,
+	       pgprot_t prot, int level, hw_pte_t *tbl, bool may_use_cont,
 	       u64 va_offset);
 
 asmlinkage void early_map_kernel(u64 boot_status, phys_addr_t fdt);
diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
index 0acab179fc1a5..753267c0b41e5 100644
--- a/arch/arm64/mm/contpte.c
+++ b/arch/arm64/mm/contpte.c
@@ -21,13 +21,14 @@ static inline bool mm_is_user(struct mm_struct *mm)
 	return mm != &init_mm;
 }
 
-static inline pte_t *contpte_align_down(pte_t *ptep)
+static inline hw_pte_t *contpte_align_down(hw_pte_t *ptep)
 {
 	return PTR_ALIGN_DOWN(ptep, sizeof(*ptep) * CONT_PTES);
 }
 
-static inline pte_t *contpte_align_addr_ptep(unsigned long *start,
-					     unsigned long *end, pte_t *ptep,
+static inline hw_pte_t *contpte_align_addr_ptep(unsigned long *start,
+					     unsigned long *end,
+					     hw_pte_t *ptep,
 					     unsigned int nr)
 {
 	/*
@@ -47,7 +48,7 @@ static inline pte_t *contpte_align_addr_ptep(unsigned long *start,
 }
 
 static void contpte_try_unfold_partial(struct mm_struct *mm, unsigned long addr,
-					pte_t *ptep, unsigned int nr)
+					hw_pte_t *ptep, unsigned int nr)
 {
 	/*
 	 * Unfold any partially covered contpte block at the beginning and end
@@ -59,7 +60,7 @@ static void contpte_try_unfold_partial(struct mm_struct *mm, unsigned long addr,
 
 	if (ptep + nr != contpte_align_down(ptep + nr)) {
 		unsigned long last_addr = addr + PAGE_SIZE * (nr - 1);
-		pte_t *last_ptep = ptep + nr - 1;
+		hw_pte_t *last_ptep = ptep + nr - 1;
 
 		contpte_try_unfold(mm, last_addr, last_ptep,
 				   __ptep_get(last_ptep));
@@ -67,11 +68,11 @@ static void contpte_try_unfold_partial(struct mm_struct *mm, unsigned long addr,
 }
 
 static void contpte_convert(struct mm_struct *mm, unsigned long addr,
-			    pte_t *ptep, pte_t pte)
+			    hw_pte_t *ptep, pte_t pte)
 {
 	struct vm_area_struct vma = TLB_FLUSH_VMA(mm, 0);
 	unsigned long start_addr;
-	pte_t *start_ptep;
+	hw_pte_t *start_ptep;
 	int i;
 
 	start_ptep = ptep = contpte_align_down(ptep);
@@ -227,7 +228,7 @@ static void contpte_convert(struct mm_struct *mm, unsigned long addr,
 }
 
 void __contpte_try_fold(struct mm_struct *mm, unsigned long addr,
-			pte_t *ptep, pte_t pte)
+			hw_pte_t *ptep, pte_t pte)
 {
 	/*
 	 * We have already checked that the virtual and pysical addresses are
@@ -253,7 +254,7 @@ void __contpte_try_fold(struct mm_struct *mm, unsigned long addr,
 	struct folio *folio;
 	struct page *page;
 	unsigned long pfn;
-	pte_t *orig_ptep;
+	hw_pte_t *orig_ptep;
 	pgprot_t prot;
 
 	int i;
@@ -291,7 +292,7 @@ void __contpte_try_fold(struct mm_struct *mm, unsigned long addr,
 EXPORT_SYMBOL_GPL(__contpte_try_fold);
 
 void __contpte_try_unfold(struct mm_struct *mm, unsigned long addr,
-			pte_t *ptep, pte_t pte)
+			hw_pte_t *ptep, pte_t pte)
 {
 	/*
 	 * We have already checked that the ptes are contiguous in
@@ -305,7 +306,7 @@ void __contpte_try_unfold(struct mm_struct *mm, unsigned long addr,
 }
 EXPORT_SYMBOL_GPL(__contpte_try_unfold);
 
-pte_t contpte_ptep_get(pte_t *ptep, pte_t orig_pte)
+pte_t contpte_ptep_get(hw_pte_t *ptep, pte_t orig_pte)
 {
 	/*
 	 * Gather access/dirty bits, which may be populated in any of the ptes
@@ -362,7 +363,7 @@ static inline bool contpte_is_consistent(pte_t pte, unsigned long pfn,
 			pgprot_val(prot) == pgprot_val(orig_prot);
 }
 
-pte_t contpte_ptep_get_lockless(pte_t *orig_ptep)
+pte_t contpte_ptep_get_lockless(hw_pte_t *orig_ptep)
 {
 	/*
 	 * The ptep_get_lockless() API requires us to read and return *orig_ptep
@@ -384,7 +385,7 @@ pte_t contpte_ptep_get_lockless(pte_t *orig_ptep)
 	pgprot_t orig_prot;
 	unsigned long pfn;
 	pte_t orig_pte;
-	pte_t *ptep;
+	hw_pte_t *ptep;
 	pte_t pte;
 	int i;
 
@@ -445,7 +446,8 @@ pte_t contpte_ptep_get_lockless(pte_t *orig_ptep)
 EXPORT_SYMBOL_GPL(contpte_ptep_get_lockless);
 
 void contpte_set_ptes(struct mm_struct *mm, unsigned long addr,
-					pte_t *ptep, pte_t pte, unsigned int nr)
+					hw_pte_t *ptep, pte_t pte,
+					unsigned int nr)
 {
 	unsigned long next;
 	unsigned long end;
@@ -488,7 +490,7 @@ void contpte_set_ptes(struct mm_struct *mm, unsigned long addr,
 EXPORT_SYMBOL_GPL(contpte_set_ptes);
 
 void contpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
-				pte_t *ptep, unsigned int nr, int full)
+				hw_pte_t *ptep, unsigned int nr, int full)
 {
 	contpte_try_unfold_partial(mm, addr, ptep, nr);
 	__clear_full_ptes(mm, addr, ptep, nr, full);
@@ -496,7 +498,7 @@ void contpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
 EXPORT_SYMBOL_GPL(contpte_clear_full_ptes);
 
 pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
-				unsigned long addr, pte_t *ptep,
+				unsigned long addr, hw_pte_t *ptep,
 				unsigned int nr, int full)
 {
 	contpte_try_unfold_partial(mm, addr, ptep, nr);
@@ -505,7 +507,7 @@ pte_t contpte_get_and_clear_full_ptes(struct mm_struct *mm,
 EXPORT_SYMBOL_GPL(contpte_get_and_clear_full_ptes);
 
 bool contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep, unsigned int nr)
+		unsigned long addr, hw_pte_t *ptep, unsigned int nr)
 {
 	/*
 	 * ptep_clear_flush_young() technically requires us to clear the access
@@ -531,7 +533,7 @@ bool contpte_test_and_clear_young_ptes(struct vm_area_struct *vma,
 EXPORT_SYMBOL_GPL(contpte_test_and_clear_young_ptes);
 
 bool contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep, unsigned int nr)
+		unsigned long addr, hw_pte_t *ptep, unsigned int nr)
 {
 	bool young;
 
@@ -554,7 +556,7 @@ bool contpte_clear_flush_young_ptes(struct vm_area_struct *vma,
 EXPORT_SYMBOL_GPL(contpte_clear_flush_young_ptes);
 
 void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
-					pte_t *ptep, unsigned int nr)
+					hw_pte_t *ptep, unsigned int nr)
 {
 	/*
 	 * If wrprotecting an entire contig range, we can avoid unfolding. Just
@@ -572,7 +574,7 @@ void contpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
 EXPORT_SYMBOL_GPL(contpte_wrprotect_ptes);
 
 void contpte_clear_young_dirty_ptes(struct vm_area_struct *vma,
-				    unsigned long addr, pte_t *ptep,
+				    unsigned long addr, hw_pte_t *ptep,
 				    unsigned int nr, cydp_t flags)
 {
 	/*
@@ -593,9 +595,10 @@ void contpte_clear_young_dirty_ptes(struct vm_area_struct *vma,
 }
 EXPORT_SYMBOL_GPL(contpte_clear_young_dirty_ptes);
 
-static bool contpte_all_subptes_match_access_flags(pte_t *ptep, pte_t entry)
+static bool contpte_all_subptes_match_access_flags(hw_pte_t *ptep,
+						   pte_t entry)
 {
-	pte_t *cont_ptep = contpte_align_down(ptep);
+	hw_pte_t *cont_ptep = contpte_align_down(ptep);
 	/*
 	 * PFNs differ per sub-PTE. Match only bits consumed by
 	 * __ptep_set_access_flags(): AF, DIRTY and write permission.
@@ -615,7 +618,7 @@ static bool contpte_all_subptes_match_access_flags(pte_t *ptep, pte_t entry)
 }
 
 int contpte_ptep_set_access_flags(struct vm_area_struct *vma,
-					unsigned long addr, pte_t *ptep,
+					unsigned long addr, hw_pte_t *ptep,
 					pte_t entry, int dirty)
 {
 	unsigned long start_addr;
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 0b52557652be6..b77f4be88e3ea 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -162,7 +162,8 @@ static void show_pte(unsigned long addr)
 		p4d_t *p4dp, p4d;
 		pud_t *pudp, pud;
 		pmd_t *pmdp, pmd;
-		pte_t *ptep, pte;
+		hw_pte_t *ptep;
+		pte_t pte;
 
 		if (pgd_none(pgd) || pgd_bad(pgd))
 			break;
@@ -208,7 +209,7 @@ static void show_pte(unsigned long addr)
  * Returns whether or not the PTE actually changed.
  */
 int __ptep_set_access_flags_anysz(struct vm_area_struct *vma,
-				  unsigned long address, pte_t *ptep,
+				  unsigned long address, hw_pte_t *ptep,
 				  pte_t entry, int dirty, unsigned long pgsize)
 {
 	pteval_t old_pteval, pteval;
diff --git a/arch/arm64/mm/fixmap.c b/arch/arm64/mm/fixmap.c
index f66a0016dd02d..237a9136bc73b 100644
--- a/arch/arm64/mm/fixmap.c
+++ b/arch/arm64/mm/fixmap.c
@@ -35,7 +35,7 @@ static pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __bss_pgtbl;
 static pmd_t bm_pmd[PTRS_PER_PMD] __bss_pgtbl __maybe_unused;
 static pud_t bm_pud[PTRS_PER_PUD] __bss_pgtbl __maybe_unused;
 
-static inline pte_t *fixmap_pte(unsigned long addr)
+static inline hw_pte_t *fixmap_pte(unsigned long addr)
 {
 	return &bm_pte[BM_PTE_TABLE_IDX(addr)][pte_index(addr)];
 }
@@ -43,7 +43,7 @@ static inline pte_t *fixmap_pte(unsigned long addr)
 static void __init early_fixmap_init_pte(pmd_t *pmdp, unsigned long addr)
 {
 	pmd_t pmd = READ_ONCE(*pmdp);
-	pte_t *ptep;
+	hw_pte_t *ptep;
 
 	if (pmd_none(pmd)) {
 		ptep = bm_pte[BM_PTE_TABLE_IDX(addr)];
@@ -120,7 +120,7 @@ void __set_fixmap(enum fixed_addresses idx,
 			       phys_addr_t phys, pgprot_t flags)
 {
 	unsigned long addr = __fix_to_virt(idx);
-	pte_t *ptep;
+	hw_pte_t *ptep;
 
 	BUG_ON(idx <= FIX_HOLE || idx >= __end_of_fixed_addresses);
 
diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index 8e799c1fe0aa6..560c0f16cd8e4 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -76,7 +76,7 @@ bool arch_hugetlb_migration_supported(struct hstate *h)
 #endif
 
 static int find_num_contig(struct mm_struct *mm, unsigned long addr,
-			   pte_t *ptep, size_t *pgsize)
+			   hw_pte_t *ptep, size_t *pgsize)
 {
 	pgd_t *pgdp = pgd_offset(mm, addr);
 	p4d_t *p4dp;
@@ -87,7 +87,7 @@ static int find_num_contig(struct mm_struct *mm, unsigned long addr,
 	p4dp = p4d_offset(pgdp, addr);
 	pudp = pud_offset(p4dp, addr);
 	pmdp = pmd_offset(pudp, addr);
-	if ((pte_t *)PTR_ALIGN_DOWN(pmdp, sizeof(*pmdp) * CONT_PMDS) == ptep) {
+	if ((hw_pte_t *)PTR_ALIGN_DOWN(pmdp, sizeof(*pmdp) * CONT_PMDS) == ptep) {
 		*pgsize = PMD_SIZE;
 		return CONT_PMDS;
 	}
@@ -116,7 +116,7 @@ static inline int num_contig_ptes(unsigned long size, size_t *pgsize)
 	return contig_ptes;
 }
 
-pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, hw_pte_t *ptep)
 {
 	int ncontig, i;
 	size_t pgsize;
@@ -148,7 +148,7 @@ pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
  */
 static pte_t get_clear_contig(struct mm_struct *mm,
 			     unsigned long addr,
-			     pte_t *ptep,
+			     hw_pte_t *ptep,
 			     unsigned long pgsize,
 			     unsigned long ncontig)
 {
@@ -173,7 +173,7 @@ static pte_t get_clear_contig(struct mm_struct *mm,
 
 static pte_t get_clear_contig_flush(struct mm_struct *mm,
 				    unsigned long addr,
-				    pte_t *ptep,
+				    hw_pte_t *ptep,
 				    unsigned long pgsize,
 				    unsigned long ncontig)
 {
@@ -196,7 +196,7 @@ static pte_t get_clear_contig_flush(struct mm_struct *mm,
  */
 static void clear_flush(struct mm_struct *mm,
 			     unsigned long addr,
-			     pte_t *ptep,
+			     hw_pte_t *ptep,
 			     unsigned long pgsize,
 			     unsigned long ncontig)
 {
@@ -213,7 +213,7 @@ static void clear_flush(struct mm_struct *mm,
 }
 
 void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
-			    pte_t *ptep, pte_t pte, unsigned long sz)
+			    hw_pte_t *ptep, pte_t pte, unsigned long sz)
 {
 	size_t pgsize;
 	int i;
@@ -234,14 +234,14 @@ void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
 	__set_ptes_anysz(mm, addr, ptep, pte, ncontig, pgsize);
 }
 
-pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
+hw_pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
 		      unsigned long addr, unsigned long sz)
 {
 	pgd_t *pgdp;
 	p4d_t *p4dp;
 	pud_t *pudp;
 	pmd_t *pmdp;
-	pte_t *ptep = NULL;
+	hw_pte_t *ptep = NULL;
 
 	pgdp = pgd_offset(mm, addr);
 	p4dp = p4d_alloc(mm, pgdp, addr);
@@ -253,7 +253,7 @@ pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
 		return NULL;
 
 	if (sz == PUD_SIZE) {
-		ptep = (pte_t *)pudp;
+		ptep = (hw_pte_t *)pudp;
 	} else if (sz == (CONT_PTE_SIZE)) {
 		pmdp = pmd_alloc(mm, pudp, addr);
 		if (!pmdp)
@@ -265,17 +265,17 @@ pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
 		if (want_pmd_share(vma, addr) && pud_none(READ_ONCE(*pudp)))
 			ptep = huge_pmd_share(mm, vma, addr, pudp);
 		else
-			ptep = (pte_t *)pmd_alloc(mm, pudp, addr);
+			ptep = (hw_pte_t *)pmd_alloc(mm, pudp, addr);
 	} else if (sz == (CONT_PMD_SIZE)) {
 		pmdp = pmd_alloc(mm, pudp, addr);
 		WARN_ON(addr & (sz - 1));
-		return (pte_t *)pmdp;
+		return (hw_pte_t *)pmdp;
 	}
 
 	return ptep;
 }
 
-pte_t *huge_pte_offset(struct mm_struct *mm,
+hw_pte_t *huge_pte_offset(struct mm_struct *mm,
 		       unsigned long addr, unsigned long sz)
 {
 	pgd_t *pgdp;
@@ -297,7 +297,7 @@ pte_t *huge_pte_offset(struct mm_struct *mm,
 		return NULL;
 	/* hugepage or swap? */
 	if (pud_leaf(pud) || !pud_present(pud))
-		return (pte_t *)pudp;
+		return (hw_pte_t *)pudp;
 	/* table; check the next level */
 
 	if (sz == CONT_PMD_SIZE)
@@ -309,7 +309,7 @@ pte_t *huge_pte_offset(struct mm_struct *mm,
 	    pmd_none(pmd))
 		return NULL;
 	if (pmd_leaf(pmd) || !pmd_present(pmd))
-		return (pte_t *)pmdp;
+		return (hw_pte_t *)pmdp;
 
 	if (sz == CONT_PTE_SIZE)
 		return pte_offset_huge(pmdp, (addr & CONT_PTE_MASK));
@@ -367,7 +367,7 @@ pte_t arch_make_huge_pte(pte_t entry, unsigned int shift, vm_flags_t flags)
 }
 
 void huge_pte_clear(struct mm_struct *mm, unsigned long addr,
-		    pte_t *ptep, unsigned long sz)
+		    hw_pte_t *ptep, unsigned long sz)
 {
 	int i, ncontig;
 	size_t pgsize;
@@ -379,7 +379,7 @@ void huge_pte_clear(struct mm_struct *mm, unsigned long addr,
 }
 
 pte_t huge_ptep_get_and_clear(struct mm_struct *mm, unsigned long addr,
-			      pte_t *ptep, unsigned long sz)
+			      hw_pte_t *ptep, unsigned long sz)
 {
 	int ncontig;
 	size_t pgsize;
@@ -397,7 +397,7 @@ pte_t huge_ptep_get_and_clear(struct mm_struct *mm, unsigned long addr,
  * all the contiguous ptes we need to check whether or not there is a
  * discrepancy between dirty or young.
  */
-static int __cont_access_flags_changed(pte_t *ptep, pte_t pte, int ncontig)
+static int __cont_access_flags_changed(hw_pte_t *ptep, pte_t pte, int ncontig)
 {
 	int i;
 
@@ -418,7 +418,7 @@ static int __cont_access_flags_changed(pte_t *ptep, pte_t pte, int ncontig)
 }
 
 int huge_ptep_set_access_flags(struct vm_area_struct *vma,
-			       unsigned long addr, pte_t *ptep,
+			       unsigned long addr, hw_pte_t *ptep,
 			       pte_t pte, int dirty)
 {
 	int ncontig;
@@ -451,7 +451,7 @@ int huge_ptep_set_access_flags(struct vm_area_struct *vma,
 }
 
 void huge_ptep_set_wrprotect(struct mm_struct *mm,
-			     unsigned long addr, pte_t *ptep)
+			     unsigned long addr, hw_pte_t *ptep)
 {
 	int ncontig;
 	size_t pgsize;
@@ -474,7 +474,7 @@ void huge_ptep_set_wrprotect(struct mm_struct *mm,
 }
 
 pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
-			    unsigned long addr, pte_t *ptep)
+			    unsigned long addr, hw_pte_t *ptep)
 {
 	struct mm_struct *mm = vma->vm_mm;
 	size_t pgsize;
@@ -514,7 +514,8 @@ bool __init arch_hugetlb_valid_size(unsigned long size)
 	return __hugetlb_valid_size(size);
 }
 
-pte_t huge_ptep_modify_prot_start(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
+pte_t huge_ptep_modify_prot_start(struct vm_area_struct *vma, unsigned long addr,
+				  hw_pte_t *ptep)
 {
 	unsigned long psize = huge_page_size(hstate_vma(vma));
 
@@ -530,7 +531,8 @@ pte_t huge_ptep_modify_prot_start(struct vm_area_struct *vma, unsigned long addr
 	return huge_ptep_get_and_clear(vma->vm_mm, addr, ptep, psize);
 }
 
-void huge_ptep_modify_prot_commit(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep,
+void huge_ptep_modify_prot_commit(struct vm_area_struct *vma, unsigned long addr,
+				  hw_pte_t *ptep,
 				  pte_t old_pte, pte_t pte)
 {
 	unsigned long psize = huge_page_size(hstate_vma(vma));
diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
index 45fbdce684c89..dccb736b32e9b 100644
--- a/arch/arm64/mm/kasan_init.c
+++ b/arch/arm64/mm/kasan_init.c
@@ -59,7 +59,7 @@ static phys_addr_t __init kasan_alloc_raw_page(int node)
 	return __pa(p);
 }
 
-static pte_t *__init kasan_pte_offset(pmd_t *pmdp, unsigned long addr, int node,
+static hw_pte_t *__init kasan_pte_offset(pmd_t *pmdp, unsigned long addr, int node,
 				      bool early)
 {
 	if (pmd_none(READ_ONCE(*pmdp))) {
@@ -116,7 +116,7 @@ static void __init kasan_pte_populate(pmd_t *pmdp, unsigned long addr,
 				      unsigned long end, int node, bool early)
 {
 	unsigned long next;
-	pte_t *ptep = kasan_pte_offset(pmdp, addr, node, early);
+	hw_pte_t *ptep = kasan_pte_offset(pmdp, addr, node, early);
 
 	do {
 		phys_addr_t page_phys = early ?
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 79d90226fd5dc..f02b974ad64df 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -159,7 +159,7 @@ static void init_clear_pgtable(void *table)
 	dsb(ishst);
 }
 
-static void init_pte(pte_t *ptep, unsigned long addr, unsigned long end,
+static void init_pte(hw_pte_t *ptep, unsigned long addr, unsigned long end,
 		     phys_addr_t phys, pgprot_t prot)
 {
 	do {
@@ -182,7 +182,7 @@ static void init_pte(pte_t *ptep, unsigned long addr, unsigned long end,
 	} while (ptep++, addr += PAGE_SIZE, addr != end);
 }
 
-static bool pte_range_has_valid_noncont(pte_t *ptep)
+static bool pte_range_has_valid_noncont(hw_pte_t *ptep)
 {
 	for (int i = 0; i < CONT_PTES; i++) {
 		pte_t pte = __ptep_get(&ptep[i]);
@@ -201,7 +201,7 @@ static int alloc_init_cont_pte(pmd_t *pmdp, unsigned long addr,
 {
 	unsigned long next;
 	pmd_t pmd = READ_ONCE(*pmdp);
-	pte_t *ptep;
+	hw_pte_t *ptep;
 
 	BUG_ON(pmd_leaf(pmd));
 	if (pmd_none(pmd)) {
@@ -592,7 +592,7 @@ pgd_pgtable_alloc_special_mm(enum pgtable_level pgtable_level)
 	return  __pgd_pgtable_alloc(NULL, GFP_PGTABLE_KERNEL, pgtable_level);
 }
 
-static void split_contpte(pte_t *ptep)
+static void split_contpte(hw_pte_t *ptep)
 {
 	int i;
 
@@ -607,13 +607,13 @@ static int split_pmd(pmd_t *pmdp, pmd_t pmd, gfp_t gfp, bool to_cont)
 	unsigned long pfn = pmd_pfn(pmd);
 	pgprot_t prot = pmd_pgprot(pmd);
 	phys_addr_t pte_phys;
-	pte_t *ptep;
+	hw_pte_t *ptep;
 	int i;
 
 	pte_phys = pgd_pgtable_alloc_init_mm_gfp(PGTABLE_LEVEL_PTE, gfp);
 	if (pte_phys == INVALID_PHYS_ADDR)
 		return -ENOMEM;
-	ptep = (pte_t *)phys_to_virt(pte_phys);
+	ptep = (hw_pte_t *)phys_to_virt(pte_phys);
 
 	if (pgprot_val(prot) & PMD_SECT_PXN)
 		tableprot |= PMD_TABLE_PXN;
@@ -691,7 +691,8 @@ static int split_kernel_leaf_mapping_locked(unsigned long addr)
 	p4d_t *p4dp, p4d;
 	pud_t *pudp, pud;
 	pmd_t *pmdp, pmd;
-	pte_t *ptep, pte;
+	hw_pte_t *ptep;
+	pte_t pte;
 	int ret = 0;
 
 	/*
@@ -904,7 +905,7 @@ static int split_to_ptes_pmd_entry(pmd_t *pmdp, unsigned long addr,
 	return ret;
 }
 
-static int split_to_ptes_pte_entry(pte_t *ptep, unsigned long addr,
+static int split_to_ptes_pte_entry(hw_pte_t *ptep, unsigned long addr,
 				   unsigned long next, struct mm_walk *walk)
 {
 	pte_t pte = __ptep_get(ptep);
@@ -1438,7 +1439,8 @@ static void __init declare_kernel_vmas(void)
 }
 
 void __pi_map_range(phys_addr_t *pte, u64 start, u64 end, phys_addr_t pa,
-		    pgprot_t prot, int level, pte_t *tbl, bool may_use_cont,
+		    pgprot_t prot, int level, hw_pte_t *tbl,
+		    bool may_use_cont,
 		    u64 va_offset);
 
 static u8 idmap_ptes[IDMAP_LEVELS - 1][PAGE_SIZE] __aligned(PAGE_SIZE) __ro_after_init,
@@ -1451,7 +1453,7 @@ static void __init create_idmap(void)
 	phys_addr_t ptep  = __pa_symbol(idmap_ptes);
 
 	__pi_map_range(&ptep, start, end, start, PAGE_KERNEL_ROX,
-		       IDMAP_ROOT_LEVEL, (pte_t *)idmap_pg_dir, false,
+		       IDMAP_ROOT_LEVEL, (hw_pte_t *)idmap_pg_dir, false,
 		       __phys_to_virt(ptep) - ptep);
 
 	if (linear_map_requires_bbml3 ||
@@ -1466,7 +1468,8 @@ static void __init create_idmap(void)
 		 */
 		ptep = __pa_symbol(kpti_bbml3_ptes);
 		__pi_map_range(&ptep, pa, pa + sizeof(u32), pa, PAGE_KERNEL,
-			       IDMAP_ROOT_LEVEL, (pte_t *)idmap_pg_dir, false,
+			       IDMAP_ROOT_LEVEL, (hw_pte_t *)idmap_pg_dir,
+			       false,
 			       __phys_to_virt(ptep) - ptep);
 	}
 }
@@ -1522,7 +1525,8 @@ static void unmap_hotplug_pte_range(pmd_t *pmdp, unsigned long addr,
 				    unsigned long end, bool free_mapped,
 				    struct vmem_altmap *altmap)
 {
-	pte_t *ptep, pte;
+	hw_pte_t *ptep;
+	pte_t pte;
 
 	do {
 		ptep = pte_offset_kernel(pmdp, addr);
@@ -1665,7 +1669,8 @@ static void free_empty_pte_table(pmd_t *pmdp, unsigned long addr,
 				 unsigned long end, unsigned long floor,
 				 unsigned long ceiling)
 {
-	pte_t *ptep, pte;
+	hw_pte_t *ptep;
+	pte_t pte;
 	unsigned long i, start = addr;
 
 	do {
@@ -1914,7 +1919,7 @@ int pmd_clear_huge(pmd_t *pmdp)
 
 int pmd_free_pte_page(pmd_t *pmdp, unsigned long addr)
 {
-	pte_t *table;
+	hw_pte_t *table;
 	pmd_t pmd;
 
 	pmd = READ_ONCE(*pmdp);
@@ -2056,7 +2061,8 @@ static bool addr_splits_kernel_leaf(unsigned long addr)
 	p4d_t *p4dp, p4d;
 	pud_t *pudp, pud;
 	pmd_t *pmdp, pmd;
-	pte_t *ptep, pte;
+	hw_pte_t *ptep;
+	pte_t pte;
 
 	/*
 	 * If the given address points at a the start address of
@@ -2284,7 +2290,7 @@ early_initcall(prevent_memory_remove_init);
 #endif
 
 pte_t modify_prot_start_ptes(struct vm_area_struct *vma, unsigned long addr,
-			     pte_t *ptep, unsigned int nr)
+			     hw_pte_t *ptep, unsigned int nr)
 {
 	pte_t pte = get_and_clear_ptes(vma->vm_mm, addr, ptep, nr);
 
@@ -2302,19 +2308,21 @@ pte_t modify_prot_start_ptes(struct vm_area_struct *vma, unsigned long addr,
 	return pte;
 }
 
-pte_t ptep_modify_prot_start(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep)
+pte_t ptep_modify_prot_start(struct vm_area_struct *vma, unsigned long addr,
+			     hw_pte_t *ptep)
 {
 	return modify_prot_start_ptes(vma, addr, ptep, 1);
 }
 
 void modify_prot_commit_ptes(struct vm_area_struct *vma, unsigned long addr,
-			     pte_t *ptep, pte_t old_pte, pte_t pte,
+			     hw_pte_t *ptep, pte_t old_pte, pte_t pte,
 			     unsigned int nr)
 {
 	set_ptes(vma->vm_mm, addr, ptep, pte, nr);
 }
 
-void ptep_modify_prot_commit(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep,
+void ptep_modify_prot_commit(struct vm_area_struct *vma, unsigned long addr,
+			     hw_pte_t *ptep,
 			     pte_t old_pte, pte_t pte)
 {
 	modify_prot_commit_ptes(vma, addr, ptep, old_pte, pte, 1);
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index 132938b32eb16..895014212a81c 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -68,7 +68,7 @@ static int pageattr_pmd_entry(pmd_t *pmd, unsigned long addr,
 	return 0;
 }
 
-static int pageattr_pte_entry(pte_t *pte, unsigned long addr,
+static int pageattr_pte_entry(hw_pte_t *pte, unsigned long addr,
 			      unsigned long next, struct mm_walk *walk)
 {
 	pte_t val = __ptep_get(pte);
@@ -379,7 +379,7 @@ bool kernel_page_present(struct page *page)
 	p4d_t *p4dp;
 	pud_t *pudp, pud;
 	pmd_t *pmdp, pmd;
-	pte_t *ptep;
+	hw_pte_t *ptep;
 	unsigned long addr = (unsigned long)page_address(page);
 
 	pgdp = pgd_offset_k(addr);
diff --git a/arch/arm64/mm/trans_pgd.c b/arch/arm64/mm/trans_pgd.c
index cca9706a875c3..845417792ad48 100644
--- a/arch/arm64/mm/trans_pgd.c
+++ b/arch/arm64/mm/trans_pgd.c
@@ -34,8 +34,8 @@ static void *trans_alloc(struct trans_pgd_info *info)
 static int copy_pte(struct trans_pgd_info *info, pmd_t *dst_pmdp,
 		    pmd_t *src_pmdp, unsigned long start, unsigned long end)
 {
-	pte_t *src_ptep;
-	pte_t *dst_ptep;
+	hw_pte_t *src_ptep;
+	hw_pte_t *dst_ptep;
 	unsigned long addr = start;
 
 	dst_ptep = trans_alloc(info);

-- 
2.47.3

