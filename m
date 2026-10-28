Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207603;
	b=3wk3DHcCsxw6i7wRdzbQXuRwbfAkIkZscLCGZbl/+j8z49+Cq1F1VDRKMsJulP5i5FWM
	 M52TQhwM3ZC53o8/KlyR1Hj6Ai8xwJJ6A9UiK8BRlHZx+QFt9yaqn4olP4FNnpnhkeENu
	 fWIt251C83Iotp3fTTeWj851fEQhOYJZX2YufVkGClVmfmjZrUl43J35RsofA5cfoVs2S
	 cqDu8icsFjY/gk3q6Xm0jQPYv1xIt9qmDH24slSh2aWt1PjGnSJQmq1qUh4LH4TyUumsB
	 at2mIBUT5Mhv/mkC00RqVYRXKROH1eeyJxK5XyN3OkCTj5xZA0hxtfXbbFaTZ17Gr+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207603;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=vktowsTsOQhJmqiWYNIb0aPqBLNSbNahOroQ81vALNQ=;
	b=1vkKUrazcxwTUje02YFf+0OkCukLDZm+QhzbdtiWtdioZwrE7GF3FrtbLWLuWtU2UzhX
	 Gajm5KlnDZbw9Nj5zwecVpfqH3r5+YNeq3OCfzFwLyeodsDShtsLRRZKfkZYqHXUZSRg8
	 YOhzUIXyYUHxhixTdYxCaIrfgYNwUknCI3KA2kn6tsKd639rHN7bHFwT4DOYpN4US1d+j
	 6w0fB+H902glhj4NAm2ITaJM1ftvszAC4XVTvb6bVm9Xsl7Sn9eYYs1bWufb1lco3biNm
	 gNdcGsJRg/9XclZakCZtmJr2wVYIH15t1nmifF9hu5WnFui2ABaxHPIStrCt7bQOdgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BZ6enJrj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB237606A322;
	Wed, 28 Oct 2026 17:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BZ6enJrj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75E631F031E0;
	Wed, 28 Oct 2026 17:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793207602;
	bh=vktowsTsOQhJmqiWYNIb0aPqBLNSbNahOroQ81vALNQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BZ6enJrj2fR+WiaobREMK06Ol4IBWooQRDlbbDCkO1gNP7+G2R9/lsOOs2AhduaH8
	 IcGiH6/qAIxcfuSrwBdneQYRZt+W8ihxfi/bu8MIRkDPSGPjLv1CElqLHZjheiMzWZ
	 DH0T5HoxcIR4+yigsaET5t4ctAredW023hZHdikTpcSGKdBksnJ3GuslAURAOE73r0
	 OFDzAYx+euSlpwhkJz6vzjSi4qGr9oAaq/5t/Y26Gl7SwP46yh6RZXFHOGQCNEJN9I
	 lo7RodJkVz/gLSXqyhniNMQsfTsQPbnnv/5roVKerewBTdFEwzrN4Aepm6Xp3XPTM4
	 cnbju0zmHk6eA==
Date: Wed, 28 Oct 2026 19:13:06 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <auItIsZRsh_Pwrti@kernel.org>
References: <20261016-hwpoison-kho-v6-0-f304255147da@debian.org>
 <20261016-hwpoison-kho-v6-4-f304255147da@debian.org>
 <ato62palTbNjLwN7@kernel.org>
 <524ee7d9-790d-48b6-8613-841da042c32a@kernel.org>
 <auH6WT5zR1RM1lpA@gmail.com>
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
In-Reply-To: <auH6WT5zR1RM1lpA@gmail.com>

On Wed, Oct 28, 2026 at 06:49:18AM -0700, Breno Leitao wrote:
> On Wed, Oct 28, 2026 at 09:39:42AM +0100, David Hildenbrand (Arm) wrote:
> > On 10/22/26 18:33, Mike Rapoport wrote:
> > > Hi Breno,
> > > 
> > > On Fri, Oct 16, 2026 at 05:15:44AM -0700, Breno Leitao wrote:
> > >> memblock allocates from and frees to buddy whatever is not reserved, and
> > >> knows nothing about frames an earlier kernel found hardware-poisoned.
> > >> Such a frame can back the memmap, a page table or a percpu area before
> > >> any hwpoison code runs, and otherwise reaches the buddy allocator like
> > >> any other free frame.
> > >>
> > >> Add MEMBLOCK_RSRV_HWPOISON for a reserved range holding those frames.
> > > 
> > > How much this would fragment memblock.reserved?
> > > 
> > > memblock is not very scalable, to say the least, and each new flag
> > > increases the size of memblock arrays which obviously hurts performance.
> > 
> > I assume that if you have too many regions there, you have different problems
> > than scalability problems.

Not different, the problems are additive :)

> > We should cut out larger chunks, and if they are all over your address space you
> > should scrap that machine.
> 
> Ack, that is what the 2M unit does. A DRAM row fault shows up as many 4K
> pages but lands in one or two units, and adjacent units share one
> memblock.reserved region.
> 
> Mike, on the statistics you asked for: across the Meta hosts that logged
> a hard memory failure in the last 28 days, these are the
> memblock.reserved regions each host would need:
> 
>              p50   p90   p99
>      x86      1     4    41
>      arm64    1     5    27

Thanks!
A new flag is fine by me.

I'm still trying to parse what your LLM wrote in the commit messages before
sending the tags ;-)
 
> Thanks,
> --breno

-- 
Sincerely yours,
Mike.
