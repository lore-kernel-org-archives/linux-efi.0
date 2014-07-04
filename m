From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 0/2] efi/arm64: FP/SIMD preserve/restore during UEFI Runtime Services
Date: Fri,  4 Jul 2014 19:41:51 +0200
Message-ID: <1404495713-10338-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Two patches to add FP/SIMD preserve/restore to UEFI Runtime Services:
- patch #1 moves runtime services wrappers to generic code so we can reuse them
  for arm64
- patch #2 enables the wrappers for arm64 and inserts calls to kernel_neon_begin
  and kernel_neon_end

@Matt: please queue up for 3.17

v3:
- improve commit message for patch #2 and add Catalin's ack

v2:
- add Kconfig symbol EFI_RUNTIME_WRAPPERS so we don't break ia64 by enabling it
  unconditionally

Ard Biesheuvel (2):
  efi/x86: move UEFI Runtime Services wrappers to generic code
  efi/arm64: preserve FP/SIMD registers on UEFI runtime services calls

 arch/arm64/Kconfig                      |   1 +
 arch/arm64/include/asm/efi.h            |  21 +++++
 arch/arm64/kernel/efi.c                 |  14 +--
 arch/x86/Kconfig                        |   1 +
 arch/x86/platform/efi/efi.c             | 144 +---------------------------
 drivers/firmware/efi/Kconfig            |   7 ++
 drivers/firmware/efi/Makefile           |   1 +
 drivers/firmware/efi/runtime-wrappers.c | 161 ++++++++++++++++++++++++++++++++
 include/linux/efi.h                     |   2 +
 9 files changed, 197 insertions(+), 155 deletions(-)
 create mode 100644 drivers/firmware/efi/runtime-wrappers.c

-- 
1.8.3.2
