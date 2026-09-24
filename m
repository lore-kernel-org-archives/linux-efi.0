Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C42C47798A;
	Thu, 24 Sep 2026 12:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790252594; cv=none; b=D8xDpyvKNBi6mIJgbafYb66FrjkFMPUl0CbAzgBTe0b1htN6tJ2xm2p5XExWMtq29Bdu/2HW9FM8wZpYTbdocS26fZWFlbNNuSiSdXTplDHDdKuML1AwLGaF86iMX6WXAoQeE90LczfuxqOznMDKWyoIO03Jw1+fFDNfscKYPmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790252594; c=relaxed/simple;
	bh=6RiiprozYmDqlvYaiBGVz8TgL+fPnC8hgT90X3WinvY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s/hdUkE0HqkzI9UTMLQWFT8oxMRmEG6gRbWtJKYkoUAkXhPG7jPZb17KvVrA/iENAQSvISkqzkvjiQAs7+s4cCDoBriNKAl8eeVnSW4db/5HxoMB9RDGvUYrZJl2BHnY16qbOU87tZZ0/wLJNt2JTMCHJDcjkvIhPNrwMHsU8qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=VL2sSYmX; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="VL2sSYmX"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 500FF152B;
	Thu, 24 Sep 2026 05:23:08 -0700 (PDT)
Received: from [10.57.83.110] (unknown [10.57.83.110])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9C5E13F86C;
	Thu, 24 Sep 2026 05:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790252591; bh=6RiiprozYmDqlvYaiBGVz8TgL+fPnC8hgT90X3WinvY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VL2sSYmXUX7Oe1yYpOSWfGPfVESz/LeVs6qkwp1c7ZID3I/9r7KlqFgNVuLSNzCV9
	 EeeFBxAp7V1h25U7R5kNeEy+s+vXRYgfbFAS4N86NhOR8+pYZ62Ffl8B6WkVroZ3GM
	 9+ukhLWw1BwYdiBWnZvL8p/PGxHli+OEN3B4LpSg=
Message-ID: <a37eb779-b180-450c-8691-8d31b9717f16@arm.com>
Date: Thu, 24 Sep 2026 13:23:05 +0100
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/6] arm64: use hw_pte_val for HW PTE loads and stores
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
 <20260922-pte0_arm-v2-3-a3f1ddff0a8a@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20260922-pte0_arm-v2-3-a3f1ddff0a8a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 22/09/2026 18:31, Muhammad Usama Anjum wrote:
> __ptep_get() returns a SW PTE value, while __set_pte_nosync() accepts
> one. When HW PTE storage uses a distinct hw_pte_t, reading or writing
> *ptep as a pte_t no longer satisfies those interfaces.
> 
> Use hw_pte_val() to expose the pteval_t stored in either the hw_pte_t
> wrapper or its pte_t alias. __set_pte_nosync() writes pte_val(pte) to
> that storage, while __ptep_get() reads it and reconstructs a pte_t with
> __pte().
> 
> This avoids imposing a generic conversion interface between HW and SW
> PTE representations, which may require architecture-specific context
> in the future.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

> ---
>  arch/arm64/include/asm/pgtable.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 4768ec59de555..ce6580ab63128 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -360,7 +360,7 @@ static inline pte_t pte_clear_uffd(pte_t pte)
>  
>  static inline void __set_pte_nosync(hw_pte_t *ptep, pte_t pte)
>  {
> -	WRITE_ONCE(*ptep, pte);
> +	WRITE_ONCE(hw_pte_val(*ptep), pte_val(pte));
>  }
>  
>  static inline void __set_pte_complete(pte_t pte)
> @@ -381,7 +381,7 @@ static inline void __set_pte(hw_pte_t *ptep, pte_t pte)
>  
>  static inline pte_t __ptep_get(hw_pte_t *ptep)
>  {
> -	return READ_ONCE(*ptep);
> +	return __pte(READ_ONCE(hw_pte_val(*ptep)));
>  }
>  
>  extern void __sync_icache_dcache(pte_t pteval);
> 

