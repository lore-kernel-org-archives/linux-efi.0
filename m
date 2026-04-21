Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEF13A1A59
	for <linux-efi@vger.kernel.org>; Tue, 21 Apr 2026 09:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776763550; cv=none; b=K+fJtCcLKeBb7MhBg4swJXwxXFz0gBJnELDBYcdhDWnNfJSklm57HRdkmiylFHv0dl9nLBG9M8thKByjm/Gf9Rvws07WbIAF8n15Zu7BtDFNZoyFVb1d0yWAafZ2tKUyq26NfLps3VqSwuktY7RVuKgP002MKI8hlLEm1C+SmAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776763550; c=relaxed/simple;
	bh=85CI3Uesj7nk7m45yHMK35fkc3qMQwMDld+L1RWxK1c=;
	h=From:To:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GN2OlVJj6E8M3pjJ5S2yhceEHnyuDQCScBTCydAOfhWJ8y6C643rbIM+EKJSVFgrDrJdbes7QTYyx59IAgjaokZf8Xk6wHEcjD49Uqok2Q8KCn5C8lcXWyyTZdgOqjhgG96pE+5UCPRualE1rdil2GXFZM7kpcIiFAPJG7w9ynA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=LMntBeNG; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="LMntBeNG"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-35d971fb6f1so3139447a91.0
        for <linux-efi@vger.kernel.org>; Tue, 21 Apr 2026 02:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776763548; x=1777368348; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pTjwhKG7KzQh08aYS/X3NKGI2n2kHnjJW0npzktt0MY=;
        b=LMntBeNG1+gCYXxuv22qJqBRUnyPqe4UeMy/Sq3QEawnuI+pF6SnMj0YoGSKrrNp4D
         VDZv2DszFs9p+P39PBZw7iNE/oPrMbdbrGT5m9kycc2sGQw5NX9prxkdU41PX81b6e63
         Y/E4/rqLb0RgfPYBAbEKXMtixh3L4aBAOBrxyO9XBDUk/kXG3YyfKp/4VDBfF7e0UWb1
         ZRTXIhyS8Ctf+ysGvUy/nejzBwAKEmua4TfedatnzX0jKAcOlx2Pi3oAqkhJqxXkl4Xo
         vC0rEvCXMn1+BOdgeuu5K7jF5KusgL96jroPp5A5C4MWcekqA5UUfDrXrxrICCFEfdiK
         qRnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776763548; x=1777368348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pTjwhKG7KzQh08aYS/X3NKGI2n2kHnjJW0npzktt0MY=;
        b=S8wdbl8AblSt8aqJGhGfBKcSltRbGZaQHkcyG2SEC18BLEWEZh7rA9d4GINUKLyRU9
         67u3Qf4sQPmatFgidIDXlezgdmkrQUiT8lsx7IqMvqNExgoMG7/sH/c9XH5dVqUx7nkQ
         /iHD+iknDKQ3d20MjzuQ9ZX3zE0YqRYQyyYobM6S84v/hJM/+FtpOyvI5d5gU2egPeWC
         PrDUqc4LZPvvuOigp8iRhvt450oVDIAtQwcCUFkN+YnmoYFDny5ShBgKuudamoJcHtqk
         tY2hM5lGGw033u20ToLzH2c3eT7I7E3oFkPZrxfiK33+/acoSEqOz8zYNuZ8HvEa5g6l
         7zyQ==
X-Forwarded-Encrypted: i=1; AFNElJ9hKpjnJbQa0QsviTLCfBBzZfR1XGOCMZPkoPL4uRV3TOP6VE7Wq1nl/dPKGw2jgAjBPObK1PMKDcI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgVsnurxReowKu8gRywLJTb/dJPct44dt7/U1swDg3Tbe8MuTk
	psAJiPovArdmXk+E60gDn8uSzYrn7T2HWhqES1U8fRkt4+1h/BregEMWxdbTP2dfcF8=
X-Gm-Gg: AeBDievQmt46NuoeKPhPgXOBRnMvsM0e4SNgfl3TQ8zzBUVLodytvLT3z47I17G1FD+
	55HGXW4X/+EUYozUmb7JUism4NDsj4b/Pe5y0mCNL1pVVAlT+8jrp4C3halhRdWjdxBRgq6FOKn
	NA9I5tBaGHz0POEnkwFAdjYKUOhvcneJLOqVO2FQvqb2flFgldpG5tWAwtQWoBbllPJyQnpq6/q
	Nb9eYo9jpKM64YZnszuEKmd4KwfZcRxGLOThH9F1KuM1h/yn/opyblQ/2VFncAH+keK3e9JchY0
	OTaS7/H/t8rQDcGHJNN1FtttWuYSMjf72mwL879v8NcFyPjhQO+fAi8DX/VHa38d+E1N8OQng49
	CZMyA3IMTR56cWrUDyKv1ZzntWJRloRPKV/rCMo9+WqR7UHw3E4V2EY8zJivvv4iQgrnH2ioo0G
	w77tBBNM6tgSQESoo7LiBBS7KsU2bby58ds86vZNHTZyky91KjM99F/G0kmKvwCMiiO2gY
X-Received: by 2002:a17:90b:2dc1:b0:35e:30bc:96e2 with SMTP id 98e67ed59e1d1-361403f1901mr17724201a91.10.1776763547742;
        Tue, 21 Apr 2026 02:25:47 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([61.213.176.6])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fa9ff39csm131965105ad.4.2026.04.21.02.25.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 21 Apr 2026 02:25:47 -0700 (PDT)
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
Subject: [PATCH 4/7] riscv: hugetlb: switch NAPOT mappings to raw PTE helpers
Date: Tue, 21 Apr 2026 17:24:54 +0800
Message-Id: <20260421092457.37649-5-cuiyunhui@bytedance.com>
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

Use raw PTE helpers in hugetlb code to operate directly on the
underlying PTE entries. This lets hugetlb manage NAPOT
folding/unfolding explicitly instead of going through Svnapot-aware
public wrappers.

Add explicit NAPOT unfolding in set_huge_pte_at() before replacing an
existing NAPOT mapping with non-NAPOT entries.

No functional change intended.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/mm/hugetlbpage.c | 55 +++++++++++++++++++++++--------------
 1 file changed, 35 insertions(+), 20 deletions(-)

diff --git a/arch/riscv/mm/hugetlbpage.c b/arch/riscv/mm/hugetlbpage.c
index a6d217112cf46..65a89b4fdad8b 100644
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
@@ -15,7 +15,7 @@ pte_t huge_ptep_get(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
 	pte_num = napot_pte_num(napot_cont_order(orig_pte));
 
 	for (i = 0; i < pte_num; i++, ptep++) {
-		pte_t pte = ptep_get(ptep);
+		pte_t pte = __ptep_get(ptep);
 
 		if (pte_dirty(pte))
 			orig_pte = pte_mkdirty(orig_pte);
@@ -74,7 +74,7 @@ pte_t *huge_pte_alloc(struct mm_struct *mm,
 
 out:
 	if (pte) {
-		pte_t pteval = ptep_get_lockless(pte);
+		pte_t pteval = __ptep_get_lockless(pte);
 
 		WARN_ON_ONCE(pte_present(pteval) && !pte_huge(pteval));
 	}
@@ -153,12 +153,12 @@ static pte_t get_clear_contig(struct mm_struct *mm,
 	pte_t pte, tmp_pte;
 	bool present;
 
-	pte = ptep_get_and_clear(mm, addr, ptep);
+	pte = __ptep_get_and_clear(mm, addr, ptep);
 	present = pte_present(pte);
 	while (--ncontig) {
 		ptep++;
 		addr += PAGE_SIZE;
-		tmp_pte = ptep_get_and_clear(mm, addr, ptep);
+		tmp_pte = __ptep_get_and_clear(mm, addr, ptep);
 		if (present) {
 			if (pte_dirty(tmp_pte))
 				pte = pte_mkdirty(pte);
@@ -210,7 +210,7 @@ static void clear_flush(struct mm_struct *mm,
 	unsigned long i, saddr = addr;
 
 	for (i = 0; i < ncontig; i++, addr += pgsize, ptep++)
-		ptep_get_and_clear(mm, addr, ptep);
+		__ptep_get_and_clear(mm, addr, ptep);
 
 	flush_tlb_range(&vma, saddr, addr);
 }
@@ -250,25 +250,40 @@ void set_huge_pte_at(struct mm_struct *mm,
 		     unsigned long sz)
 {
 	size_t pgsize;
+	pte_t orig_pte;
+	pte_t pteval;
 	int i, pte_num;
 
 	pte_num = num_contig_ptes_from_size(sz, &pgsize);
 
 	if (!pte_present(pte)) {
-		for (i = 0; i < pte_num; i++, ptep++, addr += pgsize)
-			set_ptes(mm, addr, ptep, pte, 1);
+		for (i = 0; i < pte_num; i++, ptep++, addr += pgsize) {
+			pteval = pte_mknonnapot(pte, addr);
+			orig_pte = __ptep_get(ptep);
+
+			if (pte_present_napot(orig_pte))
+				__napotpte_try_unfold(mm, addr, ptep, orig_pte);
+
+			__set_ptes(mm, addr, ptep, pteval, 1);
+		}
 		return;
 	}
 
 	if (!pte_napot(pte)) {
-		set_ptes(mm, addr, ptep, pte, 1);
+		pteval = pte_mknonnapot(pte, addr);
+		orig_pte = __ptep_get(ptep);
+
+		if (pte_present_napot(orig_pte))
+			__napotpte_try_unfold(mm, addr, ptep, orig_pte);
+
+		__set_ptes(mm, addr, ptep, pteval, 1);
 		return;
 	}
 
 	clear_flush(mm, addr, ptep, pgsize, pte_num);
 
 	for (i = 0; i < pte_num; i++, ptep++, addr += pgsize)
-		set_pte_at(mm, addr, ptep, pte);
+		__set_ptes(mm, addr, ptep, pte, 1);
 }
 
 int huge_ptep_set_access_flags(struct vm_area_struct *vma,
@@ -283,7 +298,7 @@ int huge_ptep_set_access_flags(struct vm_area_struct *vma,
 	int i, pte_num;
 
 	if (!pte_napot(pte))
-		return ptep_set_access_flags(vma, addr, ptep, pte, dirty);
+		return __ptep_set_access_flags(vma, addr, ptep, pte, dirty);
 
 	order = napot_cont_order(pte);
 	pte_num = napot_pte_num(order);
@@ -307,11 +322,11 @@ pte_t huge_ptep_get_and_clear(struct mm_struct *mm,
 			      pte_t *ptep, unsigned long sz)
 {
 	size_t pgsize;
-	pte_t orig_pte = ptep_get(ptep);
+	pte_t orig_pte = __ptep_get(ptep);
 	int pte_num;
 
 	if (!pte_napot(orig_pte))
-		return ptep_get_and_clear(mm, addr, ptep);
+		return __ptep_get_and_clear(mm, addr, ptep);
 
 	pte_num = num_contig_ptes_from_size(sz, &pgsize);
 
@@ -322,13 +337,13 @@ void huge_ptep_set_wrprotect(struct mm_struct *mm,
 			     unsigned long addr,
 			     pte_t *ptep)
 {
-	pte_t pte = ptep_get(ptep);
+	pte_t pte = __ptep_get(ptep);
 	unsigned long order;
 	pte_t orig_pte;
 	int i, pte_num;
 
 	if (!pte_napot(pte)) {
-		ptep_set_wrprotect(mm, addr, ptep);
+		__ptep_set_wrprotect(mm, addr, ptep);
 		return;
 	}
 
@@ -347,11 +362,11 @@ pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
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
 
@@ -364,18 +379,18 @@ void huge_pte_clear(struct mm_struct *mm,
 		    unsigned long sz)
 {
 	size_t pgsize;
-	pte_t pte = ptep_get(ptep);
+	pte_t pte = __ptep_get(ptep);
 	int i, pte_num;
 
 	if (!pte_napot(pte)) {
-		pte_clear(mm, addr, ptep);
+		__pte_clear(mm, addr, ptep);
 		return;
 	}
 
 	pte_num = num_contig_ptes_from_size(sz, &pgsize);
 
 	for (i = 0; i < pte_num; i++, addr += pgsize, ptep++)
-		pte_clear(mm, addr, ptep);
+		__pte_clear(mm, addr, ptep);
 }
 
 static bool is_napot_size(unsigned long size)
-- 
2.39.5

