From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL 0/2] EFI fixes for v4.15
Date: Tue,  2 Jan 2018 17:21:08 +0000
Message-ID: <20180102172110.17018-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ge Song <ge.song-PT9Dzx9SjPiXmMXjJBpWqg@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The following changes since commit 30a7acd573899fd8b8ac39236eff6468b195ac7d:

  Linux 4.15-rc6 (2017-12-31 14:47:43 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-urgent

for you to fetch changes up to 33f7b2e57a70ad58a59edc9c707724c5719d5168:

  efi: capsule-loader: reinstate virtual capsule mapping (2018-01-02 16:50:34 +0000)

----------------------------------------------------------------
Another pair of EFI fixes for v4.15:
- fix 'add_efi_memmap' early param handling, which inadvertently gets called
  before early params have been parsed
- reinstate vmapping of capsule images, so that the firmware can process
  them immediately (this got broken in v4.13)

----------------------------------------------------------------
Ard Biesheuvel (1):
      efi: capsule-loader: reinstate virtual capsule mapping

Dave Young (1):
      x86/efi: Fix kernel param add_efi_memmap regression

 arch/x86/kernel/setup.c               |  5 ++--
 arch/x86/platform/efi/quirks.c        | 13 +++++++++-
 drivers/firmware/efi/capsule-loader.c | 45 ++++++++++++++++++++++++++++-------
 include/linux/efi.h                   |  4 +++-
 4 files changed, 54 insertions(+), 13 deletions(-)
