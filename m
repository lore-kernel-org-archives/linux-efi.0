From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/3] rtc-efi: register rtc-efi device when EFI enabled
Date: Wed, 02 Jan 2013 10:45:51 +0800
Message-ID: <1357094751.6113.253.camel@linux-s257.site>
References: <1356712001-12198-1-git-send-email-jlee@suse.com>
	 <E99CBA9F97C3D149AA6B19ED2E277C9B019215CC@BY2PRD0510MB365.namprd05.prod.outlook.com>
	 <3fa7337e-6bbc-4462-9704-2d8ac20a9cf2@email.android.com>
	 <E99CBA9F97C3D149AA6B19ED2E277C9B019215FA@BY2PRD0510MB365.namprd05.prod.outlook.com>
	 <50DE03D8.9030902@zytor.com>
	 <E99CBA9F97C3D149AA6B19ED2E277C9B01921638@BY2PRD0510MB365.namprd05.prod.outlook.com>
	 <50DE2EED.9030608@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50DE2EED.9030608-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi hpa, =20

=E6=96=BC =E4=BA=94=EF=BC=8C2012-12-28 =E6=96=BC 15:44 -0800=EF=BC=8CH.=
 Peter Anvin =E6=8F=90=E5=88=B0=EF=BC=9A
> On 12/28/2012 12:49 PM, Matthew Garrett wrote:
> > On Fri, 2012-12-28 at 12:40 -0800, H. Peter Anvin wrote:
> >=20
> >>> I suspect that what we *should* do looks like:
> >>>
> >>> 1. If ACPI exports a Time and Alarm Device (ACPI000E) the use it;
> >>> 2. If ACPI exports an PC/AT device (PNP0B00/1/2) then use it(*);
> >>> 3. If we have an EFI RTC use it;
> >>> 4. Probe for a PC/AT RTC device.
> >=20
> > In terms of ordering, 3 should probably come before 2 - but that de=
pends
> > on us actually fixing the issues that are preventing some of these =
calls
> > from working. As far as wallclock time goes, EFI is going to be
> > available to us before we've parsed the DSDT to determine whether
> > there's any ACPI devices, so we'll almost certainly end up having t=
o use
> > it at at least some point during boot. Otherwise, agreed.
> >=20
>=20
> [Resending due to misconfigured tablet]
>=20
> 3 before 2 is exactly what is known to break on existing hardware (AS=
US).

I didn't find the EFI RTC problem on Asus from google.=20
Could you please share what's the situation on ASUS hardware?


Thanks a lot!
Joey Lee

>=20
> If anything, we should move to using the EFI RTC as a very last resor=
t,
> i.e. 3 after 4.  Ideally we should match Win8 behavior, but that woul=
d
> require someone mocking up different ACPI and EFI functions in a
> simulator and see how Win8 prioritizes things.
>=20
> 	-hpa
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" =
in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
