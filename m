From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 1/2] arm64: add C struct definition for Image header
Date: Mon, 14 Jul 2014 17:58:51 +0100
Message-ID: <20140714165851.GO26465@leverpostej>
References: <1405354671-14031-1-git-send-email-ard.biesheuvel@linaro.org>
 <1405354671-14031-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1405354671-14031-2-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <geoff-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Ard,

On Mon, Jul 14, 2014 at 05:17:50PM +0100, Ard Biesheuvel wrote:
> In order to be able to interpret the Image header from C code, we need a
> struct definition that reflects the specification for Image headers as laid
> out in Documentation/arm64/booting.txt.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm64/include/asm/image_hdr.h | 75 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 75 insertions(+)
>  create mode 100644 arch/arm64/include/asm/image_hdr.h
> 
> diff --git a/arch/arm64/include/asm/image_hdr.h b/arch/arm64/include/asm/image_hdr.h
> new file mode 100644
> index 000000000000..9dc74b672124
> --- /dev/null
> +++ b/arch/arm64/include/asm/image_hdr.h
> @@ -0,0 +1,75 @@
> +/*
> + * image_hdr.h - C struct definition of the arm64 Image header format
> + *
> + * Copyright (C) 2014 Linaro Ltd
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef __ASM_IMAGE_HDR_H
> +#define __ASM_IMAGE_HDR_H
> +
> +#ifdef __KERNEL__
> +#include <linux/types.h>
> +#else
> +#include <stdint.h>
> +#endif
> +
> +/**
> + * struct arm64_image_hdr - arm64 kernel Image binary header format
> + * @code0:		entry point, first instruction to jump to when booting
> + *			the Image
> + * @code1:		second instruction of entry point
> + * @text_offset:	mandatory offset (little endian) beyond a 2 megabyte
> + * 			aligned boundary that needs to be taken into account
> + * 			when deciding where to load the image
> + * @image_size:		total size (little endian) of the memory area (counted
> + *			from the offset where the image was loaded) that may be
> + *			used by the booting kernel before memory reservations
> + *			can be honoured
> + * @flags:		little endian bit field
> + *			Bit 0:		Kernel endianness.  1 if BE, 0 if LE.
> + *			Bits 1-63:	Reserved.
> + * @res2:		reserved, must be 0
> + * @res3:		reserved, must be 0
> + * @res4:		reserved, must be 0
> + * @magic:		Magic number (little endian): "ARM\x64"
> + * @res5:		reserved (used for PE COFF offset)
> + *
> + * This definition reflects the definition in Documentation/arm64/booting.txt in
> + * the Linux source tree.
> + */

Can we not just say "See Documentation/arm64/booting.txt" rather than
duplicating the description?

> +struct arm64_image_hdr {
> +	uint32_t code0;
> +	uint32_t code1;
> +	uint64_t text_offset;
> +	uint64_t image_size;
> +	uint64_t flags;
> +	uint64_t res2;
> +	uint64_t res3;
> +	uint64_t res4;
> +	uint32_t magic;
> +	uint32_t res5;
> +};
> +
> +static const union {
> +	uint8_t		le_val[4];
> +	uint32_t	cpu_val;
> +} arm64_image_hdr_magic = {
> +	.le_val		= "ARM\x64"
> +};
> +
> +/**
> + * int arm64_image_hdr_check() - check whether hdr points to an arm64 Image
> + * @hdr:	pointer to an arm64 Image
> + *
> + * Return: 1 if check is successful, 0 otherwise
> + */
> +static inline int arm64_image_hdr_check(struct arm64_image_hdr const *hdr)
> +{
> +	return hdr->magic == arm64_image_hdr_magic.cpu_val;
> +}

Rather than the arm64_image_hdr_magic union trick above, could we not
just use the magic inline with a memcmp, e.g.

static inline int arm64_image_hdr_check(struct arm64_image_hdr const *hdr)
{
	return !memcmp(&hdr->magic, "ARM\x64", 4);
}

I'm a little hesitant to expose this to userspace in case the size of
the structure grows and userspace starts relying on it having a
particular length (though perhaps that's unfounded).

It's also a little unfortunate that we lose the nice endianness
annotations here, as it gives a wrong impression of the structure as a
set of native-endian fields.

Thanks,
Mark.
