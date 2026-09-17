Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975084A2040
	for <linux-efi@vger.kernel.org>; Thu, 17 Sep 2026 23:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789687233; cv=none; b=bNjXGqbuyZiltLfK5E12DELku2NeNb5XEPkh3LWlHGDqpEQri+f1jANv/t80BCLr7mfmpxsax9Ah+QSA6mqM2y+o5y4WXAoGKiKnFXH4Io1HH7Mn+FRS2fwnx7RLqVaIFby3FycqHRcpgzSlctXVdC46DZvknCAxE6kOK6JPN6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789687233; c=relaxed/simple;
	bh=/YLkONxFDQYICTHszcVcZwZtpjGEF0UwkGSRQH89tyo=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=RV1gF69kZg3YJKKvqIf4SFvl69hHDZfJYc940shwMvo+nIwfP0P5GOmJOoXXupbP1V1+9x8VIAlNFPOe+sGvqKCf0OlrFW2xIWtQcbul8cy70Gdr8p1f2rEvYBYHbA5j463ISP7E6nRga5QmWDZHbMGUHUH0xbNzWxnBmoJmCGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KIsgnQN9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KIsgnQN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9133C1F00898;
	Thu, 17 Sep 2026 23:20:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789687226;
	bh=0wmsh21wkd7ZY/9Y9mSIaXM8UfHreJhufRu8bchqZSk=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=KIsgnQN9zT76HtR3fNU8ScaVaMKo8SrFFv9WrMMvIYYusUqR9vd8UcCWRlQx2JXn4
	 BASMLooC/sFivbzEybmIU1nfg16PSMtJE4uUGZhmbHElRktg8XJreKH/yqE40YwiM0
	 ipGxUJp/wYSOBQrfNSKYS0EdEKnw/HAy3xGwevLPCyj/A+zBbNLpuYvEjHgFrzYOV8
	 d5RzHYUXUBqi8ACNTgXrcN8VSnEqjdsazYR4Q375f6lHQicCkmt5az2nzGXNykJP8b
	 r7S1Wf16Q9kbQFgimZdjBGzAcPNJ5ltJxDwbTr2bo0QkTncTbsLaGSmQ5wMEW/5GZl
	 XRvyMrRALTYtQ==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 00F4A1980052;
	Thu, 17 Sep 2026 19:20:23 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 17 Sep 2026 19:20:24 -0400
X-ME-Sender: <xms:tnWsajmaSbOGCbGLt0qnzWWLboInZNiYDjshp4l9nIifJf5Yiqaqrg>
    <xme:tnWsahq0AO3HWWywXivnT-jRWP82rch0gEUfVkn_d1MpWKGyRhDYhEctbCNAbRn7Y
    Y6tL6AX1WgRT90dLljAgt4ZaJAguxGS6ctI1T89NzJBUiIxMLBLUMfl>
X-ME-Proxy-Cause: dmFkZTGJBonoOPjFOUoXy+YTM2uO97Vsgbx1nCN+CmyIQAwbdc8IykWfU6SoGa7Z6sKKTE
    J8q704juP+4g74zb/er4ibZOsL5U6hAWe4K/1qq4QHJxEWjWFB3kH1y3ZdSTvhKh3vnzJO
    GnR7IxfaNedbW158uD+E801gG2IPhcp7bLJ2/lFK1726f2M2FskKbulur23cZ8AI09KR6E
    nCxgW6Ag8z9BBcQtrfIzl/e12Nj21aUR/ZDgcXIsDnuVtBt06DCJrasogV42OqyZadp9Cr
    eYMkp/Eh76K3fVVf6mwuODlVYN/RiLS5mxNcSWlKSvKQrWJw6CnRA1N/ueUKvVogGqTOqd
    AaUa5O9fWZX5AHEhoPQaVQHrGed10DBJL0TY7Vg2D5iQL4IEj0wFHUfSmWYtTW//GRVXbF
    Dbyv+eoom9S2lC9o38VGzmrUe1R1KnIV5Du0uSk3zMUAXDRdpm6CsgHAtaREqNP9iKKPmf
    uSaTwd8FQzSy8aqdRlihkIM8PcbNXKnpC6q0ltslwtknmxuVD9MiwcOFlFr7gXeNGu1se0
    q32QBZIk3+HxgXsK+sBeaYcu2KsUc5dsuT/6FKQRYrpCcZQ+42IePW8R9ATXq6ZWM1Jq54
    o2sOVev8N8d6Ub8u/kEAgdQCbJfJqgiKzHDv29M/vjHfdTLbT2cHFxDJFQcA
X-ME-Proxy: <xmx:t3WsalMNoEwfPJhwb5xvoWDV4dboyUqRYRx76uOOXy01iE3vDYoFPw>
    <xmx:t3WsaiCe7wBahRNCNtAnQHV1pMAt0QQOWSLTRNslgDyWfmLvPlCBLQ>
    <xmx:t3WsakJvcacja-uTLxuf6evOU9o6YDkZA0I3KdZ_hnI0O28Y4tm5zg>
    <xmx:t3WsajOmgpCh0ZeANXpXUZQ_numI25Y9is7FpdjG9KV0fFEQBAOW_Q>
    <xmx:t3Wsaq5Tg-1z-n8qyMcrL-Jo4BytrFmvoQmeP-iLWxRuC0esRvmbYTh1>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 4A274F80080; Thu, 17 Sep 2026 19:20:22 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 18 Sep 2026 01:19:59 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Rick Edgecombe" <rick.p.edgecombe@intel.com>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 "Zhao, Yan Y" <yan.y.zhao@intel.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "x86@kernel.org" <x86@kernel.org>, "Borislav Petkov" <bp@alien8.de>
Message-Id: <0fce97e4-3c3d-4b25-aa50-b88a003fd033@app.fastmail.com>
In-Reply-To: <27b267cdaed0c46146de4af2db8362b61e0b08a3.camel@intel.com>
References: <20260914183745.37538-5-ardb@kernel.org>
 <af17c380c43912ce34c228e328b3937343ce2019.camel@intel.com>
 <aqvrUeIfpE4D-Ol0@thinkstation>
 <27b267cdaed0c46146de4af2db8362b61e0b08a3.camel@intel.com>
Subject: Re: [PATCH 0/3] Move memory acceptance x86 arch code into EFI stub
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Thu, 17 Sep 2026, at 20:29, Edgecombe, Rick P wrote:
> +Yan 
>
> On Thu, 2026-09-17 at 14:32 +0100, Kiryl Shutsemau wrote:
>> > I guess the caller could care about TDX_PAGE_ALREADY_ACCEPTED errors. But
>> > SNP
>> > doesn't do anything for this case. It seems like part of the problem is that
>> > we
>> > are passing errors back that the caller can't feasibly handle.
>> 
>> Maybe. I don't understand SNP model and why they don't care about errors
>> here.
>> 
>> Do you have a proposal here?
>
> Yan pointed out that future TDX modules will not take an S-EPT entry lock on
> accepting a NP S-EPT entry. However, I think this won't prevent guest caused
> busys on re-accept attempts?
>
>
> Here is a strawman proposal. Please consider critically.
>
> TDX_PAGE_ALREADY_ACCEPTED: Zero memory that was re-accepted and treat it as a
> success.
>
> TDX_OPERAND_BUSY host contention: Loop and blame the host for any infinite
> loops. It can be not unlike if the host zap's the EPT and the guest gets stuck
> on infinite EPT violations. Except that the host does not get any notification
> of the trouble it is causing... Some sort of TDX arch change to notify the host
> of heavy guest-host contention could be worked on in the background?
>
> TDX_OPERAND_BUSY guest contention: RW lock around accept. Normally take the lock
> for read, and a single fallback attempt takes the lock for write.
>
> Then I think all errors accept() would want to return to the callers are
> handled.
>
> The only thing I'm not sure about is TDX_PAGE_ALREADY_ACCEPTED. Some callers may
> want a warning on that case. I think a warning is more in line with what we have
> done in similar situations, rather than panic. But a warming would throw off the
> EFI stub callers apparently.

The memory acceptance occurs after ExitBootServices(), and so there is little the
EFI stub can do at this point except maybe set a variable with an error message
and reset the system. If that is better than a panic(), this is something we can
consider.

However, I'd like to avoid going off into the weeds here with something that was
intended to simply move some logic from one place to the other. The current code
prints an error to the UART I/O port (rather than the PV console TDX uses when
running in the decompressor) and then loops forever. Is that something we could
retain for this series, and then continue the above discussion in the context of
a separate series based on top of that?



