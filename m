From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v5sub3 0/4] arm64: KASLR: EFI stub part
Date: Wed, 10 Feb 2016 18:55:01 +0100
Message-ID: <1455126905-22688-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This subseries contains the EFI stub specific changes of my KASLR series
for arm64. The original v4 series can be found here:
http://thread.gmane.org/gmane.linux.kernel/2135931

This series consists of the patches that result in the kernel to be allocated
at a random physical offset on UEFI systems that implement the EFI_RNG_PROTOCOL
protocol (if so configured), and pass a random value in /chosen/kaslr-seed in
the device tree, to be used by the kernel proper to randomize the layout of
the kernel virtual address space.

Changes since v4:
- added R-b's from Matt and Kees (#2
- removed a redundant efi_status_t initializer (#2)
- fixed an issue in update_fdt() (#4) where 'int status' was mistaken for a
  efi_status_t

Patch #1 implements efi_get_random_bytes() based on the EFI_RNG_PROTOCOL

Patch #2 implements efi_random_alloc()

Patch #3 moves the allocation for the converted command line (UTF-16 to ASCII)
away from the base of memory. This is necessary since for parsing the command
line before allocating the kernel image.

Patch #4 implements the actual KASLR, by randomizing the kernel physical
address, and passing entropy in /chosen/kaslr-seed so that the kernel proper can
relocate itself virtually.

Ard Biesheuvel (4):
  efi: stub: implement efi_get_random_bytes() based on EFI_RNG_PROTOCOL
  efi: stub: add implementation of efi_random_alloc()
  efi: stub: use high allocation for converted command line
  arm64: efi: invoke EFI_RNG_PROTOCOL to supply KASLR randomness

 arch/arm64/Kconfig                             |   5 +
 arch/x86/include/asm/efi.h                     |   2 +
 drivers/firmware/efi/libstub/Makefile          |   2 +-
 drivers/firmware/efi/libstub/arm-stub.c        |  40 ++++--
 drivers/firmware/efi/libstub/arm64-stub.c      |  78 +++++++----
 drivers/firmware/efi/libstub/efi-stub-helper.c |   7 +-
 drivers/firmware/efi/libstub/efistub.h         |   7 +
 drivers/firmware/efi/libstub/fdt.c             |  14 ++
 drivers/firmware/efi/libstub/random.c          | 135 ++++++++++++++++++++
 include/linux/efi.h                            |   5 +-
 10 files changed, 257 insertions(+), 38 deletions(-)
 create mode 100644 drivers/firmware/efi/libstub/random.c

-- 
2.5.0
