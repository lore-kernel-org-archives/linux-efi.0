From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 0/5] efistub: convert into static library
Date: Thu, 26 Jun 2014 16:23:32 +0200
Message-ID: <1403792617-25792-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This is v2 of the series to change the #include "../../../../xxx.c" pattern
into a static library linked into either the kernel (arm64) or a separate boot
decompressor (x86, ARM).

Changes since v1:
- added patch #1 to change EFI_ERROR, it is not a result code defined by UEFI so
  it should only be returned by get_dram_base() and efi_entry()
- added a section to libstub Makefile to clean CFLAGS of stack protecter and 
  other options that are inappropriate for the stub
- rebased onto the UEFI Runtime Services NEON patches (re)posted earlier today

Ard Biesheuvel (5):
  efi/arm64: avoid EFI_ERROR as a generic return code
  efi/x86: efistub: move shared dependencies to <asm/efi.h>
  efi/arm64: efistub: move shared dependencies to <asm/efi.h>
  efi: efistub: refactor stub components
  efi: efistub: convert into static library

 arch/arm64/Kconfig                                 |  1 +
 arch/arm64/Makefile                                |  1 +
 arch/arm64/include/asm/efi.h                       | 12 ++++
 arch/arm64/kernel/efi-stub.c                       | 47 +++-----------
 arch/x86/boot/compressed/Makefile                  |  3 +-
 arch/x86/boot/compressed/eboot.c                   | 20 ++----
 arch/x86/boot/compressed/eboot.h                   | 16 -----
 arch/x86/include/asm/efi.h                         | 25 ++++++++
 drivers/firmware/efi/Kconfig                       |  3 +
 drivers/firmware/efi/Makefile                      |  2 +-
 drivers/firmware/efi/libstub/Makefile              | 26 ++++++++
 drivers/firmware/efi/{ => libstub}/arm-stub.c      | 32 ++++++----
 .../firmware/efi/{ => libstub}/efi-stub-helper.c   | 74 +++++++++++-----------
 drivers/firmware/efi/libstub/efistub.h             | 42 ++++++++++++
 drivers/firmware/efi/{ => libstub}/fdt.c           | 20 +++---
 include/linux/efi.h                                | 42 ++++++++++++
 16 files changed, 238 insertions(+), 128 deletions(-)
 create mode 100644 drivers/firmware/efi/libstub/Makefile
 rename drivers/firmware/efi/{ => libstub}/arm-stub.c (93%)
 rename drivers/firmware/efi/{ => libstub}/efi-stub-helper.c (88%)
 create mode 100644 drivers/firmware/efi/libstub/efistub.h
 rename drivers/firmware/efi/{ => libstub}/fdt.c (94%)

-- 
1.8.3.2
