Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0160E38228D
	for <linux-efi@vger.kernel.org>; Wed, 29 Apr 2026 03:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777432704; cv=pass; b=W41syHDbEswFXFhrmfZCo2qRpm/BFAQ6JrkdYG7r99QULbjHgEYJzfX3x1NznV5N5IUMHgGnM51ZBRbZzCLp//Ro2pvFkB6MDUND/Gg2I14mW/EDHOSrbujgFiX2pYAMrAs28zq51PpGyq0HhV6+iZmsZE0NF8QidTFTHlNszZ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777432704; c=relaxed/simple;
	bh=fnem1tTQhMPBCphl63rdMpCDVaa1ZSa29kyZpy/oz1A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FiVdc3dqjBU4UHAZIi7k9y9+W5YINw1VTW9idUu31XgwS4WTHQwpa5kx6S1D+mwwASnFQJbaMN2h2M8C5XkJUDZCCzd40MBVZypdjEAipIomh1mqK85fR7ROErQVxEuAw69u/ROQsSM6ww77retVi/geSw3DAX2KvY+ZaxF/U58=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc; spf=pass smtp.mailfrom=hev.cc; dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b=n2zezt5F; arc=pass smtp.client-ip=209.85.128.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hev.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hev.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hev-cc.20251104.gappssmtp.com header.i=@hev-cc.20251104.gappssmtp.com header.b="n2zezt5F"
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-797ab169454so137967557b3.3
        for <linux-efi@vger.kernel.org>; Tue, 28 Apr 2026 20:18:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777432701; cv=none;
        d=google.com; s=arc-20240605;
        b=giriIm71rgNC6d0Rz0bQILgvA2rEH6ppiwrtxZFrG+S9JE3Jkqh5Azhzr2Z80lDeFc
         nLLSpBMqjcV16Hi/ZmDQr4pl2F3WBZxyveELf4kipaEY2dfvgDjQ47SW3H2laOmn/Or3
         YBgkcCtZbpDgtqcAQLR2j3/22xwHTvNKWM7LwyNqjyo3B68QSt04TZC2fUVlyNkIblag
         FMpecX7GEjwApMWuEVgM4VGUIKRYMbqpQzLzSgdszJXyt9m5h9e6J+buMapZPwFw77yp
         0yOvqW6BNxJDv0dIX2FQ/ziSjaT6+ooRGsBJL7aiumvxABxkvuhOkELzwYqbYlgZ1tZI
         CylA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fM0QMKG5rcd9S9yxOG9/wQiPQnWdqUgeX7m0i/THKmE=;
        fh=GOVHbcXD1Y0Pqw2AQ6KxjgxHxTYaQlDYEUux7qnIcQI=;
        b=TcnSrWp17A3bAOHpS4EADeyRTpu4h14eotpsZcicKdm8ALfis622dI/u4l8iyhA5C6
         HXcbEKLiC7fsc7x1/aLwFSAQe1v8DHaLx0dSIgdBPXIvQ7MHaKzNl4jhu9q5qPdBawk2
         gJSk5W7k+QUFXmn5r/0QzuvkwhLuA9daKjDwwK1EFOC5+KR45iYcgjENL8qCfyufF6Y0
         gNE8eX4ZcDWRb0OMOcWkUWYQwRGa+8Ws09abqrOnrIB7ZpiZwtCrU/rzJdt/TIYQj0y8
         osOBPcNeIjikwxmFCkgeEUWN1J+EvS5IzHyk6itOC+8d92zwZ7/p0YMN3I+Z0PpVLbM4
         YJpQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20251104.gappssmtp.com; s=20251104; t=1777432701; x=1778037501; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fM0QMKG5rcd9S9yxOG9/wQiPQnWdqUgeX7m0i/THKmE=;
        b=n2zezt5FuNDAmO6PGeyOcGZmWAk7fu8ol/iMcQTueXaUvN4O4x3fErrzMospRTVcKr
         xli6bInrX0OBD+I+i97N5lhKwb8PkJgLbg6joDdfKhjvwkLB2yeMjESRlW9PgFRuNuzR
         VphDMfIUTmGFz+yzm0SAQGpSlINkYwCJpsipgnL0PghRucECb2GC3IpGMJmp75mpSZNZ
         91ntRs36BJ1NulMVJ1PqE/2+XuekPcfrNy42/nWlDafHJKY9P1kC56xzH1ulv++3bEGX
         wnQrzk1+7rdDSt2Y6l1ZRFkEj3YUSEn/YEu3juYDXi8m5/d4bhBPnAwUIQplsz7oDK4n
         bmLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777432701; x=1778037501;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fM0QMKG5rcd9S9yxOG9/wQiPQnWdqUgeX7m0i/THKmE=;
        b=gZ6fxw8eTOB/2U00a6+mWCVMlUYQvfTDy2oDYmoCm0ma/8Xih7YzCBz35BG2S8q0ua
         26I+KgMNmcncM1/NGw7U3jfxKckKxhf7MczrlMvqmhmNpZ9bE/ojJTzPTq8H3HAuJvd/
         b/R9o6XmcOXjARcOdSQXU8bPgxk918YggzGaGgtSy+5FzmEZn1NEmhQy1S+P7qV4PKcM
         jUcLh0eChA0ec9FDa5fLUxQhg9dxtS837DIqb4SgAs4DIEECP2dQ/N56nlTcH1f4zElP
         +fhV1X1EubmBkPugAFPo7xMYt08la+j0Fa+bGACD2qj46EOcqocEZFBq8xYRROtVAtOT
         gJlA==
X-Gm-Message-State: AOJu0YzBam54ESXdK24RXnNIWYUd3q9ktrEb8JyZhst14SubUp+06ZWV
	f2l5Cv7TKg3aCgjjKMLivLsyL2myquzjMo2OQ8cMv63B7DY4CoHh4V5dM1v9ZQEvRRN1O7QGCTU
	PbbiqGYyZqQRru4CLcU+ZuY7xNYDe/OxuEMxsFc+jfA==
X-Gm-Gg: AeBDievuhkl2Oa4+LgiEO4OpsPwqLACSAAYPuEvicICd77cuFAn83m2JYcCVN5T7dIZ
	vN6qxRVx0kNDwK6q4uNInMP5u83K9E+oxkv3KylEZwn0+ObQp8IOwgkJP5BlXlE0Wf8refr/ogH
	bys0a1mR6IXVIjZLPoyEoOxEVp3CDZVM66Tjl67HUsWI58cEK+FJbXXG3yMSw3nIbM39LLndo3j
	o9IbDd2NE+Hu1rVYieu252H2CZmzysQoyMl1ddNMJr2gJABjubK+Jlx7Rgtjb+4OQXZGy8TZLfo
	NVM6MF/l6khGqnY4CMozoLljYzO7gG2cZTEiCzVxApJx9lMkWSbWshdjGTsQxA==
X-Received: by 2002:a05:690c:46ca:b0:7b7:6fab:fc03 with SMTP id
 00721157ae682-7bcf57c027bmr63755927b3.44.1777432700556; Tue, 28 Apr 2026
 20:18:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260428170608.3561937-2-ardb+git@google.com>
In-Reply-To: <20260428170608.3561937-2-ardb+git@google.com>
From: WANG Rui <r@hev.cc>
Date: Wed, 29 Apr 2026 11:18:09 +0800
X-Gm-Features: AVHnY4LDCoj8AL9KjIJCRRmsUMcW4zD9eloV3w_jh8V-0Md_Gd9BcxoGGmoqi4I
Message-ID: <CAHirt9gOEJhbHjgmsRezzx7AuyKGDUky-2mAOv015uCKyOZ7jw@mail.gmail.com>
Subject: Re: [PATCH] efi/libstub: Move efi_relocate_kernel() into its only
 remaining user
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>, 
	Huacai Chen <chenhuacai@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ard,

On Wed, Apr 29, 2026 at 1:06=E2=80=AFAM Ard Biesheuvel <ardb+git@google.com=
> wrote:
>
> From: Ard Biesheuvel <ardb@kernel.org>
>
> LoongArch is the only arch that still uses efi_relocate_kernel(), so
> before making changes to it that LoongArch needs, turn it into a private
> function. Move efi_low_alloc_above() into mem.c while at it, and drop
> the relocate.c source file altogether.
>
> Cc: WANG Rui <r@hev.cc>
> Cc: Huacai Chen <chenhuacai@loongson.cn>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Tested-by: WANG Rui <wangrui@loongson.cn>

Thanks,
Rui

> ---
> Unless there are any objections, I will queue this up and rebase the
> LoongArch changes adding efi_cache_sync_image() on top of it.
>
>  drivers/firmware/efi/libstub/Makefile         |   2 +-
>  drivers/firmware/efi/libstub/efistub.h        |   7 -
>  drivers/firmware/efi/libstub/loongarch-stub.c |  79 ++++++++++
>  drivers/firmware/efi/libstub/mem.c            |  82 ++++++++++
>  drivers/firmware/efi/libstub/relocate.c       | 166 --------------------
>  5 files changed, 162 insertions(+), 174 deletions(-)
>
> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi=
/libstub/Makefile
> index 983a438e35f3..cfedb3025c26 100644
> --- a/drivers/firmware/efi/libstub/Makefile
> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -66,7 +66,7 @@ KBUILD_AFLAGS                 :=3D $(KBUILD_CFLAGS) -D_=
_ASSEMBLY__
>  lib-y                          :=3D efi-stub-helper.o gop.o secureboot.o=
 tpm.o \
>                                    file.o mem.o random.o randomalloc.o pc=
i.o \
>                                    skip_spaces.o lib-cmdline.o lib-ctype.=
o \
> -                                  alignedmem.o relocate.o printk.o vspri=
ntf.o
> +                                  alignedmem.o printk.o vsprintf.o
>
>  # include the stub's libfdt dependencies from lib/ when needed
>  libfdt-deps                    :=3D fdt_rw.c fdt_ro.c fdt_wip.c fdt.c \
> diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/ef=
i/libstub/efistub.h
> index 979a21818cc1..fd91fc15ec81 100644
> --- a/drivers/firmware/efi/libstub/efistub.h
> +++ b/drivers/firmware/efi/libstub/efistub.h
> @@ -1104,13 +1104,6 @@ efi_status_t efi_allocate_pages_aligned(unsigned l=
ong size, unsigned long *addr,
>  efi_status_t efi_low_alloc_above(unsigned long size, unsigned long align=
,
>                                  unsigned long *addr, unsigned long min);
>
> -efi_status_t efi_relocate_kernel(unsigned long *image_addr,
> -                                unsigned long image_size,
> -                                unsigned long alloc_size,
> -                                unsigned long preferred_addr,
> -                                unsigned long alignment,
> -                                unsigned long min_addr);
> -
>  efi_status_t efi_parse_options(char const *cmdline);
>
>  void efi_parse_option_graphics(char *option);
> diff --git a/drivers/firmware/efi/libstub/loongarch-stub.c b/drivers/firm=
ware/efi/libstub/loongarch-stub.c
> index 736b6aae323d..8c538a5243d9 100644
> --- a/drivers/firmware/efi/libstub/loongarch-stub.c
> +++ b/drivers/firmware/efi/libstub/loongarch-stub.c
> @@ -14,6 +14,85 @@ extern int kernel_asize;
>  extern int kernel_fsize;
>  extern int kernel_entry;
>
> +/**
> + * efi_relocate_kernel() - copy memory area
> + * @image_addr:                pointer to address of memory area to copy
> + * @image_size:                size of memory area to copy
> + * @alloc_size:                minimum size of memory to allocate, must =
be greater or
> + *                     equal to image_size
> + * @preferred_addr:    preferred target address
> + * @alignment:         minimum alignment of the allocated memory area. I=
t
> + *                     should be a power of two.
> + * @min_addr:          minimum target address
> + *
> + * Copy a memory area to a newly allocated memory area aligned according
> + * to @alignment but at least EFI_ALLOC_ALIGN. If the preferred address
> + * is not available, the allocated address will not be below @min_addr.
> + * On exit, @image_addr is updated to the target copy address that was u=
sed.
> + *
> + * This function is used to copy the Linux kernel verbatim. It does not =
apply
> + * any relocation changes.
> + *
> + * Return:             status code
> + */
> +static
> +efi_status_t efi_relocate_kernel(unsigned long *image_addr,
> +                                unsigned long image_size,
> +                                unsigned long alloc_size,
> +                                unsigned long preferred_addr,
> +                                unsigned long alignment,
> +                                unsigned long min_addr)
> +{
> +       unsigned long cur_image_addr;
> +       unsigned long new_addr =3D 0;
> +       efi_status_t status;
> +       unsigned long nr_pages;
> +       efi_physical_addr_t efi_addr =3D preferred_addr;
> +
> +       if (!image_addr || !image_size || !alloc_size)
> +               return EFI_INVALID_PARAMETER;
> +       if (alloc_size < image_size)
> +               return EFI_INVALID_PARAMETER;
> +
> +       cur_image_addr =3D *image_addr;
> +
> +       /*
> +        * The EFI firmware loader could have placed the kernel image
> +        * anywhere in memory, but the kernel has restrictions on the
> +        * max physical address it can run at.  Some architectures
> +        * also have a preferred address, so first try to relocate
> +        * to the preferred address.  If that fails, allocate as low
> +        * as possible while respecting the required alignment.
> +        */
> +       nr_pages =3D round_up(alloc_size, EFI_ALLOC_ALIGN) / EFI_PAGE_SIZ=
E;
> +       status =3D efi_bs_call(allocate_pages, EFI_ALLOCATE_ADDRESS,
> +                            EFI_LOADER_DATA, nr_pages, &efi_addr);
> +       new_addr =3D efi_addr;
> +       /*
> +        * If preferred address allocation failed allocate as low as
> +        * possible.
> +        */
> +       if (status !=3D EFI_SUCCESS) {
> +               status =3D efi_low_alloc_above(alloc_size, alignment, &ne=
w_addr,
> +                                            min_addr);
> +       }
> +       if (status !=3D EFI_SUCCESS) {
> +               efi_err("Failed to allocate usable memory for kernel.\n")=
;
> +               return status;
> +       }
> +
> +       /*
> +        * We know source/dest won't overlap since both memory ranges
> +        * have been allocated by UEFI, so we can safely use memcpy.
> +        */
> +       memcpy((void *)new_addr, (void *)cur_image_addr, image_size);
> +
> +       /* Return the new address of the relocated image. */
> +       *image_addr =3D new_addr;
> +
> +       return status;
> +}
> +
>  efi_status_t handle_kernel_image(unsigned long *image_addr,
>                                  unsigned long *image_size,
>                                  unsigned long *reserve_addr,
> diff --git a/drivers/firmware/efi/libstub/mem.c b/drivers/firmware/efi/li=
bstub/mem.c
> index 9c82259eea81..59f3f83de50c 100644
> --- a/drivers/firmware/efi/libstub/mem.c
> +++ b/drivers/firmware/efi/libstub/mem.c
> @@ -124,3 +124,85 @@ void efi_free(unsigned long size, unsigned long addr=
)
>         nr_pages =3D round_up(size, EFI_ALLOC_ALIGN) / EFI_PAGE_SIZE;
>         efi_bs_call(free_pages, addr, nr_pages);
>  }
> +
> +/**
> + * efi_low_alloc_above() - allocate pages at or above given address
> + * @size:      size of the memory area to allocate
> + * @align:     minimum alignment of the allocated memory area. It should
> + *             a power of two.
> + * @addr:      on exit the address of the allocated memory
> + * @min:       minimum address to used for the memory allocation
> + *
> + * Allocate at the lowest possible address that is not below @min as
> + * EFI_LOADER_DATA. The allocated pages are aligned according to @align =
but at
> + * least EFI_ALLOC_ALIGN. The first allocated page will not below the ad=
dress
> + * given by @min.
> + *
> + * Return:     status code
> + */
> +efi_status_t efi_low_alloc_above(unsigned long size, unsigned long align=
,
> +                                unsigned long *addr, unsigned long min)
> +{
> +       struct efi_boot_memmap *map __free(efi_pool) =3D NULL;
> +       efi_status_t status;
> +       unsigned long nr_pages;
> +       int i;
> +
> +       status =3D efi_get_memory_map(&map, false);
> +       if (status !=3D EFI_SUCCESS)
> +               return status;
> +
> +       /*
> +        * Enforce minimum alignment that EFI or Linux requires when
> +        * requesting a specific address.  We are doing page-based (or
> +        * larger) allocations, and both the address and size must meet
> +        * alignment constraints.
> +        */
> +       if (align < EFI_ALLOC_ALIGN)
> +               align =3D EFI_ALLOC_ALIGN;
> +
> +       size =3D round_up(size, EFI_ALLOC_ALIGN);
> +       nr_pages =3D size / EFI_PAGE_SIZE;
> +       for (i =3D 0; i < map->map_size / map->desc_size; i++) {
> +               efi_memory_desc_t *desc;
> +               unsigned long m =3D (unsigned long)map->map;
> +               u64 start, end;
> +
> +               desc =3D efi_memdesc_ptr(m, map->desc_size, i);
> +
> +               if (desc->type !=3D EFI_CONVENTIONAL_MEMORY)
> +                       continue;
> +
> +               if (desc->attribute & EFI_MEMORY_HOT_PLUGGABLE)
> +                       continue;
> +
> +               if (efi_soft_reserve_enabled() &&
> +                   (desc->attribute & EFI_MEMORY_SP))
> +                       continue;
> +
> +               if (desc->num_pages < nr_pages)
> +                       continue;
> +
> +               start =3D desc->phys_addr;
> +               end =3D start + desc->num_pages * EFI_PAGE_SIZE;
> +
> +               if (start < min)
> +                       start =3D min;
> +
> +               start =3D round_up(start, align);
> +               if ((start + size) > end)
> +                       continue;
> +
> +               status =3D efi_bs_call(allocate_pages, EFI_ALLOCATE_ADDRE=
SS,
> +                                    EFI_LOADER_DATA, nr_pages, &start);
> +               if (status =3D=3D EFI_SUCCESS) {
> +                       *addr =3D start;
> +                       break;
> +               }
> +       }
> +
> +       if (i =3D=3D map->map_size / map->desc_size)
> +               return EFI_NOT_FOUND;
> +
> +       return EFI_SUCCESS;
> +}
> diff --git a/drivers/firmware/efi/libstub/relocate.c b/drivers/firmware/e=
fi/libstub/relocate.c
> deleted file mode 100644
> index d4264bfb6dc1..000000000000
> --- a/drivers/firmware/efi/libstub/relocate.c
> +++ /dev/null
> @@ -1,166 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0
> -
> -#include <linux/efi.h>
> -#include <asm/efi.h>
> -
> -#include "efistub.h"
> -
> -/**
> - * efi_low_alloc_above() - allocate pages at or above given address
> - * @size:      size of the memory area to allocate
> - * @align:     minimum alignment of the allocated memory area. It should
> - *             a power of two.
> - * @addr:      on exit the address of the allocated memory
> - * @min:       minimum address to used for the memory allocation
> - *
> - * Allocate at the lowest possible address that is not below @min as
> - * EFI_LOADER_DATA. The allocated pages are aligned according to @align =
but at
> - * least EFI_ALLOC_ALIGN. The first allocated page will not below the ad=
dress
> - * given by @min.
> - *
> - * Return:     status code
> - */
> -efi_status_t efi_low_alloc_above(unsigned long size, unsigned long align=
,
> -                                unsigned long *addr, unsigned long min)
> -{
> -       struct efi_boot_memmap *map __free(efi_pool) =3D NULL;
> -       efi_status_t status;
> -       unsigned long nr_pages;
> -       int i;
> -
> -       status =3D efi_get_memory_map(&map, false);
> -       if (status !=3D EFI_SUCCESS)
> -               return status;
> -
> -       /*
> -        * Enforce minimum alignment that EFI or Linux requires when
> -        * requesting a specific address.  We are doing page-based (or
> -        * larger) allocations, and both the address and size must meet
> -        * alignment constraints.
> -        */
> -       if (align < EFI_ALLOC_ALIGN)
> -               align =3D EFI_ALLOC_ALIGN;
> -
> -       size =3D round_up(size, EFI_ALLOC_ALIGN);
> -       nr_pages =3D size / EFI_PAGE_SIZE;
> -       for (i =3D 0; i < map->map_size / map->desc_size; i++) {
> -               efi_memory_desc_t *desc;
> -               unsigned long m =3D (unsigned long)map->map;
> -               u64 start, end;
> -
> -               desc =3D efi_memdesc_ptr(m, map->desc_size, i);
> -
> -               if (desc->type !=3D EFI_CONVENTIONAL_MEMORY)
> -                       continue;
> -
> -               if (desc->attribute & EFI_MEMORY_HOT_PLUGGABLE)
> -                       continue;
> -
> -               if (efi_soft_reserve_enabled() &&
> -                   (desc->attribute & EFI_MEMORY_SP))
> -                       continue;
> -
> -               if (desc->num_pages < nr_pages)
> -                       continue;
> -
> -               start =3D desc->phys_addr;
> -               end =3D start + desc->num_pages * EFI_PAGE_SIZE;
> -
> -               if (start < min)
> -                       start =3D min;
> -
> -               start =3D round_up(start, align);
> -               if ((start + size) > end)
> -                       continue;
> -
> -               status =3D efi_bs_call(allocate_pages, EFI_ALLOCATE_ADDRE=
SS,
> -                                    EFI_LOADER_DATA, nr_pages, &start);
> -               if (status =3D=3D EFI_SUCCESS) {
> -                       *addr =3D start;
> -                       break;
> -               }
> -       }
> -
> -       if (i =3D=3D map->map_size / map->desc_size)
> -               return EFI_NOT_FOUND;
> -
> -       return EFI_SUCCESS;
> -}
> -
> -/**
> - * efi_relocate_kernel() - copy memory area
> - * @image_addr:                pointer to address of memory area to copy
> - * @image_size:                size of memory area to copy
> - * @alloc_size:                minimum size of memory to allocate, must =
be greater or
> - *                     equal to image_size
> - * @preferred_addr:    preferred target address
> - * @alignment:         minimum alignment of the allocated memory area. I=
t
> - *                     should be a power of two.
> - * @min_addr:          minimum target address
> - *
> - * Copy a memory area to a newly allocated memory area aligned according
> - * to @alignment but at least EFI_ALLOC_ALIGN. If the preferred address
> - * is not available, the allocated address will not be below @min_addr.
> - * On exit, @image_addr is updated to the target copy address that was u=
sed.
> - *
> - * This function is used to copy the Linux kernel verbatim. It does not =
apply
> - * any relocation changes.
> - *
> - * Return:             status code
> - */
> -efi_status_t efi_relocate_kernel(unsigned long *image_addr,
> -                                unsigned long image_size,
> -                                unsigned long alloc_size,
> -                                unsigned long preferred_addr,
> -                                unsigned long alignment,
> -                                unsigned long min_addr)
> -{
> -       unsigned long cur_image_addr;
> -       unsigned long new_addr =3D 0;
> -       efi_status_t status;
> -       unsigned long nr_pages;
> -       efi_physical_addr_t efi_addr =3D preferred_addr;
> -
> -       if (!image_addr || !image_size || !alloc_size)
> -               return EFI_INVALID_PARAMETER;
> -       if (alloc_size < image_size)
> -               return EFI_INVALID_PARAMETER;
> -
> -       cur_image_addr =3D *image_addr;
> -
> -       /*
> -        * The EFI firmware loader could have placed the kernel image
> -        * anywhere in memory, but the kernel has restrictions on the
> -        * max physical address it can run at.  Some architectures
> -        * also have a preferred address, so first try to relocate
> -        * to the preferred address.  If that fails, allocate as low
> -        * as possible while respecting the required alignment.
> -        */
> -       nr_pages =3D round_up(alloc_size, EFI_ALLOC_ALIGN) / EFI_PAGE_SIZ=
E;
> -       status =3D efi_bs_call(allocate_pages, EFI_ALLOCATE_ADDRESS,
> -                            EFI_LOADER_DATA, nr_pages, &efi_addr);
> -       new_addr =3D efi_addr;
> -       /*
> -        * If preferred address allocation failed allocate as low as
> -        * possible.
> -        */
> -       if (status !=3D EFI_SUCCESS) {
> -               status =3D efi_low_alloc_above(alloc_size, alignment, &ne=
w_addr,
> -                                            min_addr);
> -       }
> -       if (status !=3D EFI_SUCCESS) {
> -               efi_err("Failed to allocate usable memory for kernel.\n")=
;
> -               return status;
> -       }
> -
> -       /*
> -        * We know source/dest won't overlap since both memory ranges
> -        * have been allocated by UEFI, so we can safely use memcpy.
> -        */
> -       memcpy((void *)new_addr, (void *)cur_image_addr, image_size);
> -
> -       /* Return the new address of the relocated image. */
> -       *image_addr =3D new_addr;
> -
> -       return status;
> -}
> --
> 2.54.0.545.g6539524ca2-goog
>
