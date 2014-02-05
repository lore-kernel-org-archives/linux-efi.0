From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 00/22] arm/arm64: UEFI stubs + runtime services
Date: Wed,  5 Feb 2014 17:03:51 +0000
Message-ID: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This is a combined set of patches for the arm and arm64 kernel
support for UEFI firmware.

The set depends on the following prerequisite sets:
- Laura Abbott's 'Remove ARM meminfo'
- Matt Fleming's 'Move facility flags to struct efi'
- Mark Salter's  'Generic fixmap'
- Mark Salter's  'Generic early_ioremap'
- Mark Salter's  'EFI memory map iteration helper'

All of these are held on top of 3.14-rc1, with the patches in this set,
in git://git.linaro.org/people/leif.lindholm/linux.git, rebasing branch
uefi-for-upstream.

New in this version:
- Much more stub code shared arm/arm64.
- Stub looks in configuration tables for DT.
- Stub creates empty DT if none found/specified.
- Stub ignores dtb= option when UEFI Secure Boot active.
- Stub deletes any memory nodes in DT.
- Kernel sets up available RAM for memblock from UEFI memory map.
  (So no longer need different DTs or command line parameters for
   otherwise identical platforms with different amounts of RAM.)
- arm64 now compatible with 64K pages (with 4K UEFI page size).
- Fix mapping of runtime mmio regions on arm64.
- Reworked update_sctlr asm macro.
- Various cleanup and style fixes.

---

Ard Biesheuvel (1):
  arm: efistub: ignore dtb= when UEFI SecureBoot is enabled

H. Peter Anvin (1):
  Improve cmdline conversion

Leif Lindholm (6):
  arm: break part of __soft_restart out into separate function
  arm: add new asm macro update_sctlr
  Documentation: arm: add UEFI support documentation
  arm: Add [U]EFI runtime services support
  init: efi: arm: enable (U)EFI runtime services on arm
  arm: update boot/compressed/.gitignore

Mark Salter (6):
  efi: add helper function to get UEFI params from FDT
  lib: add fdt_empty_tree.c
  arm64: Add function to create identity mappings
  arm64: add EFI stub
  doc: arm64: add description of EFI stub support
  arm64: add EFI runtime services

Roy Franz (8):
  efi-stub.txt updates for ARM
  Add shared printk wrapper for consistent prefixing
  Add helper functions used by arm/arm64
  Add shared FDT related functions for ARM/ARM64
  Add strstr to compressed string.c for ARM.
  Add shared arm/arm64 EFI stub
  Add EFI stub for ARM
  Disable stack protection for decompressor/stub

 Documentation/arm/00-INDEX             |    3 +
 Documentation/arm/uefi.txt             |   64 +++++
 Documentation/arm64/booting.txt        |    4 +
 Documentation/efi-stub.txt             |   33 ++-
 arch/arm/Kconfig                       |   27 ++
 arch/arm/boot/compressed/.gitignore    |    3 +
 arch/arm/boot/compressed/Makefile      |   19 +-
 arch/arm/boot/compressed/efi-header.S  |  117 ++++++++
 arch/arm/boot/compressed/efi-stub.c    |  118 ++++++++
 arch/arm/boot/compressed/efi-stub.h    |    5 +
 arch/arm/boot/compressed/head.S        |   83 +++++-
 arch/arm/boot/compressed/string.c      |   21 ++
 arch/arm/include/asm/assembler.h       |   14 +
 arch/arm/include/asm/idmap.h           |    1 +
 arch/arm/include/asm/uefi.h            |   28 ++
 arch/arm/kernel/Makefile               |    2 +
 arch/arm/kernel/process.c              |   12 +-
 arch/arm/kernel/setup.c                |    7 +-
 arch/arm/kernel/uefi.c                 |  413 ++++++++++++++++++++++++++++
 arch/arm/kernel/uefi_phys.S            |   69 +++++
 arch/arm/mm/idmap.c                    |   15 ++
 arch/arm64/Kconfig                     |   26 ++
 arch/arm64/include/asm/efi.h           |   12 +
 arch/arm64/include/asm/mmu.h           |    2 +
 arch/arm64/kernel/Makefile             |    4 +
 arch/arm64/kernel/efi-entry.S          |   93 +++++++
 arch/arm64/kernel/efi-stub.c           |   67 +++++
 arch/arm64/kernel/efi.c                |  462 ++++++++++++++++++++++++++++++++
 arch/arm64/kernel/head.S               |  112 ++++++++
 arch/arm64/kernel/setup.c              |    3 +
 arch/arm64/mm/mmu.c                    |   66 +++--
 arch/x86/boot/compressed/eboot.c       |    3 +-
 drivers/firmware/efi/Kconfig           |    7 +
 drivers/firmware/efi/arm-stub.c        |  146 ++++++++++
 drivers/firmware/efi/efi-stub-helper.c |  199 +++++++++++---
 drivers/firmware/efi/efi.c             |   79 ++++++
 drivers/firmware/efi/fdt.c             |  268 ++++++++++++++++++
 include/linux/efi.h                    |   12 +
 init/main.c                            |    5 +
 lib/Makefile                           |    3 +-
 lib/fdt_empty_tree.c                   |    2 +
 41 files changed, 2534 insertions(+), 95 deletions(-)
 create mode 100644 Documentation/arm/uefi.txt
 create mode 100644 arch/arm/boot/compressed/efi-header.S
 create mode 100644 arch/arm/boot/compressed/efi-stub.c
 create mode 100644 arch/arm/boot/compressed/efi-stub.h
 create mode 100644 arch/arm/include/asm/uefi.h
 create mode 100644 arch/arm/kernel/uefi.c
 create mode 100644 arch/arm/kernel/uefi_phys.S
 create mode 100644 arch/arm64/include/asm/efi.h
 create mode 100644 arch/arm64/kernel/efi-entry.S
 create mode 100644 arch/arm64/kernel/efi-stub.c
 create mode 100644 arch/arm64/kernel/efi.c
 create mode 100644 drivers/firmware/efi/arm-stub.c
 create mode 100644 drivers/firmware/efi/fdt.c
 create mode 100644 lib/fdt_empty_tree.c

-- 
1.7.10.4
