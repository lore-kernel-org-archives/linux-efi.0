From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 0/3] efi interruptible runtime services
Date: Mon, 11 Jul 2016 16:59:22 +0200
Message-ID: <1468249165-25523-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This is a resend of the generic part of the series 'efi interruptible runtime
services', of which v3 was sent out on January 13th. I have added an additional
patch on top which gives runtime-wrappers.c the same treatment as efivars.c,
i.e., replacing the spinlock with a semaphore.

v2: rebase onto v4.7-rc3
    pr_warn() on failure to acquire the rt services semaphore before invoking
    the reset_system runtime service
    map EFI_ABORTED onto -EINTR

Ard Biesheuvel (1):
  efi: replace runtime services spinlock with semaphore

Sylvain Chouleur (2):
  efi: use a file local lock for efivars
  efi: don't use spinlocks for efi vars

 drivers/firmware/efi/efi-pstore.c       |  36 +++--
 drivers/firmware/efi/efi.c              |   3 +
 drivers/firmware/efi/efivars.c          |  22 ++-
 drivers/firmware/efi/runtime-wrappers.c |  81 ++++++-----
 drivers/firmware/efi/vars.c             | 142 +++++++++++++-------
 fs/efivarfs/inode.c                     |   5 +-
 fs/efivarfs/super.c                     |   9 +-
 include/linux/efi.h                     |  13 +-
 8 files changed, 204 insertions(+), 107 deletions(-)

-- 
1.9.1
