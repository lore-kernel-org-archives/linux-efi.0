From: Joseph Salisbury <joseph.salisbury-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [RESEND][v3.8] [v3.9] [v3.10] [Regression]  efi: be more paranoid
 about available space when creating variables
Date: Wed, 17 Jul 2013 16:34:26 -0400
Message-ID: <51E6FFD2.7010505@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Brad Figg <brad.figg-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Matthew,

A bug was opened that reports a regression that prevents a system from
booting[0].  After a kernel bisect, it was found that reverting the
following commit resolved this bug:

commit 68d929862e29a8b52a7f2f2f86a0600423b093cd
Author: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Date:   Sat Mar 2 19:40:17 2013 -0500

    efi: be more paranoid about available space when creating variables


The regression was introduced as of v3.9-rc2, but it also made it's way
into the stable trees(Commit 9f677cf in v3.8).

I see the following commit was introduced to address this issue:

commit 31ff2f20d9003e74991d135f56e503fe776c127c
Author: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Date:   Mon Apr 15 13:09:47 2013 -0700

    efi: Distinguish between "remaining space" and actually used space

However, the issue still in 3.9.4, 3.10-rc3 and v3.8.13 after
backporting 31ff2f2.

I see that you are the author of this patch, so I wanted to run this by
you and see if reverting commit 68d9298 is an option.  There are several
folks reporting this, so it should be easy to collect any additional
data/information or perform testing, if needed.


Thanks,

Joe

[0] http://pad.lv/1173423
