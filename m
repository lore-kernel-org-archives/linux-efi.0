From: Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>
Subject: Re: [RFE PATCH 2/2] rtc, add write functionality to sysfs
Date: Mon, 25 Feb 2013 15:58:12 +0100
Message-ID: <20130225155812.0758e093@linux.lan.towertech.it>
References: <1360861375-24131-1-git-send-email-prarit@redhat.com>
	<1360861375-24131-3-git-send-email-prarit@redhat.com>
	<5127D884.6020701@linaro.org>
	<5127DB2B.3030700@redhat.com>
	<5127DDAF.2000403@linaro.org>
	<B22B05C4-B8D2-44B9-971B-37913DE59EF6@towertech.it>
	<512A47C5.3010500@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <512A47C5.3010500-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org" <rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, 24 Feb 2013 12:03:01 -0500
Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> 
> AFAICT there is no way for me to "test" or use the write from userspace.
> hwclock uses the SET_TIME ioctl, which is a different code path AFAICT.
> 
> I'd like to be at least able to test this stuff when we make changes to it so I
> think having write functionality for date & time is worthwhile.
> 
> For me, I'm using these to heavily test ntp and ntpdate over system reboots.

 the point is: who will benefit from this patch? users? distributions?
 embedded distributions? if it's useful, then just go for it.


> OOC, Alessandro, why is the date & time split into two fields?

 because date and time are two different things and we expect
 sysfs to preferably have one value for each entry.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it
