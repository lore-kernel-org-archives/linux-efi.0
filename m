From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH] arm64/efi: set PE/COFF section alignment to 4 KB
Date: Fri, 10 Oct 2014 11:33:01 +0100
Message-ID: <20141010103301.GC4076@leverpostej>
References: <1412933124-13018-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1412933124-13018-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Ard,

On Fri, Oct 10, 2014 at 10:25:24AM +0100, Ard Biesheuvel wrote:
> Position independent AArch64 code needs to be linked and loaded at the same
> relative offset from a 4 KB boundary, or adrp/add and adrp/ldr pairs will
> not work correctly. (This is how PC relative symbol references with a 4 GB
> reach are emitted)
> 
> We need to declare this in the PE/COFF header, otherwise the PE/COFF loader
> may load the Image and invoke the stub at an offset which violates this rule.

Has this been observed happening, or was this just found by inspection?

> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm64/kernel/head.S | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index 0a6e4f924df8..5e83e5b8a9de 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -159,7 +159,7 @@ optional_header:
>  
>  extra_header_fields:
>  	.quad	0				// ImageBase
> -	.long	0x20				// SectionAlignment
> +	.long	0x1000				// SectionAlignment
>  	.long	0x8				// FileAlignment
>  	.short	0				// MajorOperatingSystemVersion
>  	.short	0				// MinorOperatingSystemVersion
> @@ -226,7 +226,7 @@ section_table:
>  	.short	0		// NumberOfRelocations  (0 for executables)
>  	.short	0		// NumberOfLineNumbers  (0 for executables)
>  	.long	0xe0500020	// Characteristics (section flags)
> -	.align 5
> +	.align 12

Can we get a comment explaining why stext needs the additional
alignment? Something like:

	/*
	 * EFI will load stext onwards at the 4k section alignment
	 * described in the PE/COFF header. To ensure that instruction
	 * sequences using an adrp and a :lo12: immediate will function
	 * correctly at this alignment, we must ensure that stext is
	 * placed at a 4k boundary in the Image to begin with.
	 */
	.align 12

Otherwise this looks sane to me.

Thanks,
Mark.
