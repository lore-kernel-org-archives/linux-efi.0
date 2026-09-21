Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42DF333D6D6;
	Mon, 21 Sep 2026 08:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789979372; cv=none; b=fSEz5jqtDUzLoKTZ9I3q1qp/mntu2uCE0dtXwLHpmH7gR8GdavAs9dHkc8rJUUysAbTSNLx4wB/fcNV/Dfkw4NnKjvHl+XXnWv6Sxk+x6ppV5PP8Z8s23Wp00p3/8Qrk9HnV9zjXsGuh/q9B7RAKU4i6VdP3ubPTmr+IEqBwQDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789979372; c=relaxed/simple;
	bh=Ad+6LLybI3uKKc7JJri+UgLlmCgPg2pPlm7qhk4O64g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z+Jdgvbm2N7O+gTbKg7rDUUWf9YPrvsu/LZ1R6i+oeDw+ga749Y9IOg0M9GfMfEwAubV075c+JpnBTiY2j4Tf67QylhkjQvAqOmF/7OTNZrSGS6tt/ZpixDSVtNuBbaHlDaYxVewoegEsTqXiJW35vwwIvpa4qfPi+OwsqeDXT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qRXpyMvL; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qRXpyMvL"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2EA8E175A;
	Mon, 21 Sep 2026 01:29:27 -0700 (PDT)
Received: from [10.57.83.12] (unknown [10.57.83.12])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1ECEC3F86C;
	Mon, 21 Sep 2026 01:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789979370; bh=Ad+6LLybI3uKKc7JJri+UgLlmCgPg2pPlm7qhk4O64g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qRXpyMvLHNueHE/qqmGi8wywc91oBqnC1xt/cQExQtagrEoU13hb8I0V89H6Lao7G
	 3OHXj+U/lHUmAJ/1SxkKWWapIqk0qrE9EAGWElpxtagB8APekzbYKUgqjO/U1aCgBH
	 42zSHCFhDH+OJ9duPe2mk552i7cOLu0tCTw7I4I0=
Message-ID: <f790350a-02eb-46b2-b079-fc3db66f2b03@arm.com>
Date: Mon, 21 Sep 2026 09:29:25 +0100
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/6] arm64: use hw_pte_t for fixmap HW PTEs
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
 <20260914-pte0_arm-v1-4-bb53b663e396@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20260914-pte0_arm-v1-4-bb53b663e396@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14/09/2026 14:51, Muhammad Usama Anjum wrote:
> fixmap_pte() returns a pointer into bm_pte, and early_fixmap_init_pte()
> installs those arrays as page tables. Their elements are therefore
> HW PTEs.
> 
> Change the element type of bm_pte to hw_pte_t so it matches the HW PTE
> pointers returned and passed to the accessors. This is needed before
> ARCH_HAS_HW_PTE_T makes HW PTEs and SW PTE values distinct types; the
> array dimensions and placement are unchanged.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
>  arch/arm64/mm/fixmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/mm/fixmap.c b/arch/arm64/mm/fixmap.c
> index 237a9136bc73b..709a97fe327d8 100644
> --- a/arch/arm64/mm/fixmap.c
> +++ b/arch/arm64/mm/fixmap.c
> @@ -31,7 +31,7 @@ static_assert(NR_BM_PMD_TABLES == 1);
>  
>  #define BM_PTE_TABLE_IDX(addr)	__BM_TABLE_IDX(addr, PMD_SHIFT)
>  
> -static pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __bss_pgtbl;
> +static hw_pte_t bm_pte[NR_BM_PTE_TABLES][PTRS_PER_PTE] __bss_pgtbl;
>  static pmd_t bm_pmd[PTRS_PER_PMD] __bss_pgtbl __maybe_unused;
>  static pud_t bm_pud[PTRS_PER_PUD] __bss_pgtbl __maybe_unused;
>  
> 

Ahh, so my previous comment that I thought this would break the build is wrong
because you haven't enabled ARCH_HAS_HW_PTE_T at that point.

Thanks,
Ryan
