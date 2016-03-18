From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 0/9] EFI framebuffer support for ARM and arm64
Date: Fri, 18 Mar 2016 17:47:32 +0100
Message-ID: <1458319661-19762-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, linux@arm.linux.org.uk, pjones@redhat.com, dh.herrmann@gmail.com
Cc: leif.lindholm@linaro.org, mark.rutland@arm.com, x86@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

This series adds support to ARM and arm64 for using the kernel's EFI
framebuffer driver to drive EFI Graphics Output Protocol (GOP) based
framebuffers.

This involves refactoring some of the existing x86 code so it can be reused
by ARM and arm64, and wiring it up both in the UEFI stub and in the core
kernel into the existing UEFI infrastructure for ARM and arm64.

Changes since v1:
- don't use const efi_guid_t and subsequently cast away constness
- update first, then move the x86 GOP code rather than creating a copy
  and update at the same time, and delete the x86 code later: this should
  make it easier to spot changes to the code that affect its correct operation
  on x86
- refactor the ARM changes so that the config table creation and consumption
  is introduced in the same patch (including the prototype changes for the
  install_configuration_table() boot service function pointer)
- use true/false rather than 1/0
- split stub changes into 32-bit arm/64-bit arm/common arm
- split platform device changes from platform driver changes (latter is
  basically only a Kconfig change)

Ard Biesheuvel (9):
  efi/x86: prepare GOP handling code for reuse as generic code
  efi: libstub: move Graphics Output Protocol handling to generic code
  efi/x86: efifb: move DMI based quirks handling out of generic code
  efi: efifb: use builtin_platform_driver and drop unused includes
  efi/arm64: libstub: make screen_info accessible to the UEFI stub
  efi/arm: libstub: make screen_info accessible to the UEFI stub
  efi/arm*: libstub: wire up GOP protocol to struct screen_info
  efi/arm*: wire up struct screen_info to efi-framebuffer platform
    device
  efifb: enable the efi-framebuffer platform driver for ARM and arm64

 arch/arm/include/asm/efi.h                |  11 +-
 arch/arm/kernel/setup.c                   |   3 +-
 arch/arm64/include/asm/efi.h              |  11 +-
 arch/arm64/kernel/efi.c                   |   3 +
 arch/arm64/kernel/image.h                 |   1 +
 arch/x86/boot/compressed/eboot.c          | 308 +----------------
 arch/x86/boot/compressed/eboot.h          |  74 ----
 arch/x86/include/asm/efi.h                |   7 +
 arch/x86/kernel/sysfb_efi.c               |  15 +
 drivers/firmware/efi/arm-init.c           |  48 ++-
 drivers/firmware/efi/efi.c                |   5 +-
 drivers/firmware/efi/libstub/Makefile     |   2 +-
 drivers/firmware/efi/libstub/arm-stub.c   |  23 ++
 drivers/firmware/efi/libstub/arm32-stub.c |  37 ++
 drivers/firmware/efi/libstub/gop.c        | 354 ++++++++++++++++++++
 drivers/video/fbdev/Kconfig               |   2 +-
 drivers/video/fbdev/efifb.c               |  21 +-
 include/linux/efi.h                       |  97 +++++-
 18 files changed, 615 insertions(+), 407 deletions(-)
 create mode 100644 drivers/firmware/efi/libstub/gop.c

-- 
2.5.0
