From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] Map in physical addresses in efi_map_region_fixed
Date: Mon, 15 Aug 2016 13:42:58 +0100
Message-ID: <20160815124258.GF30909@codeblueprint.co.uk>
References: <1470441575-96065-1-git-send-email-athorlton@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1470441575-96065-1-git-send-email-athorlton-sJ/iWh9BUns@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, Mike Travis <travis-sJ/iWh9BUns@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(Cc'ing Boris and Dave)

On Fri, 05 Aug, at 06:59:35PM, Alex Thorlton wrote:
> This is a simple change to add in the physical mappings as well as the
> virtual mappings in efi_map_region_fixed.  The motivation here is to
> get access to EFI runtime code that is only available via the 1:1
> mappings on a kexec'd kernel.
> 
> The added call is essentially the kexec analog of the first __map_region
> that Boris put in efi_map_region in commit d2f7cbe7b26a ("x86/efi:
> Runtime services virtual mapping").
> 
> Signed-off-by: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
> Cc: Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>
> Cc: Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>
> Cc: Mike Travis <travis-sJ/iWh9BUns@public.gmane.org>
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  arch/x86/platform/efi/efi_64.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> index 459bcbb..b206126 100644
> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -363,6 +363,7 @@ void __init efi_map_region(efi_memory_desc_t *md)
>   */
>  void __init efi_map_region_fixed(efi_memory_desc_t *md)
>  {
> +	__map_region(md, md->phys_addr);
>  	__map_region(md, md->virt_addr);
>  }
>  

This looks fine to me. I'm going to run it through my tests and unless
anyone complains, apply it for v4.9.
