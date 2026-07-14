Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F19824418DC;
	Tue, 14 Jul 2026 14:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784037966; cv=none; b=iOSjB2NSbmz/gNQncNEkleC22l9RnIkX9dbAg3UW+D6RpPPJ6domoSWUWrGm+I05SM2iYZ1j+J1LL2iTm0gcTy7nJ1F22u2pvr85G8LWe8yWeIAClRRL03wKwIvmut0Pd5AJTzn3KpXoVx7iJ1dSgAL8TSGdVYh0XhpxUGeayG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784037966; c=relaxed/simple;
	bh=n3wqVkoRE0XrCf49SeUd/3zMbBniK8cKIbHpgqpyHxU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KQaBvXoGgHwdVfE4VYH2MmLPQUnkPRkB99CAn47i+26iYyEyBGZ8lOFKKORRD7+Nz7LxANraDAjonAV0zUfDDcvbMwz1t3DUu+Oe+2PY/qT0NLD21jagaDu0M7dch000NNQ/f6pXxbu+P4COzj9O39JgSieBIKzeSN6f9x75oW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gLbEbpAv; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gLbEbpAv"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 07FEF1576;
	Tue, 14 Jul 2026 07:06:00 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D4CBA3F7B4;
	Tue, 14 Jul 2026 07:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784037964; bh=n3wqVkoRE0XrCf49SeUd/3zMbBniK8cKIbHpgqpyHxU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=gLbEbpAvFzCqe/uk00cuBVEyk86ImDFUKg9+DAxOfE+6fXLZiWwmczq+TYqacIij9
	 dzObBv+9qrGLnOJGKWs94LTFpTVFSye5m9UY9LBRCiPUb+bTNDGQ4mEUs5d8asduh+
	 urPZbHaQ9KgT1hC0YSHV6N5wgcZRQb27Ns4Uao8I=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 14 Jul 2026 15:03:56 +0100
Subject: [PATCH 07/22] parisc: mm: use mm_is_kernel() for kernel mm checks
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-remove_pgtable_cdtor-v1-7-44be8a7685d7@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784037902; l=2128;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=n3wqVkoRE0XrCf49SeUd/3zMbBniK8cKIbHpgqpyHxU=;
 b=NiOLSLM4Bju3NE/MJk1JSg+adlOz6kSqOBN5Q1Ojo91j2+7DutkOZ20lco5JkeakYm3HADh4V
 WLZkvqMg2QAA0cYBkRVmiWNUb4u1J8+jQygFQcLGfYdNrt+hwaqOb94
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=

The new MMF_KERNEL flag identifies kernel-owned mm's. Checking the
flag with mm_is_kernel() is preferred over comparing directly
against &init_mm.

No functional change, as only init_mm has MMF_KERNEL set for now.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/parisc/include/asm/mmu_context.h | 2 +-
 arch/parisc/include/asm/pgalloc.h     | 2 +-
 arch/parisc/include/asm/tlbflush.h    | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/parisc/include/asm/mmu_context.h b/arch/parisc/include/asm/mmu_context.h
index c9187fe836a3..e265da67559e 100644
--- a/arch/parisc/include/asm/mmu_context.h
+++ b/arch/parisc/include/asm/mmu_context.h
@@ -87,7 +87,7 @@ static inline void activate_mm(struct mm_struct *prev, struct mm_struct *next)
 	 * already, so we should be OK.
 	 */
 
-	BUG_ON(next == &init_mm); /* Should never happen */
+	BUG_ON(mm_is_kernel(next)); /* Should never happen */
 
 	if (next->context.space_id == 0)
 		next->context.space_id = alloc_sid();
diff --git a/arch/parisc/include/asm/pgalloc.h b/arch/parisc/include/asm/pgalloc.h
index 3b84ee93edaa..9f09cc4fa5dd 100644
--- a/arch/parisc/include/asm/pgalloc.h
+++ b/arch/parisc/include/asm/pgalloc.h
@@ -34,7 +34,7 @@ static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
 	struct ptdesc *ptdesc;
 	gfp_t gfp = GFP_PGTABLE_USER;
 
-	if (mm == &init_mm)
+	if (mm_is_kernel(mm))
 		gfp = GFP_PGTABLE_KERNEL;
 	ptdesc = pagetable_alloc(gfp, PMD_TABLE_ORDER);
 	if (!ptdesc)
diff --git a/arch/parisc/include/asm/tlbflush.h b/arch/parisc/include/asm/tlbflush.h
index 5ffd7c17f593..a5a6cfff295c 100644
--- a/arch/parisc/include/asm/tlbflush.h
+++ b/arch/parisc/include/asm/tlbflush.h
@@ -35,7 +35,7 @@ int __flush_tlb_range(unsigned long sid,
 
 static inline void flush_tlb_mm(struct mm_struct *mm)
 {
-	BUG_ON(mm == &init_mm); /* Should never happen */
+	BUG_ON(mm_is_kernel(mm)); /* Should never happen */
 
 #if 1 || defined(CONFIG_SMP)
 	/* Except for very small threads, flushing the whole TLB is

-- 
2.51.2

