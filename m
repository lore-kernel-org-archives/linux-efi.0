Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E857737EFFC
	for <linux-efi@vger.kernel.org>; Tue, 28 Apr 2026 14:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777386895; cv=pass; b=r6L8zK4byIWBfiFpzTp0gfJe1oPnlSpD+BXCb7QDBbxPFNBjrlmkfSuTVewZIO2IzmUuD1GhFH4/HBp4+gf+JHwy3UqHEOlwY6CFxGAZfQivXDjx1Dt9ce8fNiqFPiE7V0S/NZRNb3Z0/ZF/WLykNEeeZpiD0EibBaKVHxbu4RY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777386895; c=relaxed/simple;
	bh=oU/anFW3DRsUUuv4TQDDZBBUVZjUxz1D3ikMUAAufu8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WK71ClqP/4zW5gtosxCxjQqjs31sxSnxHdGnqrbGHaPB3cc+fSugnwwPGELp5YWbhrsXmYO/AqMuHSbu7Niz412x3oW9uqvreWVukB1gq3EdrVRjC/e3lyKHBvIv7eWt5iwIIUrl//Ur7ZPcsVTtTglpw6wbP5KIJn3lYWz0G1I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=nJtWqoL4; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="nJtWqoL4"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-50e594413c2so66296871cf.0
        for <linux-efi@vger.kernel.org>; Tue, 28 Apr 2026 07:34:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777386893; cv=none;
        d=google.com; s=arc-20240605;
        b=TVJ6dczaWBoqq0G4TM7Wcz8NMZlzw1oCnOy7OQ+k+sqAUystjNI41VjbHtlhK8KJ1m
         egufY0o1MqD4b85GOU9kKnKJBFdEw56Yaa50SnKn3PM5dJgYn5QOwxsn+2KMfFMPZgDY
         I6XCkZSpG/FoW+I4BrpMP4xdo6lpvqEdjSRGpBLGkENOO252NgkEb/X15vqDWdjzainu
         CGrPr9iaFqEW7s7lvlTFdTP94A1a7jDFPvDGdfTXzXhMWeUK0SyjVUwG7+uqZg1/1EeT
         QgyXMsR7R0d5S+v1gHFFhh7h1WK7G+Rcmmc1O2nraePpzuA31mRusolaUzac5ij05mqw
         Qmxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eQhFVJ4+LPBUTwWR+M90TmweYjwMt7L56NJXWho9jGA=;
        fh=65e6A1V7PY3fMZ6h/GaTorrUDIW7n+fSYe18uGTnbRA=;
        b=iB29hGwFqYdwZcg3LcxBM0Kkg/TjaWXhvO5uPsCtrj7gMR+X9DuTUHfmpT16YRGN9i
         0EFTHAQapPNFz8MWWvcIs2skzPHYax1lCor69EVz97bDGm00NPujBQh4ot55M6Gtny5f
         4Ym0/RY0O9R5im3v/jCKDiZKZ0qK+MwhEQa5zCX9jYNga6e2/YGIzQOp873UxFpaxClf
         CrzS6Fq/SKpQ2kgCDtNRqYRP+C7BbWp4wxU/tXQCt47Z7QR7Y4UB2+ga6OqODMtJBgVK
         tt4jEosi8zlFnz9gpVZGna3fTg+CxZKTCiaGNIQuKEYo+5ZP2R3CiUuX6az0vw7Y2eXO
         dk0Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777386893; x=1777991693; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eQhFVJ4+LPBUTwWR+M90TmweYjwMt7L56NJXWho9jGA=;
        b=nJtWqoL43RyR9O4BWHokabmLMyvxrjPZ8hAz8R+mtdaQlvzMHrtFze10is5v16iTo+
         BMpUarMltfspULBkdcjVpNY8d6zy/x6c55bHsAAJRVrRKv1AvP8expP3heyxQzcNMRun
         NPvJ5aIJa60KUPL74NlJ/aHizuWX8AUkdMMcaY1PlkI+qF8AG+sXDeWezKsAchuPk6+Q
         asETDohZR1rIzrWW8MMM6NPNbt+QIaCxlujZ5KbA+UQFcodCYrV6sPhaVJ/RpyzNrUQ6
         cctyvyrGbubkulaLAlsHAIsozSKkJiW62oHvHrZIaZDsggza5KdIan+7TAtkmv02nJk/
         NP9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777386893; x=1777991693;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eQhFVJ4+LPBUTwWR+M90TmweYjwMt7L56NJXWho9jGA=;
        b=ZJW4tKaiM4o31Yf4mfVImF7f5f5RuRggYiMGFEx1qn9mKtx27Zh/oNmtmDW3HVyeF6
         V+ttMqvOOhil0uGUaGDAthLHmHqd6jsH6NNd53VSbVupGfnk45WIYJaxC/R0COKUMgSL
         C00pm1Aa23xqPGwcQvsFYpShr22ZLbJNjTTtpM6KZuL8s378Pv8Zr0z85a8MlrhkJKTP
         MccURYDDuEc5mtO8Y9rw2GkR21X1g71DWM96L/nv5lm/a/Z5gI3VyiyN+fYogSQKYv6F
         qqhMTYHvO9pW0GwW36doTYKYKd7HOzBrAq07Mf9+dWfvVTNe3OIWdBCTuSQD38+NOtmU
         YdKw==
X-Forwarded-Encrypted: i=1; AFNElJ+Zm6vPg+CKuLmhQXAHcXcQDXajoQ/UNfC/OTLNyXSa6mRujn422I+wYziSbKUVFrKNV0L/Iu8eV9M=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyFqJcJxI7Tckw3Vdtuc0tEBDGtWThth0Jw/h5pXjgcBnYV7o8
	u1MowqGqhWUYnIgi4W/jYtHXhIoewt4JLs2W/+s2dljG6FHWKYt/LFIJCT3IdeJuLDfeuH+fYY0
	4CbQ2mut8dY3zyYKKGFpYwNpRDHVFo+FCyPl9ULoomQ==
X-Gm-Gg: AeBDiet1vs2z/AexF0xxU3UEnMZALltvA6/KxYyCNAQatoHovjzZ1Q4FqGPgg5bozCy
	58aQHRko/tI7vWZ0pNdsz727bdlswjr04LkIaNxpDsOf4SM4dHyFQG/W7tPjdqoeyomWJPQhrhg
	gadH/WXooRnR1qnOnENR89Ysnm9SvCz103nB3rn1VpE190wIDB9NXZ+vQHe6cvnUsYogExUQJye
	/4+7CutEMB4goQCJ5uapu00Wc5ekr54unV4SCDh/TbmMKlChWkdgqRnoSoXMg5sEZvEndml8F69
	sZav1HX6J2rem7ij55gZNRMJPOaAPLhGFnCF9B7McSnsRQ2GoHk=
X-Received: by 2002:a05:622a:454:b0:50f:cba1:18c4 with SMTP id
 d75a77b69052e-5100da50fadmr42348541cf.26.1777386892467; Tue, 28 Apr 2026
 07:34:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260428040159.1065822-1-r@hev.cc> <20260428040159.1065822-2-r@hev.cc>
 <CAAhV-H4dTKEwb6u5X08dX2UFxophvr_GsfB-FFt_UHbVqJJi8Q@mail.gmail.com>
In-Reply-To: <CAAhV-H4dTKEwb6u5X08dX2UFxophvr_GsfB-FFt_UHbVqJJi8Q@mail.gmail.com>
From: WANG Rui <r@hev.cc>
Date: Tue, 28 Apr 2026 22:34:41 +0800
X-Gm-Features: AVHnY4LkuMhCsyaFT_KaCu939taxa_kYyGlqpqAbl_pOc6YGwiBPcLmlHdowgFU
Message-ID: <CAHirt9hvsGLsDEo3qdWtC5BqiJsrCSv8UJYTZfqte8op7c8etw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] efi/loongarch: Randomize kernel preferred address
 for KASLR
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Lisa Robinson <lisa@bytefly.space>, 
	loongarch@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Huacai,

On Tue, Apr 28, 2026 at 1:01=E2=80=AFPM Huacai Chen <chenhuacai@kernel.org>=
 wrote:
>
> Hi, Rui,
>
> On Tue, Apr 28, 2026 at 12:02=E2=80=AFPM WANG Rui <r@hev.cc> wrote:
> >
> > Introduce efi_get_kimg_kaslr_address() to compute the preferred
> > kernel image address dynamically when CONFIG_RANDOMIZE_BASE is
> > enabled. The function derives a random offset using EFI-provided
> > randomness combined with the timer value, and constrains it within
> > CONFIG_RANDOMIZE_BASE_MAX_OFFSET.
> >
> > Update EFI_KIMG_PREFERRED_ADDRESS to call this helper so that the
> > EFI stub can select a randomized load address when KASLR is active,
> > while preserving the original base address behavior when KASLR is
> > disabled or nokaslr is specified.
> >
> > Signed-off-by: WANG Rui <r@hev.cc>
> > ---
> >  arch/loongarch/Kconfig                   |  2 +-
> >  arch/loongarch/include/asm/efi.h         |  4 +++-
> >  drivers/firmware/efi/libstub/loongarch.c | 16 ++++++++++++++++
> >  3 files changed, 20 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
> > index 3b042dbb2c41..a5afb70f73d9 100644
> > --- a/arch/loongarch/Kconfig
> > +++ b/arch/loongarch/Kconfig
> > @@ -730,7 +730,7 @@ config RANDOMIZE_BASE
> >  config RANDOMIZE_BASE_MAX_OFFSET
> >         hex "Maximum KASLR offset" if EXPERT
> >         depends on RANDOMIZE_BASE
> > -       range 0x0 0x10000000
> > +       range 0x20000 0x10000000
> >         default "0x01000000"
> >         help
> >           When KASLR is active, this provides the maximum offset that w=
ill
> > diff --git a/arch/loongarch/include/asm/efi.h b/arch/loongarch/include/=
asm/efi.h
> > index eddc8e79b3fa..f831320efd41 100644
> > --- a/arch/loongarch/include/asm/efi.h
> > +++ b/arch/loongarch/include/asm/efi.h
> > @@ -30,6 +30,8 @@ static inline unsigned long efi_get_kimg_min_align(vo=
id)
> >         return SZ_2M;
> >  }
> >
> > -#define EFI_KIMG_PREFERRED_ADDRESS     PHYSADDR(VMLINUX_LOAD_ADDRESS)
> > +unsigned long efi_get_kimg_kaslr_address(void);
> > +
> > +#define EFI_KIMG_PREFERRED_ADDRESS     efi_get_kimg_kaslr_address()
> >
> >  #endif /* _ASM_LOONGARCH_EFI_H */
> > diff --git a/drivers/firmware/efi/libstub/loongarch.c b/drivers/firmwar=
e/efi/libstub/loongarch.c
> > index 9825f5218137..c44be5d3dc04 100644
> > --- a/drivers/firmware/efi/libstub/loongarch.c
> > +++ b/drivers/firmware/efi/libstub/loongarch.c
> > @@ -38,6 +38,22 @@ static efi_status_t exit_boot_func(struct efi_boot_m=
emmap *map, void *priv)
> >         return EFI_SUCCESS;
> >  }
> >
> > +unsigned long efi_get_kimg_kaslr_address(void)
> Move it into arch/loongarch/include/asm/efi.h?

In that case, we'd need to declare efi_nokaslr and
efi_get_random_bytes() in efi.h. Since including efistub.h in efi.h
doesn't work, putting them here keeps things pretty clean.

Thanks,
Rui

>
> > +{
> > +       unsigned int random_offset =3D 0;
> > +
> > +#ifdef CONFIG_RANDOMIZE_BASE
> > +       if (!efi_nokaslr) {
> > +               efi_get_random_bytes(sizeof(random_offset), (u8 *)&rand=
om_offset);
> > +               random_offset ^=3D (random_get_entropy() << 16);
> > +               random_offset &=3D (CONFIG_RANDOMIZE_BASE_MAX_OFFSET - =
SZ_64K - 1);
> I still don't want to modify the range of RANDOMIZE_BASE_MAX_OFFSET, so u=
se
>      random_offset &=3D (CONFIG_RANDOMIZE_BASE_MAX_OFFSET - 1)
> here?
>
> > +               random_offset =3D ALIGN(random_offset, SZ_64K) + SZ_64K=
;
> It seems "random_offset =3D ALIGN(random_offset + SZ64K, SZ_64K)" is bett=
er.
>
> Huacai
>
> > +       }
> > +#endif
> > +
> > +       return PHYSADDR(VMLINUX_LOAD_ADDRESS) + random_offset;
> > +}
> > +
> >  unsigned long __weak kernel_entry_address(unsigned long kernel_addr,
> >                 efi_loaded_image_t *image)
> >  {
> > --
> > 2.54.0
> >
>
