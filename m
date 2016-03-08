From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH][RFC v3] ACPI / PM: Fix poweroff issue on HW-full platforms without _S5
Date: Tue, 08 Mar 2016 23:56:50 +0100
Message-ID: <1867318.3ivAYsjD7D@vostro.rjw.lan>
References: <1457319045-25434-1-git-send-email-yu.c.chen@intel.com> <2414254.VhAiD01BTS@vostro.rjw.lan> <36DF59CE26D8EE47B0655C516E9CE640286D370A@shsmsx102.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <36DF59CE26D8EE47B0655C516E9CE640286D370A@shsmsx102.ccr.corp.intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: "Chen, Yu C" <yu.c.chen@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "Zhang, Rui" <rui.zhang@intel.com>
List-Id: linux-efi@vger.kernel.org

On Tuesday, March 08, 2016 04:25:30 PM Chen, Yu C wrote:
> > -----Original Message-----
> > From: linux-pm-owner@vger.kernel.org [mailto:linux-pm-
> > owner@vger.kernel.org] On Behalf Of Rafael J. Wysocki
> > Sent: Tuesday, March 08, 2016 9:54 AM
> > To: Chen, Yu C
> > Cc: Rafael J. Wysocki; ACPI Devel Maling List; x86@kernel.org; linux-
> > efi@vger.kernel.org; Linux Kernel Mailing List; linux-pm@vger.kernel.org;
> > Len Brown; Matt Fleming; Thomas Gleixner; Ingo Molnar; H. Peter Anvin;
> > Zhang, Rui
> > Subject: Re: [PATCH][RFC v3] ACPI / PM: Fix poweroff issue on HW-full
> > platforms without _S5
> > 
> > On Monday, March 07, 2016 03:53:13 PM Chen, Yu C wrote:
> > > Hi Rafael,
> > > (resend for broken content)
> > >
> > > > -----Original Message-----
> > > > From: rjwysocki@gmail.com [mailto:rjwysocki@gmail.com] On Behalf Of
> > > > Rafael J. Wysocki
> > > > Sent: Monday, March 07, 2016 9:19 PM
> > > > To: Chen, Yu C
> > > > Cc: ACPI Devel Maling List; x86@kernel.org;
> > > > linux-efi@vger.kernel.org; Linux Kernel Mailing List;
> > > > linux-pm@vger.kernel.org; Rafael J. Wysocki; Len Brown; Matt
> > > > Fleming; Thomas Gleixner; Ingo Molnar; H. Peter Anvin; Zhang, Rui
> > > > Subject: Re: [PATCH][RFC v3] ACPI / PM: Fix poweroff issue on
> > > > HW-full platforms without _S5
> > > >
> > > [cut]
> > > > >  bool efi_poweroff_required(void)
> > > > >  {
> > > > > -       return !!acpi_gbl_reduced_hardware;
> > > > > +       return acpi_gbl_reduced_hardware || (acpi_no_s5 &&
> > > > > + !pm_power_off);
> > > >
> > > > What if CONFIG_ACPI is not set here?
> > > If CONFIG_ACPI is not set, this file would not be compiled, because
> > > CONFIG_EFI depends on CONFIG_ACPI.
> > 
> > OK
> > 
> > So the next question will be if efi_poweroff_required() is guaranteed to run
> > after all of the other code that may register alternative power off handling.
> Hum. unfortunately it is not guaranteed to run after all of the other code,
> because other components who register pm_power_off may be built as modules, and
> we can not predict/control the sequence registration.   So this patch may
> break the EFI platforms who use non-efi poweroff due to unstable EFI service
> ,  not sure if there are any released-products of this kind.
> 
> Currently I'm thinking of 3 possible solutions,  could you please give some advices on them:
> 
> 1. Introduce bootopt of 'poweroff=efi'
>      Set the pm_power_off to efi_power_off no matter whether there is _S5 or not
> 
> 2. Introduce /sys/power/poweroff
>     Allow the user to choose which  pm_power_off, for example:
>  
> # cat /sys/power/poweroff
> *acpi		acpi_power_off
> efi		efi_power_off	
> gpio		gpio_poweroff_do_poweroff
> user can echo string to enable which one.
> 
> And two APIs:
> register_power_off(char *name, power_off func)
> unregister_power_off(char *name)  
> 
> 
> 3. replace all the codes of  pm_power_off() with reliable_pm_power_off()
> 
> void reliable_pm_power_off(void)
> {
> 	if (!pm_power_off) {
> 		if (acpi_no_s5)
> 			pm_power_off = efi_power_off;
> 	/* Other conditions added in the future. */
> 	}
> 	pm_power_off();
> }

What about something like adding something like default_power_off that would
be used by pm_power_off if nothing else is available?

Thanks,
Rafael

