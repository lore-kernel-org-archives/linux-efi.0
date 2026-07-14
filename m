Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 764C347DF9B;
	Tue, 14 Jul 2026 14:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784038055; cv=none; b=Vpvur0jO5UP652caprhnV5mfunPpuzJux+6qEK6m249ibhl+0pVV75ix14DYFHZy4wLDW4AD4Bue8W1gPY2agdsVAaSBwEHAQTs2jcRpiQaQDn8n+eKT5da0pQU6K+K5ri0EEh4+dRQDKFhh0wV9O3ud6ER4FdbsbP90ktmvV7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784038055; c=relaxed/simple;
	bh=VE9T6pQuQsM82lM79rZVxS9mOIiIj6SKheB2t7eP+e8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DdYXkmpTqRVNqsRVwGDhwMlag+L2AuhER0/+ie1Ns5BeN6wTUmvnDz1LL12dr5skpQVir/nYoTizcLJsN1FJya0p5Fw52GtYujSNlYEfAjNH9ER4MVgK1Yfw8i94NySZ59j3w5qJBpUVATZEIMQehiz5WuBJr/OHR5C5FCct4k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=LM6l4iVa; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="LM6l4iVa"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 04C511CE0;
	Tue, 14 Jul 2026 07:07:25 -0700 (PDT)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D2ACB3F7B4;
	Tue, 14 Jul 2026 07:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784038049; bh=VE9T6pQuQsM82lM79rZVxS9mOIiIj6SKheB2t7eP+e8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=LM6l4iVarrFVDA4j9SWJAplc2WkKEHlGEtdlAtv7pOYj1y3dATl0KnbkElc5xhenP
	 ErHq3OM3B9mOaLihBDgBjY6YaXcTg/I+07sfZRGvHPhPtHlUZIL/cU1EpblJJAXbkJ
	 UH/xAtOtw9tn/FqSE+wrtOg61lpQnXFpNRh+nTaw=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Tue, 14 Jul 2026 15:04:07 +0100
Subject: [PATCH 18/22] arm64: mm: drop explicit mm_is_efi() check in
 contpte
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260714-remove_pgtable_cdtor-v1-18-44be8a7685d7@arm.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784037902; l=2365;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=VE9T6pQuQsM82lM79rZVxS9mOIiIj6SKheB2t7eP+e8=;
 b=IJb3I/i6HXAVQpbcZffARFaIRNRmoRCmPcfDA+y7q25vE/t36H63xBNhz/u8eBXK9/0ECckK8
 YJz0OELUjVVA+CXShhe5YzEf7ewVjSRMYhD9KGxFsYnbUmRuESOa0pX
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=

efi_mm is now marked as a kernel mm, like init_mm. mm_is_kernel()
therefore gives the right answer for efi_mm and mm_is_user() is now
equivalent to !mm_is_kernel().

Remove mm_is_user() and directly use mm_is_kernel() instead.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 arch/arm64/mm/contpte.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
index ad5c04cf66ff..e21e279101ca 100644
--- a/arch/arm64/mm/contpte.c
+++ b/arch/arm64/mm/contpte.c
@@ -4,23 +4,9 @@
  */
 
 #include <linux/mm.h>
-#include <linux/efi.h>
 #include <linux/export.h>
 #include <asm/tlbflush.h>
 
-static inline bool mm_is_user(struct mm_struct *mm)
-{
-	/*
-	 * Don't attempt to apply the contig bit to kernel mappings, because
-	 * dynamically adding/removing the contig bit can cause page faults.
-	 * These racing faults are ok for user space, since they get serialized
-	 * on the PTL. But kernel mappings can't tolerate faults.
-	 */
-	if (unlikely(mm_is_efi(mm)))
-		return false;
-	return !mm_is_kernel(mm);
-}
-
 static inline pte_t *contpte_align_down(pte_t *ptep)
 {
 	return PTR_ALIGN_DOWN(ptep, sizeof(*ptep) * CONT_PTES);
@@ -263,7 +249,13 @@ void __contpte_try_fold(struct mm_struct *mm, unsigned long addr,
 
 	int i;
 
-	if (!mm_is_user(mm))
+	/*
+	 * Don't attempt to apply the contig bit to kernel mappings, because
+	 * dynamically adding/removing the contig bit can cause page faults.
+	 * These racing faults are ok for user space, since they get serialized
+	 * on the PTL. But kernel mappings can't tolerate faults.
+	 */
+	if (mm_is_kernel(mm))
 		return;
 
 	page = pte_page(pte);
@@ -302,7 +294,7 @@ void __contpte_try_unfold(struct mm_struct *mm, unsigned long addr,
 	 * We have already checked that the ptes are contiguous in
 	 * contpte_try_unfold(), so just check that the mm is user space.
 	 */
-	if (!mm_is_user(mm))
+	if (mm_is_kernel(mm))
 		return;
 
 	pte = pte_mknoncont(pte);
@@ -465,7 +457,7 @@ void contpte_set_ptes(struct mm_struct *mm, unsigned long addr,
 	 */
 	VM_WARN_ON(nr == 1);
 
-	if (!mm_is_user(mm))
+	if (mm_is_kernel(mm))
 		return __set_ptes(mm, addr, ptep, pte, nr);
 
 	end = addr + (nr << PAGE_SHIFT);

-- 
2.51.2

