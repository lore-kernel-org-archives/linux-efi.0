From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] rtc-efi: register rtc-efi device when EFI enabled
Date: Fri, 28 Dec 2012 15:44:45 -0800
Message-ID: <50DE2EED.9030608@zytor.com>
References: <1356712001-12198-1-git-send-email-jlee@suse.com>   <E99CBA9F97C3D149AA6B19ED2E277C9B019215CC@BY2PRD0510MB365.namprd05.prod.outlook.com>   <3fa7337e-6bbc-4462-9704-2d8ac20a9cf2@email.android.com>  <E99CBA9F97C3D149AA6B19ED2E277C9B019215FA@BY2PRD0510MB365.namprd05.prod.outlook.com>  <50DE03D8.9030902@zytor.com> <E99CBA9F97C3D149AA6B19ED2E277C9B01921638@BY2PRD0510MB365.namprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E99CBA9F97C3D149AA6B19ED2E277C9B01921638-kSjp6dTd0Hr1oIOzUjSfqB1/qY2kGW66nBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 12/28/2012 12:49 PM, Matthew Garrett wrote:
> On Fri, 2012-12-28 at 12:40 -0800, H. Peter Anvin wrote:
> 
>>> I suspect that what we *should* do looks like:
>>>
>>> 1. If ACPI exports a Time and Alarm Device (ACPI000E) the use it;
>>> 2. If ACPI exports an PC/AT device (PNP0B00/1/2) then use it(*);
>>> 3. If we have an EFI RTC use it;
>>> 4. Probe for a PC/AT RTC device.
> 
> In terms of ordering, 3 should probably come before 2 - but that depends
> on us actually fixing the issues that are preventing some of these calls
> from working. As far as wallclock time goes, EFI is going to be
> available to us before we've parsed the DSDT to determine whether
> there's any ACPI devices, so we'll almost certainly end up having to use
> it at at least some point during boot. Otherwise, agreed.
> 

[Resending due to misconfigured tablet]

3 before 2 is exactly what is known to break on existing hardware (ASUS).

If anything, we should move to using the EFI RTC as a very last resort,
i.e. 3 after 4.  Ideally we should match Win8 behavior, but that would
require someone mocking up different ACPI and EFI functions in a
simulator and see how Win8 prioritizes things.

	-hpa
