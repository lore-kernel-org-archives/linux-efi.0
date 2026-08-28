Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABF91F16B
	for <linux-efi@vger.kernel.org>; Fri, 28 Aug 2026 14:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787927711; cv=none; b=W62ki8mlDuAZEujmcqEUcGPWvJ0GqA1bmxrwF0H8Z9NaTnmN/MiRtv2fI2if2IXaaQfcX62ECRqDhJ+5QWMevOtiqsVJxC5lV/5D90kxu0oq5nbPCS4zjupllSEmkF7g7ZLvlOFw7DUwArhv2GNIGzCCE0UlyH+1eEbDe5g6bZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787927711; c=relaxed/simple;
	bh=4vLhgOAWJfhHB9C5k+hA8EmZVp3gB6NlTS87ovCpJAw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kNiv/XvmvqUQw1i5RyH3beOAKptT0ZeKyWub/HtMqAUPUagxtuVO1mY0Or2yfQBdprudiW1Rp5EGG5px1uPB6LH6Iryc8LPoCBSNcM0hKfkDmjnk4lC5Ek+xfXT2n/3dRl6n8uxkIIqq2X7ZOmy/9Q0dmfvjuhY08eXxQ2xkCuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ttw3JWgq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ttw3JWgq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50901F00A3A;
	Fri, 28 Aug 2026 14:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787927710;
	bh=X98NIGQPKg+8BL1yOqDNFmiYvUCnib2Cgl3Keq8DNq8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ttw3JWgqNYV5trlA+T4J+dIMw+PPccTmFDjHPtV5ldhV352Ou+iRwpxOzR/YnVN2n
	 PZrQkRwOzfU8qQcXj/0pJkyLp09ydZFYrDCgaPhl+W7Twuz4qVnBqnmIFVEfb11ghg
	 UcIOreweXmta4MnUHvisAL6p3gRuw3M8yAHK+qWsCwNkZaPmcDVtZvyJvFTPwPWjmS
	 umL7X2ZOXGi8oZsKB4keyN+jztq0Qy6/FKsy6xUyyf4z5e6qP7N+Nwtq3ZBQS8Zj91
	 SNCZo1oft6Ret6h/p7cdcV5Apubb1yBX8gbIxOxL0cAIPQH2N4CXEN1s1+tJVcfXa3
	 oEMGw4VX292yw==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.ams.internal (Postfix) with ESMTP id 52C35198008C;
	Fri, 28 Aug 2026 10:35:04 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 28 Aug 2026 10:35:07 -0400
X-ME-Sender: <xms:l5yRarcPRM80BNt_5aHC1xO0r_gvBz4bDVyiZHDXrDOiNDgIzur_hg>
    <xme:l5yRakUd8Wc6NL_qZ5h8G6qBbE30XTs-Jt7ReT9ovn-mkInkh7AURYX8am8VDxAl8
    ZDfPV6aC7zhs2ZP4ismfFfJUf037nclNuqiOOskXlVyROGnx0ocNAci>
X-ME-Received: <xmr:l5yRah8G0tfniwzDLxB8WVU8F3Jgy7vppsnErh2NSXLdQXRf-L5DUyKDUSE>
X-ME-Proxy-Cause: dmFkZTFr1ErFwYp/sqUKdif/sqW6Wb/VLBv2jg+httKCJi0/AiJZkNFzvc+y4ea1xp/ZET
    2BvSs8QnzsnCXfGgp2ktatqoulkesBfNz9bNdfY+uqmeKUm8+9HL7ZW9s56lkxowNkQHlS
    AjzdH/bRfIsBF/KnwpBnDG36NrdV3UW7HS6CG5RjSJMhSI4bpm8wI9kR6EVyq816yX8vGf
    mRUeK7k3IA6El8JHfKpYwDBMH4psiZovq5zMI+LxcFqzE9+a0akPdGqZRuIJ7dGqwZ5MQT
    +9kkWrZXPfiDaAA8/1kCqtOBnBva6b1YGyBkk9gQTnzIMyRZEGeSRoa5mI+ZJTmrtyq3dC
    /nUCEZPuQ2cFYPEkbhCQN9LmCZisqrhzK1YHzoItQBRLyPB6dljqFRiGftTCfOXdrevsNL
    H0bBBZUB01hFRlOT4YV67+KOI1zTNOR+HuxbIbNLC40+7/gUg9TU4jihypkbo6PjhwQgwJ
    DfLZcSVXiNu/PpssEtSApwapZhxvgFGbop+tHpV7Md0Q5kViZBZxlKAahyhRpEfPEP74Fz
    83Le96qvmhI69sQIroizEz1uSe/5KwR/x+dml0NZFHXTBMwGCbvSVOJpRktkFUUtp0EpBk
    yVnh1glRHSqB+gOxq4DTr+wtKmcZNouvSfDPqte9/hIi/8Ifqb0rO/pcQAEQ
X-ME-Proxy: <xmx:l5yRahj0oiv-fevYFaXsx6GjkNiVTBgYAQT8083bvNLeZRlJ8nwY0Q>
    <xmx:l5yRamWsrAxPFiBPUGrV0oMHaTPO5PyClkuGdJUCYV2qoX9nSwnG5g>
    <xmx:l5yRaosIDwkm7IkEIS2Qd8I-3tdOeCQ-wyHH6czifFXyMseGWt9fpA>
    <xmx:l5yRag43aZFdWKQ_Ki5udhyfQo96KqOf14aWRhL9ZC-sWkfos0KWwQ>
    <xmx:l5yRanWawyaciE_RzQ8QiinNDbBWtMHmM3KINcLCwMwmX3zAXRQIdG-T>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 28 Aug 2026 10:35:02 -0400 (EDT)
Date: Fri, 28 Aug 2026 15:35:01 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-efi@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, rmikey@meta.com, riel@surriel.com, 
	kernel-team@meta.com
Subject: Re: [PATCH v3 5/5] mm/memory-failure: efi: replay the poisioned page
 in the next kernel
Message-ID: <apGbDOnPm5VXP5ez@thinkstation>
References: <20260826-hwpoison-kho-v3-0-6f79c4b605bc@debian.org>
 <20260826-hwpoison-kho-v3-5-6f79c4b605bc@debian.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826-hwpoison-kho-v3-5-6f79c4b605bc@debian.org>

On Wed, Aug 26, 2026 at 05:03:56AM -0700, Breno Leitao wrote:
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index ddda9d6837f32..f94fa221da0b8 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -2667,6 +2667,7 @@ void __init mm_core_init(void)
>  	kho_memory_init();
>  
>  	memblock_free_all();
> +	hwpoison_init_boot();
>  	mem_init();
>  	kmem_cache_init();
>  	/*

I don't think it works with deferred page init.

With CONFIG_DEFERRED_STRUCT_PAGE_INIT the struct pages above
first_deferred_pfn are not initialized here. memmap_init_range() breaks
out at defer_init() and the rest is done by page_alloc_init_late(), way
past this point.

But I think the shape is wrong here, not just the placement. We should
flag poisoned pages on the first add to buddy, not after the buddy is
initialized.

__free_pages_core() already consults the unaccepted table. Adding youre
case there seems logical. And all three paths -- memblock_free_pages(),
deferred_free_pages() and generic_online_page() -- gets there.
No need in special-casing for deferred page init.

It also closes the window where the page allocator is live before the
frames are taken out of it.

And patch 4 seems to be redundant in such shape.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
