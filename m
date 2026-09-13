Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404CB361943
	for <linux-efi@vger.kernel.org>; Sun, 13 Sep 2026 16:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789317359; cv=none; b=YKVyN4+3T7eifEG5UzQgQMXqKIuj68fx5Alc+y4yzD34ODvtXDU0tWXff9FcN6SsoxLrREEwKb8535IIVCgiKMMPaYey1mRXw8PkYpaoo9aJtLMe3t6Yo+BiTi7oZtX3yr2I/bw4V/01hzZCllYH8W6DAd+4aMtssCcUip6F2VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789317359; c=relaxed/simple;
	bh=syRLLaTbbkRqf7ULKYiWrw01EvEz04f3MgJhJlK5Oww=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=k05c0u61zCAUuzOkuhVk0Bz9shlqCLIKWdiKdSbN4BWWe5TT04Z0F0L3i+QfIRTgedztL6pibMkL8xn7ZYqKX3PkHgXMTdqqc0vRasd6twhekwsFMF4cPBIukTf7TqZKF8Jymdg0ev4o7ryMz9l3Oo1LXKCqZF3GT1ndAUHwzEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ByPw/t0a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ByPw/t0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B2A1F00893;
	Sun, 13 Sep 2026 16:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789317357;
	bh=kD6A/JyFUqLL9iYXCsC4e135a5kpWhi8Sv7OGIVOzX8=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=ByPw/t0aO1yqgYBpYDv28K1KD81++UKGmj6Tw0Kn02YzJOQkCF8F+gILXCLK844qv
	 phps1DMeN8KPiWfW9drl9T9jRr83eUS0JJqx7et0XA789u2TRZEFNjoS7jRaMNvy1x
	 eXgAZPdO5vPrAQdSq5uwqIxc8l1BzJanzaqkKlQaVJIBt8GAiylrPwhrKbtfXRZobQ
	 aVutshvpg4ZzZ/1X7CbkzoISjYfUwgsXs2aOwdjQ81ONaW685miJsSdhO9Z8BV3jD6
	 Ld0qtDN9UoU9tG/hjpvXytupjk2rb1aozmw4Xp5ek6B+AqMBPEoUlEIn4LEVvwnBXH
	 629ImWkbFwMCQ==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 6CA9B1980052;
	Sun, 13 Sep 2026 12:35:55 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Sun, 13 Sep 2026 12:35:55 -0400
X-ME-Sender: <xms:6dCmasOP7Nb50u1ehy6pP8n2xaGlTZ5YYN-5DEzol6Eg9Au14sYxHg>
    <xme:6dCmatw7NYmTIGZEDbUt_SmUEDFN7mky_udZUsk4x4XdjF4Ed3VHD8U-eagbtqmOu
    34_V0fMlONLv7xbpSCgFvvHb1625lq_qawcygtAgDQ-kK-qizlAkvw>
X-ME-Proxy-Cause: dmFkZTEurrpb6X4yZyfyIk5xpoJjSevjD/sx13uZ/EGRGXmz4irO4fBnDjBvd5iHgqgPAZ
    +xYv3wEE+LNHxKhRMf1oBU83aJN43CNTp53H63DiypGMRIWrwtnMBMsE6vK1FTyxmljTY9
    e6Bv8t83ykU39RcT+Lfm1mgweaWwMZoAZWHMrzsOUUYjP/E6Q6WsZIQfF9E2X9elSsM1wG
    CzdxoYbxyCcYuw8N2E37742Q7U9okFuEpcXoHom1IWFQOeo8YXapNZ3yMcQJW7SYP+A+D3
    c7sVNZK7c5ho14UMClOeUdxIA+5Pxjzam94mKF6ZbbCHoKC0o9MJ/FljCDkeAwzCH5WHUQ
    dXVW6rH80uO+yAtu2yH5FFwj8Ed9qYHY1/RSuuMT2l276fmBs4jBMxvT8HeGR6DVkpR6vn
    03n+DSvIeA1wtshOeCMvqEu+ZGM1LbQG5rEu49LI6MMGAA7MRdJkxEU9DnXV9mQfI3bF27
    Wvz1NBZk0HFBh5AjsxgXlsFRbSfS6/Y01+MJ5zSfsgCtLXz3SEfSlUFss/aC/UokXYVBoN
    pknaXiAe5CBoP4E0SF7acD9kALP4C1Tv0U53ftKq/SYOV+FRzAtz61j6ORnP0ugUfKy5pI
    ehLPrr7X52jlLMaz3iBY2RoAEQHV8q11hgq9FnzU4TprtrdAUs1sz53ex+jw
X-ME-Proxy: <xmx:69Cmal1G3HiiVi9kU0DiVVJQDesAZbM4xpJDxy5YpsnmutjpzZ8njQ>
    <xmx:69CmamLjCjO2tTD_pG1r4BXdq9LoRTKovPVflx2bX3HbWA2s_EBapw>
    <xmx:69Cmalw4H5Kuyiz1AF15BfGXY4SZvRO_FleKFaRJewck033Oazaqhw>
    <xmx:69CmakWiJo92yURNxp0rTBa1iN87mD6v1enAjvxn6UF4IWB5iaO-0w>
    <xmx:69CmaljTZao1gzjI7BG9UOlFAj9V3rxiOA0GH5lvhBzz31PTJtibP3gR>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 84455F8007D; Sun, 13 Sep 2026 12:35:53 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Sun, 13 Sep 2026 18:35:33 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Borislav Petkov" <bp@alien8.de>
Cc: "Kiryl Shutsemau" <kirill@shutemov.name>,
 "Ard Biesheuvel" <ardb+git@google.com>, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org, "Vincent Mailhol" <mailhol@kernel.org>,
 x86@kernel.org
Message-Id: <862d50e1-2072-407b-882d-5e3074a3c225@app.fastmail.com>
In-Reply-To: <20260912175410.GAaqWRwnz7bHUtXYSs@fat_crate.local>
References: <20260909115530.1924665-12-ardb+git@google.com>
 <20260909115530.1924665-13-ardb+git@google.com>
 <20260909191410.GAaqGwAsCewrdVZZ0s@fat_crate.local>
 <cee2e02b-3817-44cf-857f-62a148290367@app.fastmail.com>
 <aqKrhNQ3mZMs5-Dy@thinkstation>
 <b24b9785-b790-476d-985d-e8c5405d192b@app.fastmail.com>
 <20260912061005.GDaqTsveevVkzxRJoI@fat_crate.local>
 <b259aff1-1fb1-4819-88ca-9b47dac036cd@app.fastmail.com>
 <20260912175410.GAaqWRwnz7bHUtXYSs@fat_crate.local>
Subject: Re: [PATCH v2 01/10] x86/boot: Drop pointless re-implementation of panic()
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Sat, 12 Sep 2026, at 19:54, Borislav Petkov wrote:
> On Sat, Sep 12, 2026 at 10:41:56AM +0200, Ard Biesheuvel wrote:
>> If you're not taking it as a fix, then yes, please.
>
> Help me understand the exact problem pls: 
>
> That panic() function gets called by arch_accept_memory() and *that* gets
> called only by code in drivers/firmware/efi/libstub/unaccepted_memory.c or
> drivers/firmware/efi/unaccepted_memory.c (but that uses the kernel proper
> panic() one).
>
> So we *are* in the context of EFI boot services.
>
> What am I missing?
>

Right, I'd missed that.

But when booting via the EFI stub, the decompressor is omitted entirely,
except for some TDX and SEV-SNP code that is shared between them.

This means calling error() is a bad idea, because the TDX initialization
code that overrides the port I/O based __putstr() handling never executes
in that case.

The reason I want to get rid of panic() is because snprintf() is going
to be removed from the EFI stub.

So I think the current patch is still correct. I will follow up with another
one that moves arch_accept_memory() into the EFI stub, and drops the
dependency on error().

 
