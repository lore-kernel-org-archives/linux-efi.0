Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E9E94756B1;
	Thu, 24 Sep 2026 12:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790252618; cv=none; b=KIq1go0s73J/URiT4ZUNnK+KmeX/TMC1OJAmwqyITJoX9dXjdL62o+EBAznQAMJ2uwlWTA+a8b3YSB9TO4PM/Kqhd+2bL+Ktk4sV6BR2wukUoSZSRxXAM1JB3ZgLM/ruUGSP5zoLu8iKwitKgJXJM15haXInRxC0O5AWedHUu2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790252618; c=relaxed/simple;
	bh=vNFe6jSuDfebOXCmwmWjYhSTK+XatMTN9IVuzrYWanA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DLXQDFsS1BdTdbA0Lnvbde17h3mAkm2p/0V0uwoHy92PjxaY1K0ZmpuIPVFBC+vFpK6VEIJqVKJpg9EqUZpJ7MgW2SNCC6fhGI0SIc2v9k/L3yHTyzq7CQPXqQF7bIjMZD/gRn0Fw3ZO80amKhHXUdThd5E3T+qMEvpmkBXR7eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=CjAMiE95; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="CjAMiE95"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB5CA152B;
	Thu, 24 Sep 2026 05:23:32 -0700 (PDT)
Received: from [10.57.83.110] (unknown [10.57.83.110])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 18B033F86C;
	Thu, 24 Sep 2026 05:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790252616; bh=vNFe6jSuDfebOXCmwmWjYhSTK+XatMTN9IVuzrYWanA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CjAMiE950CD1likYhHHG2G4IDbslsFxD3Qsg7M0c/rEsrgq0shMN5wyePSHulDU5w
	 ntAkjL3I4uXuHGdNdSZtQIh7Vvcbnn+grI4a/YnTyOemiulO6PNQz2yAZroktlQqkM
	 rzbMuwv+8zjiPVV8HIZ6jKyW0OBl55PjEDIZxndo=
Message-ID: <27c9b227-9dae-4263-be10-2c6089f8f425@arm.com>
Date: Thu, 24 Sep 2026 13:23:30 +0100
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/6] arm64: use hw_pte_t for fixmap HW PTEs
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
 <20260922-pte0_arm-v2-4-a3f1ddff0a8a@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20260922-pte0_arm-v2-4-a3f1ddff0a8a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 22/09/2026 18:31, Muhammad Usama Anjum wrote:
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

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

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

