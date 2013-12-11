From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] UEFI: Don't use UEFI time services on 32-bit
Date: Wed, 11 Dec 2013 08:20:57 +0800
Message-ID: <1386721257.3539.1717.camel@linux-s257.site>
References: <1385754283-2464-1-git-send-email-matthew.garrett@nebula.com>
	 <52994324.4000404@zytor.com> <52A79B9A.7080004@zytor.com>
	 <1386716246.26245.2.camel@x230> <52A7A1B0.7050903@zytor.com>
	 <1386717862.26245.5.camel@x230>  <52A7A915.1070701@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52A7A915.1070701-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=BA=8C=EF=BC=8C2013-12-10 =E6=96=BC 15:51 -0800=EF=BC=8CH.=
 Peter Anvin =E6=8F=90=E5=88=B0=EF=BC=9A
> On 12/10/2013 03:24 PM, Matthew Garrett wrote:
> >>
> >> TAD would also give us the timezone.  I'm not sure how you can
> >> realistically only use the time function during boot, however, unl=
ess
> >> you inherently assume it is coherent with the hardware RTC, since =
you
> >> wouldn't be able to set it.
> >=20
> > If we can verify that Windows actually uses TAD then I'd agree it's
> > preferable to EFI, but if we can't then I wouldn't be so sure. I'll=
 redo
> > my Windows instrumentation and figure out under which circumstances=
 it's
> > calling the time functions.
> >=20
>=20
> Well, *which version* of Windows is a big question here.  Keep in min=
d
> that the TAD was only introduced with ACPI 5 so it is quite a new
> feature.  I would really like to see it implemented in SeaBIOS and/or
> OVMF so we can test it out in Qemu.
>=20
> 	-hpa
>=20

Actually, I am working on the timezone support of ACPI TIME and EFI
TIME. My current implementation is using EFI time services to deal with
clock in RTC.

The ACPI TAD is a generic device that need parse DSDT for access it. Th=
e
DSDT parser is in subsystem initial stage. But in start_kernel, the
timekeeping_init() call wallclock functions to deal system clock with
RTC, it's too early for access ACPI TAD, so it still access CMOS
interface unless switch it to EFI services.

If we adapt to ACPI TAD, then how does system clock deal with RTC
through it when system boot?


Thanks
Joey Lee
