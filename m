From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [GIT PULL 0/8] EFI changes for v4.19
Date: Wed, 11 Jul 2018 11:40:32 +0200
Message-ID: <20180711094040.12506-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Alexander Graf <agraf@suse.de>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Laszlo Ersek <lersek@redhat.com>, Leif Lindholm <leif.lindholm@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Jones <pjones@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
List-Id: linux-efi@vger.kernel.org

The following changes since commit 7daf201d7fe8334e2d2364d4e8ed3394ec9af819:

  Linux 4.18-rc2 (2018-06-24 20:54:29 +0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next

for you to fetch changes up to 6a3524a55f16437d210f61bbb53c7c099b18babe:

  fbdev/efifb: honour UEFI memory map attributes when mapping the fb (2018-07-11 11:23:26 +0200)

----------------------------------------------------------------
EFI changes for v4.19, batch #1:
- Perform UEFI runtime services calls from a work queue so the calls into the
  firmware occur from a kernel thread (Sai)
- Honor the UEFI memory map attributes for live memory regions configured by
  UEFI as a framebuffer. This works around a coherency problem with KVM guests
  running on ARM. (Ard)
- Cleanup for the x86 EFI stub code (Ingo)
- A timekeeping fix from Arnd
- Gradually phase out the DTB loader in the ARM version of the EFI stub. (Ard)
- Drop an unused function declaration (Sai)

----------------------------------------------------------------
Ard Biesheuvel (3):
      efi/libstub/arm: add opt-in Kconfig option for the DTB loader
      efi: drop type and attribute checks in efi_mem_desc_lookup()
      fbdev/efifb: honour UEFI memory map attributes when mapping the fb

Arnd Bergmann (1):
      efi: cper: avoid using get_seconds()

Ingo Molnar (1):
      efi/x86: Clean up the eboot code

Sai Praneeth (3):
      efi/x86: Use non-blocking SetVariable() for efi_delete_dummy_variable()
      efi: Use a work queue to invoke EFI Runtime Services
      efi: Remove the declaration of efi_late_init() as the function is unused

 arch/x86/boot/compressed/eboot.c        | 245 ++++++++++++++++----------------
 arch/x86/platform/efi/quirks.c          |  14 +-
 drivers/firmware/efi/Kconfig            |  12 ++
 drivers/firmware/efi/cper.c             |  17 ++-
 drivers/firmware/efi/efi.c              |  22 ++-
 drivers/firmware/efi/esrt.c             |   5 +-
 drivers/firmware/efi/libstub/arm-stub.c |   7 +-
 drivers/firmware/efi/runtime-wrappers.c | 202 ++++++++++++++++++++++++--
 drivers/video/fbdev/efifb.c             |  51 +++++--
 include/linux/efi.h                     |   5 +-
 10 files changed, 413 insertions(+), 167 deletions(-)
