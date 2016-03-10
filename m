From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 0/8] EFI framebuffer support for ARM and arm64
Date: Thu, 10 Mar 2016 12:40:00 +0700
Message-ID: <1457588408-19309-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This series adds support to ARM and arm64 for using the kernel's EFI
framebuffer driver to drive EFI Graphics Output Protocol (GOP) based
framebuffers.

This involves refactoring some of the existing x86 code so it can be reused
by ARM and arm64, and wiring it up both in the UEFI stub and in the core
kernel into the existing UEFI infrastructure for ARM and arm64.

Ard Biesheuvel (8):
  efi: make install_configuration_table() boot service usable
  efi: libstub: move Graphics Output Protocol handling to generic code
  efi/x86: libstub: move to generic GOP code
  efi/x86: efifb: move DMI based quirks handling out of generic code
  efi: efifb: use builtin_platform_driver and drop unused includes
  efi/arm*: libstub: wire up GOP handling into the ARM UEFI stub
  efi/arm*: efifb: expose efifb platform device if GOP is available
  efi/arm: populate screen_info based on data provided by the UEFI stub

 arch/arm/include/asm/efi.h                |  20 +-
 arch/arm/kernel/efi.c                     |  24 ++
 arch/arm/kernel/setup.c                   |   3 +-
 arch/arm64/include/asm/efi.h              |  11 +-
 arch/arm64/kernel/efi.c                   |   3 +
 arch/arm64/kernel/image.h                 |   1 +
 arch/x86/boot/compressed/eboot.c          | 308 +----------------
 arch/x86/boot/compressed/eboot.h          |  74 ----
 arch/x86/include/asm/efi.h                |   7 +
 arch/x86/kernel/sysfb_efi.c               |  15 +
 drivers/firmware/efi/arm-init.c           |  25 ++
 drivers/firmware/efi/libstub/Makefile     |   2 +-
 drivers/firmware/efi/libstub/arm-stub.c   |  23 ++
 drivers/firmware/efi/libstub/arm32-stub.c |  38 +++
 drivers/firmware/efi/libstub/gop.c        | 354 ++++++++++++++++++++
 drivers/video/fbdev/Kconfig               |   2 +-
 drivers/video/fbdev/efifb.c               |  21 +-
 include/linux/efi.h                       |  89 ++++-
 18 files changed, 615 insertions(+), 405 deletions(-)
 create mode 100644 drivers/firmware/efi/libstub/gop.c

-- 
1.9.1
