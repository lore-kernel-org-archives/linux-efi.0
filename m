From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [RFC][PATCH 0/7] Chainsaw efivars.c
Date: Fri,  8 Feb 2013 20:59:11 +0000
Message-ID: <1360357158-8168-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

drivers/firmware/efivars.c has grown pretty large and is ~2K lines.

Inside efivars.c there's currently,

  o code for handling EFI variables at the firmware-level
  o sysfs code for exposing EFI variables
  o a new EFI variable filesystem
  o a persistent storage backend

all intertwined and smushed together. This situation is only going to
get worse as new EFI support is added.

We need an interface that hides the EFI variable operations in use so
code isn't tempted to access them directly, e.g. efivarfs currently
uses '__efivars' which means it doesn't work for CONFIG_GOOGLE_SMI as
that uses different variable ops. With this interface in place, we can
start moving independent code out into separate files, allowing users
to only turn on the functionality that they want.

This patch series introduces the new efivar_entry API, and splits out
the major parts of efivars.c into new files. There's more work TODO,
but this is at least a start.

The series is also available on the 'chainsaw' branch at,

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/linux.git

Comments welcome.

Matt Fleming (7):
  efivars: Keep a private global pointer to efivars
  efi: Move utf16_strlen() to efi.h
  efivars: New efivar_entry API
  drivers/firmware: Create a new EFI drivers directory
  efivars: Move pstore code out of efivars.c
  efi: Add generic variable operations
  efivarfs: Move to fs/efivarfs

 MAINTAINERS                        |   12 +-
 drivers/firmware/Kconfig           |   18 +-
 drivers/firmware/Makefile          |    1 +
 drivers/firmware/efi/Kconfig       |   56 +
 drivers/firmware/efi/Makefile      |    6 +
 drivers/firmware/efi/generic-ops.c |   52 +
 drivers/firmware/efi/pstore.c      |  239 +++++
 drivers/firmware/efi/sysfs.c       |  549 ++++++++++
 drivers/firmware/efivars.c         | 2068 +++++++++---------------------------
 drivers/firmware/google/Kconfig    |    6 +-
 drivers/firmware/google/gsmi.c     |   30 +-
 fs/Kconfig                         |    1 +
 fs/Makefile                        |    1 +
 fs/efivarfs/Kconfig                |   12 +
 fs/efivarfs/Makefile               |    7 +
 fs/efivarfs/file.c                 |  130 +++
 fs/efivarfs/inode.c                |  179 ++++
 fs/efivarfs/internal.h             |   18 +
 fs/efivarfs/super.c                |  233 ++++
 include/linux/efi.h                |  120 ++-
 20 files changed, 2120 insertions(+), 1618 deletions(-)
 create mode 100644 drivers/firmware/efi/Kconfig
 create mode 100644 drivers/firmware/efi/Makefile
 create mode 100644 drivers/firmware/efi/generic-ops.c
 create mode 100644 drivers/firmware/efi/pstore.c
 create mode 100644 drivers/firmware/efi/sysfs.c
 create mode 100644 fs/efivarfs/Kconfig
 create mode 100644 fs/efivarfs/Makefile
 create mode 100644 fs/efivarfs/file.c
 create mode 100644 fs/efivarfs/inode.c
 create mode 100644 fs/efivarfs/internal.h
 create mode 100644 fs/efivarfs/super.c

-- 
1.7.11.7
