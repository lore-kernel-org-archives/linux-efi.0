Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794314358;
	b=4i+vCyf7A0i/ZbCI6/ScFLOuvzIEI5BXvGWy85Wz/AF2rIMcOS5TBpMRKjJ5qYDlr5XD
	 HJ+TDSwGmwHBF9tyJCoxN3iJiDQ5jxi00qiv89LiIo5EVVluKyk+L2fq8qsOeOuxpb+Cb
	 7yLyMv+tbWReNo90yeIn2JnCs63ijYxj1n1tdDI2hidGaW7GmyRU8KDPpY7Wze4Jl1y68
	 RhzP/N1pYx6BJQx5Tyd6HCiy1rxektmvzMQRk9moFjGK4ip+9PWkLFO9a+YHebypbKQsj
	 rZ/DsnsQ6st2ZQXCdbtsNNQsdV0UuR/zf7ZApV5w9o2DlZnuUS7LGdPbErn/uutZIbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794314358;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=foMB6zqZG4DxlbH1YMLSMkKfWvtLuueYKpiNGX9DV/w=;
	b=34KAwclzmDOe5qeohVBcYbPKXP9UQ4QiBx4InmoVP+ys02rYuB1aZAxApe6rzemFoQdE
	 LpccRjGcpMyyXvgtjSlTGXjQL8S3Bzreu2qMXebullS3O+KXJLNSg6OEFvOrKi96BfERN
	 PuhR9svzn2bCyw0WefEllSKkWM9XwuPJk+dnw4VGwwCoU4nhBH5lEANf0w/0pM6vh+U4d
	 DRpxAxe+qvWwOfyvqk8+IQXe5HmeBbS2N3IIrzWWS3fcQg914Dd7skBZsILnB4Uun20ve
	 mXcN/Ue21dgJobTs5irtADSazerNVPDbg0vdxHlfVXJVTukkyDoyiFXnmPBELwoNOLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kYhGR3ZC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F9A606A331
	for <linux-efi@vger.kernel.org>; Tue, 10 Nov 2026 12:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kYhGR3ZC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBA651F0089F;
	Tue, 10 Nov 2026 12:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794314358;
	bh=foMB6zqZG4DxlbH1YMLSMkKfWvtLuueYKpiNGX9DV/w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kYhGR3ZCjkLW8K6RhLEenxJZ+UUuFdj8ztdSb2Niitcve/B8CUfybhirIHCd7WovV
	 tqAs8ns43qh9LNawUvQdOBaeGhYuLaVIN3qNsQH1QO2toWhEkbqcLaISM+SqK0/+TE
	 +6OXH8Q8cCxv3w51UBGh6DPVY5zj7/GIq9uRcmvOcOHQet9oFz5yGT1Qbt/MfLtag4
	 jSTiIbOlscaTNBBjioCTF7a9aTHAx07tvnc5mq0Hc0YWkobq3h+e5WQwzF6e4OXMlP
	 B12TDLCclz0+R9MsWHsUH5M/DDofF1QbuB3cocFaG1dp1GZGp6XGxBVZIjEj8xztIJ
	 +kpQWImSb4m/Q==
Message-ID: <sashiko-outbox-207035@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 09/10] efi/zboot: Disentangle efi_remap_image() from
 efi_cache_sync_image()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ard Biesheuvel" <ardb+git@google.com>, linux-efi@vger.kernel.org
Cc: "Ard Biesheuvel" <ardb@kernel.org>, "Jason Gunthorpe" <jgg@nvidia.com>, "Paul
 Walmsley" <pjw@kernel.org>, "Palmer Dabbelt" <palmer@dabbelt.com>, "Albert
 Ou" <aou@eecs.berkeley.edu>, "Huacai Chen" <chenhuacai@kernel.org>
In-Reply-To: <20261110121731.2728824-21-ardb+git@google.com>
References: <20261110121731.2728824-12-ardb+git@google.com>
 <20261110121731.2728824-21-ardb+git@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 12:39:17 +0000
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
- [High] efi/zboot: broken image_info offset and code_size in
  efi_zboot_remap_image()
--

commit 51947c84bec76536d55cfa9120873713a58ae31b
Author: Ard Biesheuvel <ardb@kernel.org>

efi/zboot: Disentangle efi_remap_image() from efi_cache_sync_image()

This commit moves the efi_cache_sync_image() and efi_remap_image() calls out
of the architecture-specific and decompressor paths into a new
efi_zboot_remap_image() helper invoked from efi_zboot_entry().

> diff --git a/drivers/firmware/efi/libstub/zboot.c b/drivers/firmware/efi/=
libstub/zboot.c
> index c6071b0e8f1a4..25ff5960771ca 100644
> --- a/drivers/firmware/efi/libstub/zboot.c
> +++ b/drivers/firmware/efi/libstub/zboot.c
> @@ -38,6 +38,17 @@ const struct efi_image_info *zboot_get_image_info(unsi=
gned long image_base)
>  	return (void *)image_base + efistub_image_info_offset;
>  }
> =20
> +static efi_status_t efi_zboot_remap_image(const struct efi_image_info *i=
mage_info,
> +					  unsigned long image_base,
> +					  unsigned long image_size)
> +{
> +	unsigned long code_size =3D efistub_kernel_codesize(image_info);
> +
> +	efi_cache_sync_image(image_base, code_size);
> +
> +	return efi_remap_image(image_base, image_size, code_size);
> +}
> +
>  asmlinkage efi_status_t __efiapi
>  efi_zboot_entry(efi_handle_t handle, efi_system_table_t *systab)
>  {
> @@ -105,7 +116,8 @@ efi_zboot_entry(efi_handle_t handle, efi_system_table=
_t *systab)
>  		goto error;
> =20
>  	auto image_info =3D zboot_get_image_info(image_base);
> -	status =3D efi_stub_common(handle, image, image_base, cmdline_ptr,
> +	status =3D efi_zboot_remap_image(image_info, image_base, alloc_size) ?:
> +	         efi_stub_common(handle, image, image_base, cmdline_ptr,
>  				 image_info);

[Severity: High]
Does calling efi_zboot_remap_image() here cause a boot regression on RISC-V
CONFIG_EFI_ZBOOT kernels when EFI_MEMORY_ATTRIBUTE_PROTOCOL is present?

Previously, efi_remap_image() in the zboot path was only called on arm64, a=
nd
zboot.c never dereferenced image_info.  Now efi_zboot_entry() calls
efi_zboot_remap_image() for all zboot architectures and aborts the boot if =
it
fails.

On RISC-V, the binary Image decompressed to image_base starts at _start, wh=
ile
_text is placed PAGE_SIZE bytes later, and __inittext_end is defined before
section and PE/COFF alignment:

arch/riscv/kernel/vmlinux.lds.S:
	_start =3D .;
	HEAD_TEXT_SECTION
	. =3D ALIGN(PAGE_SIZE);

	.text : {
		_text =3D .;
    ...
	__inittext_end =3D .;
	. =3D ALIGN(SECTION_ALIGN);
#ifdef CONFIG_EFI
	. =3D ALIGN(PECOFF_SECTION_ALIGNMENT);
	__pecoff_text_end =3D .;
#endif

Because get_image_info_offset in drivers/firmware/efi/libstub/Makefile.zboot
computes efistub_image_info_offset relative to _text,
zboot_get_image_info(image_base) points PAGE_SIZE bytes before the actual
struct efi_image_info, so efistub_kernel_codesize(image_info) reads unrelat=
ed
image bytes as code_size.  Even with the offset fixed,
__inittext_end - _text omits the leading PAGE_SIZE bytes between _start and
_text and is not page-aligned, causing efi_remap_image() to fail with
EFI_INVALID_PARAMETER or remap the wrong range.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110121731.2728=
824-12-ardb+git@google.com?part=3D9
