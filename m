From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 00/10] arm64: UEFI support
Date: Fri,  4 Apr 2014 19:45:03 +0100
Message-ID: <1396637113-22790-1-git-send-email-leif.lindholm@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This set adds support for UEFI to the arm64 port - a stub loader, as
well as runtime services support for efivars.

It depends on some core EFI patches currently in linux-next.

This includes bits shared between arm and arm64 support.
Remaining bits required for arm support will be submitted separately.

Changes from previous version:
- Enter_virtual_mode() is now an early initcall.
- UEFI Reserved regions now preserved.
- Bugfix for dtb= support with SecureBoot.
- Stub now flushes instruction cache by address for kernel image area.
- CONFIG_EFI_STUB merged into CONFIG_EFI since they are interdependent.
- EFI_DEVICE_TREE_GUID renamed DEVICE_TREE_GUID.
- Minor cleanups.

Ard Biesheuvel (1):
  efi/arm64: ignore dtb= when UEFI SecureBoot is enabled

Leif Lindholm (1):
  doc: arm: add UEFI support documentation

Mark Salter (6):
  lib: add fdt_empty_tree.c
  efi: add helper function to get UEFI params from FDT
  arm64: Add function to create identity mappings
  arm64: efi: add EFI stub
  doc: arm64: add description of EFI stub support
  arm64: add EFI runtime services

Roy Franz (2):
  doc: efi-stub.txt updates for ARM
  efi: Add shared FDT related functions for ARM/ARM64

 Documentation/arm/00-INDEX             |    2 +
 Documentation/arm/uefi.txt             |   64 +++++
 Documentation/arm64/booting.txt        |    4 +
 Documentation/efi-stub.txt             |   33 ++-
 arch/arm64/Kconfig                     |   21 ++
 arch/arm64/include/asm/efi.h           |   14 +
 arch/arm64/include/asm/mmu.h           |    2 +
 arch/arm64/kernel/Makefile             |    3 +
 arch/arm64/kernel/efi-entry.S          |  100 +++++++
 arch/arm64/kernel/efi-stub.c           |   97 +++++++
 arch/arm64/kernel/efi.c                |  469 ++++++++++++++++++++++++++++++++
 arch/arm64/kernel/head.S               |  112 ++++++++
 arch/arm64/kernel/setup.c              |    5 +
 arch/arm64/mm/mmu.c                    |   65 +++--
 drivers/firmware/efi/Kconfig           |    7 +
 drivers/firmware/efi/arm-stub.c        |  255 +++++++++++++++++
 drivers/firmware/efi/efi-stub-helper.c |   24 ++
 drivers/firmware/efi/efi.c             |   79 ++++++
 drivers/firmware/efi/fdt.c             |  269 ++++++++++++++++++
 include/linux/efi.h                    |   12 +
 lib/Makefile                           |    3 +-
 lib/fdt_empty_tree.c                   |    2 +
 22 files changed, 1616 insertions(+), 26 deletions(-)
 create mode 100644 Documentation/arm/uefi.txt
 create mode 100644 arch/arm64/include/asm/efi.h
 create mode 100644 arch/arm64/kernel/efi-entry.S
 create mode 100644 arch/arm64/kernel/efi-stub.c
 create mode 100644 arch/arm64/kernel/efi.c
 create mode 100644 drivers/firmware/efi/arm-stub.c
 create mode 100644 drivers/firmware/efi/fdt.c
 create mode 100644 lib/fdt_empty_tree.c

-- 
1.7.10.4
