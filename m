From: "Chen, Yu C" <yu.c.chen@intel.com>
Subject: RE: [PATCH][RFC] ACPI / PM: Fix poweroff issue on HW-full platforms
 without _S5
Date: Fri, 4 Mar 2016 17:02:30 +0000
Message-ID: <36DF59CE26D8EE47B0655C516E9CE640286D2880@shsmsx102.ccr.corp.intel.com>
References: <1456925357-2899-1-git-send-email-yu.c.chen@intel.com>
 <20160304133306.GB2715@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20160304133306.GB2715@codeblueprint.co.uk>
Content-Language: en-US
Sender: linux-acpi-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Zhang, Rui" <rui.zhang@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>, Rafael Wysocki <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
List-Id: linux-efi@vger.kernel.org

Hi  Matt,

> -----Original Message-----
> From: linux-pm-owner@vger.kernel.org [mailto:linux-pm-
> owner@vger.kernel.org] On Behalf Of Matt Fleming
> Sent: Friday, March 04, 2016 9:33 PM
> To: Chen, Yu C
> Cc: linux-acpi@vger.kernel.org; linux-efi@vger.kernel.org; linux-
> pm@vger.kernel.org; rjw@sisk.pl; lenb@kernel.org; tglx@linutronix.de;
> x86@kernel.org; Zhang, Rui; Zheng, Lv
> Subject: Re: [PATCH][RFC] ACPI / PM: Fix poweroff issue on HW-full
> platforms without _S5
> 
> On Wed, 02 Mar, at 09:29:17PM, Chen Yu wrote:
> > The problem is Linux registers pm_power_off = efi_power_off only if we
> > are in hardware reduced mode. Actually, what we also want is to do
> > this when ACPI S5 is simply not supported.
> > That should handle both the HW reduced mode, and the HW-full mode
> > where the DSDT fails to supply an _S5 object.
> >
> > This patch fixes this issue by introducing a new flag acpi_no_s5 which
> > indicates the non-existence of _S5. The initial state of acpi_no_s5 is
> > false and probed in acpi_sleep_init, then we'll later see the updated
> > value in efi_poweroff_required, according to which we can set
> > pm_power_off to efi_power_off in efi_shutdown_init.
> >
> > Suggested-by: Len Brown <len.brown@intel.com>
> > Signed-off-by: Chen Yu <yu.c.chen@intel.com>
> > ---
> >  arch/x86/platform/efi/quirks.c | 3 ++-
> >  drivers/acpi/sleep.c           | 2 ++
> >  include/acpi/acpixf.h          | 6 ++++++
> >  3 files changed, 10 insertions(+), 1 deletion(-)
> 
> Are there legacy platforms without _S5 where we currently handle reboot
> via some other means that are going to break if we attempt an EFI reboot?
> 
> I ask because historically performing an EFI reboot has been all kinds of buggy
> on x86.
I made a double check and  yes there are other components would like to
register their customized pm_power_off if _S5 is not available.
So if EFI reboot is not stable, current code may  not be robust enough .
Hum, how about this one?
(assigned to efi reboot only when there is no other components registered pm_power_off)
 return  acpi_gbl_reduced_hardware ||
	(acpi_no_s5 && ! pm_power_off);
> 
> Also, is this what Windows does if _S5 is absent?
I'm not sure, Windows might also leverage other drivers to achieve a poweroff. 

yu

