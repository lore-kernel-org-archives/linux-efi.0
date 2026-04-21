Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BAF38C401
	for <linux-efi@vger.kernel.org>; Tue, 21 Apr 2026 09:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776763531; cv=none; b=F5qUxlxAFZCGNCSBkeNqKjyvXYdCPa+sIWR2ir6gBGCMN5otubzYsSBIJ/zCilgQBPueRFEh3eIPfFApLfRTv5elt83NUTlTGu7osWFEC4fSCebI8Znv9E+se8sT65nEg5SW9aP1zq8OOx0lEMCbPgFH1cCM8YX0bJkDGR+xpD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776763531; c=relaxed/simple;
	bh=qUIa/9sDsAgCTGzA9WinapTYHc7hlNf+Cle2ugEYNbY=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=T98Jg2yq8edM551fv2n+2KbdvNUAeK0W32UPczxo5D3m3JVj6MIC4ImUpB+YI3ebUvJAcypxVL7YY85IjR77MAxNkpd7ASP1Qe37wcBlJKeELXQnZ4Pf0N6Uxghh545blXr+wv2Bgz6G9gtMUGLSn+kqrJejXP+o03iaK8EDvz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=A7tYf/Xq; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="A7tYf/Xq"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2b0afa0210bso18640125ad.2
        for <linux-efi@vger.kernel.org>; Tue, 21 Apr 2026 02:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776763529; x=1777368329; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hAU2czezOYKOKIblUParrQgVvl9OeyW0IiuDcmMed3s=;
        b=A7tYf/Xq5WVKWO5Pi9ZYHlN05OrDhUVlDEXf3HM18VqP2j96Ob53D7zMfOvxUYvOHP
         cqCYgo+sj9oe2723eY+EwqZKC7WDu7791TxGJ0ISXOe8Dp+3Dg8H/eumxGWwCdfg3Psv
         LWnhx76MP4dEAgxJTv31YcWe62UbcWdtc61Bts9pnAaesyllUMm5fmgIIgRww9JIjjxu
         +TYFHmMPI4/w+FEcUJk/PFP4Uld7CwMLnv1aJ5cWnwwaGYfCki2zIa4y4Hvif8m+MB1O
         Jf7Do2eU0sK5qWZtykmT5LbIqiTSOT08A/SMRiXpUjTeYXrTWqJEJ+EKTTNeanTsmC1h
         Et8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776763529; x=1777368329;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hAU2czezOYKOKIblUParrQgVvl9OeyW0IiuDcmMed3s=;
        b=iGrlUbFLLn/bV8FmccAD8OtUXqkZRjvyTjiwzUjWHUErzLfS2pjIFcjX0EcMChHgJu
         bY0kUVDLrRSiigR8Y7OGCI9TpADkLRhMC+SGyWiEsYrs4+6Y/tctQLT/PP/+5z3WRDNk
         mAoOob8xkNCAe6oIvRe9wQ0TWxKd1kM5wKGXud0tqq23JfhxYguRDQB9EpqTX3EsAfNk
         bGNa6zXF7RevBtf7KXBemD6GzUi4xyoOiHArKZxevMycQnWmrswp5mtBKRwIh2NPqIYg
         Pq+Xqr2RwmJ8PDoE6Hb9jyJTUEkAmBleuWor+SAWHWuBNNkis1TdQ2smYY9Bdbuwyiiz
         9hfw==
X-Forwarded-Encrypted: i=1; AFNElJ+muEQZtk+QvMu2ZRw9Ez7ZwAXU66vVgedJHltIIBg0g874ysXAg/ibSGdNL3BBKkz+DM46RIDhxUY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx41naeP+6hSg1o3jebibxGzB688Sx6tcSszHza1ZSZXCrKpFs8
	CeK0QPhGHvN//ts3quoq/YFFuAhm8MmGwoR/ZZ5zAE6Vx+xOM7ejf2us3WQGJEkgIJM=
X-Gm-Gg: AeBDiesHXwRcDEU5V50yFN+KJx4GNSX2Bhr9/91Oo9zYadyHmk7XyWCjdt50wBF4pXY
	lBXDPqUgXLXIFkCKT07jHe49KYhEGxuCwuMXIVtcGETlFyYV2TD16rSrFF1TEULyBxPxili0HNv
	XQZ19vZysE/cB6ZYyrnkVqc5TC+DXJ208ikhIxzxyPlCojFaUoYiO02gqXyf5t8KQ/XH194RyU7
	aGgZQmcNJHSo+I7Ycxg8BPEQyw16Xk5Z5aCxq5UkqwaV2+3S0RpId6XrslY+RSc8ubVb0vrAkKT
	6LUgycspj5TS1rK1qQ2niofJWMC46plG4GNd/Fp6gtM/7j5WTy0NoJO82ou3b2DK4dlR0sU8SA+
	muDbnXAdVxawm0l08ISwrQev3XC8a1hpex7omndCEuHe1vPeKddxr83rSphR10/w5rJfbqzDnyW
	PFEFd5S6gZ3vr/0HRI8Fge6zUOMXz4OibETrJJ9PtGzwV4ZI3AAp46GcA4bi3CRhwApv88
X-Received: by 2002:a17:902:bd44:b0:2b2:5da8:14be with SMTP id d9443c01a7336-2b5f9fcd9eemr128057035ad.41.1776763529026;
        Tue, 21 Apr 2026 02:25:29 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fa9ff39csm131965105ad.4.2026.04.21.02.25.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 21 Apr 2026 02:25:28 -0700 (PDT)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: akpm@linux-foundation.org,
	alex@ghiti.fr,
	andrew+kernel@donnellan.id.au,
	andreyknvl@gmail.com,
	anup@brainfault.org,
	aou@eecs.berkeley.edu,
	apopple@nvidia.com,
	ardb@kernel.org,
	atish.patra@linux.dev,
	baolin.wang@linux.alibaba.com,
	cuiyunhui@bytedance.com,
	david@kernel.org,
	debug@rivosinc.com,
	djordje.todorovic@htecgroup.com,
	dvyukov@google.com,
	elver@google.com,
	glider@google.com,
	ilias.apalodimas@linaro.org,
	junhui.liu@pigmoral.tech,
	kasan-dev@googlegroups.com,
	kees@kernel.org,
	kevin.brodsky@arm.com,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	liu.xuemei1@zte.com.cn,
	ljs@kernel.org,
	namcao@linutronix.de,
	osalvador@suse.de,
	palmer@dabbelt.com,
	pjw@kernel.org,
	rmclure@linux.ibm.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryabinin.a.a@gmail.com,
	surenb@google.com,
	vincenzo.frascino@arm.com,
	vishal.moola@gmail.com,
	wangruikang@iscas.ac.cn,
	zhangchunyan@iscas.ac.cn
Subject: [PATCH 2/7] riscv/kvm: use raw PTE helpers for G-stage leaf PTEs
Date: Tue, 21 Apr 2026 17:24:52 +0800
Message-Id: <20260421092457.37649-3-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260421092457.37649-1-cuiyunhui@bytedance.com>
References: <20260421092457.37649-1-cuiyunhui@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the raw RISC-V PTE helpers when KVM G-stage code needs to inspect
or update the exact leaf entry encoding. This keeps G-stage page tables
independent from the public PTE wrappers that will gain Svnapot-aware
behavior.

No functional change intended.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/kvm/gstage.c | 48 ++++++++++++++++++++++-------------------
 arch/riscv/kvm/mmu.c    |  4 ++--
 2 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
index d9fe8be2a1516..fda235092533a 100644
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
@@ -138,18 +138,19 @@ int kvm_riscv_gstage_set_pte(struct kvm_gstage *gstage,
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
+			__set_pte(ptep,
+				  pfn_pte(PFN_DOWN(__pa(next_ptep)),
+					  __pgprot(_PAGE_TABLE)));
 		} else {
 			if (gstage_pte_leaf(ptep))
 				return -EEXIST;
-			next_ptep = (pte_t *)gstage_pte_page_vaddr(ptep_get(ptep));
+			next_ptep = (pte_t *)gstage_pte_page_vaddr(__ptep_get(ptep));
 		}
 
 		current_level--;
@@ -157,7 +158,7 @@ int kvm_riscv_gstage_set_pte(struct kvm_gstage *gstage,
 	}
 
 	if (pte_val(*ptep) != pte_val(map->pte)) {
-		set_pte(ptep, map->pte);
+		__set_pte(ptep, map->pte);
 		if (gstage_pte_leaf(ptep))
 			gstage_tlb_flush(gstage, current_level, map->addr);
 	}
@@ -170,13 +171,13 @@ static void kvm_riscv_gstage_update_pte_prot(struct kvm_gstage *gstage, u32 leve
 {
 	pte_t new_pte;
 
-	if (pgprot_val(pte_pgprot(ptep_get(ptep))) == pgprot_val(prot))
+	if (pgprot_val(pte_pgprot(__ptep_get(ptep))) == pgprot_val(prot))
 		return;
 
-	new_pte = pfn_pte(pte_pfn(ptep_get(ptep)), prot);
+	new_pte = pfn_pte(pte_pfn(__ptep_get(ptep)), prot);
 	new_pte = pte_mkdirty(new_pte);
 
-	set_pte(ptep, new_pte);
+	__set_pte(ptep, new_pte);
 
 	gstage_tlb_flush(gstage, level, addr);
 }
@@ -255,7 +256,8 @@ int kvm_riscv_gstage_map_page(struct kvm_gstage *gstage,
 		if (ptep_level > out_map->level) {
 			kvm_riscv_gstage_split_huge(gstage, pcache, gpa,
 						    out_map->level, true);
-		} else if (ALIGN_DOWN(PFN_PHYS(pte_pfn(ptep_get(ptep))), page_size) == hpa) {
+		} else if (ALIGN_DOWN(PFN_PHYS(pte_pfn(__ptep_get(ptep))),
+					 page_size) == hpa) {
 			kvm_riscv_gstage_update_pte_prot(gstage, ptep_level, gpa, ptep, prot);
 			return 0;
 		}
@@ -301,16 +303,16 @@ int kvm_riscv_gstage_split_huge(struct kvm_gstage *gstage,
 	while(current_level > target_level) {
 		ptep = (pte_t *)&next_ptep[gstage_pte_index(gstage, addr, current_level)];
 
-		if (!pte_val(ptep_get(ptep)))
+		if (!pte_val(__ptep_get(ptep)))
 			break;
 
 		if (!gstage_pte_leaf(ptep)) {
-			next_ptep = (pte_t *)gstage_pte_page_vaddr(ptep_get(ptep));
+			next_ptep = (pte_t *)gstage_pte_page_vaddr(__ptep_get(ptep));
 			current_level--;
 			continue;
 		}
 
-		huge_pte = pte_val(ptep_get(ptep));
+		huge_pte = pte_val(__ptep_get(ptep));
 
 		ret = gstage_level_to_page_size(gstage, current_level - 1, &child_page_size);
 		if (ret)
@@ -322,11 +324,12 @@ int kvm_riscv_gstage_split_huge(struct kvm_gstage *gstage,
 
 		for (i = 0; i < PTRS_PER_PTE; i++) {
 			child_pte = make_child_pte(huge_pte, i, child_page_size);
-			set_pte((pte_t *)&next_ptep[i], __pte(child_pte));
+			__set_pte((pte_t *)&next_ptep[i], __pte(child_pte));
 		}
 
-		set_pte(ptep, pfn_pte(PFN_DOWN(__pa(next_ptep)),
-				__pgprot(_PAGE_TABLE)));
+		__set_pte(ptep,
+			  pfn_pte(PFN_DOWN(__pa(next_ptep)),
+				  __pgprot(_PAGE_TABLE)));
 
 		if (flush)
 			gstage_tlb_flush(gstage, current_level, addr);
@@ -351,18 +354,18 @@ void kvm_riscv_gstage_op_pte(struct kvm_gstage *gstage, gpa_t addr,
 
 	WARN_ON(addr & (page_size - 1));
 
-	if (!pte_val(ptep_get(ptep)))
+	if (!pte_val(__ptep_get(ptep)))
 		return;
 
 	if (ptep_level && !gstage_pte_leaf(ptep)) {
-		next_ptep = (pte_t *)gstage_pte_page_vaddr(ptep_get(ptep));
+		next_ptep = (pte_t *)gstage_pte_page_vaddr(__ptep_get(ptep));
 		next_ptep_level = ptep_level - 1;
 		ret = gstage_level_to_page_size(gstage, next_ptep_level, &next_page_size);
 		if (ret)
 			return;
 
 		if (op == GSTAGE_OP_CLEAR)
-			set_pte(ptep, __pte(0));
+			__set_pte(ptep, __pte(0));
 		for (i = 0; i < PTRS_PER_PTE; i++)
 			kvm_riscv_gstage_op_pte(gstage, addr + i * next_page_size,
 						&next_ptep[i], next_ptep_level, op);
@@ -371,9 +374,10 @@ void kvm_riscv_gstage_op_pte(struct kvm_gstage *gstage, gpa_t addr,
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
 			gstage_tlb_flush(gstage, ptep_level, addr);
 	}
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 2d3def024270c..f338ef08a6d13 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -262,7 +262,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 				       &ptep, &ptep_level))
 		return false;
 
-	return ptep_test_and_clear_young(NULL, 0, ptep);
+	return __ptep_test_and_clear_young(NULL, 0, ptep);
 }
 
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
@@ -282,7 +282,7 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 				       &ptep, &ptep_level))
 		return false;
 
-	return pte_young(ptep_get(ptep));
+	return pte_young(__ptep_get(ptep));
 }
 
 static bool fault_supports_gstage_huge_mapping(struct kvm_memory_slot *memslot,
-- 
2.39.5

