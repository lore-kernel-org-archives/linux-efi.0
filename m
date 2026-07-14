Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B20B43F8AF;
	Tue, 14 Jul 2026 14:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784037943; cv=none; b=U2LZVYzX8NTONM3RVmMYQNPC0l6uhs0s/5BbQ1gsBUrk8QC0hdCynQiAZ+uiVd5nnKvFYMkqJH1t21FR7hq9qJ+8Umzp2jJOY9bKtfcAZlcpJc4r6ZMrsWGOWrX+M/wi4i4s8EzEfC5jwbOdJ97ne4Y50FVBbbUA7WZju6ozDQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784037943; c=relaxed/simple;
	bh=5/MiBpHs0ErPi8rhCKmMSpm6ldHtuokM4yv1ELNR2HE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=n+mCVUpCMgUpnKl1aBQg+DD6lLXdV9ykO0AmAqYvs5SJTo/5/y/aS1Gkrm98iVX+4W3wdabYlNHGpjwZ1YQHpQT/6j9f65IcnagCSS6Zn1+0kyHnt1SF8nyQxxxef11TFzT1hO7a2oiDUc3bpHW3IQlZJqYXsEYhofpHcTZnyfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KYO9cDN7; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KYO9cDN7"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CDF1F1516;
	Tue, 14 Jul 2026 07:05:36 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A8C023F7B4;
	Tue, 14 Jul 2026 07:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784037941; bh=5/MiBpHs0ErPi8rhCKmMSpm6ldHtuokM4yv1ELNR2HE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=KYO9cDN7rDizxe3v/je6cSxNCJeEVFPUnXsSWSe2BPhKaPCn7aqwcwGf5Fv/X2xeM
	 fJX9X0ToA3Vm5csdSfShGsy263erMfQnPGfY2VsiME2prC8a3J844A9rhhh46ZY371
	 B0aQM0b2gjQo2R4Q0Ts/ynPMN9wstMhZsk8mylek=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 14 Jul 2026 15:03:53 +0100
Subject: [PATCH 04/22] mm: use mm_is_kernel() in generic page table code
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-remove_pgtable_cdtor-v1-4-44be8a7685d7@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784037902; l=7589;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=5/MiBpHs0ErPi8rhCKmMSpm6ldHtuokM4yv1ELNR2HE=;
 b=uo2OhW6qUc5pqzt9VsrUNdo1IYgeBBnT6lqfK5Ys8RZJ6rVRF5aIis0fNbkhks1ozPQyi/VUC
 pyQWphyWV1oCOOAp4DOjVmApiSewKKEeH9vCDbxc96BlDrMTGs1NvYU
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=

Generic page-table allocation, constructor and walker code uses
init_mm comparisons to select kernel page table handling. Use
mm_is_kernel() instead so kernel-owned mm's can share that handling
once they are marked with MMF_KERNEL.

No functional change as only init_mm has MMF_KERNEL set for now.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/asm-generic/pgalloc.h | 16 ++++++++--------
 include/linux/mm.h            |  4 ++--
 mm/memory.c                   |  6 +++---
 mm/page_table_check.c         | 14 +++++++-------
 mm/pagewalk.c                 |  4 ++--
 5 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/include/asm-generic/pgalloc.h b/include/asm-generic/pgalloc.h
index 051aa1331051..a283280e3140 100644
--- a/include/asm-generic/pgalloc.h
+++ b/include/asm-generic/pgalloc.h
@@ -138,7 +138,7 @@ static inline pmd_t *pmd_alloc_one_noprof(struct mm_struct *mm, unsigned long ad
 	struct ptdesc *ptdesc;
 	gfp_t gfp = GFP_PGTABLE_USER;
 
-	if (mm == &init_mm)
+	if (mm_is_kernel(mm))
 		gfp = GFP_PGTABLE_KERNEL;
 	ptdesc = pagetable_alloc_noprof(gfp, 0);
 	if (!ptdesc)
@@ -148,7 +148,7 @@ static inline pmd_t *pmd_alloc_one_noprof(struct mm_struct *mm, unsigned long ad
 		return NULL;
 	}
 
-	if (mm == &init_mm)
+	if (mm_is_kernel(mm))
 		ptdesc_set_kernel(ptdesc);
 
 	return ptdesc_address(ptdesc);
@@ -175,7 +175,7 @@ static inline pud_t *__pud_alloc_one_noprof(struct mm_struct *mm, unsigned long
 	gfp_t gfp = GFP_PGTABLE_USER;
 	struct ptdesc *ptdesc;
 
-	if (mm == &init_mm)
+	if (mm_is_kernel(mm))
 		gfp = GFP_PGTABLE_KERNEL;
 
 	ptdesc = pagetable_alloc_noprof(gfp, 0);
@@ -184,7 +184,7 @@ static inline pud_t *__pud_alloc_one_noprof(struct mm_struct *mm, unsigned long
 
 	pagetable_pud_ctor(ptdesc);
 
-	if (mm == &init_mm)
+	if (mm_is_kernel(mm))
 		ptdesc_set_kernel(ptdesc);
 
 	return ptdesc_address(ptdesc);
@@ -232,7 +232,7 @@ static inline p4d_t *__p4d_alloc_one_noprof(struct mm_struct *mm, unsigned long
 	gfp_t gfp = GFP_PGTABLE_USER;
 	struct ptdesc *ptdesc;
 
-	if (mm == &init_mm)
+	if (mm_is_kernel(mm))
 		gfp = GFP_PGTABLE_KERNEL;
 
 	ptdesc = pagetable_alloc_noprof(gfp, 0);
@@ -241,7 +241,7 @@ static inline p4d_t *__p4d_alloc_one_noprof(struct mm_struct *mm, unsigned long
 
 	pagetable_p4d_ctor(ptdesc);
 
-	if (mm == &init_mm)
+	if (mm_is_kernel(mm))
 		ptdesc_set_kernel(ptdesc);
 
 	return ptdesc_address(ptdesc);
@@ -279,7 +279,7 @@ static inline pgd_t *__pgd_alloc_noprof(struct mm_struct *mm, unsigned int order
 	gfp_t gfp = GFP_PGTABLE_USER;
 	struct ptdesc *ptdesc;
 
-	if (mm == &init_mm)
+	if (mm_is_kernel(mm))
 		gfp = GFP_PGTABLE_KERNEL;
 
 	ptdesc = pagetable_alloc_noprof(gfp, order);
@@ -288,7 +288,7 @@ static inline pgd_t *__pgd_alloc_noprof(struct mm_struct *mm, unsigned int order
 
 	pagetable_pgd_ctor(ptdesc);
 
-	if (mm == &init_mm)
+	if (mm_is_kernel(mm))
 		ptdesc_set_kernel(ptdesc);
 
 	return ptdesc_address(ptdesc);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7a4b8e7ac8f4..b336eb32faa0 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3818,7 +3818,7 @@ static inline void pagetable_dtor_free(struct ptdesc *ptdesc)
 static inline bool pagetable_pte_ctor(struct mm_struct *mm,
 				      struct ptdesc *ptdesc)
 {
-	if (mm != &init_mm && !ptlock_init(ptdesc))
+	if (!mm_is_kernel(mm) && !ptlock_init(ptdesc))
 		return false;
 	__pagetable_ctor(ptdesc);
 	return true;
@@ -3909,7 +3909,7 @@ static inline spinlock_t *pmd_lock(struct mm_struct *mm, pmd_t *pmd)
 static inline bool pagetable_pmd_ctor(struct mm_struct *mm,
 				      struct ptdesc *ptdesc)
 {
-	if (mm != &init_mm && !pmd_ptlock_init(ptdesc))
+	if (!mm_is_kernel(mm) && !pmd_ptlock_init(ptdesc))
 		return false;
 	ptdesc_pmd_pts_init(ptdesc);
 	__pagetable_ctor(ptdesc);
diff --git a/mm/memory.c b/mm/memory.c
index d5e87624f692..c0244c0b0756 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3394,13 +3394,13 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 	spinlock_t *ptl;
 
 	if (create) {
-		mapped_pte = pte = (mm == &init_mm) ?
+		mapped_pte = pte = mm_is_kernel(mm) ?
 			pte_alloc_kernel_track(pmd, addr, mask) :
 			pte_alloc_map_lock(mm, pmd, addr, &ptl);
 		if (!pte)
 			return -ENOMEM;
 	} else {
-		mapped_pte = pte = (mm == &init_mm) ?
+		mapped_pte = pte = mm_is_kernel(mm) ?
 			pte_offset_kernel(pmd, addr) :
 			pte_offset_map_lock(mm, pmd, addr, &ptl);
 		if (!pte)
@@ -3422,7 +3422,7 @@ static int apply_to_pte_range(struct mm_struct *mm, pmd_t *pmd,
 
 	lazy_mmu_mode_disable();
 
-	if (mm != &init_mm)
+	if (!mm_is_kernel(mm))
 		pte_unmap_unlock(mapped_pte, ptl);
 	return err;
 }
diff --git a/mm/page_table_check.c b/mm/page_table_check.c
index 3fb995e5d40d..a5382c245b32 100644
--- a/mm/page_table_check.c
+++ b/mm/page_table_check.c
@@ -148,7 +148,7 @@ void __page_table_check_zero(struct page *page, unsigned int order)
 void __page_table_check_pte_clear(struct mm_struct *mm, unsigned long addr,
 				  pte_t pte)
 {
-	if (&init_mm == mm)
+	if (mm_is_kernel(mm))
 		return;
 
 	if (pte_user_accessible_page(mm, addr, pte))
@@ -159,7 +159,7 @@ EXPORT_SYMBOL(__page_table_check_pte_clear);
 void __page_table_check_pmd_clear(struct mm_struct *mm, unsigned long addr,
 				  pmd_t pmd)
 {
-	if (&init_mm == mm)
+	if (mm_is_kernel(mm))
 		return;
 
 	if (pmd_user_accessible_page(mm, addr, pmd))
@@ -170,7 +170,7 @@ EXPORT_SYMBOL(__page_table_check_pmd_clear);
 void __page_table_check_pud_clear(struct mm_struct *mm, unsigned long addr,
 				  pud_t pud)
 {
-	if (&init_mm == mm)
+	if (mm_is_kernel(mm))
 		return;
 
 	if (pud_user_accessible_page(mm, addr, pud))
@@ -201,7 +201,7 @@ void __page_table_check_ptes_set(struct mm_struct *mm, unsigned long addr,
 {
 	unsigned int i;
 
-	if (&init_mm == mm)
+	if (mm_is_kernel(mm))
 		return;
 
 	page_table_check_pte_flags(pte);
@@ -231,7 +231,7 @@ void __page_table_check_pmds_set(struct mm_struct *mm, unsigned long addr,
 	unsigned long stride = PMD_SIZE >> PAGE_SHIFT;
 	unsigned int i;
 
-	if (&init_mm == mm)
+	if (mm_is_kernel(mm))
 		return;
 
 	page_table_check_pmd_flags(pmd);
@@ -249,7 +249,7 @@ void __page_table_check_puds_set(struct mm_struct *mm, unsigned long addr,
 	unsigned long stride = PUD_SIZE >> PAGE_SHIFT;
 	unsigned int i;
 
-	if (&init_mm == mm)
+	if (mm_is_kernel(mm))
 		return;
 
 	for (i = 0; i < nr; i++)
@@ -263,7 +263,7 @@ void __page_table_check_pte_clear_range(struct mm_struct *mm,
 					unsigned long addr,
 					pmd_t pmd)
 {
-	if (&init_mm == mm)
+	if (mm_is_kernel(mm))
 		return;
 
 	if (!pmd_bad(pmd) && !pmd_leaf(pmd)) {
diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index ed4860c01936..a3f47d1de3c5 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -72,13 +72,13 @@ static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 		 * fit its pmd_bad() check (_PAGE_NX set and _PAGE_RW clear),
 		 * and CONFIG_EFI_PGT_DUMP efi_mm goes so far as to walk them.
 		 */
-		if (walk->mm == &init_mm || addr >= TASK_SIZE)
+		if (mm_is_kernel(walk->mm) || addr >= TASK_SIZE)
 			pte = pte_offset_kernel(pmd, addr);
 		else
 			pte = pte_offset_map(pmd, addr);
 		if (pte) {
 			err = walk_pte_range_inner(pte, addr, end, walk);
-			if (walk->mm != &init_mm && addr < TASK_SIZE)
+			if (!mm_is_kernel(walk->mm) && addr < TASK_SIZE)
 				pte_unmap(pte);
 		}
 	} else {

-- 
2.51.2

