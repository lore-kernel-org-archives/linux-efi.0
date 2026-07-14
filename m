Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33E2F47DD62;
	Tue, 14 Jul 2026 14:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784038044; cv=none; b=ZStobTDGjRSvHCOZHECUWn2pfNynF8YBPaJ34ovaS2O4DV4zh2kaKQcYEP3gZyyXiQkvg9XlaLICc8nZiC3HbFr6z1FvhnPjgI4B+UWUrf78T7BEOcj3CN2jWTwTXawjtCio6hy2RYIumNh0NMbfnB7UrrhEr48uw9mN+f6pv6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784038044; c=relaxed/simple;
	bh=W5yMHnXfWcnH1ZpiyUJxzPFiGyzR0nmofTO/4v3XglM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=MlQTP0ZY+NjAEcSqlHGDQbM8wsSVTRfQ5ex43qh8btgsG/D/X/lbrsoTMSD4PlGrrLAXrSUUy0sSkVuMQbuluLRZve0TxBr9fkSAWGmXymwqufhupWFMwiZcXnuYCXSD/csPJpJuPbUqkPLjRSEp5QhpxiuEE1wmnZPSqbaB6aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=tcs2QjbO; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="tcs2QjbO"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 485791C25;
	Tue, 14 Jul 2026 07:07:17 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 211913FBB1;
	Tue, 14 Jul 2026 07:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784038041; bh=W5yMHnXfWcnH1ZpiyUJxzPFiGyzR0nmofTO/4v3XglM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=tcs2QjbOfi2UrOaEb3Be0yDpY6GZomCe7QbbhuAt79rvxsFv0nPzL+CWkgYpCVks/
	 ogkFHzzFifaJTeH1MCRm+XyD/611Im1Ut2kp5sQ9dzHO1o7eUkGFrrRiH6Z4V/RDtz
	 /vlFqoX8JwYVcEUc2qvYwpr+Gn4LoNg3DQ/uWfI4=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 14 Jul 2026 15:04:06 +0100
Subject: [PATCH 17/22] mm: pagewalk: drop redundant address check for
 kernel mm walks
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-remove_pgtable_cdtor-v1-17-44be8a7685d7@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784037902; l=1902;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=W5yMHnXfWcnH1ZpiyUJxzPFiGyzR0nmofTO/4v3XglM=;
 b=TFBgeJD80Ix+w11MAOvfP3+Vh87dI14Hnq0FHr8NrSRBwD9XPKoZw/aAqVJc1+sG5OV8cIA+P
 hlg2L1E8nGiAdR9B4tzknmDLhA26Dhv64+3Fs4YGAcZ8Y3UcdoWIKP6
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=

Commit 8b1cb4a2e819 ("mm/pagewalk: fix EFI_PGT_DUMP of
espfix area") made no-VMA page table walks use
pte_offset_kernel() for any address above TASK_SIZE. This avoided
pte_offset_map() validation on EFI page table dumps, where efi_mm
could walk x86 espfix PMDs that intentionally look bad to pmd_bad().

efi_mm is now marked with MMF_KERNEL, and no-VMA walks use
mm_is_kernel() to select pte_offset_kernel() for kernel mm's. As a
result we no longer need to handle the EFI_PGT_DUMP case explicitly.The
address check is therefore redundant for EFI_PGT_DUMP and makes the
condition harder to reason about.

Remove the address check and associated comment; mm_is_kernel()
should be sufficient on its own.

Tested by booting x86 QEMU with CONFIG_EFI_PGT_DUMP=y and reading
/sys/kernel/debug/page_tables/efi.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 mm/pagewalk.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index a3f47d1de3c5..0dd9d4ad9b68 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -68,17 +68,14 @@ static int walk_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 	if (walk->no_vma) {
 		/*
 		 * pte_offset_map() might apply user-specific validation.
-		 * Indeed, on x86_64 the pmd entries set up by init_espfix_ap()
-		 * fit its pmd_bad() check (_PAGE_NX set and _PAGE_RW clear),
-		 * and CONFIG_EFI_PGT_DUMP efi_mm goes so far as to walk them.
 		 */
-		if (mm_is_kernel(walk->mm) || addr >= TASK_SIZE)
+		if (mm_is_kernel(walk->mm))
 			pte = pte_offset_kernel(pmd, addr);
 		else
 			pte = pte_offset_map(pmd, addr);
 		if (pte) {
 			err = walk_pte_range_inner(pte, addr, end, walk);
-			if (!mm_is_kernel(walk->mm) && addr < TASK_SIZE)
+			if (!mm_is_kernel(walk->mm))
 				pte_unmap(pte);
 		}
 	} else {

-- 
2.51.2

