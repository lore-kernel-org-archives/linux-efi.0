Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFE83AD51C
	for <linux-efi@vger.kernel.org>; Mon, 24 Aug 2026 10:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787567564; cv=none; b=TndT2tBw2TrKEe/RYJGAO9ilsa1srp4sPBkXsBK6HapYJ+qfaBCQgQk4wkPyjtHlth8TWuewr3KEW6WnSssE/i0bs3W2GA8k1AHb6375fSESJ5u+VrfzuRNLgJO+66sEi+lR1lafYGfyKawC6WDmI4yJk8ODce8suDcGEr0+A4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787567564; c=relaxed/simple;
	bh=+LHvizjufpq3QP5jwJyt8mGXFIgWtGN8aXuUDIj29AY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gMD05mDqoaNNUWbaJtHPvVr96nFvVVZYcXMZFOMV0cH87xRzz7sT9Q6TUOG/rEEJ6fPc/vl45pQ7+18K2OUySHzJ0/hQFFVc8CxBDlzpqffrM5516hW3mJM3R/ocfOhfumQl2Wx+84nedEP9zT3seorHR/Ahgux+kzvrA2fSxQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MWvJClqu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MWvJClqu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28E61F00A3A;
	Mon, 24 Aug 2026 10:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787567562;
	bh=Q5frcXO7zyG1Iq+1oYF/eoeXxIiDw2PLXMirPuyU5Ds=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MWvJClqu/WoX2vNp1HHpt69dELCdRP1LmQUOkfPsNqbmy3STXvgyGbQLTVIh4rxQ4
	 AhCvRa/b0IlPXt2+JpUiWfgOzBmksgA2DcMh9mUGOfMgoE772RS2gv7iqXIiiaGEDa
	 v5w4YC4pweJOnLyT3UOc0Vas+hbShvayjuVUhWuyE05V/ftQXM4tmgQTMteGA+hGk/
	 0Cmp9UMN6aXsJZvAKLXUk1d6B3/6wQMUz47lVATKLg9UENmhHNsICKsWZCr5/+KL+z
	 RvA3sNk0YxMmWGwqRFSmku8Hu9aF4SgeIhW3TSuk7QgDGg5zt9EjYfxO4MU5L4b+nx
	 jQZYNPbql0s9Q==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 340EB1980045;
	Mon, 24 Aug 2026 06:32:38 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 24 Aug 2026 06:32:40 -0400
X-ME-Sender: <xms:xR2Mat51Dq14Ifc99aUyb95-S5hDCrIQDHd4xnuOtiZsMKmRPdO-Jg>
    <xme:xR2MaoXpjywZrb2LVkDn3i2Rxre9MeflCMDt_JKDDb-twDqUsCbh2LPeDICEv0-pJ
    _z9Y6YzvOTpXK0RkxC4_E36RyIKYQzXlBMdZ4DqMDiH9sHOobBvoXcP>
X-ME-Received: <xmr:xR2MakanAAB0IBgBEF-10p2bLsG49PZQud9x4elumks30x6zuROGkEo-rJ4>
X-ME-Proxy-Cause: dmFkZTEYnC3pImoohK99eGhBRTTR7KcVIkdV/ZQBL04BJxb8LYLYJ2gAtfA/2F8kCqKLMQ
    k2kZF/VDDj3pfDzPgVoz381cNo+3r3BSgIqYqZLNYbyqfTz/JHigmzZ8oniTQYrhneKQOf
    EEHdzcTrayFcRlmp5EAZRfT4AYlmPCJfm6md4UjrcbbZ8jHY/3Oc7j8plhP5euwZeuHfUH
    0XcDnrUwXLrzmSxfa75UA7uHzeedDIX9sbAlzTFvmKdd2UxrAiXttuU7y/lfP2onlgcWLy
    /w1CYl5XRSdFYLHkqIo2jI9ebN35arPjMv8Boufoa1sbgloqdErdGlNWkj+ra2OeT2armT
    tBl9hJZ9vFHo06r7FvUgNcpuCc32sIcvvCRfblb2WBG0fQykN0mA3H0z5SiN3rGl5ClKpb
    4oa2g3Z2zarUza7fKkdZgbq0RgGytdm6eufyf/DAf9QH26ndizuw2Z72G9c4d9oW8PXr+M
    HKnQ5UReYPUBTVtWSdDnoSU4Ud/jjbkyo5CQgy8tbbTLYa9QI0p5JTxgtdZN7B8uOzPIGL
    ggSC2cVugUf8xTN7KEYpG9kYBGLljA0/Tr0JydL4GAkn4pxf6s9bL5UWag99cUmOiGnrTQ
    9VjccRmOhi75HC8vqBM/wAxhlPl4O/tedw/d0EzARF8XI3FdGsyJ9WN2ZAVg
X-ME-Proxy: <xmx:xR2Many1XOn6sZW8o77T3GenwaWJ4pHxyfjwSxTuJUTiTwawNUGtMg>
    <xmx:xR2MahIGm6ijXwUWG82qSwyM1phY77W7TNMVWihsL8VRFApu3dOO7Q>
    <xmx:xR2Mamfzazfc8qC3_r-kjSsWlYO_Ze2Yige1nsM7A5LNSeVir119Nw>
    <xmx:xR2MahuWapSxqwL7_2IrnW8Z-9OUwQEZXdkOojC7sdt3PNwaCCBZvQ>
    <xmx:xR2MasGKMQO20ssgPzr_UTuR2xaJmtgHltL8NRTLhF7f9DAacfaBWZ__>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Aug 2026 06:32:37 -0400 (EDT)
Date: Mon, 24 Aug 2026 11:32:35 +0100
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
Message-ID: <aowcYuXEeqdfHmn6@thinkstation>
References: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
 <20260821-hwpoison-kho-v2-6-5743791e48e6@debian.org>
 <aog_uH5fTsJzXjjx@thinkstation>
 <aohIF6MmjiQpbz5j@gmail.com>
 <aohldTtzE2GJ76md@thinkstation>
 <aoh-3XJw82O8SmsA@gmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aoh-3XJw82O8SmsA@gmail.com>

On Fri, Aug 21, 2026 at 09:43:37AM -0700, Breno Leitao wrote:
> On Fri, Aug 21, 2026 at 03:53:32PM +0100, Kiryl Shutsemau wrote:
> > On Fri, Aug 21, 2026 at 07:03:06AM -0700, Breno Leitao wrote:
> > > On Fri, Aug 21, 2026 at 01:13:55PM +0100, Kiryl Shutsemau wrote:
> > > > On Fri, Aug 21, 2026 at 03:06:06AM -0700, Breno Leitao wrote:
> > > > > +	/* Reserve the table itself so it survives a further kexec. */
> > > > > +	memblock_reserve(PAGE_ALIGN_DOWN(ppm),
> > > > > +			 PAGE_ALIGN(ppm + sizeof(*pm) + bitmap_size) -
> > > > > +			 PAGE_ALIGN_DOWN(ppm));
> > > > 
> > > > Hm. I don't think it is enough.
> > > > 
> > > > On x86, kernel doesn't keep memblock around after boot (see
> > > > CONFIG_ARCH_KEEP_MEMBLOCK). Reserving in memblock exclude the memory
> > > > from page allocator. But kexec can place the image there.
> > > 
> > > You mean the third kexec?
> > > 
> > > 1) Kernel A hits an ECC error and marks page X poisoned.
> > > 2) Kernel A kexecs into kernel B, which won't use that page since
> > >    it's in EFI_POISONED_PAGE and memblock-reserved.
> > > 3) Kernel B kexecs into kernel C, which doesn't respect
> > >    EFI_POISONED_PAGE.
> > > 
> > > Is this the scenario you mean?
> > 
> > No. I think nothing prevents kernel B from putting kernel C image into
> > the reserved space in !CONFIG_ARCH_KEEP_MEMBLOCK case.
> > 
> > Kernel B excludes poisoned memory from buddy allocator, but kexec
> > doesn't care about this when look for placement for the next image.
> 
> Right, that is exactly the case I meant above — sorry for not being
> clearer.
> 
> Agreed, this is a gap.
> 
> Can we keep it separate for now and address it as a follow-up?

I wounder if the fix would be to make page allocator consume the table
and not do memblock_reserve() here? So we would allocate struct pages
for the memory and poison them on init. And your fix by the link below
would do the rest.

> Similar
> to the one covered the initial issue [1] first.
> 
> Link: https://lore.kernel.org/all/20260812-kexec_posioned-v6-0-e477887086f0@debian.org/ [1]

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
