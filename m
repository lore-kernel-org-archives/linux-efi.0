From: Ingo Molnar <mingo@kernel.org>
Subject: [GIT PULL] EFI changes for v4.20
Date: Tue, 23 Oct 2018 12:07:56 +0200
Message-ID: <20181023100756.GA10989@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@alien8.de>
List-Id: linux-efi@vger.kernel.org

Greg,

Please pull the latest efi-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git efi-core-for-linus

   # HEAD: fa70f0d2ce96a892b38fbbaa60584af536f21f97 Merge tag 'efi-next' of git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi into efi/core

The main changes are:

 - Add support for enlisting the help of the EFI firmware to create 
   memory reservations that persist across kexec.

 - Add page fault handling to the runtime services support code on x86 so
   we can more gracefully recover from buggy EFI firmware.

 - Fix command line handling on x86 for the boot path that omits the stub's
   PE/COFF entry point.

 - Other assorted fixes and updates.

 Thanks,

	Ingo

------------------>
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
