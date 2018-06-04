From: Ingo Molnar <mingo@kernel.org>
Subject: [GIT PULL] EFI changes for v4.18
Date: Mon, 4 Jun 2018 10:53:21 +0200
Message-ID: <20180604085321.GA13825@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-efi@vger.kernel.org

Linus,

Please pull the latest efi-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git efi-core-for-linus

   # HEAD: 83f0a7c7b265a56d757f7e3a80622e5b0b7ebc46 efi/capsule-loader: Don't output reset log when reset flags are not set

The main EFI changes in this cycle were:

 - Decode x86 CPER data (Yazen Ghannam)

 - Ignore unrealistically large option ROMs (Hans de Goede)

 - Initialize UEFI secure boot state during Xen dom0 boot (Daniel Kiper)

 - Additional minor tweaks and fixes.

 Thanks,

	Ingo

------------------>
Ard Biesheuvel (2):
      efi: Align efi_pci_io_protocol typedefs to type naming convention
      efi/x86: Fold __setup_efi_pci32() and __setup_efi_pci64() into one function

Borislav Petkov (1):
      efi/cper: Remove the INDENT_SP silliness

Daniel Kiper (1):
      x86/xen/efi: Initialize UEFI secure boot state during dom0 boot

Hans de Goede (1):
      efi/x86: Ignore unrealistically large option ROMs

Shunyong Yang (1):
      efi/capsule-loader: Don't output reset log when reset flags are not set

Wei Yongjun (1):
      efi/libstub/tpm: Make function efi_retrieve_tpm2_eventlog_1_2() static

Yazen Ghannam (8):
      efi: Fix IA32/X64 Processor Error Record definition
      efi: Decode IA32/X64 Processor Error Section
      efi: Decode IA32/X64 Processor Error Info Structure
      efi: Decode UEFI-defined IA32/X64 Error Structure GUIDs
      efi: Decode IA32/X64 Cache, TLB, and Bus Check structures
      efi: Decode additional IA32/X64 Bus Check fields
      efi: Decode IA32/X64 MS Check structure
      efi: Decode IA32/X64 Context Info structure


 arch/x86/boot/compressed/eboot.c          | 114 +++-------
 arch/x86/xen/efi.c                        |  57 +++++
 drivers/firmware/efi/Kconfig              |   5 +
 drivers/firmware/efi/Makefile             |   1 +
 drivers/firmware/efi/capsule-loader.c     |  14 +-
 drivers/firmware/efi/cper-arm.c           |   6 +-
 drivers/firmware/efi/cper-x86.c           | 356 ++++++++++++++++++++++++++++++
 drivers/firmware/efi/cper.c               |  16 +-
 drivers/firmware/efi/libstub/secureboot.c |   3 +
 drivers/firmware/efi/libstub/tpm.c        |   2 +-
 include/linux/cper.h                      |   4 +-
 include/linux/efi.h                       |   6 +-
 12 files changed, 485 insertions(+), 99 deletions(-)
 create mode 100644 drivers/firmware/efi/cper-x86.c
