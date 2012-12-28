From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/3] rtc-efi: register rtc-efi device when EFI enabled
Date: Fri, 28 Dec 2012 11:07:11 -0800
Message-ID: <3fa7337e-6bbc-4462-9704-2d8ac20a9cf2@email.android.com>
References: <1356712001-12198-1-git-send-email-jlee@suse.com> <E99CBA9F97C3D149AA6B19ED2E277C9B019215CC@BY2PRD0510MB365.namprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E99CBA9F97C3D149AA6B19ED2E277C9B019215CC-kSjp6dTd0Hr1oIOzUjSfqB1/qY2kGW66nBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

We do have such machines, which is why this change has been reverted twice already.  I believe we should stick to the priority scheme I proposed a few weeks ago.

Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org> wrote:

>On Sat, 2012-12-29 at 00:26 +0800, Lee, Chun-Yi wrote:
>> UEFI time services, GetTime(), SetTime(), GetWakeupTime(),
>SetWakeupTime() are also
>> supported by other non-IA64 architecutre with UEFI BIOS, e.g. x86.
>> 
>> This patch changed RTC_DRV_EFI configuration to depend on EFI but not
>just IA64. It
>> checks efi_enabled flag and efi-rtc driver should enabled.
>
>In theory, certainly - but do we still have machines that explode if
>the
>get_time call is made? We may also want to think about disabling the
>legacy access to the RTC if the EFI calls are present.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
