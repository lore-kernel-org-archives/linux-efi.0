Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1530B4A35;
	Thu,  6 Aug 2026 07:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786001684; cv=none; b=TWQcyqfPZ2DCOWNPx+VF08t6Na5LiGyH9ShiUxgAyfmeXvZVCZ9FrYQ2N4IpSB7i9hTazXqwijNiJk/nz/EFkzLg5kqr73Av6O6pwS8MCJSz5eqw9/L5tHiC8AhSwIAUahsWBIu3+Av6vIomxksJTAtbWaScVq5nO8ZoxnbAS7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786001684; c=relaxed/simple;
	bh=wTPvBNOjeKHkAAraDoIpZqoXY/SNX7sFHQtH2Gv7yQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rxv1HKshhuQuibtArhSdy/H9Dbxq52nqA2SFw8fg53oMvZIGmj7+XbDSqYTiJEKngsSPZADdfOjcRInMBxmJNDrgk5RmxPjE99x87nzV6O6seXrLZ3wqSpXXw0BlWjUfptgktW4/BnsbWexo3wR8tzC/w6dWy0bPlSPmOCaY8io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gRtWObil; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gRtWObil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA9D1F000E9;
	Thu,  6 Aug 2026 07:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786001682;
	bh=y3wUW9A5onn8mXoBrGXcecd/b5GN4A+lRTgjr2p0JTI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gRtWObilZ/zqY2xNJFCFGkSOxfW+x1vY1mLHvaVfFn3nCz/YO+ctLWfNTTs4szgnu
	 yTVCVopxmFl5NcnYpG991e8Bt2Ezz8pE1lZATTWxE8x5kpf0Cga4wRPeWCS7E5HqWv
	 XYFKlbUMhZXVnLOpWi/i+ZQVJSvS2hDlXe0DDN6dURjWleKZWV49tMZzt2Af3x0wCx
	 girzSHfnN2fGQM3POEWVr+brhoQK6GI2hxA4PAd23gY3P1IVF+HqesJZch2/8pByI2
	 /EHEMqZTbBwqX/8U8p+wI2vggLbJGqS41xPiSDTkTcAYl1PUWUd+oug/OamioWoiLi
	 FVdw8NszJIKKQ==
Date: Thu, 6 Aug 2026 08:34:22 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Yunhui Cui <cuiyunhui@bytedance.com>
Cc: linux-riscv@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, kasan-dev@googlegroups.com, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH v2 10/15] mm/gup: add fast-GUP specific lockless PTE
 helpers
Message-ID: <anQ2bW3JxraT6PFY@lucifer>
References: <cover.1784201104.git.cuiyunhui@bytedance.com>
 <138d74aa9863ae8ff445e16a2798d062895b75bc.1784201104.git.cuiyunhui@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <138d74aa9863ae8ff445e16a2798d062895b75bc.1784201104.git.cuiyunhui@bytedance.com>

+cc literally everybody you failed to contact...!

Why on earth are you doing sending a series like this which changes core mm,
non-RFC and at v2 to boot, without bothering to Cc relevant people?

I am also very confused as to why you are sending an ostensible RISC-V series
then changing how core mm works to fit it, that's not how that works.

And if you're seeking to change core mm send it as an RFC!

On Thu, Jul 16, 2026 at 08:41:45PM +0800, Yunhui Cui wrote:
> fast-GUP snapshots a PTE without holding the PTL, pins the page, and
> then revalidates that the PTE did not change. Keep both reads under the
> same lockless PTE semantics by defaulting the fast-GUP revalidation to
> ptep_get_lockless().

Why?...

>
> Introduce fast-GUP specific PTE snapshot and revalidation helpers. The
> default implementation preserves the existing ptep_get_lockless()
> semantics, while allowing architectures to override the helpers when the
> public lockless getter provides extra semantics that fast-GUP does not
> consume.
>
> Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
> ---
>  include/linux/pgtable.h | 18 ++++++++++++++++++
>  mm/gup.c                |  6 ++++--
>  2 files changed, 22 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index da14328093a86..62943fcbf7046 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -813,6 +813,24 @@ static inline pte_t ptep_get_lockless(pte_t *ptep)
>  }
>  #endif
>

Of course, no comments, helpful!

> +#ifndef gup_ptep_get_lockless
> +static inline pte_t gup_ptep_get_lockless(pte_t *ptep, pte_t *rawp)

rawp? This is terrible naming.

And 'gup_ptep_get_lockless()' is worse. What on earth is this function meant to
do? And why is 'gup lockless' considered different from lockless?

And you return the value twice, because of course you do. Why? Who knows.

> +{
> +	pte_t pte = ptep_get_lockless(ptep);
> +
> +	*rawp = pte;
> +
> +	return pte;
> +}
> +#endif
> +
> +#ifndef gup_ptep_revalidate
> +static inline bool gup_ptep_revalidate(pte_t *ptep, pte_t raw_pte)
> +{
> +	return pte_val(raw_pte) == pte_val(ptep_get_lockless(ptep));
> +}

Again this naming is utterly terrible and I'm at a loss as to why on earth
you're doing this?

We don't need to abstract equality checks?

> +#endif
> +
>  #ifndef pmdp_get_lockless
>  static inline pmd_t pmdp_get_lockless(pmd_t *pmdp)
>  {
> diff --git a/mm/gup.c b/mm/gup.c
> index 99902c15703b0..72fb147193e55 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2842,10 +2842,12 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
>  	if (!ptep)
>  		return 0;
>  	do {
> -		pte_t pte = ptep_get_lockless(ptep);
> +		pte_t raw_pte, pte;

What on earth is a 'raw' PTE?

>  		struct page *page;
>  		struct folio *folio;
>
> +		pte = gup_ptep_get_lockless(ptep, &raw_pte);
> +
>  		/*
>  		 * Always fallback to ordinary GUP on PROT_NONE-mapped pages:
>  		 * pte_access_permitted() better should reject these pages
> @@ -2871,7 +2873,7 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
>  			goto pte_unmap;
>
>  		if (unlikely(pmd_val(pmd) != pmd_val(pmdp_get_lockless(pmdp))) ||
> -		    unlikely(pte_val(pte) != pte_val(ptep_get_lockless(ptep)))) {
> +		    unlikely(!gup_ptep_revalidate(ptep, raw_pte))) {

Why do we need to refadctor a comparison between a local variable and a lockless
get?

I'm just so confused by what on earth this patch is meant to be or why it's here...

>  			gup_put_folio(folio, 1, flags);
>  			goto pte_unmap;
>  		}
> --
> 2.39.5
>
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

--
Cheers, Lorenzo
