From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 5/5] init: efi: arm: enable (U)EFI runtime services on
 arm
Date: Mon, 13 Jan 2014 18:57:15 +0000
Message-ID: <20140113185714.GE30907@bivouac.eciton.net>
References: <1389445524-30623-1-git-send-email-leif.lindholm@linaro.org>
 <1389445524-30623-6-git-send-email-leif.lindholm@linaro.org>
 <201401131929.07236.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <201401131929.07236.arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, Jan 13, 2014 at 07:29:06PM +0100, Arnd Bergmann wrote:
> On Saturday 11 January 2014, Leif Lindholm wrote:
> > diff --git a/init/main.c b/init/main.c
> > index febc511..1331829 100644
> > --- a/init/main.c
> > +++ b/init/main.c
> > @@ -905,6 +905,10 @@ static noinline void __init kernel_init_freeable(void)
> >         smp_prepare_cpus(setup_max_cpus);
> >  
> >         do_pre_smp_initcalls();
> > +
> > +       if (IS_ENABLED(CONFIG_ARM) && efi_enabled(EFI_BOOT))
> > +               efi_enter_virtual_mode();
> 
> What is the dependency on CONFIG_ARM here? Wouldn't most other
> architectures need the same?

Most 64-bit architectures could get away from it.
x86 does it where its particular init environment forces it to.

For arm, the strict ordering requirement is for efi_enter_virtual_mode
to be called after init_static_idmap.

If ordering between early_initcalls was possible in a sane way, I could
do that instead, but I don't think a patch that swapped order of kernel/
and mm/ in arch/arm/Makefile would be accepted :)

> I'd rather not see this turn into
> a long list of CONFIG_$(ARCH) checks if other architectures
> enable it in the same place.
> 
> I also wonder why the three architectures implementing it all
> call this from wildly different places during init/main.c, namely
> (very early) setup_arch() on ia64,

Likewise arm64.

> (relatively early) start_kernel
> on x86 and (relatively late) kernel_init_freeable on arm.

As I said - the pure 64-bit archs have less of an issue, since they
can have their kernel somewhere that won't clash with the 1:1 mapping
of RAM required by UEFI SetVirtualAddressMap.

> In general, I'd be happy with adding this as late in the startup
> code as possible, but it may be better to use the same place as
> x86 in order to avoid surprises with unexpected dependencies.

I _really_ don't want to call SetVirtualAddressMap after smp_init.

> One such dependency that may cause problems is the fact that
> we (try to) call efi_late_init() before efi_enter_virtual_mode()
> now.

Well, efi_late_init() is an inline {} on everything !x86.

/
    Leif
