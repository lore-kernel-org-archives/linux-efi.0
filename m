Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0EA413796;
	Mon, 27 Jul 2026 13:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785158565; cv=none; b=cNWBXaPxSweccXqI0R2jpcckYTvpNEUit99JGAb9tZTmGYzTwuGWo0puIDO66GKCHcFpC8WEOxkz2DQUVPQu2nOsz0XS2EthZts6FQyUYVbiZI5BhHyTODLCRhoEKUxr3fAVz3lvORoYiJ5noYm58UTR4nzdDlOY2x12UAVNLO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785158565; c=relaxed/simple;
	bh=zxN5slOKYO4hXuNYdsgaSdjbnFuG7vN/WI+cmjmFWi4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AxpHXJz/rJUlEIFPp2aqQ25MQTkSmS/UQCEVqgEL/oNuoTWVtrFSqNiccRjQPMZ3BqwLjafufBxeqyJGroqmg84dPGdoV7gMCFRURqHFq5Eqlwl89O1kizUxwFvAEZGeLmxpLqyQCET7YxzfZppA5zIOpNT9RDfvvcUOn8EBZ/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=oHxrOk0d; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="oHxrOk0d"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mB3rVl4J/0dZRKiZaqA8l1qOdT57Rk7hhvrQccsk7m4=; b=oHxrOk0dF/P4m32D0E6tqtoBi4
	IRjcQOCZ/9k1CGQtRAQsNUYaicVPx8mhPiS7+ODexGP5CZfYto4bM7GCcr0LHGHc6o/Pz7Sj15aDw
	hlDvzUv+jTmXKYUmSu7M7LUGovRMwDSbcFwG/s4WtLcBBFzbJ/sJjdOSNegXZvouf/GWRYQZaCSSW
	mwpE3Stkyotby4ASAsARSjzl3m2ovpL0w2/Y4KVg7KVTpUyn1EwH0fMWmSqgpiY0KqpfLajHWfrmv
	oXtbj4EDVmUmWCEdZr+63Q+Khpuarq6kDfZdqotB1WuIZI4si7StacMH6JweoAhZt4ahwuBwEuNVm
	74DW9rCw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1woLHn-006vOX-1M;
	Mon, 27 Jul 2026 13:22:27 +0000
Date: Mon, 27 Jul 2026 06:22:14 -0700
From: Breno Leitao <leitao@debian.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	rneu@meta.com, riel@surriel.com, caggio@meta.com, anilagrawal@meta.com, 
	rmikey@meta.com, linux-mm@kvack.org, kernel-team@meta.com
Subject: Re: [PATCH RFC 0/3] efi: mm/memory-failure: keep hardware-poisoned
 pages out of the next kexec
Message-ID: <amdVuOO_6aCxMkA2@gmail.com>
References: <20260717-hwpoison-kho-v1-0-9c5eda551998@debian.org>
 <amDHmNWfQ8eid9jH@thinkstation>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amDHmNWfQ8eid9jH@thinkstation>
X-Debian-User: leitao

On Wed, Jul 22, 2026 at 02:50:18PM +0100, Kiryl Shutsemau wrote:
> On Fri, Jul 17, 2026 at 07:03:02AM -0700, Breno Leitao wrote:
> > Problem:
> > ========
> > 
> > When a page is hard-offlined due to an uncorrectable memory error (multi
> > bit ECC), memory_failure() sets PG_hwpoison, unmaps it, removes it from
> > the buddy allocator. This information is not carried to the next kernel
> > that is kexeced. The new kernel kexecs and trip over that bad memory
> > bank _again_.
> > 
> > Why now:
> > ========
> > 
> > Several industry trends make this increasingly important:
> > 
> >     1) DRAM is getting more expensive
> >     2) soldered / on-package memory (LPDDR, HBM) is becoming more common, so a
> >        failing part can no longer simply be swapped;
> >     3) memory is kept in service far longer (at Meta, DRAM lifetime is being
> >        drastically extended).
> >     4) It is more and more common to kexec instead of full reboot
> >     5) Increase of memory per system with CXL
> > 
> > Proposed Solution:
> > ==================
> > 
> > Carry the poisoned frames to the next kernel in a new EFI configuration
> > table, LINUX_EFI_POISONED_MEMORY, modeled on the existing
> > LINUX_EFI_MEMRESERVE table.
> > 
> > EFI configuration tables already survive kexec: firmware hands the EFI
> > system table to every kernel in the chain, so a table installed once is
> > seen by all successors without a new handover channel.
> > 
> > The mechanism is architecture independent, so x86 and arm64 use the same
> > code.
> > 
> > The EFI stub installs an empty table while EFI boot service is up. A
> > configuration table can only be created there; the running kernel can only
> > append to it.
> > 
> > Each hard-offlined frame is appended; an unpoison "removes" its entry
> > so a frame that is good again is not carried forward.
> > 
> > The next kernel walks the inherited table early in
> > efi_config_parse_tables(), before memblock and the buddy allocator are
> > up, and memblock_reserve()s every recorded frame. The bad RAM is never
> > handed out.
> 
> The allocator is only half of the problem. kexec segment placement
> doesn't know about any of this: kexec_file picks destinations from
> System RAM resources (memblock on arm64), and poisoned frames are only
> ever removed from buddy. So the next kernel image, initrd or purgatory
> can be placed on top of a poisoned frame -- the relocation memcpy then
> consumes the poison and the machine checks during the very kexec this
> series is supposed to protect. Same for the table's own list pages:
> overwrite one at placement time and the next kernel parses garbage.


Agreed, and thanks. This is real and, I think, largely separable from
the cross-kexec table -- the running kernel already knows its own
poisoned frames via PG_hwpoison, so excluding them at load time protects
the immediate kexec without depending on anything carried across the
boot. I'd like to tackle it as an independent change, let me do a PoC
and see how much change it is. I suspect it is less than this one (and
probably nice to have even if this series doesn't end up anywhere)

> Hooking num_poisoned_pages_inc() also means soft-offlined pages are
> recorded. Those are functional pages, offlined predictively. Turning
> them into permanent losses for every kernel down the kexec chain does
> not seem right. I would record hard failures only.

Yea, it seems that action_result() is what we want instead of
num_poisoned_pages_inc()

> On the data structure: I am not an expert on DRAM failure modes, so I
> went reading. The field studies [1] say roughly a quarter of DRAM
> faults are multi-bit structures (row/column/bank), and the address
> interleaving means one such fault shows up to the OS as many separate
> 4K pages. A row fault lands in a window of tens of KB to about a MB; a
> column fault is one bad line per row, strided across the bank's entire
> footprint -- potentially thousands of pages scattered over gigabytes,
> reported one MCE at a time as they get touched. DDR5 on-die ECC hides
> most single-bit faults from the host, so the visible mix shifts toward
> these multi-bit modes over time.
> 
> If that is accurate, per-4K entries have no natural bound, and every
> entry becomes a separate scattered memblock_reserve() in every future
> boot.
> 
> I would consider a bitmap with one bit per 2M instead, modeled on
> struct efi_unaccepted_memory: the stub sizes it from the EFI memory map
> at cold boot, the running kernel sets a bit on hard offline, clears it
> on unpoison, and the next kernel reserves set units. It is one
> fixed-size allocation, so the whole grow-and-link machinery and the
> chain-parsing trust problem go away, and a row fault collapses into one
> or two bits.

Thanks for digging into the failure modes -- that matches my
understanding, and the bounded, chain-free bitmap is appealing for
exactly the reasons you give: a row fault collapsing to a bit or two,
one fixed allocation, and no cross-kernel chain to trust.

Let me hack a PoC with a bitmap and check how it looks like, let's see
if that looks like smoother.

--breno
