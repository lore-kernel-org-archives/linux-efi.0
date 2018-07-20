From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [GIT PULL 0/9] EFI changes for v4.19 (#2)
Date: Fri, 20 Jul 2018 10:47:17 +0900
Message-ID: <20180720014726.24031-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Hans de Goede <hdegoede@redhat.com>, Lukas Wunner <lukas@wunner.de>
List-Id: linux-efi@vger.kernel.org

The following changes since commit 61f0d55569463a1af897117ff47d202b0ccb2e24:

  efi/esrt: Only call efi_mem_reserve() for boot services memory (2018-07-17 09:15:05 +0200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git efi-next

for you to fetch changes up to ea6854bfead2a7ac7e44274a5dbc69a567cf3e73:

  efivars: Call guid_parse() against guid_t type of variable (2018-07-18 07:17:20 +0800)

----------------------------------------------------------------
EFI changes for v4.19, batch #2:
- Make mixed mode UEFI runtime service invocations mutually exclusive, as
  mandated by the UEFI spec (Ard)
- GUID cleanups by Andy
- More stub code deduplication and cleanup (Lukas, Ard)

----------------------------------------------------------------
Andy Shevchenko (2):
      efi/cper: Use consistent types for UUIDs
      efivars: Call guid_parse() against guid_t type of variable

Ard Biesheuvel (6):
      efi/x86: prevent reentrant firmware calls in mixed mode
      efi/x86: merge setup_efi_pci32 and setup_efi_pci64 routines
      efi/x86: align efi_uga_draw_protocol typedef names to convention
      efi/x86: merge 32-bit and 64-bit UGA draw protocol setup routines
      efi/x86: add missing NULL initialization in UGA draw protocol discovery
      efi/x86: replace references to efi_early->is64 with efi_is_64bit()

Lukas Wunner (1):
      efi: Deduplicate efi_open_volume()

 arch/arm/include/asm/efi.h                     |   3 +
 arch/arm64/include/asm/efi.h                   |   3 +
 arch/x86/boot/compressed/eboot.c               | 316 ++++++-------------------
 arch/x86/boot/compressed/eboot.h               |  12 +-
 arch/x86/platform/efi/efi_64.c                 | 101 +++++++-
 drivers/firmware/efi/cper.c                    |   2 +-
 drivers/firmware/efi/libstub/arm-stub.c        |  25 --
 drivers/firmware/efi/libstub/efi-stub-helper.c |  31 ++-
 drivers/firmware/efi/libstub/efistub.h         |   3 -
 fs/efivarfs/inode.c                            |   4 +-
 include/linux/efi.h                            |  10 +
 11 files changed, 219 insertions(+), 291 deletions(-)
