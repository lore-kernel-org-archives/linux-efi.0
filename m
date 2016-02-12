From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [GIT PULL 0/5] EFI urgent fixes
Date: Fri, 12 Feb 2016 11:27:07 +0000
Message-ID: <1455276432-9931-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Matthew Garrett <mjg59-JW9irJGTvgXQT0dZR+AlfA@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Folks,

Please pull the following EFI patches from Peter that prevent
accidental deletion of EFI variables through efivarfs which can lead
to bricked machines.

These obviously need backporting to stable, so I'll take care of
sending the backports separately because we don't need to send the
entire 5 patch series.

The following changes since commit 59fd1214561921343305a0e9dc218bf3d40068f3:

  x86/mm/numa: Fix 32-bit memblock range truncation bug on 32-bit NUMA kernels (2016-02-08 12:10:03 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to ed8b0de5a33d2a2557dce7f9429dca8cb5bc5879:

  efi: Make efivarfs entries immutable by default (2016-02-10 16:25:52 +0000)

----------------------------------------------------------------
 * Prevent accidental deletion of EFI variables through efivarfs that
   may brick machines. We use a whitelist of known-safe variables to
   allow things like installing distributions to work out of the box, and
   instead restrict vendor-specific variable deletion by making
   non-whitelist variables immutable - Peter Jones

----------------------------------------------------------------
Peter Jones (5):
      lib/ucs2_string: Add ucs2 -> utf8 helper functions
      efi: Use ucs2_as_utf8 in efivarfs instead of open coding a bad version
      efi: Do variable name validation tests in utf8
      efi: Make our variable validation list include the guid
      efi: Make efivarfs entries immutable by default

 Documentation/filesystems/efivarfs.txt         |   7 ++
 drivers/firmware/efi/efivars.c                 |  35 +++---
 drivers/firmware/efi/vars.c                    | 143 ++++++++++++++++++-------
 fs/efivarfs/file.c                             |  70 ++++++++++++
 fs/efivarfs/inode.c                            |  30 ++++--
 fs/efivarfs/internal.h                         |   3 +-
 fs/efivarfs/super.c                            |  16 +--
 include/linux/efi.h                            |   5 +-
 include/linux/ucs2_string.h                    |   4 +
 lib/ucs2_string.c                              |  62 +++++++++++
 tools/testing/selftests/efivarfs/efivarfs.sh   |  19 +++-
 tools/testing/selftests/efivarfs/open-unlink.c |  72 ++++++++++++-
 12 files changed, 383 insertions(+), 83 deletions(-)
