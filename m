Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 624C53B14A7;
	Fri, 18 Sep 2026 15:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789746915; cv=none; b=Q5w8OocILKJyVReb1qlYDQQkw4/fYyK4TVfjjFmxXdxnXHk3ZnfCrMo4VR15dYE2MTl1CYCMy/7OpE0ByraePy2AXkFKigY+fbNxudpH1i0i8CIZbNMekYC67f0f6n+BsA1TfcmqD8M4j1px+TqXNEMADtyHGtijxLHKMGpBvxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789746915; c=relaxed/simple;
	bh=h6rfWJQHWA6AbcMjJ6geNACzDmvpZX6SlmU6TfDDjl4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AsxEafN+GKZEIxhKC31oH+4rOlqm+xnwO+iWtPmgOM/3sgtzhJygUq8IQFMbD8N12BpdNtBVV8A3KdMmya/nTNzmdRTf+ZVLUSI1E5uQgxlHM18dUuhueweBiTeqsDVcWPNTW934AwqtOpAZ7CJueKPkpF5gkaKnnnO23BOF1Hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Slvyn6V4; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Slvyn6V4"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 00D69168F;
	Fri, 18 Sep 2026 08:55:09 -0700 (PDT)
Received: from [10.57.83.108] (unknown [10.57.83.108])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 93FD43F7B4;
	Fri, 18 Sep 2026 08:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789746912; bh=h6rfWJQHWA6AbcMjJ6geNACzDmvpZX6SlmU6TfDDjl4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Slvyn6V4Oo34Au5DOF1kboWsJhCsaV1c3o8YhZGZ1uDZIq6kJGrq06wenZFv5EDFt
	 rc1I3KnVukf8/IyOeNPvQrdNuKb9cmLZVVwgE+SE8jrEkLVZCoxFvYokUmGawc8WSZ
	 yCfWVIgzMcDRelK8r6NIxI4xxV77Jr9WyJ/BldhY=
Message-ID: <f9a7cd29-8aa3-4436-a95e-999c03aad0d7@arm.com>
Date: Fri, 18 Sep 2026 16:55:06 +0100
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] arm64: use hw_pte_val for HW PTE atomics
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
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
 linux-efi@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org
References: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
 <20260914-pte0_arm-v1-2-bb53b663e396@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20260914-pte0_arm-v1-2-bb53b663e396@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14/09/2026 14:51, Muhammad Usama Anjum wrote:
> Add hw_pte_val() to preserve an lvalue for the HW PTE bits, so atomic
> updates can take their address. pte_val() expects a SW PTE value and
> cannot operate directly on a distinct hw_pte_t.
> 
> With ARCH_HAS_HW_PTE_T, use pte_val() on the wrapper's __pte member;
> otherwise, use pte_val() directly.
> 
> The atomic operations and their ordering are unchanged.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
>  arch/arm64/include/asm/pgtable.h | 10 +++++-----
>  arch/arm64/mm/fault.c            |  6 +++---
>  include/linux/pgtable_types.h    |  4 ++++
>  3 files changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 652ce413be389..4768ec59de555 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -1303,7 +1303,7 @@ static inline bool __ptep_test_and_clear_young(struct vm_area_struct *vma,
>  	do {
>  		old_pte = pte;
>  		pte = pte_mkold(pte);
> -		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
> +		pte_val(pte) = cmpxchg_relaxed(&hw_pte_val(*ptep),
>  					       pte_val(old_pte), pte_val(pte));
>  	} while (pte_val(pte) != pte_val(old_pte));
>  
> @@ -1346,7 +1346,7 @@ static inline pte_t __ptep_get_and_clear_anysz(struct mm_struct *mm,
>  					       hw_pte_t *ptep,
>  					       unsigned long pgsize)
>  {
> -	pte_t pte = __pte(xchg_relaxed(&pte_val(*ptep), 0));
> +	pte_t pte = __pte(xchg_relaxed(&hw_pte_val(*ptep), 0));
>  
>  	switch (pgsize) {
>  	case PAGE_SIZE:
> @@ -1422,7 +1422,7 @@ static inline void ___ptep_set_wrprotect(struct mm_struct *mm,
>  	do {
>  		old_pte = pte;
>  		pte = pte_wrprotect(pte);
> -		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
> +		pte_val(pte) = cmpxchg_relaxed(&hw_pte_val(*ptep),
>  					       pte_val(old_pte), pte_val(pte));
>  	} while (pte_val(pte) != pte_val(old_pte));
>  }
> @@ -1460,7 +1460,7 @@ static inline void __clear_young_dirty_pte(struct vm_area_struct *vma,
>  		if (flags & CYDP_CLEAR_DIRTY)
>  			pte = pte_mkclean(pte);
>  
> -		pte_val(pte) = cmpxchg_relaxed(&pte_val(*ptep),
> +		pte_val(pte) = cmpxchg_relaxed(&hw_pte_val(*ptep),
>  					       pte_val(old_pte), pte_val(pte));
>  	} while (pte_val(pte) != pte_val(old_pte));
>  }
> @@ -1830,7 +1830,7 @@ static inline bool ptep_try_set(hw_pte_t *ptep, pte_t new_pte)
>  {
>  	pteval_t old = 0;
>  
> -	if (!try_cmpxchg(&pte_val(*ptep), &old, pte_val(new_pte)))
> +	if (!try_cmpxchg(&hw_pte_val(*ptep), &old, pte_val(new_pte)))
>  		return false;
>  
>  	/*
> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
> index b77f4be88e3ea..7d6c30f27214e 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -225,8 +225,8 @@ int __ptep_set_access_flags_anysz(struct vm_area_struct *vma,
>  	/*
>  	 * Setting the flags must be done atomically to avoid racing with the
>  	 * hardware update of the access/dirty state. The PTE_RDONLY bit must
> -	 * be set to the most permissive (lowest value) of *ptep and entry
> -	 * (calculated as: a & b == ~(~a | ~b)).
> +	 * be set to the most permissive (lowest value) of the current PTE and
> +	 * entry (calculated as: a & b == ~(~a | ~b)).

This seems like an unrelated and unecessary comment change?

>  	 */
>  	pte_val(entry) ^= PTE_RDONLY;
>  	pteval = pte_val(pte);
> @@ -235,7 +235,7 @@ int __ptep_set_access_flags_anysz(struct vm_area_struct *vma,
>  		pteval ^= PTE_RDONLY;
>  		pteval |= pte_val(entry);
>  		pteval ^= PTE_RDONLY;
> -		pteval = cmpxchg_relaxed(&pte_val(*ptep), old_pteval, pteval);
> +		pteval = cmpxchg_relaxed(&hw_pte_val(*ptep), old_pteval, pteval);
>  	} while (pteval != old_pteval);
>  
>  	/*
> diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
> index d6c5a7548550b..ee4eace5c3e1c 100644
> --- a/include/linux/pgtable_types.h
> +++ b/include/linux/pgtable_types.h
> @@ -9,9 +9,13 @@
>  #ifdef CONFIG_ARCH_HAS_HW_PTE_T
>  typedef struct __hw_pte_t { pte_t __pte; } hw_pte_t;
>  #define __pte_from_hw(pte)	((pte).__pte)
> +

nit: why the newline here (and equivalent below)?

> +#define hw_pte_val(x)  pte_val((x).__pte)

Wouldn't it be better to add these as part of the generic series? I know we
prefer to add an api along with its first user, but in this case it seems odd,
because you're effectively requiring that arm64 is the first merged arch to
support this? You could also use the same argument to say that none of this
should be merged until the commit where an arch turns on ARCH_HAS_HW_PTE_T.

Thanks,
Ryan


>  #else
>  #define hw_pte_t pte_t
>  #define __pte_from_hw(pte)	(pte)
> +
> +#define hw_pte_val(x)  pte_val(x)
>  #endif
>  
>  #endif /* !__ASSEMBLY__ */
> 

