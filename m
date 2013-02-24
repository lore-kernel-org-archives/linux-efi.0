From: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFE PATCH 1/2] x86, rtc, ntp, Do full rtc synchronization with
 ntp
Date: Sun, 24 Feb 2013 12:12:57 -0500
Message-ID: <512A4A19.2090800@redhat.com>
References: <1360861375-24131-1-git-send-email-prarit@redhat.com> <1360861375-24131-2-git-send-email-prarit@redhat.com> <5127D853.6030703@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5127D853.6030703-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



On 02/22/2013 03:42 PM, John Stultz wrote:
> 
> 
> This looks reasonable to me.
> 
> Though I want to make sure we get this thoroughly tested by the various distros
> so we don't surprise anyone, since it has to potential to cause problems where
> folks are dualbooting windows (using a localtime RTC) and do not have their OS
> setup to trigger warp_clock to adjust for the localtime rtc (instead getting a
> time correction later via NTP).
> 
> I'll queue it and see about getting it merged to -tip & -next. Then we'll have
> to decide if 3.10 or 3.11 is the right time frame to land it.
> 

cc'ing Alessandro as well.

John, I've been testing this across various systems (including those known to
have some wonkiness with the RTC in BIOS ... see comment below) to see if this
code impacts anything.

I've tested mainly using Fedora 18 (with the latest kernel -tip obviously), but
I also installed Ubuntu on a system to see if there was any noticeable impact
there too.  I have not seen any unusual testing failures on AMD or Intel systems.

On the one system which I know to have "weak" battery such that the RTC doesn't
"stick" on the system shutdown the clock resets itself in BIOS reboot to "Jan 1
1970".  When I tested previously I could not get the RTC written to the current
date; after my changes, the RTC does at least reflect the current date through a
reboot.  It should be noted that if I do replace the battery on this system I
can get the RTC to properly "stick" through a reboot.

Given the test results I think this should go in earlier rather than later;  I'd
like to target 3.10 for the full sync, and possibly 3.11 for the HCTOSYS stuff.

... unless anyone has a strenuous objection ;)

P.
