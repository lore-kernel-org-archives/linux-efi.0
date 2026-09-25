Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB89C455603
	for <linux-efi@vger.kernel.org>; Fri, 25 Sep 2026 07:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790322651; cv=none; b=uv6Xtb2V5zC9cMZswHJ6Ybl3hajhTexq5JIC6xjdwDcODLRD1f14QSPmd4lTXr3A0n+zx9wjULevOhg7NKYlkt544Ms0bhNfiPem79yslNq6iONaev/JzeU/HX19zuKIAVJ2dv9eKDuAEocjwlrubZtJu2XCARpEO9/9SK0TdNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790322651; c=relaxed/simple;
	bh=etvYMdjIKmKo0vypJIIrSrdY9PtMT/S+xJavh4Imy7c=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=sUBC6FJ9xUl3r0K+jf3dnNyeoF1bOTvipfS8utZ77mifQhIVbRIwg4tHYm3f/7/fYzTHAlO6q0bVraRrHEa3MLZKIPYWTz3dCW4VuXL1FNG0F1vBpZwHx9qrmwWW1AOQI8XA+QKE811DAW6ba4sXRv6AJzCQrZfUZJsHCIbeMEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CN3d9N80; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CN3d9N80"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6121F000FF;
	Fri, 25 Sep 2026 07:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790322649;
	bh=t2Dx/d45eW/YSr1SSo2BR+xcaKZ/ss9Th88yiSDyPFU=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=CN3d9N8015i+DdLjif2urqc4z8yblX07qO7q5cIwjy4GWuX7dRab49Xelylr9j1xJ
	 ru/l+ayN21db+dp9EG1AoaCtYLytJFWjnfJ95MFemVE9PA8fSLyRFWejwuK/PlTHfA
	 YMDn5dAvV8UAPOZQQ9mto7xXLDn1N2M04qpSSPTgMW4VvfwofbEi+z0+2PE5NUNxk8
	 4Nw/ZX8hdI/356I+fnxTRGM9roCMfxAL7vaZ8Cp94LvgS9PbboqWHrUIImfTS9JDiJ
	 brcLEbnN4iWAxyIYAMQOM/mt4WiYY4pNheYXb5YaOKb9LXwErvCpcCbezbvu07FZzt
	 FKpDBhfYzBxgA==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 33C8B1980062;
	Fri, 25 Sep 2026 03:50:47 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Fri, 25 Sep 2026 03:50:47 -0400
X-ME-Sender: <xms:1Se2akdImMzz2JmVrIhbv1x22F7ZoWPiNQ6vcYqsEjbqabYYlK673g>
    <xme:1Se2ahBkyfwgo2J_1iO2UKnwMHBdfKrx45kK2MRW2F_W9CkgrbO9GRmgt6zl6LCST
    4iby97QxQBi7v1riqW8MlAcMTnWxmChCatU8eF2RQE42bdkNspEpCG1mw>
X-ME-Proxy-Cause: dmFkZTEauvpc3Xgpv/TCnf4kDS4S+hfiJ+BbESf1ZndveM7HOh1njdCDrq7KMMr/U8bq6C
    PNJb9YEQJDxJFvIJ0vji9MPQpdxZ3pmpmbyXady5AXyjkwjy0GXCKYeYLToKgN0Mm+gvtD
    /lYmVPNRmdVrhNEI12bxPQH5PNLolit6ZujMY8uiFYo+DDDODouf1aVtkFqocomJph1j9k
    hYJVeUouoCED9AxZc5c1G48vLSMp4ajZq+oH83mNyLo/2ZSnKpRBwjzS/QwIA5VE3g+boz
    EnBF6MMECdCx2lhgunHdF9dcqKuEqGyYngxrGd79tvQu332KMczwJChtSqM3dXM5vNWfJz
    OiFAhlRyRqLG3cWQix+J+jGj8GLtlvaxG2ep4gUkaleyMqBRisMFdwP6SmJnkU9TlCfxTO
    rDPnFzza298B7dEv5qgsYnXNp1Y7e1OcgY2mtyY09tO7hNQfkt+qlN43VEcTIzYUbamfRj
    lA9rrMymYfWD/DT3+bmZyFZoCs02elMBhC8tLilZdBZCKB18DrHiUhigxkShP3c/HIk5GQ
    7Jay04oLQRmrM4+NdsuHtIimeHH4ifB1Owjjupt+FkqKwgx27T9EUxKakd6v2glNUJ1it8
    KnZCV1PlRtkf88Z1y9uVvEMyNxkofMGIw3LP+XkFLIWrGFx/4QcxW6wAas0g
X-ME-Proxy: <xmx:1ye2apYqRCA-pIqtGEedGRLjVBPWLPezoqzNPdDD2nVYCT8hZ7V7cA>
    <xmx:1ye2aoBBa8Wz_ss1yRsnI3HRLdqgMMydyDjEBmkmCga2gSuFuuzKTA>
    <xmx:1ye2apne7FtJshXZtRddHabf8RLAKWqseGhhSsGB4tZU-EFiIS4_uQ>
    <xmx:1ye2ahz7cGrtsGAdC9_Q4QR3kPHqMbIXSwNg5upLcSRKYsk6-XuvWw>
    <xmx:1ye2arQwbw6lsVPnogS4FIZLhavD0F4IDrnaEH7xqjSKYgTXz3pmFoHG>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 97C63F80080; Fri, 25 Sep 2026 03:50:45 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 25 Sep 2026 09:50:25 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Rick Edgecombe" <rick.p.edgecombe@intel.com>,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Yan Y Zhao" <yan.y.zhao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
 "Borislav Petkov" <bp@alien8.de>
Message-Id: <aa7a1571-f91f-42ca-aa12-3122f453cad0@app.fastmail.com>
In-Reply-To: <fe5b400e19742ae3666cd7b3e4bd22164024293f.camel@intel.com>
References: <20260914183745.37538-5-ardb@kernel.org>
 <af17c380c43912ce34c228e328b3937343ce2019.camel@intel.com>
 <aqvrUeIfpE4D-Ol0@thinkstation>
 <27b267cdaed0c46146de4af2db8362b61e0b08a3.camel@intel.com>
 <aqyd+rhamNei92Nz@yzhao56-desk.sh.intel.com>
 <aqzMGEVpDRPUyPUA@yzhao56-desk.sh.intel.com> <aq0VWfqv2_SgOvV9@thinkstation>
 <b9ff9e11-d7da-4e34-9744-e3adcc786276@app.fastmail.com>
 <arUNjv0rSaAM2xmk@thinkstation>
 <fe5b400e19742ae3666cd7b3e4bd22164024293f.camel@intel.com>
Subject: Re: [PATCH 0/3] Move memory acceptance x86 arch code into EFI stub
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Fri, 25 Sep 2026, at 01:30, Edgecombe, Rick P wrote:
> On Thu, 2026-09-24 at 12:46 +0100, Kiryl Shutsemau wrote:
>> > Is there any way we could make some progress here?
>> > 
>> > Ultimately, the thing I am after is to get rid of the call from the
>> > decompressor to EFI stub's snprintf(), which I want to remove. For
>> > the time being, I am more than happy leaving the memory acceptance where
>> > it is, and just dropping the call to snprintf().
>> 
>> Please go ahead with the move. Rick's questions are about what
>> tdx_accept_memory() should return, not about where the caller lives,
>> and can be sorted out separately.
>
> Yep. I tried to do a quick smoke test and got a similar build error as Boris. I
> guess you will send a new revision?
>

Yes, thanks for testing.
