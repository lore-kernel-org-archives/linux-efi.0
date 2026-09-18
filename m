Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27FC2502543;
	Fri, 18 Sep 2026 16:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789747444; cv=none; b=KfXIFWiOIjNOHF4eFVyGk8TPjdBNLKHaZkFrMmi4K+l+wqgNFzFPme6Atsr+tflK6rFM7eZuC3/DPNuMhrPOuFeS1mFPb3zoCt+30AY4OA4T9ZYW3HSvfWhdS0o2UjEKKgy9/kOSEfr9S1JnY+Cg3OhPBCnCFO9eR2XXk6NAO6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789747444; c=relaxed/simple;
	bh=3do1fHEhpJFdddOzJMwgsSk4W5z16/aVCPPb79+UaWw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=P0X7u6WKmIpfya2u/7fim/wQG8EA4qaL2Mm28Dn9iPH99KajUYNn/yIWQzhTAg5rMrZYQT81CniF6FCO3qLiQcdX+8OlSF+F6h/8ow4ZDbnFmzWmN/emAxTtqWV1m+tsv7zE91OpNxKCbU0fZmh/z7d6+5tHb5MGwMSiqlSjINk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ursaNtXT; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ursaNtXT"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CFE92168F;
	Fri, 18 Sep 2026 09:03:57 -0700 (PDT)
Received: from [10.57.83.108] (unknown [10.57.83.108])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 610943F86C;
	Fri, 18 Sep 2026 09:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789747441; bh=3do1fHEhpJFdddOzJMwgsSk4W5z16/aVCPPb79+UaWw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ursaNtXTCcqbQPlZcHlBtigESNoL8DsKRECG9Iqdkj3jgziA1On9agLeueKYJUzMZ
	 VBJ8HQsbSdEVCjUBsfg35q+YGoQJpkq7G15flXI6Y15UjIywcb2nq3FBSi+KTOFB0D
	 3OmrnfLX3muvFaMq+V/9S6YL7WX2+/DW0/+tjQys=
Message-ID: <829523cd-85a4-4f8e-b9f2-f3c1d7ce4fb1@arm.com>
Date: Fri, 18 Sep 2026 17:03:55 +0100
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

I think in my original proposal it was impossible to have a hw_pte value; only a
hw_pte pointer was possible. Being able to create hw_pte values means that it is
possible that a hw_pte_t pointer is not actually pointing to an entry in a HW
pgtable. The main motivation for this is that we want to dereference neighbours
of a hw pte based on it's pointer and be confident that it is safe. I think this
removes some of the safety.

Clearly in this instance, bm_pte is still defined such that we have an aligned
page worth of ptes, so its ok. I'm just concerned about the potential for
changes that don't follow the rules (and don't get picked up by the compiler) in
future.

I guess that's the trade off for having something that looks like a pointer
instead of an opaque handle.

Thanks,
Ryan

>  static pmd_t bm_pmd[PTRS_PER_PMD] __bss_pgtbl __maybe_unused;
>  static pud_t bm_pud[PTRS_PER_PUD] __bss_pgtbl __maybe_unused;
>  
> 

