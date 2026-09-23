Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325DA3AE198;
	Wed, 23 Sep 2026 14:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174113; cv=none; b=agl2RSwU/3UJmUGLgHW3JXjrnS6NIuKary8Ot35OeA0AHj+pYYXreo6imrxZjx0zM1Hs4uMU9EfPOGQ8nyz6vYXsqy+h+uPWL/wH7DGdZDH6cLwl1D0JjcBm0WSqwnhPR2OqRx0Y8dAFMcxlhePN7NMcW/+Ipjn7YVGK5/Md6/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174113; c=relaxed/simple;
	bh=1bCLQrHdsVLU9EInS/vCERGCbCjpqd51mH0QOzCSRBg=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=U4AxcQ4HmzchxLWS34uSntFYR8k0uuZrI93p6vjZ/b9BgKV+Hk1SLwikeZiO1c6Vi2hkRJIig0U233mqXe25a2uWLbWv3m6gg1b6oVVGhphqHTEpFzsffY+0JqiOBk8A8cKyFC+q/Dc/jdzuk7jyg7u0c/mtbG90vMpU+fM7UJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aeIXsDUL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aeIXsDUL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2911F000FF;
	Wed, 23 Sep 2026 14:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790174112;
	bh=3TwlLkyZQTZh0Z1xs++bAft9ht0Lw6LygEgQuu2yQpI=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=aeIXsDULTaQWcyTIx49ef/GOrG6Jnn0Tke0MEZYE6XLjQFtP0qCHOEBrGCuDq+83y
	 mltPPaiVyS6QCTI9AcL8MmzG5ix0fCY1wjbgQFSYlt4H6tn7WMQtkegfYqMcp/pAdF
	 J8sr5oc565b1suLKqZTTEASfNSid/pLEIcdpszV4H8oFKaVsiiA5ebGwQfUMvx7u54
	 ts0J2NY7ZcOd0ZtpTEjsXpjysn6qh8e11M1LvxDoTezCqthpHIFB6ObBasMTmcvtgd
	 hY2+C+Rr5NmLXzOrumro10xV9LTRUiuqQtrGQnze4I0YRuk6LnG/giQo+HsFKuPgY0
	 HQiLzGvd6Tdaw==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id A56B8198003A;
	Wed, 23 Sep 2026 10:35:09 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Wed, 23 Sep 2026 10:35:09 -0400
X-ME-Sender: <xms:nOOzanqx8hELxLWJ4Qeiu9lg4QNyYL3Dty_DvgxaG3Tb-30m2sgtXQ>
    <xme:nOOzascA0PMOvO_BNLXjMqTC72P-ENMKTQ02TLLpaYgBFPYYyhfpyBpMeavFLgn6d
    6ewlRq7pW3xORPkpaTHSxRzC6wEKaLGJCUS3lq_yNKteZWr6J0tJA>
X-ME-Proxy-Cause: dmFkZTET3UkT5mqQjagqhJhvdpIFMPyuHUX8u+/eSW+NxtZtu12NbLWJfOn87tvBPLWizL
    gTXneLmgVEDkvj7uWZZxKyuYv83KC3W4EQDZNdsSvJKvWK5U4Qn5QcwjQShQrB21khUcCt
    qQ69uSgwT83+2D5LqAVCbNh4zWBxerW7IjWmdJlyal7U6FqN5YZHiT0KbMYje3jjKB14qb
    F0W3M0yg/649cuu5Uwrssd45k8OoGtqSqoxAnIA3GvWqT8UVcT8unVGEy5DejYmvlWhxyg
    6O0WtiF5sqyhbHR/Vn5jjq1N6ylKcCXqzq70U4hzTJUSYgPlIKzgW5XH4G7tAYoEZfhqsN
    67Cn9QxW2Kuvwx5euu5lzbixavJ0ahZXbGY6K7bd+ZRXIq27e/+zeNvuTLN7oRPNqmHQiC
    DF7dBeN7OdO7aORSO1Zsksu4q5EhYC/rx+VuYQTqoiAEEObzQrhHBRYTd81Y4Uo9YxKM2d
    Yt6pET56fY5x4FQQFjulh0z1kHJtJZq/Su+1mT4SwvnDG2TC864k9RGLr0yOqF6omlusq8
    X2DaeyNUlzurUg36iHNLsCQwtTigYN1PDwb6qTReYesuXtEi+/VRyEU0UhhjpoS4L1qYRa
    R0yw9A7Hj1muYTO1XSpyzoOCmxJUBSaayw3Lcr38I587NUbbJlfNC2Y4aqQQ
X-ME-Proxy: <xmx:neOzalRLkax8O6CzpGZy-fM3TGiGf2DSGKPHBVVjCGmQd6E0JK8W9w>
    <xmx:neOzao3qR5-PUz-jawl_fdoSA8uafig3qmxKbCp-RwLDfTaJ0jKUUg>
    <xmx:neOzaqvnL2L__9Ja328A5wCDVt_iWNbOJPx4ECJaBc2uXwBAUdbRdA>
    <xmx:neOzauhAlkJjNb02XjHZN3aHn40LziGESpPSZAYX11DCSu6LWa5Mfw>
    <xmx:neOzar_QtvHoIHDcNSEupfhBGwl6hnAYCAGn7xJpuWR10YgVTaCKU4V->
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id ED42DF8007E; Wed, 23 Sep 2026 10:35:07 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 23 Sep 2026 16:34:47 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 "Yan Y Zhao" <yan.y.zhao@intel.com>
Cc: "Rick Edgecombe" <rick.p.edgecombe@intel.com>,
 "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "x86@kernel.org" <x86@kernel.org>, "Borislav Petkov" <bp@alien8.de>
Message-Id: <b9ff9e11-d7da-4e34-9744-e3adcc786276@app.fastmail.com>
In-Reply-To: <aq0VWfqv2_SgOvV9@thinkstation>
References: <20260914183745.37538-5-ardb@kernel.org>
 <af17c380c43912ce34c228e328b3937343ce2019.camel@intel.com>
 <aqvrUeIfpE4D-Ol0@thinkstation>
 <27b267cdaed0c46146de4af2db8362b61e0b08a3.camel@intel.com>
 <aqyd+rhamNei92Nz@yzhao56-desk.sh.intel.com>
 <aqzMGEVpDRPUyPUA@yzhao56-desk.sh.intel.com> <aq0VWfqv2_SgOvV9@thinkstation>
Subject: Re: [PATCH 0/3] Move memory acceptance x86 arch code into EFI stub
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Fri, 18 Sep 2026, at 12:45, Kiryl Shutsemau wrote:
> On Fri, Sep 18, 2026 at 01:28:56PM +0800, Yan Zhao wrote:
>> On Fri, Sep 18, 2026 at 10:12:10AM +0800, Yan Zhao wrote:
>> > On Fri, Sep 18, 2026 at 02:29:55AM +0800, Edgecombe, Rick P wrote:
>> > > +Yan 
>> > > 
>> > > On Thu, 2026-09-17 at 14:32 +0100, Kiryl Shutsemau wrote:
>> > > > > I guess the caller could care about TDX_PAGE_ALREADY_ACCEPTED errors. But
>> > > > > SNP
>> > > > > doesn't do anything for this case. It seems like part of the problem is that
>> > > > > we
>> > > > > are passing errors back that the caller can't feasibly handle.
>> > > > 
>> > > > Maybe. I don't understand SNP model and why they don't care about errors
>> > > > here.
>> > > > 
>> > > > Do you have a proposal here?
>> > > 
>> > > Yan pointed out that future TDX modules will not take an S-EPT entry lock on
>> > > accepting a NP S-EPT entry. However, I think this won't prevent guest caused
>> > > busys on re-accept attempts?
>> > Re-accept attempts may occur due to:
>> > (a) two concurrent ACCEPT TDCALLs, where the one that arrives slightly later
>> >     returns either TDACCEPT_ALREADY_ACCEPTED or TDX_OPERAND_BUSY.
>> > (b) two successive ACCEPT TDCALLs on the same GPA.
>> > 
>> > Since Linux guest always invokes ACCEPT TDCALL before a memory access, and
>> > accept_memory() always checks the unaccepted_table->bitmap before invoking the
>> > ACCEPT TDCALL, case (b) should be impossible in practice, right?
>> > 
>> > Is case (a) a valid scenario, and does it actually occur in a Linux guest?
>> Case (a) should be prevented by the unaccepted_memory_lock in accept_memory(),
>> right?
>
> Right, for accept_memory().
>
> The lock itself is dropped around the TDCALL, but the range stays on
> accepting_list until the bits are cleared, and the overlap check is done
> in unit_size granularity, so a second caller for the same unit spins
> until the first one is done and then finds the bits clear. Both (a) and
> (b) are covered there.
>
> There is a second ACCEPT issuer that does not look at the bitmap at
> all: shared->private conversion in tdx_enc_status_changed().
>
> It does not need the bitmap because the memory came from the page
> allocator or memblock and got accepted before it was handed out. It also
> has no per-range serialization; mem_enc_lock is only taken for read. So
> ALREADY_ACCEPTED on that path means either the guest converted the same
> range twice (a double-free class of bug) or the VMM acked MapGPA(shared)
> but never removed the private page. Either way the page there is the one
> the guest accepted earlier, and the failure already comes back as -EIO
> rather than a panic.
>

Is there any way we could make some progress here?

Ultimately, the thing I am after is to get rid of the call from the
decompressor to EFI stub's snprintf(), which I want to remove. For
the time being, I am more than happy leaving the memory acceptance where
it is, and just dropping the call to snprintf().

