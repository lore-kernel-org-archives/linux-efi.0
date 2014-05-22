From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v4 4/5] arch/x86: Replace plain strings with constants
Date: Thu, 22 May 2014 08:56:17 +0100
Message-ID: <20140522075617.GQ4798@console-pimps.org>
References: <1400272904-31121-1-git-send-email-daniel.kiper@oracle.com>
 <1400272904-31121-5-git-send-email-daniel.kiper@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1400272904-31121-5-git-send-email-daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, eshelton-e+AXbWqSrlAAvxtiuMwx3w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, ian.campbell-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org, jbeulich-IBi9RG/b67k@public.gmane.org, jeremy-TSDbQ3PG+2Y@public.gmane.org, konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 16 May, at 10:41:43PM, Daniel Kiper wrote:
> Signed-off-by: Daniel Kiper <daniel.kiper-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/kernel/setup.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index f41f648..7a67f5d 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -924,11 +924,11 @@ void __init setup_arch(char **cmdline_p)
>  #endif
>  #ifdef CONFIG_EFI
>  	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
> -		     "EL32", 4)) {
> +				EFI32_LOADER_SIGNATURE, 4)) {
>  		set_bit(EFI_BOOT, &efi.flags);
>  		set_bit(EFI_DIRECT, &efi.flags);
>  	} else if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
> -		     "EL64", 4)) {
> +				EFI64_LOADER_SIGNATURE, 4)) {
>  		set_bit(EFI_BOOT, &efi.flags);
>  		set_bit(EFI_DIRECT, &efi.flags);
>  		set_bit(EFI_64BIT, &efi.flags);

Conceptually this change is a nice cleanup, but you've also changed the
indentation. Please don't do that, stick with the existing format.

-- 
Matt Fleming, Intel Open Source Technology Center
