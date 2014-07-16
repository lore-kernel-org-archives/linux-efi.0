From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RFC PATCH] arm64/efi: efistub: reuse EFI mapping for Image if
 it is lower
Date: Wed, 16 Jul 2014 10:20:37 +0100
Message-ID: <20140716092037.GC26951@leverpostej>
References: <1405443030-4202-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1405443030-4202-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Ard,

On Tue, Jul 15, 2014 at 05:50:30PM +0100, Ard Biesheuvel wrote:
> The EFI loader may load Image at any available offset. This means Image may
> reside very close to or at the base of DRAM, in which case the relocation
> done by efi_entry() results in Image being moved up in memory, which is
> undesirable (memory below the kernel is currently not usable).

Rather than complicating this path I would prefer that we fixed not
being able to address memory below stext - TEXT_OFFSET. That would
simplify the bootloader's job regardless of UEFI, as any loader can then
simply place the kernel at a 2MB-aligned address + TEXT_OFFSET (the
kernel would have to not span a 512MB boundary to keep the initial page
tables simple, but that's still a weaker requirement than what we
currently need).

The approach taken in this patch seems sane for the current way the VA
space is laid out, but if we're not currently wasting an absurd amount
of memory I'd rather we got the VA layout fixed such that we can address
memory below the kernel image.

How much memory are we seeing wasted as a result of the existing
relocation code, and how often?

[...]

>  	/*
> +	 * Check whether the original allocation done by the EFI loader is more
> +	 * favorable (i.e., closer to the base of DRAM) than the new one created
> +	 * by efi_entry(). If so, reuse the original one.
> +	 */
> +	adr	x3, 0f
> +	cmp	x3, x0
> +	bgt	1f	// this image is loaded higher, so just proceed normally
> +
> +	/*
> +	 * Jump into the relocated image so we can move the original Image to
> +	 * a 2 MB boundary + TEXT_OFFSET inside the original mapping without
> +	 * overwriting ourselves.
> +	 */
> +	sub	x3, x3, x22	// subtract current base offset
> +	add	x3, x3, x0	// add base offset of relocated image
> +	br	x3		// jump to next line, but in relocated image

At this point I don't believe the necessary icache maintenance + isb
have occurred to make the new image visible to the I-side and to ensure
we don't have any stale prefetched instructions in the pipeline. That
still seems to happen later. Have I missed something?

> +
> +0:	mov	x1, x0			// copy from relocated Image
> +	sub	x0, x22, #1		// copy to base of original Image
> +	orr	x0, x0, #(SZ_2M - 1)	// .. rounded up to 2 MB
> +	ldr	x3, =(TEXT_OFFSET + 1)	// .. plus TEXT_OFFSET
> +	add	x0, x0, x3
> +	mov	x2, x24			// copy 'size of Image' bytes
> +	bl	memcpy
> +	add	x21, x0, x23		// add stext_offset to entry point
> +1:
> +	/*
>  	 * Flush dcache covering current runtime addresses
>  	 * of kernel text/data. Then flush all of icache.
>  	 */
> -	adrp	x1, _text
> -	add	x1, x1, #:lo12:_text
> -	adrp	x2, _edata
> -	add	x2, x2, #:lo12:_edata
> -	sub	x1, x2, x1
> -
> +	mov	x1, x24                 // size of Image
>  	bl	__flush_dcache_area
>  	ic	ialluis

Cheers,
Mark.
