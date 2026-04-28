Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5577083C
	for <linux-efi@vger.kernel.org>; Tue, 28 Apr 2026 05:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777352476; cv=none; b=tb5w2n+7vOVfL87ER4yV9l27Bpxzz3ngGBaPulOZg+Rqb45jeCEUD0vgF6NzkyhfZxtVqvHPPbcR/CY/mEMYjCcWgroP45TDvhpqTA6Fnxz4MgjEz6SxGvL4nI0VY6SDc1xSB/JRpngdnwXkd2d8pBycvKrPXHYDFAj1ufCXoMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777352476; c=relaxed/simple;
	bh=UzPgCl26DtCGIEQPuNr82TuYkn8mwsv3IgFR6E7awnM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kgavQ2JUZcM6mMi0NjZrDYKu9fpGfst86jHk7ksGQBEoK5JSnxTEnVNm5Fx4D+0Z+ulr/CG40SkbPemzR3wcYq/8McNnOqz05Mg6zYIO/QOzbZ3B+baZ54ksqpf/3ornrFa4xc3Q6meRg+AzNmtUy7DKH9fbNLlt7Fw6OZI4bBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=peKKhi9/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="peKKhi9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23061C2BCB7
	for <linux-efi@vger.kernel.org>; Tue, 28 Apr 2026 05:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777352476;
	bh=UzPgCl26DtCGIEQPuNr82TuYkn8mwsv3IgFR6E7awnM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=peKKhi9/4j2liYt/N7lythOUnbJ+psZagt2ShLZ7Lm/n2D4nQBYQET+TDOhtGMPGb
	 Ike1+r4immW6at8tN0esjYJvrCZQDZ5pZOWDUNRR18YPcNKVgzG3SwnU6PnGyl7HnQ
	 mFBOp5/505pYTU8FH+G8gFOAxz+b+e6FokTqP4Qef2AD/doCr/BC9/cIE+kZqLF6Wo
	 XSAZk3qWCM89AW1Ko2GbVxEfOe9AnG69QZDxlD1L+feulwjdKvbaJnobOch0Q7k8f0
	 Ywfyd2Ztq0YMAYaU+/CDRJV5tgUI7Lvmz7B1g3TVD0dJw+O6AzBJyyyf5J81KGFwBx
	 npkjndsBhydCg==
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-676fec7e946so8888979a12.3
        for <linux-efi@vger.kernel.org>; Mon, 27 Apr 2026 22:01:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9k6BSPorAEw0OGJZwy+vYHSX3naIgVuA6fynfF5iGIBdVSj9s24xClNCH6vrA79dcU7YdhED9a3s0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6n5xYOsZATALJOr09F/Cv//+W47AOD8xrx2ndSOJYuPwJWIAK
	JajLbCC3fWNn7WXHaDLk9aiifmEdVOldOQ9sojiSfn8MFC4ATQB+KahcawNygGvL66s2HP5I9cI
	kbEhRVH6rMPs6thda8wXkTrPjXw8LPBo=
X-Received: by 2002:a17:906:6a1e:b0:bad:3277:623 with SMTP id
 a640c23a62f3a-bb804834ea8mr86755766b.41.1777352474598; Mon, 27 Apr 2026
 22:01:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260428040159.1065822-1-r@hev.cc> <20260428040159.1065822-2-r@hev.cc>
In-Reply-To: <20260428040159.1065822-2-r@hev.cc>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 28 Apr 2026 13:01:02 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4dTKEwb6u5X08dX2UFxophvr_GsfB-FFt_UHbVqJJi8Q@mail.gmail.com>
X-Gm-Features: AVHnY4LZ97OtBCn1QDUncPwB-AFKakekSM87ABd2ntSW0pMX8Z1PllV97XV9K4Q
Message-ID: <CAAhV-H4dTKEwb6u5X08dX2UFxophvr_GsfB-FFt_UHbVqJJi8Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] efi/loongarch: Randomize kernel preferred address
 for KASLR
To: WANG Rui <r@hev.cc>
Cc: Ard Biesheuvel <ardb@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Lisa Robinson <lisa@bytefly.space>, 
	loongarch@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Rui,

On Tue, Apr 28, 2026 at 12:02=E2=80=AFPM WANG Rui <r@hev.cc> wrote:
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
> ---
>  arch/loongarch/Kconfig                   |  2 +-
>  arch/loongarch/include/asm/efi.h         |  4 +++-
>  drivers/firmware/efi/libstub/loongarch.c | 16 ++++++++++++++++
>  3 files changed, 20 insertions(+), 2 deletions(-)
>
> diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
> index 3b042dbb2c41..a5afb70f73d9 100644
> --- a/arch/loongarch/Kconfig
> +++ b/arch/loongarch/Kconfig
> @@ -730,7 +730,7 @@ config RANDOMIZE_BASE
>  config RANDOMIZE_BASE_MAX_OFFSET
>         hex "Maximum KASLR offset" if EXPERT
>         depends on RANDOMIZE_BASE
> -       range 0x0 0x10000000
> +       range 0x20000 0x10000000
>         default "0x01000000"
>         help
>           When KASLR is active, this provides the maximum offset that wil=
l
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
> index 9825f5218137..c44be5d3dc04 100644
> --- a/drivers/firmware/efi/libstub/loongarch.c
> +++ b/drivers/firmware/efi/libstub/loongarch.c
> @@ -38,6 +38,22 @@ static efi_status_t exit_boot_func(struct efi_boot_mem=
map *map, void *priv)
>         return EFI_SUCCESS;
>  }
>
> +unsigned long efi_get_kimg_kaslr_address(void)
Move it into arch/loongarch/include/asm/efi.h?

> +{
> +       unsigned int random_offset =3D 0;
> +
> +#ifdef CONFIG_RANDOMIZE_BASE
> +       if (!efi_nokaslr) {
> +               efi_get_random_bytes(sizeof(random_offset), (u8 *)&random=
_offset);
> +               random_offset ^=3D (random_get_entropy() << 16);
> +               random_offset &=3D (CONFIG_RANDOMIZE_BASE_MAX_OFFSET - SZ=
_64K - 1);
I still don't want to modify the range of RANDOMIZE_BASE_MAX_OFFSET, so use
     random_offset &=3D (CONFIG_RANDOMIZE_BASE_MAX_OFFSET - 1)
here?

> +               random_offset =3D ALIGN(random_offset, SZ_64K) + SZ_64K;
It seems "random_offset =3D ALIGN(random_offset + SZ64K, SZ_64K)" is better=
.

Huacai

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
