From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/3] rtc-efi: register rtc-efi device when EFI enabled
Date: Wed, 09 Jan 2013 14:23:11 +0800
Message-ID: <1357712591.6113.389.camel@linux-s257.site>
References: <1356712001-12198-1-git-send-email-jlee@suse.com>
	 <E99CBA9F97C3D149AA6B19ED2E277C9B019215CC@BY2PRD0510MB365.namprd05.prod.outlook.com>
	 <1356742803.6113.245.camel@linux-s257.site>  <50DE4259.7090409@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50DE4259.7090409-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

=E6=96=BC =E4=BA=94=EF=BC=8C2012-12-28 =E6=96=BC 17:07 -0800=EF=BC=8CH.=
 Peter Anvin =E6=8F=90=E5=88=B0=EF=BC=9A
> On 12/28/2012 05:00 PM, joeyli wrote:
> > =E6=96=BC =E4=BA=94=EF=BC=8C2012-12-28 =E6=96=BC 17:43 +0000=EF=BC=8C=
Matthew Garrett =E6=8F=90=E5=88=B0=EF=BC=9A
> >> On Sat, 2012-12-29 at 00:26 +0800, Lee, Chun-Yi wrote:
> >>> UEFI time services, GetTime(), SetTime(), GetWakeupTime(), SetWak=
eupTime() are also
> >>> supported by other non-IA64 architecutre with UEFI BIOS, e.g. x86=
=2E
> >>>
> >>> This patch changed RTC_DRV_EFI configuration to depend on EFI but=
 not just IA64. It
> >>> checks efi_enabled flag and efi-rtc driver should enabled.
> >>
> >> In theory, certainly - but do we still have machines that explode =
if the
> >> get_time call is made? We may also want to think about disabling t=
he
> >> legacy access to the RTC if the EFI calls are present.
> >=20
> > The legacy get_time access on my test machine is work fine, not thi=
ng
> > explode. :-)
> > Just we have a function want to expose the timezone information to
> > userspace and also store it.
> >=20
>=20
> We should indeed save the timezone information if it is available --
> either from the ACPI TAD or from the EFI RTC, or even via some
> platform-dependent mechanism.  It is important, though, that that is
> separate from the order of priority.
>=20
> 	-hpa
>=20

I found Windows 8 doesn't aware/maintain the Timezone and Daylight
fields in EFI_TIME struct.

I got a Acer UEFI notebook and I keep the Windows 8 hard drive
(/dev/sda) but install Linux to another hard drive (/dev/sdb).=20

On Linux, I applied my rtc-efi patches for allow user space feed
Timezone and store it to BIOS through SetTime(). I wrote a simple user
space program to set Timezone and Daylight fields, after set those
fields I reboot to Windows 8 and use DateTime setting GUI to look at th=
e
change. Looks Windows doesn't aware the change, it just assume the time
in DateTime filed is local time, but didn't show the Timezone that was
set by me on Linux to GUI.

Then, I select another Timezone(country) through Windows 8 GUI, and
reboot to Linux. I read the Timezone and Daylight by program but didn't
see the Timezone and Daylight changed by Windows 8, the value is still
the same with my latest time setting by Linux program. Windows 8 change=
d
DayTime fields but didn't maintain Timezone and Daylight.

I only have this machine with preloaded Windows 8 for verify the
behavior, not sure it's normally or not. If Windows 8 ignores Timezone
and Daylight fields in UEFI BIOS, then I think it's lower down the
necessary for we maintain Timezone and Daylight in UEFI BIOS.=20

We still can store Timezone and Daylight value to UEFI, but will have n=
o
any interactive with Windows 8.

Appreciate for any suggestions.


Thanks a lot!
Joey Lee
