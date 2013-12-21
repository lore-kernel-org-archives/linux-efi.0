From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH 06/14] rtc-efi: register rtc-efi device when EFI
 enabled
Date: Sat, 21 Dec 2013 09:24:02 +0800
Message-ID: <1387589042.3539.4901.camel@linux-s257.site>
References: <1387439515-8926-1-git-send-email-jlee@suse.com>
	 <1387439515-8926-7-git-send-email-jlee@suse.com>
	 <20131219140918.GF3145@console-pimps.org>
	 <1387513491.3539.4345.camel@linux-s257.site> <52B3C7F8.3040901@zytor.com>
	 <20131220103755.GA14784@pd.tnic> <1387552463.17961.2.camel@x230>
	 <52B4B0ED.7030600@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52B4B0ED.7030600-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, "bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org" <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org" <samer.el-haj-mahmoud-VXdhtT5mjnY@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org" <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, "Elliott-VXdhtT5mjnY@public.gmane.org" <Elliott-VXdhtT5mjnY@public.gmane.org>, "werner-IBi9RG/b67k@public.gmane.org" <werner-IBi9RG/b67k@public.gmane.org>, "rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "oneukum-l3A5Bk7waGM@public.gmane.org" <oneukum-l3A5Bk7waGM@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "trenn-l3A5Bk7waGM@public.gmane.org" <trenn-l3A5Bk7waGM@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "JBeulich-IBi9RG/b67k@public.gmane.org" <JBeulich-IBi9RG/b67k@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org" <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=BA=94=EF=BC=8C2013-12-20 =E6=96=BC 13:04 -0800=EF=BC=8CH.=
 Peter Anvin =E6=8F=90=E5=88=B0=EF=BC=9A
> On 12/20/2013 07:14 AM, Matthew Garrett wrote:
> > On Fri, 2013-12-20 at 11:37 +0100, Borislav Petkov wrote:
> >> On Thu, Dec 19, 2013 at 08:30:48PM -0800, H. Peter Anvin wrote:
> >>> On 12/19/2013 08:24 PM, joeyli wrote:
> >>>> I agreed, but userspace application should not be too often to a=
ccess
> >>>> RTC. Maybe only when system boot and set timezone.
> >>>
> >>> This is, quite frankly, an idiotic argument.
> >>
> >> TBH, I've been struggling with the question too - and it might eve=
n be a
> >> stupid question - but what is that absolute need to be able to get=
 the
> >> TZ in userspace? Why should I care?
> >>
> >> Can we get some use cases for stupid people like me please?
> >=20
> > Dual-boot environments will tend to have the RTC in local time, not=
 UTC.
> > That means that userspace has to reprogram the clock over daylight
> > savings changes, and to do that it must know whether another OS has
> > already done so.
> >=20
>=20
> Actually, it doesn't have to reprogram the clock ... it just needs to
> know if another OS has already done so.  All Linux needs to do is to =
be
> able to derive UTC from whatever the RTC is set to and to be able to
> keep it consistent.
>=20
> 	-hpa
>=20
>=20

It's dependent on a right boot initial priority of distribution.
Here have a discussion of adjusting system clock by TZ (from ACPI or
UEFI):
Discussion on BIOS/CMOS/UEFI clock in local time
	http://www.spinics.net/lists/util-linux-ng/msg07639.html

and,
from Ted Ts'o in the mail thread
     https://lkml.org/lkml/2008/1/8/195


If kernel use the TZ field from ACPI TAD or EFI to adjust system
clock when booting, then it can avoid buggy distributions adjust
system clock AFTER e2fsck is run.

Using ACPI TAD should after DSDT parsing in subsystem initial stage,
so I choice EFI time services before we can move DSDT parser to
start_kernel().


Thanks a lot!
Joey Lee
