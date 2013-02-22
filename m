From: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFE PATCH 2/2] rtc, add write functionality to sysfs
Date: Fri, 22 Feb 2013 15:55:07 -0500
Message-ID: <5127DB2B.3030700@redhat.com>
References: <1360861375-24131-1-git-send-email-prarit@redhat.com> <1360861375-24131-3-git-send-email-prarit@redhat.com> <5127D884.6020701@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5127D884.6020701-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org



On 02/22/2013 03:43 PM, John Stultz wrote:
> On 02/14/2013 09:02 AM, Prarit Bhargava wrote:
>> /sys/class/rtc/rtcX/date and /sys/class/rtc/rtcX/time currently have
>> read-only access.  This patch introduces write functionality which will
>> set the rtc time.
>>
>> Usage: echo YYYY-MM-DD > /sys/class/rtc/rtcX/date
>>         echo HH:MM:SS > /sys/class/rtc/rtcX/time
> 
> Why do we want to add a new interface here?

John,

I'm not adding a new interface.  The current date/time interface only handles
read and I'm introducing write.

Sorry -- maybe my description was too short ...

P.

> 
> thanks
> -john
> 
