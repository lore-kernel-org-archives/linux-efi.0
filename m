From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [GIT PULL 00/10] EFI changes for v5.1
Date: Sat,  2 Feb 2019 10:41:09 +0100
Message-ID: <20190202094119.13230-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, AKASHI Takahiro <takahiro.akashi@linaro.org>, Alexander Graf <agraf@suse.de>, Bjorn Andersson <bjorn.andersson@linaro.org>, Borislav Petkov <bp@alien8.de>, Heinrich Schuchardt <xypron.glpk@gmx.de>, Jeffrey Hugo <jhugo@codeaurora.org>, Lee Jones <lee.jones@linaro.org>, Leif Lindholm <leif.lindholm@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Jones <pjones@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
List-Id: linux-efi@vger.kernel.org

The following changes since commit 1c7fc5cbc33980acd13d668f1c8f0313d6ae9fd8:

  Linux 5.0-rc2 (2019-01-14 10:41:12 +1200)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next

for you to fetch changes up to 44f5ab0e212a9fff7c518803f7fc77b692b2afcd:

  acpi: bgrt: parse BGRT to obtain BMP address before it gets clobbered (2019-02-02 10:35:35 +0100)

----------------------------------------------------------------
EFI changes for v5.1:
- Use 32 bit alignment for efi_guid_t
- Allow the call to SetVirtualAddressMap() to be omitted
- Implement earlycon=efifb based on existing earlyprintk code
- Move BGRT table handling to earlier in the boot so we don't overwrite it
- Various minor fixes and code cleanups from Sai, Ingo and Ard

----------------------------------------------------------------
Ard Biesheuvel (7):
      efi: memattr: don't bail on zero VA if it equals the region's PA
      efi: use 32-bit alignment for efi_guid_t
      efi: replace GPL license boilerplate with SPDX headers
      efi: arm/arm64: allow SetVirtualAddressMap() to be omitted
      x86: make ARCH_USE_MEMREMAP_PROT a generic Kconfig symbol
      efi: x86: convert x86 EFI earlyprintk into generic earlycon implementation
      acpi: bgrt: parse BGRT to obtain BMP address before it gets clobbered

Ingo Molnar (1):
      efi/fdt: More cleanups

Sai Praneeth Prakhya (2):
      x86/efi: Mark can_free_region() as an __init function
      x86/efi: Return error status if mapping EFI regions fail

 Documentation/admin-guide/kernel-parameters.txt |   8 +-
 arch/Kconfig                                    |   3 +
 arch/arm64/kernel/acpi.c                        |   2 -
 arch/x86/Kconfig                                |   5 +-
 arch/x86/Kconfig.debug                          |  10 -
 arch/x86/include/asm/efi.h                      |   7 +-
 arch/x86/kernel/acpi/boot.c                     |   2 -
 arch/x86/kernel/early_printk.c                  |   4 -
 arch/x86/mm/ioremap.c                           |   4 +-
 arch/x86/platform/efi/Makefile                  |   1 -
 arch/x86/platform/efi/early_printk.c            | 240 ------------------------
 arch/x86/platform/efi/efi.c                     |  21 ++-
 arch/x86/platform/efi/efi_32.c                  |   6 +-
 arch/x86/platform/efi/efi_64.c                  |  39 ++--
 arch/x86/platform/efi/quirks.c                  |   2 +-
 drivers/acpi/bgrt.c                             |   6 -
 drivers/firmware/efi/Kconfig                    |   6 +
 drivers/firmware/efi/Makefile                   |   1 +
 drivers/firmware/efi/apple-properties.c         |  13 +-
 drivers/firmware/efi/arm-init.c                 |   6 +-
 drivers/firmware/efi/arm-runtime.c              |   6 +-
 drivers/firmware/efi/capsule-loader.c           |   4 +-
 drivers/firmware/efi/capsule.c                  |   4 +-
 drivers/firmware/efi/cper-arm.c                 |  14 +-
 drivers/firmware/efi/cper.c                     |  14 +-
 drivers/firmware/efi/dev-path-parser.c          |   9 +-
 drivers/firmware/efi/earlycon.c                 | 206 ++++++++++++++++++++
 drivers/firmware/efi/efi-bgrt.c                 |  89 +++++++--
 drivers/firmware/efi/efi-pstore.c               |   2 +
 drivers/firmware/efi/efi.c                      |  13 ++
 drivers/firmware/efi/efibc.c                    |  10 +-
 drivers/firmware/efi/efivars.c                  |  58 +-----
 drivers/firmware/efi/esrt.c                     |   1 +
 drivers/firmware/efi/fake_mem.c                 |  16 +-
 drivers/firmware/efi/libstub/Makefile           |   4 +-
 drivers/firmware/efi/libstub/arm-stub.c         |   5 +
 drivers/firmware/efi/libstub/arm32-stub.c       |   6 +-
 drivers/firmware/efi/libstub/arm64-stub.c       |   6 +-
 drivers/firmware/efi/libstub/efi-stub-helper.c  |  15 +-
 drivers/firmware/efi/libstub/efistub.h          |  12 ++
 drivers/firmware/efi/libstub/fdt.c              | 115 ++++++------
 drivers/firmware/efi/libstub/gop.c              |   4 +-
 drivers/firmware/efi/libstub/random.c           |   6 +-
 drivers/firmware/efi/libstub/secureboot.c       |   4 +-
 drivers/firmware/efi/libstub/tpm.c              |   4 +-
 drivers/firmware/efi/memattr.c                  |   7 +-
 drivers/firmware/efi/runtime-map.c              |   3 +-
 drivers/firmware/efi/test/efi_test.c            |   1 +
 drivers/firmware/efi/test/efi_test.h            |   2 +-
 drivers/firmware/efi/tpm.c                      |   5 +-
 drivers/firmware/efi/vars.c                     |  15 +-
 include/linux/efi-bgrt.h                        |   4 +-
 include/linux/efi.h                             |  15 +-
 53 files changed, 494 insertions(+), 571 deletions(-)
 delete mode 100644 arch/x86/platform/efi/early_printk.c
 create mode 100644 drivers/firmware/efi/earlycon.c
