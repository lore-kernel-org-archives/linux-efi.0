From: joeyli <jlee@suse.com>
Subject: Re: [RFC PATCH 06/14] rtc-efi: register rtc-efi device when EFI
 enabled
Date: Fri, 20 Dec 2013 12:24:51 +0800
Message-ID: <1387513491.3539.4345.camel@linux-s257.site>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
	 <1387439515-8926-7-git-send-email-jlee@suse.com>
	 <20131219140918.GF3145@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20131219140918.GF3145@console-pimps.org>
Sender: linux-acpi-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Alessandro Zummo <a.zummo@towertech.it>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com, samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>, werner@suse.com, trenn@suse.de, JBeulich@suse.com, linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com, x86@kernel.org, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, linux-acpi@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E5=9B=9B=EF=BC=8C2013-12-19 =E6=96=BC 14:09 +0000=EF=BC=8CMa=
tt Fleming =E6=8F=90=E5=88=B0=EF=BC=9A
> On Thu, 19 Dec, at 03:51:47PM, Lee, Chun-Yi wrote:
> > UEFI time services, GetTime(), SetTime(), GetWakeupTime(), SetWakeu=
pTime() are also
> > supported by other non-IA64 architecutre with UEFI BIOS, e.g. x86.
> >=20
> > This patch changed RTC_DRV_EFI configuration to depend on EFI but n=
ot just IA64. It
> > checks efi_enabled flag and efi-rtc driver should enabled.
> >=20
> > Cc: Matt Fleming <matt.fleming@intel.com>
> > Cc: H. Peter Anvin <hpa@zytor.com>
> > Cc: Matthew Garrett <matthew.garrett@nebula.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: Jan Beulich <JBeulich@suse.com>
> > Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> > ---
> >  arch/x86/platform/efi/efi.c |   17 +++++++++++++++++
> >  drivers/rtc/Kconfig         |    2 +-
> >  2 files changed, 18 insertions(+), 1 deletions(-)
>=20
> This patch needs to be justified. Enabling the EFI runtime *Time
> functions just because they're available isn't good enough. We need t=
o
> know why this patch improves things, what use case does it solve?
>=20

The main purpose of enable efi-rtc driver is providing interface to
userspace access timezone field in EFI time services.

Currently have two BIOS interfaces provided the timezone field accessin=
g
ability, ACPI TAD and EFI. I hope can enable them on x86_64 machines.

> The general attitude has been that we want to invoke the runtime
> services less, not more, due to the huge variety of runtime
> implementation bugs.
>=20

I agreed, but userspace application should not be too often to access
RTC. Maybe only when system boot and set timezone.


Thanks a lot!
Joey Lee

--
To unsubscribe from this list: send the line "unsubscribe linux-acpi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
