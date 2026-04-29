Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A839B3815C6
	for <linux-efi@vger.kernel.org>; Wed, 29 Apr 2026 08:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777452954; cv=none; b=sW8QiEj1SYVh9XApVOCPCpPGNZaB1as7JIDmCapZXFBWR6cKb2vgM/M4ARC0F/wZnpq2tgNJRzfSCdG3UuC2V7Y25udoLwLN2vWNeH9WqS5JdW7pMYB6GoHuDCHLc5YuCxPpS/prwNzZix5LDhCGDmP0EV2ngGMhMk9A0h4PPo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777452954; c=relaxed/simple;
	bh=O/GSs85hzvhIPvia2rR93WkBMTqT8ZjtriJwaDoYRSE=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=VsbQ6IcAB1/kM/MtK08507tvGNw3xlxYBDbjGeTF5lbt0kADe5dwht2977xSTmi08t+LbyUl8Cyjzf0FrdIB3CXnd3TY3vD6U+WZt/b//Vy4oxGqmLHm76jvtwhC6zhKo0QpQb/4JUn1PL/rsg8xM9A8A3fZE1D+dpnasqjhmIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ao+pO9gi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ao+pO9gi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F44C4AF09;
	Wed, 29 Apr 2026 08:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777452954;
	bh=O/GSs85hzvhIPvia2rR93WkBMTqT8ZjtriJwaDoYRSE=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=Ao+pO9gi/I3imCbNIy5j+uLyA/XLQrE2+a2fYp0glFV1aTonAYK1hF/q3WMwazKm3
	 /37N5d3uRKpIFHuQ9zQGOoepvkdPlt8ObKdTxUgaeZs7tjz732rYw+2WDvmmEFv8US
	 Qa9I1thHu9VubGRAwcKLoxotRR+MgpNGZBkvXAud/KKQ8OQPEiAn42v5O63EaopNCY
	 D9WQ8KI4iHH/caz6IZ/27HHvxkdEJpYTQP4E2acwEgocxUzO0ODKQrB8+PIW9aiJgR
	 ssfaAtUVeFn1wPO6AKIH4wfQLwA3h8jXWXpPklzSThokvEq/y6n9F9yXRolZShDtNF
	 2382vloSwownQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 39C0EF4006F;
	Wed, 29 Apr 2026 04:55:53 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Wed, 29 Apr 2026 04:55:53 -0400
X-ME-Sender: <xms:mcfxaa8r7iLLvvCaQaNA2J_zX2XcLROJ8T-qnCliDuMPGYQ3yXsOcg>
    <xme:mcfxaVinir3A7wgq6jssaVlXkWC988F_OvC4622_Vw3GcJhbDLiJYpd-JHw6kvVUN
    1mMM7jKG6w1Qsv65LaQG0MB887iXohz8XnVZi-o4qnhB6dPIneyAG4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdekgedtudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhguuceu
    ihgvshhhvghuvhgvlhdfuceorghruggssehkvghrnhgvlhdrohhrgheqnecuggftrfgrth
    htvghrnhepvdeuheeitdevtdelkeduudetgffftdelteefteevjeevjeeiheefhfejieej
    fedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrugdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeijedthedttdejledq
    feefvdduieegudehqdgrrhgusgeppehkvghrnhgvlhdrohhrghesfihorhhkohhfrghrug
    drtghomhdpnhgspghrtghpthhtohepledpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    oheplhhishgrsegshihtvghflhihrdhsphgrtggvpdhrtghpthhtoheprheshhgvvhdrtg
    gtpdhrtghpthhtoheptghhvghnhhhurggtrghisehkvghrnhgvlhdrohhrghdprhgtphht
    thhopehilhhirghsrdgrphgrlhhoughimhgrsheslhhinhgrrhhordhorhhgpdhrtghpth
    htoheplhhoohhnghgrrhgthheslhhishhtshdrlhhinhhugidruggvvhdprhgtphhtthho
    pehsuhhnhhgrihihohhngheslhhoohhnghhsohhnrdgtnhdprhgtphhtthhopehlihhnuh
    igqdgvfhhisehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidq
    khgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepkhgvrhhnvg
    hlseigvghntdhnrdhnrghmvg
X-ME-Proxy: <xmx:mcfxac_YUM7RMumUvrTuQ7hKTLoUgmX3wwmjgevCuWWDwjHx1ziqkQ>
    <xmx:mcfxaRQx1lNUfZl-OD7IF3hBXKoLYIp6dk0pDqvNCXbz9kXQC_CstQ>
    <xmx:mcfxaWcWYSytjBvK2bIJe5YO_BD2Frpbb8-7RgB2zRliNm90g-ATWQ>
    <xmx:mcfxaTQV4EhZwOQxmqOKHO8-XM58Mc56aY_80zNHIyjegez2u9caHQ>
    <xmx:mcfxaSKXg1rxLP9ifMuDo7uRRunsfJUeH-sGomB9LDrXyY1LleKP8Ctp>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 172DB700065; Wed, 29 Apr 2026 04:55:53 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 29 Apr 2026 10:55:32 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "WANG Rui" <r@hev.cc>, "Huacai Chen" <chenhuacai@kernel.org>
Cc: "WANG Xuerui" <kernel@xen0n.name>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Haiyong Sun" <sunhaiyong@loongson.cn>, "Lisa Robinson" <lisa@bytefly.space>,
 loongarch@lists.linux.dev, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-Id: <cdbbe14e-c677-4c32-b7e6-19e76a716171@app.fastmail.com>
In-Reply-To: <20260429051318.1581350-2-r@hev.cc>
References: <20260429051318.1581350-1-r@hev.cc>
 <20260429051318.1581350-2-r@hev.cc>
Subject: Re: [PATCH v3 1/3] efi/loongarch: Randomize kernel preferred address for KASLR
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Wed, 29 Apr 2026, at 07:13, WANG Rui wrote:
> Introduce efi_get_kimg_kaslr_address() to compute the preferred
> kernel image address dynamically when CONFIG_RANDOMIZE_BASE is
> enabled. The function derives a random offset using EFI-provided
> randomness combined with the timer value, and constrains it within
> CONFIG_RANDOMIZE_BASE_MAX_OFFSET.
>
> Update EFI_KIMG_PREFERRED_ADDRESS to call this helper so that the
> EFI stub can select a randomized load address when KASLR is active,
> while preserving the original base address behavior when KASLR is
> disabled or nokaslr is specified.
>
> Signed-off-by: WANG Rui <r@hev.cc>
> ---
>  arch/loongarch/include/asm/efi.h         |  4 +++-
>  drivers/firmware/efi/libstub/loongarch.c | 16 ++++++++++++++++
>  2 files changed, 19 insertions(+), 1 deletion(-)
>
> diff --git a/arch/loongarch/include/asm/efi.h b/arch/loongarch/include/asm/efi.h
> index eddc8e79b3fa..f831320efd41 100644
> --- a/arch/loongarch/include/asm/efi.h
> +++ b/arch/loongarch/include/asm/efi.h
> @@ -30,6 +30,8 @@ static inline unsigned long efi_get_kimg_min_align(void)
>  	return SZ_2M;
>  }
> 
> -#define EFI_KIMG_PREFERRED_ADDRESS	PHYSADDR(VMLINUX_LOAD_ADDRESS)
> +unsigned long efi_get_kimg_kaslr_address(void);
> +

Where is the call to this function being added?

> +#define EFI_KIMG_PREFERRED_ADDRESS	efi_get_kimg_kaslr_address()
> 
>  #endif /* _ASM_LOONGARCH_EFI_H */
> diff --git a/drivers/firmware/efi/libstub/loongarch.c 
> b/drivers/firmware/efi/libstub/loongarch.c
> index 9825f5218137..51997a0e83bd 100644
> --- a/drivers/firmware/efi/libstub/loongarch.c
> +++ b/drivers/firmware/efi/libstub/loongarch.c
> @@ -38,6 +38,22 @@ static efi_status_t exit_boot_func(struct 
> efi_boot_memmap *map, void *priv)
>  	return EFI_SUCCESS;
>  }
> 
> +unsigned long efi_get_kimg_kaslr_address(void)
> +{
> +	unsigned int random_offset = 0;
> +
> +#ifdef CONFIG_RANDOMIZE_BASE
> +	if (!efi_nokaslr) {
> +		efi_get_random_bytes(sizeof(random_offset), (u8 *)&random_offset);
> +		random_offset ^= (random_get_entropy() << 16);
> +		random_offset &= (CONFIG_RANDOMIZE_BASE_MAX_OFFSET - 1);
> +		random_offset = ALIGN(random_offset + SZ_64K, SZ_64K);
> +	}
> +#endif
> +
> +	return PHYSADDR(VMLINUX_LOAD_ADDRESS) + random_offset;
> +}
> +
>  unsigned long __weak kernel_entry_address(unsigned long kernel_addr,
>  		efi_loaded_image_t *image)
>  {
> -- 
> 2.54.0
