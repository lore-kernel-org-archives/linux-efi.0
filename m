From: joeyli <jlee@suse.com>
Subject: Re: [RFC PATCH 06/14] rtc-efi: register rtc-efi device when EFI
 enabled
Date: Sat, 21 Dec 2013 23:34:08 +0800
Message-ID: <1387640048.3539.5760.camel@linux-s257.site>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
	 <1387439515-8926-7-git-send-email-jlee@suse.com>
	 <20131219140918.GF3145@console-pimps.org>
	 <1387513491.3539.4345.camel@linux-s257.site> <52B3C7F8.3040901@zytor.com>
	 <20131220103755.GA14784@pd.tnic> <1387552463.17961.2.camel@x230>
	 <52B4B0ED.7030600@zytor.com> <1387589042.3539.4901.camel@linux-s257.site>
	 <52B4F421.2000403@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <52B4F421.2000403@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, "bp@alien8.de" <bp@alien8.de>, "samer.el-haj-mahmoud@hp.com" <samer.el-haj-mahmoud@hp.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "a.zummo@towertech.it" <a.zummo@towertech.it>, "Elliott@hp.com" <Elliott@hp.com>, "werner@suse.com" <werner@suse.com>, "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>, "x86@kernel.org" <x86@kernel.org>, "rjw@rjwysocki.net" <rjw@rjwysocki.net>, "mingo@redhat.com" <mingo@redhat.com>, "oneukum@suse.de" <oneukum@suse.de>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "trenn@suse.de" <trenn@suse.de>, "matt.fleming@intel.com" <matt.fleming@intel.com>, "JBeulich@suse.com" <JBeulich@suse.com>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "matt@console-pimps.org" <matt@console-pimps.org>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=BA=94=EF=BC=8C2013-12-20 =E6=96=BC 17:51 -0800=EF=BC=8CH.=
 Peter Anvin =E6=8F=90=E5=88=B0=EF=BC=9A
> On 12/20/2013 05:24 PM, joeyli wrote:
> > =E6=96=BC =E4=BA=94=EF=BC=8C2013-12-20 =E6=96=BC 13:04 -0800=EF=BC=8C=
H. Peter Anvin =E6=8F=90=E5=88=B0=EF=BC=9A
> >>
> >> Actually, it doesn't have to reprogram the clock ... it just needs=
 to
> >> know if another OS has already done so.  All Linux needs to do is =
to be
> >> able to derive UTC from whatever the RTC is set to and to be able =
to
> >> keep it consistent.
> >>
> >=20
> > It's dependent on a right boot initial priority of distribution.
>=20
> -ENOPARSE
>=20
> > Here have a discussion of adjusting system clock by TZ (from ACPI o=
r
> > UEFI):
> > Discussion on BIOS/CMOS/UEFI clock in local time
> > 	http://www.spinics.net/lists/util-linux-ng/msg07639.html
> >=20
> > and,
> > from Ted Ts'o in the mail thread
> >      https://lkml.org/lkml/2008/1/8/195
> >=20
> > If kernel use the TZ field from ACPI TAD or EFI to adjust system
> > clock when booting, then it can avoid buggy distributions adjust
> > system clock AFTER e2fsck is run.
> >=20
> > Using ACPI TAD should after DSDT parsing in subsystem initial stage=
,
> > so I choice EFI time services before we can move DSDT parser to
> > start_kernel().
> >=20
>=20
> Yes, of course.  That is irrelevant to needing to reprogram the clock=
,
> though.
>=20
> My argument is very simple: if we have to rely on EFI, we can get the
> offset in the boot stub before ExitBootServices(), and then simply ne=
ver
> change it.  That way we still pick up if another operating system has
> changed it, and it will still reflect the proper UTC time.
>=20
> 	-hpa
>=20

OK, I will add this part to next version for the UEFI system doesn't
have ACPI TAD.


Thanks for your suggestion!
Joey Lee
