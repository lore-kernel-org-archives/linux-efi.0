From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Fix 3DNow optimization build failure in EFI
 stub
Date: Mon, 04 Aug 2014 16:06:01 -0700
Message-ID: <53E011D9.5040908@zytor.com>
References: <1407192735-26368-1-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1407192735-26368-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 08/04/2014 03:52 PM, Matt Fleming wrote:
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 801ed36c2e49..fcad2e15e92a 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1520,7 +1520,7 @@ config X86_SMAP
>  
>  config EFI
>  	bool "EFI runtime service support"
> -	depends on ACPI
> +	depends on ACPI && !X86_USE_3DNOW
>  	select UCS2_STRING
>  	select EFI_RUNTIME_WRAPPERS
>  	---help---
> 

As we discussed over IRC, should be EFI_STUB not EFI.  Once that is fixed:

Acked-by: H. Peter Anvin <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

... in case Ingo or Thomas grabs it before I do.

	-hpa
