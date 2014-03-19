From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH 0/5] efivars compat support
Date: Wed, 19 Mar 2014 19:59:55 +0000
Message-ID: <1395259200-27732-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Apparently people are running 32-bit userland on top of 64-bit kernels
and wanting to interact with efivars. At the moment this doesn't work
all too well because 'struct efi_variable' (the data blob passed between
userland and kernel) contains unsigned long data items, leading to
incompatibilities and tears.

We can fix this up fairly trivially in the kernel by using
is_compat_task() and doing a small amount of data munging.

Matt Fleming (5):
  efivars: Use local variables instead of a pointer dereference
  efivars: Check size of user object
  efivars: Stop passing a struct argument to efivar_validate()
  efivars: Refactor sanity checking code into separate function
  efivars: Add compatibility code for compat tasks

 drivers/firmware/efi/efivars.c | 192 ++++++++++++++++++++++++++++++++++-------
 drivers/firmware/efi/vars.c    |  30 +++----
 include/linux/efi.h            |   6 +-
 3 files changed, 181 insertions(+), 47 deletions(-)

-- 
1.8.5.3
