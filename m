From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [GIT PULL 0/5] more EFI changes for v4.14
Date: Fri, 25 Aug 2017 16:50:14 +0100
Message-ID: <20170825155019.6740-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Colin Ian King <colin.king@canonical.com>, Jan Beulich <jbeulich@suse.com>, Matt Fleming <matt@codeblueprint.co.uk>, Matthew Garrett <mjg59@google.com>
List-Id: linux-efi@vger.kernel.org

The following changes since commit f1a5b53570001b1bcbf890ac6c4be1db99f8cc28:

  firmware/efi/esrt: Constify attribute_group structures (2017-08-21 09:43:51 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next

for you to fetch changes up to c4d2793e5a07d5e63d91715a4393fe47c8345112:

  efi: bgrt: use efi_mem_type() (2017-08-25 10:35:23 +0100)

----------------------------------------------------------------
More EFI changes for v4.14:
- add support for requesting the firmware to wipe RAM at warm reboot
- increase the size of the random seed obtained from UEFI so crng
  fast init can complete earlier
- add 'static' to local function pointer
- move efi_mem_type() to common code and replace an open coded instance
  with it in the BGRT driver

----------------------------------------------------------------
Ard Biesheuvel (1):
      efi/random: Increase size of firmware supplied randomness

Colin Ian King (1):
      efi/reboot: Make function pointer orig_pm_power_off static

Jan Beulich (2):
      efi: move efi_mem_type() to common code
      efi: bgrt: use efi_mem_type()

Matthew Garrett (1):
      efi/libstub: Enable reset attack mitigation

 arch/x86/boot/compressed/eboot.c        |  3 ++
 arch/x86/platform/efi/efi.c             | 19 -----------
 drivers/firmware/efi/Kconfig            | 10 ++++++
 drivers/firmware/efi/efi-bgrt.c         | 22 +------------
 drivers/firmware/efi/efi.c              | 40 +++++++++++++++++++----
 drivers/firmware/efi/libstub/Makefile   |  1 +
 drivers/firmware/efi/libstub/arm-stub.c |  3 ++
 drivers/firmware/efi/libstub/random.c   | 10 +++---
 drivers/firmware/efi/libstub/tpm.c      | 58 +++++++++++++++++++++++++++++++++
 drivers/firmware/efi/reboot.c           |  2 +-
 include/linux/efi.h                     |  9 +++++
 11 files changed, 123 insertions(+), 54 deletions(-)
 create mode 100644 drivers/firmware/efi/libstub/tpm.c
