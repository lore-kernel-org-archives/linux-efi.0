Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0723525A357;
	Wed, 29 Apr 2026 09:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777454139; cv=none; b=Q/xntl39MqiXi6VYeuOWanHPxRKcfug62k3ns94xRqEo4O1yTKzHlQBc/nyqNYAfx8yxKXL+XxtoV1zwRNVvRBJfE9iT6tKz0Kf6m36rCbuBcFlvGw2U6LjilC2jDXjKOM2zNPICqM9x/rAVBStFa//WWibB++DqWvwawIM1d8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777454139; c=relaxed/simple;
	bh=HoyPdVcg4KZlmtH8kv+yXCW7meKR7jg9DcjSYZOX9mk=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=tpzuDO9P4kJcYqz23iSihOctXK4nFGeWojQbKrSV/5ZInO02dLWcVP4ZQyCQACEpwxt7LfJlGl/Q10uD66GWa3VGMxl3YS1MFjAAn2E+k+hObHWzWy0bwOVeVmVKCBUy2ISRJ+xJAqI5C97JM3LAhtuRyg0NvzX+84uP1SnkkUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K1MUYtdD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K1MUYtdD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94B9AC2BCB3;
	Wed, 29 Apr 2026 09:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777454138;
	bh=HoyPdVcg4KZlmtH8kv+yXCW7meKR7jg9DcjSYZOX9mk=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=K1MUYtdDpxlSJvO468pK1Q4pFGoXnoPf7tewA696iSmy5As+lw3kwrXm+b9Pkf21m
	 RT9RbZwT1TlP2koscC2smFfSFrNfG+fhalRTxGq+w13oESIc34Ccgndqagn5ODj88I
	 oqZgkLVrWoM/uhXFl/Hgo5Hz+Nn9oQxg2ZhS2ICeGoz3aA/Qr/9d/hxNFjsopW687n
	 7YsiOWtrM3cRVoN4AzpAqo3iCDwRXf1ox9WguY7XxhSCQnxZOJW0Jzeena3oePjG6O
	 Q0XGfP6ru+5p3ckU8B86+pXdKOs3Q/bwcL7o9vXAgqwISz0GYZ0U/+/8oqTnrJC/5f
	 OKInKF+XS340A==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id A8B68F40068;
	Wed, 29 Apr 2026 05:15:37 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Wed, 29 Apr 2026 05:15:37 -0400
X-ME-Sender: <xms:OczxaUSydFc17fIqvjNZgOu5pd_Wf7dK-xxSN7Hrw2zolc9VrJUhIQ>
    <xme:OczxacnSFz-ddwAcbKIAx3Ednxw99q_pUTDOCCzjfqHge3zmjxWJRvbV9FpVHeE6c
    eIQrLXP0vSxt1TY-A6WJtvsJpoBrjLQ5LGs6NdSDZXcRHVCGoleSzY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdekgedthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthhqredtredtjeenucfhrhhomhepfdetrhguuceu
    ihgvshhhvghuvhgvlhdfuceorghruggssehkvghrnhgvlhdrohhrgheqnecuggftrfgrth
    htvghrnhepueetieduieegkeejvdehudeiheettefgtdeugffhjefghfeftdelhedvheff
    hfdvnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
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
X-ME-Proxy: <xmx:OczxaRwL1Xj4gA5NTT9RU8svJdn43eyrSA5R0tUDWRS0Oa5AwjHLQg>
    <xmx:Oczxad3JTNg_OIkjz9ghBDKjMsn7tuiIDkF1Sax9taY9G2F5rooiUw>
    <xmx:Oczxafy5cEcXnMOyfc9wZXmusfFYeZdIswfc0y7afUmDxeVxpN7D2A>
    <xmx:OczxaaWZ3N6-Nqu8ZIUTzP_JnFbhnHpzfWV-VcyCXJh_cuz2_FCo9g>
    <xmx:OczxaT-BMSxMZPJJZ2u2CV09kf1vlSLznxgGSMQ6akprSFJcXrZaywky>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 84989700065; Wed, 29 Apr 2026 05:15:37 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 29 Apr 2026 11:15:16 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "WANG Rui" <r@hev.cc>
Cc: "Huacai Chen" <chenhuacai@kernel.org>, "WANG Xuerui" <kernel@xen0n.name>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
 "Haiyong Sun" <sunhaiyong@loongson.cn>, "Lisa Robinson" <lisa@bytefly.space>,
 loongarch@lists.linux.dev, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-Id: <08229417-cc68-4cfc-9896-4dd82ada1b56@app.fastmail.com>
In-Reply-To: 
 <CAHirt9hCLMmfhyYisWGB+84OauMx1_w1maEpEZhx34dPX6xiyA@mail.gmail.com>
References: <20260429051318.1581350-1-r@hev.cc>
 <20260429051318.1581350-2-r@hev.cc>
 <cdbbe14e-c677-4c32-b7e6-19e76a716171@app.fastmail.com>
 <CAHirt9hCLMmfhyYisWGB+84OauMx1_w1maEpEZhx34dPX6xiyA@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] efi/loongarch: Randomize kernel preferred address for KASLR
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



On Wed, 29 Apr 2026, at 11:04, WANG Rui wrote:
> Hi Ard,
>
> On Wed, Apr 29, 2026 at 4:55=E2=80=AFPM Ard Biesheuvel <ardb@kernel.or=
g> wrote:
>>
>>
>>
>> On Wed, 29 Apr 2026, at 07:13, WANG Rui wrote:
>> > Introduce efi_get_kimg_kaslr_address() to compute the preferred
>> > kernel image address dynamically when CONFIG_RANDOMIZE_BASE is
>> > enabled. The function derives a random offset using EFI-provided
>> > randomness combined with the timer value, and constrains it within
>> > CONFIG_RANDOMIZE_BASE_MAX_OFFSET.
>> >
>> > Update EFI_KIMG_PREFERRED_ADDRESS to call this helper so that the
>> > EFI stub can select a randomized load address when KASLR is active,
>> > while preserving the original base address behavior when KASLR is
>> > disabled or nokaslr is specified.
>> >
>> > Signed-off-by: WANG Rui <r@hev.cc>
>> > ---
>> >  arch/loongarch/include/asm/efi.h         |  4 +++-
>> >  drivers/firmware/efi/libstub/loongarch.c | 16 ++++++++++++++++
>> >  2 files changed, 19 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/arch/loongarch/include/asm/efi.h b/arch/loongarch/incl=
ude/asm/efi.h
>> > index eddc8e79b3fa..f831320efd41 100644
>> > --- a/arch/loongarch/include/asm/efi.h
>> > +++ b/arch/loongarch/include/asm/efi.h
>> > @@ -30,6 +30,8 @@ static inline unsigned long efi_get_kimg_min_alig=
n(void)
>> >       return SZ_2M;
>> >  }
>> >
>> > -#define EFI_KIMG_PREFERRED_ADDRESS   PHYSADDR(VMLINUX_LOAD_ADDRESS)
>> > +unsigned long efi_get_kimg_kaslr_address(void);
>> > +
>>
>> Where is the call to this function being added?
>>
>> > +#define EFI_KIMG_PREFERRED_ADDRESS   efi_get_kimg_kaslr_address()
>
> 1. drivers/firmware/efi/libstub/loongarch-stub.c
>
>   efi_status_t handle_kernel_image(...)
>   {
>       ...
>       status =3D efi_relocate_kernel(&kernel_addr, kernel_fsize, kerne=
l_asize,
>                EFI_KIMG_PREFERRED_ADDRESS, efi_get_kimg_min_align(), 0=
x0);
>       ...
>   }
>
> 2. drivers/firmware/efi/libstub/zboot.c
>
>   static unsigned long alloc_preferred_address(...)
>   {
>   #ifdef EFI_KIMG_PREFERRED_ADDRESS
>       efi_physical_addr_t efi_addr =3D EFI_KIMG_PREFERRED_ADDRESS;
>
>       if (efi_bs_call(allocate_pages, EFI_ALLOCATE_ADDRESS, EFI_LOADER=
_DATA,
>               alloc_size / EFI_PAGE_SIZE, &efi_addr) =3D=3D EFI_SUCCES=
S)
>           return efi_addr;
>   #endif
>       return ULONG_MAX;
>   }
>

Ah apologies - I misread the patch.
