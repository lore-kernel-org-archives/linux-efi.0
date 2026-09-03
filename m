Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DBA45D5F5;
	Thu,  3 Sep 2026 11:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788435333; cv=none; b=DBfYZZPl7FGPsBmSx7hD5TY9MTG8LIRZ4j5Ph4DoSgfuU//sY2Nm9zYNsYbQmQqyvZxyLGFspzwvP9c2KYwyD9gJE3pwWDO7xTANVv8K8KAf92aCkIRLxkB+vAikg2zkiKNX51W+hAnGl9NkWs+SBtWGnaDdxCBF/AIrVFB+9s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788435333; c=relaxed/simple;
	bh=WNhBU4gBRi7n5E2RV+yY1aQmqX5dEeo2lb8vnV0Klcc=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=DsBp5lFa1yIjItdlFwmYCMo/13uLPk0oo5zKL6G57EtiEQe/jrWSeVjJMXxvMIbcj6LI2dmsJB5SIe+0ZV+aPLxUISGgY/ROzidXdQbr7q7nm60o206KLj9qkmjey80wviw9svCRYXDxCaGe9PMQNEtzd0fSlS+y3TKG6e84KhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O2IlCtuM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O2IlCtuM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618FE1F00A3D;
	Thu,  3 Sep 2026 11:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788435322;
	bh=GI67CPM8yi0ZXHmIKGRDTSpV4PxMt/Uk06vuw2OahkI=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=O2IlCtuMNbakoyXY2D31P0E159cHIcVJigxX8w1haBC94Qr6S6epMXjHIa6zRKBcI
	 OE+3f+rxDwwrGfsAD39fX4eezjvDMWYQsiEBdjcI2ykCvpuYqCZaATkfJtH49cQ18l
	 krxnRw67DEnZu6K+iHbcYVCl8cpwh6T+2TyVgAZ1f3p50VYIJOnhiW6vlOJB77V4Ko
	 bG6Ibq/G59tGMPHPCGWYjsKzLdkjHjjnOyo4mBexT8oQGRPZLzX6I9LxqSU40yLiBI
	 6ioEwGaIon7j50uKjJMCzEfi2pGebyH9VSRHP603iIbFtQsc0r2t+s5gmnlXTPVxsg
	 JAvkM9kZDFz6A==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id E4DBF1980047;
	Thu,  3 Sep 2026 07:35:19 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 03 Sep 2026 07:35:19 -0400
X-ME-Sender: <xms:dVuZaovR-c4KRU0bTmDyoCGKVMfDysb6kHC1eD5iZo1XHtRzHLg5MA>
    <xme:dVuZagTuUyST6iT-SQLgc4S5CPheVwCXWPsq_mLPsKpOjysyPxS8RjXzOtmsnJIsE
    R0PLVOL7-kSEieR9iijT3rSlPzPfP4Uw1qparPP_tnFvwZYqtGYWTHQ>
X-ME-Proxy-Cause: dmFkZTE35Cj2o9w6o+pggtHOOqOz+sFl03EWpmd0tgzo6J4wCd8a6EDhiYd49BIPNtsWXQ
    0iMYBwpT31vuwS1JR8RCBFTjzAOhlfyq3ma8jZDDtkEvhBXicIKS9OZnuxqiHsod5f97xV
    J8FuqC6e1eFexwdHQ5OjGxcGDKBn7IryT10wtxIaC4dZKH5cEiidOl7qSUhty7IyZid1Fl
    fJ0P/6Mj3V5MrBQ8WAroV/0glwDye2vhVcP3ViBaNekQHcc/o76j8jjKJ02MtH+5zbHJSw
    +wpKAV5qAtjs+NgZNC3uSWYGjXjfwAGnlPYRQsAVCbM4H1PPFRNi5pfmReEaN61S6yq6m/
    m2p+KCzk8ukGUj/kpko5dgEeh1qnctYJ9br2Pae92FQF+tYhovlKnfL2iqeYktjPnfAk/m
    QjD5Bzno//eaVQPd+UzOzdmPZgjpenScHoY+Trtdb2FKlTvt0XEgWaQ5kDNUaGo1qGjiwo
    nlswmSKj5eQT7TsC7UUKNsL+u8qbVBS/QO6Ds8ZwXRRCiIlcAfYe+la8gV/Tovgl2NjQOO
    dweU/H5/dm2ZtkVoyH71W94LMdRNNDu5RgOWguqkAVYgC4NDPF2qmjcSI6JU9aBDfc5FPQ
    nhqY/ZXhVMXQQ6ujvQfC/dRftD41+DoPW3t84Fqh1lJN4xRWiI6VMF5Jrbwg
X-ME-Proxy: <xmx:d1uZalmMn24bZvw6ZcLzuvbcrJAKUgXdzzzS8Ud0C6nXYA5EVSPc0Q>
    <xmx:d1uZariQuCSm2xXM69lE3G6vkzqSsl66MJ4aSRGJ0xZNmHI3CWwIlg>
    <xmx:d1uZaiSh-nrRtvN90zTY6qN6k34XEQY-5mUsY52qudIhz0_2VpP38g>
    <xmx:d1uZagiQ1esEatnM-Y_IcDnASzPxDyVKHWkMTHuTWVtpIJAbsM8j7g>
    <xmx:d1uZauiiVEu2LLn_6b5rQDBKimEFB2v8DRx7K80_-fufnxKLOWw9oQim>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 12337F8007A; Thu,  3 Sep 2026 07:35:17 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 03 Sep 2026 13:34:56 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Sven Peter" <sven@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>,
 "Lorenzo Pieralisi" <lpieralisi@kernel.org>, "Rob Herring" <robh@kernel.org>,
 "Krzysztof Kozlowski" <krzk+dt@kernel.org>,
 "Conor Dooley" <conor+dt@kernel.org>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Catalin Marinas" <catalin.marinas@arm.com>, "Will Deacon" <will@kernel.org>,
 "Sudeep Holla" <sudeep.holla@kernel.org>, "Janne Grunau" <j@jannau.net>,
 "Neal Gompa" <neal@gompa.dev>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
 asahi@lists.linux.dev
Message-Id: <9c53cfd7-e193-4441-83ca-7710060225b7@app.fastmail.com>
In-Reply-To: <20260708-efi-psci-v1-0-9efb3abf0e4c@kernel.org>
References: <20260708-efi-psci-v1-0-9efb3abf0e4c@kernel.org>
Subject: Re: [PATCH RFC 0/6] PSCI-via-EFI to support firmware and kernel sharing EL2
 for Apple Silicon
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Sven,

On Wed, 8 Jul 2026, at 09:15, Sven Peter wrote:
> Hi,
>
> Usually, idle and sleep state are implemented in firmware running in
> e.g. EL3 with the kernel trapping into that from EL2. Unfortunately,
> there's no EL3 on Apple Silicon machines and we'd rather not run the
> kernel in EL1 since this would result in losing KVM support.
>
> While the shallower states could be implemented inside a custom cpuidle
> driver (like we do downstream, see [1]) the deeper states result in a
> complete loss of state and require bootstraping the cores again which is
> quite involved. So instead we need some way to call back into our
> open-source firmware to be able to handle that. This is even more
> important for M4+ which don't even support the architectural wfi anymore
> and always lose state when that instruction is executed.
>
> Luckily, EFI runtime services provide much of scaffolding we need,
> namely a way to keep some code and data mapped and the ability to jump
> into there from inside the kernel.
>
> This series adds a custom EFI table that points to a PSCI entry point
> (plus some other stuff that has to be available before EFI runtime
> services are set up) and adds support for this new conduit to the psci
> code. We can't directly use the normal EFI runtime path because that one
> takes a sleeping lock and we need to be able to call into PSCI from
> atomic context during e.g. cpu bringup or during idle.
> It also adds support for specifying the specific MAIR attributes for EFI
> runtime mappings as defined in the latest UEFI spec since Apple Silicon
> is rather allergic to using Device-nGnRnE vs. Device-nGnRE for its MMIO.
>
> This all results in a surprisingly small diffstat. I believe this
> approach was originally suggested in some IRC discussion years ago,
> possibly by Ard, but I can't find the old logs anymore.
> Happy to add a Suggested-by tag though if anyone remembers.
>
> The firmware implementation I used for testing can be found at [2] and
> the full kernel tree with this series applied at [3].
>
> Best,
>
> Sven
>
> [1] 
> https://github.com/AsahiLinux/linux/blob/asahi/drivers/cpuidle/cpuidle-apple.c
> [2] https://github.com/AsahiLinux/m1n1/tree/psci-via-efi
> [3] 
> https://git.kernel.org/pub/scm/linux/kernel/git/sven/linux.git/log/?h=efi-psci
>
> Signed-off-by: Sven Peter <sven@kernel.org>
> ---
> Sven Peter (6):
>       dt-bindings: arm: psci: Add EFI conduit
>       arm64/efi: Add and parse custom PSCI EFI configuration table
>       efi: Add EFI_MEMORY_ISA_{MASK,VALID}
>       arm64/efi: Honor EFI_MEMORY_ISA_MASK for Device-nGnRnE vs -nGnRE
>       firmware/psci: Add EFI runtime conduit
>       arm64: dts: apple: t8103: Add PSCI and CPU idle states
>

I've picked up patches #3 and #4, which are useful in their own right.

I'm not sure if the arm64 maintainers will want to consider this, but
I think it's a reasonable compromise, as it puts the abstraction in
the right place.

I take it this will be contributed to u-boot if it gets accepted here?



