From: Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH v3 0/3] (U)EFI runtime services for arm
Date: Thu, 28 Nov 2013 16:41:20 +0000
Message-ID: <1385656883-4420-1-git-send-email-leif.lindholm@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux@arm.linux.org.uk
Cc: matt.fleming@intel.com, grant.likely@linaro.org, roy.franz@linaro.org, msalter@redhat.com, patches@linaro.org, linaro-uefi@linaro.org, mark.rutland@arm.com, Leif Lindholm <leif.lindholm@linaro.org>
List-Id: linux-efi@vger.kernel.org

In systems based on [U]EFI-conformant firmware, runtime services provide
a standardised way for the kernel to update firmware environment
variables. This is used for example by efibootmgr to update which image
should be loaded on next boot.

This patchset implements basic support for UEFI runtime services on ARM
platforms, as well as the basic underlying EFI support. It also defines
a mechanism by which the required information is passed from the
bootloader (the EFI stub submitted separately) to the kernel via FDT
entries.

This patchset depends on the presence of early_ioremap(). It has been
validated against Mark Salter's generic implementation.

Changes from v2:
- Updated FDT bindings.
- The EFI stub is now the only loader that will support the kernel
  enabling runtime services.
- Documentation updates.

Changes from v1:
- Updated FDT bindings, based on feedback.
- Use common config table scanning and address lookup code.
- Add dependency on !CPU_BIG_ENDIAN (for now).
- Add proper efi_enabled() facility.
- Documentation updates.


Leif Lindholm (3):
  Documentation: arm: add UEFI support documentation
  arm: Add [U]EFI runtime services support
  init: efi: arm: enable (U)EFI runtime services on arm

 Documentation/arm/00-INDEX  |    3 +
 Documentation/arm/uefi.txt  |   61 ++++++
 arch/arm/Kconfig            |   15 ++
 arch/arm/include/asm/uefi.h |   22 ++
 arch/arm/kernel/Makefile    |    2 +
 arch/arm/kernel/setup.c     |    6 +
 arch/arm/kernel/uefi.c      |  469 +++++++++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/uefi_phys.S |   59 ++++++
 include/linux/efi.h         |    2 +-
 init/main.c                 |    4 +
 10 files changed, 642 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/arm/uefi.txt
 create mode 100644 arch/arm/include/asm/uefi.h
 create mode 100644 arch/arm/kernel/uefi.c
 create mode 100644 arch/arm/kernel/uefi_phys.S

-- 
1.7.10.4
