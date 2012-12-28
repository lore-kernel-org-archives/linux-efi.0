From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] rtc-efi: register rtc-efi device when EFI enabled
Date: Fri, 28 Dec 2012 12:40:56 -0800
Message-ID: <50DE03D8.9030902@zytor.com>
References: <1356712001-12198-1-git-send-email-jlee@suse.com>  <E99CBA9F97C3D149AA6B19ED2E277C9B019215CC@BY2PRD0510MB365.namprd05.prod.outlook.com>  <3fa7337e-6bbc-4462-9704-2d8ac20a9cf2@email.android.com> <E99CBA9F97C3D149AA6B19ED2E277C9B019215FA@BY2PRD0510MB365.namprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E99CBA9F97C3D149AA6B19ED2E277C9B019215FA-kSjp6dTd0Hr1oIOzUjSfqB1/qY2kGW66nBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 12/28/2012 11:17 AM, Matthew Garrett wrote:
> On Fri, 2012-12-28 at 11:07 -0800, H. Peter Anvin wrote:
>> We do have such machines, which is why this change has been reverted twice already.  I believe we should stick to the priority scheme I proposed a few weeks ago.
>
> I seem to have missed that discussion, and couldn't find it after a
> brief search. Got a pointer?
>

Looks like it was a non-public distribution ... anyway, what I wrote was:

> I suspect that what we *should* do looks like:
>
> 1. If ACPI exports a Time and Alarm Device (ACPI000E) the use it;
> 2. If ACPI exports an PC/AT device (PNP0B00/1/2) then use it(*);
> 3. If we have an EFI RTC use it;
> 4. Probe for a PC/AT RTC device.
>
> I'm unsure what the ordering of 1 & 2 should be.  The ACPI device has
> the advantage that it contains time zone information, which is important
> for Windows interoperability, and at least optionally supports
> millisecond resolution; there is no way to even export "this is where
> you find time zone information" (since we're dealing with an RTC with
> embedded CMOS, there is storage available, it is just a matter of
> telling the OS how to find it) for the PNP0B0x devices.
>
> The TAD is also guaranteed to map 1:1 to the EFI RTC.
>
> 	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.
