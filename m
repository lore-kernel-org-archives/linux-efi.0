Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B9D48F820
	for <linux-efi@vger.kernel.org>; Fri, 21 Aug 2026 14:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787324022; cv=none; b=usY0AKWdpKQI1he0zowVYd2y35Bv0L55RgPBxK7YW3MNsGmtJGRaj86GtDxyR2gAZXi8qdfe0GUqCp8fhVLtDSAt7x1FGQKoX+iTtkbqxLPXLtzMAKG5B1jhIgGDDPzj1HfxGZyMakn1pwIJZUOPox/ZRwl4jtjjuEh36Fw8mhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787324022; c=relaxed/simple;
	bh=yVLVN6tqPoF0TEFTQk1A+vRL9+BTOsYuzr2pqrId/q8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KczkbB30OCz6NlUp/q3yN83ZEyVJQAGVFDK77wu2EhE1tz+qmWApkLOKFVosWoXWbQHsjqoIIYtWmRgFST00fyLDYvW5234QPsMcE26iluSym9I1V2PaTvIhkkpuvJgQuOOLGOieALuSbuIcrjXCgvHP8LcuOkYyTTUso7EicMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PEqLsZh8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PEqLsZh8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19A11F00A3A;
	Fri, 21 Aug 2026 14:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787324018;
	bh=gjevPVNDI3BMq67YKVjzwksfTaXW8pJVyyPC7ES6lEo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PEqLsZh8icemV6iCXLH8M1lwsuZIi3ppcJsoYkHbdgbhu48kCp/fzBVJmA+oO0f10
	 A3T8kuGkGfXWM3lFtPhlABSA/ZLi5QI1UlAez8YchNUOWf6MIbU+Sq4O/RMx+ddJzd
	 zX6mfViDwm9H4ky1grMR/7zMfO1HJVHZDI3kQdGakxl87mqdNfF2T069ytU4DpBR1R
	 uUfOlu07HhdXWSEZcB7TpoBFiRx5U3OuBGcOl/m1t38yanYpaMdnHgb6oRM9K+QoCP
	 Eur4/KYp8ziJXcXNbn3YRLL+yg8AgCvW4WKrQs5/fx9CGAIg6Vr6CfnI0j0QFnUrbm
	 1CtXL9ud/p8iw==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.ams.internal (Postfix) with ESMTP id 686B8198003A;
	Fri, 21 Aug 2026 10:53:34 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 21 Aug 2026 10:53:36 -0400
X-ME-Sender: <xms:bWaIahUo1Hb5TY7rwvXWZqiIQCsFm7HQZRTqnTRCmeUTDs2vDO3M7g>
    <xme:bWaIavA0jrACtIJfZNvxMZnB6LY5W3K6xw9sI5Oyjio_OXkiu-Rald-HEwNdcbwFs
    EFnhJ08yslj1tzcI-YdxlzsNHQDfk7etgZCI4hvkpXcYkXmd4O0sY1J>
X-ME-Received: <xmr:bWaIatXlrPt1A9pRHHG3TomUuLeZgaxqix4gL1TQUGJ1yocmnUjHoi5KShA>
X-ME-Proxy-Cause: dmFkZTEbg+VVSOlsbnGiy6K3W4JLvpYCkMXlScxQEGLLdOvOtuyrQIKV5vXx+5KSTZnied
    1BL05bKU0wpXElyHPT96soPhyznOA9yhQkJWdpXI71jCNZvHn/c8VAuX2g4/alGQJvz1qd
    B6T1tx9pKoO/3Xnvauupxnqq2zICVzTk4UBlHScruUUmAP9mnk/qzNvZQc+jf4jpBBOpED
    xE+2fgXCydrOnnCVlfS603l+zfBqCrVei/CtHb7spiwvo3P4OCFzG/j5TiRRMOyLcK4pgg
    ZSlRN9jwxfCyD9ZxG09NOzC4Ou0Dq8l4ppVyOBSA9VAPYEjjLuSug642uKL0/SMdJGusT8
    FyQeFVv5+gCq6v82m5C+dc3R+HvKciPH93C1bDuVeIW4IkUVggKfOTqwr4KKZy3emCTP+n
    DBukM1AbkGCTiOllFIoIrYoui9xfTNkWipsxWRgRoasgv7YwnRXH5aQZquW9snqERvi/Xs
    R0upe+kYPe/qNbREEIgpWHKovwhkbXElaYqKpMSBzNUq1tliCfVcEBRiTFlkTSmPwDqgrW
    ibYpBtd+fq2PrhOJ9Bklg/CSpV2hTOVcWUlpUl15BIC4Ze+TqxA907+2A7dBb9OARMk/T8
    nYgNX66kQKWXnHcaCI9pVHv1DteFjCk363spGtTWHEjy145SOc0yJlhjjcWg
X-ME-Proxy: <xmx:bWaIal_Su38VzUHm5aZb5ee-a0Xap4tAuQbnDctK1GAi4ze5g8Uy-Q>
    <xmx:bWaIarlEUp7XaB1sCVXjYocrfIRLRmUk01Zsvst5zTvva0SwLs4H5Q>
    <xmx:bWaIaoKqrww3YI_6W-VqhpR6EMrBfw132AL-VJxCcnDhIAw2aruieA>
    <xmx:bWaIaprOpW83gjEzL46Meqyz_1QQ8ZhkWmKqehA-02uQYv0Zk58lew>
    <xmx:bWaIatSyPscqY50xMTnar5di4kwbi2endQokP4zfKYafYoSxjsRuGgoR>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Aug 2026 10:53:33 -0400 (EDT)
Date: Fri, 21 Aug 2026 15:53:32 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rmikey@meta.com, riel@surriel.com, kexec@lists.infradead.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 6/6] efi: respect the poisoned pages coming from
 previous kernel
Message-ID: <aohldTtzE2GJ76md@thinkstation>
References: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
 <20260821-hwpoison-kho-v2-6-5743791e48e6@debian.org>
 <aog_uH5fTsJzXjjx@thinkstation>
 <aohIF6MmjiQpbz5j@gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aohIF6MmjiQpbz5j@gmail.com>

On Fri, Aug 21, 2026 at 07:03:06AM -0700, Breno Leitao wrote:
> On Fri, Aug 21, 2026 at 01:13:55PM +0100, Kiryl Shutsemau wrote:
> > On Fri, Aug 21, 2026 at 03:06:06AM -0700, Breno Leitao wrote:
> > > +	/* Reserve the table itself so it survives a further kexec. */
> > > +	memblock_reserve(PAGE_ALIGN_DOWN(ppm),
> > > +			 PAGE_ALIGN(ppm + sizeof(*pm) + bitmap_size) -
> > > +			 PAGE_ALIGN_DOWN(ppm));
> > 
> > Hm. I don't think it is enough.
> > 
> > On x86, kernel doesn't keep memblock around after boot (see
> > CONFIG_ARCH_KEEP_MEMBLOCK). Reserving in memblock exclude the memory
> > from page allocator. But kexec can place the image there.
> 
> You mean the third kexec?
> 
> 1) Kernel A hits an ECC error and marks page X poisoned.
> 2) Kernel A kexecs into kernel B, which won't use that page since
>    it's in EFI_POISONED_PAGE and memblock-reserved.
> 3) Kernel B kexecs into kernel C, which doesn't respect
>    EFI_POISONED_PAGE.
> 
> Is this the scenario you mean?

No. I think nothing prevents kernel B from putting kernel C image into
the reserved space in !CONFIG_ARCH_KEEP_MEMBLOCK case.

Kernel B excludes poisoned memory from buddy allocator, but kexec
doesn't care about this when look for placement for the next image.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
