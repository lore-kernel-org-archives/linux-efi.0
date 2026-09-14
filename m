Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F18794611E1;
	Mon, 14 Sep 2026 13:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789393935; cv=none; b=BAvUsNoYtdWHpdCE7yI7zwPfIzPktY/fujhNCd9iRzLzB5Wbro1bKcxCu4cWVAM4G3N1/Uz/tEf2cVaO+UjqW65iaLzrPwL9X0MntQM2T4IZyI2FYHk7qyksdbfiZ9XEjdW69bM7aZt/9bD9+zf4ACgANkBlbqaxodqEVf+I7RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789393935; c=relaxed/simple;
	bh=a0XPwGbhmPF/8HQB5tl0tfRDc3dHm2jdpy2fD9dIAOw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mW1Gsegtr3xfuc1Tb16/p/kl8Neq/C6bVmHjfmh3KnbK5gYNGKr2cOEf+YK+jy1BkVbOtwgcOlwHRTnBkUVhJC/5KxsA1igI52nnyrPOq4gtDMrbjC7pCJ3pYKllcPL28BaAycVQU/5W8NA2QdXA5RDixAsARvwIWMnRhIQnBGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Pfzm5hJ3; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Pfzm5hJ3"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C4A051570;
	Mon, 14 Sep 2026 06:52:08 -0700 (PDT)
Received: from [127.0.1.1] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F60A3F882;
	Mon, 14 Sep 2026 06:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789393932; bh=a0XPwGbhmPF/8HQB5tl0tfRDc3dHm2jdpy2fD9dIAOw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Pfzm5hJ3feethkE3Lt+/Yi0zFezDiFNBYm62UaeS/yrfFexyWZ5fbgJcnY5dDxP/0
	 2T9TOcPMJpLUxmKN/g4RlGweBDexJjW+SpVe4eoyBWvQbUpGj2MaSFuD6QqTOaw7RS
	 AGhWCYfmKhKFpjN5exzGFjhmlpyiygeQNVXzo1rM=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Date: Mon, 14 Sep 2026 14:51:32 +0100
Subject: [PATCH 2/6] arm64: use hw_pte_val for HW PTE atomics
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-pte0_arm-v1-2-bb53b663e396@arm.com>
References: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
In-Reply-To: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Ard Biesheuvel <ardb@kernel.org>, 
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

Add hw_pte_val() to preserve an lvalue for the HW PTE bits, so atomic
updates can take their address. pte_val() expects a SW PTE value and
cannot operate directly on a distinct hw_pte_t.

With ARCH_HAS_HW_PTE_T, use pte_val() on the wrapper's __pte member;
otherwise, use pte_val() directly.

The atomic operations and their ordering are unchanged.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 arch/arm64/include/asm/pgtable.h | 10 +++++-----
 arch/arm64/mm/fault.c            |  6 +++---
 include/linux/pgtable_types.h    |  4 ++++
 3 files changed, 12 insertions(+), 8 deletions(-)

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
index b77f4be88e3ea..7d6c30f27214e 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -225,8 +225,8 @@ int __ptep_set_access_flags_anysz(struct vm_area_struct *vma,
 	/*
 	 * Setting the flags must be done atomically to avoid racing with the
 	 * hardware update of the access/dirty state. The PTE_RDONLY bit must
-	 * be set to the most permissive (lowest value) of *ptep and entry
-	 * (calculated as: a & b == ~(~a | ~b)).
+	 * be set to the most permissive (lowest value) of the current PTE and
+	 * entry (calculated as: a & b == ~(~a | ~b)).
 	 */
 	pte_val(entry) ^= PTE_RDONLY;
 	pteval = pte_val(pte);
@@ -235,7 +235,7 @@ int __ptep_set_access_flags_anysz(struct vm_area_struct *vma,
 		pteval ^= PTE_RDONLY;
 		pteval |= pte_val(entry);
 		pteval ^= PTE_RDONLY;
-		pteval = cmpxchg_relaxed(&pte_val(*ptep), old_pteval, pteval);
+		pteval = cmpxchg_relaxed(&hw_pte_val(*ptep), old_pteval, pteval);
 	} while (pteval != old_pteval);
 
 	/*
diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
index d6c5a7548550b..ee4eace5c3e1c 100644
--- a/include/linux/pgtable_types.h
+++ b/include/linux/pgtable_types.h
@@ -9,9 +9,13 @@
 #ifdef CONFIG_ARCH_HAS_HW_PTE_T
 typedef struct __hw_pte_t { pte_t __pte; } hw_pte_t;
 #define __pte_from_hw(pte)	((pte).__pte)
+
+#define hw_pte_val(x)  pte_val((x).__pte)
 #else
 #define hw_pte_t pte_t
 #define __pte_from_hw(pte)	(pte)
+
+#define hw_pte_val(x)  pte_val(x)
 #endif
 
 #endif /* !__ASSEMBLY__ */

-- 
2.47.3

