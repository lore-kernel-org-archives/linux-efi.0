Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792686827;
	b=FILeOmPX1UHuAZ/Q3+bsGEQypA1KzzrPz3RJ0ANKmjRD8wVtz87/e0eWMafThSbnwaYR
	 9vWqMenHTcdHVVXCebUvmHH4yufKIam4/1py1xRr80C85hsJba+R48w5KiXWvV+758Ne7
	 laB4UQsLkIHF7yH6Q2GjKht6sVfjORLU0glPSNiUVt8jghEPBvwiL+W92bY+bj2xwgqoh
	 8vBP8ke+i9+HS6pDT/ItlbZnEWGAS6xBrylUR3WCyZEFMdDDZtHkcSRPJI4Mf7Y7I2YTu
	 BtYEztfPdHCs3/C3ITu6q/UZ6SL2l9yjgtCJuitLk1s4gawL1sShmqo7EDBThxzG80w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792686827;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=LpR8WjbHXVeMxwxDz6y1I6beOL7GiQQlFjax9WUKfwY=;
	b=CIjnqrSmeet+M1c13muhx4B30LprQaLaGpqyDeAu/XMy/KO6vfALOVSbs1D2RPFYR5xm
	 kRLI91BQNLH0NcRbGU7/YGzXhEUIyDXguNLLHLs2A6Raq9UadQXDU0w9pWoge/VN0uALL
	 lRzCkmi9UaH+y4yyWCn9GFzGhIyIa4IfzdKInpLEacPIJqvdqJxWx21Qtr3hvwJjrjerz
	 /dpMvBJMNEPreTFb6LKYkbV37JxhmUGy3aMGeDW4aWLd+DjHoWTrpqlAJPD1T9PK5Urg7
	 NCWWP3tfcn7pbphzgPjj6mA0H5mGVxsP5Wq4fZ6IQUtTdeyAu94f85xFkzipBqBdO1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mGfY8uhP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2AB606A319;
	Thu, 22 Oct 2026 16:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mGfY8uhP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B02A1F01829;
	Thu, 22 Oct 2026 16:33:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792686826;
	bh=LpR8WjbHXVeMxwxDz6y1I6beOL7GiQQlFjax9WUKfwY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mGfY8uhP+J1OJ9zOd5vQO36o8Wtj2BKL2APMuWGIC1cKOoGyd3aiCDYeTt4Gsq3tC
	 9wXhZz0su8A5X+82eVyls0J/MGt75DSJppM7sPC+XEv2TLKOuaTikGmV7QgdraLnGZ
	 vkAy2Fmk4wbXqQXys4jSqCBoGBqDYPRFLG0ZepiY3Lnu19OpQu08AT4M3IuLe27XCR
	 BbEDwunBo5rtR/xnN9r7vgcCmuo5sQWEOm/p6+ZoGp4jxVpmkpZVCI25CS++SfNELW
	 VKhWfwvhgrVX+NzJMZN0QCs+G3NKs39w3UCmsAOcZRC5iJrmYi621k35bc8gy9X9Qz
	 IeqViBIxxtuzA==
Date: Thu, 22 Oct 2026 19:33:30 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	kas@kernel.org, kexec@lists.infradead.org,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	shakeel.butt@linux.dev, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, rmikey@meta.com,
	riel@surriel.com, harry@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v6 4/7] mm/memblock: add a reserved-region flag for
 poisoned frames
Message-ID: <ato62palTbNjLwN7@kernel.org>
References: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
 <20261016-hwpoison-kho-v6-4-f304255147da@debian.org>
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016-hwpoison-kho-v6-4-f304255147da@debian.org>

Hi Breno,

On Fri, Oct 16, 2026 at 05:15:44AM -0700, Breno Leitao wrote:
> memblock allocates from and frees to buddy whatever is not reserved, and
> knows nothing about frames an earlier kernel found hardware-poisoned.
> Such a frame can back the memmap, a page table or a percpu area before
> any hwpoison code runs, and otherwise reaches the buddy allocator like
> any other free frame.
> 
> Add MEMBLOCK_RSRV_HWPOISON for a reserved range holding those frames.

How much this would fragment memblock.reserved?

memblock is not very scalable, to say the least, and each new flag
increases the size of memblock arrays which obviously hurts performance.

Do you have some statistics how many regions would be created for the
poisoned ranges?

> memblock neither allocates from a flagged range nor frees it to buddy.
> memmap_init_reserved_pages() initializes its struct pages like any other
> reserved range, including above first_deferred_pfn, but flags the RAM
> frames PG_hwpoison instead of PG_reserved. That is the state of a frame
> poisoned by this kernel. Holes in the range stay reserved.
> 
> PG_reserved is left clear on purpose. page_is_unmovable() treats a
> reserved page as unmovable but skips a counted PG_hwpoison one, so a
> memory block holding an inherited frame can still be offlined.
> 
> memblock_reserve_hwpoison() is the entry point. It is best effort. Until
> the reserved array can be resized it keeps spare slots for the
> reservations that must not fail. It flags only what no earlier
> reservation covers, a kexec segment for one: that was placed around the
> bad frames, and memblock_add_range() would warn about the overlap. A page
> shared with such a reservation stays with it, so no page is flagged
> twice.
> 
> It returns 0 only when every free part of the range is reserved. If any
> part cannot be reserved it returns an error, even when another part was.
> 
> Name the flag in the debugfs flag table. MEMBLOCK_RSRV_HUGETLB gets a
> name too: it has none, and would be left as a NULL slot below the new
> flag, which memblock_debug_show() passes on to seq_puts().
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  include/linux/memblock.h | 10 ++++++
>  mm/memblock.c            | 80 +++++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 89 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/memblock.h b/include/linux/memblock.h
> index aa845f488327f2..86755be249666d 100644
> --- a/include/linux/memblock.h
> +++ b/include/linux/memblock.h
> @@ -52,6 +52,8 @@ extern unsigned long long max_possible_pfn;
>   * kernel that we know is good to use. It is the only memory that
>   * allocations may happen from in this phase.
>   * @MEMBLOCK_RSRV_HUGETLB: memory is reserved for hugetlb pages
> + * @MEMBLOCK_RSRV_HWPOISON: reserved memory region holding frames an earlier
> + * kernel found to be hardware-poisoned.
>   */
>  enum memblock_flags {
>  	MEMBLOCK_NONE		= 0x0,	/* No special request */
> @@ -63,6 +65,7 @@ enum memblock_flags {
>  	MEMBLOCK_RSRV_KERN	= 0x20,	/* memory reserved for kernel use */
>  	MEMBLOCK_KHO_SCRATCH	= 0x40,	/* scratch memory for kexec handover */
>  	MEMBLOCK_RSRV_HUGETLB	= 0x80, /* memory reserved for hugetlb pages */
> +	MEMBLOCK_RSRV_HWPOISON	= 0x100, /* poisoned by an earlier kernel */
>  };
>  
>  /**
> @@ -142,6 +145,8 @@ static __always_inline int memblock_reserve_kern(phys_addr_t base, phys_addr_t s
>  	return __memblock_reserve(base, size, NUMA_NO_NODE, MEMBLOCK_RSRV_KERN);
>  }
>  
> +int memblock_reserve_hwpoison(phys_addr_t base, phys_addr_t size);
> +
>  #ifdef CONFIG_HAVE_MEMBLOCK_PHYS_MAP
>  int memblock_physmem_add(phys_addr_t base, phys_addr_t size);
>  #endif
> @@ -295,6 +300,11 @@ static inline bool memblock_is_reserved_noinit(struct memblock_region *m)
>  	return m->flags & MEMBLOCK_RSRV_NOINIT;
>  }
>  
> +static inline bool memblock_is_reserved_hwpoison(struct memblock_region *m)
> +{
> +	return m->flags & MEMBLOCK_RSRV_HWPOISON;
> +}
> +
>  static inline bool memblock_is_driver_managed(struct memblock_region *m)
>  {
>  	return m->flags & MEMBLOCK_DRIVER_MANAGED;
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 31961ed628b0ad..d20d99972a4db0 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -36,6 +36,9 @@
>  # define INIT_MEMBLOCK_RESERVED_REGIONS		INIT_MEMBLOCK_REGIONS
>  #endif
>  
> +/* Reserved slots memblock_reserve_hwpoison() leaves free until a resize. */
> +#define MEMBLOCK_HWPOISON_SPARE			32
> +
>  #ifndef INIT_MEMBLOCK_MEMORY_REGIONS
>  #define INIT_MEMBLOCK_MEMORY_REGIONS		INIT_MEMBLOCK_REGIONS
>  #endif
> @@ -1015,6 +1018,55 @@ int __init_memblock __memblock_reserve(phys_addr_t base, phys_addr_t size,
>  	return memblock_add_range(&memblock.reserved, base, size, nid, flags);
>  }
>  
> +int __init memblock_reserve_hwpoison(phys_addr_t base, phys_addr_t size)
> +{
> +	phys_addr_t end = base + size;
> +	bool reserved = false;
> +	int err = 0;
> +
> +	while (base < end) {
> +		phys_addr_t next = end;
> +		struct memblock_region *r;
> +		bool covered = false;
> +
> +		for_each_reserved_mem_region(r) {
> +			if (r->base + r->size <= base)
> +				continue;
> +			if (r->base >= end)
> +				break;
> +			if (PAGE_ALIGN_DOWN(r->base) <= base) {
> +				base = min(end, PAGE_ALIGN(r->base + r->size));
> +				covered = true;
> +			} else {
> +				next = PAGE_ALIGN_DOWN(r->base);
> +			}
> +			break;
> +		}
> +		if (covered)
> +			continue;
> +
> +		if (!memblock_can_resize &&
> +		    memblock.reserved.cnt + MEMBLOCK_HWPOISON_SPARE >=
> +		    memblock.reserved.max) {
> +			err = -ENOSPC;
> +			break;
> +		}
> +
> +		err = __memblock_reserve(base, next - base, NUMA_NO_NODE,
> +					 MEMBLOCK_RSRV_HWPOISON);
> +		if (err)
> +			break;
> +
> +		reserved = true;
> +		base = next;
> +	}
> +
> +	if (err)
> +		return err;
> +
> +	return reserved ? 0 : -EBUSY;
> +}
> +
>  #ifdef CONFIG_HAVE_MEMBLOCK_PHYS_MAP
>  int __init_memblock memblock_physmem_add(phys_addr_t base, phys_addr_t size)
>  {
> @@ -2394,6 +2446,27 @@ static void __init memmap_init_reserved_range(phys_addr_t start,
>  	}
>  }
>  
> +/*
> + * Frames an earlier kernel found poisoned end up as a frame poisoned by this
> + * kernel would: PG_hwpoison, not PG_reserved. Holes in the range stay reserved.
> + */
> +static void __init memmap_init_hwpoison_range(phys_addr_t start,
> +					      phys_addr_t end, int nid)
> +{
> +	unsigned long pfn;
> +
> +	for_each_valid_pfn(pfn, PFN_DOWN(start), PFN_UP(end)) {
> +		struct page *page = pfn_to_page(pfn);
> +
> +		init_deferred_page(pfn, nid);
> +
> +		if (memblock_is_map_memory(PFN_PHYS(pfn)))
> +			hwpoison_boot_page(page);
> +		else
> +			__SetPageReserved(page);
> +	}
> +}
> +
>  static void __init memmap_init_reserved_pages(void)
>  {
>  	struct memblock_region *region;
> @@ -2438,7 +2511,10 @@ static void __init memmap_init_reserved_pages(void)
>  			if (!numa_valid_node(nid))
>  				nid = early_pfn_to_nid(PFN_DOWN(start));
>  
> -			memmap_init_reserved_range(start, end, nid);
> +			if (memblock_is_reserved_hwpoison(region))
> +				memmap_init_hwpoison_range(start, end, nid);
> +			else
> +				memmap_init_reserved_range(start, end, nid);
>  		}
>  	}
>  }
> @@ -2874,6 +2950,8 @@ static const char * const flagname[] = {
>  	[ilog2(MEMBLOCK_RSRV_NOINIT)] = "RSV_NIT",
>  	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
>  	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
> +	[ilog2(MEMBLOCK_RSRV_HUGETLB)] = "RSV_HUGETLB",
> +	[ilog2(MEMBLOCK_RSRV_HWPOISON)] = "RSV_HWPOISON",
>  };
>  
>  static int memblock_debug_show(struct seq_file *m, void *private)
> 
> -- 
> 2.53.0-Meta
> 

-- 
Sincerely yours,
Mike.
