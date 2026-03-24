Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C743D3CED
	for <linux-efi@vger.kernel.org>; Tue, 24 Mar 2026 09:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774345827; cv=none; b=nYPOV0Q5dC+z+C4HB7Z91tP6LH1ncLtj8TwH/c0LQBH/GgWeFFL+3BHzDQskbLKCXoxxHrnS9uV5XiZ1G35wDgBxMhaa41buWbqVGOKThCdSHMluJVokFDfVsKIZN4cJl8GNP0KWjAD7so0fUf9WTqIP4CtFILdrignDV3tKJMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774345827; c=relaxed/simple;
	bh=IS0+rfgdfuUFu4ufXz4Qc8ExzjqQwFAH2zh54FD20do=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=OmLYitgfjq1N283eGcVABqfWptOwB2xoXvzTVNZqvCtL+B9SIvWzFHOgJwIDlvq4MPAEh6X6z7F73Ri0y5bO4pjZ68CVgtDfmUITZ/pMyWFCZrdrpgJCBQEFRZ+h71XaUd0T0VlFJWEH1NO9/ur4wQOTyVm6WgUnF1N9nSurzsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MyKz2qy3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MyKz2qy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B65C4AF0B;
	Tue, 24 Mar 2026 09:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774345827;
	bh=IS0+rfgdfuUFu4ufXz4Qc8ExzjqQwFAH2zh54FD20do=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=MyKz2qy3yVkslXM21GcvP+NTJt4Q/9wN8XUTwYSGqGsFP/C6i4OksSxu1DW0ApBYY
	 AhrRutaYPuqMKlHBkw8JHx5fgVvuJ5nIF6n+5WHLjQ1AVS/9q97ZS1qYVnwMUac2//
	 avARt5jY4nzhbJiN6Qe2uqhtGzr1MHeeNBuN6+HHSabkviDMHz0/U2gGOY12s3CHly
	 Hhv87gWa9D6JTRGoMKDEejuSQDis5pa1K1yAHY2fw1rLD/qndlR4FcBJSIz6AW1nDt
	 WIVN1mqxyF7miToc4ot7ikheeSj9OEtSeBxCD0Hd4Juwv3RZusspJINHjepgEaeEEK
	 NJsmFyriDpUNA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 3846DF4006B;
	Tue, 24 Mar 2026 05:50:26 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Tue, 24 Mar 2026 05:50:26 -0400
X-ME-Sender: <xms:Yl7CaRz_4FNqW_p6HCrr_ASnHvUDgfUggyg3G_m2swC1H4CTE2qwNw>
    <xme:Yl7CacGaXi1oZsRyCBtb8REivENwALylFUt_SvIINvcP47YW3GCLK9R0jE2wbVbTU
    n3rMF64F16mzSOA_BVKxhcepy4lclfAwUmy_7cb1ZH_y2CYFFyDQA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefvdduvdeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeei
    jeefudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopeeipdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrrhgusgdoghhithesghhoohhglhgvrdgtohhmpdhrtghpthhtohepsggvnhhhse
    hkvghrnhgvlhdrtghrrghshhhinhhgrdhorhhgpdhrtghpthhtoheprhhpphhtsehkvghr
    nhgvlhdrohhrghdprhgtphhtthhopeigkeeisehkvghrnhgvlhdrohhrghdprhgtphhtth
    hopehlihhnuhigqdgvfhhisehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohep
    lhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:Yl7CaeXCR11Jcfv4wviBlpeCxNj7HxzKVX7l-uTvrPv-l6wLCCmhdQ>
    <xmx:Yl7Cac29kXCGNkbSqpnxDDrQhlKsISvWvk1_WHEP7kU1-wiRghEHHQ>
    <xmx:Yl7CaUra04hGvBomZBgmLQlRqAAaZvMvfxFxTL0MrrlXqa2gRZ7UDQ>
    <xmx:Yl7CabXbOY9IuUNGNWbtsVgd3OOzaQNR_X2PkFlwxdAIL1x4p4yd-A>
    <xmx:Yl7CaXb-l7_Ls_qxq-3hH76bdGUwgLM7KHHR17knR0qU_GC7twwynOdf>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 0F22C700065; Tue, 24 Mar 2026 05:50:26 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A_C-dXp6MCYk
Date: Tue, 24 Mar 2026 10:50:05 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Ard Biesheuvel" <ardb+git@google.com>, linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org,
 "Mike Rapoport" <rppt@kernel.org>,
 "Benjamin Herrenschmidt" <benh@kernel.crashing.org>
Message-Id: <f4c11afa-e934-4457-8a3b-89a0ad2f4263@app.fastmail.com>
In-Reply-To: <20260319090529.1091660-21-ardb+git@google.com>
References: <20260319090529.1091660-21-ardb+git@google.com>
Subject: Re: [PATCH v2 00/19] efi/x86: Avoid the need to mangle the EFI memory map
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Thu, 19 Mar 2026, at 10:05, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
>
> At boot, x86 uses E820 tables, memblock tables and the EFI memory map to
> reason about which parts of system RAM are available to the OS, and
> which are reserved.
>
> While other EFI architectures treat the EFI memory map as immutable, the
> x86 boot code modifies it to keep track of memory reservations of boot
> services data regions, in order to distinguish which parts have been
> memblock_reserve()'d permanently, and which ones have been reserved only
> temporarily to work around buggy implementations of the EFI runtime
> service [SetVirtualAddressMap()] that reconfigures the VA space of the
> runtime services themselves.
>
> This method is mostly fine for marking entire regions as reserved, but
> it gets complicated when the code decides to split EFI memory map
> entries in order to mark some of it permanently reserved, and the rest
> of it temporarily reserved.
>
> Let's clean this up, by
> - marking permanent reservations of EFI boot services data memory as
>   MEMBLOCK_RSRV_KERN
> - taking this marking into account when deciding whether or not a EFI
>   boot services data region can be freed
> - dropping all of the EFI memory map insertion/splitting logic and the
>   allocation/freeing logic, all of which have become redundant.
>

Please disregard this for now. Sashiko pointed out some fundamental issues in this series, and I think it might be better to take a different approach entirely.
