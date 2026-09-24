Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475E43218BA;
	Thu, 24 Sep 2026 11:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790250409; cv=none; b=q3qWXuiNB6IWI4/Ect44eKgs8iVNvS7qAvmXoZxsOFm5P8l9vyzfA9iHa07giINrnbbCg8DtL2zeVSoUfdbd/2f2trlOaw/XXdSPE/bz0Re9T3J+pKcPC/8dLj6VMYPYvnJNE2YLYxsJAF1TAktOPywcBThcO9ztBw5ESW3Cbq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790250409; c=relaxed/simple;
	bh=nwzMs4xFWD6XOvQBWlN0Ck4M/lHKtAstP0FW+sr7FPM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ktrP7R1ZishojgbdfkK0jzKgOtAcE9wejFksngoEiZho6VNntMbI0Fo093R/D7m+I+jJA/7yKXwtlCeJ2yoe7pB0fHrKtE7lR+DnorNjAMqWyHlEYxVVtCJGDfVCbbNi+psE9iSn+PKxxk80Ykt6JwzSBBC0rl39gmrZz9/tjrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C2ZZjtfa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C2ZZjtfa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F5711F00893;
	Thu, 24 Sep 2026 11:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790250407;
	bh=QguTDCtcZFBrUjcoOQ2Wz86gy5PkZ7tI+mbiZ0He4tw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C2ZZjtfadKsgmmtE6a7a/Bq54lk4EKawfSp9fOl2cu1OxJtfeAZl50DrZQAZGGBYV
	 x11u4amuSRlEw+PcWzv9b2uIzAJoz0t1WbTk6WrLJ6isNp77ImFoPnxbVQYiVswviN
	 rr2L9J1UeDj8BTP47GVxDPUi3YrSnls7//ZTpjjqIW0fe65XpOGLw829UTOnEUI1iH
	 ofqTi3qOH43x9adS89ocr2DYCPpWlIJd6qsGWQL7TeBxU9ZAGwcxQZy8mEIg+mzAWT
	 34xHAECBF2C/Maw4vhQjMScryrB1cU04PF4zJ3cQ95C4SivYUw+ZYlJVJMpyKPykfR
	 6Glmzkwvj3pPg==
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.ams.internal (Postfix) with ESMTP id 9ACC3198003A;
	Thu, 24 Sep 2026 07:46:44 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Thu, 24 Sep 2026 07:46:45 -0400
X-ME-Sender: <xms:pA21agEIK5eesbtjIGqnX-aM7ZC8C_blTl-puqYKwk8m_iOWseJCZQ>
    <xme:pA21alvOT4ahFuL-2XL2yuqzHJ-Bsph9OP4Og6KtmW8jpKMIcHN-T7VqIo9aLulli
    jjY1ixAKeaAlgAuLwq0dmRgr2yWOKoyGLmveTVb13O1V0ZO0nMtTl-x>
X-ME-Received: <xmr:pA21aukvAExvvwrlLlGBri3fB2aPs5LZwLRsACzItHe6UlC9tR8tgTFC-zU>
X-ME-Proxy-Cause: dmFkZTEcOZ07bQFcLSp3gnDeHBJY9VHvfMOdJMNGSYJt1XwbpXgRVIGKMXFbu7UciwVjn7
    7qQRY6imOe9A0uQF9KkGzivPcSBvE88LF8s6cjVFR//tBApRVM8wchvpG9D0aG59qYOdWg
    1K3CpHwypUQyTZfdg8v1VA3R4btiCJtgPimY7Od2IngXDfvCSpXPVkiv+GTG3eXa/1jJzi
    m/hQV9gUWY5Oudef4NizUeTrliHd+gg9W/LvmDyrn3nj3uSlbIoLre0H4E+LnJGqf4us1U
    m/6sxg5wfzpCTJkpXblYHZQX2ezHrefd+W65EvtdTmtaj/OFGjSMFYIVVYY7yN7vhpvVTZ
    LE2p2dn+ad3LU5nd01+WhwCfTgejYBgifVg3I9WVStJ2ynM/0uYHq2+1isB9kg0nsr50O6
    dkK6sJv7aoQAIVcUFs/9Zh2M2UDnesHKeGlMdL11IPEmCeHojhAg3snpstIHXFQoIhdX4/
    0oyvw3viq+OVIrCKqhOkkNetMjftR1AH+y5bst9G0Q3+D1EkdbHPpoXkIEPTsh9O2/sGAX
    1x9AJmkdcZt7rqG0JZh2Ov+WNb0IGygL9ftwYR7ECMZBOtfS6Jgb1lLaCJemUDWqaKgMdD
    zZjeZUeHHaMb/X8zfgWSD6PMttDA8tahXrm3jSw0q7AbyEZkJTZBgbjrEIpA
X-ME-Proxy: <xmx:pA21agPRIEeAWCX8stX6NJUoes-llOVvwq_sV8nwR8K0B72CCxW5Gg>
    <xmx:pA21aixQTLrGi--h997NFGngCV8i-_x1mzAzxr94OYk6Ml0PBQWvxg>
    <xmx:pA21atvOfA4-PsRzsEknF72rnlcUB8iysI91SWAy1CoXntdNJcaD7A>
    <xmx:pA21albaC30ooolnMbNye3oK48QFl6WoJblSJhD4mlBnW68IU7FJKQ>
    <xmx:pA21as2tJ_NsFIGYcH1D7M_q82BkAiH4GpI8frdnuyC1DcyWxFm07gqj>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 24 Sep 2026 07:46:43 -0400 (EDT)
Date: Thu, 24 Sep 2026 12:46:42 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Yan Y Zhao <yan.y.zhao@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, 
	Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 0/3] Move memory acceptance x86 arch code into EFI stub
Message-ID: <arUNjv0rSaAM2xmk@thinkstation>
References: <20260914183745.37538-5-ardb@kernel.org>
 <af17c380c43912ce34c228e328b3937343ce2019.camel@intel.com>
 <aqvrUeIfpE4D-Ol0@thinkstation>
 <27b267cdaed0c46146de4af2db8362b61e0b08a3.camel@intel.com>
 <aqyd+rhamNei92Nz@yzhao56-desk.sh.intel.com>
 <aqzMGEVpDRPUyPUA@yzhao56-desk.sh.intel.com>
 <aq0VWfqv2_SgOvV9@thinkstation>
 <b9ff9e11-d7da-4e34-9744-e3adcc786276@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9ff9e11-d7da-4e34-9744-e3adcc786276@app.fastmail.com>

On Wed, Sep 23, 2026 at 04:34:47PM +0200, Ard Biesheuvel wrote:
> 
> 
> On Fri, 18 Sep 2026, at 12:45, Kiryl Shutsemau wrote:
> > On Fri, Sep 18, 2026 at 01:28:56PM +0800, Yan Zhao wrote:
> >> On Fri, Sep 18, 2026 at 10:12:10AM +0800, Yan Zhao wrote:
> >> > On Fri, Sep 18, 2026 at 02:29:55AM +0800, Edgecombe, Rick P wrote:
> >> > > +Yan 
> >> > > 
> >> > > On Thu, 2026-09-17 at 14:32 +0100, Kiryl Shutsemau wrote:
> >> > > > > I guess the caller could care about TDX_PAGE_ALREADY_ACCEPTED errors. But
> >> > > > > SNP
> >> > > > > doesn't do anything for this case. It seems like part of the problem is that
> >> > > > > we
> >> > > > > are passing errors back that the caller can't feasibly handle.
> >> > > > 
> >> > > > Maybe. I don't understand SNP model and why they don't care about errors
> >> > > > here.
> >> > > > 
> >> > > > Do you have a proposal here?
> >> > > 
> >> > > Yan pointed out that future TDX modules will not take an S-EPT entry lock on
> >> > > accepting a NP S-EPT entry. However, I think this won't prevent guest caused
> >> > > busys on re-accept attempts?
> >> > Re-accept attempts may occur due to:
> >> > (a) two concurrent ACCEPT TDCALLs, where the one that arrives slightly later
> >> >     returns either TDACCEPT_ALREADY_ACCEPTED or TDX_OPERAND_BUSY.
> >> > (b) two successive ACCEPT TDCALLs on the same GPA.
> >> > 
> >> > Since Linux guest always invokes ACCEPT TDCALL before a memory access, and
> >> > accept_memory() always checks the unaccepted_table->bitmap before invoking the
> >> > ACCEPT TDCALL, case (b) should be impossible in practice, right?
> >> > 
> >> > Is case (a) a valid scenario, and does it actually occur in a Linux guest?
> >> Case (a) should be prevented by the unaccepted_memory_lock in accept_memory(),
> >> right?
> >
> > Right, for accept_memory().
> >
> > The lock itself is dropped around the TDCALL, but the range stays on
> > accepting_list until the bits are cleared, and the overlap check is done
> > in unit_size granularity, so a second caller for the same unit spins
> > until the first one is done and then finds the bits clear. Both (a) and
> > (b) are covered there.
> >
> > There is a second ACCEPT issuer that does not look at the bitmap at
> > all: shared->private conversion in tdx_enc_status_changed().
> >
> > It does not need the bitmap because the memory came from the page
> > allocator or memblock and got accepted before it was handed out. It also
> > has no per-range serialization; mem_enc_lock is only taken for read. So
> > ALREADY_ACCEPTED on that path means either the guest converted the same
> > range twice (a double-free class of bug) or the VMM acked MapGPA(shared)
> > but never removed the private page. Either way the page there is the one
> > the guest accepted earlier, and the failure already comes back as -EIO
> > rather than a panic.
> >
> 
> Is there any way we could make some progress here?
> 
> Ultimately, the thing I am after is to get rid of the call from the
> decompressor to EFI stub's snprintf(), which I want to remove. For
> the time being, I am more than happy leaving the memory acceptance where
> it is, and just dropping the call to snprintf().

Please go ahead with the move. Rick's questions are about what
tdx_accept_memory() should return, not about where the caller lives,
and can be sorted out separately.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
