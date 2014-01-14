From: Toshi Kani <toshi.kani@hp.com>
Subject: Re: [RFT][PATCH] ACPI / init: Run acpi_early_init() before
 efi_enter_virtual_mode()
Date: Tue, 14 Jan 2014 13:32:27 -0700
Message-ID: <1389731547.1792.296.camel@misato.fc.hp.com>
References: <1387439053-8711-1-git-send-email-jlee@suse.com>
		 <3476450.BMEcId2Lgj@vostro.rjw.lan>
		 <20131221122148.GB29501@console-pimps.org>
		 <2530951.HFPX8MI38t@vostro.rjw.lan>
	 <1389672548.24105.252.camel@linux-s257.site> <52D57B54.7080509@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <52D57B54.7080509@zytor.com>
Sender: linux-acpi-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: joeyli <jlee@suse.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Matt Fleming <matt@console-pimps.org>, Alessandro Zummo <a.zummo@towertech.it>, Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com, samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>, werner@suse.com, trenn@suse.de, JBeulich@suse.com, linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com, x86@kernel.org, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, linux-acpi@vger.kernel.org, Borislav Petkov <bp@suse.de>
List-Id: linux-efi@vger.kernel.org

On Tue, 2014-01-14 at 10:00 -0800, H. Peter Anvin wrote:
> On 01/13/2014 08:09 PM, joeyli wrote:
> > 
> > This patch works to me on Acer Gateway Z5WT2 UEFI notebook and Intel
> > UEFI development board.
> > 
> > Does it possible move acpi_early_init() to before timekeeping_init()?
> > The position is also before efi_enter_virtual_mode() and that will be
> > useful for parsing ACPI TAD to set system clock:
> > 
> > diff --git a/init/main.c b/init/main.c
> > index febc511..b6d93c8 100644
> > --- a/init/main.c
> > +++ b/init/main.c
> > @@ -565,6 +565,7 @@ asmlinkage void __init start_kernel(void)
> >         init_timers();
> >         hrtimers_init();
> >         softirq_init();
> > +       acpi_early_init();
> >         timekeeping_init();
> >         time_init();
> >         sched_clock_postinit();
> > @@ -641,7 +642,6 @@ asmlinkage void __init start_kernel(void)
> >  
> >         check_bugs();
> >  
> > -       acpi_early_init(); /* before LAPIC and SMP init */
> >         sfi_init_late();
> >  
> >         if (efi_enabled(EFI_RUNTIME_SERVICES)) {
> > 
> 
> Hi Toshi,
> 
> Could you try this variant, too?  If this works as well then we end up
> solving two problems in one patch...

Hi Peter,

Yes, this version works fine as well.

Tested-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi

