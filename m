From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] rtc-efi: register rtc-efi device when EFI enabled
Date: Fri, 28 Dec 2012 17:07:37 -0800
Message-ID: <50DE4259.7090409@zytor.com>
References: <1356712001-12198-1-git-send-email-jlee@suse.com>  <E99CBA9F97C3D149AA6B19ED2E277C9B019215CC@BY2PRD0510MB365.namprd05.prod.outlook.com> <1356742803.6113.245.camel@linux-s257.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1356742803.6113.245.camel-ONCj+Eqt86TasUa73XJKwA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 12/28/2012 05:00 PM, joeyli wrote:
> =E6=96=BC =E4=BA=94=EF=BC=8C2012-12-28 =E6=96=BC 17:43 +0000=EF=BC=8C=
Matthew Garrett =E6=8F=90=E5=88=B0=EF=BC=9A
>> On Sat, 2012-12-29 at 00:26 +0800, Lee, Chun-Yi wrote:
>>> UEFI time services, GetTime(), SetTime(), GetWakeupTime(), SetWakeu=
pTime() are also
>>> supported by other non-IA64 architecutre with UEFI BIOS, e.g. x86.
>>>
>>> This patch changed RTC_DRV_EFI configuration to depend on EFI but n=
ot just IA64. It
>>> checks efi_enabled flag and efi-rtc driver should enabled.
>>
>> In theory, certainly - but do we still have machines that explode if=
 the
>> get_time call is made? We may also want to think about disabling the
>> legacy access to the RTC if the EFI calls are present.
>=20
> The legacy get_time access on my test machine is work fine, not thing
> explode. :-)
> Just we have a function want to expose the timezone information to
> userspace and also store it.
>=20

We should indeed save the timezone information if it is available --
either from the ACPI TAD or from the EFI RTC, or even via some
platform-dependent mechanism.  It is important, though, that that is
separate from the order of priority.

	-hpa
