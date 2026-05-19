Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0407E40802A
	for <linux-efi@vger.kernel.org>; Tue, 19 May 2026 15:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779204434; cv=none; b=mVAqR4TX5tG7IgA9UqBR8i6UrC4oGPgXL0Bz/VIzB+cPvR1W/dYmSR4u3DKt7LT7tntVAVoATi41dZbdGPfHIXHcQwDldy4cQ/GcQvaOwgNmhYf88tqk87E9U0Q092LThYQo0UtTIvfacbmPdFtnm3RL6gI+98Dm1k+0/a5dsOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779204434; c=relaxed/simple;
	bh=8mbp85orKVOXghvRFoP9+ukIjwL3AK5WbhqVjK/SKYs=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=WInusUJbJUD6g5ttJbcTlE/CxwdkK2mP6CRWq+wZSu/Hqkk82ObOH4yQO8b0BOLgNLlOuKE9daWLxRmK+YW/b4IcCQP4QJetBqiyMe3Ip/HvAjHgwN7bjGdgPuKkum0g+SlIs7w+14SepZ0IcpZWAa7pP8NFT5f6WDO+mmhg+4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nAIq974P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nAIq974P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8539C2BCC7
	for <linux-efi@vger.kernel.org>; Tue, 19 May 2026 15:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779204433;
	bh=8mbp85orKVOXghvRFoP9+ukIjwL3AK5WbhqVjK/SKYs=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=nAIq974PETgMBCgPzz5jfX2jBdmgiNCjtvQgqyeCSvUgFCvgzxl+vVSSPs6f4wxaw
	 7YJzQHfa/EVfd/gzu2J6tP0OxD/PoIlaESGVApf3q/2rzMjYbdi1RWVoeriEHgMFS0
	 AIAs8raXjHNkEtpB464dUIUnU3HONbHdmB24dN5PD9rG/gcWT+PGPoW7oZpPFRD5ub
	 sjCmeyf4gEQcfeTGsx8U1p4ZwKJjM+Chq+ZqaUfiNXK9M8YQOaAh4JvxtV5QyZysCH
	 L5eDhUD+v+lGI7lVYujRgr9Yx2iJUgxBnnCO6HsohdS9+qVRQCLJ/Q/h7WDIULCOY8
	 ua1dZ2bUoIFJA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id F22AAF4007C;
	Tue, 19 May 2026 11:27:12 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Tue, 19 May 2026 11:27:12 -0400
X-ME-Sender: <xms:UIEMasXTcmn-bgmv-RS2uX_K0JMJe1untVChZ5aSnTC-8CD94CyEvw>
    <xme:UIEMarb8Ufvak0er-3T9N1NUuMV_lyOn6V57WxYlQ_EIPjOhiNNJ5jyTGW00dwqSp
    vL6g1ttRCUi6tYqia2lLyPhpep8Zx4A4DxuC1EaxLXUv1rfEfkccw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddugedvudduucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeei
    jeefudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopeegpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopehilhhirghsrdgrphgrlhhoughimhgrsheslhhinhgrrhhordhorhhgpdhrtghpth
    htohepmhgrihhlsehmrghrihhushhhohgthhdruggvpdhrtghpthhtoheplhhinhhugidq
    vghfihesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvg
    hrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:UIEMahcwyN7g5-91dBx1RIcveCf8fZFIY2eC2ZxkA0D3ieTWZCicpw>
    <xmx:UIEMaqpxO0xgF9-AaC-2ixFuU2t6762yDskQnoXjR2x7RQsyGSkHNQ>
    <xmx:UIEMauA0EZq5HoUEhtglbC4KR6TcxViDdq_TW5scYfUn3WMC39v42w>
    <xmx:UIEMavapgSjIDK2kK-k2gmB4EWyh77TXUpZrXI--A3Ud-5sVPWJvbQ>
    <xmx:UIEMap70wmOrGEFOeOO8G5n22dzkql0AjndDvCRN4sd1ivactGV30QXh>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id D1529182007A; Tue, 19 May 2026 11:27:12 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 19 May 2026 17:26:51 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Marius Hoch" <mail@mariushoch.de>, linux-kernel@vger.kernel.org
Cc: "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 linux-efi@vger.kernel.org
Message-Id: <420eda5f-d993-46c0-a93a-9375c71e1fdc@app.fastmail.com>
In-Reply-To: <20260517192346.1739732-2-mail@mariushoch.de>
References: <20260517192346.1739732-2-mail@mariushoch.de>
Subject: Re: [PATCH] efi: sysfb_efi: Extend quirk to cover IdeaPad Duet 3 10IGL5-LTE
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Sun, 17 May 2026, at 21:23, Marius Hoch wrote:
> The LTE enabled version of the IdeaPad Duet 3 10IGL5 needs the
> same quirk as the non-LTE version. As these are the only two
> IdeaPad Duet 3 10IGL5 versions, we can safely use non exact matching.
>
> Tested on a IdeaPad Duet 3 10IGL5-LTE.
>
> Signed-off-by: Marius Hoch <mail@mariushoch.de>
> ---
>  drivers/firmware/efi/sysfb_efi.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>

Thanks, I'll queue this up (unless anyone has objections?)

> diff --git a/drivers/firmware/efi/sysfb_efi.c 
> b/drivers/firmware/efi/sysfb_efi.c
> index 4c3986ddcd54..685283bb7327 100644
> --- a/drivers/firmware/efi/sysfb_efi.c
> +++ b/drivers/firmware/efi/sysfb_efi.c
> @@ -311,11 +311,14 @@ static const struct dmi_system_id 
> efifb_dmi_swap_width_height[] __initconst = {
>  		.callback = efifb_swap_width_height,
>  	},
>  	{
> -		/* Lenovo IdeaPad Duet 3 10IGL5 with 1200x1920 portrait screen */
> +		/*
> +		 * Lenovo IdeaPad Duet 3 10IGL5 and 10IGL5-LTE with
> +		 * 1200x1920 portrait screen
> +		 */
>  		.matches = {
>  			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
> -			DMI_EXACT_MATCH(DMI_PRODUCT_VERSION,
> -					"IdeaPad Duet 3 10IGL5"),
> +			/* Non exact match to also match the LTE version */
> +			DMI_MATCH(DMI_PRODUCT_VERSION, "IdeaPad Duet 3 10IGL5"),
>  		},
>  		.callback = efifb_swap_width_height,
>  	},
> -- 
> 2.54.0
