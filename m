Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=82.195.75.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793195416;
	b=VVP+bJzmRD4lZc7cuZwKzJHA4ZdEBeoO+Oo66YtjjeEniG2SD0Bfa6G5qOxG8zfw6vTy
	 W6dkhuCabW5vvS/i/oIbJLQ97mxM4CJbHzy8VZc4cG9DHPDa2x8a1A2FNgsHy6+ljwS4I
	 s+qPmm6BSXGxMvk3M3PW9woKCb1eSoW5rtk0pL7VqQC4cChUY6bvib77lUYtLOr9pfSbV
	 2dwBuDs2/ay840IOP1OQbp+bIwDWL1uuzvQOR7ktRuKSWg2zoim/tFO9EvPGNpzx3+/ol
	 GnTdmoocz8jZ/FV65BedAw1GOT4bu7EcM29fSySotabnA0SZzqnqcOST7iyr/O+2qNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793195416;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Debian-User;
	bh=EKOJSvQCyvmegciiDSA3qkq54znl6sRsTPqc7BTTnKg=;
	b=MQa5FSN/dUrwopcu6lSI0IkhedJOB9nwkQtJO83aBuL8Wnk1d38o6yt5ax1STwLVbFXE
	 5w/SREVRLKeAgYXAcjbDX463ZpZ9HtSgr5H6TIDTtBI5bR5qvU6gbqmUV1/u/2dqucvSn
	 WWsB8VP58qphxfz875B6t1zC2YMBB5LT/dhIs+7KT2V38o5yyGUD7p77nGnTPaSItorRm
	 /M6MKXyuNMZRQMO7yUAwsvynpJ6O807IeMPqvYvnqJWn5OFCYwsskfNT4hvbCC6Db3mF5
	 SR9x8agOvy8DOUMBO6kWFhwB/OCkLiVn+DriCvwZWKP2mMlSvMwDMtbyhDYUQaM6U9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=debian.org;
	spf=pass smtp.mailfrom=debian.org;
	dkim=pass header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=BxUepWxa;
	arc=none smtp.remote-ip=82.195.75.108
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3131D606A32F;
	Wed, 28 Oct 2026 13:50:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3131D606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=BxUepWxa
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=EKOJSvQCyvmegciiDSA3qkq54znl6sRsTPqc7BTTnKg=; b=BxUepWxaQM94nl47RKcbqrBwZ7
	kKjKjVjHXt+ZcHaBoC9nDp4oSN9ak/TO/XSgZcZWwNyUes07CsiuLocLH66v0bHNVj9IKB35ZiIBf
	fXcJPdkUhdzi3eVA3yYx2Wb11fbpqdcML3ik3qmNvo9oHUT+1pIV40JNfxDMJ/wmX9eR2jxICexSE
	ad3Hc1No0hfI+y0IgWiVtZAg0BshCR6qLOZqqp16nouHynXTJ9IQB4qiaP3+hFCWqYSQ+ZvQao6uQ
	gtgCbH3J+tJpJRCI+onTodJWcxHXBKOxtmizI01tTt3GIKNO4zPmrK05hh4otiSxEU/f4XlZ4mWb4
	KFvceyFg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xM41u-002Ho4-0T;
	Wed, 28 Oct 2026 13:49:26 +0000
Date: Wed, 28 Oct 2026 06:49:18 -0700
From: Breno Leitao <leitao@debian.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, kas@kernel.org, kexec@lists.infradead.org, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	shakeel.butt@linux.dev, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, rmikey@meta.com, riel@surriel.com, harry@kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v6 4/7] mm/memblock: add a reserved-region flag for
 poisoned frames
Message-ID: <auH6WT5zR1RM1lpA@gmail.com>
References: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
 <20261016-hwpoison-kho-v6-4-f304255147da@debian.org>
 <ato62palTbNjLwN7@kernel.org>
 <524ee7d9-790d-48b6-8613-841da042c32a@kernel.org>
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
In-Reply-To: <524ee7d9-790d-48b6-8613-841da042c32a@kernel.org>
X-Debian-User: leitao

On Wed, Oct 28, 2026 at 09:39:42AM +0100, David Hildenbrand (Arm) wrote:
> On 10/22/26 18:33, Mike Rapoport wrote:
> > Hi Breno,
> > 
> > On Fri, Oct 16, 2026 at 05:15:44AM -0700, Breno Leitao wrote:
> >> memblock allocates from and frees to buddy whatever is not reserved, and
> >> knows nothing about frames an earlier kernel found hardware-poisoned.
> >> Such a frame can back the memmap, a page table or a percpu area before
> >> any hwpoison code runs, and otherwise reaches the buddy allocator like
> >> any other free frame.
> >>
> >> Add MEMBLOCK_RSRV_HWPOISON for a reserved range holding those frames.
> > 
> > How much this would fragment memblock.reserved?
> > 
> > memblock is not very scalable, to say the least, and each new flag
> > increases the size of memblock arrays which obviously hurts performance.
> 
> I assume that if you have too many regions there, you have different problems
> than scalability problems.
> 
> We should cut out larger chunks, and if they are all over your address space you
> should scrap that machine.

Ack, that is what the 2M unit does. A DRAM row fault shows up as many 4K
pages but lands in one or two units, and adjacent units share one
memblock.reserved region.

Mike, on the statistics you asked for: across the Meta hosts that logged
a hard memory failure in the last 28 days, these are the
memblock.reserved regions each host would need:

             p50   p90   p99
     x86      1     4    41
     arm64    1     5    27

Thanks,
--breno
