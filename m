Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3184D489FB8
	for <linux-efi@vger.kernel.org>; Mon, 12 Oct 2026 12:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791809605; cv=none; b=Ez0WtLs6yjIsyWBLTPJ8/Mt4xx29QpXKWaMkQE0naF8XnIfP8yu7V3OjcjSlA1Tcp9qoW3GdIO5h4Dp5LExfoo1JIJCu78RTH3ICzR64KJ1bfIPBhHq+MNCBvE8peCjCzCmHxNb7wDXuINw10KrWSShAQrJvkAVylK5QRYWQH5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791809605; c=relaxed/simple;
	bh=c4NU76/P6zFT4OEPxt5+Ge4Tzy2Cegn4Q3mBCzPSiAs=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=c+5K0GxyA+5c2UISkaHAMvvr+Z+0Gd7z22VjC8ohORfXMFEFI5TO7tyTQzDVtvEOYWuBI6ZDILXVeiwRrm7A3QwcEZPq8N0Aq6hN5xG4kAc49RmpsKli98KCBe+Jn57rNlsT/49nOjHzHVaR0DbWETRK3FO/xuLBAtQ3CjXylec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RCkqZSmj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RCkqZSmj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3EC1F0089C;
	Mon, 12 Oct 2026 12:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791809603;
	bh=h7zdAX0kLTxUuA0EnRtZw5Fdnep7mfvn6Bya+Q3wDIs=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=RCkqZSmjISthf/xMtuH/Jqz98ASGAL/e4srIgAlM6ceYhv4W4d9Jk9TIyYIbYu/pi
	 MUjpQw2hx0US1JmjoC4oQtr/mYfXaT2XDTyfqphBVKHIcdL8vlzTwVBkEBUAEn4xLw
	 CdpwP6eNxZuxs3XdEGli5QB2Yc+LvlEga37Ufg1hBd+oDqosPPUHiApeCYpkb4ZMnK
	 rBaITAWzxGR2A6TiYYjQj+v7j5nO/Doj85EncrDonOd8bLJuP9ua+x9F0mk/znaCP1
	 50Bsk9zjLBgZMdcLwFKhJWIVLv4Y1Slih7dpCB/SKdyRF6P8AY2s1d81L3XPd+Kw1D
	 nNwz57qz9rg7g==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id B03A01980052;
	Mon, 12 Oct 2026 08:53:21 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Mon, 12 Oct 2026 08:53:21 -0400
X-ME-Sender: <xms:QNjMap47UyYHfrI6CMGxCNCVTwQR0sSOwksMsHER122lTFVg64IQZQ>
    <xme:QNjMahsqN-4RPa2-EFb_vms1w1eIv3nKrEWQzkBk3H5RYnP5xAKNkvcZOmYcdivbY
    e6fB9JRJcgqotozJDxL_-8Ljl-IXCcIzortaZPf0MoMcPFaa7sRT_c>
X-ME-Proxy-Cause: dmFkZTFqX8TO2NAyrkoSybZun85lLqjcOhDkvX0ktVIRmF+SXLlaZEjV5n6UyZyG5WjEXa
    6l10nQ73BHuR/SJCSLAbO1AJBo5qfdT+EqQmKob0XcTM8IHRmiBtnNtGs9nEkG1cKJ4WLk
    ns2u+SuiMLA2XnKrMd1LD+rIrbydn2nMQa49hBUnWqIba/guG3WhCWmKsRljENJsolRJcQ
    AuNNlewiXERmu34NVd04Gp+xCBiOPaqxc6/IwjAj1QdgXy7PiqPxp2asKh21huBov8XNkE
    wOJ2OvMex2+f68ofzkB23ss4DkM7mq9mAKP4O6XwsF+6SEQ0g7g6L/D3fl1CnjKclvkEZb
    XZW3VOH/9Qg+v4h5wGhnorhliUZl2+hE5AVwUOJ6cIB2XFIgSFWgtNh7tpfTb6GfMyuqxD
    +LEWhYg56qPo7ovhEcAHGIjGICiHn2olJuLDp6/7w8VVSPXbZtmKRVdC9czj0M6POqunCN
    5fu006JfF0D+Y5Y8neeh/dOnlttGxJfdIfWM0xVByk4NjFCyGxJZtcUO1V+0glaH/mJvpd
    wCD0Z/T7gBxqoGPD6lhODwv9RHJVcFn+x7UYQWss3q/piBrdjYnMPr0//ZXBfHdHEa4TQM
    bA1QFZ1KtMpO8cL8uAjRPcTPQL5wtZGZ9UCO5lM8IeiSZFiEQ7oDZy0RBtnw
X-ME-Proxy: <xmx:QdjMau55acNMipLAfiUOGZHQdVvhRZOQsnS9aOqEkaK4BUXgho8Nhw>
    <xmx:QdjMai3dDFJQe74C06uHsuAy69-hGRKsU-KItPIjl2hjqIUh1LfLeg>
    <xmx:QdjMascQtXcDNnGmZ6JYfkAgWq39rDlKP1O-CEguJQ8YYfFT440Iuw>
    <xmx:QdjMagfzbK2wJhoOR7su5sFt4BXLPivV5IVWBL5OxXS3Rm8Ba55Buw>
    <xmx:QdjMavyfc8FJ0253r_YmDBYKd1tCep2gM2wiHEF5F-IA6XZCDyaIR07a>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 1C44FF80090; Mon, 12 Oct 2026 08:53:20 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 12 Oct 2026 14:52:59 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Catalin Marinas" <catalin.marinas@arm.com>
Cc: "Ard Biesheuvel" <ardb+git@google.com>,
 linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org,
 "Will Deacon" <will@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>
Message-Id: <a6a4a7be-e4f4-4ec8-9974-7c2ffb7245fd@app.fastmail.com>
In-Reply-To: <aszXyPjGB8zIWKQT@arm.com>
References: <20261009143438.330265-2-ardb+git@google.com>
 <cad3ed39-407e-49db-91f5-cd36f052ced0@app.fastmail.com>
 <aszXyPjGB8zIWKQT@arm.com>
Subject: Re: [PATCH] arm64/mm: Route faults taken by EFI runtime firmware to no_context
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, 12 Oct 2026, at 14:51, Catalin Marinas wrote:
> On Mon, Oct 12, 2026 at 10:36:41AM +0200, Ard Biesheuvel wrote:
>> > diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
>> > index 0b52557652be..db308fe01c4f 100644
>> > --- a/arch/arm64/mm/fault.c
>> > +++ b/arch/arm64/mm/fault.c
>> > @@ -40,6 +40,7 @@
>> >  #include <asm/kprobes.h>
>> >  #include <asm/mte.h>
>> >  #include <asm/processor.h>
>> > +#include <asm/stacktrace.h>
>> >  #include <asm/sysreg.h>
>> >  #include <asm/system_misc.h>
>> >  #include <asm/tlbflush.h>
>> > @@ -621,6 +622,17 @@ static int __kprobes do_page_fault(unsigned long 
>> > far, unsigned long esr,
>> >  	if (faulthandler_disabled() || !mm)
>> >  		goto no_context;
>> > 
>> > +	/*
>> > +	 * Faults taken by EFI runtime services firmware are never resolved by
>> > +	 * the mm (efi_mm has no VMAs), and must reach __do_kernel_fault() so
>> > +	 * that efi_runtime_fixup_exception() can recover from them. When EFI
>> > +	 * runtime services are invoked from a preemptible kthread, neither of
>> > +	 * the conditions above applies, so check for this explicitly.
>> > +	 */
>> > +	if (IS_ENABLED(CONFIG_EFI) && !user_mode(regs) &&
>> > +	    is_ttbr0_addr(regs->pc) && current_in_efi())
>> > +		goto no_context;
>> > +
>> 
>> Looking at this again, I wonder if we should just add a comparison with
>> &efi_mm to the preceding if() condition.
>
> I think mm_is_efi() check in the previous block is simpler. I couldn't
> find any case where this wouldn't cover the more extensive check above
> (or the other way around).
>

Exactly. I'll send a v2.
