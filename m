Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354D737267A
	for <linux-efi@vger.kernel.org>; Wed, 29 Apr 2026 07:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777449132; cv=none; b=LBFDo2ir4Wi6uFvDhS2vkCbheBuEWoWDQ3BRQzRPbPalRcp5UdR95Bi+zfGX5gSZvVIwGusSyVFfdnRAgHxz07CPczhJ487Clvyl6k8ntHIK/yvdhN/88T511Tua98jn7RGG5SIGzIO+rVN5TqSLGVDgBU9wnvQzqSldtOtsBiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777449132; c=relaxed/simple;
	bh=P+uO0jmXBfzlb55uzSAkZvd5lXOzZiIUwbZcV3ztWeM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eZc3ZKUKH8RmV4laLkmyzQvng6kDbROiPwavDbBF8lt9ssNDCrHjsjX4nJIkQtDHlasNwLL25fHsdRvQIdnmGOxSNSJyXyQNgu2DPyKuY3NZbef7iAS7RJHF9nF+wJzJi75yYefGaWbUCHfAPm37jk+lIRuEtcVcyqutiE2Z4ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UNmUpk24; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UNmUpk24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3DCDC2BCB3
	for <linux-efi@vger.kernel.org>; Wed, 29 Apr 2026 07:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777449131;
	bh=P+uO0jmXBfzlb55uzSAkZvd5lXOzZiIUwbZcV3ztWeM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=UNmUpk24wwiLOUY94+cXrISZUm5JTcRjZ46K9nk2x6SLkYrmZ6zwec98Uv6aFT7Hf
	 rRLT12dViD5IrV7RRiOQH5a5jxxFifC+s9vDTbjOfNLkBJ2QhuZSDUbhku7lZnEjA2
	 Dm4jjP+SS/chINGTLbIqM58dgu7VTgrNBlstxBPAcZ3ux+mk2f9QHuQVZaKPf+W8Ts
	 7YTzwC2ZDNm0wRfcQUTyQGBFst6QluLeG25+mI35MU6Nza0GhRkxRz7ZrWglgVNfHj
	 ESdXFknZOsCjg21qavhuMI5dALWKMcIH7CrgZaEKUB8htmriLqaLkw/MbVz8Bz1/rM
	 rWyw4riDdIo8w==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-ba7a1cc0380so2062432066b.2
        for <linux-efi@vger.kernel.org>; Wed, 29 Apr 2026 00:52:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/vZL75+s9iBTrdXL1bjyBLDz+foQ+Wa+nhdoebvX3tdkM+lhFqPj43jg9fz0vXrL9PmbEeJUiIlkE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxob1FmS48TEnMntF3c6V0jZCVLgs93nZmDgPUfwXw5oawpX2b5
	ZWa4dM8aiBahNpTd5gMiRecsJm4KD4dX4FwhmnUm5o7Qz2x4Xc4H0f1N14mqnQtuhiTJ90GPJC3
	xd3lUVgc96X+yvoTDuulg1dDKNJd3+o4=
X-Received: by 2002:a17:907:3c84:b0:bae:2adb:1461 with SMTP id
 a640c23a62f3a-bb80100e70emr397819266b.9.1777449130365; Wed, 29 Apr 2026
 00:52:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260429051318.1581350-1-r@hev.cc> <20260429051318.1581350-2-r@hev.cc>
In-Reply-To: <20260429051318.1581350-2-r@hev.cc>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 29 Apr 2026 15:51:56 +0800
X-Gmail-Original-Message-ID: <CAAhV-H76sdWQ02S=jTKJWFviZ0HHGXSWPT9Nwh9b4QFj1v9wpQ@mail.gmail.com>
X-Gm-Features: AVHnY4Ki22xNhThmDFd37k_0EleXB43gBpiP61uVcWv-C6prgKNU2qiVxWIUcV0
Message-ID: <CAAhV-H76sdWQ02S=jTKJWFviZ0HHGXSWPT9Nwh9b4QFj1v9wpQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] efi/loongarch: Randomize kernel preferred address
 for KASLR
To: WANG Rui <r@hev.cc>
Cc: Ard Biesheuvel <ardb@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Haiyong Sun <sunhaiyong@loongson.cn>, 
	Lisa Robinson <lisa@bytefly.space>, loongarch@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Ard,

On Wed, Apr 29, 2026 at 1:14=E2=80=AFPM WANG Rui <r@hev.cc> wrote:
>
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
If you have no objections, can you give an Acked-by? I thinks this
series should go to loongarch tree.

Huacai

> ---
>  arch/loongarch/include/asm/efi.h         |  4 +++-
>  drivers/firmware/efi/libstub/loongarch.c | 16 ++++++++++++++++
>  2 files changed, 19 insertions(+), 1 deletion(-)
>
> diff --git a/arch/loongarch/include/asm/efi.h b/arch/loongarch/include/as=
m/efi.h
> index eddc8e79b3fa..f831320efd41 100644
> --- a/arch/loongarch/include/asm/efi.h
> +++ b/arch/loongarch/include/asm/efi.h
> @@ -30,6 +30,8 @@ static inline unsigned long efi_get_kimg_min_align(void=
)
>         return SZ_2M;
>  }
>
> -#define EFI_KIMG_PREFERRED_ADDRESS     PHYSADDR(VMLINUX_LOAD_ADDRESS)
> +unsigned long efi_get_kimg_kaslr_address(void);
> +
> +#define EFI_KIMG_PREFERRED_ADDRESS     efi_get_kimg_kaslr_address()
>
>  #endif /* _ASM_LOONGARCH_EFI_H */
> diff --git a/drivers/firmware/efi/libstub/loongarch.c b/drivers/firmware/=
efi/libstub/loongarch.c
> index 9825f5218137..51997a0e83bd 100644
> --- a/drivers/firmware/efi/libstub/loongarch.c
> +++ b/drivers/firmware/efi/libstub/loongarch.c
> @@ -38,6 +38,22 @@ static efi_status_t exit_boot_func(struct efi_boot_mem=
map *map, void *priv)
>         return EFI_SUCCESS;
>  }
>
> +unsigned long efi_get_kimg_kaslr_address(void)
> +{
> +       unsigned int random_offset =3D 0;
> +
> +#ifdef CONFIG_RANDOMIZE_BASE
> +       if (!efi_nokaslr) {
> +               efi_get_random_bytes(sizeof(random_offset), (u8 *)&random=
_offset);
> +               random_offset ^=3D (random_get_entropy() << 16);
> +               random_offset &=3D (CONFIG_RANDOMIZE_BASE_MAX_OFFSET - 1)=
;
> +               random_offset =3D ALIGN(random_offset + SZ_64K, SZ_64K);
> +       }
> +#endif
> +
> +       return PHYSADDR(VMLINUX_LOAD_ADDRESS) + random_offset;
> +}
> +
>  unsigned long __weak kernel_entry_address(unsigned long kernel_addr,
>                 efi_loaded_image_t *image)
>  {
> --
> 2.54.0
>
