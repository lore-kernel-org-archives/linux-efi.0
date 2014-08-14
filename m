From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2 2/3] arm64/efi: efistub: cover entire static mem
 footprint in PE/COFF .text
Date: Thu, 14 Aug 2014 12:31:25 +0100
Message-ID: <20140814113125.GD24018@leverpostej>
References: <1406717944-24725-1-git-send-email-ard.biesheuvel@linaro.org>
 <1406717944-24725-3-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1406717944-24725-3-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Jul 30, 2014 at 11:59:03AM +0100, Ard Biesheuvel wrote:
> The static memory footprint of a kernel Image at boot is larger than the
> Image file itself. Things like .bss data and initial page tables are allocated
> statically but populated dynamically so their content is not contained in the
> Image file.
> 
> However, if EFI (or GRUB) has loaded the Image at precisely the desired offset
> of base of DRAM + TEXT_OFFSET, the Image will be booted in place, and we have
> to make sure that the allocation done by the PE/COFF loader is large enough.
> 
> Fix this by growing the PE/COFF .text section to cover the entire static
> memory footprint. The part of the section that is not covered by the payload
> will be zero initialised by the PE/COFF loader.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Acked-by: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

This looks sane to me and it seems we do the same for x86 as of
c7fb93ec51d4 (x86/efi: Include a .bss section within the PE/COFF
headers). So:

Acked-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>

> ---
>  arch/arm64/kernel/head.S | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index 144f10567f82..b6ca95aee348 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -151,7 +151,7 @@ optional_header:
>  	.short	0x20b				// PE32+ format
>  	.byte	0x02				// MajorLinkerVersion
>  	.byte	0x14				// MinorLinkerVersion
> -	.long	_edata - stext			// SizeOfCode
> +	.long	_end - stext			// SizeOfCode
>  	.long	0				// SizeOfInitializedData
>  	.long	0				// SizeOfUninitializedData
>  	.long	efi_stub_entry - efi_head	// AddressOfEntryPoint
> @@ -169,7 +169,7 @@ extra_header_fields:
>  	.short	0				// MinorSubsystemVersion
>  	.long	0				// Win32VersionValue
>  
> -	.long	_edata - efi_head		// SizeOfImage
> +	.long	_end - efi_head			// SizeOfImage
>  
>  	// Everything before the kernel image is considered part of the header
>  	.long	stext - efi_head		// SizeOfHeaders
> @@ -216,7 +216,7 @@ section_table:
>  	.byte	0
>  	.byte	0
>  	.byte	0        		// end of 0 padding of section name
> -	.long	_edata - stext		// VirtualSize
> +	.long	_end - stext		// VirtualSize
>  	.long	stext - efi_head	// VirtualAddress
>  	.long	_edata - stext		// SizeOfRawData
>  	.long	stext - efi_head	// PointerToRawData
> -- 
> 1.8.3.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
