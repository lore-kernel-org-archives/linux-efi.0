Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE15647DD7A;
	Tue, 14 Jul 2026 14:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784037989; cv=none; b=HM5dCq7dsvU/ZIdNnJbecY+qT72X3zw/rMJVoUBsD9GcFwRjc5zza4FO+Hr6GoJdbG9zVPre+i4NU90li1VFV3tGvNFJR6QWJhN5z73dfOz3gkRbH6CUMMch/6AK7p33so3v1+6fxnkI9ZILM1IZ+g6YvGZkNjmqzhK2FUx10Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784037989; c=relaxed/simple;
	bh=0Ls2F5YWtI+Ww29NmMlh3ILvDXBv7NqjYutzPTWlWAY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Dlm3dCKV3g2U9xwnBLULxkerVylNt0waPQhUa2KswyePTsn8cMGool4iiww411fL4PgnJeeQMW3p4ipZvwlSLG31etIUKUeOMTROV4bymdFQoc6iJS/QFCTSkQjwYhPlkdktby/OBL6ASXpwUH6RlzKWaDsUV6p/2Dr7d2BbvYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Vw/Dcaip; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Vw/Dcaip"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 339AB1576;
	Tue, 14 Jul 2026 07:06:23 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0D7CA3F7B4;
	Tue, 14 Jul 2026 07:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784037987; bh=0Ls2F5YWtI+Ww29NmMlh3ILvDXBv7NqjYutzPTWlWAY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Vw/DcaipPFO7n11+mYGQ7sNvjiW4bDFKvxM87pb4Zb7kuc57MeI8Zk26C7/35oDk9
	 zqUNmHcLyquGe9NI65E4Her4eCylK5913yMxY4xf0bE1WBcJGqN4rBz8A8PaHgPJxY
	 8H47S03cWv8hSaCgq8C8KHighveKeuoCTTOKDHQY=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 14 Jul 2026 15:03:59 +0100
Subject: [PATCH 10/22] sparc: mm: use mm_is_kernel() for kernel mm checks
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-remove_pgtable_cdtor-v1-10-44be8a7685d7@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784037902; l=3538;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=0Ls2F5YWtI+Ww29NmMlh3ILvDXBv7NqjYutzPTWlWAY=;
 b=VJPLQX/cB8CHz8XN2ewL2VVdeyfHItZBmFDR5s9RbTft/6Q4d42mZh1rja83yviws3jmyIGiU
 WKKijSfDJjoB4fJ0orVPQbnc54Akn8lFl91qUqv6PDas/mRRckHwzdj
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=

The new MMF_KERNEL flag identifies kernel-owned mm's. Checking the
flag with mm_is_kernel() is preferred over comparing directly
against &init_mm.

No functional change, as only init_mm has MMF_KERNEL set for now.

pgtable_64.h previously forward-declared init_mm to avoid pulling
in mm_types.h. It seems that including mm_types.h is not causing
troubles any more, so we can also use mm_is_kernel() there and drop
the forward declaration.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/sparc/include/asm/mmu_context_64.h | 2 +-
 arch/sparc/include/asm/pgtable_64.h     | 6 ++----
 arch/sparc/mm/init_64.c                 | 2 +-
 arch/sparc/mm/tlb.c                     | 2 +-
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/sparc/include/asm/mmu_context_64.h b/arch/sparc/include/asm/mmu_context_64.h
index 78bbacc14d2d..e88bc61aeb04 100644
--- a/arch/sparc/include/asm/mmu_context_64.h
+++ b/arch/sparc/include/asm/mmu_context_64.h
@@ -83,7 +83,7 @@ static inline void switch_mm(struct mm_struct *old_mm, struct mm_struct *mm, str
 	int cpu = smp_processor_id();
 
 	per_cpu(per_cpu_secondary_mm, cpu) = mm;
-	if (unlikely(mm == &init_mm))
+	if (unlikely(mm_is_kernel(mm)))
 		return;
 
 	spin_lock_irqsave(&mm->context.lock, flags);
diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index 0837ebbc5dce..960f8bf1ec5a 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -86,6 +86,7 @@ extern unsigned long VMALLOC_END;
 #define vmemmap			((struct page *)VMEMMAP_BASE)
 
 #include <linux/sched.h>
+#include <linux/mm_types.h>
 #include <asm/tlbflush.h>
 
 bool kern_addr_valid(unsigned long addr);
@@ -885,9 +886,6 @@ static inline unsigned long pud_pfn(pud_t pud)
 #define p4d_set(p4dp, pudp)	\
 	(p4d_val(*(p4dp)) = (__pa((unsigned long) (pudp))))
 
-/* We cannot include <linux/mm_types.h> at this point yet: */
-extern struct mm_struct init_mm;
-
 /* Actual page table PTE updates.  */
 void tlb_batch_add(struct mm_struct *mm, unsigned long vaddr,
 		   pte_t *ptep, pte_t orig, int fullmm,
@@ -903,7 +901,7 @@ static void maybe_tlb_batch_add(struct mm_struct *mm, unsigned long vaddr,
 	 * SUN4V NOTE: _PAGE_VALID is the same value in both the SUN4U
 	 *             and SUN4V pte layout, so this inline test is fine.
 	 */
-	if (likely(mm != &init_mm) && pte_accessible(mm, orig))
+	if (likely(!mm_is_kernel(mm)) && pte_accessible(mm, orig))
 		tlb_batch_add(mm, vaddr, ptep, orig, fullmm, hugepage_shift);
 }
 
diff --git a/arch/sparc/mm/init_64.c b/arch/sparc/mm/init_64.c
index 103db4683b16..e0b678349e3a 100644
--- a/arch/sparc/mm/init_64.c
+++ b/arch/sparc/mm/init_64.c
@@ -788,7 +788,7 @@ static void mmu_context_wrap(void)
 		 */
 		mm = per_cpu(per_cpu_secondary_mm, cpu);
 
-		if (unlikely(!mm || mm == &init_mm))
+		if (unlikely(!mm || mm_is_kernel(mm)))
 			continue;
 
 		old_ctx = mm->context.sparc64_ctx_val;
diff --git a/arch/sparc/mm/tlb.c b/arch/sparc/mm/tlb.c
index 6d9dd5eb1328..47083c287a94 100644
--- a/arch/sparc/mm/tlb.c
+++ b/arch/sparc/mm/tlb.c
@@ -179,7 +179,7 @@ static void tlb_batch_pmd_scan(struct mm_struct *mm, unsigned long vaddr,
 static void __set_pmd_acct(struct mm_struct *mm, unsigned long addr,
 			   pmd_t orig, pmd_t pmd)
 {
-	if (mm == &init_mm)
+	if (mm_is_kernel(mm))
 		return;
 
 	if ((pmd_val(pmd) ^ pmd_val(orig)) & _PAGE_PMD_HUGE) {

-- 
2.51.2

