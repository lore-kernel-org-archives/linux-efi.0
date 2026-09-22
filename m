Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA8B3576EAC;
	Tue, 22 Sep 2026 17:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790098386; cv=none; b=ul3I85KGvjAOv14B18jLwtjV6R+ChPfnMc+RmxibMJ9RACsVIxwfoou9lIKOvzvblnoi+TLE5Eg2sjWTjDWdvmzTlCLMHa19qDzoPztc2nyyCEIAm3u1scDO3v8nQc51l+zd2au6yWbBx5vKK54WDjwSCDdeLwXRaek7okGDWDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790098386; c=relaxed/simple;
	bh=xTJL2byDqGx0AB4Z6L+IiKln34gIro0/pV4Ued2u1UM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bjhnSXH3VziQtQRag1eG9rRpISsXTMpBjG27crkFUs1OZ/M+cL53gcVEXfH/nLoU9EWKDTXEG9sdMlj8/z0x/LG+Dg0Mvpqo5AHts9JsfWpAU9H6dcDIEAj8q5AbufRTOkgsGoiOocupKpsyB7HU1/W9Uc4MPE8LhPla+p9wsuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Rr/9WR4u; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Rr/9WR4u"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4CC811576;
	Tue, 22 Sep 2026 10:32:54 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 633063F86C;
	Tue, 22 Sep 2026 10:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790098377; bh=xTJL2byDqGx0AB4Z6L+IiKln34gIro0/pV4Ued2u1UM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Rr/9WR4uGteoys9nZHG7+FeU3UTiy8Locu6YSlv8Os75MOwYw1jqPExvnMg9LRzUJ
	 2y6T0AwNdB9W5yWJSKEUKDK4zrqxaAO4cewAugA1YMhbN8da8UqEMmzaUGtYMbZYGI
	 8EZouveWU4RVVr0bxL6+D614EYrFlIzanIIkQzLg=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Date: Tue, 22 Sep 2026 18:31:57 +0100
Subject: [PATCH v2 2/6] arm64: use hw_pte_val for HW PTE atomics
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260922-pte0_arm-v2-2-a3f1ddff0a8a@arm.com>
References: <20260922-pte0_arm-v2-0-a3f1ddff0a8a@arm.com>
In-Reply-To: <20260922-pte0_arm-v2-0-a3f1ddff0a8a@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, 
 Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-efi@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
 Muhammad Usama Anjum <usama.anjum@arm.com>
X-Mailer: b4 0.16.0

The low-level atomic PTE update paths take the address of
pte_val(*ptep). That assumes HW PTE storage can be passed directly to
the SW PTE value accessor and no longer type-checks when hw_pte_t is
distinct.

Use hw_pte_val() for the lvalues passed to compare-exchange and exchange
operations. The atomic operations and their ordering are unchanged.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Chagnes in v2:
- Remove comment change
- Move hw_pte_val() to generic series
---
 arch/arm64/include/asm/pgtable.h | 10 +++++-----
 arch/arm64/mm/fault.c            |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 652ce413be389..4768ec59de555 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1303,7 +1303,7 @@ static inline bool __ptep_test_and_clear_young(struct vm_area_struct *vma,
 	do {
 		old_pte = pte;
 		pte = pte_mkold(pte);
-		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
+		pte_val(pte) = cmpxchg_relaxed(&hw_pte_val(*ptep),
 					       pte_val(old_pte), pte_val(pte));
 	} while (pte_val(pte) != pte_val(old_pte));
 
@@ -1346,7 +1346,7 @@ static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
 					       hw_pte_t *ptep,
 					       unsigned long pgsize)
 {
-	pte_t pte = __pte(xchg_relaxed(&pte_val(*ptep), 0));
+	pte_t pte = __pte(xchg_relaxed(&hw_pte_val(*ptep), 0));
 
 	switch (pgsize) {
 	case PAGE_SIZE:
@@ -1422,7 +1422,7 @@ static inline void ___ptep_set_wrprotect(struct mm_struct *mm,
 	do {
 		old_pte = pte;
 		pte = pte_wrprotect(pte);
-		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
+		pte_val(pte) = cmpxchg_relaxed(&hw_pte_val(*ptep),
 					       pte_val(old_pte), pte_val(pte));
 	} while (pte_val(pte) != pte_val(old_pte));
 }
@@ -1460,7 +1460,7 @@ static inline void __clear_young_dirty_pte(struct vm_area_struct *vma,
 		if (flags & CYDP_CLEAR_DIRTY)
 			pte = pte_mkclean(pte);
 
-		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
+		pte_val(pte) = cmpxchg_relaxed(&hw_pte_val(*ptep),
 					       pte_val(old_pte), pte_val(pte));
 	} while (pte_val(pte) != pte_val(old_pte));
 }
@@ -1830,7 +1830,7 @@ static inline bool ptep_try_set(hw_pte_t *ptep, pte_t new_pte)
 {
 	pteval_t old = 0;
 
-	if (!try_cmpxchg(&pte_val(*ptep), &old, pte_val(new_pte)))
+	if (!try_cmpxchg(&hw_pte_val(*ptep), &old, pte_val(new_pte)))
 		return false;
 
 	/*
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index b77f4be88e3ea..3322f4e7174dc 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -235,7 +235,7 @@ int __ptep_set_access_flags_anysz(struct vm_area_struct *vma,
 		pteval ^= PTE_RDONLY;
 		pteval |= pte_val(entry);
 		pteval ^= PTE_RDONLY;
-		pteval = cmpxchg_relaxed(&pte_val(*ptep), old_pteval, pteval);
+		pteval = cmpxchg_relaxed(&hw_pte_val(*ptep), old_pteval, pteval);
 	} while (pteval != old_pteval);
 
 	/*

-- 
2.47.3

