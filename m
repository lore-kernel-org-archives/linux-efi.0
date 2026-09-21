Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 700A2136351;
	Mon, 21 Sep 2026 09:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789983864; cv=none; b=aNvkmSw5BBR+lVdRJzWv2IT0sUyES7YGj7A1P1qym7DOs6zgx+8fgf2ZiWRMCVYBjupLgNf3rTq6PtFh3g+sgPXop2YP6MQsyrWSS6tOluVebzrCpeeiRbNy5aP9kHhTwK6ErpnGOOLkxMmWaLFQDFpkVfGR/QmeHdTsIM76BtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789983864; c=relaxed/simple;
	bh=QGwc+dAkTPXAJc9o4T5hZxy9BZq11nu1Z0f1P5saI/Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vb+1PhLCIXCogOszJaqt2eTdh7uT9yNkPQYtNy+W5PrRwNwr28j3oA4ySe9bFEoGteCkIltCW+PT+6ZewhkLNNArm5J3frTKHmx/Sq8BYkSX+bLJo+eNBkyai6E2iXrq+chq2AUVaQvSnyxyatgUIbA4yQe5ILpFe7nU24S+tdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=qwUc8yek; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="qwUc8yek"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2998F153B;
	Mon, 21 Sep 2026 02:44:18 -0700 (PDT)
Received: from [10.57.83.12] (unknown [10.57.83.12])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7468D3F86F;
	Mon, 21 Sep 2026 02:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789983861; bh=QGwc+dAkTPXAJc9o4T5hZxy9BZq11nu1Z0f1P5saI/Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qwUc8yekPnle5iyolREB22nxPCxek0508Oh9aZKHTFLruu7FqF8h71LWhAgNuw5e8
	 QO8MRf3saEnhCc9HduCxILbEzWErOEEfJEa25crNaoG3YkHcqnb9MTAiu+kCe9UwNQ
	 wWUie9GNe6r5o8kHoxX5FXP83fHJqGFNHbtOiC5c=
Message-ID: <89d44eaa-2ea8-478a-8a39-af91373485fb@arm.com>
Date: Mon, 21 Sep 2026 10:44:15 +0100
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] arm64: use HW PTE accessors in early map_range()
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
 <20260914-pte0_arm-v1-5-bb53b663e396@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20260914-pte0_arm-v1-5-bb53b663e396@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14/09/2026 14:51, Muhammad Usama Anjum wrote:
> map_range() uses HW PTE pointers to build early translation tables at
> each level. Directly testing, decoding, or assigning *tbl treats an
> HW PTE as a SW PTE value, which requires explicit conversion once
> hw_pte_t becomes distinct.
> 
> Use __ptep_get() to load a SW PTE value for the empty-entry check and
> child-table address, and __set_pte_nosync() to convert SW PTE values to
> HW PTEs on stores. The no-sync helper performs WRITE_ONCE() without
> adding the completion barriers used by __set_pte().
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

> ---
>  arch/arm64/kernel/pi/map_range.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kernel/pi/map_range.c b/arch/arm64/kernel/pi/map_range.c
> index 94f06da76e333..9c4c8060c5df4 100644
> --- a/arch/arm64/kernel/pi/map_range.c
> +++ b/arch/arm64/kernel/pi/map_range.c
> @@ -51,19 +51,21 @@ void __init map_range(phys_addr_t *pte, u64 start, u64 end, phys_addr_t pa,
>  
>  	while (start < end) {
>  		u64 next = min((start | lmask) + 1, PAGE_ALIGN(end));
> +		pte_t entry = __ptep_get(tbl);
>  
>  		if (level < 2 || (level == 2 && (start | next | pa) & lmask)) {
>  			/*
>  			 * This chunk needs a finer grained mapping. Create a
>  			 * table mapping if necessary and recurse.
>  			 */
> -			if (pte_none(*tbl)) {
> -				*tbl = __pte(__phys_to_pte_val(*pte) |
> +			if (pte_none(entry)) {
> +				entry = __pte(__phys_to_pte_val(*pte) |
>  					     PMD_TYPE_TABLE | PMD_TABLE_UXN);
> -				*pte += PTRS_PER_PTE * sizeof(pte_t);
> +				__set_pte_nosync(tbl, entry);
> +				*pte += PTRS_PER_PTE * sizeof(hw_pte_t);
>  			}
>  			map_range(pte, start, next, pa, prot, level + 1,
> -				  (hw_pte_t *)(__pte_to_phys(*tbl) + va_offset),
> +				  (hw_pte_t *)(__pte_to_phys(entry) + va_offset),
>  				  may_use_cont, va_offset);
>  		} else {
>  			/*
> @@ -81,7 +83,8 @@ void __init map_range(phys_addr_t *pte, u64 start, u64 end, phys_addr_t pa,
>  				protval &= ~PTE_CONT;
>  
>  			/* Put down a block or page mapping */
> -			*tbl = __pte(__phys_to_pte_val(pa) | protval);
> +			entry = __pte(__phys_to_pte_val(pa) | protval);
> +			__set_pte_nosync(tbl, entry);
>  		}
>  		pa += next - start;
>  		start = next;
> 

