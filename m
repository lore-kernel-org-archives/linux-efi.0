Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794840759;
	b=4mPgYJz+gx/xaa6LhgaVw+RYq9vwtZwCayiuePvYFtKWHBCQKRfunZ8M1A45ojzH0vm2
	 X71lH6xBAeGguOHzN6DKPUV0lcZols3v3f+B1u/rgEUvVGw8b46/WIaz1NrHOvj1LNDGR
	 Erh84F3YKh9ee6xxCzQpQj3lNFpMx69/8FZpHsKUBR/0W67FqZBSnmoxMxTXyeYH5cSAg
	 Yno5elcJLmC5DVfKGu3NKgUFP8xaBTqpYG38Yu6TtUpH9j3x4tQEp4rwZztaMJ65FKm18
	 VmoY0FMNSLwAfdjnQtwmdNx804k5olQnrRkejnJS8JmcV5exULzf7sAnoI0mfW8QTyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794840759;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=jpJvaZXjGcu32lN5m0c26aRcXjtF+VpxL9DNN8ctmR4=;
	b=XTVoDdtDOCvLPQg8oDs5yUR+4CdnKbl9vmh7GaKs6X/Q9xtNlO2kUZCzbtpBlGtp53/L
	 p5xvOf2OqI5EDaP5EjZ/7Hmuuja5t9Gg0ufy8DgbUJJDNwHdSHLL8CjRNf2R0nuyYQAGW
	 s5QdSlxyojOmqRdi/ZLXIOiJjkPKJdfUHLSZLJKA7i7ps69IBumDtpJxBeeP9tag26TD/
	 xIpZs01lfEQzhgn7r6BJcuj5JGsm7RunaT4BbSJaLyVtIOroEpGG/0EMQCqGprjOoigtW
	 GGG1PQrpV5+d5GA8SdD5fyFUrsgzYQO5UjxV8tlamA//LumWN3uV4hARbm0ulLHE0SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZajQoCIq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD38606A31C
	for <linux-efi@vger.kernel.org>; Mon, 16 Nov 2026 14:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZajQoCIq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483921F000C4;
	Mon, 16 Nov 2026 14:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794840758;
	bh=jpJvaZXjGcu32lN5m0c26aRcXjtF+VpxL9DNN8ctmR4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZajQoCIq55KQkSPSj1rYyhreyAPj6hjVFABDZsUIPLBFEpz9Ht/vIn+8P9hu/rweo
	 EcOMBmyKaEbuIyvKnYNVbzRHeYQXfGop+ktkdhyPtIOBjI21RNhWYvzTFx/MiG9M1E
	 ro1hVnC6FpQvKjf3uu3hiliRqd02s2BFl4dyJ7KABUjfbmMhzCisZLlmVN3PvBoQfD
	 6swZBP3uGkLNOttpu+mFYac9RHB4+ypJppvDb4Ru4hsh2yeb3c802pC+PFWZvSt5go
	 VkZuZnyHpOaiIQlsRwNk12CZp3+E7wpxb/e+ZXIg5V46f938R2tFUpg9JSJJNDVNAA
	 0O6j0Hq9EWmdg==
Message-ID: <sashiko-outbox-217196@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 12/15] efi/zboot: Disentangle efi_remap_image() from
 efi_cache_sync_image()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ard Biesheuvel" <ardb+git@google.com>, linux-efi@vger.kernel.org
Cc: "Ard Biesheuvel" <ardb@kernel.org>, "Jason Gunthorpe" <jgg@nvidia.com>, "Paul
 Walmsley" <pjw@kernel.org>, "Palmer Dabbelt" <palmer@dabbelt.com>, "Albert
 Ou" <aou@eecs.berkeley.edu>, "Huacai Chen" <chenhuacai@kernel.org>
In-Reply-To: <20261116142618.1687025-29-ardb+git@google.com>
References: <20261116142618.1687025-17-ardb+git@google.com>
 <20261116142618.1687025-29-ardb+git@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 14:52:37 +0000
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
- [High] efi/zboot: unaligned code_size in efi_zboot_remap_image() on
  RISC-V
--

commit f296d871a4059f81fdcf9e8fdf0200c1435b74e5
Author: Ard Biesheuvel <ardb@kernel.org>

efi/zboot: Disentangle efi_remap_image() from efi_cache_sync_image()

This commit moves the efi_cache_sync_image() and efi_remap_image() calls out
of the decompressors and arm64's cache sync helper into efi_zboot_entry() v=
ia
a new efi_zboot_remap_image() helper.

> diff --git a/drivers/firmware/efi/libstub/zboot.c b/drivers/firmware/efi/=
libstub/zboot.c
> index 4cff756902ad4..9c7de225b39e5 100644
> --- a/drivers/firmware/efi/libstub/zboot.c
> +++ b/drivers/firmware/efi/libstub/zboot.c
> @@ -40,6 +40,17 @@ const struct efi_image_info *zboot_get_image_info(unsi=
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
> @@ -107,7 +118,8 @@ efi_zboot_entry(efi_handle_t handle, efi_system_table=
_t *systab)
>  		goto error;
> =20
>  	auto image_info =3D zboot_get_image_info(image_base);
> -	status =3D efi_stub_common(handle, image, image_info, cmdline_ptr);
> +	status =3D efi_zboot_remap_image(image_info, image_base, alloc_size) ?:
> +		 efi_stub_common(handle, image, image_info, cmdline_ptr);

[Severity: High]
Can efi_zboot_remap_image() pass a non-page-aligned code_size to
efi_remap_image() on RISC-V and abort the boot?

Previously, efi_remap_image() was only called from arm64's
efi_cache_sync_image() implementation.  Calling it from efi_zboot_entry()
now runs it on all zboot architectures and aborts the boot if it returns an
error.

efistub_kernel_codesize() returns __inittext_end - _text.  Unlike arm64 and
LoongArch, RISC-V places __inittext_end before the section and PE/COFF
alignment directives:

arch/riscv/kernel/vmlinux.lds.S:
	__inittext_end =3D .;
	. =3D ALIGN(SECTION_ALIGN);
#ifdef CONFIG_EFI
	. =3D ALIGN(PECOFF_SECTION_ALIGNMENT);
	__pecoff_text_end =3D .;
#endif

Because __inittext_end is only instruction-aligned on RISC-V, code_size
(along with image_base + code_size and alloc_size - code_size) is not a
multiple of EFI_PAGE_SIZE (4 KiB).  On UEFI firmware implementing
EFI_MEMORY_ATTRIBUTE_PROTOCOL, set_memory_attributes() and
clear_memory_attributes() reject the unaligned range with
EFI_INVALID_PARAMETER, causing efi_zboot_entry() to skip efi_stub_common()
and fail the boot.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116142618.1687=
025-17-ardb+git@google.com?part=3D12
