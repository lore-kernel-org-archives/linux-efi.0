Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA7A42E433;
	Fri, 21 Aug 2026 16:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787330642; cv=none; b=DQ5cBKAhIhVdwXoBTQYSW5irvkRsq1YlCh+rWBA1V78V0qp9Pk/x/NZ9SapfBwv/4xo3q03tbjqSBiLK0KNoDjH+PL2WgSn+ZlmMGEkE3hFGR6HKP87Gq1Ksvs0YMcDpuTeSMd6yIY3pJKDGXzJ/XQtlMp+SI2MDieungic2SRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787330642; c=relaxed/simple;
	bh=RXD7+n97B/IdMri8vA4kXbnZK1yE3vwuOZSikTcBbw0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QB7Ywz/h3U3zVT4YYw+3SUbXBy4Iuywee7ZU/rvFo3Qyi+USozZcUWM3qjdVyZrWZllPFD+UMy4oSZ4KqmIFa4GlaUyKHPklR/r+kGbLZWocCYYvLEUhqWMdLYsBZr92NMUHWak+y0FC45EhzsxMoifo5Jccj4ryVqSn1V4Xpao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=P/gO3+OX; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="P/gO3+OX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Reply-To:Content-ID:Content-Description;
	bh=ujreQuq/VbmIvSks87pTDL9ws/ca+3fQw+q8D7dPgig=; b=P/gO3+OXjKhdklMG70E4d9i1Pv
	CTtOyI7PTR1PUPuVw5nC9U8ZjLepIYCzm58FlRYPQE9FCZOapdf7XZ7JFcU4z/+/nzKPP0geDGkbA
	vkbBZayX61CN3UmI7yXulNL7qsEmI/lbaPowvDacKmuCYmQM+tQBme1JhhlOmpkcHInMUiDw6cuq3
	gEDuvuNXW9ZS+qluH8M8vSYdyab8wzGX5wpNR7ZsrFyTLtnXLrLggMTPZMxR1Gme4QQYwBtYQX//5
	Ar6oAAK9X34bZCPBrnt3mY/YnES6I92rb4yIJxHbQJSoidhzxWQ1tbrOXyWPeBdNKWPyDzfSREq+y
	yaBnCfpQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wxSLG-00BTcG-28;
	Fri, 21 Aug 2026 16:43:43 +0000
Date: Fri, 21 Aug 2026 09:43:37 -0700
From: Breno Leitao <leitao@debian.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rmikey@meta.com, riel@surriel.com, kexec@lists.infradead.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 6/6] efi: respect the poisoned pages coming from
 previous kernel
Message-ID: <aoh-3XJw82O8SmsA@gmail.com>
References: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
 <20260821-hwpoison-kho-v2-6-5743791e48e6@debian.org>
 <aog_uH5fTsJzXjjx@thinkstation>
 <aohIF6MmjiQpbz5j@gmail.com>
 <aohldTtzE2GJ76md@thinkstation>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aohldTtzE2GJ76md@thinkstation>
X-Debian-User: leitao

On Fri, Aug 21, 2026 at 03:53:32PM +0100, Kiryl Shutsemau wrote:
> On Fri, Aug 21, 2026 at 07:03:06AM -0700, Breno Leitao wrote:
> > On Fri, Aug 21, 2026 at 01:13:55PM +0100, Kiryl Shutsemau wrote:
> > > On Fri, Aug 21, 2026 at 03:06:06AM -0700, Breno Leitao wrote:
> > > > +	/* Reserve the table itself so it survives a further kexec. */
> > > > +	memblock_reserve(PAGE_ALIGN_DOWN(ppm),
> > > > +			 PAGE_ALIGN(ppm + sizeof(*pm) + bitmap_size) -
> > > > +			 PAGE_ALIGN_DOWN(ppm));
> > > 
> > > Hm. I don't think it is enough.
> > > 
> > > On x86, kernel doesn't keep memblock around after boot (see
> > > CONFIG_ARCH_KEEP_MEMBLOCK). Reserving in memblock exclude the memory
> > > from page allocator. But kexec can place the image there.
> > 
> > You mean the third kexec?
> > 
> > 1) Kernel A hits an ECC error and marks page X poisoned.
> > 2) Kernel A kexecs into kernel B, which won't use that page since
> >    it's in EFI_POISONED_PAGE and memblock-reserved.
> > 3) Kernel B kexecs into kernel C, which doesn't respect
> >    EFI_POISONED_PAGE.
> > 
> > Is this the scenario you mean?
> 
> No. I think nothing prevents kernel B from putting kernel C image into
> the reserved space in !CONFIG_ARCH_KEEP_MEMBLOCK case.
> 
> Kernel B excludes poisoned memory from buddy allocator, but kexec
> doesn't care about this when look for placement for the next image.

Right, that is exactly the case I meant above — sorry for not being
clearer.

Agreed, this is a gap.

Can we keep it separate for now and address it as a follow-up? Similar
to the one covered the initial issue [1] first.

Link: https://lore.kernel.org/all/20260812-kexec_posioned-v6-0-e477887086f0@debian.org/ [1]
