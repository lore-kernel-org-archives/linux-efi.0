From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL 0/5] EFI updates for v4.16
Date: Tue,  2 Jan 2018 18:10:37 +0000
Message-ID: <20180102181042.19074-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Arvind Yadav <arvind.yadav.cs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Stephen Boyd <sboyd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Vasyl Gomonovych <gomonovych-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The following changes since commit 30a7acd573899fd8b8ac39236eff6468b195ac7d:

  Linux 4.15-rc6 (2017-12-31 14:47:43 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next

for you to fetch changes up to 1926a2c1178b6a6622d5ebdc44e1ad0010863824:

  efi: parse ARM error information value (2018-01-02 18:03:05 +0000)

----------------------------------------------------------------
EFI changes for v4.16:
- ignore EFI_MEMORY_XP attributes on ARM if _RP/_WP are set as well
- add support for ARM specific CPER values in decoding routines
- some cosmetic cleanups

----------------------------------------------------------------
Ard Biesheuvel (1):
      arm64: efi: ignore EFI_MEMORY_XP attribute if RP and/or WP are set

Arvind Yadav (1):
      efi/capsule-loader: pr_err() strings should end with newlines

Tyler Baicar (2):
      efi: move ARM CPER code to new file
      efi: parse ARM error information value

Vasyl Gomonovych (1):
      efi: Use PTR_ERR_OR_ZERO()

 arch/arm64/kernel/efi.c               |   4 +-
 drivers/firmware/efi/Kconfig          |   5 +
 drivers/firmware/efi/Makefile         |   1 +
 drivers/firmware/efi/capsule-loader.c |   2 +-
 drivers/firmware/efi/cper-arm.c       | 356 ++++++++++++++++++++++++++++++++++
 drivers/firmware/efi/cper.c           | 122 +-----------
 drivers/firmware/efi/efi.c            |   2 +-
 include/linux/cper.h                  |  48 +++++
 8 files changed, 418 insertions(+), 122 deletions(-)
 create mode 100644 drivers/firmware/efi/cper-arm.c
