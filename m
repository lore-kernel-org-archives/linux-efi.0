From: Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH 0/4] arm: [U]EFI runtime services support
Date: Tue, 25 Jun 2013 19:10:59 +0100
Message-ID: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-efi@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, hpa@linux.intel.com, tglx@linutronix.de, matt.fleming@intel.com, Leif Lindholm <leif.lindholm@linaro.org>
List-Id: linux-efi@vger.kernel.org

In systems based on [U]EFI-conformant firmware, runtime services provide
a standardised way for the kernel to update firmware environment variables.
This is used for example by efibootmgr to update which image should be
loaded on next boot.

This patchset implements basic support for UEFI runtime services on ARM
platforms, as well as the basic underlying EFI support. It also defines a
mechanism by which the required information is passed from the bootloader
to the kernel via FDT entries.

This patchset depends on the previously submitted early_ioremap() patchset.

Leif Lindholm (4):
  Documentation: arm: [U]EFI runtime services
  x86: efi: break efi_lookup_mapped_addr out to generic code
  arm: Add [U]EFI runtime services support
  init: efi: arm: enable (U)EFI runtime services on arm

 Documentation/arm/00-INDEX        |    3 +
 Documentation/arm/uefi.txt        |   39 ++++
 arch/arm/Kconfig                  |   15 ++
 arch/arm/include/asm/efi.h        |   22 ++
 arch/arm/kernel/Makefile          |    2 +
 arch/arm/kernel/efi.c             |  456 +++++++++++++++++++++++++++++++++++++
 arch/arm/kernel/efi_phys.S        |   59 +++++
 arch/arm/kernel/setup.c           |    5 +
 arch/x86/platform/efi/efi.c       |   28 ---
 drivers/firmware/efi/Makefile     |    2 +-
 drivers/firmware/efi/efi-helper.c |   33 +++
 init/main.c                       |    6 +
 12 files changed, 641 insertions(+), 29 deletions(-)
 create mode 100644 Documentation/arm/uefi.txt
 create mode 100644 arch/arm/include/asm/efi.h
 create mode 100644 arch/arm/kernel/efi.c
 create mode 100644 arch/arm/kernel/efi_phys.S
 create mode 100644 drivers/firmware/efi/efi-helper.c

-- 
1.7.10.4
