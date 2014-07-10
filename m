From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH] efi: Request desired alignment via the PE/COFF headers
Date: Thu, 10 Jul 2014 13:16:11 +0100
Message-ID: <20140710121611.GF15932@console-pimps.org>
References: <1404945890-10754-1-git-send-email-mbrown@fensystems.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1404945890-10754-1-git-send-email-mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Brown <mbrown-OViyBiuKJBuK421+ScFKDQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 09 Jul, at 11:44:50PM, Michael Brown wrote:
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

Could you expand on the commit log? It's not clear why this is
desirable, especially for anyone that hasn't read the previous thread on
the new EFI stub .bss header.

That actual change looks fine though.

-- 
Matt Fleming, Intel Open Source Technology Center
