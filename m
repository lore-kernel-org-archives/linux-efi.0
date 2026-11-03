Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793699341;
	b=ecvFUg1QQ4N5CDLeqa1F/kC2tK0JrFfLJdnyYNQO62TQ+yuQfPOeZ/p1Z/gReir5zaXn
	 uyXu1hWXl/sKyo2FEJe2TbRiO5ZBVqA/UjQW6bq0R/KVB1HO+RLyJEBw4M3cdfxcFxdrc
	 4vpzwxRnDXIh7JcNjSFXyixMC5vERrsCUfVtlaXNW7HYiGMbUBpUBBETEJfjjOHZPtvUs
	 I/KMWVuqef0YeeeDUElpV3gk/kqkprB/wzNFuuLTnvUjSsdI6OdwDgmI2yAqWZJ+o08jg
	 8boPCUsDnsb5xURQe5k++0tqQeMCAiMBaxJHiWtFdkZqU4QHHPxz4iTcmCDGA10oUKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793699341;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=cgwH7+eb4DO1f1hZBo5/HU3TXgqaVoeCZLybivmvUJo=;
	b=uvb4NzaOh/gx1RbbQeyIChyd5i1jL4GqNXp/K9f+yzRY/Sz3MKzZKrA9gzt9o+mshRYp
	 ouAt/C1nkR/B0EDJuhsmo9lg2M5qfykNyGQtDh1dSMCYkkjh19VOVElZ/0tYDKb0hALoM
	 DhxV6v9NruVmNTRY/kawW4An01BLsC2gC9j8iJB+T/BD07o7/u4olQyOBhCCckNYgntGf
	 s8l1mMPcZzc80u1t6DtOmc0YzKI4Wm4kpDPpv21PVqDMcr6a1EJwYE/BBVvy9P/J58AdR
	 vYvrA+5jDhKpPHEpNebFHHhMlps1hzzsPqYC56+chpChldwrQP6k/f35wuMlZnylgyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GV++1Djw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 049AE606A327;
	Tue,  3 Nov 2026 09:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GV++1Djw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74261F000C1;
	Tue,  3 Nov 2026 09:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793699340;
	bh=cgwH7+eb4DO1f1hZBo5/HU3TXgqaVoeCZLybivmvUJo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GV++1DjwxRqBZTgtqKQjH8FDRWWNjQ0UExyz4D4wPRG6CXHgHqlai8IgSZ5/B9AVO
	 fyr6sYpt+ugUguBnTwfa9EONvXK3lfiCOo8fFL2gesEHkb4WUZGfvT6fCfMJNsI31Z
	 Vw/EI3JAg4jrRuPcmYktzzSqUrEL7bUe5ETL5f1c0mbZHI+qxZizlD4FmPKJbOX8x8
	 UcFo7Cvy49IASUxO9wd2cXytT8/WMCHJsvvJP/mjOG1ZnH5zkongCwU5jFXzRP2W/i
	 UHtO33zaLptW2P5/6tQLOOQzYQ1+oU9XS++2xZHKEc1aCasgMoti+lnda5b6BltK8l
	 casrwkwEvaa2g==
Date: Tue, 3 Nov 2026 11:48:43 +0200
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
Subject: Re: [PATCH v6 3/7] mm/memory-failure: add hwpoison_boot_page() to
 flag an inherited frame
Message-ID: <aumt-4kfGGtoXuh-@kernel.org>
References: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
 <20261016-hwpoison-kho-v6-3-f304255147da@debian.org>
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
In-Reply-To: <20261016-hwpoison-kho-v6-3-f304255147da@debian.org>

On Fri, Oct 16, 2026 at 05:15:43AM -0700, Breno Leitao wrote:
> A kernel that kexecs inherits the frames its predecessor found
> hardware-poisoned. It has to carry them as PG_hwpoison in its own memmap,
> so that everything that already understands the flag covers them,
> including the kexec segment placement check.
> 
> Add a helper that sets the flag and counts the frame in
> num_poisoned_pages. It runs while the memmap is initialised, before
> memory_dev_init() has run. memblk_nr_poison_inc() divides by
> sections_per_block, which memory_dev_init() sets, so the helper
> increments num_poisoned_pages itself instead of calling
> num_poisoned_pages_inc().
> 
> An inherited frame is a hardware failure like any other, so the helper
> sets hw_memory_failure. Without it, unpoison_memory() accepts the frame,
> clears the flag and drops the last reference, which frees a frame that
> is still bad.
> 
> The helper also counts the frame as managed, as a frame that fails at
> run time stays counted. Memory offlining subtracts every frame of the
> block that is not PageOffline, so a frame that was never counted leaves
> the managed page count too low after an offline.
> 
> The per-node memory failure statistics are not updated. This kernel
> handled no failure, it only inherited one.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  mm/internal.h       | 5 +++++
>  mm/memory-failure.c | 8 ++++++++
>  2 files changed, 13 insertions(+)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index da14c56fb24e11..4bd3bbce86e0ad 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1169,6 +1169,7 @@ void SetPageHWPoisonTakenOff(struct page *page);
>  void ClearPageHWPoisonTakenOff(struct page *page);
>  bool take_page_off_buddy(struct page *page);
>  bool put_page_back_buddy(struct page *page);
> +void __init hwpoison_boot_page(struct page *page);
>  struct task_struct *task_early_kill(struct task_struct *tsk, int force_early);
>  void add_to_kill_ksm(struct task_struct *tsk, const struct page *p,
>  		     struct vm_area_struct *vma, struct list_head *to_kill,
> @@ -1181,6 +1182,10 @@ static inline int unmap_poisoned_folio(struct folio *folio, unsigned long pfn, b
>  {
>  	return -EBUSY;
>  }
> +
> +static inline void hwpoison_boot_page(struct page *page)
> +{
> +}
>  #endif

We've been splitting internal.h to smaller headers, maybe it's time to add
"memory-faulure.h"?
  
>  extern unsigned long  __must_check vm_mmap_pgoff(struct file *, unsigned long,
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index a2ca8df501caee..d0d6b184ee469f 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -96,6 +96,14 @@ void num_poisoned_pages_sub(unsigned long pfn, long i)
>  		memblk_nr_poison_sub(pfn, i);
>  }
>  
> +void __init hwpoison_boot_page(struct page *page)
> +{
> +	SetPageHWPoison(page);
> +	atomic_long_inc(&num_poisoned_pages);
> +	hw_memory_failure = true;
> +	adjust_managed_page_count(page, 1);
> +}
> +
>  /*
>   * Return the first or the last hardware-poisoned online page in [start,
>   * start + size), or PHYS_ADDR_MAX if the range is clean.
> 
> -- 
> 2.53.0-Meta
> 

-- 
Sincerely yours,
Mike.
