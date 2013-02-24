From: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFE PATCH 2/2] rtc, add write functionality to sysfs
Date: Sun, 24 Feb 2013 12:03:01 -0500
Message-ID: <512A47C5.3010500@redhat.com>
References: <1360861375-24131-1-git-send-email-prarit@redhat.com> <1360861375-24131-3-git-send-email-prarit@redhat.com> <5127D884.6020701@linaro.org> <5127DB2B.3030700@redhat.com> <5127DDAF.2000403@linaro.org> <B22B05C4-B8D2-44B9-971B-37913DE59EF6@towertech.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <B22B05C4-B8D2-44B9-971B-37913DE59EF6-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>
Cc: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



On 02/23/2013 06:11 PM, Alessandro Zummo wrote:
> On 22/feb/2013, at 22:05, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> 
>> On 02/22/2013 12:55 PM, Prarit Bhargava wrote:
>>>
>>> On 02/22/2013 03:43 PM, John Stultz wrote:
>>>> On 02/14/2013 09:02 AM, Prarit Bhargava wrote:
>>>>> /sys/class/rtc/rtcX/date and /sys/class/rtc/rtcX/time currently have
>>>>> read-only access.  This patch introduces write functionality which will
>>>>> set the rtc time.
>>>>>
>>>>> Usage: echo YYYY-MM-DD > /sys/class/rtc/rtcX/date
>>>>>         echo HH:MM:SS > /sys/class/rtc/rtcX/time
>>>> Why do we want to add a new interface here?
>>> John,
>>>
>>> I'm not adding a new interface.  The current date/time interface only handles
>>> read and I'm introducing write.
>>>
>>
>> Right, but what benefit does that provide?
>> (I'm not saying there isn't any, its just not clear from your patch why this is a good thing.)
>>

Sorry John, I misunderstood your question.

>> Also CC'ing Alessandro for his input.
> 
> I'd like to keep the interfaces as simple as possible but I'm open to improvements if there are good use cases.
> 

AFAICT there is no way for me to "test" or use the write from userspace.
hwclock uses the SET_TIME ioctl, which is a different code path AFAICT.

I'd like to be at least able to test this stuff when we make changes to it so I
think having write functionality for date & time is worthwhile.

For me, I'm using these to heavily test ntp and ntpdate over system reboots.

OOC, Alessandro, why is the date & time split into two fields?

P.
