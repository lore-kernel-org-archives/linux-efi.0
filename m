Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027263;
	b=PGSRotcpcP6JnGPk699pVrKPjZx6qz2Xn7hJlre3zVdEPMXuGO7T8nrLnHytHt5sm4TX
	 hH01Xs0MLc3p/OEDPtDd4yd4tvx5FL1Y8U1o1txgmU9W4e9SCACtLCiWjhBB3CXtjxSTt
	 h3+nSSRpCZGqbRFDFOOEof0ACooQd2982H6TchjpYayo4gYLmj6FhRjaslwMhJeVhdy8t
	 OyCtS+4pgu6iZ4n6dEJJOP9mDxbE0u/aVhHJc8aIQzifZn6Fd3agJk4d8oy9yRYs4qRfk
	 jtCRVFmZgvebrsT+/RVu9SfSoqGOZ+x0v/q2RqPvZ3jhU1FfwUCwA04TySVzMWGEDow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027263;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=qwwJT8Me/AkiOYZLyx5TqIH28n7JDUxmewQdTvVr9QU=;
	b=oM/T3FKXhtp2jdGhfRgneb8kI8ptWtQRM4bfM4nRQWJ7FAm/aNvHBbZ7J7yo5Ulj3aF0
	 /QqXhWUqexZKBfuwUQodDMq4qkXzosyU2Ua8XA9iHJi3IMMTZNQVTItfmu5PfxsOiEnYO
	 zU4J/v2MdfYymTWvjgmXAuRzgcidZTB9Y65KaWT7h6dYkRWLb+52YQt5MvLvKH7EVplmZ
	 p4Z5n2e+sylVF9OBU4i86bkSkVPCl7MX/sSZlZgGJCoVsmiYnLhqNlmYGJiriaWr9u2BC
	 ZI1t4brl6bl8BjjJpj532OyhDycjIJ8gNf5RUCOlCAinu8e2tBqhcxKsOdwaU+Qp3SA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MkBruAlK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190FF606A33F
	for <linux-efi@vger.kernel.org>; Wed, 18 Nov 2026 18:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MkBruAlK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD9F1F000C5;
	Wed, 18 Nov 2026 18:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795027262;
	bh=qwwJT8Me/AkiOYZLyx5TqIH28n7JDUxmewQdTvVr9QU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MkBruAlKYi8kXcmJOKn9OloV7/vxBlg5DNgO2ydaI9RuWKkmVV7D+WewtuCAGn5iO
	 Ittvk4vFGLV5ZzxambIHQ53Ilk32Q4Ck0+g9JKcHQiy423IusAS9oeeEMpTcf41Gmd
	 xsi66Mm0mW/N+a/6O9tiPNrPwc2hxPKVFOjccLu5E+XNhdDSPHBly1kk7Bs3GLFSZR
	 i6Pprbu0J2droYMyai6C6vDftF8aIu4wQz6BtNVGqzthRZV1ZyByjjNQEXfAEK4vX3
	 fSVetMzQts+MIvECl6MswWGK9jUUeyQk5g4fPGRGr/k4cU3gNq28aIud4tT7xaOvVp
	 OCGF90ey5yxJA==
Message-ID: <sashiko-outbox-221779@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 06/19] efi/libstub: arm: Size the decompressed kernel
 allocation precisely
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ard Biesheuvel" <ardb+git@google.com>, linux-efi@vger.kernel.org
Cc: "Ard Biesheuvel" <ardb@kernel.org>, "Jason Gunthorpe" <jgg@nvidia.com>, "Paul
 Walmsley" <pjw@kernel.org>, "Palmer Dabbelt" <palmer@dabbelt.com>, "Albert
 Ou" <aou@eecs.berkeley.edu>, "Huacai Chen" <chenhuacai@kernel.org>
In-Reply-To: <20261118182105.1633603-27-ardb+git@google.com>
References: <20261118182105.1633603-21-ardb+git@google.com>
 <20261118182105.1633603-27-ardb+git@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 18:41:01 +0000
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
- [High] efi/libstub: arm: unaligned u32 read in handle_kernel_image()
--

commit b84ef299db1b32d7220e230864d358882c52170f
Author: Ard Biesheuvel <ardb@kernel.org>

efi/libstub: arm: Size the decompressed kernel allocation precisely

This commit sizes the ARM EFI stub's reserved memory window for the
decompressed kernel using the uncompressed image size, BSS size, and
initial page table size instead of a fixed 32 MiB limit, and reduces
EFI_PHYS_ALIGN to 2 MiB.

> diff --git a/drivers/firmware/efi/libstub/arm32-stub.c b/drivers/firmware=
/efi/libstub/arm32-stub.c
> index 1073dd9475160..1ab15d66e7092 100644
> --- a/drivers/firmware/efi/libstub/arm32-stub.c
> +++ b/drivers/firmware/efi/libstub/arm32-stub.c
> @@ -76,6 +76,12 @@ void efi_handle_post_ebs_state(void)
>  		      &efi_entry_state->sctlr_after_ebs);
>  }
> =20
> +/* last unaligned u32 in the image carries the uncompressed size */
> +extern u32 input_data_end[] __aligned(1);
> +
> +/* entry #3 in the zimage magic table carries the kernel's BSS size */
> +extern u32 zimage_magic_table[] asm("_table_start");
> +
>  efi_status_t handle_kernel_image(unsigned long *image_addr,
>  				 unsigned long *image_size,
>  				 unsigned long *reserve_addr,
> @@ -83,18 +89,22 @@ efi_status_t handle_kernel_image(unsigned long *image=
_addr,
>  				 efi_loaded_image_t *image,
>  				 efi_handle_t image_handle)
>  {
> -	const int slack =3D TEXT_OFFSET - 5 * PAGE_SIZE;
> -	int alloc_size =3D MAX_UNCOMP_KERNEL_SIZE + EFI_PHYS_ALIGN;
> +	unsigned long kernel_memsize =3D input_data_end[-1] + zimage_magic_tabl=
e[3];

[Severity: High]
Does input_data_end[-1] still perform a 4-byte-aligned word load when the
compressed payload length is not a multiple of 4?

In C, __aligned(1) on an array variable declaration applies to the array
symbol rather than the element type, so input_data_end decays to u32 * and
compilers emit a 32-bit ldr instruction even under -malignment-traps.  In
arch/arm/boot/compressed/vmlinux.lds.S, input_data_end immediately follows
*(.piggydata) before . =3D ALIGN(4), so input_data_end - 4 has only 1-byte
alignment and triggers an alignment fault when the stub runs with the MMU
disabled or alignment traps enabled.  Reading the size with
get_unaligned_le32((u8 *)input_data_end - 4) avoids the aligned u32
dereference.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261118182105.1633=
603-21-ardb+git@google.com?part=3D6
