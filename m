Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143ED3DCD9B;
	Wed, 18 Mar 2026 14:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773843424; cv=none; b=aHXaoAosOgTWfeHuTeQZPqrsD8FlEC6tpBfiLUGVGcajB0et9c656qbDovkAAFrOM0ljMcqUVcODsTuo3tRT5jgbockj4Woo30czX17l5OjJpmsRv+KVcEhOLrNtSu4zbVC23OEzmx+Zo3MSLClAbgMcvhg8BEjxxcOjp1Pf5S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773843424; c=relaxed/simple;
	bh=Nka2tAu2xfrAzh/LVz+kPzjJGV26abtbTSAN+jQ1zCs=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=HazUw2u3FVdjMMxhzhgw+rx2TUXsyEa4z2lFarn7QQUHQHcsKLkb3XOBURWg0pImJzGFC3Wll48aCvthROLT/cia+bW7IBSJJaEc9dmaFAMSMC8NwkCFnV3V9rC3WV0MpIghX6i2IqkG0AMFRl7cqKBxhSkxmUhGE+uCN2SpMVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l2n98eIW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l2n98eIW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B834CC19421;
	Wed, 18 Mar 2026 14:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773843423;
	bh=Nka2tAu2xfrAzh/LVz+kPzjJGV26abtbTSAN+jQ1zCs=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=l2n98eIWgaO3CjkFjgd0Sou85/DdxxIF5f5x0NNXjCnRCCUzjcWJiinkayJ878aww
	 BMJ0pXZVJUefOLLhpj2fMemzle19sO2O1t5wBOu4oWg54p9ZGJdEhdeS/Czy9hnQXA
	 eulz6Qr5rpmd86XRFktfVxpPiPuG0bWwvXiusqCzjYmb/h8nhtFZfXIiV7SJql6pbr
	 L4xv+2VnZl426NR2cd+2lb906X8FppURSFBE0mng0zk5Fvon36cCbedPT6Sf5MOPBk
	 nKWZjGbed3op7zsa/QhDxrRfMTA0/5KlsKm4GWT7flFR84ReuRSkL4lH9ODOoxK1Dd
	 vepd5z1nkYYfQ==
Message-ID: <11428d25-7bea-4be6-a6ee-bfeac1d50807@kernel.org>
Date: Wed, 18 Mar 2026 15:16:52 +0100
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH 3/8] mm: move free_reserved_area() to mm/memblock.c
Content-Language: en-US
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Andreas Larsson <andreas@gaisler.com>, Ard Biesheuvel <ardb@kernel.org>,
 Borislav Petkov <bp@alien8.de>, Brendan Jackman <jackmanb@google.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Christian Brauner <brauner@kernel.org>, "David S. Miller"
 <davem@davemloft.net>, Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.cz>,
 Johannes Weiner <hannes@cmpxchg.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Marco Elver <elver@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Masami Hiramatsu <mhiramat@kernel.org>, Michael Ellerman
 <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Rob Herring <robh@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
 Saravana Kannan <saravanak@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Will Deacon <will@kernel.org>, Zi Yan <ziy@nvidia.com>,
 devicetree@vger.kernel.org, iommu@lists.linux.dev,
 kasan-dev@googlegroups.com, linux-arm-kernel@lists.infradead.org,
 linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, x86@kernel.org
References: <20260318105827.1358927-1-rppt@kernel.org>
 <20260318105827.1358927-4-rppt@kernel.org>
In-Reply-To: <20260318105827.1358927-4-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/18/26 11:58, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> free_reserved_area() is related to memblock as it frees reserved memory
> back to the buddy allocator, similar to what memblock_free_late() does.
> 
> Move free_reserved_area() to mm/memblock.c to prepare for further
> consolidation of the functions that free reserved memory.
> 
> No functional changes.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


> ---
>  mm/memblock.c   | 37 ++++++++++++++++++++++++++++++++++++-
>  mm/page_alloc.c | 36 ------------------------------------
>  2 files changed, 36 insertions(+), 37 deletions(-)
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index b3ddfdec7a80..8f3010dddc58 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -893,6 +893,42 @@ int __init_memblock memblock_remove(phys_addr_t base, phys_addr_t size)
>  	return memblock_remove_range(&memblock.memory, base, size);
>  }
>  
> +unsigned long free_reserved_area(void *start, void *end, int poison, const char *s)
> +{
> +	void *pos;
> +	unsigned long pages = 0;
> +
> +	start = (void *)PAGE_ALIGN((unsigned long)start);
> +	end = (void *)((unsigned long)end & PAGE_MASK);
> +	for (pos = start; pos < end; pos += PAGE_SIZE, pages++) {
> +		struct page *page = virt_to_page(pos);
> +		void *direct_map_addr;
> +
> +		/*
> +		 * 'direct_map_addr' might be different from 'pos'
> +		 * because some architectures' virt_to_page()
> +		 * work with aliases.  Getting the direct map
> +		 * address ensures that we get a _writeable_
> +		 * alias for the memset().
> +		 */
> +		direct_map_addr = page_address(page);
> +		/*
> +		 * Perform a kasan-unchecked memset() since this memory
> +		 * has not been initialized.
> +		 */
> +		direct_map_addr = kasan_reset_tag(direct_map_addr);
> +		if ((unsigned int)poison <= 0xFF)
> +			memset(direct_map_addr, poison, PAGE_SIZE);
> +
> +		free_reserved_page(page);
> +	}
> +
> +	if (pages && s)
> +		pr_info("Freeing %s memory: %ldK\n", s, K(pages));
> +
> +	return pages;
> +}
> +
>  /**
>   * memblock_free - free boot memory allocation
>   * @ptr: starting address of the  boot memory allocation
> @@ -1776,7 +1812,6 @@ void __init memblock_free_late(phys_addr_t base, phys_addr_t size)
>  		totalram_pages_inc();
>  	}
>  }
> -
>  /*
>   * Remaining API functions
>   */
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 2d4b6f1a554e..df3d61253001 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6234,42 +6234,6 @@ void adjust_managed_page_count(struct page *page, long count)
>  }
>  EXPORT_SYMBOL(adjust_managed_page_count);
>  
> -unsigned long free_reserved_area(void *start, void *end, int poison, const char *s)
> -{
> -	void *pos;
> -	unsigned long pages = 0;
> -
> -	start = (void *)PAGE_ALIGN((unsigned long)start);
> -	end = (void *)((unsigned long)end & PAGE_MASK);
> -	for (pos = start; pos < end; pos += PAGE_SIZE, pages++) {
> -		struct page *page = virt_to_page(pos);
> -		void *direct_map_addr;
> -
> -		/*
> -		 * 'direct_map_addr' might be different from 'pos'
> -		 * because some architectures' virt_to_page()
> -		 * work with aliases.  Getting the direct map
> -		 * address ensures that we get a _writeable_
> -		 * alias for the memset().
> -		 */
> -		direct_map_addr = page_address(page);
> -		/*
> -		 * Perform a kasan-unchecked memset() since this memory
> -		 * has not been initialized.
> -		 */
> -		direct_map_addr = kasan_reset_tag(direct_map_addr);
> -		if ((unsigned int)poison <= 0xFF)
> -			memset(direct_map_addr, poison, PAGE_SIZE);
> -
> -		free_reserved_page(page);
> -	}
> -
> -	if (pages && s)
> -		pr_info("Freeing %s memory: %ldK\n", s, K(pages));
> -
> -	return pages;
> -}
> -
>  void free_reserved_page(struct page *page)
>  {
>  	clear_page_tag_ref(page);

