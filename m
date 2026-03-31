Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E9F3B3BE3
	for <linux-efi@vger.kernel.org>; Tue, 31 Mar 2026 07:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774940854; cv=none; b=EW7eBZU6ga/hgG6c2I0yUFvbMIXkBDDHRp4ITP7IFVl1DxkHQmaC0h8tmQEIQfDX5TfSiaoA/qLCcKMe+rFcIsTEI3pALCqRsGagVxopP4VBSMuAWKmoPZwyiT1UxbbZSUhv7U2+2Os8aC82iP2NPp7fLraoYxyoadOh7vt9pCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774940854; c=relaxed/simple;
	bh=5hhsjDLE9pNupvcpyt3pLkHUAnRs5UEgXGmbpLk3fUk=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=OVKotXdqdJoUDSmKuMtGweigDw3v519tX1Ua8LeMOarwSejhQIypW//KbD5JOAgs7Z+bjbZs+8MLPIqk2bHuySFZKf3ZrpKK9yqpW+nar4xUkfKFLS1rQ/7SMZQuF3polSDcDmSLaSee/FAvrEfUb/ZGhsITCb3UxWVcGDi3zN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WFzyNyvM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WFzyNyvM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFAEC19423;
	Tue, 31 Mar 2026 07:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774940854;
	bh=5hhsjDLE9pNupvcpyt3pLkHUAnRs5UEgXGmbpLk3fUk=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=WFzyNyvM84zF5PzozJTJrhLPYa1KFDKwXZwxmFHJ83R9ztGPRIiWaWCPZ9CvKK5F0
	 JSxXiwn4j3c+lHr8CDtYbhrhqEeTbjsO4UuawwwYZ/d5WbFX5XuPPx1SMyWzUEyRwW
	 0A5Y0Z1jKagrubmQ3Vf3zcJwURWWd2lUjg8CrCNZAOdttvkCgav0viJu4IQZP0NYtV
	 slXO30+UiRxNLmqyeOSiyx+4A9b6KiT9XlJIbfCggKaUDmeDpDcGr83GfORzBYT9vH
	 qyVo/J8XyVMEeo2o+9UXqK4lsiqp++wdyv8moAoyyTrNzq+azV+kj8CJnzwm2lBLDA
	 RZJ3Xl8j1Pymg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id C4C86F4006E;
	Tue, 31 Mar 2026 03:07:32 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Tue, 31 Mar 2026 03:07:32 -0400
X-ME-Sender: <xms:tHLLadocK8sL8RDGILdHR5O04fECPuhMVhZUJxhi5KV6j4XZEuzVCQ>
    <xme:tHLLaaf4zb0Ya6Zg380XOt3-_M_ojUsRgHlF58EqG1ffR_JplLfAi0RKtYL_0A9-x
    RqHcGFsUwYh7-aDkei25Lp2b8i5vPp678hxG_xK4LHw1qh-dcNjGfA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefgeduvdefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeei
    jeefudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopeelpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehlvghithgrohesuggvsghirghnrdhorhhgpdhrtghpthhtohepuhhsrghmrggrrh
    hifheigedvsehgmhgrihhlrdgtohhmpdhrtghpthhtoheprghruggsodhgihhtsehgohho
    ghhlvgdrtghomhdprhgtphhtthhopehgohhurhhrhiesghhouhhrrhihrdhnvghtpdhrtg
    hpthhtohepjhhirhhishhlrggshieskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepgiek
    ieeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepugihohhunhhgsehrvgguhhgrthdrtg
    homhdprhgtphhtthhopehlihhnuhigqdgvfhhisehvghgvrhdrkhgvrhhnvghlrdhorhhg
    pdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorh
    hg
X-ME-Proxy: <xmx:tHLLaU6U2OXL-Ek790KlJsXEpX4cYv1Bpwab5sy_Naed9HLQElQ4xQ>
    <xmx:tHLLaWXv_t_8lUbucJIXWsabnYmTnBbE_gunUvGyJQb8zAYrqhqSHg>
    <xmx:tHLLaUKow3pe-kr093hgMpQRBHKJWfNQfUhxzYzXRJNGa1cCMojSow>
    <xmx:tHLLaQvXHd_h_b8C9LM62XvzZxd9uGlTwQpGuilQfB_t7OruvC7tdg>
    <xmx:tHLLaZKqsgr30Voms5ayqjvo47pLVKfhQ6i5se0CesViE4cmpKYu9ubg>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 8544F700065; Tue, 31 Mar 2026 03:07:32 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AatMSBWUS2yF
Date: Tue, 31 Mar 2026 09:07:12 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Gregory Price" <gourry@gourry.net>,
 "Ard Biesheuvel" <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 "Dave Young" <dyoung@redhat.com>, "Usama Arif" <usamaarif642@gmail.com>,
 "Jiri Slaby" <jirislaby@kernel.org>, "Breno Leitao" <leitao@debian.org>
Message-Id: <5d2213b7-a792-4eb7-9c2f-b029cde099e4@app.fastmail.com>
In-Reply-To: <aclmumCA5ADfT7-Z@gourry-fedora-PF4VCD3F>
References: <20260326132655.1733873-7-ardb+git@google.com>
 <20260326132655.1733873-8-ardb+git@google.com>
 <aclmumCA5ADfT7-Z@gourry-fedora-PF4VCD3F>
Subject: Re: [PATCH 1/5] efi/memattr: Fix thinko in table size sanity check
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Sun, 29 Mar 2026, at 19:51, Gregory Price wrote:
> On Thu, Mar 26, 2026 at 02:26:57PM +0100, Ard Biesheuvel wrote:
>> From: Ard Biesheuvel <ardb@kernel.org>
>> 
>> While it is true that each PE/COFF runtime driver in memory can
>> generally be split into 3 different regions (the header, the code/rodata
>> region and the data/bss region), each with different permissions, it
>> does not mean that 3x the size of the memory map is a suitable upper
>> bound. This is due to the fact that all runtime drivers could be
>> coalesced into a single EFI runtime code region by the firmware, and if
>> the firmware does a good job of keeping the fragmentation down, it is
>> conceivable that the memory attributes table has more entries than the
>> EFI memory map itself.
>> 
>> So instead, base the sanity check on whether the descriptor size matches
>> the EFI memory map's descriptor size (which is not mandated by the spec
>> but extremely unlikely to differ in practice), and whether the size of
>> the whole table does not exceed 2 MiB.
>> 
>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>
> The 2MB limit is a bit odd to me - but then i don't see a legitimate
> reason to need 50k+ entries here unless the system is doing something
> absolutely nutty - it would mean a wildly fragmented system and most
> likely an indicator of a bug rather than a legitimately intended
> configuration.
>

The 2MB is completely arbitrary. We could use 1M or 32M for all I care. The original report was about a bogus table eating up all the memory.

> Otherwise, this does seem like a better check regardless.
>
> Reviewed-by: Gregory Price <gourry@gourry.net>

Thanks.
