From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 0/3] efi interruptible runtime services
Date: Fri, 22 Apr 2016 09:13:20 +0200
Message-ID: <1461309203-11806-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
Cc: sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This is a resend of the generic part of the series 'efi interruptible runtime
services', of which v3 was sent out on January 13th. I have added an additional
patch on top which gives runtime-wrappers.c the same treatment as efivars.c,
i.e., replacing the spinlock with a semaphore.

Ard Biesheuvel (1):
  efi: replace runtime services spinlock with semaphore

Sylvain Chouleur (2):
  efi: use a file local lock for efivars
  efi: don't use spinlocks for efi vars

 drivers/firmware/efi/efi-pstore.c       |  36 +++--
 drivers/firmware/efi/efivars.c          |  22 ++-
 drivers/firmware/efi/runtime-wrappers.c |  77 +++++-----
 drivers/firmware/efi/vars.c             | 150 +++++++++++++-------
 fs/efivarfs/inode.c                     |   5 +-
 fs/efivarfs/super.c                     |   9 +-
 include/linux/efi.h                     |  13 +-
 7 files changed, 202 insertions(+), 110 deletions(-)

-- 
2.5.0
