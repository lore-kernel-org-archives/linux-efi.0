Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60B8547D931;
	Tue, 14 Jul 2026 14:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784037981; cv=none; b=S+JQKclxjjfhhhFAtJD2EAMT6lCaHTncKrsrTs1Br/3V6fmNh2PbU/JpySfa8zw2vzfyuITfDEGl37auJ+r6vnlo96b19lOLf1RzHrBXS87LVDkChTUi/tEVQvCbZdr/tVcsPbIlFQiNkkqmy6MuihzaNezuivFeHUqYnyRnBM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784037981; c=relaxed/simple;
	bh=NDusZRNCWoEozZsjG5aWosyCUDI8Y1KKdd/tV+nqCY0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lH7Q43amPVPrBiVbRlr17kpUvc+HjxiTG+SlmZziwQbReWn6m/DyqGv7ajMlkKvhfiaIvukgXiBOPnNdrYBiT5ftn8WWJVsbJEV6xNVQrouCRnClf8VWxtapW0HZGPA7VYovsk0H75s/wUnDcG0ewNbmrFM+i/26Go9z09zdqIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=g68p8jn2; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="g68p8jn2"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 78E4E1576;
	Tue, 14 Jul 2026 07:06:15 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4FE263F7B4;
	Tue, 14 Jul 2026 07:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784037979; bh=NDusZRNCWoEozZsjG5aWosyCUDI8Y1KKdd/tV+nqCY0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=g68p8jn2r/BRs15OVDSJM5PC0vX+xZEjL9qs6O4bNrlLAmFr23nxaTMwPJrtgFVSe
	 PO42BSv3F1n/0/KY29fSo68pViH3svUbemsg+2g8ZALHR7Gb34DvnaAe4yB7K0yUyn
	 X1Qg4PRgk23qfvxdXOP4RJxy06FeoAcjmt/U8Rmo=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 14 Jul 2026 15:03:58 +0100
Subject: [PATCH 09/22] s390: mm: use mm_is_kernel() for kernel mm checks
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-remove_pgtable_cdtor-v1-9-44be8a7685d7@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784037902; l=2701;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=NDusZRNCWoEozZsjG5aWosyCUDI8Y1KKdd/tV+nqCY0=;
 b=EN7VJwlPWQ2mLOV0RQXIAGmFgLbZqozbS12jiAz8t5flCb4LBC8CQLf9qAbAsIdiWxuJ/h34z
 +bgdLqbZMrPAgQeOceVSuzYyrvq4LTVvYRTcF4wG9fcsRmwk6IO2SXA
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=

The new MMF_KERNEL flag identifies kernel-owned mm's. Checking the
flag with mm_is_kernel() is preferred over comparing directly
against &init_mm.

No functional change, as only init_mm has MMF_KERNEL set for now.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/s390/include/asm/mmu_context.h | 2 +-
 arch/s390/include/asm/pgtable.h     | 6 +++---
 arch/s390/mm/pgalloc.c              | 4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/s390/include/asm/mmu_context.h b/arch/s390/include/asm/mmu_context.h
index bd1ef5e2d2eb..675f270d0b70 100644
--- a/arch/s390/include/asm/mmu_context.h
+++ b/arch/s390/include/asm/mmu_context.h
@@ -69,7 +69,7 @@ static inline void switch_mm_irqs_off(struct mm_struct *prev, struct mm_struct *
 {
 	int cpu = smp_processor_id();
 
-	if (next == &init_mm)
+	if (mm_is_kernel(next))
 		get_lowcore()->user_asce = s390_invalid_asce;
 	else
 		get_lowcore()->user_asce.val = next->context.asce;
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index e882663a58e7..f7741e6b417e 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1836,21 +1836,21 @@ static inline int has_transparent_hugepage(void)
 #ifdef CONFIG_PAGE_TABLE_CHECK
 static inline bool pte_user_accessible_page(struct mm_struct *mm, unsigned long addr, pte_t pte)
 {
-	VM_BUG_ON(mm == &init_mm);
+	VM_BUG_ON(mm_is_kernel(mm));
 
 	return pte_present(pte);
 }
 
 static inline bool pmd_user_accessible_page(struct mm_struct *mm, unsigned long addr, pmd_t pmd)
 {
-	VM_BUG_ON(mm == &init_mm);
+	VM_BUG_ON(mm_is_kernel(mm));
 
 	return pmd_leaf(pmd) && (pmd_val(pmd) & _SEGMENT_ENTRY_READ);
 }
 
 static inline bool pud_user_accessible_page(struct mm_struct *mm, unsigned long addr, pud_t pud)
 {
-	VM_BUG_ON(mm == &init_mm);
+	VM_BUG_ON(mm_is_kernel(mm));
 
 	return pud_leaf(pud);
 }
diff --git a/arch/s390/mm/pgalloc.c b/arch/s390/mm/pgalloc.c
index 7ac44543e051..d0456b7e73d4 100644
--- a/arch/s390/mm/pgalloc.c
+++ b/arch/s390/mm/pgalloc.c
@@ -20,7 +20,7 @@ unsigned long *crst_table_alloc_noprof(struct mm_struct *mm)
 	struct ptdesc *ptdesc;
 	unsigned long *table;
 
-	if (mm == &init_mm)
+	if (mm_is_kernel(mm))
 		gfp &= ~__GFP_ACCOUNT;
 	ptdesc = pagetable_alloc_noprof(gfp, CRST_ALLOC_ORDER);
 	if (!ptdesc)
@@ -120,7 +120,7 @@ unsigned long *page_table_alloc_noprof(struct mm_struct *mm)
 	struct ptdesc *ptdesc;
 	unsigned long *table;
 
-	if (mm == &init_mm)
+	if (mm_is_kernel(mm))
 		gfp &= ~__GFP_ACCOUNT;
 	ptdesc = pagetable_alloc_noprof(gfp, 0);
 	if (!ptdesc)

-- 
2.51.2

