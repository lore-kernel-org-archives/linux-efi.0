Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C828E3EFD2D;
	Mon, 21 Sep 2026 08:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789979226; cv=none; b=RL11E5Pj0wgNTiCnQOahdDmlisKXvx1cV8aBFwoAMKFEjfNbNZa9QxMA8XI0/NPZ4z7cqEZh1VOAAN2BOCGXlLQruR/BAYIHBGLnpqhuetQEE5Noc5Wbap6NinAVGhkaeJ4KUDm/UPBGGrdrqGyJinilyhAupSo16x7elvhvzWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789979226; c=relaxed/simple;
	bh=DAIFdbL4xzUIu7ZahFa8TI9VqSq7uJsS8lo7ckS9dpo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TVO5As36gT9J7dREmf0vTOi6KD11eFYbhdsk2iNugAcdgTq85uoc4nmNVSYAcHeI5VIZNb/7GAhJQSowtuLyjsvsX5wWCsk08dZOLttjDVDvIx7mf6Em1/2vpOrnKEX4C8HYAl2K+2HaxM8rCXvjdd8hcyXkthRpOvW3ooi0pjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=a1hlKdD8; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="a1hlKdD8"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B812175A;
	Mon, 21 Sep 2026 01:27:00 -0700 (PDT)
Received: from [10.57.83.12] (unknown [10.57.83.12])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E68713F86C;
	Mon, 21 Sep 2026 01:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789979224; bh=DAIFdbL4xzUIu7ZahFa8TI9VqSq7uJsS8lo7ckS9dpo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=a1hlKdD8fyjBw+8gF3G8WZAD/mIi7EKGmaNrH8A7prWIORzqTVcC/DXPhIZ79c7vn
	 1vU1HYe/zUy8NNZfs3ZXkTmRkRKFCHIJuXnY3zhDPle3JQVTsugXbliOskfQjOZptF
	 UV56/60hoTzYfzFhV6U3gOs8WqSzLGS6eD578weE=
Message-ID: <86d4aea6-4272-427e-9229-295489e068d7@arm.com>
Date: Mon, 21 Sep 2026 09:26:58 +0100
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] arm64: convert between HW PTEs and SW PTE values
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
 <20260914-pte0_arm-v1-3-bb53b663e396@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20260914-pte0_arm-v1-3-bb53b663e396@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14/09/2026 14:51, Muhammad Usama Anjum wrote:
> __ptep_get() returns a SW PTE value, and __set_pte_nosync() accepts one.
> When HW PTEs use a distinct hw_pte_t, directly reading or writing *ptep
> as a SW PTE value no longer satisfies those interfaces.
> 
> Use __pte_from_hw after READ_ONCE() to obtain a SW PTE value and add
> __hw_pte before WRITE_ONCE() to form an HW PTE.
> 
> Define __hw_pte for both the wrapper and alias configurations so the
> same accessor code works in either case.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
>  arch/arm64/include/asm/pgtable.h | 4 ++--
>  include/linux/pgtable_types.h    | 2 ++
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 4768ec59de555..67c4a6179e154 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -360,7 +360,7 @@ static inline pte_t pte_clear_uffd(pte_t pte)
>  
>  static inline void __set_pte_nosync(hw_pte_t *ptep, pte_t pte)
>  {
> -	WRITE_ONCE(*ptep, pte);
> +	WRITE_ONCE(*ptep, __hw_pte(pte));

Would this work as an alternative? It removes the need for the new __hw_pte()
helper. In future, converting a pte_t to a hw_pte_t won't be trivial so having a
generic helper for it doesn't feel like a good fit.

	WRITE_ONCE(hw_pte_val(*ptep), pte_val(pte));

In general, I wonder if we should avoid defining both the __hw_pte() and
__pte_from_hw() generic helpers. Conversion between sw and hw representations
will become arch-specific in future and for arm64 that conversion will need
extra information so it's can't just specialize these interfaces as they are.

>  }
>  
>  static inline void __set_pte_complete(pte_t pte)
> @@ -381,7 +381,7 @@ static inline void __set_pte(hw_pte_t *ptep, pte_t pte)
>  
>  static inline pte_t __ptep_get(hw_pte_t *ptep)
>  {
> -	return READ_ONCE(*ptep);
> +	return __pte_from_hw(READ_ONCE(*ptep));


...Corresponds with:

	return __pte(READ_ONCE(hw_pte_val(*ptep)));

Thanks,
Ryan

>  }
>  
>  extern void __sync_icache_dcache(pte_t pteval);
> diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
> index ee4eace5c3e1c..b5862a16aa497 100644
> --- a/include/linux/pgtable_types.h
> +++ b/include/linux/pgtable_types.h
> @@ -9,11 +9,13 @@
>  #ifdef CONFIG_ARCH_HAS_HW_PTE_T
>  typedef struct __hw_pte_t { pte_t __pte; } hw_pte_t;
>  #define __pte_from_hw(pte)	((pte).__pte)
> +#define __hw_pte(pte)  ((hw_pte_t) { (pte) })
>  
>  #define hw_pte_val(x)  pte_val((x).__pte)
>  #else
>  #define hw_pte_t pte_t
>  #define __pte_from_hw(pte)	(pte)
> +#define __hw_pte(pte)  (pte)
>  
>  #define hw_pte_val(x)  pte_val(x)
>  #endif
> 

