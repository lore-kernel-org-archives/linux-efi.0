From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2 13/15] arm64: add EFI runtime services
Date: Tue, 18 Mar 2014 17:36:20 +0000
Message-ID: <20140318173616.GB20497@arm.com>
References: <1394750828-16351-1-git-send-email-leif.lindholm@linaro.org>
 <1394750828-16351-14-git-send-email-leif.lindholm@linaro.org>
 <20140318123418.GH13200@arm.com>
 <1395152209.2967.3.camel@deneb.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1395152209.2967.3.camel-PDpCo7skNiwAicBL8TP8PQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Mar 18, 2014 at 02:16:49PM +0000, Mark Salter wrote:
> On Tue, 2014-03-18 at 12:34 +0000, Catalin Marinas wrote:
> > On Thu, Mar 13, 2014 at 10:47:06PM +0000, Leif Lindholm wrote:
> > > --- /dev/null
> > > +++ b/arch/arm64/kernel/efi.c
> > [...]
> > > +/*
> > > + * Called from setup_arch with interrupts disabled.
> > > + */
> > > +void __init efi_enter_virtual_mode(void)
> > [...]
> > > --- a/init/main.c
> > > +++ b/init/main.c
> > > @@ -902,6 +902,10 @@ static noinline void __init kernel_init_freeable(void)
> > >         smp_prepare_cpus(setup_max_cpus);
> > > 
> > >         do_pre_smp_initcalls();
> > > +
> > > +       if (IS_ENABLED(CONFIG_ARM64) && efi_enabled(EFI_BOOT))
> > > +               efi_enter_virtual_mode();
> > 
> > The comment for the efi_enter_virtual_mode() function says "called from
> > setup_arch with interrupts disabled". None of these are true for the
> > call above (and I would really prefer an arch call than this arm64
> > conditional call in init/main.c.
> > 
> 
> Right, the call changed to later in boot but the comment didn't. Calling
> from setup_arch is too early. But an early_initcall would work and would
> get rid of the ugly CONFIG_ARM64 test.

I agree, early_initcall() is better.

-- 
Catalin
