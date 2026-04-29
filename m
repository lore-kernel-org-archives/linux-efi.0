Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0D33A544A
	for <linux-efi@vger.kernel.org>; Wed, 29 Apr 2026 09:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777453466; cv=pass; b=JE6O9/m2EYplFfSFwf1X1nEDGbJj4YBRGvNZ9fSNpSiLR5ts3YymuA2Pk1ovzk+25dQFaPUULonDHJxaNor1q4uGv9HvLMIHGGFRQM05wk1mM8H1FsRk4tDo6nHAwAOLs4SZh4NjmZpKWvLRiIyulLlO8WnvoD/gi/vjAxrfEJM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777453466; c=relaxed/simple;
	bh=ZMyxqcIFaP9OJPmN8xllVR/qPV5bDUfWiOPhSHyGVtg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q3BCqZPN9ZKHcf2r7SKOGuCEO96hwfjSohDkyXSHIG24/gSwj2xf0nhgkFI6f5pwaWW0xPyB1fcKqPe/2wt5qNfqskbDfJMH6wv6YtJ5PU/ObTPJE5EWo2lfKByy+zT4CWMucPqKbj8BGVJnHRyG+9merFjCLgf4sAreomHCrgU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=g2FLMRSk; arc=pass smtp.client-ip=74.125.224.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="g2FLMRSk"
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-65075c2ba66so10291066d50.1
        for <linux-efi@vger.kernel.org>; Wed, 29 Apr 2026 02:04:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777453464; cv=none;
        d=google.com; s=arc-20240605;
        b=jh6esg310/A6HUXCyu2C+Qfsah48Wr8/MjaiPuhPg3YNQwADr1j//S6oJ54sPdruU6
         xcR6uwe6tZoa5OUgRujM1VOLZ+JxX/UvgWuaz0/dE/uYJWOaYwRGPxu/c04JmpzZwW3t
         qNWXoghsNGNzQLPMu9mk45QU2sSY/W0XT1Os7IQkkA3xZPjLHc5Ft43taVVX6wTAk3OH
         TNB0QrJ+hAQS8o5P/4xKE30yakgtMXmolyUPD+SX61e8F+vO4A0SO4+kSst5w+Yfn4RB
         kMg3aL6tmjg3OoLPN97KMzCiL/Nv8TFo6OsFQH6513iudUkONkO5vozsG+hY7Nz4tFve
         1D7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=H/hCEm95VzRETV93q9jodeYGEMcpGO34GjU4Jtkr8Lc=;
        fh=fmbZAb3ghGDnYC299taEuFdKkLf15AlpRFNLnKJKWp0=;
        b=UUDPTR+mZEu2hxHuFbZZIE5b0SnkO+y9Z7D2DK8F6u6XoF8HBRIDDNW3cfZNa/yb0q
         Ho8kjywtfTbGywhMrYWj1WDY7zm9mb8Jj8APDnnll+pUxrQGSIGv3hBymrHxwGV9uZm1
         z/0tP+Qug9KLACsRXTNrkfNjKy7ZqHwG9oEVEuvfp1bdzA3Aj7wayjxRbHwePLLReRiE
         M6LI9L+oWWncqaNw+dFhQffneKW/9OQGobeY3kmC2lE6i8TP5PSOPn20SyrL98jIRx/f
         v7qoU8YuEiD/4g6QDE7Q/5FW8LGC/eVPr6afyfdLtLHJFPsuKY/B1DQ5G4vKffEHh2Lj
         d8TA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777453464; x=1778058264; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H/hCEm95VzRETV93q9jodeYGEMcpGO34GjU4Jtkr8Lc=;
        b=g2FLMRSkn2rJfH108WZ/eZLlu3Y8FKQDXgSev3NF1gmf4265LMXLl2L6nHzcvu52X6
         zGoUH1l4st2Q53VlHcZMmKtJ6HfM36ly5rp9/t8wSm2md+NzdFg57GdUjhUXrtCU2XAM
         dXz79jD2l1twAQQIeOs4hKB8Ltyky7aBgb4cYMmq2lYtcqTCg0GHz6abseh0BxDE8mqF
         mRZd5KqcVrzkfKdEZpicFTYS60waOmsypXfBNLfLVYFHVaj5/H7MvK3TgrQ6TdiyP6R0
         Z/oV5ph5pWsuEdQhwQVB6WtSkPuXtHAYmbDIgcryikWXaBOHLqIa7IdpgWnRdDNJzLeo
         PLiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777453464; x=1778058264;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H/hCEm95VzRETV93q9jodeYGEMcpGO34GjU4Jtkr8Lc=;
        b=lSP2YBtAC0x82jmyMW0CTDMvClA0pNSgB6A+G2j5KtgKMcmfLjDrj+s+sj8shr2SoG
         5nvNPqHyJ5BbbLciCHZrto1UvIYErUroRpWxns65vzYdzPRD1g6I62adEZhpE8QYSLxD
         MTdjRvd80gqKwm0AQO+KEIVDjBLU/8Jxfl7tnFm/t1uFm/9sev8iD/9LB5G4qxbmgEGq
         7vRDVyJHDHEks6MBYJHwHKLppZNILnORQ+qZoy73EQhvMCnBa+rV8nfm14wxj2RkKM1e
         skMYcejwlMlzAhdBATc16N8taph5H1PkCCleJ70ufACFdOd8XJP3UY2qTLl/SfX0gWM4
         MOJw==
X-Forwarded-Encrypted: i=1; AFNElJ/GKq7FYA/o/6ObfnVtjpSSER7FVAxX8LbkHCqKkvzf+g1gxfwD6efamSkYsbHPzxsKK3p8K7RA9kg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBLJRnAPs9BaAWSYrvnlM8Lij+V6owp8KZ+u7B2rSXdlWPf38g
	o0VygEEzkzUd/kANKI2As7sEqqfuqkCyHmb+I4BL+YgC4yUMiZNti7KPdY8xpy/Nkx1G1+hsb90
	fRUJJa/huHeIHMUdFmuFG7+AxoBET+2b7CLYmFLxLvMWdKTDbOMx5+dDYCQ==
X-Gm-Gg: AeBDievLUBchdvt6tKTa73nIv5ZtpuVVD0+yLZRzo+jTfpf1jNKv49PwCnZt/MBDwdN
	cphwWB7osmYPxC13jaFvSQprzVlq2w3Fenkbqz+cILtHWJ5ejVZWLGM40z8W376vpr4fcHOWj5K
	Ch+FRTebaRKheJGZJwtoe4z73TAc8pSdiDt4Dw/0+pRMmgLzBMk6Yua5q+k4mLHV477q0ejpBd/
	dWlVtL18b0OLvubDQC2RQ60weyKTiRRSvd3PFlvNzuq/JM+N4zNops7BMZeLZ7ASfGM75GSVpa3
	O4l/VethAf558rum1OXBqfOq9ptuQpoCBLur5eaTU0X4kQpStsc=
X-Received: by 2002:a05:690e:484e:b0:650:131b:6ee4 with SMTP id
 956f58d0204a3-65beed7791emr4448465d50.20.1777453463614; Wed, 29 Apr 2026
 02:04:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260429051318.1581350-1-r@hev.cc> <20260429051318.1581350-2-r@hev.cc>
 <cdbbe14e-c677-4c32-b7e6-19e76a716171@app.fastmail.com>
In-Reply-To: <cdbbe14e-c677-4c32-b7e6-19e76a716171@app.fastmail.com>
From: WANG Rui <r@hev.cc>
Date: Wed, 29 Apr 2026 17:04:11 +0800
X-Gm-Features: AVHnY4KZA8Yvg_6QGfU5v96qrCiBFIQkfKN0rmWvrlYlZQXk3i65J-hrRobuDxM
Message-ID: <CAHirt9hCLMmfhyYisWGB+84OauMx1_w1maEpEZhx34dPX6xiyA@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] efi/loongarch: Randomize kernel preferred address
 for KASLR
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Haiyong Sun <sunhaiyong@loongson.cn>, 
	Lisa Robinson <lisa@bytefly.space>, loongarch@lists.linux.dev, linux-efi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ard,

On Wed, Apr 29, 2026 at 4:55=E2=80=AFPM Ard Biesheuvel <ardb@kernel.org> wr=
ote:
>
>
>
> On Wed, 29 Apr 2026, at 07:13, WANG Rui wrote:
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
> >  arch/loongarch/include/asm/efi.h         |  4 +++-
> >  drivers/firmware/efi/libstub/loongarch.c | 16 ++++++++++++++++
> >  2 files changed, 19 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/loongarch/include/asm/efi.h b/arch/loongarch/include/=
asm/efi.h
> > index eddc8e79b3fa..f831320efd41 100644
> > --- a/arch/loongarch/include/asm/efi.h
> > +++ b/arch/loongarch/include/asm/efi.h
> > @@ -30,6 +30,8 @@ static inline unsigned long efi_get_kimg_min_align(vo=
id)
> >       return SZ_2M;
> >  }
> >
> > -#define EFI_KIMG_PREFERRED_ADDRESS   PHYSADDR(VMLINUX_LOAD_ADDRESS)
> > +unsigned long efi_get_kimg_kaslr_address(void);
> > +
>
> Where is the call to this function being added?
>
> > +#define EFI_KIMG_PREFERRED_ADDRESS   efi_get_kimg_kaslr_address()

1. drivers/firmware/efi/libstub/loongarch-stub.c

  efi_status_t handle_kernel_image(...)
  {
      ...
      status =3D efi_relocate_kernel(&kernel_addr, kernel_fsize, kernel_asi=
ze,
               EFI_KIMG_PREFERRED_ADDRESS, efi_get_kimg_min_align(), 0x0);
      ...
  }

2. drivers/firmware/efi/libstub/zboot.c

  static unsigned long alloc_preferred_address(...)
  {
  #ifdef EFI_KIMG_PREFERRED_ADDRESS
      efi_physical_addr_t efi_addr =3D EFI_KIMG_PREFERRED_ADDRESS;

      if (efi_bs_call(allocate_pages, EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA=
,
              alloc_size / EFI_PAGE_SIZE, &efi_addr) =3D=3D EFI_SUCCESS)
          return efi_addr;
  #endif
      return ULONG_MAX;
  }

Thanks,
Rui

> >
> >  #endif /* _ASM_LOONGARCH_EFI_H */
> > diff --git a/drivers/firmware/efi/libstub/loongarch.c
> > b/drivers/firmware/efi/libstub/loongarch.c
> > index 9825f5218137..51997a0e83bd 100644
> > --- a/drivers/firmware/efi/libstub/loongarch.c
> > +++ b/drivers/firmware/efi/libstub/loongarch.c
> > @@ -38,6 +38,22 @@ static efi_status_t exit_boot_func(struct
> > efi_boot_memmap *map, void *priv)
> >       return EFI_SUCCESS;
> >  }
> >
> > +unsigned long efi_get_kimg_kaslr_address(void)
> > +{
> > +     unsigned int random_offset =3D 0;
> > +
> > +#ifdef CONFIG_RANDOMIZE_BASE
> > +     if (!efi_nokaslr) {
> > +             efi_get_random_bytes(sizeof(random_offset), (u8 *)&random=
_offset);
> > +             random_offset ^=3D (random_get_entropy() << 16);
> > +             random_offset &=3D (CONFIG_RANDOMIZE_BASE_MAX_OFFSET - 1)=
;
> > +             random_offset =3D ALIGN(random_offset + SZ_64K, SZ_64K);
> > +     }
> > +#endif
> > +
> > +     return PHYSADDR(VMLINUX_LOAD_ADDRESS) + random_offset;
> > +}
> > +
> >  unsigned long __weak kernel_entry_address(unsigned long kernel_addr,
> >               efi_loaded_image_t *image)
> >  {
> > --
> > 2.54.0
