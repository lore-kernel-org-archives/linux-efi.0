From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] arm64: support reboot and power off via EFI runtime
Date: Wed, 18 Jun 2014 10:41:47 -0400
Message-ID: <1403102507.32688.42.camel@deneb.redhat.com>
References: <1403023514-1352-1-git-send-email-msalter@redhat.com>
	 <CAL_JsqJUMMRwUn+PUiFweDOywgLCbKiWfDTLDSfJqE9oTV5gYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL_JsqJUMMRwUn+PUiFweDOywgLCbKiWfDTLDSfJqE9oTV5gYw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 2014-06-18 at 09:09 -0500, Rob Herring wrote:
> On Tue, Jun 17, 2014 at 11:45 AM, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > Add handlers for arm_pm_resestart and pm_power_off which use EFI
> 
> typo.
> 
> > runtime services ResetSystem call to perform the functions. These
> > handlers are only installed if no handler currently exists. This
> > allows PSCI to take priority over EFI for these functions.
> >
> > Signed-off-by: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  arch/arm64/kernel/efi.c | 40 ++++++++++++++++++++++++++++++++++++++++
> 
> Where's the arm32 version? Surely this could be shared with all
> arches. pm_power_off is at least architecturally independent. We
> should do the same for restart/reboot. I'm not saying do that now, but
> at least put it in the right place for that to happen.
> 
> Rob

Good point. So the right place would be drivers/firmware/efi I think.
Add a CONFIG_EFI_RESET with default off. I suppose we could also
go ahead and s/arm_pm_restart/pm_restart/ kernel-wide or have an
ifdef in the code (or depends on ARM64 || ARM in Kconfig) until we
do so.

[Matt Fleming CC'd]

> 
> >  1 file changed, 40 insertions(+)
> >
> > diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> > index 14db1f6..e8c0476 100644
> > --- a/arch/arm64/kernel/efi.c
> > +++ b/arch/arm64/kernel/efi.c
> > @@ -19,11 +19,14 @@
> >  #include <linux/of_fdt.h>
> >  #include <linux/sched.h>
> >  #include <linux/slab.h>
> > +#include <linux/reboot.h>
> > +#include <linux/pm.h>
> >
> >  #include <asm/cacheflush.h>
> >  #include <asm/efi.h>
> >  #include <asm/tlbflush.h>
> >  #include <asm/mmu_context.h>
> > +#include <asm/system_misc.h>
> >
> >  struct efi_memory_map memmap;
> >
> > @@ -467,3 +470,40 @@ static int __init arm64_enter_virtual_mode(void)
> >         return 0;
> >  }
> >  early_initcall(arm64_enter_virtual_mode);
> > +
> > +static void efi_restart(enum reboot_mode reboot_mode, const char *cmd)
> > +{
> > +       int efi_mode;
> > +
> > +       switch (reboot_mode) {
> > +       case REBOOT_WARM:
> > +       case REBOOT_SOFT:
> > +               efi_mode = EFI_RESET_WARM;
> > +               break;
> > +       default:
> > +               efi_mode = EFI_RESET_COLD;
> > +               break;
> > +       }
> > +       efi.reset_system(efi_mode, 0, 0, NULL);
> > +}
> > +
> > +static void efi_power_off(void)
> > +{
> > +       efi.reset_system(EFI_RESET_SHUTDOWN, 0, 0, NULL);
> > +}
> > +
> > +static int __init setup_efi_reset(void)
> > +{
> > +       if (efi_enabled(EFI_RUNTIME_SERVICES)) {
> > +               /*
> > +                * If something (psci, etc) hasn't already registered
> > +                * a handler, use EFI.
> > +                */
> > +               if (arm_pm_restart == NULL)
> > +                       arm_pm_restart = efi_restart;
> > +               if (pm_power_off == NULL)
> > +                       pm_power_off = efi_power_off;
> > +       }
> > +       return 0;
> > +}
> > +pure_initcall(setup_efi_reset);
> > --
> > 1.9.0
> >
> >
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
