From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [RFT][PATCH] ACPI / init: Run acpi_early_init() before
 efi_enter_virtual_mode() (was: Re: [RFC PATCH 00/14] Support timezone of
 ACPI TAD and EFI TIME)
Date: Sun, 12 Jan 2014 10:06:27 +0100
Message-ID: <20140112090627.GB3668@pd.tnic>
References: <1387439053-8711-1-git-send-email-jlee@suse.com>
 <3476450.BMEcId2Lgj@vostro.rjw.lan>
 <20131221122148.GB29501@console-pimps.org>
 <2530951.HFPX8MI38t@vostro.rjw.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2530951.HFPX8MI38t-sKB8Sp2ER+y1GS7QM15AGw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Elliott-VXdhtT5mjnY@public.gmane.org, samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, werner-IBi9RG/b67k@public.gmane.org, trenn-l3A5Bk7waGM@public.gmane.org, JBeulich-IBi9RG/b67k@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, Jan 12, 2014 at 01:30:23AM +0100, Rafael J. Wysocki wrote:
> I don't see any adverse effects of the patch below on a couple of my test
> boxes, but (a) they are Intel-based and (b) they are non-EFI, so it would be
> good to give it a go on as many machines as reasonably possible.
> 
> Thanks,
> Rafael
> 
> ---
> From: Rafael J. Wysocki <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Subject: ACPI / init: Run acpi_early_init() before efi_enter_virtual_mode()
> 
> According to Matt Fleming, if acpi_early_init() was executed befpre
> efi_enter_virtual_mode(), the EFI initialization could benefit from
> it, so make that happen.
> 
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  init/main.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-pm/init/main.c
> ===================================================================
> --- linux-pm.orig/init/main.c
> +++ linux-pm/init/main.c
> @@ -615,6 +615,7 @@ asmlinkage void __init start_kernel(void
>  	calibrate_delay();
>  	pidmap_init();
>  	anon_vma_init();
> +	acpi_early_init();
>  #ifdef CONFIG_X86
>  	if (efi_enabled(EFI_RUNTIME_SERVICES))
>  		efi_enter_virtual_mode();
> @@ -641,7 +642,6 @@ asmlinkage void __init start_kernel(void
>  
>  	check_bugs();
>  
> -	acpi_early_init(); /* before LAPIC and SMP init */
>  	sfi_init_late();
>  
>  	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
>

Looks good both on kvm+OVMF and on my Dell EFI box.

Tested-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>

Toshi has a big EFI box though - if he could run it too, that would be
great :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
