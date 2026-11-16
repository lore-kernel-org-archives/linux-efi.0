Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794839970;
	b=QzcrTmtnh8dPe4G3X/ufgZR2e1mH52hLcazzETSmffs90DG7WzQxtzZF6V2Lxp4B4ESU
	 pk73dgABhcqUqqyRiEpqmy5CSAvcE5P4hPw5vXNR71amelGGJ2/q85QGWVSOikTBN4oee
	 ALYOl4c6CivBncyfNXzeYQN4Tpu9DadKPqyizDnnVEd6PBV+gnByYZKPJ+CU07cb8Rryq
	 ZNSEdqSvMWQt/6KNEwIXfAXUZ0XXAzFfOBO1GT6jl+aU6z6omQXfT6A2xerQ7gBeoU3MV
	 k7pFEwhQjy1iI3LlRZcV6JffKzQTdqsOFH8dAoMjvscFiTStCauRXz61zakGm2l7pxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794839970;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=B9/GWhInAdPURKudeKpGcy01vE4EprmyJ4kNx4wIQic=;
	b=czKy1hqveGcxdaA8NQQ04ek1r7gyyvthY1bii3KWQcqW2MGStgRCMAJzXRbr/kjLKw88
	 SZF1mEYReZaP0M/kS6HtH9AeoEL7+qnVfP9HVKCwaxaN//EdalIEeJDFU6AcvA3T78Jhs
	 N3Zvopmmohu3bNgRhhFk0dTWfJg3zDeHn9JP8AWZEQueyntagQ3C833BHg2DRQuMlLnU4
	 WWC13bfVS44GYZUtKNo2xzCfA9HLXEgI2/ULtaIxY4YifBh0GJObxgvH1CBOmVpJfHRPj
	 Bd6NEgJJmjwQnXnVLK6hnf1olBanEJJn05yTAsWq12j5FG+3aXYC4t7NptKf0uXLbfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VqUDrM21;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C38A606A33E
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 14:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VqUDrM21
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E953B1F000C4;
	Mon, 16 Nov 2026 14:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794839969;
	bh=B9/GWhInAdPURKudeKpGcy01vE4EprmyJ4kNx4wIQic=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VqUDrM211d36Yr9bIROi9Z6vYI/OzAv5Zve0/qER050vfQQDzVceoU8xkmXSMRNR6
	 u5uiYEF9JlwjOXoiZkTpFVGV1f+7GRS99DGsjsn0YElVx4w5kUUSvb+cyvsW1+BDVG
	 +thYGxELWYFI8uaRFU9bJW7a8sWDvqS+hYY/9BC1ZJKgHLwwMNHFeDA8CNZeRqLbWo
	 0zygM3mx85YWGwMimC00VeJ+WQ/Y+ti0st9bMCxbkkdZquyqEUe8dV7q0NyqammStV
	 6Fe1/L/s3oMVtf+oc1DP3XWssQ26uqijjocea5rwrDVv6HSENIef+btsWGyTwwU3XP
	 XYr25tVY2hdhA==
Message-ID: <sashiko-outbox-217184@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 07/15] efi/libstub: Pass kernel entrypoint down to
 efi_enter_kernel()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ard Biesheuvel" <ardb+git@google.com>, linux-efi@vger.kernel.org
Cc: "Ard Biesheuvel" <ardb@kernel.org>, "Jason Gunthorpe" <jgg@nvidia.com>, "Paul
 Walmsley" <pjw@kernel.org>, "Palmer Dabbelt" <palmer@dabbelt.com>, "Albert
 Ou" <aou@eecs.berkeley.edu>, "Huacai Chen" <chenhuacai@kernel.org>
In-Reply-To: <20261116142618.1687025-24-ardb+git@google.com>
References: <20261116142618.1687025-17-ardb+git@google.com>
 <20261116142618.1687025-24-ardb+git@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 14:39:26 +0000
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Post: <mailto:linux-efi@vger.kernel.org>
List-Help: <mailto:linux-efi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-efi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] efi/libstub: bogus efistub_kernel_base() address on 32-bit ARM
--

commit 452448a07bb84c8f25cb8af4964ea6a4db8f2543
Author: Ard Biesheuvel <ardb@kernel.org>

efi/libstub: Pass kernel entrypoint down to efi_enter_kernel()

This commit passes struct efi_image_info down to efi_boot_kernel() and
efi_enter_kernel() so that the kernel entrypoint is obtained from
image_info rather than calculated from linker symbols.

> diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/h=
ead.S
> index 9f406e9c0ea6f..a7f58dfe41bc3 100644
> --- a/arch/arm/boot/compressed/head.S
> +++ b/arch/arm/boot/compressed/head.S
> @@ -1450,7 +1450,7 @@ __enter_kernel_from_hyp:
>  		b	__enter_kernel
> =20
>  ENTRY(efi_enter_kernel)
> -		mov	r4, r0			@ preserve image base
> +		ldr	r4, [r0]		@ preserve image base
>  		mov	r8, r1			@ preserve DT pointer
> =20
>  		adr_l	r0, call_cache_fn
> diff --git a/drivers/firmware/efi/libstub/arm32-stub.c b/drivers/firmware=
/efi/libstub/arm32-stub.c
> index f7151a4915ba2..b73a0b4fcd101 100644
> --- a/drivers/firmware/efi/libstub/arm32-stub.c
> +++ b/drivers/firmware/efi/libstub/arm32-stub.c
> @@ -127,7 +127,7 @@ efi_status_t handle_kernel_image(unsigned long *image=
_addr,
>  	efi_bs_call(free_pages, *reserve_addr + MAX_UNCOMP_KERNEL_SIZE,
>  		    (alloc_size - MAX_UNCOMP_KERNEL_SIZE) / EFI_PAGE_SIZE);
> =20
> -	*image_addr =3D kernel_base + TEXT_OFFSET;
> +	*image_addr =3D efistub_image_info._text_offset =3D kernel_base + TEXT_=
OFFSET;
>  	*image_size =3D 0;
> =20
>  	efi_debug("image addr =3D=3D 0x%lx, reserve_addr =3D=3D 0x%lx\n",

[Severity: High]
Does storing the absolute address in efistub_image_info._text_offset break
efistub_kernel_base() on 32-bit ARM?

Before efi_enter_kernel() runs, efi_stub_common() derives image_addr via
efistub_kernel_base(image_info) and passes it to
efi_get_max_initrd_addr(image_addr):

drivers/firmware/efi/libstub/efistub.h:efistub_kernel_base() {
	return (unsigned long)offset_to_ptr(&image_info->_text_offset);
}

drivers/firmware/efi/libstub/efi-stub.c:efi_stub_common() {
	unsigned long image_addr =3D efistub_kernel_base(image_info);
	...
	efi_load_initrd(image, ULONG_MAX, efi_get_max_initrd_addr(image_addr),
			NULL);

Because offset_to_ptr() adds &image_info->_text_offset to the value stored
in _text_offset, image_addr becomes the sum of two physical addresses.
That corrupts the initrd allocation limit (round_down(image_addr, SZ_4M) +
SZ_512M), either wrapping the 32-bit limit below DRAM so efi_load_initrd()
fails, or shifting it past the 512 MiB lowmem window.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116142618.1687=
025-17-ardb+git@google.com?part=3D7
