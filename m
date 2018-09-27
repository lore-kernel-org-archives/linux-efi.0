From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [GIT PULL 00/11] EFI updates for v4.20
Date: Thu, 27 Sep 2018 10:50:27 +0200
Message-ID: <20180927085039.8391-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Aaron Ma <aaron.ma@canonical.com>, Alistair Strachan <astrachan@google.com>, Ben Hutchings <ben@decadent.org.uk>, Bhupesh Sharma <bhsharma@redhat.com>, Hans de Goede <hdegoede@redhat.com>, Ivan Hu <ivan.hu@canonical.com>, Jeremy Linton <jeremy.linton@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, Peter Robinson <pbrobinson@redhat.com>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Stefan Agner <stefan@agner.ch>
List-Id: linux-efi@vger.kernel.org

Thomas, Ingo,

Please pull/cherry-pick the below. Note that the first three patches will
be depended upon by an irqchip series that Marc Zyngier has sent out last
week, and that targets the next release as well. So please advise how to
proceed with that: we could simply apply those patches first and use the
resulting commit in tip.git as a stable branch, I suppose, but I'll let
Marc chime in in case he has any other ideas.

Thanks,
Ard. 

[0] https://lore.kernel.org/lkml/20180921195954.21574-1-marc.zyngier@arm.com/

The following changes since commit 11da3a7f84f19c26da6f86af878298694ede0804:

  Linux 4.19-rc3 (2018-09-09 17:26:43 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next

for you to fetch changes up to 9c1442a9d039a1a3302fa93e9a11001c5f23b624:

  x86: boot: Fix EFI stub alignment (2018-09-26 12:15:01 +0200)

----------------------------------------------------------------
EFI updates for v4.20:
- Add support for enlisting the help of the EFI firmware to create memory
  reservations that persist across kexec.
- Add page fault handling to the runtime services support code on x86 so
  we can gracefully recover from buggy EFI firmware.
- Fix command line handling on x86 for the boot path that omits the stub's
  PE/COFF entry point.
- Other assorted fixes.

----------------------------------------------------------------
Aaron Ma (1):
      efi/x86: earlyprintk - Add 64bit efi fb address support

Alistair Strachan (1):
      efi/libstub: arm: support building with clang

Ard Biesheuvel (3):
      efi: honour memory reservations passed via a linux specific config table
      efi/arm: libstub: add a root memreserve config table
      efi: add API to reserve memory persistently across kexec reboot

Ben Hutchings (1):
      x86: boot: Fix EFI stub alignment

Hans de Goede (1):
      efi/x86: Call efi_parse_options() from efi_main()

Ivan Hu (1):
      efi/efi_test: add exporting ResetSystem runtime service

Sai Praneeth (2):
      efi: Make efi_rts_work accessible to efi page fault handler
      efi/x86: Handle page faults occurring while running EFI runtime services

Sebastian Andrzej Siewior (1):
      efi/x86: drop task_lock() from efi_switch_mm()

 arch/x86/boot/compressed/eboot.c        | 10 +++++
 arch/x86/boot/tools/build.c             |  7 +++
 arch/x86/include/asm/efi.h              |  1 +
 arch/x86/mm/fault.c                     |  9 ++++
 arch/x86/platform/efi/early_printk.c    |  8 +++-
 arch/x86/platform/efi/efi_64.c          | 10 ++---
 arch/x86/platform/efi/quirks.c          | 78 +++++++++++++++++++++++++++++++++
 drivers/firmware/efi/efi.c              | 59 ++++++++++++++++++++++++-
 drivers/firmware/efi/libstub/Makefile   |  3 +-
 drivers/firmware/efi/libstub/arm-stub.c | 27 ++++++++++++
 drivers/firmware/efi/runtime-wrappers.c | 61 +++++++-------------------
 drivers/firmware/efi/test/efi_test.c    | 27 ++++++++++++
 drivers/firmware/efi/test/efi_test.h    | 10 +++++
 include/linux/efi.h                     | 51 +++++++++++++++++++++
 14 files changed, 307 insertions(+), 54 deletions(-)
