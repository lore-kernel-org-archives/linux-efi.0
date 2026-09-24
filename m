Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED6D747D44E;
	Thu, 24 Sep 2026 12:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790252498; cv=none; b=okjua3YPdY0BmuIRa8vZpbUhbLklKWXTwV89CtPhKUrlv2Uv5RwVoX+zcisl0lPbcTGUk5ey5mfvgs3sl3fxcOf2KR9AmF4RYnqlrstxgT0aOhZfqPDWpmOJGu1gbhhjXjqNwlxYXKJyDYEA+Xtap2XE5N0Vsh2ZdUXi7PhxG0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790252498; c=relaxed/simple;
	bh=rTdcO7n0+nshxu9CDu/EDryDUt+kuTOvFiqhnTEqJCg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nnHc/7k8vkAp5hJOoThodNMgab+t/n8cDMIH9wlZtrjcGaa7Br5As2NLhObEtM0kJzOX9h5z30xuyuAPjPIEEGClGHt/fHtvqsusL0vA9SdvMonn8Xa/hBYqja79OpQFc8FcQbpMFfcYJQfF+au/Si6UV6rMigxARXiQYsq4V8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=RCb6mJCl; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="RCb6mJCl"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8687A152B;
	Thu, 24 Sep 2026 05:21:32 -0700 (PDT)
Received: from [10.57.83.110] (unknown [10.57.83.110])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ABA9B3F86C;
	Thu, 24 Sep 2026 05:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790252496; bh=rTdcO7n0+nshxu9CDu/EDryDUt+kuTOvFiqhnTEqJCg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RCb6mJClIL5UcTql5vFcsex7DxOdojrWEOrsuD+03U/8LnEkoU4WGd4NklebN4L/q
	 i8SAcsH8Z8iDp7GOdFsb2I3V0awYWc2PApLoDAD0UXrSVigZDqp90z2XYQLFkm59o6
	 Z+aW0c6kZeCZ6al02l/F0iQ5og5z9BpTFQcoNTnk=
Message-ID: <7a600128-bf10-4966-8c08-129eeec3fb91@arm.com>
Date: Thu, 24 Sep 2026 13:21:29 +0100
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/6] arm64: use hw_pte_val for HW PTE atomics
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
References: <20260922-pte0_arm-v2-0-a3f1ddff0a8a@arm.com>
 <20260922-pte0_arm-v2-2-a3f1ddff0a8a@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20260922-pte0_arm-v2-2-a3f1ddff0a8a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 22/09/2026 18:31, Muhammad Usama Anjum wrote:
> The low-level atomic PTE update paths take the address of
> pte_val(*ptep). That assumes HW PTE storage can be passed directly to
> the SW PTE value accessor and no longer type-checks when hw_pte_t is
> distinct.
> 
> Use hw_pte_val() for the lvalues passed to compare-exchange and exchange
> operations. The atomic operations and their ordering are unchanged.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

> ---
> Chagnes in v2:
> - Remove comment change
> - Move hw_pte_val() to generic series
> ---
>  arch/arm64/include/asm/pgtable.h | 10 +++++-----
>  arch/arm64/mm/fault.c            |  2 +-
>  2 files changed, 6 insertions(+), 6 deletions(-)
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
> index b77f4be88e3ea..3322f4e7174dc 100644
> --- a/arch/arm64/mm/fault.c
> +++ b/arch/arm64/mm/fault.c
> @@ -235,7 +235,7 @@ int __ptep_set_access_flags_anysz(struct vm_area_struct *vma,
>  		pteval ^= PTE_RDONLY;
>  		pteval |= pte_val(entry);
>  		pteval ^= PTE_RDONLY;
> -		pteval = cmpxchg_relaxed(&pte_val(*ptep), old_pteval, pteval);
> +		pteval = cmpxchg_relaxed(&hw_pte_val(*ptep), old_pteval, pteval);
>  	} while (pteval != old_pteval);
>  
>  	/*
> 

