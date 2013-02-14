From: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFE PATCH 0/2] x86, rtc, ntp, Enable full rtc synchronization
Date: Thu, 14 Feb 2013 12:02:53 -0500
Message-ID: <1360861375-24131-1-git-send-email-prarit@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

This patchset enables a full rtc synchronization via ntp on x86.  The current
codebase (plus http://marc.info/?l=linux-kernel&m=136036689219340&w=2, which is
queued for tip), will attempt to synchronize the rtc to the system time every
11 minutes if ntp is running.

The problem in the current code is that the synchronization will only occur
if the system time is within +/-15 minutes of the current rtc time.  ie)
we only do a "partial" synchronization of the rtc.  Other architectures do
full synchronizations and the partial sync appears to be a software limitation.

This patchset introduces a full synchronization of the rtc, and allows the
writing of the rtc date and time via sysfs (read for date and time is already
implemented).

I tested this patch by using the write capability introduced in 2/2 to
write in older and newer dates into the rtc, and then rebooting with ntpdate,
and/or ntpdate enabled and verifying the correct setting of the hwclock (and
system time) via calls to date and hwclock (all on 64-bit x86)

I have not tested the mrst/vrtc.c code, however, code inspection indicates
that the only change required is the year offset of 1972.  I booted 32-bit
Fedora 18 on an UEFI system and confirmed that the system time and hwclock
were now correct at boot.

Signed-off-by: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Prarit Bhargava (2):
  x86, rtc, ntp, Do full rtc synchronization with ntp
  rtc, add write functionality to sysfs

 arch/x86/kernel/rtc.c         | 69 ++++++----------------------------
 arch/x86/platform/efi/efi.c   | 24 ++++++++----
 arch/x86/platform/mrst/vrtc.c | 41 ++++++++++++---------
 drivers/rtc/rtc-sysfs.c       | 86 ++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 136 insertions(+), 84 deletions(-)

-- 
1.8.1.2
