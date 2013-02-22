From: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFE PATCH 1/2] x86, rtc, ntp, Do full rtc synchronization with
 ntp
Date: Fri, 22 Feb 2013 12:42:59 -0800
Message-ID: <5127D853.6030703@linaro.org>
References: <1360861375-24131-1-git-send-email-prarit@redhat.com> <1360861375-24131-2-git-send-email-prarit@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360861375-24131-2-git-send-email-prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 02/14/2013 09:02 AM, Prarit Bhargava wrote:
> Every 11 minutes ntp attempts to update the x86 rtc with the current
> system time.  Currently, the x86 code only updates the rtc if the system
> time is within +/-15 minutes of the current value of the rtc.  Other
> architectures do a full synchronization and there is no reason that x86
> should be software limited to a 30 minute window.
>
> This patch changes the behavior of the kernel to do a full synchronization
> (year, month, day, hour, minute, and second) of the rtc when ntp requests
> a synchronization between the system time and the rtc.
>
> I've used the RTC library functions in this patchset as they do all the
> required bounds checking.
>
> Signed-off-by: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Cc: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Cc: David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


This looks reasonable to me.

Though I want to make sure we get this thoroughly tested by the various 
distros so we don't surprise anyone, since it has to potential to cause 
problems where folks are dualbooting windows (using a localtime RTC) and 
do not have their OS setup to trigger warp_clock to adjust for the 
localtime rtc (instead getting a time correction later via NTP).

I'll queue it and see about getting it merged to -tip & -next. Then 
we'll have to decide if 3.10 or 3.11 is the right time frame to land it.

thanks
-john
