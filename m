Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6236047D468;
	Thu, 10 Sep 2026 13:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789045948; cv=none; b=o6f+FpG6AEOjLE1w+KkCjmGLNsB16ca1vO8uNuXJ7HwHR9SZwPYeCbWUMjkkRpNaMoTlq7yGn50+2ULWvCrZAIjT0B++fYVmjnjbArhcZSLj0zVwRRABX2INavOFjWvTy4N4/U2bl04i5TPZmsl9+MChVDzMGL2Yxcmv6KWOyIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789045948; c=relaxed/simple;
	bh=KRPBCMqju6sAaFsER+3NIni5Rb7UTXAFGokMvO1JzjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fgRJCZY1Cr/gNq1/L6ASpN0+EspM8WZeJLy0MU1HpYKSBmWY5JFtyZl+Epti0M6Cyruwfjso+2PEQGS2Rt2NvsmLCJUU8/LcddAx98Vi1qSodtLtx7x//qRN9TJEi7HYi2Q2IPT9JVgnqPtCZJgmjoWHGmMkNoHk9dIuKdGNj7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name; spf=pass smtp.mailfrom=shutemov.name; dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b=N+KhENbh; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=UtAcdd5v; arc=none smtp.client-ip=202.12.124.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shutemov.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b="N+KhENbh";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="UtAcdd5v"
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 64FA57A0075;
	Thu, 10 Sep 2026 09:12:25 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Thu, 10 Sep 2026 09:12:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789045945; x=
	1789132345; bh=0jDWHSTuNbhoCTJf9sEK6WPL9npjARd36eOneS0PQs8=; b=N
	+KhENbhh7KQoiBMAj4b4D+8z0tWGUtWXV47RhQUTn01l9scT4TIhuls1KLtFm3Lb
	sqR29dz2vArN7ru8Bp9ayR1rUgSL5AFpoQF6BhLreVJ4VBix8yL5XhRf5xRV9rjn
	h+BAmzW5saLzu6EGEDnEOS78vK0thXvO8dVcye9rQnVt5+3zvgK8MpcJvQBMHGzr
	k/C6GpVch2fniwUFwTv+LEMBh1JkYci4pQ6lnT1iCx4RWRbO8JOMnfuB+aWFcY60
	70ubFnNx/1qsxwbNVN3f25KIXbK5FqTYwIHweavs/JAP2hBvMO9wY0kFASxRcEks
	2wwM+48vhYy2PZ7ouFgzA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1789045945; x=1789132345; bh=0jDWHSTuNbhoCTJf9sEK6WPL9npjARd36eO
	neS0PQs8=; b=UtAcdd5vhEyLG0pU1Rw+mNitCY2bNuQR970HG7ehZeD/qR8L9EK
	L0dcXQPuWp1ARjYtJNpAIhezzKMGd43FDvhIQaviVFtjShzidDFMrvujHBzeP1S8
	kOG/QJKxLaghdhZOxVsmZ8ZttZuC0bnre47zeT0+7EKsBCMgNSOni1vBSOkeMPtn
	3RcsaIVP/bikiHvIBga2KuHhoNjv3hwEofsXe/xw5P8nJZVXiCG9/sIOT21nFBak
	vDICO5reqBVq0gn2X8HY+x2AbvJUJIEKQ1OTe09Vm/pyWx1kALJksAiWVH2WTDoZ
	EPgcQ2lohkDl2gr3Xic1KUU+/iIXZ9lAfew==
X-ME-Sender: <xms:uKyiat133pKtS2BzJ7Kz-Y61j1tPjDvusi1kIh4FbO676w9SF5KOyQ>
    <xme:uKyiagcXBs9eMshdcUxoCDQHQXzkp2yLNHg2MwNYoyeggAE9BdTjiFspY3-plo2jo
    tTaYmRBCgnXNqbJGHOFGmPW0NyFfjeNqsidtkkj4hoJ1GWTfBzhX4Ql>
X-ME-Received: <xmr:uKyiaiWpdy3o6sVAjvgLx3vX-q6G1mu7tpsEeo3NwmkDd6CqockznmzhdPU>
X-ME-Proxy-Cause: dmFkZTGiRBm+g20tR5r7WAlCxmjmQfdKJ7Ydjtx7NttiUyQIVV3eBF/2sd5v/n7b9k8t+k
    l6XvwEeXVN2T7cEYOTLjMtva3ocXdlgqvv3xTIRk06BxiTO/+RgGlSozQF/TVNAjxmL7gt
    v9YbQ5UOSfYcfRH7XOWZSlWxbOQAdTgWW39hm1FijhEUwTpdgdXKnvWTRIzjB8asowoqCX
    wu3AwUh5w/vuiR92Xlkah4MamNz3Ay6Pba3CS5qPkKfECCFOM5Q1Kd/wcycbl5foekWj6D
    +hPDhfi0HOA1F+LaE63mjAMFIwriKsTPLVY90ACxioHQR2nQMgQn95C2GXYkVNyzegqPOX
    QelFyB9goT+Ji5fu+dFA9ZNQEPURQoVTWSj0hDuLB3Z4LoawQ3ObCwn8xYH0jBVbeMnkd+
    hQzXAjT9SvAo3ztFtc69KEGCwSEZQu2BjcanDuCR5lHLGEbHmx4BKV5AQ75rQ8OA3k+rhW
    uji/6jYoL5gMmIOz8GE7bS6GRRNIL1tMbJj5yi+D71coTWmEBag0QQUw/07pTsNi8KxuGq
    vy/iYgjghh8VUNWhpURhmbcr8Ks06eFhEo2xlHWDhpYc+FCrBjhaHXz6w3tvQS3EbtBzZD
    qB7SH46Jh0O7IBxQLV0lVwMEoZcw55wc1tyKM5pxkF8hFyD9IqafKekK5ZAQ
X-ME-Proxy: <xmx:uKyiao9XO2l7vmUZ2fVJc47dExe5ZJT1tfgr5vNW4CK63JTrBFUiCg>
    <xmx:uayiashhiYUGB_8Zq9FUisyzMo8lLEG2Ir1WgnXT5GZ-axm7N9NgSA>
    <xmx:uayiakd2H_nWWLzxWxgXk1Oe8f8OuFu3gawffWDYRRr4cspaDpiFyQ>
    <xmx:uayialIrSIZWbbBUBf8FfmcoAx0z8UdjL6DP79hLzuge_FDSnEzDyg>
    <xmx:uayiaugIjvwIYzHmUP4hSKG5HDCSofaUlwXaowBIhU0DqdrBAFe3xdzg>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Sep 2026 09:12:24 -0400 (EDT)
Date: Thu, 10 Sep 2026 14:12:23 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, Ard Biesheuvel <ardb+git@google.com>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vincent Mailhol <mailhol@kernel.org>, x86@kernel.org
Subject: Re: [PATCH v2 01/10] x86/boot: Drop pointless re-implementation of
 panic()
Message-ID: <aqKrhNQ3mZMs5-Dy@thinkstation>
References: <20260909115530.1924665-12-ardb+git@google.com>
 <20260909115530.1924665-13-ardb+git@google.com>
 <20260909191410.GAaqGwAsCewrdVZZ0s@fat_crate.local>
 <cee2e02b-3817-44cf-857f-62a148290367@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cee2e02b-3817-44cf-857f-62a148290367@app.fastmail.com>

On Wed, Sep 09, 2026 at 10:43:23PM +0200, Ard Biesheuvel wrote:
> 
> On Wed, 9 Sep 2026, at 21:14, Borislav Petkov wrote:
> > On Wed, Sep 09, 2026 at 01:55:32PM +0200, Ard Biesheuvel wrote:
> >> From: Ard Biesheuvel <ardb@kernel.org>
> >> 
> >> The decompressor has its own implementation of panic(), which is based
> >> on the vsnprintf() routine provided by the EFI stub.
> >> 
> >> Relying on the EFI stub from code that does not execute in the context
> >> of the EFI boot services is a bad idea. It is also completely pointless
> >> in this case, given that the only user of this version of panic() only
> >> passes a compile time constant string, without any printf conversions.
> >> 
> >> So use error() instead of panic() in that case, and drop the panic()
> >> implementation entirely. This is needed so that the EFI stub's
> >> vsnprintf() can be modified in a manner that is incompatible with the
> >> expectations of this caller.
> >> 
> >> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> >> ---
> >>  arch/x86/boot/compressed/error.c | 19 -------------------
> >>  arch/x86/boot/compressed/error.h |  1 -
> >>  arch/x86/boot/compressed/mem.c   |  2 +-
> >>  3 files changed, 1 insertion(+), 21 deletions(-)
> >> 
> >> diff --git a/arch/x86/boot/compressed/error.c b/arch/x86/boot/compressed/error.c
> >> index 19a8251de506..ce5ed7d8265e 100644
> >> --- a/arch/x86/boot/compressed/error.c
> >> +++ b/arch/x86/boot/compressed/error.c
> >> @@ -22,22 +22,3 @@ void error(char *m)
> >>  	while (1)
> >>  		asm("hlt");
> >>  }
> >> -
> >> -/* EFI libstub  provides vsnprintf() */
> >> -#ifdef CONFIG_EFI_STUB
> >> -void panic(const char *fmt, ...)
> >
> > So this thing appeared magically in v8 of the TDX unaccepted memory patches
> > and I don't think we questioned it back then.
> >
> > v7's tdx_accept_memory() does error():
> >
> > https://lore.kernel.org/all/20220614120231.48165-15-kirill.shutemov@linux.intel.com/
> >
> > and v8 started doing panic():
> >
> > +void tdx_accept_memory(phys_addr_t start, phys_addr_t end)
> > +{
> > +	if (!tdx_enc_status_changed_phys(start, end, true))
> > +		panic("Accepting memory failed: %#llx-%#llx\n",  start, end);
> > +}
> >
> > https://lore.kernel.org/all/20221207014933.8435-15-kirill.shutemov@linux.intel.com/
> >
> > and it switched to it being a vsnprintf() wrapper because it wanted to dump
> > start and end perhaps.
> >
> > But then it ended up dropping the params in v13 and landed upstream with
> > a single string as an argument.
> >
> > Anyway, adding Kiryl/Kirill for comment and leaving in the rest for reference.
> >
> 
> Looking at that v13, it seems the panic() call was added to
> arch/x86/coco/tdx/tdx-shared.c, which was shared between the kernel proper and
> the decompressorat the time, and so a panic() implementation was needed in the
> decompressor too. But that is no longer the case.

Right. I don't mind dropping this panic() from the decompressor. The
range was already gone since v13 and I never saw the error trigger
anyway.

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
