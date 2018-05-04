From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [GIT PULL 00/17] EFI updates for v4.18
Date: Fri,  4 May 2018 07:59:46 +0200
Message-ID: <20180504060003.19618-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Borislav Petkov <bp@suse.de>, Daniel Kiper <daniel.kiper@oracle.com>, Hans de Goede <hdegoede@redhat.com>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Joey Zheng <yu.zheng@hxt-semitech.com>, Kim Phillips <kim.phillips@arm.com>, Lukas Wunner <lukas@wunner.de>, Mark Rutland <mark.rutland@arm.com>, Shunyong Yang <shunyong.yang@hxt-semitech.com>, Wei Yongjun <weiyongjun1@huawei.com>, Yazen Ghannam <yazen.ghannam@amd.com>
List-Id: linux-efi@vger.kernel.org

The following changes since commit 60cc43fc888428bb2f18f08997432d426a243338:

  Linux 4.17-rc1 (2018-04-15 18:24:20 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next

for you to fetch changes up to a0e781fedc0e975d2f33fda94e26d3f76331ee3d:

  efi/libstub/arm64: handle randomized TEXT_OFFSET (2018-05-03 19:00:27 +0200)

----------------------------------------------------------------
First batch of EFI changes for v4.18:
- Initialize UEFI secure boot state during Xen dom0 boot (Daniel Kiper)
- Decode x86 CPER data (Yazen Ghannam)
- Ignore unrealistically large option roms (Hans de Goede)
- Additional minor tweaks
- A fix for arm64 kernels with CONFIG_RANDOMIZE_TEXT_OFFSET=y and running
  with KASLR enabled. I was on the fence whether to send it as a fix or
  cc it to stable, so I chose the latter. (TEXT_OFFSET randomization is a
  debug feature that the distros don't enable)

----------------------------------------------------------------
Ard Biesheuvel (3):
      efi: fix efi_pci_io_protocol32 prototype for mixed mode
      efi: align efi_pci_io_protocol typedefs to type naming convention
      efi/x86: fold __setup_efi_pci32 and __setup_efi_pci64 into one

Borislav Petkov (1):
      efi/cper: Remove the INDENT_SP silliness

Daniel Kiper (1):
      x86/xen/efi: Initialize UEFI secure boot state during dom0 boot

Hans de Goede (1):
      efi/x86: Ignore unrealistically large option roms

Mark Rutland (1):
      efi/libstub/arm64: handle randomized TEXT_OFFSET

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

 arch/x86/boot/compressed/eboot.c          | 112 +++-------
 arch/x86/xen/efi.c                        |  57 +++++
 drivers/firmware/efi/Kconfig              |   5 +
 drivers/firmware/efi/Makefile             |   1 +
 drivers/firmware/efi/capsule-loader.c     |  14 +-
 drivers/firmware/efi/cper-arm.c           |   6 +-
 drivers/firmware/efi/cper-x86.c           | 356 ++++++++++++++++++++++++++++++
 drivers/firmware/efi/cper.c               |  16 +-
 drivers/firmware/efi/libstub/arm64-stub.c |   7 +
 drivers/firmware/efi/libstub/secureboot.c |   3 +
 drivers/firmware/efi/libstub/tpm.c        |   2 +-
 include/linux/cper.h                      |   4 +-
 include/linux/efi.h                       |  14 +-
 13 files changed, 496 insertions(+), 101 deletions(-)
 create mode 100644 drivers/firmware/efi/cper-x86.c
