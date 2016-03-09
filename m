From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH][RFC v3] ACPI / PM: Fix poweroff issue on HW-full
 platforms without _S5
Date: Wed, 9 Mar 2016 15:34:36 +0000
Message-ID: <20160309153436.GB15775@codeblueprint.co.uk>
References: <1457319045-25434-1-git-send-email-yu.c.chen@intel.com>
 <CAJZ5v0iWjW_XJEsVBM1yyimxUQMDaWapQ_OrN45TeFXFySd0rw@mail.gmail.com>
 <36DF59CE26D8EE47B0655C516E9CE640286D329F@shsmsx102.ccr.corp.intel.com>
 <2414254.VhAiD01BTS@vostro.rjw.lan>
 <36DF59CE26D8EE47B0655C516E9CE640286D370A@shsmsx102.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <36DF59CE26D8EE47B0655C516E9CE640286D370A@shsmsx102.ccr.corp.intel.com>
Sender: linux-pm-owner@vger.kernel.org
To: "Chen, Yu C" <yu.c.chen@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Rafael J. Wysocki" <rafael@kernel.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "Zhang, Rui" <rui.zhang@intel.com>
List-Id: linux-efi@vger.kernel.org

On Tue, 08 Mar, at 04:25:30PM, Chen, Yu C wrote:
> Hum. unfortunately it is not guaranteed to run after all of the other code,
> because other components who register pm_power_off may be built as modules, and
> we can not predict/control the sequence registration.   So this patch may
> break the EFI platforms who use non-efi poweroff due to unstable EFI service
> ,  not sure if there are any released-products of this kind.
 
Certainly the majority of x86 client machines do not use EFI power
off, because it hardly ever functions correctly.

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

Be wary of adding all these control knobs. People just want their
machines to reboot properly without having to mess with boot
parameters.

Let's go back to the start. What prompted this patch? Do Intel have
(or are planning) machines that do not have _S5 and are expected to
use EFI to reset the system? Or is this some new configuration
discussed in the ACPI spec that Linux needs to be support? 

Can we remove the ambiguity and options to force EFI reset if _S5 is
missing? Afterall, that's why the function is called
efi_poweroff_*required*.
