Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AF0847D94A;
	Tue, 14 Jul 2026 14:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784037950; cv=none; b=DL8HvfDTPbwlj/dH2suYPPcK20odRlERNQ+Xc0KZ+nx73Be18y6IT3Ky7B3vTxDJ3rbC700K1ZKv93uoxcXKZ9HvqSGAYkNI+Xp4BSYEAIN1lORrkBKqUVN964p1YntzX66OqfSs86HE5lIZ9UjmKnIrvXsbY9TAwL6pme/VB38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784037950; c=relaxed/simple;
	bh=81hPHNKy6+kTl2+35lvgI+YoSAV+lxYrdESi+BeMQ9o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=npEW+pV2IU0SXV6dosu5XNEj394Zz+4vIVdjOgucGbPL0X5AcbiV1qz41hPjOittBwc6HDIlmn++NoghDa3ZdnIkGnuaglgABAx8E49eIUvF//6UQWhj6DRO+2AQlr4J3XSXsxUDpOa1milepqM1Vch8uZu3LRTwuOUR400z3oQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=J3x7thz6; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="J3x7thz6"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8D4221570;
	Tue, 14 Jul 2026 07:05:44 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 656AE3F7B4;
	Tue, 14 Jul 2026 07:05:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784037948; bh=81hPHNKy6+kTl2+35lvgI+YoSAV+lxYrdESi+BeMQ9o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=J3x7thz6DDIFd0T672gJo0MMnvLqrsR4ffqXjRuw6y/FJl0Sv4brx2AvsrenCXyub
	 hNeHOpm1dGW6Ol7r4E98ejCd2H2xHFjmSYxf0TFC/EKx6I3nhvG3tmBb0uG3LlhJwX
	 CsqR3L3Byysgiom9B50gJLtZIUOotRrLJXVN3jH4=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 14 Jul 2026 15:03:54 +0100
Subject: [PATCH 05/22] arm64: mm: use mm_is_kernel() for kernel mm checks
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-remove_pgtable_cdtor-v1-5-44be8a7685d7@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784037902; l=3632;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=81hPHNKy6+kTl2+35lvgI+YoSAV+lxYrdESi+BeMQ9o=;
 b=x1sfUWl36JCNbyA4SXGcEWPKjJ2W9GBoHx+AU6SimhVKBjyOGOssy6XRkSm07LMGEZVJbSnP4
 NXfCyMO7l0VD8qsDQe1L21uTIP7w+5/eot3+ExiUATLVcbhzhw7kG6L
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=

The new MMF_KERNEL flag identifies kernel-owned mm's. Checking the
flag with mm_is_kernel() is preferred over comparing directly
against &init_mm.

In some cases, such as show_pte(), the handling is truly specific to
init_mm and we leave those comparisons with &init_mm unchanged.

No functional change, as only init_mm has MMF_KERNEL set for now.

mm_is_user() will eventually be replaced with !mm_is_kernel(), once
efi_mm is also marked with MMF_KERNEL.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/include/asm/pgalloc.h | 10 +++++-----
 arch/arm64/mm/contpte.c          |  2 +-
 arch/arm64/mm/hugetlbpage.c      |  2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/pgalloc.h b/arch/arm64/include/asm/pgalloc.h
index 1b4509d3382c..33db4fa3c619 100644
--- a/arch/arm64/include/asm/pgalloc.h
+++ b/arch/arm64/include/asm/pgalloc.h
@@ -30,7 +30,7 @@ static inline void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmdp)
 {
 	pudval_t pudval = PUD_TYPE_TABLE | PUD_TABLE_AF;
 
-	pudval |= (mm == &init_mm) ? PUD_TABLE_UXN : PUD_TABLE_PXN;
+	pudval |= mm_is_kernel(mm) ? PUD_TABLE_UXN : PUD_TABLE_PXN;
 	__pud_populate(pudp, __pa(pmdp), pudval);
 }
 #else
@@ -52,7 +52,7 @@ static inline void p4d_populate(struct mm_struct *mm, p4d_t *p4dp, pud_t *pudp)
 {
 	p4dval_t p4dval = P4D_TYPE_TABLE | P4D_TABLE_AF;
 
-	p4dval |= (mm == &init_mm) ? P4D_TABLE_UXN : P4D_TABLE_PXN;
+	p4dval |= mm_is_kernel(mm) ? P4D_TABLE_UXN : P4D_TABLE_PXN;
 	__p4d_populate(p4dp, __pa(pudp), p4dval);
 }
 
@@ -81,7 +81,7 @@ static inline void pgd_populate(struct mm_struct *mm, pgd_t *pgdp, p4d_t *p4dp)
 {
 	pgdval_t pgdval = PGD_TYPE_TABLE | PGD_TABLE_AF;
 
-	pgdval |= (mm == &init_mm) ? PGD_TABLE_UXN : PGD_TABLE_PXN;
+	pgdval |= mm_is_kernel(mm) ? PGD_TABLE_UXN : PGD_TABLE_PXN;
 	__pgd_populate(pgdp, __pa(p4dp), pgdval);
 }
 
@@ -108,7 +108,7 @@ static inline void __pmd_populate(pmd_t *pmdp, phys_addr_t ptep,
 static inline void
 pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmdp, pte_t *ptep)
 {
-	VM_BUG_ON(mm && mm != &init_mm);
+	VM_BUG_ON(mm && !mm_is_kernel(mm));
 	__pmd_populate(pmdp, __pa(ptep),
 		       PMD_TYPE_TABLE | PMD_TABLE_AF | PMD_TABLE_UXN);
 }
@@ -116,7 +116,7 @@ pmd_populate_kernel(struct mm_struct *mm, pmd_t *pmdp, pte_t *ptep)
 static inline void
 pmd_populate(struct mm_struct *mm, pmd_t *pmdp, pgtable_t ptep)
 {
-	VM_BUG_ON(mm == &init_mm);
+	VM_BUG_ON(mm_is_kernel(mm));
 	__pmd_populate(pmdp, page_to_phys(ptep),
 		       PMD_TYPE_TABLE | PMD_TABLE_AF | PMD_TABLE_PXN);
 }
diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
index 2de12656b4d8..ad5c04cf66ff 100644
--- a/arch/arm64/mm/contpte.c
+++ b/arch/arm64/mm/contpte.c
@@ -18,7 +18,7 @@ static inline bool mm_is_user(struct mm_struct *mm)
 	 */
 	if (unlikely(mm_is_efi(mm)))
 		return false;
-	return mm != &init_mm;
+	return !mm_is_kernel(mm);
 }
 
 static inline pte_t *contpte_align_down(pte_t *ptep)
diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index 25f04d01aabe..4d054fadf51c 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -212,7 +212,7 @@ static void clear_flush(struct mm_struct *mm,
 	for (i = 0; i < ncontig; i++, addr += pgsize, ptep++)
 		__ptep_get_and_clear_anysz(mm, addr, ptep, pgsize);
 
-	if (mm == &init_mm)
+	if (mm_is_kernel(mm))
 		flush_tlb_kernel_range(saddr, addr);
 	else
 		__flush_hugetlb_tlb_range(&vma, saddr, addr, pgsize, TLBF_NOWALKCACHE);

-- 
2.51.2

