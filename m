From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] efi: Request desired alignment via the PE/COFF headers
Date: Fri, 11 Jul 2014 17:31:24 -0700
Message-ID: <53C081DC.5080605@zytor.com>
References: <1404945890-10754-1-git-send-email-mbrown@fensystems.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404945890-10754-1-git-send-email-mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 07/09/2014 03:44 PM, Michael Brown wrote:
> Signed-off-by: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
> ---
>  arch/x86/boot/header.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
> index 7a6d43a..16ef025 100644
> --- a/arch/x86/boot/header.S
> +++ b/arch/x86/boot/header.S
> @@ -154,7 +154,7 @@ extra_header_fields:
>  #else
>  	.quad	0				# ImageBase
>  #endif
> -	.long	0x20				# SectionAlignment
> +	.long	CONFIG_PHYSICAL_ALIGN		# SectionAlignment
>  	.long	0x20				# FileAlignment
>  	.word	0				# MajorOperatingSystemVersion
>  	.word	0				# MinorOperatingSystemVersion
> 

Are large alignments (16 MiB!) actually allowed in PE/COFF?

	-hpa
