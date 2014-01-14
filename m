From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFT][PATCH] ACPI / init: Run acpi_early_init() before efi_enter_virtual_mode()
Date: Tue, 14 Jan 2014 10:00:52 -0800
Message-ID: <52D57B54.7080509@zytor.com>
References: <1387439053-8711-1-git-send-email-jlee@suse.com>	 <3476450.BMEcId2Lgj@vostro.rjw.lan>	 <20131221122148.GB29501@console-pimps.org>	 <2530951.HFPX8MI38t@vostro.rjw.lan> <1389672548.24105.252.camel@linux-s257.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389672548.24105.252.camel-ONCj+Eqt86TasUa73XJKwA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joeyli <jlee-IBi9RG/b67k@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Elliott-VXdhtT5mjnY@public.gmane.org, samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, werner-IBi9RG/b67k@public.gmane.org, trenn-l3A5Bk7waGM@public.gmane.org, JBeulich-IBi9RG/b67k@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 01/13/2014 08:09 PM, joeyli wrote:
> 
> This patch works to me on Acer Gateway Z5WT2 UEFI notebook and Intel
> UEFI development board.
> 
> Does it possible move acpi_early_init() to before timekeeping_init()?
> The position is also before efi_enter_virtual_mode() and that will be
> useful for parsing ACPI TAD to set system clock:
> 
> diff --git a/init/main.c b/init/main.c
> index febc511..b6d93c8 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -565,6 +565,7 @@ asmlinkage void __init start_kernel(void)
>         init_timers();
>         hrtimers_init();
>         softirq_init();
> +       acpi_early_init();
>         timekeeping_init();
>         time_init();
>         sched_clock_postinit();
> @@ -641,7 +642,6 @@ asmlinkage void __init start_kernel(void)
>  
>         check_bugs();
>  
> -       acpi_early_init(); /* before LAPIC and SMP init */
>         sfi_init_late();
>  
>         if (efi_enabled(EFI_RUNTIME_SERVICES)) {
> 

Hi Toshi,

Could you try this variant, too?  If this works as well then we end up
solving two problems in one patch...

	-hpa
