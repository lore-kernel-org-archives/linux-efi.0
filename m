Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4713B8D7E;
	Tue, 15 Sep 2026 12:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789476030; cv=none; b=up3EeJBRzoxMy8ePY6BHljBDRP5p7vX0d8NHDttWDIzQhX36yk+IJlhmyHWCVa9IE5b7OjKkZCnC6cQBXco1IAVvZ5r3lp8lLjKJnnaAgICZab7XCo5hcZTtdd1JhD7FcThqlYKabNun3uo2v4tggOitepZXntgM+thKhjqc7FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789476030; c=relaxed/simple;
	bh=p4Hd/6/zw9mR1aiUREIx+yJcylAUWfTgc7O6UnTGHOY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mKYQY98giO30uNQ1bbGmKxhOWKqZ9rfsY4+jis5pbWz2TDNOE3HQS+MmZypgEj0LzYD0Kq/NH1vrxYGyCcZwAQ+3zSyMCCCiHfdepUUI3r2YNtjmO9ZX1GPVTW5vMC4cX5rwPyOhW8Osh/Jkyysnd4r5sKIf3S+TrKPh8bI7avw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=huBfHert; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="huBfHert"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=Pqqx6qyZK7hDaGMfpM7ctme4msTknL0M/1U1XtnHr1M=; b=huBfHert8ebhJsOV5HNhXjIL6i
	5hoDBf8pBN819FnWMjS07l+DapxPI5DgQs5AX8qKYVKDdOhXqpOC2FMR9E4k1ERdGl9gLRYa6uS7L
	29ZMZlV8O/OgrMSMPHHLn//ZifgJXlrn097+s/IzxtyrQ/x+0cTTCUE+CBjBIlTxVONVha3ghSzyU
	WbWX347JicsNYVyxS7O5iHBc5fdrfrnAA5+tFHy+mlF8v8LVSeJkNUDmq0F40jC7sd6Hp6tqBv7dB
	v/o0rxqmBw4kUMlPPOg5fHOhqQBLMlVAvYlYUIRvN2RhVwgBX90/49Nyn7l9HOVPICSYQFAbnlWwJ
	7dSC0UUg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x6SS0-004Oba-0j;
	Tue, 15 Sep 2026 12:39:52 +0000
Date: Tue, 15 Sep 2026 05:39:44 -0700
From: Breno Leitao <leitao@debian.org>
To: Harry Yoo <harry@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>, kexec@lists.infradead.org, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rmikey@meta.com, riel@surriel.com, kernel-team@meta.com
Subject: Re: [PATCH v4 2/5] mm/memory-failure: libstub: install the
 poisoned-memory EFI table
Message-ID: <aqk4NUnq92ftuUuJ@gmail.com>
References: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
 <20260909-hwpoison-kho-v4-2-359313564495@debian.org>
 <2c9a7bef-3189-4f78-a6cb-61d2f7afd643@app.fastmail.com>
 <aqKhgPKzRf0e22s3@gmail.com>
 <aqkIdVhoG2wwVBtb@gmail.com>
 <aqkyT0Ui9h5KWuzn@thinkstation>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aqkyT0Ui9h5KWuzn@thinkstation>
X-Debian-User: leitao

Hi Harry,

Thanks a lot for the feedback.

On Tue, Sep 15, 2026 at 01:12:54PM +0100, Harry Yoo wrote:
> On Tue, Sep 15, 2026 at 02:03:48AM -0700, Breno Leitao wrote:
> > On Thu, Sep 10, 2026 at 06:11:53AM -0700, Breno Leitao wrote:
> > > So I'd say we have two options:
> > >
> > > 1) Keep it similar to unaccepted memory, with 2M granularity.
> > >    - Pro : Similar mental model as unnacepted memory
> > >    - Cons: 2 MB might be a bit wasteful
> > >
> > > 2) Move to a linked list like the RFC, keeping it outside of the EFI
> > >    table.
> > >    - Pro: Reduce the memory granularities to page instead of 2M blocs.
> > >    - Cons: Another way of passing memory information between kexec
> > >      kernels.
> > >
> > > Any any other option or strong preference?
> >
> > Since nobody voiced a strong preference, I will stick with option (1),
> > the bitmap, for these reasons:
>
> Not sure if this was discussed already, but perhaps we need to have
> a chain of struct linux_efi_poisoned_memory rather than a single
> bitmap, to easily add support for hot-added memory later?

Agreed, that's a good point. We could extend linux_efi_poisoned_memory
with a ->next pointer, so that if we ever add hot-plug support later, we
can link in another linux_efi_poisoned_memory. 

That said, I'm not sure hot-plug memory is really relevant here. Hot-plug
is mostly used in VMs, while this feature is more host-side, so it doesn't
seem like a great fit. Maybe it would only matter for servers where
physical memory can be added while running (do those still exist? I
recall IBM offered that feature at some point, but I'm not sure there are
real customers for it).

> Also, I wonder if some architectures have a scattered set of pfn
> ranges so that the span from the start pfn to the end pfn being much
> larger than the actual physical memory size.
>
> If so it might make more sense to have a bitmap for each pfn range.

Agreed, having a ->next in linux_efi_poisoned_memory is a good idea that
we can lean on depending on whatever problem comes up down the road.

Very good point — let's keep this linux_efi_poisoned_memory chain idea in
mind for whenever we need to expand it.
