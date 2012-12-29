From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] rtc-efi: register rtc-efi device when EFI enabled
Date: Fri, 28 Dec 2012 21:19:21 -0800
Message-ID: <ed3971f1-8464-4406-bae2-eff914c9c2fc@email.android.com>
References: <1356712001-12198-1-git-send-email-jlee@suse.com> <E99CBA9F97C3D149AA6B19ED2E277C9B019215CC@BY2PRD0510MB365.namprd05.prod.outlook.com> <3fa7337e-6bbc-4462-9704-2d8ac20a9cf2@email.android.com> <E99CBA9F97C3D149AA6B19ED2E277C9B019215FA@BY2PRD0510MB365.namprd05.prod.outlook.com> <50DE03D8.9030902@zytor.com> <E99CBA9F97C3D149AA6B19ED2E277C9B01921638@BY2PRD0510MB365.namprd05.prod.outlook.com> <35da3df5-ecac-4b57-83a2-828326e5bfc3@email.android.com> <E99CBA9F97C3D149AA6B19ED2E277C9B0192169D@BY2PRD0510MB365.namprd05.prod.outlook.com> <50DE3C8F.4000405@zytor.com> <E99CBA9F97C3D149AA6B19ED2E277C9B01921744@BY2PRD0510MB365.namprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E99CBA9F97C3D149AA6B19ED2E277C9B01921744-kSjp6dTd0Hr1oIOzUjSfqB1/qY2kGW66nBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arjan van de Ven <arjan-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Again, we could hack a simulator and try it.

Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org> wrote:

>On Fri, 2012-12-28 at 16:42 -0800, H. Peter Anvin wrote:
>> On 12/28/2012 03:39 PM, Matthew Garrett wrote:
>> > On Fri, 2012-12-28 at 15:32 -0800, H. Peter Anvin wrote:
>> >> No, that is explicitly the ordering that is excludable.
>> > 
>> > Windows uses the UEFI time functions. The fact that they fail for
>us on
>> > a bunch of systems is just another symptom of our general failure
>to
>> > accurately mimic Windows when making runtime calls, and we should
>just
>> > make sure that that gets fixed rather than layering more
>workarounds on
>> > top. It's an embarrassment that we're still unable to deal with
>> > platforms that work fine with another OS. 
>> > 
>> 
>> Are they using them in preference to ACPI?  This seems a bit odd,
>since
>> one can presume that the ACPI functions were added at Microsoft's
>request...
>
>In preference to the ACPI RTC, I haven't yet had an ACPI 5.0 TAD device
>to test in comparison.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
