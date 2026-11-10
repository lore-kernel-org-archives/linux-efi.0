Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794313644;
	b=cBzrcSsexRV62v3d1yTpmJ2uxFrPTXkT7rrmJ178hkPCIzDOHwe/m8mVZwNSB5BxzG1A
	 7nayYZ5/t5fIDfAQi3nO2SA4XNgsV72t2zjE6UsvtYZJ3vjt6TN9mxc3uTznxS2atNLX8
	 4df/ODjAECYGF4M8Hg/a2MqExBkKvgLE6cbPUY1M4f1olIVZoZSCK+4FwmMjORswtbTvW
	 HiqMWS3HX2mnEQK2/CuWS9W+TS8alfHL/sipcWWooFDwxsHun8jjjr2UolI9JpkLgnqbR
	 cRiJ62coi1aEI49maVIwoK4C5gE7LO7s6rN+oyH7kLvF8Nx0T7mkUnDm2Qaf+WlE9Ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794313644;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=d021EGXoTrRdRTkmlLM22kAv6+JwIRqz3AMqhUqSoxY=;
	b=xtwl6Zoc6cNXITe+7VsTtK2u080dLV2tf2oocfppV6c8fp35VIWimwecLJh7YqbtzusA
	 azRo/nVlCwWeCoul2MTWXQkpN4ACfz6GWvvwDunuTL0PUX2YzDFVxD9sQED40j3Akq58l
	 F6mnVy1JabSE2l1evEbPuFkVv/XyBbGe5VJz1ePYNvGDujnQ9Spk8WmRoEK2S08Nyxtzm
	 87qBeQYWNUuqDB5qHBkThsu7JcwXSNha8MIOQdpBoXx7GvruI1al62DZ6BgGnbOuQpSQa
	 uNXmaLDB7pNhRUylTOiUVNO5JlUa/ussRewIFfRgxy5Oqy6gmmsLo6Lz6wNONfEyKbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iwQuVSka;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A61CD606A31C
	for <linux-efi@vger.kernel.org>; Tue, 10 Nov 2026 12:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iwQuVSka
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93181F0089F;
	Tue, 10 Nov 2026 12:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794313643;
	bh=d021EGXoTrRdRTkmlLM22kAv6+JwIRqz3AMqhUqSoxY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iwQuVSkaCjMaERsdSIRMZ7THlXHXYA2ssH0jZ5A4MMra9ZSVKZLUCzE4F3z5r2mSy
	 PneAjZH/+MtiE+LD51Cw34VAMC56pHwMHMkYGdCXkGz3ALE1p2C0FI2fAwC9RzncSA
	 h/PpdmhtLxXlF2Qn2Lh83iR66wEePfLnNqYs2NbXn2wVANaz5Jgrj12QB/hD5sT6t+
	 EWdjfcMiF8qUjo/PUkHemt3Qr+sqmqgSMrK4ZmyqQk3uPEmHrAv3whp+MePt0cky4I
	 rmS+XuXVF9IzPceKxk7bF3temxF6Y+Fvt/yIDZf0EUfRRjhe+SN0Hyl5oOFb/qY692
	 l0YZdFuGvcYbQ==
Message-ID: <sashiko-outbox-207016@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 07/10] efi/libstub: riscv: Use struct efi_image_info
 to access image properties
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ard Biesheuvel" <ardb+git@google.com>, linux-efi@vger.kernel.org
Cc: "Ard Biesheuvel" <ardb@kernel.org>, "Jason Gunthorpe" <jgg@nvidia.com>, "Paul
 Walmsley" <pjw@kernel.org>, "Palmer Dabbelt" <palmer@dabbelt.com>, "Albert
 Ou" <aou@eecs.berkeley.edu>, "Huacai Chen" <chenhuacai@kernel.org>
In-Reply-To: <20261110121731.2728824-19-ardb+git@google.com>
References: <20261110121731.2728824-12-ardb+git@google.com>
 <20261110121731.2728824-19-ardb+git@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 12:27:22 +0000
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
- [Critical] efi/libstub: riscv: wrong image base and entry offset from
  _text
--

commit 66c3f5bb26141f8dc9e6a6b6eea665f0e9187c52
Author: Ard Biesheuvel <ardb@kernel.org>

efi/libstub: riscv: Use struct efi_image_info to access image properties

This commit converts the RISC-V EFI stub to use struct efi_image_info
helpers instead of linker script symbol aliases to determine the kernel
image base, sizes, and entry offset.

> diff --git a/drivers/firmware/efi/libstub/riscv-stub.c b/drivers/firmware=
/efi/libstub/riscv-stub.c
> index 5cbc50a814e11..e8d66f6fe8e03 100644
> --- a/drivers/firmware/efi/libstub/riscv-stub.c
> +++ b/drivers/firmware/efi/libstub/riscv-stub.c
> @@ -20,7 +19,7 @@ unsigned long stext_offset(void)
>  	 * of the file representation. So instead, we need to jump to the
>  	 * actual entrypoint in the .text region of the image.
>  	 */
> -	return _start_kernel - _start;
> +	return efistub_kernel_entry_offset(efistub_get_image_info());
>  }
> =20
>  efi_status_t handle_kernel_image(unsigned long *image_addr,
> @@ -30,13 +29,14 @@ efi_status_t handle_kernel_image(unsigned long *image=
_addr,
>  				 efi_loaded_image_t *image,
>  				 efi_handle_t image_handle)
>  {
> -	unsigned long kernel_size, kernel_codesize, kernel_memsize;
> +	auto image_info			=3D efistub_get_image_info();
> +	unsigned long kernel_base	=3D efistub_kernel_base(image_info);
> +	unsigned long kernel_size	=3D efistub_kernel_size(image_info);
> +	unsigned long kernel_codesize	=3D efistub_kernel_codesize(image_info);
> +	unsigned long kernel_memsize	=3D efistub_kernel_memsize(image_info);
>  	efi_status_t status;
> =20
> -	kernel_size =3D _edata - _start;
> -	kernel_codesize =3D __inittext_end - _start;
> -	kernel_memsize =3D kernel_size + (_end - _edata);
> -	*image_addr =3D (unsigned long)_start;
> +	*image_addr =3D kernel_base;
>  	*reserve_size =3D kernel_memsize;

[Severity: Critical]
Does using struct efi_image_info here base the RISC-V image calculations on
_text instead of _start?

struct efi_image_info records _text_offset using REL_REF(_text), and the
efistub_kernel_*() helpers compute the base address, image sizes, and
efi_primary_entry (_start_kernel) offset relative to _text.  On RISC-V,
however, _start and the .head.text section (which contains _start_kernel)
are placed before _text:

arch/riscv/kernel/vmlinux.lds.S:
	_start =3D .;
	HEAD_TEXT_SECTION
	. =3D ALIGN(PAGE_SIZE);

	.text : {
		_text =3D .;
		_stext =3D .;

As a result, handle_kernel_image() sets *image_addr to _text and omits
.head.text when efi_kaslr_relocate_kernel() checks alignment and copies the
image, while stext_offset() returns _start_kernel - _text (a negative
s32 offset that sign-extends to unsigned long), causing efi_enter_kernel()
to jump before the start of the image buffer and crash at boot.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110121731.2728=
824-12-ardb+git@google.com?part=3D7
