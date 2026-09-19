Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C95547252E
	for <linux-efi@vger.kernel.org>; Sat, 19 Sep 2026 10:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789813715; cv=none; b=UxSvKmuC5CJF989PgDcD47NkuaEJf6P1prWLg4BObLeDqzq5jDZ79RFtHlOxpCs2wsK5ygS0rXSDWZcqLVbFtTSodgte4GQrbsTSekHO7EqGK/Frl5cr1Tj6kEQZRmlZYWpABHb8XbOohXEqmRiQoz8hc80T9oc+JvGK7VlOrbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789813715; c=relaxed/simple;
	bh=5oMA+CY9eg2MPQW/ZzazYNrDQiFaMFZzkKAVWP9/XHo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ak9uPMpswfBYfI5RoBwTLdB9EAB3KOGpSNvbwGQK9zTcqZmYXVxe/Uq0wCQtUaPXW/o14WNpnCjUgW3zE8PNXMm7SRW1Dqi5ltQQX1RPOEgr+BZ5vaZlhBKznkra0iW97qb4bTxJ4aSNf7m2djRuqewvH2jBr7YtrQ+Fla0oMl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f2kNP1WL; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f2kNP1WL"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-39b31b4281eso1625465a91.2
        for <linux-efi@vger.kernel.org>; Sat, 19 Sep 2026 03:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789813707; x=1790418507; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+T4o7Z4sldFW89gg456PmAN7vw155d0OxgwruAX/bjg=;
        b=f2kNP1WLxpvn/t+tUVbCCW9qQi8v7yZhZP4wuzHoq4yZG7bfEaEBwN+SEWo6eBRm5H
         SbIVwc0QnCDZ5rGfb8sej1SbFqn2GErZWE10spac0xqjx6paYxJNUllIIAddz6FLhLYL
         OlVQyWI0JH82nLIWJ56HmEgC5rKT32x1JiTBj5BLHy7I0O3snFQpmHtZmwOhSlHiSn1p
         Sc4/gHlaWDWgbJisvSBIID3Ut9Nz4R+1ngKB989GtrrU9jADnNTciwPQ4PtMJ5AH4Fn0
         c6u8c3j3Honlrca1efBY2qMpBppoLgxDBfuXLj4IpffBUBgSlbsyx3IUnWqrFjAszNVH
         CO8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789813707; x=1790418507;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+T4o7Z4sldFW89gg456PmAN7vw155d0OxgwruAX/bjg=;
        b=h1TX+NmFbWDGZXMWllFcvCHrIQ9PnG+uIq4A/44XJ7XW8QbJa9Tv6LCswfImD+U3dh
         en8t3y6M9w4nOsqRXXnJQCYGTUPLzx3j97R+0gzXv8ieBhKEjBYD4NerX2uZDFI7Brjc
         BlAieyC8Yx3w0T8zZwd58unuM3c662IT1/w4FsrkXhBB4OaySDHqVdhlES7STUv5BGfs
         lGESun11zvK7FQ1oEZMtWyf/YYOuzNP7IfCS0v+BHjtNCzic4sYFSXXKTderRccab/Fg
         bxqGOoiV1SXiXjhtFSAVOq6kYCIEVw7/OFvXs8jQAKnOXaC6RIAa50MyCuKx7XqVZuQs
         uc1Q==
X-Forwarded-Encrypted: i=1; AKwUvBz/tW8C/iwlWTwp+BarvyArFLtsaYOu8BWnQTpVSAbIzQV2yhJ9VF+EoDHLCtgjsDAW45mud6I8LDM=@vger.kernel.org
X-Gm-Message-State: AFuF++l1gFgZ7w5RBkGFdLonZjeONyenWjRTN2hCsiGBrxatqPVYhF1Z
	6TWZv6x08G6muKHbYuGqy//7c9Cvb8bsexWtsrs5tafo2fIyEEsJie1a
X-Gm-Gg: AYBFou0MlQt8Nvd+Dm+Y8YVJkO9xJDbJ3oH4MXgrk80laELj3RqZ1/K0JVv0VvAaWFX
	gSAAJLoOAsXF3qqDdorvDAwuvAAdXkMivUIo8YG7Luj2SVhsdZRhg78KxvOwPHVHIMRfla1Ppe6
	VNH9ZOqc/jRsP3YgnpKx0wyag/meRG6NblWDdfrutg5AfO7kEgsR6LnxLsatfbFW7Zy/QAaM/Ex
	zR5uzsYuBpv0zjGl8DBO+5INilZ5pUR7LgoldrNAmc4zjd/jVILNQ0SDm4zfWvcxO0ko3YghZv4
	JImDqeIcZr9a1RblhgJjnEnJpIJshhqeGLjCprAQUMVON1TtmmpQxcj0X3UfivJzFiRfUFalmA4
	UErI98NRF/9UxBq/w9xicvcT0vNNz52F3vp0FFHt677MASgNEXAZVpYLbFqzbCcdMtgVARzIUbM
	Bho0KJob6alHcoXCWr2ljyyqs7EHlguQuviPc55XajTQe3ipj2sQ8/h44Q1MzCMHHL/uX2sWD+l
	W4tHJgKXs8=
X-Received: by 2002:a17:90b:184d:b0:39e:6a7f:1dcc with SMTP id 98e67ed59e1d1-39e6a7f222amr3389602a91.40.1789813707258;
        Sat, 19 Sep 2026 03:28:27 -0700 (PDT)
Received: from localhost ([118.34.230.2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6c615f05sm4060068a91.15.2026.09.19.03.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 03:28:26 -0700 (PDT)
Date: Sat, 19 Sep 2026 15:58:25 +0530
From: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>, kas@kernel.org,
	kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>, hannes@cmpxchg.or,
	shakeel.butt@linux.dev, linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, rmikey@meta.com,
	riel@surriel.com, harry@kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, kernel-team@meta.com
Subject: Re: [PATCH v5 8/9] mm/memory-failure: add hwpoison_boot_page() to
 flag an inherited frame
Message-ID: <aq5jyXzuDAANeCJs@acer-nitro-anv15-41>
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-8-3bc7a57bd503@debian.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260915-hwpoison-kho-v5-8-3bc7a57bd503@debian.org>

On Tue, Sep 15, 2026 at 05:53:42AM -0700, Breno Leitao wrote:
> A frame the previous kernel recorded as poisoned has to be flagged before
> it reaches the allocator, which is long before memory_failure() can run.
> Add a helper that leaves it in the state a frame poisoned by this kernel
> would be in, so everything that already understands PG_hwpoison covers it,
> the kexec segment placement check included.
> 
> num_poisoned_pages_inc() does not work at boot: its per memory block half
> looks the block up by pfn, and memory_dev_init() has not run, so it
> divides by zero. Take only the global counter there. A hotplugged block is
> already there, so that path takes both counters as usual.
> 
> The caller comes later in this series.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  include/linux/mm.h  |  7 +++++++
>  mm/memory-failure.c | 26 ++++++++++++++++++++++++++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index b68824fcfbef19..8039830998dd4b 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -5225,6 +5225,8 @@ extern const struct attribute_group memory_failure_attr_group;
>  extern void memory_failure_queue(unsigned long pfn, int flags);
>  void num_poisoned_pages_inc(unsigned long pfn);
>  void num_poisoned_pages_sub(unsigned long pfn, long i);
> +void __meminit hwpoison_boot_page(struct page *page,
> +				  enum meminit_context context);
>  phys_addr_t range_first_hwpoison(phys_addr_t start, unsigned long size);
>  phys_addr_t range_last_hwpoison(phys_addr_t start, unsigned long size);
>  #else
> @@ -5232,6 +5234,11 @@ static inline void memory_failure_queue(unsigned long pfn, int flags)
>  {
>  }
>  
> +static inline void hwpoison_boot_page(struct page *page,
> +				      enum meminit_context context)
> +{
> +}
> +
>  static inline void num_poisoned_pages_inc(unsigned long pfn)
>  {
>  }
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index d9b8be696aac38..60e9682434700b 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -137,6 +137,32 @@ phys_addr_t range_last_hwpoison(phys_addr_t start, unsigned long size)
>  	return range_hwpoison(start, size, false);
>  }
>  
> +static void update_per_node_mf_stats(unsigned long pfn, enum mf_result result);
> +
> +void __meminit hwpoison_boot_page(struct page *page,
> +				  enum meminit_context context)
> +{
> +	unsigned long pfn = page_to_pfn(page);
> +
> +	if (PageHWPoison(page))
> +		return;
> +
> +	SetPageHWPoison(page);
> +	set_page_count(page, 1);
> +	/* The page has been completely isolated == MF_RECOVERED */
> +	update_per_node_mf_stats(pfn, MF_RECOVERED);


snip

> +
> +	/*
> +	 * The per memory block half of num_poisoned_pages_inc() has no block to
> +	 * find at boot, and divides by zero looking for one. A hotplugged block
> +	 * is already there.
> +	 */
> +	if (context == MEMINIT_HOTPLUG)
> +		num_poisoned_pages_inc(pfn);
> +	else
> +		atomic_long_inc(&num_poisoned_pages);
> +}

Hi Breno,

num_poisoned_pages_inc() currently assumes that the supplied PFN can
be used for per-memory-block accounting and therefore calls
memblk_nr_poison_inc() unconditionally. The early-boot path needs
global-only accounting because the memory-block infrastructure is not
initialized yet.

Could num_poisoned_pages_inc() treat -1UL as global-only accounting,
matching num_poisoned_pages_sub()?

Example as below:

void num_poisoned_pages_inc(unsigned long pfn)
{
	atomic_long_inc(&num_poisoned_pages);

	if (pfn != -1UL)
		memblk_nr_poison_inc(pfn);
}


The caller could then use:

num_poisoned_pages_inc(context == MEMINIT_HOTPLUG ? pfn : -1UL);

This would keep updates to `num_poisoned_pages` encapsulated rather than
manipulating the counter directly here, while also making the increment
and decrement interfaces consistent.

Thanks,
Shaikh Kamaluddin.
> +
>  /**
>   * MF_ATTR_RO - Create sysfs entry for each memory failure statistics.
>   * @_name: name of the file in the per NUMA sysfs directory.
> 
> -- 
> 2.53.0-Meta
> 
