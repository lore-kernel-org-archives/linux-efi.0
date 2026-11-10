Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794314841;
	b=rfFmqyywEUX0a4QhfpGeWfKu8pgGX4kiWGsLx11LUtmKiLvjWNMDSOmBybOPuuecReV5
	 yCYkbycUTWyDvmnSwE+QKdE2ediDLzPs6cm2Vb8kybrbY7yZ+XmcvnOUqElLQ+0fFsKsu
	 ri9jdNLcWNdLbhZUWtBG4NoGUSoFNXyD39Jj1WkxXqyFCMJj+J9ZNX+FbvHmBqx4xvxwK
	 9hL2QngSgOtex2HbNzlCKM0Pumt+V+jKgC1h4jFCVOcfrkutkFD173U4rD7hqkrQU1Tqz
	 1aju9wGSvl1scwffaMlzCwKRj+4i9y8DjpsQhunP6u6UFBcnzFv5Y/KX0XLw5k4kbOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794314841;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=/PrrIAUI4sO4p4C/1e9ukddssZoJ+vYAyiSRBglexko=;
	b=oapn41Tu3AXAoP4BoGzhZp2M//AnefmgFSChiUvSybonWWuWUb1lx4ARw7EjU80JJqUz
	 RtnKggx8G4XtuDWXWCgWgDfFbv03EzQ/cBR9AfLSsgfvhG53OQ8BBhyWtOUh9ZLJicSt0
	 ZVYgwslk5ZjQ+aS7u/jJ29ZGFpoG3nwXoeoct0KDUVagTCnKKKBFv7KR3SFEDrvgyDagW
	 A3NvGAOCots72PkhzgDpxoaygyS8U2ZsZ2J/4kSEZGTdWjPErmpMFXLRzb4bJpr+qr1bN
	 RIUdYWP25YaKkvq9EQo8WsyNQ01W3wVVxLR1FzUH7r34/6D8kzUg6T0dsmmvuF/yBDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RRYaNYS2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC88F606A31C
	for <linux-efi@vger.kernel.org>; Tue, 10 Nov 2026 12:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RRYaNYS2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81B51F0089F;
	Tue, 10 Nov 2026 12:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794314840;
	bh=/PrrIAUI4sO4p4C/1e9ukddssZoJ+vYAyiSRBglexko=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RRYaNYS2CSMeXSHWM2dEzEJ5NZBFJCQZRVHalGrowyhIMTTX/uUf9Q9FY+TgkX1Od
	 x/A8s7r7Cxr2RZfjatKqGncWExiBjq84wBEHtQMtPHvPpe8vYYX+ll7rZTs/8EbVPA
	 qx4j0qow6MVce7ApWtYsHMzh7yg9rSZkOj2O0euyGhveHZmerN2bOn3pdh57XtFe0I
	 GRvYt4SDlIQSbmg6P7azNd5TfsXLF/G/pgINde58zuji3iZZ5X7+4yxlLRE48r7gNd
	 3NqP/MOQ67/Z0UEpncGIYxgjAdygX6laKV8K23c4jyIymKbWTPXTb/iEFbRK4fVtTT
	 iwtjTm5uh39MA==
Message-ID: <sashiko-outbox-207042@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 04/10] efi/libstub: Capture loaded image information
 in struct efi_image_info
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ard Biesheuvel" <ardb+git@google.com>, linux-efi@vger.kernel.org
Cc: "Ard Biesheuvel" <ardb@kernel.org>, "Jason Gunthorpe" <jgg@nvidia.com>, "Paul
 Walmsley" <pjw@kernel.org>, "Palmer Dabbelt" <palmer@dabbelt.com>, "Albert
 Ou" <aou@eecs.berkeley.edu>, "Huacai Chen" <chenhuacai@kernel.org>
In-Reply-To: <20261110121731.2728824-16-ardb+git@google.com>
References: <20261110121731.2728824-12-ardb+git@google.com>
 <20261110121731.2728824-16-ardb+git@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 12:47:18 +0000
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
- [High] efi/libstub: use of _text instead of _start breaks RISC-V image
  offsets
--

commit 753bce0ac7226eaedf6904088805b59f9e240934
Author: Ard Biesheuvel <ardb@kernel.org>

efi/libstub: Capture loaded image information in struct efi_image_info

This commit introduces struct efi_image_info to record the loaded kernel
image's layout and entry point offsets, passing it to efi_stub_common() for
both the uncompressed EFI stub and EFI zboot.

> diff --git a/arch/riscv/kernel/head.S b/arch/riscv/kernel/head.S
> index 1631fd6bc786b..6c81f32be70b5 100644
> --- a/arch/riscv/kernel/head.S
> +++ b/arch/riscv/kernel/head.S
> @@ -28,6 +28,7 @@ SYM_CODE_START(_start)
>  	 * that expects this header format!!
>  	 */
>  #ifdef CONFIG_EFI
> +SYM_FUNC_ALIAS(efi_primary_entry, _start_kernel)
>  	/*
>  	 * This instruction decodes to "MZ" ASCII required by UEFI.
>  	 */
> diff --git a/drivers/firmware/efi/libstub/Makefile.zboot b/drivers/firmwa=
re/efi/libstub/Makefile.zboot
> index 52baacf3e9d94..e2769bbec963f 100644
> --- a/drivers/firmware/efi/libstub/Makefile.zboot
> +++ b/drivers/firmware/efi/libstub/Makefile.zboot
> @@ -26,9 +26,18 @@ zboot-size-len-$(CONFIG_KERNEL_ZSTD)	:=3D 4
>  $(obj)/vmlinuz: $(obj)/vmlinux.bin FORCE
>  	+$(call if_changed,$(zboot-method-y))
> =20
> +# subtract the two symbol values to obtain the offset of struct efi_imag=
e_info
> +get_image_info_offset =3D $(shell $(NM) -n $(objtree)/vmlinux |\
> +			grep -E ' _text$$| __efistub_efistub_image_info$$' |\
> +			awk 'NR =3D=3D 1 { a =3D toupper($$1) } \
> +			     NR =3D=3D 2 { print "obase=3D16; ibase=3D16; " toupper($$1) "-" =
a }' |\
> +			bc)
> +
>  # avoid eager evaluation to prevent references to non-existent build art=
ifacts
>  OBJCOPYFLAGS_vmlinuz.o =3D -I binary -O $(EFI_ZBOOT_BFD_TARGET) $(EFI_ZB=
OOT_OBJCOPY_FLAGS) \
> -			  --rename-section .data=3D.gzdata,load,alloc,readonly,contents
> +			 --rename-section .data=3D.gzdata,load,alloc,readonly,contents \
> +			 --add-symbol efistub_image_info_offset=3D0x$(get_image_info_offset)
> +

[ ... ]

> diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/ef=
i/libstub/efistub.h
> index f5eec8c12894c..394796472cc07 100644
> --- a/drivers/firmware/efi/libstub/efistub.h
> +++ b/drivers/firmware/efi/libstub/efistub.h
> @@ -1148,11 +1148,53 @@ efi_status_t handle_kernel_image(unsigned long *i=
mage_addr,
>  				 efi_loaded_image_t *image,
>  				 efi_handle_t image_handle);
> =20
> +struct efi_image_info {
> +	s32	_text_offset;
> +	s32	__inittext_end_offset;
> +	s32	_edata_offset;
> +	s32	_end_offset;
> +	s32	entry_offset;
> +};
> +
> +const struct efi_image_info *efistub_get_image_info(void);
> +const struct efi_image_info *zboot_get_image_info(unsigned long image_ba=
se);
> +
> +static inline
> +unsigned long efistub_kernel_base(const struct efi_image_info *image_inf=
o)
> +{
> +	return (unsigned long)offset_to_ptr(&image_info->_text_offset);
> +}
> +
> +static inline
> +unsigned long efistub_kernel_size(const struct efi_image_info *image_inf=
o)
> +{
> +	return image_info->_edata_offset - image_info->_text_offset;
> +}
> +
> +static inline
> +unsigned long efistub_kernel_memsize(const struct efi_image_info *image_=
info)
> +{
> +	return image_info->_end_offset - image_info->_text_offset;
> +}
> +
> +static inline
> +unsigned long efistub_kernel_codesize(const struct efi_image_info *image=
_info)
> +{
> +	return image_info->__inittext_end_offset - image_info->_text_offset;
> +}
> +
> +static inline
> +unsigned long efistub_kernel_entry_offset(const struct efi_image_info *i=
mage_info)
> +{
> +	return image_info->entry_offset - image_info->_text_offset;
> +}

[ ... ]

> diff --git a/drivers/firmware/efi/libstub/image_info.S b/drivers/firmware=
/efi/libstub/image_info.S
> new file mode 100644
> index 0000000000000..3d3dded0f451a
> --- /dev/null
> +++ b/drivers/firmware/efi/libstub/image_info.S
> @@ -0,0 +1,12 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#define REL_REF(sym)	.long	sym - 0b
> +
> +	.globl		__efistub_efistub_image_info
> +	.p2align	3
> +__efistub_efistub_image_info:
> +0:	REL_REF(_text)
> +	REL_REF(__inittext_end)
> +	REL_REF(_edata)
> +	REL_REF(_end)
> +	REL_REF(efi_primary_entry)

[Severity: High]
Does using _text as the image base reference break these offset calculations
on RISC-V?

Unlike arm64 and LoongArch, RISC-V places _start and HEAD_TEXT_SECTION
before _text:

arch/riscv/kernel/vmlinux.lds.S:
	. =3D LOAD_OFFSET;
	_start =3D .;
	HEAD_TEXT_SECTION
	. =3D ALIGN(PAGE_SIZE);

	.text : {
		_text =3D .;
		_stext =3D .;

Because arch/riscv/kernel/head.S is in __HEAD (.head.text), the binary
Image starts at _start and efi_primary_entry (_start_kernel) sits below
_text.

As a result, get_image_info_offset in Makefile.zboot computes
efistub_image_info_offset relative to _text instead of the start of the
decompressed image (_start), so zboot_get_image_info() points (_text -
_start) bytes before struct efi_image_info.  In addition,
efistub_kernel_base() returns _text rather than _start, the size helpers
exclude .head.text, and efistub_kernel_entry_offset() computes a negative
s32 (_start_kernel - _text) that sign-extends to a bogus unsigned long.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110121731.2728=
824-12-ardb+git@google.com?part=3D4
