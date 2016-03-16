From: "Chen, Yu C" <yu.c.chen@intel.com>
Subject: RE: [PATCH][RFC,v4] ACPI / PM: Introduce efi poweroff for HW-full
 platforms without _S5
Date: Wed, 16 Mar 2016 05:59:29 +0000
Message-ID: <36DF59CE26D8EE47B0655C516E9CE640286D5713@shsmsx102.ccr.corp.intel.com>
References: <1457687133-3730-1-git-send-email-yu.c.chen@intel.com>
 <20160311155546.GJ15775@codeblueprint.co.uk>
 <36DF59CE26D8EE47B0655C516E9CE640286D442A@shsmsx102.ccr.corp.intel.com>
 <20160314200033.GG2619@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <20160314200033.GG2619@codeblueprint.co.uk>
Content-Language: en-US
Sender: linux-pm-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "Zhang, Rui" <rui.zhang@intel.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Salter <msalter@redhat.com>
List-Id: linux-efi@vger.kernel.org

Hi Matt,

> -----Original Message-----
> From: Matt Fleming [mailto:matt@codeblueprint.co.uk]
> Sent: Tuesday, March 15, 2016 4:01 AM
> To: Chen, Yu C
> Cc: linux-acpi@vger.kernel.org; linux-pm@vger.kernel.org; Rafael J. Wysocki;
> Len Brown; Thomas Gleixner; Ingo Molnar; H. Peter Anvin; Zhang, Rui; linux-
> efi@vger.kernel.org; x86@kernel.org; linux-kernel@vger.kernel.org; Ard
> Biesheuvel; Mark Salter
> Subject: Re: [PATCH][RFC,v4] ACPI / PM: Introduce efi poweroff for HW-full
> platforms without _S5
> 
> On Fri, 11 Mar, at 04:33:46PM, Chen, Yu C wrote:
> >
> > There is  a future Base-IA platform, we are planning to skip
> > implementing the SLP_TYP register and the S5 object.  (already there
> > will be no S3 and no S4)
> 
> Cool. This is really valuable information that should go into the commit
> message.
> 
> Because if this is the rationale for the change, I don't see why we'd need to
> provide the default stuff. Instead we should just enforce EFI reboot, and
> only add the pm_poweroff_default hook if there is an explicit user in the
> future, IMO.

Do you mean the patch v3 make sense
https://patchwork.kernel.org/patch/8514751/
and we should use efi power off as our first choice, if there is no _S5  available(no acpi_power_off),
even there is a customized  poweroff(driver provided, eg)? 

Meanwhile, the legacy platforms will not be affected because
there is no path to overwrite pm_power_off to efi power off.

thanks,
yu
