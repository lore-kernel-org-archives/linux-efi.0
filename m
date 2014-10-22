From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 01/10] arm64/efi: efistub: jump to 'stext' directly, not
 through the header
Date: Wed, 22 Oct 2014 15:47:47 +0100
Message-ID: <20141022144747.GC4010@leverpostej>
References: <1413987713-30528-1-git-send-email-ard.biesheuvel@linaro.org>
 <1413987713-30528-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1413987713-30528-2-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "yi.li-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <yi.li-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Ard,

On Wed, Oct 22, 2014 at 03:21:44PM +0100, Ard Biesheuvel wrote:
> After the EFI stub has done its business, it jumps into the kernel by
> branching to offset #0 of the loaded Image, which is where it expects
> to find the header containing a 'branch to stext' instruction.
> 
> However, the UEFI spec 2.1.1 states the following regarding PE/COFF
> image loading:
> "A UEFI image is loaded into memory through the LoadImage() Boot
> Service. This service loads an image with a PE32+ format into memory.
> This PE32+ loader is required to load all sections of the PE32+ image
> into memory."
> 
> In other words, it is /not/ required to load parts of the image that are
> not covered by a PE/COFF section, so it may not have loaded the header
> at the expected offset, as it is not covered by any PE/COFF section.
> 
> So instead, jump to 'stext' directly, which is at the base of the
> PE/COFF .text section, by supplying a symbol 'stext_offset' to
> efi-entry.o which contains the relative offset of stext into the Image.
> Also replace other open coded calculations of the same value with a
> reference to 'stext_offset'
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Given the constraints you describe above, and prior discussions, this
looks sane to me:

Acked-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>

Mark.

> ---
> v3:
> - rebased onto 3.17+
> - added spec reference to commit message
> 
> v2:
> - drop :lo12: relocation against stext_offset in favor of using a literal
>   '=stext_offset' which is safer
> ---
>  arch/arm64/kernel/efi-entry.S |  3 ++-
>  arch/arm64/kernel/head.S      | 10 ++++++----
>  2 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm64/kernel/efi-entry.S b/arch/arm64/kernel/efi-entry.S
> index 619b1dd7bcde..a0016d3a17da 100644
> --- a/arch/arm64/kernel/efi-entry.S
> +++ b/arch/arm64/kernel/efi-entry.S
> @@ -61,7 +61,8 @@ ENTRY(efi_stub_entry)
>  	 */
>  	mov	x20, x0		// DTB address
>  	ldr	x0, [sp, #16]	// relocated _text address
> -	mov	x21, x0
> +	ldr	x21, =stext_offset
> +	add	x21, x0, x21
>  
>  	/*
>  	 * Flush dcache covering current runtime addresses
> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index 0a6e4f924df8..8c06c9d269d2 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -132,6 +132,8 @@ efi_head:
>  #endif
>  
>  #ifdef CONFIG_EFI
> +	.globl	stext_offset
> +	.set	stext_offset, stext - efi_head
>  	.align 3
>  pe_header:
>  	.ascii	"PE"
> @@ -155,7 +157,7 @@ optional_header:
>  	.long	0				// SizeOfInitializedData
>  	.long	0				// SizeOfUninitializedData
>  	.long	efi_stub_entry - efi_head	// AddressOfEntryPoint
> -	.long	stext - efi_head		// BaseOfCode
> +	.long	stext_offset			// BaseOfCode
>  
>  extra_header_fields:
>  	.quad	0				// ImageBase
> @@ -172,7 +174,7 @@ extra_header_fields:
>  	.long	_end - efi_head			// SizeOfImage
>  
>  	// Everything before the kernel image is considered part of the header
> -	.long	stext - efi_head		// SizeOfHeaders
> +	.long	stext_offset			// SizeOfHeaders
>  	.long	0				// CheckSum
>  	.short	0xa				// Subsystem (EFI application)
>  	.short	0				// DllCharacteristics
> @@ -217,9 +219,9 @@ section_table:
>  	.byte	0
>  	.byte	0        		// end of 0 padding of section name
>  	.long	_end - stext		// VirtualSize
> -	.long	stext - efi_head	// VirtualAddress
> +	.long	stext_offset		// VirtualAddress
>  	.long	_edata - stext		// SizeOfRawData
> -	.long	stext - efi_head	// PointerToRawData
> +	.long	stext_offset		// PointerToRawData
>  
>  	.long	0		// PointerToRelocations (0 for executables)
>  	.long	0		// PointerToLineNumbers (0 for executables)
> -- 
> 1.8.3.2
> 
> 
