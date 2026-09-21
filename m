Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADB2144AB82;
	Mon, 21 Sep 2026 08:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789977602; cv=none; b=LtcIY9mtYjD/UBFaws99HkWzYgyCiqcEw7Ke1Q7y1NSJwwKdaX7Z2V+x+eVWM1+GprEenfUAACXqZ8cJGa0E08O4Xf3QndQvWx97NVuKpcZ+BCL51hDUbmuQ1FwOFHTKX7upEz74tZCm29jeww/8u7bLUxBtFRSpIhmT6Npxb+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789977602; c=relaxed/simple;
	bh=uRgzAnJkCmIi+snQIbSmkHF+wLnwLOyY5X1yVPOvLlY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BoDv2OWc0Ug+6EGyq4rBU4mZL8z0ZSvgykTbRpb8xLFPxzgbunxfWYCK2Rpig8FFHvVmc7IJPVNrTKZuhdc09wRa5xv6bgUqUsHEpkB4Uh0Y7JE+E7amZ4DXbtnlIbdtxd4agEjaP9AHD/SAL8zk0IXeqdjokqCs5FyxIGYT760=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=oOow57Ti; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="oOow57Ti"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3D9E7143D;
	Mon, 21 Sep 2026 00:59:56 -0700 (PDT)
Received: from [10.57.83.12] (unknown [10.57.83.12])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EC76C3F86F;
	Mon, 21 Sep 2026 00:59:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789977599; bh=uRgzAnJkCmIi+snQIbSmkHF+wLnwLOyY5X1yVPOvLlY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oOow57TiAT2tB/NkK8hmGQp1DapcKPuzLjk1RccTkIyvjhT+W62/wiLiQQhfRtFKc
	 4KXMyKWVtD0nlgizdDb0ZyrNReJpgNSJDCbQsOVPjvF3xkgEDDT/Lgpbx6mFtal5hX
	 fPGGW5nNp3gYVFvgixCsuIVC77t3fq9WFJPKKwuc=
Message-ID: <3e3e8b33-cf24-4b09-a64c-f9b2bbe604e7@arm.com>
Date: Mon, 21 Sep 2026 08:59:53 +0100
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] arm64: use hw_pte_t for HW PTE pointers
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
 <20260914-pte0_arm-v1-1-bb53b663e396@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20260914-pte0_arm-v1-1-bb53b663e396@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14/09/2026 14:51, Muhammad Usama Anjum wrote:
> With pte_t * used for HW PTE pointers, the compiler cannot distinguish
> them from SW PTE value pointers. The generic HW PTE interfaces already
> use hw_pte_t *, so arm64 HW PTE pointers must use that type before
> ARCH_HAS_HW_PTE_T can make it distinct.
> 
> Convert HW PTE pointers to hw_pte_t *, retaining pte_t for SW PTE
> values. Helpers shared with PMD and PUD operations keep explicit casts
> because this series does not introduce distinct entry types for those
> levels.
> 
> arm64 still uses the hw_pte_t alias in this patch. The new pointer
> spelling therefore denotes the same type until the final opt-in.
> 
> Include linux/pgtable_types.h in pi.h to make hw_pte_t visible.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
>  arch/arm64/include/asm/hugetlb.h  |  19 ++---
>  arch/arm64/include/asm/pgalloc.h  |   2 +-
>  arch/arm64/include/asm/pgtable.h  | 143 ++++++++++++++++++++------------------
>  arch/arm64/include/asm/vmalloc.h  |   2 +-
>  arch/arm64/kernel/efi.c           |   3 +-
>  arch/arm64/kernel/pi/map_kernel.c |   4 +-
>  arch/arm64/kernel/pi/map_range.c  |   9 +--
>  arch/arm64/kernel/pi/pi.h         |   3 +-
>  arch/arm64/mm/contpte.c           |  49 +++++++------
>  arch/arm64/mm/fault.c             |   5 +-
>  arch/arm64/mm/fixmap.c            |   6 +-
>  arch/arm64/mm/hugetlbpage.c       |  48 +++++++------
>  arch/arm64/mm/kasan_init.c        |   4 +-
>  arch/arm64/mm/mmu.c               |  46 +++++++-----
>  arch/arm64/mm/pageattr.c          |   4 +-
>  arch/arm64/mm/trans_pgd.c         |   4 +-
>  16 files changed, 190 insertions(+), 161 deletions(-)
> 

[...]

> diff --git a/arch/arm64/mm/fixmap.c b/arch/arm64/mm/fixmap.c
> index f66a0016dd02d..237a9136bc73b 100644
> --- a/arch/arm64/mm/fixmap.c
> +++ b/arch/arm64/mm/fixmap.c
> @@ -35,7 +35,7 @@ static pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __bss_pgtbl;
>  static pmd_t bm_pmd[PTRS_PER_PMD] __bss_pgtbl __maybe_unused;
>  static pud_t bm_pud[PTRS_PER_PUD] __bss_pgtbl __maybe_unused;
>  
> -static inline pte_t *fixmap_pte(unsigned long addr)
> +static inline hw_pte_t *fixmap_pte(unsigned long addr)
>  {
>  	return &bm_pte[BM_PTE_TABLE_IDX(addr)][pte_index(addr)];

How does this work, given you haven't yet converted bm_pte? You're returning a
pte_t* where you need a hw_pte_t*. Either the compiler is implicitly converting
(which would defeat the whole purpose of this series) or this patch doesn't
compile until you convert bm_pte later on (which I suspect is more likely).

>  }
> @@ -43,7 +43,7 @@ static inline pte_t *fixmap_pte(unsigned long addr)
>  static void __init early_fixmap_init_pte(pmd_t *pmdp, unsigned long addr)
>  {
>  	pmd_t pmd = READ_ONCE(*pmdp);
> -	pte_t *ptep;
> +	hw_pte_t *ptep;
>  
>  	if (pmd_none(pmd)) {
>  		ptep = bm_pte[BM_PTE_TABLE_IDX(addr)];

Same problem here?

Thanks,
Ryan

