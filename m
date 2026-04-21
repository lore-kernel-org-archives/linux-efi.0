Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E8153A5E93
	for <linux-efi@vger.kernel.org>; Tue, 21 Apr 2026 09:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776763544; cv=none; b=BehLTAndsXg1AzxEG/pH/UIEks5mUTpmxNOIGKK0cWVw1uvFRIuMBBCGDK5u4+7G5XhhS7UGmUp1w5/stMs5q6fabvg5OegdhzpQG+CWkgFZUAbwJDbqXdrzXCUpiKuoLHfImBqBdJ2rBMmo+16z4gTyC1ZyvqEeYfuOi2AXV7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776763544; c=relaxed/simple;
	bh=HQOGKbyG1jukjMC5CkaRgoKkdrfRVJKKytRiflUvgY0=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=i511msg7aiM32UTGsbnQMlrk++aopqrh6f/mMFXdFW6WCgK3UYX0MJ4f9/qPN5rv5bduYKkef+e88vh1dL7glsNTCMjZFwKBAkA8nc3nKArHQxOP1GdOqhunfKH6mNTY095teYWsL4uSGcspTcHQpcgAN0fOw5uW/+eyYKyB97E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=B37AwPPE; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="B37AwPPE"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2b788a98557so3106975ad.2
        for <linux-efi@vger.kernel.org>; Tue, 21 Apr 2026 02:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776763539; x=1777368339; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e3Aiqpt/ykXwmcx+XDDP/rmLrEEbX7Jgl7wd7KeN5Vc=;
        b=B37AwPPEQpmKAdGFaeQMU9XWxmd9m/ZRvNXJ+yXZzTwrIg1EnAB0CURVNE834xbPMb
         kzQRSPgd//ZAvlJXYh/FPZVLEylY1TawPi7S2M5VB3WJ4Gmd4UQRlN1wlH+c6g+EeNkN
         eWZlUFuBXZyocDz5cDJI8S6mhcCsP6ymWv6XxWp8wFB7AYsztZ1nF7DbSxY+6dtAbIcU
         T+i/rQq3s79y8WxVGnhSeFAvx6IdY0GtzGPIrpxTH4QuC8rJtVEUYx0PDW5RbzehISu5
         D00eytCKTBTxoLTxchZJ9zZy1/XL86Blsf+MNgGU4OLXHAx9vTWJxi8VkUc6f9G1zD2c
         Iz/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776763539; x=1777368339;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=e3Aiqpt/ykXwmcx+XDDP/rmLrEEbX7Jgl7wd7KeN5Vc=;
        b=EBzazNnAIUv2ZdZ9mmGUpJWd3Jpny3izGYGoFfCPFcT//1oLupBY1dOqgpjZgycrFr
         l10BDEDFqd64/F8m409JIWJPF/OEdOA6Bu+4BbhKYu88/Xz4DIHpvfDawoNzJFI0wSkT
         0lY70olzBQKt588ccOocin5b7gmJYiv6cCPRWbHWOjmMHMWG9NnL8cxIE8Z993f68VLa
         Z+dEni5XKtNv+53qUM/h0Eg5dAwdsSzTHf7QBrNhZ7koUxlvnv73tmejEi4oMyT8ot5b
         r5rSq3JeJwCJGJn9CzPU3Q4o0eJeQ7q0SXRYyO3t2QAVE5jyL6kF15kwSFmGtub/n1KM
         fhYw==
X-Forwarded-Encrypted: i=1; AFNElJ/v++1XO2hMn0vpI1RCwb3QWJxpSY8swRoyBBIDaMSoWsr/E57qBN/ikw+h2biJ3vjgNGdzsMf8jyc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRak6R8CwUQSAkps6RYxj5NkKbF/D7D38ezVWrBT+4yyGPC7G6
	z7eHeMXqIxdPy+/j6viRo6Hvpu2BcFxCfKuNA+5v3VSOp4IRYaTEnVI3X+9EiuA0Tws=
X-Gm-Gg: AeBDiesDnMT8GxggaTOPZpvk87MaKf7qTrr/KQDIc04RaXpnpAHLBGUHWi6TDqzfYFL
	MfgRhLmqK0agp+7xHaga9O66yR0JAjXsUC2NM4Ucy43/ZVmKSBMPEt+TmlrQmraqjdMdF1qqoFG
	lv7mpdM3WzJLNcsK3aEm0Bphlfcm+z52jypLd2SxYozR1izQ0wKJrQ4zAK5hcirR02w2exxUea6
	+Nv0zvvXIXbpubiHCNGNTy3m1jFiNbokSp6e4740S3u/Ebyl2liRGDhCMbvadVrQ/gWFkIqVH1B
	SZibuUsshOSX/ou/IiiQGRunhQaqEzm91icwBsYVrz7xN7aAxoo7p5U2aoFk8+ELNrTv80b9k/n
	FkhlLhgzkdDRLNb2EkpcF+hkd+DGhT8JW3KBj+CS08fL2fKzhplkoPGlQmlxO1+z6mxixBAILHm
	dXQQ70Z/Z+DdK6N17oN++aHn9OIiMmXA5uICuERCwQjxzs7iYD0r9gqVvIGWEq275fQoI7
X-Received: by 2002:a17:902:f54d:b0:2b4:5b1a:d09c with SMTP id d9443c01a7336-2b5f9edb4cbmr186430275ad.15.1776763538472;
        Tue, 21 Apr 2026 02:25:38 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fa9ff39csm131965105ad.4.2026.04.21.02.25.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 21 Apr 2026 02:25:38 -0700 (PDT)
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
Subject: [PATCH 3/7] riscv: mm: add Svnapot-aware contiguous PTE wrappers
Date: Tue, 21 Apr 2026 17:24:53 +0800
Message-Id: <20260421092457.37649-4-cuiyunhui@bytedance.com>
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

Add Svnapot-aware wrappers around the public PTE helpers so core MM
callers can operate on contiguous mappings without learning the NAPOT
encoding details. Introduce contpte.c to handle folding, unfolding and
accessed/dirty state aggregation for contiguous PTE blocks.

Keep the raw __* helpers unchanged so NAPOT-aware callers can continue
to access the underlying PTE encoding directly, and centralize the
public Svnapot-aware wrappers under a single CONFIG_RISCV_ISA_SVNAPOT
block with simple alias fallbacks for the non-Svnapot case.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/pgtable.h | 288 +++++++++++++++++--
 arch/riscv/mm/Makefile           |   1 +
 arch/riscv/mm/contpte.c          | 479 +++++++++++++++++++++++++++++++
 arch/riscv/mm/pgtable.c          |  39 ++-
 4 files changed, 769 insertions(+), 38 deletions(-)
 create mode 100644 arch/riscv/mm/contpte.c

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 4de1f40fa77ea..722483d4df37f 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -11,6 +11,10 @@
 
 #include <asm/pgtable-bits.h>
 
+#ifndef __ASSEMBLER__
+#include <asm/cmpxchg.h>
+#endif
+
 #ifndef CONFIG_MMU
 #ifdef CONFIG_RELOCATABLE
 #define KERNEL_LINK_ADDR	UL(0)
@@ -301,6 +305,12 @@ static inline unsigned long pte_napot(pte_t pte)
 	return 0;
 }
 
+static inline pte_t pte_mknapot(pte_t pte, unsigned int order)
+{
+	(void)order;
+	return pte;
+}
+
 #endif /* CONFIG_RISCV_ISA_SVNAPOT */
 
 /* Yields the page frame number (PFN) of a page table entry */
@@ -339,6 +349,11 @@ static inline int pte_present(pte_t pte)
 	return (pte_val(pte) & (_PAGE_PRESENT | _PAGE_PROT_NONE));
 }
 
+static inline bool pte_present_napot(pte_t pte)
+{
+	return pte_present(pte) && pte_napot(pte);
+}
+
 #define pte_accessible pte_accessible
 static inline unsigned long pte_accessible(struct mm_struct *mm, pte_t a)
 {
@@ -392,6 +407,23 @@ static inline int pte_special(pte_t pte)
 	return pte_val(pte) & _PAGE_SPECIAL;
 }
 
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
+
 /* static inline pte_t pte_rdprotect(pte_t pte) */
 
 static inline pte_t pte_wrprotect(pte_t pte)
@@ -642,24 +674,12 @@ static inline void __set_ptes(struct mm_struct *mm, unsigned long addr,
 
 #define __set_ptes __set_ptes
 
-static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
-			    pte_t *ptep, pte_t pteval, unsigned int nr)
-{
-	__set_ptes(mm, addr, ptep, pteval, nr);
-}
-
 static inline void __pte_clear(struct mm_struct *mm,
 			       unsigned long addr, pte_t *ptep)
 {
 	__set_pte_at(mm, ptep, __pte(0));
 }
 
-static inline void pte_clear(struct mm_struct *mm,
-	unsigned long addr, pte_t *ptep)
-{
-	__pte_clear(mm, addr, ptep);
-}
-
 #define __ptep_get __ptep_get
 static inline pte_t __ptep_get(pte_t *ptep)
 {
@@ -672,6 +692,47 @@ static inline pte_t __ptep_get_lockless(pte_t *ptep)
 	return __ptep_get(ptep);
 }
 
+static inline void __clear_young_dirty_pte(struct vm_area_struct *vma,
+					   unsigned long addr, pte_t *ptep,
+					   pte_t pte, cydp_t flags)
+{
+	pte_t old_pte;
+
+	do {
+		old_pte = pte;
+
+		if (flags & CYDP_CLEAR_YOUNG)
+			pte = pte_mkold(pte);
+		if (flags & CYDP_CLEAR_DIRTY)
+			pte = pte_mkclean(pte);
+
+		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
+					       pte_val(old_pte),
+					       pte_val(pte));
+	} while (pte_val(pte) != pte_val(old_pte));
+}
+
+static inline void __clear_young_dirty_ptes(struct vm_area_struct *vma,
+					    unsigned long addr, pte_t *ptep,
+					    unsigned int nr, cydp_t flags)
+{
+	pte_t pte;
+
+	for (;;) {
+		pte = __ptep_get(ptep);
+
+		if (flags == (CYDP_CLEAR_YOUNG | CYDP_CLEAR_DIRTY))
+			__set_pte(ptep, pte_mkclean(pte_mkold(pte)));
+		else
+			__clear_young_dirty_pte(vma, addr, ptep, pte, flags);
+
+		if (--nr == 0)
+			break;
+		ptep++;
+		addr += PAGE_SIZE;
+	}
+}
+
 #define __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS	/* defined in mm/pgtable.c */
 extern int ptep_set_access_flags(struct vm_area_struct *vma, unsigned long address,
 				 pte_t *ptep, pte_t entry, int dirty);
@@ -703,12 +764,6 @@ __ptep_get_and_clear(struct mm_struct *mm, unsigned long address, pte_t *ptep)
 
 #define __ptep_get_and_clear __ptep_get_and_clear
 
-static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
-				       unsigned long address, pte_t *ptep)
-{
-	return __ptep_get_and_clear(mm, address, ptep);
-}
-
 static inline void
 __ptep_set_wrprotect(struct mm_struct *mm, unsigned long address, pte_t *ptep)
 {
@@ -725,13 +780,6 @@ __ptep_set_wrprotect(struct mm_struct *mm, unsigned long address, pte_t *ptep)
 
 #define __ptep_set_wrprotect __ptep_set_wrprotect
 
-#define __HAVE_ARCH_PTEP_SET_WRPROTECT
-static inline void ptep_set_wrprotect(struct mm_struct *mm,
-				      unsigned long address, pte_t *ptep)
-{
-	__ptep_set_wrprotect(mm, address, ptep);
-}
-
 static inline pte_t __ptep_clear_flush(struct vm_area_struct *vma,
 				       unsigned long address,
 				       pte_t *ptep)
@@ -744,9 +792,8 @@ static inline pte_t __ptep_clear_flush(struct vm_area_struct *vma,
 	return pte;
 }
 
-#define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
-static inline bool ptep_clear_flush_young(struct vm_area_struct *vma,
-		unsigned long address, pte_t *ptep)
+static inline bool __ptep_clear_flush_young(struct vm_area_struct *vma,
+					    unsigned long address, pte_t *ptep)
 {
 	/*
 	 * This comment is borrowed from x86, but applies equally to RISC-V:
@@ -763,9 +810,192 @@ static inline bool ptep_clear_flush_young(struct vm_area_struct *vma,
 	 * shouldn't really matter because there's no real memory
 	 * pressure for swapout to react to. ]
 	 */
-	return ptep_test_and_clear_young(vma, address, ptep);
+	return __ptep_test_and_clear_young(vma, address, ptep);
+}
+
+#define __ptep_clear_flush_young __ptep_clear_flush_young
+
+#ifdef CONFIG_RISCV_ISA_SVNAPOT
+
+/*
+ * The Svnapot helpers transparently manage napot-encoded PTEs for the public
+ * core-MM-facing API below. The napot bit is a private implementation detail
+ * of those public helpers. Callers that need direct access to the underlying
+ * PTE encoding must use the low-level __* helpers instead.
+ */
+void __napotpte_try_fold(struct mm_struct *mm, unsigned long addr,
+			 pte_t *ptep, pte_t pte);
+void __napotpte_try_unfold(struct mm_struct *mm, unsigned long addr,
+			   pte_t *ptep, pte_t pte);
+pte_t napotpte_ptep_get(pte_t *ptep, pte_t orig_pte);
+pte_t napotpte_ptep_get_lockless(pte_t *ptep);
+void napotpte_set_ptes(struct mm_struct *mm, unsigned long addr,
+		       pte_t *ptep, pte_t pte, unsigned int nr);
+void napotpte_clear_young_dirty_ptes(struct vm_area_struct *vma,
+				     unsigned long addr, pte_t *ptep,
+			     unsigned int nr, cydp_t flags);
+bool napotpte_ptep_set_access_flags(struct vm_area_struct *vma,
+				    unsigned long address, pte_t *ptep,
+			    pte_t entry, int dirty);
+bool napotpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
+					unsigned long address, pte_t *ptep);
+bool napotpte_ptep_clear_flush_young(struct vm_area_struct *vma,
+				     unsigned long address, pte_t *ptep);
+
+static __always_inline bool riscv_pte_present_napot(pte_t pte)
+{
+	return riscv_has_extension_unlikely(RISCV_ISA_EXT_SVNAPOT) &&
+	       pte_present_napot(pte);
+}
+
+static __always_inline void
+napotpte_try_fold(struct mm_struct *mm, unsigned long addr, pte_t *ptep,
+		  pte_t pte)
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
+static __always_inline void
+napotpte_try_unfold(struct mm_struct *mm, unsigned long addr, pte_t *ptep,
+		    pte_t pte)
+{
+	if (unlikely(pte_present_napot(pte)))
+		__napotpte_try_unfold(mm, addr, ptep, pte);
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
+static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
+				       unsigned long address, pte_t *ptep)
+{
+	napotpte_try_unfold(mm, address, ptep, __ptep_get(ptep));
+
+	return __ptep_get_and_clear(mm, address, ptep);
+}
+
+#define clear_young_dirty_ptes clear_young_dirty_ptes
+static inline void clear_young_dirty_ptes(struct vm_area_struct *vma,
+					  unsigned long addr, pte_t *ptep,
+				  unsigned int nr, cydp_t flags)
+{
+	napotpte_clear_young_dirty_ptes(vma, addr, ptep, nr, flags);
+}
+
+#define __HAVE_ARCH_PTEP_SET_WRPROTECT
+static inline void ptep_set_wrprotect(struct mm_struct *mm,
+				      unsigned long address, pte_t *ptep)
+{
+	__ptep_set_wrprotect(mm, address, ptep);
 }
 
+#define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
+static inline bool ptep_clear_flush_young(struct vm_area_struct *vma,
+					  unsigned long address, pte_t *ptep)
+{
+	pte_t orig_pte = __ptep_get(ptep);
+
+	if (likely(!riscv_pte_present_napot(orig_pte)))
+		return __ptep_clear_flush_young(vma, address, ptep);
+
+	return napotpte_ptep_clear_flush_young(vma, address, ptep);
+}
+
+#else /* CONFIG_RISCV_ISA_SVNAPOT */
+
+static __always_inline bool riscv_pte_present_napot(pte_t pte)
+{
+	return false;
+}
+
+static inline bool napotpte_ptep_set_access_flags(struct vm_area_struct *vma,
+						  unsigned long address,
+					  pte_t *ptep, pte_t entry,
+					  int dirty)
+{
+	return false;
+}
+
+static inline bool
+napotpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
+				   unsigned long address,
+					   pte_t *ptep)
+{
+	return false;
+}
+
+static inline bool
+napotpte_ptep_clear_flush_young(struct vm_area_struct *vma,
+				unsigned long address,
+					pte_t *ptep)
+{
+	return false;
+}
+
+#define set_ptes				__set_ptes
+#define pte_clear				__pte_clear
+#define ptep_get				__ptep_get
+#define ptep_get_lockless			__ptep_get_lockless
+#define ptep_get_and_clear			__ptep_get_and_clear
+#define clear_young_dirty_ptes			__clear_young_dirty_ptes
+#define __HAVE_ARCH_PTEP_SET_WRPROTECT
+#define ptep_set_wrprotect			__ptep_set_wrprotect
+#define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
+#define ptep_clear_flush_young			__ptep_clear_flush_young
+
+#endif /* CONFIG_RISCV_ISA_SVNAPOT */
+
 #define pgprot_nx pgprot_nx
 static inline pgprot_t pgprot_nx(pgprot_t _prot)
 {
diff --git a/arch/riscv/mm/Makefile b/arch/riscv/mm/Makefile
index b916a68d324ad..5855f923b83ec 100644
--- a/arch/riscv/mm/Makefile
+++ b/arch/riscv/mm/Makefile
@@ -17,6 +17,7 @@ obj-$(CONFIG_MMU) += extable.o fault.o pageattr.o pgtable.o tlbflush.o
 obj-y += cacheflush.o
 obj-y += context.o
 obj-y += pmem.o
+obj-$(CONFIG_RISCV_ISA_SVNAPOT) += contpte.o
 
 obj-$(CONFIG_HUGETLB_PAGE) += hugetlbpage.o
 obj-$(CONFIG_PTDUMP) += ptdump.o
diff --git a/arch/riscv/mm/contpte.c b/arch/riscv/mm/contpte.c
new file mode 100644
index 0000000000000..f73af7d9b099a
--- /dev/null
+++ b/arch/riscv/mm/contpte.c
@@ -0,0 +1,479 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/align.h>
+#include <linux/cpufeature.h>
+#include <linux/efi.h>
+#include <linux/export.h>
+#include <linux/mm.h>
+#include <linux/mm_types.h>
+#include <linux/page_table_check.h>
+#include <linux/pgtable.h>
+
+#include <asm/tlbflush.h>
+
+static inline bool napot_hw_supported(void)
+{
+	return riscv_has_extension_unlikely(RISCV_ISA_EXT_SVNAPOT);
+}
+
+static inline bool mm_is_user(struct mm_struct *mm)
+{
+	if (unlikely(mm_is_efi(mm)))
+		return false;
+
+	return mm != &init_mm;
+}
+
+static inline unsigned int napotpte_order(void)
+{
+	return NAPOT_CONT64KB_ORDER;
+}
+
+static inline unsigned long napotpte_size(void)
+{
+	return napot_cont_size(napotpte_order());
+}
+
+static inline unsigned int napotpte_pte_num(void)
+{
+	return napot_pte_num(napotpte_order());
+}
+
+static inline unsigned long napotpte_mask(void)
+{
+	return napotpte_size() - 1;
+}
+
+static inline unsigned long napot_align_addr(unsigned long addr)
+{
+	return ALIGN_DOWN(addr, napotpte_size());
+}
+
+static inline pte_t *napot_align_ptep(pte_t *ptep)
+{
+	return PTR_ALIGN_DOWN(ptep, napotpte_pte_num() * sizeof(*ptep));
+}
+
+static inline pte_t pte_mask_ad(pte_t pte)
+{
+	return pte_mkold(pte_mkclean(pte));
+}
+
+static inline unsigned long pte_protval_no_pfn_no_napot(pte_t pte)
+{
+	return (pte_val(pte) & ~_PAGE_PFN_MASK) & ~_PAGE_NAPOT;
+}
+
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
+static inline pte_t napotpte_subpte(pte_t *ptep, pte_t pte)
+{
+	unsigned long pfn;
+	pgprot_t prot;
+
+	if (!pte_present_napot(pte))
+		return pte;
+
+	pfn = pte_pfn(pte) + (ptep - napot_align_ptep(ptep));
+	prot = __pgprot(pte_protval_no_pfn_no_napot(pte));
+
+	return pfn_pte(pfn, prot);
+}
+
+static inline pte_t
+__napot_ptep_get_and_clear(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
+{
+	pte_t pte;
+
+	pte = __pte(atomic_long_xchg((atomic_long_t *)ptep, 0));
+	page_table_check_pte_clear(mm, addr, pte);
+
+	return pte;
+}
+
+static void napotpte_convert(struct mm_struct *mm, unsigned long addr,
+			     pte_t *ptep, pte_t target)
+{
+	unsigned long start_addr, end;
+	pte_t *start_ptep;
+	pte_t ptent, pte;
+	unsigned int i, nr;
+
+	start_addr = napot_align_addr(addr);
+	start_ptep = napot_align_ptep(ptep);
+	nr = napotpte_pte_num();
+	end = start_addr + napotpte_size();
+
+	for (i = 0; i < nr; i++) {
+		ptent = __napot_ptep_get_and_clear(mm, start_addr + i * PAGE_SIZE,
+						   start_ptep + i);
+		if (pte_dirty(ptent))
+			target = pte_mkdirty(target);
+		if (pte_young(ptent))
+			target = pte_mkyoung(target);
+	}
+
+	flush_tlb_mm_range(mm, start_addr, end, PAGE_SIZE);
+
+	page_table_check_ptes_set(mm, start_addr, start_ptep, target, nr);
+	if (pte_napot(target)) {
+		for (i = 0; i < nr; i++)
+			__set_pte_at(mm, start_ptep + i, target);
+		return;
+	}
+
+	for (i = 0; i < nr; i++) {
+		pte = pfn_pte(pte_pfn(target) + i,
+			      __pgprot(pte_protval_no_pfn_no_napot(target)));
+		if (pte_dirty(target))
+			pte = pte_mkdirty(pte);
+		if (pte_young(target))
+			pte = pte_mkyoung(pte);
+		__set_pte_at(mm, start_ptep + i, pte);
+	}
+}
+
+static inline bool napotpte_is_consistent(pte_t pte, pte_t orig_pte)
+{
+	return pte_present_napot(pte) &&
+	       pte_val(pte_mask_ad(pte)) == pte_val(pte_mask_ad(orig_pte));
+}
+
+void __napotpte_try_fold(struct mm_struct *mm, unsigned long addr,
+			 pte_t *ptep, pte_t pte)
+{
+	struct page *page;
+	struct folio *folio;
+	unsigned long folio_start, folio_end;
+	unsigned long cont_start, cont_end;
+	unsigned long pfn;
+	pgprot_t prot;
+	pte_t expected, cur;
+	pte_t *start;
+	unsigned int i, nr;
+
+	if (!napot_hw_supported() || !mm_is_user(mm))
+		return;
+
+	if (!pte_present(pte) || pte_napot(pte) || pte_special(pte))
+		return;
+
+	page = pte_page(pte);
+	folio = page_folio(page);
+	folio_start = addr - (page - &folio->page) * PAGE_SIZE;
+	folio_end = folio_start + folio_nr_pages(folio) * PAGE_SIZE;
+	cont_start = napot_align_addr(addr);
+	cont_end = cont_start + napotpte_size();
+	if (folio_start > cont_start || folio_end < cont_end)
+		return;
+
+	nr = napotpte_pte_num();
+	start = napot_align_ptep(ptep);
+
+	pfn = ALIGN_DOWN(pte_pfn(pte), nr);
+	prot = pte_pgprot(pte_mask_ad(pte));
+	expected = pfn_pte(pfn, prot);
+
+	for (i = 0; i < nr; i++) {
+		cur = READ_ONCE(start[i]);
+		if (pte_val(pte_mask_ad(cur)) != pte_val(expected))
+			return;
+		pte_val(expected) += 1UL << _PAGE_PFN_SHIFT;
+	}
+
+	expected = pte_mknapot(pfn_pte(pfn, prot), napotpte_order());
+	napotpte_convert(mm, addr, ptep, expected);
+}
+EXPORT_SYMBOL(__napotpte_try_fold);
+
+void __napotpte_try_unfold(struct mm_struct *mm, unsigned long addr,
+			   pte_t *ptep, pte_t pte)
+{
+	pte_t target;
+	pgprot_t prot;
+
+	if (!napot_hw_supported() || !mm_is_user(mm))
+		return;
+
+	prot = __pgprot(pte_protval_no_pfn_no_napot(pte));
+	target = pfn_pte(pte_pfn(pte), prot);
+
+	napotpte_convert(mm, addr, ptep, target);
+}
+EXPORT_SYMBOL(__napotpte_try_unfold);
+
+pte_t napotpte_ptep_get(pte_t *ptep, pte_t orig_pte)
+{
+	pte_t pte, cur;
+	pte_t *start;
+	unsigned int i, nr;
+
+	if (!napot_hw_supported() || !pte_present_napot(orig_pte))
+		return orig_pte;
+
+	pte = orig_pte;
+	start = napot_align_ptep(ptep);
+	nr = napotpte_pte_num();
+
+	for (i = 0; i < nr; i++) {
+		cur = READ_ONCE(start[i]);
+		if (!napotpte_is_consistent(cur, orig_pte))
+			return napotpte_subpte(ptep, orig_pte);
+		if (pte_dirty(cur))
+			pte = pte_mkdirty(pte);
+		if (pte_young(cur))
+			pte = pte_mkyoung(pte);
+	}
+
+	return napotpte_subpte(ptep, pte);
+}
+EXPORT_SYMBOL(napotpte_ptep_get);
+
+pte_t napotpte_ptep_get_lockless(pte_t *orig_ptep)
+{
+	pte_t orig_pte, pte;
+	pte_t *ptep;
+	unsigned int i, nr;
+
+	if (!napot_hw_supported())
+		return READ_ONCE(*orig_ptep);
+
+	nr = napotpte_pte_num();
+
+retry:
+	orig_pte = READ_ONCE(*orig_ptep);
+	if (!pte_present_napot(orig_pte))
+		return orig_pte;
+
+	ptep = napot_align_ptep(orig_ptep);
+
+	for (i = 0; i < nr; i++, ptep++) {
+		pte = READ_ONCE(*ptep);
+
+		if (!napotpte_is_consistent(pte, orig_pte))
+			goto retry;
+
+		if (pte_dirty(pte)) {
+			orig_pte = pte_mkdirty(orig_pte);
+			for (; i < nr; i++, ptep++) {
+				pte = READ_ONCE(*ptep);
+
+				if (!napotpte_is_consistent(pte, orig_pte))
+					goto retry;
+
+				if (pte_young(pte)) {
+					orig_pte = pte_mkyoung(orig_pte);
+					break;
+				}
+			}
+			break;
+		}
+
+		if (pte_young(pte)) {
+			orig_pte = pte_mkyoung(orig_pte);
+			i++;
+			ptep++;
+			for (; i < nr; i++, ptep++) {
+				pte = READ_ONCE(*ptep);
+
+				if (!napotpte_is_consistent(pte, orig_pte))
+					goto retry;
+
+				if (pte_dirty(pte)) {
+					orig_pte = pte_mkdirty(orig_pte);
+					break;
+				}
+			}
+			break;
+		}
+	}
+
+	return napotpte_subpte(orig_ptep, orig_pte);
+}
+EXPORT_SYMBOL(napotpte_ptep_get_lockless);
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
+		boundary = (addr + size) & ~napotpte_mask();
+		next = (boundary - 1 < end - 1) ? boundary : end;
+		chunk = (next - addr) >> PAGE_SHIFT;
+
+		cur = pfn_pte(pfn, prot);
+		if (((addr | next | (pfn << PAGE_SHIFT)) & napotpte_mask()) == 0) {
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
+		for (;;) {
+			if (flags == CYDP_CLEAR_YOUNG)
+				__ptep_test_and_clear_young(vma, addr, ptep);
+			else
+				napotpte_clear_young_dirty_pte(ptep, flags);
+			if (--nr == 0)
+				break;
+			ptep++;
+			addr += PAGE_SIZE;
+		}
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
+bool napotpte_ptep_set_access_flags(struct vm_area_struct *vma,
+				    unsigned long address, pte_t *ptep,
+				    pte_t entry, int dirty)
+{
+	pte_t orig_pte, raw_pte, napot_pte;
+	pte_t *start;
+	pgprot_t prot;
+	unsigned long start_addr;
+	unsigned int i, nr;
+	bool changed;
+
+	raw_pte = READ_ONCE(*ptep);
+	if (!napot_hw_supported() || !pte_present_napot(raw_pte))
+		return false;
+
+	orig_pte = ptep_get(ptep);
+	if (pte_val(orig_pte) == pte_val(entry))
+		return false;
+
+	if (pte_write(orig_pte) != pte_write(entry)) {
+		__napotpte_try_unfold(vma->vm_mm, address, ptep, raw_pte);
+		entry = pte_mknonnapot(entry, address);
+
+		return ptep_set_access_flags(vma, address, ptep, entry, dirty);
+	}
+
+	prot = pte_pgprot(entry);
+	napot_pte = pfn_pte(pte_pfn(raw_pte), prot);
+	napot_pte = pte_mknapot(napot_pte, napotpte_order());
+
+	start = napot_align_ptep(ptep);
+	start_addr = napot_align_addr(address);
+	nr = napotpte_pte_num();
+	changed = false;
+
+	page_table_check_ptes_set(vma->vm_mm, start_addr, start, napot_pte, nr);
+	for (i = 0; i < nr; i++) {
+		if (!pte_same(READ_ONCE(start[i]), napot_pte)) {
+			__set_pte_at(vma->vm_mm, start + i, napot_pte);
+			changed = true;
+		}
+	}
+
+	if (changed)
+		flush_tlb_range(vma, start_addr, start_addr + napotpte_size());
+
+	return changed;
+}
+EXPORT_SYMBOL(napotpte_ptep_set_access_flags);
+
+bool napotpte_ptep_test_and_clear_young(struct vm_area_struct *vma,
+					unsigned long address, pte_t *ptep)
+{
+	pte_t *start;
+	unsigned int i, nr;
+	bool young;
+
+	if (!napot_hw_supported() || !pte_present_napot(READ_ONCE(*ptep)))
+		return false;
+
+	start = napot_align_ptep(ptep);
+	nr = napotpte_pte_num();
+	young = false;
+
+	for (i = 0; i < nr; i++)
+		young |= test_and_clear_bit(_PAGE_ACCESSED_OFFSET,
+					   &pte_val(start[i]));
+
+	return young;
+}
+EXPORT_SYMBOL(napotpte_ptep_test_and_clear_young);
+
+bool napotpte_ptep_clear_flush_young(struct vm_area_struct *vma,
+				     unsigned long address, pte_t *ptep)
+{
+	unsigned long start_addr;
+	bool young;
+
+	young = napotpte_ptep_test_and_clear_young(vma, address, ptep);
+	if (!young)
+		return false;
+
+	start_addr = napot_align_addr(address);
+	flush_tlb_range(vma, start_addr, start_addr + napotpte_size());
+
+	return true;
+}
+EXPORT_SYMBOL(napotpte_ptep_clear_flush_young);
diff --git a/arch/riscv/mm/pgtable.c b/arch/riscv/mm/pgtable.c
index 9131a78fe15c4..85ff49286f91c 100644
--- a/arch/riscv/mm/pgtable.c
+++ b/arch/riscv/mm/pgtable.c
@@ -9,6 +9,14 @@ int ptep_set_access_flags(struct vm_area_struct *vma,
 			  unsigned long address, pte_t *ptep,
 			  pte_t entry, int dirty)
 {
+	pte_t raw_pte;
+
+	entry = pte_mknonnapot(entry, address);
+	raw_pte = READ_ONCE(*ptep);
+	if (riscv_pte_present_napot(raw_pte))
+		return napotpte_ptep_set_access_flags(vma, address, ptep, entry,
+					      dirty);
+
 	return __ptep_set_access_flags(vma, address, ptep, entry, dirty);
 }
 
@@ -16,19 +24,26 @@ int __ptep_set_access_flags(struct vm_area_struct *vma,
 			    unsigned long address, pte_t *ptep,
 			    pte_t entry, int dirty)
 {
-	if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SVVPTC)) {
-		if (!pte_same(ptep_get(ptep), entry)) {
-			__set_pte_at(vma->vm_mm, ptep, entry);
-			/* Here only not svadu is impacted */
-			flush_tlb_page(vma, address);
-			return true;
-		}
+	pte_t raw_pte;
+	bool changed;
+
+	entry = pte_mknonnapot(entry, address);
+	raw_pte = READ_ONCE(*ptep);
+	if (riscv_pte_present_napot(raw_pte))
+		return false;
 
+	changed = !pte_same(raw_pte, entry);
+	if (!changed)
 		return false;
+
+	__set_pte_at(vma->vm_mm, ptep, entry);
+
+	if (riscv_has_extension_unlikely(RISCV_ISA_EXT_SVVPTC)) {
+		/* Here only not svadu is impacted */
+		flush_tlb_page(vma, address);
+		return true;
 	}
 
-	if (!pte_same(ptep_get(ptep), entry))
-		__set_pte_at(vma->vm_mm, ptep, entry);
 	/*
 	 * update_mmu_cache will unconditionally execute, handling both
 	 * the case that the PTE changed and the spurious fault case.
@@ -39,6 +54,12 @@ int __ptep_set_access_flags(struct vm_area_struct *vma,
 bool ptep_test_and_clear_young(struct vm_area_struct *vma,
 		unsigned long address, pte_t *ptep)
 {
+	pte_t raw_pte;
+
+	raw_pte = READ_ONCE(*ptep);
+	if (riscv_pte_present_napot(raw_pte))
+		return napotpte_ptep_test_and_clear_young(vma, address, ptep);
+
 	return __ptep_test_and_clear_young(vma, address, ptep);
 }
 EXPORT_SYMBOL_GPL(ptep_test_and_clear_young);
-- 
2.39.5

