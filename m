Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F973F65EC
	for <linux-efi@vger.kernel.org>; Thu, 16 Jul 2026 12:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784205801; cv=none; b=rNMIfEn9wejwFPd/WN3zc8nfQFpLCpEUUolSRGXvXiNymtG+JIhOXHrW0AucYqoJ1NIVw0dlrL6AofurLxprgGCRL9bsxtlWoNa5BRSDke2oAiQ+FeHNDFIXVsGxiRHssj2/F8yCqkwpGYv+gDudEzgyDOtjVWOZK0ZNb5BFE3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784205801; c=relaxed/simple;
	bh=kCa2xNVMj+V75V+49VB/MuMM2EguhYMLPZCSxZBA3PY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Kf5SCQuOO4mpcRGuAscZr/jKeZII6wI+M1bvD46tDQtKB+rG/n6THuhY76S1fO4BnuLVnM6o09pgBGTNRQVOnqqm9njJhq5Gla2XMzRL0N/WbeJev8GFmbRUwwms3TLzcD485D51usfcuErPMKyW3QYcr+B+kOpRSoVgSq8AeAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=lql1FO7q; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="lql1FO7q"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-ca957432c7fso4563939a12.1
        for <linux-efi@vger.kernel.org>; Thu, 16 Jul 2026 05:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784205799; x=1784810599; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fNlHrO3Snp57unD4Dpln5m5m4ypo+fcvDFEAF+5w4Yg=;
        b=lql1FO7q4dAp67bq1/QIwfUShcZSQ0cUjD/mv/6RSw57AzzgpCBlQKRD3iNXN3QlUS
         PwfQmOe7aioQ7LveoIoVQ8+b9y3NToJ+03Qd44nTAfTukElpNerxNSpJhfpTtXbC3OSO
         eM8cH+CtFziL8s8LF7q4H8WpsskRCOfZ3y+kYZVDTjcF9i2McaHqJbDlGk4ls1+J5Xoj
         eqZc1sJO8XmAY+88IXkKXc+TnA/UgjGhvIWobGB5KFTVDUP3CoXnbLmSwp4RYolZWiNV
         nakVZCaeiqaMYbOGc4Q21lSlSDtWJTFn6efwHKCF+OM0SBM1+jpvDiVDFu5SV/d2MW93
         wgYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784205799; x=1784810599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=fNlHrO3Snp57unD4Dpln5m5m4ypo+fcvDFEAF+5w4Yg=;
        b=mRCPGGUiNzFYX+yI2qtAf+2xWEcADf9QbBTC5fpK6zelOEuhhihIVLOtTnGOiHZImC
         guFvWjVYanZhqnzkDRLg9adU6Csd/p6NrCN04gFf/y/gdJM3pfGNs4PNlW1Fl9SquPQC
         prc8Yz7t+/98929QtC6nTfeodAZ7DwtSU63pNeyp1uHU8tsYcweNocZxFERY6bxdWSaO
         79p4fB6c8siTqNP/uYOEnbJYWahbHxaviyUYHFIHlt6GnyoYPMvACOfjWH0ETleOgnKR
         QI+BZAwfwo3SeIANRW9FH99qJ9i8FWW8AZpKU4fLTqsl14hSLyKVUOR9CiqP8Q/JCCDj
         C/kQ==
X-Forwarded-Encrypted: i=1; AHgh+RqI3eIYBIFjtN/EFddIJ6D8lIVSoZc7kyxmgyltrMvGAKRerzsMJRU043JfYzHtnYYvyGAhYiaVczo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbJdDdsFi5ySmd7I7ccZirrNqiFcllLnxHe9e7Foz6PJUv+m1V
	RTJ3JiQnEOKIg2ePTLHkEXa/sE7pErHHNiI4uLLFKOhL6BlAwc0h1obhM9nqs48beWM=
X-Gm-Gg: AfdE7cmSi9pqzNwV/TWZ9E0U0ClYR9m5MX5VZcTvXGXi9O0fYRUDKKKSjta9EFd7Ack
	d0DUasCcyH1uAzOS4S8WXHgbOPKNcqHueXwi9xI7FdzxDQCkQZDuCFnlBUz39BEI858K5qn842c
	CCvkTzBorJY5WBAN8g98AHxukeAwlNg1Pi1bO14NsJptRy8erAD8TMi5dNBdRR8SpTJJiuLZX2p
	k5sHdNhqE1HloycZawnp9KmPZi51uIqmPZe46j+ulOO2pQwBN7vNmshbPT2FKQt0MNzmVIqUQGG
	Y8hXy1NOtdbBMoyte3e6Iv5S2zCeKKbtrvRxzufZzVLjC4i+1pt7Rbq+1qfAXoTsCsHrJrD8atC
	r1RUCRpTYt1vShuUJ9iivMylBGHVTYeF4t1xM+ECdpC7CQbfEslcVxU+pW5BRdFfUllZCo2COLR
	2dhNeitfHKzUdAmn3qA9ePvD0=
X-Received: by 2002:a05:6a21:730e:b0:3c1:279c:526c with SMTP id adf61e73a8af0-3c3576426d3mr10915500637.63.1784205798567;
        Thu, 16 Jul 2026 05:43:18 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([2408:8606:1800:501::2:f])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cb258eeaba2sm1730793a12.12.2026.07.16.05.43.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 16 Jul 2026 05:43:17 -0700 (PDT)
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
Subject: [PATCH v2 04/15] riscv/mm: implement Svnapot contpte update helpers
Date: Thu, 16 Jul 2026 20:41:39 +0800
Message-Id: <08e6e04deb4c415f6819d677858e3eca1270b0f1.1784201104.git.cuiyunhui@bytedance.com>
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

Svnapot support needs the public RISC-V PTE update helpers to preserve
the same logical per-page view that generic MM users see on the read
side. Without a dedicated update path, operations such as set_ptes(),
ptep_set_access_flags(), and related clear or write-protect flows would
end up touching the raw NAPOT encoding directly, which leaks arch-private
representation details into generic MM code and makes folded mappings
harder to update safely.

Add Svnapot-aware contpte update helpers and route the public update-side
PTE operations through them, while keeping the raw helpers available for
RISC-V code that still needs direct access to the encoded entries.

This also wires the update path into the related mechanics needed when a
Svnapot block is unfolded and rewritten, so page-table-check, access-flag
updates, and non-Svnapot builds continue to observe the expected public
PTE semantics.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/pgtable.h | 281 ++++++++++++++++++++++----
 arch/riscv/mm/contpte.c          | 329 ++++++++++++++++++++++++++++++-
 arch/riscv/mm/pgtable.c          |  18 ++
 3 files changed, 588 insertions(+), 40 deletions(-)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index fce6d04ea65db..771faabb2b00b 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -413,6 +413,30 @@ static inline int pte_special(pte_t pte)
 	return pte_val(pte) & _PAGE_SPECIAL;
 }
 
+#ifdef CONFIG_RISCV_ISA_SVNAPOT
+static inline pte_t pte_mknonnapot(pte_t pte, unsigned long addr)
+{
+	unsigned long pfn;
+	unsigned long offset;
+	pgprot_t prot;
+
+	if (!pte_present_napot(pte))
+		return pte;
+
+	offset = (addr & (napot_cont_size(napot_cont_order(pte)) - 1)) >>
+		 PAGE_SHIFT;
+	pfn = pte_pfn(pte) + offset;
+	prot = __pgprot((pte_val(pte) & ~_PAGE_PFN_MASK) & ~_PAGE_NAPOT);
+
+	return pfn_pte(pfn, prot);
+}
+#else
+static inline pte_t pte_mknonnapot(pte_t pte, unsigned long addr)
+{
+	return pte;
+}
+#endif
+
 /* static inline pte_t pte_rdprotect(pte_t pte) */
 
 static inline pte_t pte_wrprotect(pte_t pte)
@@ -555,6 +579,25 @@ void __napotpte_try_unfold(struct mm_struct *mm, unsigned long addr,
 			   pte_t *ptep, pte_t pte);
 pte_t napotpte_ptep_get(pte_t *ptep, pte_t orig_pte);
 pte_t napotpte_ptep_get_lockless(pte_t *ptep);
+void napotpte_set_ptes(struct mm_struct *mm, unsigned long addr,
+		       pte_t *ptep, pte_t pte, unsigned int nr);
+void napotpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
+			      pte_t *ptep, unsigned int nr, int full);
+pte_t napotpte_get_and_clear_full_ptes(struct mm_struct *mm,
+				       unsigned long addr, pte_t *ptep,
+				       unsigned int nr, int full);
+void napotpte_clear_young_dirty_ptes(struct vm_area_struct *vma,
+				     unsigned long addr, pte_t *ptep,
+				     unsigned int nr, cydp_t flags);
+void napotpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
+			     pte_t *ptep, unsigned int nr);
+int napotpte_ptep_set_access_flags(struct vm_area_struct *vma,
+				   unsigned long address, pte_t *ptep,
+				   pte_t entry, int dirty);
+int napotpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
+				       unsigned long address, pte_t *ptep);
+int napotpte_ptep_clear_flush_young(struct vm_area_struct *vma,
+				    unsigned long address, pte_t *ptep);
 #endif
 
 #ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
@@ -706,37 +749,6 @@ static inline pte_t __ptep_get_lockless(pte_t *ptep)
 	return __ptep_get(ptep);
 }
 
-#ifdef CONFIG_RISCV_ISA_SVNAPOT
-
-#define ptep_get ptep_get
-static inline pte_t ptep_get(pte_t *ptep)
-{
-	pte_t pte = __ptep_get(ptep);
-
-	if (likely(!pte_present_napot(pte)))
-		return pte;
-
-	return napotpte_ptep_get(ptep, pte);
-}
-
-#define ptep_get_lockless ptep_get_lockless
-static inline pte_t ptep_get_lockless(pte_t *ptep)
-{
-	pte_t pte = __ptep_get_lockless(ptep);
-
-	if (likely(!pte_present_napot(pte)))
-		return pte;
-
-	return napotpte_ptep_get_lockless(ptep);
-}
-
-#else
-
-#define ptep_get __ptep_get
-#define ptep_get_lockless __ptep_get_lockless
-
-#endif
-
 static inline void __clear_young_dirty_pte(struct vm_area_struct *vma,
 					   unsigned long addr, pte_t *ptep,
 					   pte_t pte, cydp_t flags)
@@ -829,7 +841,6 @@ static inline pte_t __ptep_clear_flush(struct vm_area_struct *vma,
 
 #define __ptep_clear_flush __ptep_clear_flush
 
-#define __HAVE_ARCH_PTEP_SET_WRPROTECT
 static inline void __ptep_set_wrprotect(struct mm_struct *mm,
 					unsigned long address, pte_t *ptep)
 {
@@ -870,7 +881,169 @@ static inline bool __ptep_clear_flush_young(struct vm_area_struct *vma,
 
 #define __ptep_clear_flush_young __ptep_clear_flush_young
 
-#define set_pte __set_pte
+#ifdef CONFIG_RISCV_ISA_SVNAPOT
+
+static __always_inline void napotpte_try_fold(struct mm_struct *mm,
+					      unsigned long addr, pte_t *ptep,
+					      pte_t pte)
+{
+	const unsigned long contmask = napot_pte_num(NAPOT_CONT64KB_ORDER) - 1;
+	bool valign = ((addr >> PAGE_SHIFT) & contmask) == contmask;
+
+	if (unlikely(valign)) {
+		bool palign = (pte_pfn(pte) & contmask) == contmask;
+
+		if (unlikely(palign && pte_present(pte) && !pte_napot(pte) &&
+			     !pte_special(pte)))
+			__napotpte_try_fold(mm, addr, ptep, pte);
+	}
+}
+
+static __always_inline void napotpte_try_unfold(struct mm_struct *mm,
+						unsigned long addr, pte_t *ptep,
+						pte_t pte)
+{
+	if (unlikely(pte_present_napot(pte)))
+		__napotpte_try_unfold(mm, addr, ptep, pte);
+}
+
+/*
+ * Public PTE helpers may transparently handle Svnapot-encoded mappings.
+ * NAPOT-aware arch users should stick to the private/raw __pte* helpers.
+ */
+#define ptep_get ptep_get
+static inline pte_t ptep_get(pte_t *ptep)
+{
+	pte_t pte = __ptep_get(ptep);
+
+	if (likely(!pte_present_napot(pte)))
+		return pte;
+
+	return napotpte_ptep_get(ptep, pte);
+}
+
+#define ptep_get_lockless ptep_get_lockless
+static inline pte_t ptep_get_lockless(pte_t *ptep)
+{
+	pte_t pte = __ptep_get_lockless(ptep);
+
+	if (likely(!pte_present_napot(pte)))
+		return pte;
+
+	return napotpte_ptep_get_lockless(ptep);
+}
+
+#define set_ptes set_ptes
+static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
+			    pte_t *ptep, pte_t pteval, unsigned int nr)
+{
+	pteval = pte_mknonnapot(pteval, addr);
+
+	if (likely(nr == 1)) {
+		napotpte_try_unfold(mm, addr, ptep, __ptep_get(ptep));
+		__set_ptes(mm, addr, ptep, pteval, 1);
+		napotpte_try_fold(mm, addr, ptep, pteval);
+		return;
+	}
+
+	napotpte_set_ptes(mm, addr, ptep, pteval, nr);
+}
+
+static inline void pte_clear(struct mm_struct *mm,
+			     unsigned long addr, pte_t *ptep)
+{
+	napotpte_try_unfold(mm, addr, ptep, __ptep_get(ptep));
+	__pte_clear(mm, addr, ptep);
+}
+
+static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
+				       unsigned long addr, pte_t *ptep)
+{
+	napotpte_try_unfold(mm, addr, ptep, __ptep_get(ptep));
+	return __ptep_get_and_clear(mm, addr, ptep);
+}
+
+#define clear_young_dirty_ptes clear_young_dirty_ptes
+static inline void clear_young_dirty_ptes(struct vm_area_struct *vma,
+					  unsigned long addr, pte_t *ptep,
+					  unsigned int nr, cydp_t flags)
+{
+	if (likely(nr == 1 && !pte_present_napot(__ptep_get(ptep))))
+		__clear_young_dirty_ptes(vma, addr, ptep, nr, flags);
+	else
+		napotpte_clear_young_dirty_ptes(vma, addr, ptep, nr, flags);
+}
+
+#define clear_full_ptes clear_full_ptes
+static inline void clear_full_ptes(struct mm_struct *mm, unsigned long addr,
+				   pte_t *ptep, unsigned int nr, int full)
+{
+	if (likely(nr == 1)) {
+		napotpte_try_unfold(mm, addr, ptep, __ptep_get(ptep));
+		__ptep_get_and_clear(mm, addr, ptep);
+		return;
+	}
+
+	napotpte_clear_full_ptes(mm, addr, ptep, nr, full);
+}
+
+#define get_and_clear_full_ptes get_and_clear_full_ptes
+static inline pte_t get_and_clear_full_ptes(struct mm_struct *mm,
+					    unsigned long addr, pte_t *ptep,
+					    unsigned int nr, int full)
+{
+	if (likely(nr == 1)) {
+		napotpte_try_unfold(mm, addr, ptep, __ptep_get(ptep));
+		return __ptep_get_and_clear(mm, addr, ptep);
+	}
+
+	return napotpte_get_and_clear_full_ptes(mm, addr, ptep, nr, full);
+}
+
+#define wrprotect_ptes wrprotect_ptes
+static inline void wrprotect_ptes(struct mm_struct *mm,
+				  unsigned long address, pte_t *ptep,
+				  unsigned int nr)
+{
+	if (likely(nr == 1)) {
+		napotpte_try_unfold(mm, address, ptep, __ptep_get(ptep));
+		__ptep_set_wrprotect(mm, address, ptep);
+		return;
+	}
+
+	napotpte_wrprotect_ptes(mm, address, ptep, nr);
+}
+
+#define __HAVE_ARCH_PTEP_SET_WRPROTECT
+static inline void ptep_set_wrprotect(struct mm_struct *mm,
+				      unsigned long address, pte_t *ptep)
+{
+	wrprotect_ptes(mm, address, ptep, 1);
+}
+
+#define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
+static inline int ptep_clear_flush_young(struct vm_area_struct *vma,
+					 unsigned long address, pte_t *ptep)
+{
+	pte_t orig_pte = __ptep_get(ptep);
+
+	if (likely(!pte_present_napot(orig_pte)))
+		return __ptep_clear_flush_young(vma, address, ptep);
+
+	return napotpte_ptep_clear_flush_young(vma, address, ptep);
+}
+
+#else /* CONFIG_RISCV_ISA_SVNAPOT */
+
+#define napotpte_ptep_set_access_flags(vma, address, ptep, entry, dirty) \
+	({ (void)(vma); (void)(address); (void)(ptep); (void)(entry); \
+	   (void)(dirty); 0; })
+
+#define napotpte_ptep_test_and_clear_young(vma, address, ptep) \
+	({ (void)(vma); (void)(address); (void)(ptep); 0; })
+
+#define ptep_get __ptep_get
+#define ptep_get_lockless __ptep_get_lockless
 #define set_ptes __set_ptes
 
 static inline void pte_clear(struct mm_struct *mm,
@@ -881,9 +1054,51 @@ static inline void pte_clear(struct mm_struct *mm,
 
 #define ptep_get_and_clear __ptep_get_and_clear
 #define clear_young_dirty_ptes __clear_young_dirty_ptes
+
+static inline void __clear_full_ptes(struct mm_struct *mm,
+				     unsigned long addr, pte_t *ptep,
+				     unsigned int nr, int full)
+{
+	for (;;) {
+		__ptep_get_and_clear(mm, addr, ptep);
+		if (--nr == 0)
+			break;
+		ptep++;
+		addr += PAGE_SIZE;
+	}
+}
+
+static inline pte_t __get_and_clear_full_ptes(struct mm_struct *mm,
+					      unsigned long addr, pte_t *ptep,
+					      unsigned int nr, int full)
+{
+	pte_t pte, tmp_pte;
+
+	pte = __ptep_get_and_clear(mm, addr, ptep);
+	while (--nr) {
+		ptep++;
+		addr += PAGE_SIZE;
+		tmp_pte = __ptep_get_and_clear(mm, addr, ptep);
+		if (pte_dirty(tmp_pte))
+			pte = riscv_pte_mkhwdirty(pte);
+		if (pte_young(tmp_pte))
+			pte = pte_mkyoung(pte);
+	}
+
+	return pte;
+}
+
+#define clear_full_ptes __clear_full_ptes
+#define get_and_clear_full_ptes __get_and_clear_full_ptes
+#define __HAVE_ARCH_PTEP_SET_WRPROTECT
 #define ptep_set_wrprotect __ptep_set_wrprotect
+#define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
 #define ptep_clear_flush_young __ptep_clear_flush_young
 
+#endif /* CONFIG_RISCV_ISA_SVNAPOT */
+
+#define set_pte __set_pte
+
 #define pgprot_nx pgprot_nx
 static inline pgprot_t pgprot_nx(pgprot_t _prot)
 {
diff --git a/arch/riscv/mm/contpte.c b/arch/riscv/mm/contpte.c
index 43ea76e424492..3f8a0a2970afb 100644
--- a/arch/riscv/mm/contpte.c
+++ b/arch/riscv/mm/contpte.c
@@ -62,6 +62,24 @@ static inline unsigned long pte_protval_no_pfn_no_napot(pte_t pte)
 	return (pte_val(pte) & ~_PAGE_PFN_MASK) & ~_PAGE_NAPOT;
 }
 
+static inline void napotpte_clear_young_dirty_pte(pte_t *ptep, cydp_t flags)
+{
+	pte_t old_pte, new_pte;
+	unsigned long old_val, new_val;
+
+	do {
+		old_pte = READ_ONCE(*ptep);
+		new_pte = old_pte;
+		if (flags & CYDP_CLEAR_YOUNG)
+			new_pte = pte_mkold(new_pte);
+		if (flags & CYDP_CLEAR_DIRTY)
+			new_pte = pte_mkclean(new_pte);
+
+		old_val = pte_val(old_pte);
+		new_val = pte_val(new_pte);
+	} while (cmpxchg_relaxed(&pte_val(*ptep), old_val, new_val) != old_val);
+}
+
 static inline pte_t napotpte_subpte(pte_t *ptep, pte_t pte)
 {
 	unsigned long pfn;
@@ -76,13 +94,34 @@ static inline pte_t napotpte_subpte(pte_t *ptep, pte_t pte)
 	return pfn_pte(pfn, prot);
 }
 
-static inline pte_t __napot_ptep_get_and_clear(struct mm_struct *mm,
-					       unsigned long addr, pte_t *ptep)
+static void __clear_full_ptes(struct mm_struct *mm, unsigned long addr,
+			      pte_t *ptep, unsigned int nr, int full)
 {
-	pte_t pte;
+	for (;;) {
+		__ptep_get_and_clear(mm, addr, ptep);
+		if (--nr == 0)
+			break;
+		ptep++;
+		addr += PAGE_SIZE;
+	}
+}
 
-	pte = __pte(atomic_long_xchg((atomic_long_t *)ptep, 0));
-	page_table_check_pte_clear(mm, addr, pte_mknonnapot(pte, addr));
+static pte_t __get_and_clear_full_ptes(struct mm_struct *mm,
+				       unsigned long addr, pte_t *ptep,
+				       unsigned int nr, int full)
+{
+	pte_t pte, tmp_pte;
+
+	pte = __ptep_get_and_clear(mm, addr, ptep);
+	while (--nr) {
+		ptep++;
+		addr += PAGE_SIZE;
+		tmp_pte = __ptep_get_and_clear(mm, addr, ptep);
+		if (pte_dirty(tmp_pte))
+			pte = riscv_pte_mkhwdirty(pte);
+		if (pte_young(tmp_pte))
+			pte = pte_mkyoung(pte);
+	}
 
 	return pte;
 }
@@ -102,8 +141,9 @@ static void napotpte_convert(struct mm_struct *mm, unsigned long addr,
 
 	for (i = 0; i < nr; i++) {
 		ptent_addr = start_addr + i * PAGE_SIZE;
-		ptent = __napot_ptep_get_and_clear(mm, ptent_addr,
-						   start_ptep + i);
+		ptent = __ptep_get_and_clear_noptc(start_ptep + i);
+		page_table_check_pte_clear(mm, ptent_addr,
+					   pte_mknonnapot(ptent, ptent_addr));
 		if (pte_dirty(ptent))
 			target = riscv_pte_mkhwdirty(target);
 		if (pte_young(ptent))
@@ -136,6 +176,22 @@ static inline bool napotpte_is_consistent(pte_t pte, pte_t orig_pte)
 	       pte_val(pte_mask_ad(pte)) == pte_val(pte_mask_ad(orig_pte));
 }
 
+static bool napotpte_all_subptes_same(pte_t *ptep, pte_t expected_pte)
+{
+	pte_t *start;
+	unsigned int i, nr;
+
+	start = napot_align_ptep(ptep);
+	nr = napotpte_pte_num();
+
+	for (i = 0; i < nr; i++) {
+		if (!pte_same(READ_ONCE(start[i]), expected_pte))
+			return false;
+	}
+
+	return true;
+}
+
 void __napotpte_try_fold(struct mm_struct *mm, unsigned long addr,
 			 pte_t *ptep, pte_t pte)
 {
@@ -271,3 +327,262 @@ pte_t napotpte_ptep_get_lockless(pte_t *orig_ptep)
 	return napotpte_subpte(orig_ptep, orig_pte);
 }
 EXPORT_SYMBOL(napotpte_ptep_get_lockless);
+
+static void napotpte_try_unfold_range(struct mm_struct *mm,
+				      unsigned long addr, pte_t *ptep,
+				      unsigned int nr)
+{
+	unsigned long next;
+	pte_t pte;
+	unsigned int chunk;
+
+	while (nr) {
+		pte = READ_ONCE(*ptep);
+		if (pte_present_napot(pte)) {
+			__napotpte_try_unfold(mm, addr, ptep, pte);
+			next = napot_align_addr(addr) + napotpte_size();
+			chunk = (next - addr) >> PAGE_SHIFT;
+		} else {
+			chunk = 1;
+		}
+
+		if (chunk > nr)
+			chunk = nr;
+
+		ptep += chunk;
+		addr += chunk * PAGE_SIZE;
+		nr -= chunk;
+	}
+}
+
+static void napotpte_try_unfold_partial(struct mm_struct *mm,
+					unsigned long addr, pte_t *ptep,
+					unsigned int nr)
+{
+	pte_t pte;
+
+	if (ptep != napot_align_ptep(ptep) || nr < napotpte_pte_num()) {
+		pte = READ_ONCE(*ptep);
+		if (pte_present_napot(pte))
+			__napotpte_try_unfold(mm, addr, ptep, pte);
+	}
+
+	if (ptep + nr != napot_align_ptep(ptep + nr)) {
+		unsigned long last_addr;
+		pte_t *last_ptep;
+
+		last_addr = addr + PAGE_SIZE * (nr - 1);
+		last_ptep = ptep + nr - 1;
+		pte = READ_ONCE(*last_ptep);
+		if (pte_present_napot(pte))
+			__napotpte_try_unfold(mm, last_addr, last_ptep, pte);
+	}
+}
+
+void napotpte_set_ptes(struct mm_struct *mm, unsigned long addr,
+		       pte_t *ptep, pte_t pte, unsigned int nr)
+{
+	unsigned long next, end;
+	unsigned long pfn, size, boundary;
+	pgprot_t prot;
+	unsigned int chunk, i;
+	pte_t cur;
+
+	if (!napot_hw_supported() || !mm_is_user(mm)) {
+		__set_ptes(mm, addr, ptep, pte, nr);
+		return;
+	}
+
+	size = napotpte_size();
+	end = addr + ((unsigned long)nr << PAGE_SHIFT);
+	pfn = pte_pfn(pte);
+	prot = __pgprot(pte_protval_no_pfn_no_napot(pte));
+
+	do {
+		boundary = (addr + size) & ~(size - 1);
+		next = (boundary - 1 < end - 1) ? boundary : end;
+		chunk = (next - addr) >> PAGE_SHIFT;
+
+		cur = pfn_pte(pfn, prot);
+		if (((addr | next | (pfn << PAGE_SHIFT)) & (size - 1)) == 0) {
+			cur = pte_mknapot(cur, napotpte_order());
+			page_table_check_ptes_set(mm, addr, ptep, cur, chunk);
+			for (i = 0; i < chunk; i++)
+				__set_pte_at(mm, ptep + i, cur);
+		} else {
+			__set_ptes(mm, addr, ptep, cur, chunk);
+		}
+
+		addr = next;
+		ptep += chunk;
+		pfn += chunk;
+	} while (addr != end);
+}
+EXPORT_SYMBOL(napotpte_set_ptes);
+
+void napotpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
+			      pte_t *ptep, unsigned int nr, int full)
+{
+	if (!napot_hw_supported() || !mm_is_user(mm)) {
+		__clear_full_ptes(mm, addr, ptep, nr, full);
+		return;
+	}
+
+	/*
+	 * Svnapot stores identical napot-encoded entries across the whole block
+	 * rather than per-page PFNs, so batch zap paths must unfold the covered
+	 * range before the generic MM consumes ordinary per-page PTEs.
+	 */
+	napotpte_try_unfold_range(mm, addr, ptep, nr);
+	__clear_full_ptes(mm, addr, ptep, nr, full);
+}
+EXPORT_SYMBOL(napotpte_clear_full_ptes);
+
+pte_t napotpte_get_and_clear_full_ptes(struct mm_struct *mm,
+				       unsigned long addr, pte_t *ptep,
+				       unsigned int nr, int full)
+{
+	if (!napot_hw_supported() || !mm_is_user(mm))
+		return __get_and_clear_full_ptes(mm, addr, ptep, nr, full);
+
+	napotpte_try_unfold_range(mm, addr, ptep, nr);
+
+	return __get_and_clear_full_ptes(mm, addr, ptep, nr, full);
+}
+EXPORT_SYMBOL(napotpte_get_and_clear_full_ptes);
+
+void napotpte_clear_young_dirty_ptes(struct vm_area_struct *vma,
+				     unsigned long addr, pte_t *ptep,
+				     unsigned int nr, cydp_t flags)
+{
+	struct mm_struct *mm;
+	unsigned long start, end;
+	unsigned int total;
+
+	mm = vma->vm_mm;
+	if (!napot_hw_supported() || !mm_is_user(mm)) {
+		__clear_young_dirty_ptes(vma, addr, ptep, nr, flags);
+		return;
+	}
+
+	start = addr;
+	end = start + nr * PAGE_SIZE;
+
+	if (pte_present_napot(READ_ONCE(*(ptep + nr - 1))))
+		end = ALIGN(end, napotpte_size());
+
+	if (pte_present_napot(READ_ONCE(*ptep))) {
+		start = napot_align_addr(start);
+		ptep = napot_align_ptep(ptep);
+	}
+
+	total = (end - start) >> PAGE_SHIFT;
+	for (; total; total--, ptep++, start += PAGE_SIZE)
+		napotpte_clear_young_dirty_pte(ptep, flags);
+}
+EXPORT_SYMBOL(napotpte_clear_young_dirty_ptes);
+
+void napotpte_wrprotect_ptes(struct mm_struct *mm, unsigned long addr,
+			     pte_t *ptep, unsigned int nr)
+{
+	unsigned int i;
+
+	if (!napot_hw_supported() || !mm_is_user(mm)) {
+		for (i = 0; i < nr; i++, ptep++, addr += PAGE_SIZE)
+			__ptep_set_wrprotect(mm, addr, ptep);
+		return;
+	}
+
+	napotpte_try_unfold_partial(mm, addr, ptep, nr);
+
+	for (i = 0; i < nr; i++, ptep++, addr += PAGE_SIZE)
+		__ptep_set_wrprotect(mm, addr, ptep);
+}
+EXPORT_SYMBOL(napotpte_wrprotect_ptes);
+
+int napotpte_ptep_set_access_flags(struct vm_area_struct *vma,
+				   unsigned long address, pte_t *ptep,
+				   pte_t entry, int dirty)
+{
+	pte_t raw_pte, napot_pte;
+	pte_t *start;
+	pgprot_t prot;
+	unsigned long start_addr;
+	unsigned int i, nr;
+	bool changed;
+
+	raw_pte = READ_ONCE(*ptep);
+	if (!napot_hw_supported() || !pte_present_napot(raw_pte))
+		return 0;
+
+	prot = pte_pgprot(entry);
+	napot_pte = pfn_pte(pte_pfn(raw_pte), prot);
+	napot_pte = pte_mknapot(napot_pte, napotpte_order());
+
+	if (napotpte_all_subptes_same(ptep, napot_pte))
+		return !riscv_has_extension_unlikely(RISCV_ISA_EXT_SVVPTC);
+
+	if (pte_write(raw_pte) != pte_write(napot_pte)) {
+		__napotpte_try_unfold(vma->vm_mm, address, ptep, raw_pte);
+		entry = pte_mknonnapot(entry, address);
+
+		return __ptep_set_access_flags(vma, address, ptep, entry,
+					      dirty);
+	}
+
+	start = napot_align_ptep(ptep);
+	address = napot_align_addr(address);
+	start_addr = address;
+	nr = napotpte_pte_num();
+	changed = false;
+
+	for (i = 0; i < nr; i++, start++, address += PAGE_SIZE) {
+		if (__ptep_set_access_flags(vma, address, start, napot_pte, 0))
+			changed = true;
+	}
+
+	if (changed)
+		flush_tlb_range(vma, start_addr, start_addr + napotpte_size());
+
+	return changed;
+}
+EXPORT_SYMBOL(napotpte_ptep_set_access_flags);
+
+int napotpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
+				       unsigned long address, pte_t *ptep)
+{
+	pte_t *start;
+	unsigned int i, nr;
+	int young;
+
+	if (!napot_hw_supported() || !pte_present_napot(READ_ONCE(*ptep)))
+		return 0;
+
+	start = napot_align_ptep(ptep);
+	nr = napotpte_pte_num();
+	young = 0;
+
+	for (i = 0; i < nr; i++)
+		young |= test_and_clear_bit(_PAGE_ACCESSED_OFFSET,
+					   &pte_val(start[i]));
+
+	return young;
+}
+EXPORT_SYMBOL(napotpte_ptep_test_and_clear_young);
+
+int napotpte_ptep_clear_flush_young(struct vm_area_struct *vma,
+				    unsigned long address, pte_t *ptep)
+{
+	unsigned long start_addr;
+	int young;
+
+	young = napotpte_ptep_test_and_clear_young(vma, address, ptep);
+	if (!young)
+		return 0;
+
+	start_addr = napot_align_addr(address);
+	flush_tlb_range(vma, start_addr, start_addr + napotpte_size());
+
+	return young;
+}
+EXPORT_SYMBOL(napotpte_ptep_clear_flush_young);
diff --git a/arch/riscv/mm/pgtable.c b/arch/riscv/mm/pgtable.c
index 43bd542c6ff02..50e4c4cc10691 100644
--- a/arch/riscv/mm/pgtable.c
+++ b/arch/riscv/mm/pgtable.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <asm/pgalloc.h>
+#include <linux/cpufeature.h>
 #include <linux/gfp.h>
 #include <linux/kernel.h>
 #include <linux/pgtable.h>
@@ -32,6 +33,16 @@ int ptep_set_access_flags(struct vm_area_struct *vma,
 			  unsigned long address, pte_t *ptep,
 			  pte_t entry, int dirty)
 {
+	pte_t raw_pte;
+
+	entry = pte_mknonnapot(entry, address);
+
+	raw_pte = READ_ONCE(*ptep);
+	if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SVNAPOT) &&
+	    pte_present_napot(raw_pte))
+		return napotpte_ptep_set_access_flags(vma, address, ptep, entry,
+					      dirty);
+
 	return __ptep_set_access_flags(vma, address, ptep, entry, dirty);
 }
 
@@ -50,6 +61,13 @@ bool ptep_test_and_clear_young(struct vm_area_struct *vma,
 			       unsigned long address,
 			       pte_t *ptep)
 {
+	pte_t raw_pte;
+
+	raw_pte = READ_ONCE(*ptep);
+	if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SVNAPOT) &&
+	    pte_present_napot(raw_pte))
+		return napotpte_ptep_test_and_clear_young(vma, address, ptep);
+
 	return __ptep_test_and_clear_young(vma, address, ptep);
 }
 EXPORT_SYMBOL_GPL(ptep_test_and_clear_young);
-- 
2.39.5

