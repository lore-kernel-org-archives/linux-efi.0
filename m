From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL 0/3] EFI fixes for v4.15
Date: Wed,  6 Dec 2017 09:50:07 +0000
Message-ID: <20171206095010.24170-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Pan Bian <bianpan2016-9Onoh4P/yGk@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The following changes since commit ae64f9bd1d3621b5e60d7363bc20afb46aede215:

  Linux 4.15-rc2 (2017-12-03 11:01:47 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git efi-urgent

for you to fetch changes up to bfe89df500c99e29fbd0fd6f18e396f1625efcee:

  efi: add comment to avoid future expanding of sysfs systab (2017-12-05 18:11:36 +0000)

----------------------------------------------------------------
A couple of fixes for v4.15:
- limit the permissions of EFI related sysfs nodes to 0400
- use memunmap not kfree for a mapping created with memremap
- add a comment to the code that produces the contents of
  /sys/firmware/efi/systab that it already violates policy, and
  no new entries should be added to it

----------------------------------------------------------------
Dave Young (1):
      efi: add comment to avoid future expanding of sysfs systab

Greg Kroah-Hartman (1):
      efi: move some sysfs files to be read-only by root

Pan Bian (1):
      efi/esrt: use memunmap rather kfree to free the remapping

 drivers/firmware/efi/efi.c         |  5 +++--
 drivers/firmware/efi/esrt.c        | 17 +++++++----------
 drivers/firmware/efi/runtime-map.c | 10 +++++-----
 include/linux/sysfs.h              |  6 ++++++
 4 files changed, 21 insertions(+), 17 deletions(-)
