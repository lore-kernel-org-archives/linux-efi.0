Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8C041D63D
	for <linux-efi@vger.kernel.org>; Thu, 16 Jul 2026 12:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784205782; cv=none; b=R2+llyB/yzUtKo6NgMfmMfk71jVKRiUh4HRG5dn8M9NZhYZmtud7Qw9dGjUdO9S9HD9da83noyoHdD/KMt+vB0xzE6qfa5m5tzZKxE8yqVJ6OJr407Ta4oxmejF9dB0NqAFvNCkdqN+gaQSbwfsYoXb6JO4IC+mPKmNr62rEMhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784205782; c=relaxed/simple;
	bh=Nx5Yl6cR2reFM/yshhQpyFD0LbkKqFxW/sLhFH1f5LA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=t110NoSJpE/ilvD0AgqpM91+eX86TgVi+5tg5gW5bYDbRPk2M7N9xBm2gLia7lRldecvnzXiJI5Jl4p1tOhul7lCrCnzJiR93pSRxQQGvQKm0N9BUUJ67ELUadbz8mD/Q/49GLUUKMPjZeNMIJkmpIKQhTUGlWdxyKfgqiNRalk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=EtgFCpD2; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="EtgFCpD2"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cace91f112so63326905ad.0
        for <linux-efi@vger.kernel.org>; Thu, 16 Jul 2026 05:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784205780; x=1784810580; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rFSd9gJ52z3Dc4l0Wp7sqaI2N1wGspZkVOhizZNhqfU=;
        b=EtgFCpD25fizNROUuJswoYa2JWJH1h0tXeDyFL52FqKuZmI/LyPrWDjoUytXc+PrER
         8OtNfdQyYXq19G9qIEhUNVs9ZIBS/SgP1iI+t43ZZg9QA9zsIuiNscE5gduprrf4nS36
         obfCBtbUg9woy/R6IIbU1kbgI3BAMaZM2jTWtkGhiVQXrXeHydb8YS8yNc761ziWRSqf
         SfIMJ2Oj3hoS35shg1PcFwZcYJM3Q7mOTHaQj9254ohEq7HOFw+cbeLUZcLp3r0kA+xe
         nEz+wRjOR2XHrBMt6bMOWn8xA8RZDHFrz8SdP7R3LGJTpSQJTXbKsLhD0IFBVmmbxZT2
         ddZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784205780; x=1784810580;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rFSd9gJ52z3Dc4l0Wp7sqaI2N1wGspZkVOhizZNhqfU=;
        b=dC5htVUeYgbdNCdfEGEpEgdwN+Mdsi4nps31IfRECDoqjaO8n8z362JKe1bGc3/7p6
         8X1+mH8BMlJUYCD31V2qb4sWTEjAMuscWSR+QP2Ea0HOZWsY79+qQgvfdbp7ZHvZx3qO
         JSjwqpCX1R4SZqmVchQ+1hw2erNtUe6+vK3WDrehxWvJxi65xhkaTiZGJjacUa4c5RfG
         3vxUvbc0obOcrBnJky9Sr1TN/dPEiWwch0ucx5I6oOg+b4hrOu3QH2EQ85YybHpbNi3r
         7C5J4B1Hg6VdGS1KmGudF2CB12ArPC307quAItWdv8TSI/CcQ/zOeyCtPyXsKcozNZh+
         YN1A==
X-Forwarded-Encrypted: i=1; AHgh+RqUYXKpPX564s6DQOO4tCRXVf7/6A6plqJCURLRbbQKibIeHM4WD2aOmlbyyz6p2ZEfjL/nNudaLks=@vger.kernel.org
X-Gm-Message-State: AOJu0Yykj/ypewmfM1dN3n9eq4DwAFV+IHF3OOdoVs+a165kJENmx2fU
	hcy7jKS2bka0ccXGgZkR8X2B6zLiK/1Ka3yxZJqQXXe3angaVzxkO/jNqxgTBWvDICw=
X-Gm-Gg: AfdE7cnUqZg5KJSKcCmPxrKzRutGpkfbdNq67uzm5AKvUKQfTyIbUsd/oaijYRa9mPL
	LC9PPtB+55da4tqJhBLu6dlbiPx3eFWWW87zNxMSeW19Z9u4rO7g/3gb4mGvqnZuqUdkJUxhTci
	YPL68ikGaMuNR98J/LUv79J67NPY4u8Ox0XffCAg7QaJc8i+tkpchLdeILFvr7wIb3+GeGbm4W8
	SjaMKT5ccvoyYbhUEBP6QSjQqCnTFvCC7szx/lY3DEIAx/8IKNILQ8J3cBcd8txmMpKDt62Opuj
	IacIVovqlT/1rGh3LVPFEkCJkfq89ECb005SRp9Lpz7TRLerWlIyySVGDDnVUaQauOIXMTlR9TQ
	jJTrK7bPHIW7TbjBk3tEnwntEekZC5T+pgu90eI0Fs3dFG9+pBYCrPe4LdGs1HdK0Hfb1w2Epk5
	NwjoRkHvfq7uy/RnVaMXySIcU=
X-Received: by 2002:a05:6a21:d82:b0:3c0:9c19:65a2 with SMTP id adf61e73a8af0-3c36c45b9b5mr7903332637.74.1784205779488;
        Thu, 16 Jul 2026 05:42:59 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([2408:8606:1800:501::2:f])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cb258eeaba2sm1730793a12.12.2026.07.16.05.42.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 16 Jul 2026 05:42:58 -0700 (PDT)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: linux-riscv@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	kasan-dev@googlegroups.com,
	Yunhui Cui <cuiyunhui@bytedance.com>
Subject: [PATCH v2 02/15] riscv: switch arch page-table users to raw PTE helpers
Date: Thu, 16 Jul 2026 20:41:37 +0800
Message-Id: <304b13bffd2f5299da4ae80c37803e527fb1719d.1784201104.git.cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <cover.1784201104.git.cuiyunhui@bytedance.com>
References: <cover.1784201104.git.cuiyunhui@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert RISC-V internal page-table walkers and mutators over to the raw
PTE helper layer so they keep operating on the encoded hardware entries.
This keeps arch-private users independent from the Svnapot-aware public
PTE view that will be added on top for generic mm paths.

Add a raw get-and-clear helper without page-table-check side effects so
NAPOT-aware arch callers can report the effective non-NAPOT leaf view
explicitly when tearing down contiguous mappings.

Also update the hugetlb Svnapot clear/rewrite paths so they keep operating
on the contiguous block with page-table-check behavior consistent with the
raw-helper model.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/kfence.h  |   4 +-
 arch/riscv/include/asm/pgtable.h |  14 +++-
 arch/riscv/kernel/efi.c          |   4 +-
 arch/riscv/kernel/hibernate.c    |   3 +-
 arch/riscv/kvm/gstage.c          |  25 +++---
 arch/riscv/kvm/mmu.c             |   4 +-
 arch/riscv/mm/fault.c            |   4 +-
 arch/riscv/mm/hugetlbpage.c      | 135 ++++++++++++++++++++-----------
 arch/riscv/mm/init.c             |   8 +-
 arch/riscv/mm/kasan_init.c       |  16 ++--
 arch/riscv/mm/pageattr.c         |  12 +--
 arch/riscv/mm/pgtable.c          |  34 +++++---
 12 files changed, 165 insertions(+), 98 deletions(-)

diff --git a/arch/riscv/include/asm/kfence.h b/arch/riscv/include/asm/kfence.h
index 29cb3a6ee113d..8325962a9d7e8 100644
--- a/arch/riscv/include/asm/kfence.h
+++ b/arch/riscv/include/asm/kfence.h
@@ -19,9 +19,9 @@ static inline bool kfence_protect_page(unsigned long addr, bool protect)
 	pte_t *pte = virt_to_kpte(addr);
 
 	if (protect) {
-		set_pte(pte, __pte(pte_val(ptep_get(pte)) & ~_PAGE_PRESENT));
+		__set_pte(pte, __pte(pte_val(__ptep_get(pte)) & ~_PAGE_PRESENT));
 	} else {
-		set_pte(pte, __pte(pte_val(ptep_get(pte)) | _PAGE_PRESENT));
+		__set_pte(pte, __pte(pte_val(__ptep_get(pte)) | _PAGE_PRESENT));
 		mark_new_valid_map();
 	}
 
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 8ca5da9534967..a0f64e980e981 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -9,7 +9,6 @@
 #include <linux/mmzone.h>
 #include <linux/sizes.h>
 
-#include <asm/cmpxchg.h>
 #include <asm/pgtable-bits.h>
 
 #ifndef CONFIG_MMU
@@ -124,6 +123,7 @@
 
 #ifndef __ASSEMBLER__
 
+#include <asm/cmpxchg.h>
 #include <asm/page.h>
 #include <asm/tlbflush.h>
 #include <linux/mm_types.h>
@@ -468,6 +468,11 @@ static inline pte_t pte_mkdirty(pte_t pte)
 	return __pte(pte_val(pte) | _PAGE_DIRTY | _PAGE_SOFT_DIRTY);
 }
 
+static inline pte_t riscv_pte_mkhwdirty(pte_t pte)
+{
+	return __pte(pte_val(pte) | _PAGE_DIRTY);
+}
+
 static inline pte_t pte_mkclean(pte_t pte)
 {
 	return __pte(pte_val(pte) & ~(_PAGE_DIRTY));
@@ -756,6 +761,13 @@ static inline pte_t __ptep_get_and_clear(struct mm_struct *mm,
 
 #define __ptep_get_and_clear __ptep_get_and_clear
 
+static inline pte_t __ptep_get_and_clear_noptc(pte_t *ptep)
+{
+	return __pte(atomic_long_xchg((atomic_long_t *)ptep, 0));
+}
+
+#define __ptep_get_and_clear_noptc __ptep_get_and_clear_noptc
+
 static inline pte_t __ptep_clear_flush(struct vm_area_struct *vma,
 				       unsigned long address, pte_t *ptep)
 {
diff --git a/arch/riscv/kernel/efi.c b/arch/riscv/kernel/efi.c
index 2d3cc57b45352..81ea2546d2922 100644
--- a/arch/riscv/kernel/efi.c
+++ b/arch/riscv/kernel/efi.c
@@ -60,7 +60,7 @@ int __init efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md)
 static int __init set_permissions(pte_t *ptep, unsigned long addr, void *data)
 {
 	efi_memory_desc_t *md = data;
-	pte_t pte = ptep_get(ptep);
+	pte_t pte = __ptep_get(ptep);
 	unsigned long val;
 
 	if (md->attribute & EFI_MEMORY_RO) {
@@ -72,7 +72,7 @@ static int __init set_permissions(pte_t *ptep, unsigned long addr, void *data)
 		val = pte_val(pte) & ~_PAGE_EXEC;
 		pte = __pte(val);
 	}
-	set_pte(ptep, pte);
+	__set_pte(ptep, pte);
 
 	return 0;
 }
diff --git a/arch/riscv/kernel/hibernate.c b/arch/riscv/kernel/hibernate.c
index 982843828adb7..c7d5c7d4bbcde 100644
--- a/arch/riscv/kernel/hibernate.c
+++ b/arch/riscv/kernel/hibernate.c
@@ -186,7 +186,8 @@ static int temp_pgtable_map_pte(pmd_t *dst_pmdp, pmd_t *src_pmdp, unsigned long
 		pte_t pte = READ_ONCE(*src_ptep);
 
 		if (pte_present(pte))
-			set_pte(dst_ptep, __pte(pte_val(pte) | pgprot_val(prot)));
+			__set_pte(dst_ptep,
+				  __pte(pte_val(pte) | pgprot_val(prot)));
 	} while (dst_ptep++, src_ptep++, start += PAGE_SIZE, start < end);
 
 	return 0;
diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
index c4c3b79567f10..67b2c75f5cec1 100644
--- a/arch/riscv/kvm/gstage.c
+++ b/arch/riscv/kvm/gstage.c
@@ -88,7 +88,7 @@ bool kvm_riscv_gstage_get_leaf(struct kvm_gstage *gstage, gpa_t addr,
 	*ptep_level = current_level;
 	ptep = (pte_t *)gstage->pgd;
 	ptep = &ptep[gstage_pte_index(gstage, addr, current_level)];
-	while (ptep && pte_val(ptep_get(ptep))) {
+	while (ptep && pte_val(__ptep_get(ptep))) {
 		if (gstage_pte_leaf(ptep)) {
 			*ptep_level = current_level;
 			*ptepp = ptep;
@@ -98,7 +98,7 @@ bool kvm_riscv_gstage_get_leaf(struct kvm_gstage *gstage, gpa_t addr,
 		if (current_level) {
 			current_level--;
 			*ptep_level = current_level;
-			ptep = (pte_t *)gstage_pte_page_vaddr(ptep_get(ptep));
+			ptep = (pte_t *)gstage_pte_page_vaddr(__ptep_get(ptep));
 			ptep = &ptep[gstage_pte_index(gstage, addr, current_level)];
 		} else {
 			ptep = NULL;
@@ -152,18 +152,18 @@ int kvm_riscv_gstage_set_pte(struct kvm_gstage *gstage,
 		if (gstage_pte_leaf(ptep))
 			return -EEXIST;
 
-		if (!pte_val(ptep_get(ptep))) {
+		if (!pte_val(__ptep_get(ptep))) {
 			if (!pcache)
 				return -ENOMEM;
 			next_ptep = kvm_mmu_memory_cache_alloc(pcache);
 			if (!next_ptep)
 				return -ENOMEM;
-			set_pte(ptep, pfn_pte(PFN_DOWN(__pa(next_ptep)),
-					      __pgprot(_PAGE_TABLE)));
+			__set_pte(ptep, pfn_pte(PFN_DOWN(__pa(next_ptep)),
+						__pgprot(_PAGE_TABLE)));
 		} else {
 			if (gstage_pte_leaf(ptep))
 				return -EEXIST;
-			next_ptep = (pte_t *)gstage_pte_page_vaddr(ptep_get(ptep));
+			next_ptep = (pte_t *)gstage_pte_page_vaddr(__ptep_get(ptep));
 		}
 
 		current_level--;
@@ -171,7 +171,7 @@ int kvm_riscv_gstage_set_pte(struct kvm_gstage *gstage,
 	}
 
 	if (pte_val(*ptep) != pte_val(map->pte)) {
-		set_pte(ptep, map->pte);
+		__set_pte(ptep, map->pte);
 		if (gstage_pte_leaf(ptep))
 			gstage_tlb_flush(gstage, current_level, map->addr);
 	}
@@ -371,18 +371,18 @@ bool kvm_riscv_gstage_op_pte(struct kvm_gstage *gstage, gpa_t addr,
 
 	WARN_ON(addr & (page_size - 1));
 
-	if (!pte_val(ptep_get(ptep)))
+	if (!pte_val(__ptep_get(ptep)))
 		return false;
 
 	if (ptep_level && !gstage_pte_leaf(ptep)) {
-		next_ptep = (pte_t *)gstage_pte_page_vaddr(ptep_get(ptep));
+		next_ptep = (pte_t *)gstage_pte_page_vaddr(__ptep_get(ptep));
 		next_ptep_level = ptep_level - 1;
 		ret = gstage_level_to_page_size(gstage, next_ptep_level, &next_page_size);
 		if (ret)
 			return false;
 
 		if (op == GSTAGE_OP_CLEAR)
-			set_pte(ptep, __pte(0));
+			__set_pte(ptep, __pte(0));
 		for (i = 0; i < PTRS_PER_PTE; i++)
 			flush |= kvm_riscv_gstage_op_pte(gstage, addr + i * next_page_size,
 							 &next_ptep[i], next_ptep_level, op);
@@ -391,9 +391,10 @@ bool kvm_riscv_gstage_op_pte(struct kvm_gstage *gstage, gpa_t addr,
 	} else {
 		old_pte = *ptep;
 		if (op == GSTAGE_OP_CLEAR)
-			set_pte(ptep, __pte(0));
+			__set_pte(ptep, __pte(0));
 		else if (op == GSTAGE_OP_WP)
-			set_pte(ptep, __pte(pte_val(ptep_get(ptep)) & ~_PAGE_WRITE));
+			__set_pte(ptep,
+				  __pte(pte_val(__ptep_get(ptep)) & ~_PAGE_WRITE));
 		if (pte_val(*ptep) != pte_val(old_pte))
 			flush = true;
 	}
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 082f9b2617338..48dfc88d8cea6 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -278,7 +278,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 				       &ptep, &ptep_level))
 		return false;
 
-	return ptep_test_and_clear_young(NULL, 0, ptep);
+	return __ptep_test_and_clear_young(NULL, 0, ptep);
 }
 
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
@@ -298,7 +298,7 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 				       &ptep, &ptep_level))
 		return false;
 
-	return pte_young(ptep_get(ptep));
+	return pte_young(__ptep_get(ptep));
 }
 
 static bool fault_supports_gstage_huge_mapping(struct kvm_memory_slot *memslot,
diff --git a/arch/riscv/mm/fault.c b/arch/riscv/mm/fault.c
index 04ed6f8acae4f..0b725ed723023 100644
--- a/arch/riscv/mm/fault.c
+++ b/arch/riscv/mm/fault.c
@@ -69,7 +69,7 @@ static void show_pte(unsigned long addr)
 	if (!ptep)
 		goto out;
 
-	pte = ptep_get(ptep);
+	pte = __ptep_get(ptep);
 	pr_cont(", pte=%016lx", pte_val(pte));
 	pte_unmap(ptep);
 out:
@@ -231,7 +231,7 @@ static inline void vmalloc_fault(struct pt_regs *regs, int code, unsigned long a
 	 * silently loop forever.
 	 */
 	pte_k = pte_offset_kernel(pmd_k, addr);
-	if (!pte_present(ptep_get(pte_k))) {
+	if (!pte_present(__ptep_get(pte_k))) {
 		no_context(regs, addr);
 		return;
 	}
diff --git a/arch/riscv/mm/hugetlbpage.c b/arch/riscv/mm/hugetlbpage.c
index a6d217112cf46..5ededac02161d 100644
--- a/arch/riscv/mm/hugetlbpage.c
+++ b/arch/riscv/mm/hugetlbpage.c
@@ -7,7 +7,7 @@ pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 {
 	unsigned long pte_num;
 	int i;
-	pte_t orig_pte = ptep_get(ptep);
+	pte_t orig_pte = __ptep_get(ptep);
 
 	if (!pte_present(orig_pte) || !pte_napot(orig_pte))
 		return orig_pte;
@@ -15,10 +15,10 @@ pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 	pte_num = napot_pte_num(napot_cont_order(orig_pte));
 
 	for (i = 0; i < pte_num; i++, ptep++) {
-		pte_t pte = ptep_get(ptep);
+		pte_t pte = __ptep_get(ptep);
 
 		if (pte_dirty(pte))
-			orig_pte = pte_mkdirty(orig_pte);
+			orig_pte = riscv_pte_mkhwdirty(orig_pte);
 
 		if (pte_young(pte))
 			orig_pte = pte_mkyoung(orig_pte);
@@ -74,7 +74,7 @@ pte_t *huge_pte_alloc(struct mm_struct *mm,
 
 out:
 	if (pte) {
-		pte_t pteval = ptep_get_lockless(pte);
+		pte_t pteval = __ptep_get_lockless(pte);
 
 		WARN_ON_ONCE(pte_present(pteval) && !pte_huge(pteval));
 	}
@@ -145,28 +145,52 @@ unsigned long hugetlb_mask_last_page(struct hstate *h)
 	return 0UL;
 }
 
+static unsigned long napot_hugetlb_block_addr(pte_t pte, unsigned long addr)
+{
+	unsigned long order;
+
+	if (!pte_napot(pte))
+		return addr;
+
+	order = napot_cont_order(pte);
+
+	return addr & napot_cont_mask(order);
+}
+
+static pte_t napot_hugetlb_get_and_clear(struct mm_struct *mm,
+					 unsigned long addr, pte_t *ptep)
+{
+	pte_t pte;
+
+	pte = __ptep_get_and_clear_noptc(ptep);
+	page_table_check_pte_clear(mm, addr, pte_mknonnapot(pte, addr));
+
+	return pte;
+}
+
 static pte_t get_clear_contig(struct mm_struct *mm,
 			      unsigned long addr,
 			      pte_t *ptep,
 			      unsigned long ncontig)
 {
-	pte_t pte, tmp_pte;
-	bool present;
-
-	pte = ptep_get_and_clear(mm, addr, ptep);
-	present = pte_present(pte);
-	while (--ncontig) {
-		ptep++;
-		addr += PAGE_SIZE;
-		tmp_pte = ptep_get_and_clear(mm, addr, ptep);
-		if (present) {
-			if (pte_dirty(tmp_pte))
-				pte = pte_mkdirty(pte);
-			if (pte_young(tmp_pte))
-				pte = pte_mkyoung(pte);
-		}
+	pte_t orig_pte = __ptep_get(ptep);
+	unsigned long i;
+
+	addr = napot_hugetlb_block_addr(orig_pte, addr);
+	if (pte_napot(orig_pte))
+		ptep = huge_pte_offset(mm, addr,
+				       napot_cont_size(napot_cont_order(orig_pte)));
+
+	for (i = 0; i < ncontig; i++, addr += PAGE_SIZE, ptep++) {
+		pte_t pte = napot_hugetlb_get_and_clear(mm, addr, ptep);
+
+		if (pte_dirty(pte))
+			orig_pte = riscv_pte_mkhwdirty(orig_pte);
+		if (pte_young(pte))
+			orig_pte = pte_mkyoung(orig_pte);
 	}
-	return pte;
+
+	return orig_pte;
 }
 
 static pte_t get_clear_contig_flush(struct mm_struct *mm,
@@ -174,10 +198,13 @@ static pte_t get_clear_contig_flush(struct mm_struct *mm,
 				    pte_t *ptep,
 				    unsigned long pte_num)
 {
+	pte_t pte = __ptep_get(ptep);
 	pte_t orig_pte = get_clear_contig(mm, addr, ptep, pte_num);
 	struct vm_area_struct vma = TLB_FLUSH_VMA(mm, 0);
 	bool valid = !pte_none(orig_pte);
 
+	addr = napot_hugetlb_block_addr(pte, addr);
+
 	if (valid)
 		flush_tlb_range(&vma, addr, addr + (PAGE_SIZE * pte_num));
 
@@ -207,14 +234,31 @@ static void clear_flush(struct mm_struct *mm,
 			unsigned long ncontig)
 {
 	struct vm_area_struct vma = TLB_FLUSH_VMA(mm, 0);
+	pte_t pte = __ptep_get(ptep);
 	unsigned long i, saddr = addr;
 
+	addr = napot_hugetlb_block_addr(pte, addr);
+	if (pte_napot(pte))
+		ptep = huge_pte_offset(mm, addr,
+				       napot_cont_size(napot_cont_order(pte)));
+	saddr = addr;
+
 	for (i = 0; i < ncontig; i++, addr += pgsize, ptep++)
-		ptep_get_and_clear(mm, addr, ptep);
+		napot_hugetlb_get_and_clear(mm, addr, ptep);
 
 	flush_tlb_range(&vma, saddr, addr);
 }
 
+static void set_huge_napot_ptes(struct mm_struct *mm, unsigned long addr,
+				pte_t *ptep, pte_t pte, unsigned long pte_num)
+{
+	unsigned long i;
+
+	page_table_check_ptes_set(mm, addr, ptep, pte, pte_num);
+	for (i = 0; i < pte_num; i++)
+		__set_pte_at(mm, ptep + i, pte);
+}
+
 static int num_contig_ptes_from_size(unsigned long sz, size_t *pgsize)
 {
 	unsigned long hugepage_shift;
@@ -256,19 +300,18 @@ void set_huge_pte_at(struct mm_struct *mm,
 
 	if (!pte_present(pte)) {
 		for (i = 0; i < pte_num; i++, ptep++, addr += pgsize)
-			set_ptes(mm, addr, ptep, pte, 1);
+			__set_ptes(mm, addr, ptep, pte, 1);
 		return;
 	}
 
 	if (!pte_napot(pte)) {
-		set_ptes(mm, addr, ptep, pte, 1);
+		__set_ptes(mm, addr, ptep, pte, 1);
 		return;
 	}
 
 	clear_flush(mm, addr, ptep, pgsize, pte_num);
 
-	for (i = 0; i < pte_num; i++, ptep++, addr += pgsize)
-		set_pte_at(mm, addr, ptep, pte);
+	set_huge_napot_ptes(mm, addr, ptep, pte, pte_num);
 }
 
 int huge_ptep_set_access_flags(struct vm_area_struct *vma,
@@ -280,10 +323,10 @@ int huge_ptep_set_access_flags(struct vm_area_struct *vma,
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long order;
 	pte_t orig_pte;
-	int i, pte_num;
+	int pte_num;
 
 	if (!pte_napot(pte))
-		return ptep_set_access_flags(vma, addr, ptep, pte, dirty);
+		return __ptep_set_access_flags(vma, addr, ptep, pte, dirty);
 
 	order = napot_cont_order(pte);
 	pte_num = napot_pte_num(order);
@@ -291,13 +334,12 @@ int huge_ptep_set_access_flags(struct vm_area_struct *vma,
 	orig_pte = get_clear_contig_flush(mm, addr, ptep, pte_num);
 
 	if (pte_dirty(orig_pte))
-		pte = pte_mkdirty(pte);
+		pte = riscv_pte_mkhwdirty(pte);
 
 	if (pte_young(orig_pte))
 		pte = pte_mkyoung(pte);
 
-	for (i = 0; i < pte_num; i++, addr += PAGE_SIZE, ptep++)
-		set_pte_at(mm, addr, ptep, pte);
+	set_huge_napot_ptes(mm, addr, ptep, pte, pte_num);
 
 	return true;
 }
@@ -306,14 +348,13 @@ pte_t huge_ptep_get_and_clear(struct mm_struct *mm,
 			      unsigned long addr,
 			      pte_t *ptep, unsigned long sz)
 {
-	size_t pgsize;
-	pte_t orig_pte = ptep_get(ptep);
+	pte_t orig_pte = __ptep_get(ptep);
 	int pte_num;
 
 	if (!pte_napot(orig_pte))
-		return ptep_get_and_clear(mm, addr, ptep);
+		return __ptep_get_and_clear(mm, addr, ptep);
 
-	pte_num = num_contig_ptes_from_size(sz, &pgsize);
+	pte_num = napot_pte_num(napot_cont_order(orig_pte));
 
 	return get_clear_contig(mm, addr, ptep, pte_num);
 }
@@ -322,13 +363,13 @@ void huge_ptep_set_wrprotect(struct mm_struct *mm,
 			     unsigned long addr,
 			     pte_t *ptep)
 {
-	pte_t pte = ptep_get(ptep);
+	pte_t pte = __ptep_get(ptep);
 	unsigned long order;
 	pte_t orig_pte;
-	int i, pte_num;
+	int pte_num;
 
 	if (!pte_napot(pte)) {
-		ptep_set_wrprotect(mm, addr, ptep);
+		__ptep_set_wrprotect(mm, addr, ptep);
 		return;
 	}
 
@@ -339,19 +380,18 @@ void huge_ptep_set_wrprotect(struct mm_struct *mm,
 
 	orig_pte = pte_wrprotect(orig_pte);
 
-	for (i = 0; i < pte_num; i++, addr += PAGE_SIZE, ptep++)
-		set_pte_at(mm, addr, ptep, orig_pte);
+	set_huge_napot_ptes(mm, addr, ptep, orig_pte, pte_num);
 }
 
 pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
 			    unsigned long addr,
 			    pte_t *ptep)
 {
-	pte_t pte = ptep_get(ptep);
+	pte_t pte = __ptep_get(ptep);
 	int pte_num;
 
 	if (!pte_napot(pte))
-		return ptep_clear_flush(vma, addr, ptep);
+		return __ptep_clear_flush(vma, addr, ptep);
 
 	pte_num = napot_pte_num(napot_cont_order(pte));
 
@@ -363,19 +403,16 @@ void huge_pte_clear(struct mm_struct *mm,
 		    pte_t *ptep,
 		    unsigned long sz)
 {
-	size_t pgsize;
-	pte_t pte = ptep_get(ptep);
-	int i, pte_num;
+	pte_t pte = __ptep_get(ptep);
+	int pte_num;
 
 	if (!pte_napot(pte)) {
-		pte_clear(mm, addr, ptep);
+		__pte_clear(mm, addr, ptep);
 		return;
 	}
 
-	pte_num = num_contig_ptes_from_size(sz, &pgsize);
-
-	for (i = 0; i < pte_num; i++, addr += pgsize, ptep++)
-		pte_clear(mm, addr, ptep);
+	pte_num = napot_pte_num(napot_cont_order(pte));
+	get_clear_contig(mm, addr, ptep, pte_num);
 }
 
 static bool is_napot_size(unsigned long size)
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index e2be64bacf160..d44bb7db22b43 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -378,9 +378,9 @@ void __set_fixmap(enum fixed_addresses idx, phys_addr_t phys, pgprot_t prot)
 	ptep = &fixmap_pte[pte_index(addr)];
 
 	if (pgprot_val(prot))
-		set_pte(ptep, pfn_pte(phys >> PAGE_SHIFT, prot));
+		__set_pte(ptep, pfn_pte(phys >> PAGE_SHIFT, prot));
 	else
-		pte_clear(&init_mm, addr, ptep);
+		__pte_clear(&init_mm, addr, ptep);
 	local_flush_tlb_page(addr);
 }
 
@@ -1571,11 +1571,11 @@ static void __meminit remove_pte_mapping(pte_t *pte_base, unsigned long addr, un
 			next = end;
 
 		ptep = pte_base + pte_index(addr);
-		pte = ptep_get(ptep);
+		pte = __ptep_get(ptep);
 		if (!pte_present(*ptep))
 			continue;
 
-		pte_clear(&init_mm, addr, ptep);
+		__pte_clear(&init_mm, addr, ptep);
 		if (is_vmemmap)
 			free_vmemmap_storage(pte_page(pte), PAGE_SIZE, altmap);
 	}
diff --git a/arch/riscv/mm/kasan_init.c b/arch/riscv/mm/kasan_init.c
index 1f3aa9611187f..c5d5513b206ca 100644
--- a/arch/riscv/mm/kasan_init.c
+++ b/arch/riscv/mm/kasan_init.c
@@ -39,9 +39,9 @@ static void __init kasan_populate_pte(pmd_t *pmd, unsigned long vaddr, unsigned
 	ptep = pte_offset_kernel(pmd, vaddr);
 
 	do {
-		if (pte_none(ptep_get(ptep))) {
+		if (pte_none(__ptep_get(ptep))) {
 			phys_addr = memblock_phys_alloc(PAGE_SIZE, PAGE_SIZE);
-			set_pte(ptep, pfn_pte(PFN_DOWN(phys_addr), PAGE_KERNEL));
+			__set_pte(ptep, pfn_pte(PFN_DOWN(phys_addr), PAGE_KERNEL));
 			memset(__va(phys_addr), KASAN_SHADOW_INIT, PAGE_SIZE);
 		}
 	} while (ptep++, vaddr += PAGE_SIZE, vaddr != end);
@@ -327,8 +327,8 @@ asmlinkage void __init kasan_early_init(void)
 		KASAN_SHADOW_END - (1UL << (64 - KASAN_SHADOW_SCALE_SHIFT)));
 
 	for (i = 0; i < PTRS_PER_PTE; ++i)
-		set_pte(kasan_early_shadow_pte + i,
-			pfn_pte(virt_to_pfn(kasan_early_shadow_page), PAGE_KERNEL));
+		__set_pte(kasan_early_shadow_pte + i,
+			  pfn_pte(virt_to_pfn(kasan_early_shadow_page), PAGE_KERNEL));
 
 	for (i = 0; i < PTRS_PER_PMD; ++i)
 		set_pmd(kasan_early_shadow_pmd + i,
@@ -520,10 +520,10 @@ void __init kasan_init(void)
 		       kasan_mem_to_shadow((const void *)MODULES_VADDR + SZ_2G));
 
 	for (i = 0; i < PTRS_PER_PTE; i++)
-		set_pte(&kasan_early_shadow_pte[i],
-			mk_pte(virt_to_page(kasan_early_shadow_page),
-			       __pgprot(_PAGE_PRESENT | _PAGE_READ |
-					_PAGE_ACCESSED)));
+		__set_pte(&kasan_early_shadow_pte[i],
+			  mk_pte(virt_to_page(kasan_early_shadow_page),
+				 __pgprot(_PAGE_PRESENT | _PAGE_READ |
+					  _PAGE_ACCESSED)));
 
 	memset(kasan_early_shadow_page, KASAN_SHADOW_INIT, PAGE_SIZE);
 	init_task.kasan_depth = 0;
diff --git a/arch/riscv/mm/pageattr.c b/arch/riscv/mm/pageattr.c
index 3f76db3d27699..e0271e2a0b295 100644
--- a/arch/riscv/mm/pageattr.c
+++ b/arch/riscv/mm/pageattr.c
@@ -68,10 +68,10 @@ static int pageattr_pmd_entry(pmd_t *pmd, unsigned long addr,
 static int pageattr_pte_entry(pte_t *pte, unsigned long addr,
 			      unsigned long next, struct mm_walk *walk)
 {
-	pte_t val = ptep_get(pte);
+	pte_t val = __ptep_get(pte);
 
 	val = __pte(set_pageattr_masks(pte_val(val), walk));
-	set_pte(pte, val);
+	__set_pte(pte, val);
 
 	return 0;
 }
@@ -121,7 +121,7 @@ static int __split_linear_mapping_pmd(pud_t *pudp,
 
 			ptep_new = (pte_t *)page_address(pte_page);
 			for (i = 0; i < PTRS_PER_PTE; ++i, ++ptep_new)
-				set_pte(ptep_new, pfn_pte(pfn + i, prot));
+				__set_pte(ptep_new, pfn_pte(pfn + i, prot));
 
 			smp_wmb();
 
@@ -406,14 +406,14 @@ static int debug_pagealloc_set_page(pte_t *pte, unsigned long addr, void *data)
 {
 	int enable = *(int *)data;
 
-	unsigned long val = pte_val(ptep_get(pte));
+	unsigned long val = pte_val(__ptep_get(pte));
 
 	if (enable)
 		val |= _PAGE_PRESENT;
 	else
 		val &= ~_PAGE_PRESENT;
 
-	set_pte(pte, __pte(val));
+	__set_pte(pte, __pte(val));
 
 	return 0;
 }
@@ -466,5 +466,5 @@ bool kernel_page_present(struct page *page)
 		return true;
 
 	pte = pte_offset_kernel(pmd, addr);
-	return pte_present(ptep_get(pte));
+	return pte_present(__ptep_get(pte));
 }
diff --git a/arch/riscv/mm/pgtable.c b/arch/riscv/mm/pgtable.c
index 9c4427d0b1874..43bd542c6ff02 100644
--- a/arch/riscv/mm/pgtable.c
+++ b/arch/riscv/mm/pgtable.c
@@ -5,14 +5,13 @@
 #include <linux/kernel.h>
 #include <linux/pgtable.h>
 
-int ptep_set_access_flags(struct vm_area_struct *vma,
-			  unsigned long address, pte_t *ptep,
-			  pte_t entry, int dirty)
+int __ptep_set_access_flags(struct vm_area_struct *vma,
+			    unsigned long address, pte_t *ptep,
+			    pte_t entry, int dirty)
 {
 	if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SVVPTC)) {
-		if (!pte_same(ptep_get(ptep), entry)) {
+		if (!pte_same(__ptep_get(ptep), entry)) {
 			__set_pte_at(vma->vm_mm, ptep, entry);
-			/* Here only not svadu is impacted */
 			flush_tlb_page(vma, address);
 			return true;
 		}
@@ -20,7 +19,7 @@ int ptep_set_access_flags(struct vm_area_struct *vma,
 		return false;
 	}
 
-	if (!pte_same(ptep_get(ptep), entry))
+	if (!pte_same(__ptep_get(ptep), entry))
 		__set_pte_at(vma->vm_mm, ptep, entry);
 	/*
 	 * update_mmu_cache will unconditionally execute, handling both
@@ -29,13 +28,30 @@ int ptep_set_access_flags(struct vm_area_struct *vma,
 	return true;
 }
 
-bool ptep_test_and_clear_young(struct vm_area_struct *vma,
-		unsigned long address, pte_t *ptep)
+int ptep_set_access_flags(struct vm_area_struct *vma,
+			  unsigned long address, pte_t *ptep,
+			  pte_t entry, int dirty)
 {
-	if (!pte_young(ptep_get(ptep)))
+	return __ptep_set_access_flags(vma, address, ptep, entry, dirty);
+}
+
+bool __ptep_test_and_clear_young(struct vm_area_struct *vma,
+				 unsigned long address,
+				 pte_t *ptep)
+{
+	if (!pte_young(__ptep_get(ptep)))
 		return false;
+
 	return test_and_clear_bit(_PAGE_ACCESSED_OFFSET, &pte_val(*ptep));
 }
+EXPORT_SYMBOL_GPL(__ptep_test_and_clear_young);
+
+bool ptep_test_and_clear_young(struct vm_area_struct *vma,
+			       unsigned long address,
+			       pte_t *ptep)
+{
+	return __ptep_test_and_clear_young(vma, address, ptep);
+}
 EXPORT_SYMBOL_GPL(ptep_test_and_clear_young);
 
 #ifdef CONFIG_64BIT
-- 
2.39.5

