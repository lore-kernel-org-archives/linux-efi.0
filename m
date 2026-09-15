Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC383115AE;
	Tue, 15 Sep 2026 13:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789479101; cv=none; b=IudSRz/JFyd0hgBhKSZ5eOrZG4ribLMtPvMqY2k9+yeEYfBaaAROA07fn1wi25XibdHA9aJ/VARyAqEVa5SPvKUbHiAszA2L6lsE+tFLPsH7+A7PuoCl+h9zYCVeRamF3CcmnuJk3Jy2b36dBAukWkvGoae+kBZtRSIuOz9qjZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789479101; c=relaxed/simple;
	bh=RfwwC2+Zez1tPpO2uzngk8MVBZQTEo9cPOqnv9hB2dc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RtRrxN/qtiXmCID/QFzK1PDlRmPiqFspbBdJrzrHWxDZtYeqK3UWTGpKekFDlrV9dvyG7snv6lBXjqg+QW4RtO9mRt6/5S0gnGT9UMPbSHPd9qNQmtp7NyIFy/quyo922aXdm0mDk+ED1f1f+JKIxYHaOBK4gndsdT88aDW4FFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bxgsy2BH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bxgsy2BH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE8D1F000FF;
	Tue, 15 Sep 2026 13:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789479100;
	bh=szNMGe0DObGeR+SwRrUoeZsesJIvyvHlKuWjShKq/XM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Bxgsy2BH8vB1k6x/MwDXjlbNVwjyZEYkY8k9e3PdVaD+xjsGtBcSM9mJabPOrJUzz
	 kd+tHYqRrKZEq87R5a8vsjCkYvifnJ8NtGCJawmHnVkZckYqaVj42qfBwQldxWKjGN
	 lGHVDHinmGCkNbzgPmoE22Y75nwCu0vz4nOwIRCQC+CkloWdVLGFpJuKkkt6yR3sjn
	 nFZNRopmz55BHRoMcDgESNpOC07YvQkifLyL9ERd9uVTHuFnJV5FTShXlo1wH1UfV3
	 opo03/Dn1lTUHe5SWpC77GI5+3vj4S6E08Us84DlyhteMV2n/GNLKKz3llO3ZNCFst
	 ILzESzN/1go0Q==
Date: Tue, 15 Sep 2026 14:31:38 +0100
From: Harry Yoo <harry@kernel.org>
To: Breno Leitao <leitao@debian.org>
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
Message-ID: <aqlFnuIIECOyaweo@thinkstation>
References: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
 <20260909-hwpoison-kho-v4-2-359313564495@debian.org>
 <2c9a7bef-3189-4f78-a6cb-61d2f7afd643@app.fastmail.com>
 <aqKhgPKzRf0e22s3@gmail.com>
 <aqkIdVhoG2wwVBtb@gmail.com>
 <aqkyT0Ui9h5KWuzn@thinkstation>
 <aqk4NUnq92ftuUuJ@gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aqk4NUnq92ftuUuJ@gmail.com>

On Tue, Sep 15, 2026 at 05:39:44AM -0700, Breno Leitao wrote:
> Hi Harry,
> 
> Thanks a lot for the feedback.

Hi Breno, no problem!

> On Tue, Sep 15, 2026 at 01:12:54PM +0100, Harry Yoo wrote:
> > On Tue, Sep 15, 2026 at 02:03:48AM -0700, Breno Leitao wrote:
> > > On Thu, Sep 10, 2026 at 06:11:53AM -0700, Breno Leitao wrote:
> > > > So I'd say we have two options:
> > > >
> > > > 1) Keep it similar to unaccepted memory, with 2M granularity.
> > > >    - Pro : Similar mental model as unnacepted memory
> > > >    - Cons: 2 MB might be a bit wasteful
> > > >
> > > > 2) Move to a linked list like the RFC, keeping it outside of the EFI
> > > >    table.
> > > >    - Pro: Reduce the memory granularities to page instead of 2M blocs.
> > > >    - Cons: Another way of passing memory information between kexec
> > > >      kernels.
> > > >
> > > > Any any other option or strong preference?
> > >
> > > Since nobody voiced a strong preference, I will stick with option (1),
> > > the bitmap, for these reasons:
> >
> > Not sure if this was discussed already, but perhaps we need to have
> > a chain of struct linux_efi_poisoned_memory rather than a single
> > bitmap, to easily add support for hot-added memory later?
> 
> Agreed, that's a good point. We could extend linux_efi_poisoned_memory
> with a ->next pointer, so that if we ever add hot-plug support later, we
> can link in another linux_efi_poisoned_memory. 
> 
> That said, I'm not sure hot-plug memory is really relevant here. Hot-plug
> is mostly used in VMs, while this feature is more host-side, so it doesn't
> seem like a great fit. Maybe it would only matter for servers where
> physical memory can be added while running (do those still exist? I
> recall IBM offered that feature at some point, but I'm not sure there are
> real customers for it).

IIRC CXL memory modules can be set up either by firmware or hot-plugged
after boot. Not sure how common the latter case is (or will be) in
practice, though.

> > Also, I wonder if some architectures have a scattered set of pfn
> > ranges so that the span from the start pfn to the end pfn being much
> > larger than the actual physical memory size.
> >
> > If so it might make more sense to have a bitmap for each pfn range.
> 
> Agreed, having a ->next in linux_efi_poisoned_memory is a good idea that
> we can lean on depending on whatever problem comes up down the road.
> 
> Very good point — let's keep this linux_efi_poisoned_memory chain idea in
> mind for whenever we need to expand it.

You mean 1) keeping the structure as-is for now (and expand later with
new EFI table version) or 2) adjusting the structure in the future
revision of this patchset?

-- 
Cheers,
Harry / Hyeonggon
