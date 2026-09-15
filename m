Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F823C870E;
	Tue, 15 Sep 2026 13:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789479582; cv=none; b=ADjhQM/mAxdirE8mfUSq6ArTeN3K2FKQOpx5cTkPZ6XqYpnWVAGArXVUzsmCVCWLEcQkRFcNs1+McE72DNCvLfppJPQhJ9hmdFEBzsrr2lB6Bd+niX+dj9pS/pdNgmb7e4uvFKZrAtea1RD962c4yDsy3x8ipz+bCXdf8lrdTJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789479582; c=relaxed/simple;
	bh=tZSU09jDCsIk/tpoX25HEUkW1egfskgNv1nvZG1Ds40=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W48G/1q0k0z10bwkdTJ8xqumkqQ/bKdKob6f7xF2mdKtT4Qvzy4JLdBH4X0x7Tv+j67vu0u+J8plg/AGQiY+4Aqj/7FA7yxjjX9enTkpMCrATHqHNfHmPlFCoocJI56sGTqfYXzCj34BFJZU+sJpQ3uFHb6dwvPakO7zQCqbB/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=BANf+DRv; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="BANf+DRv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=tZSU09jDCsIk/tpoX25HEUkW1egfskgNv1nvZG1Ds40=; b=BANf+DRv0G7ET6nd+Q02kEYT2c
	vD0Mdmy0esC2oiO1N8yesVKAZLUPkTsnz8o42k+YjQG4Z+8iuYgTcrL0MNA6PbeaKganDKnzH1Y6o
	dz1s24SikbwO6UvoBwIl5MOsySvfek4zhd34ghQRFqhlMs76eRAiXy7gCoWV3PKofIQOYDmDdmZ+z
	8umNKp9aZ7sYSbOGScmRPisgvY7fTzJF4LhfQfgaYtHzp+aE8umHMErYILFzLYv+cC6N8zV0soirE
	MzgEa0+BS6oIJQ04ge7Wt0Df7pee81AIR4q7tocqaLjyrupAkjIJjTRtDxCT86XCyk5TrACr2je2b
	QoiL60yw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x6TN9-004QnQ-0c;
	Tue, 15 Sep 2026 13:38:55 +0000
Date: Tue, 15 Sep 2026 06:38:47 -0700
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
Message-ID: <aqlI264D-PxJzPWb@gmail.com>
References: <20260909-hwpoison-kho-v4-0-359313564495@debian.org>
 <20260909-hwpoison-kho-v4-2-359313564495@debian.org>
 <2c9a7bef-3189-4f78-a6cb-61d2f7afd643@app.fastmail.com>
 <aqKhgPKzRf0e22s3@gmail.com>
 <aqkIdVhoG2wwVBtb@gmail.com>
 <aqkyT0Ui9h5KWuzn@thinkstation>
 <aqk4NUnq92ftuUuJ@gmail.com>
 <aqlFnuIIECOyaweo@thinkstation>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aqlFnuIIECOyaweo@thinkstation>
X-Debian-User: leitao

On Tue, Sep 15, 2026 at 02:31:38PM +0100, Harry Yoo wrote:
> On Tue, Sep 15, 2026 at 05:39:44AM -0700, Breno Leitao wrote:
> > > Also, I wonder if some architectures have a scattered set of pfn
> > > ranges so that the span from the start pfn to the end pfn being much
> > > larger than the actual physical memory size.
> > >
> > > If so it might make more sense to have a bitmap for each pfn range.
> >
> > Agreed, having a ->next in linux_efi_poisoned_memory is a good idea that
> > we can lean on depending on whatever problem comes up down the road.
> >
> > Very good point — let's keep this linux_efi_poisoned_memory chain idea in
> > mind for whenever we need to expand it.
>
> You mean 1) keeping the structure as-is for now (and expand later with
> new EFI table version) or 2) adjusting the structure in the future
> revision of this patchset?

I'd say option (1): keep the structure as it is for now, and only adjust
it once/if we actually decide to implement the hot-add use case.

That's exactly why I added the "u32 version" field to
struct linux_efi_poisoned_memory, so, it can be expanded later.

Version 1 (this patchset) covers the common, basic approach. If down the
road someone sees value in extending it to other use cases (such as
hot-plug), we can bump it to v2 and add a ->next field then.

What do you think?

Thanks for the review,
--breno
