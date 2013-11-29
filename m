From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [GIT PULL] EFI urgent fixes
Date: Fri, 29 Nov 2013 12:09:51 +0000
Message-ID: <20131129120951.GF11775@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi guys,

The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:

  Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to fdeadb43fdf1e7d5698c027b555c389174548e5a:

  efi-pstore: Make efi-pstore return a unique id (2013-11-29 10:11:06 +0000)

----------------------------------------------------------------
 * Avoid triggering a lockdep warning caused by calling kmemdup() while
   holding a spinlock - Seiji Aguchi

 * EFI framebuffer earlyprintk fix for off-by-one error that caused
   console output to be split over two lines on some machines.

 * Avoid pstore filename collisions by using a timestamp to calculate
   the entry ID, thereby making them unique - Madper Xie

----------------------------------------------------------------
Madper Xie (1):
      efi-pstore: Make efi-pstore return a unique id

Matt Fleming (1):
      x86/efi: Fix earlyprintk off-by-one bug

Seiji Aguchi (1):
      efivars, efi-pstore: Hold off deletion of sysfs entry until the scan is completed

 arch/x86/platform/efi/early_printk.c |   2 +-
 drivers/firmware/efi/efi-pstore.c    | 163 +++++++++++++++++++++++++++++++----
 drivers/firmware/efi/efivars.c       |  12 ++-
 drivers/firmware/efi/vars.c          |  12 ++-
 include/linux/efi.h                  |   4 +
 5 files changed, 170 insertions(+), 23 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
