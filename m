From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH][RFC v3] ACPI / PM: Fix poweroff issue on HW-full platforms without _S5
Date: Tue, 08 Mar 2016 02:53:46 +0100
Message-ID: <2414254.VhAiD01BTS@vostro.rjw.lan>
References: <1457319045-25434-1-git-send-email-yu.c.chen@intel.com> <CAJZ5v0iWjW_XJEsVBM1yyimxUQMDaWapQ_OrN45TeFXFySd0rw@mail.gmail.com> <36DF59CE26D8EE47B0655C516E9CE640286D329F@shsmsx102.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <36DF59CE26D8EE47B0655C516E9CE640286D329F@shsmsx102.ccr.corp.intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: "Chen, Yu C" <yu.c.chen@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "Zhang, Rui" <rui.zhang@intel.com>
List-Id: linux-efi@vger.kernel.org

On Monday, March 07, 2016 03:53:13 PM Chen, Yu C wrote:
> Hi Rafael,
> (resend for broken content)
> 
> > -----Original Message-----
> > From: rjwysocki@gmail.com [mailto:rjwysocki@gmail.com] On Behalf Of
> > Rafael J. Wysocki
> > Sent: Monday, March 07, 2016 9:19 PM
> > To: Chen, Yu C
> > Cc: ACPI Devel Maling List; x86@kernel.org; linux-efi@vger.kernel.org; Linux
> > Kernel Mailing List; linux-pm@vger.kernel.org; Rafael J. Wysocki; Len Brown;
> > Matt Fleming; Thomas Gleixner; Ingo Molnar; H. Peter Anvin; Zhang, Rui
> > Subject: Re: [PATCH][RFC v3] ACPI / PM: Fix poweroff issue on HW-full
> > platforms without _S5
> > 
> [cut]
> > >  bool efi_poweroff_required(void)
> > >  {
> > > -       return !!acpi_gbl_reduced_hardware;
> > > +       return acpi_gbl_reduced_hardware || (acpi_no_s5 &&
> > > + !pm_power_off);
> > 
> > What if CONFIG_ACPI is not set here?
> If CONFIG_ACPI is not set, this file would not 
> be compiled, because CONFIG_EFI depends on CONFIG_ACPI.

OK

So the next question will be if efi_poweroff_required() is guaranteed to run
after all of the other code that may register alternative power off handling.

Thanks,
Rafael

