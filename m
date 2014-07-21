From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [RFC PATCH 00/10] arm64: boot BE kernels from UEFI
Date: Mon, 21 Jul 2014 17:16:15 +0200
Message-ID: <1405955785-13477-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, victor.kamensky-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, steve.capper-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This series adds support for booting BE kernels from UEFI. As UEFI is defined to
be strictly little endian, some workarounds are required to combine a little
endian EFI stub with a big endian kernel. Also, runtime services need to be
wrapped so they can be executed in little endian mode.

Patches #1 and #2 have been sent to the list before, but are included for
completeness.

Patch #3, #4 and #5 modify the PE/COFF header definition so it is always
emitted in little endian, regardless of the endianness of the kernel.

Patch #6 removes references to linker defined symbols like _text and _edata
from the stub, as the stub is now a standalone little endian binary that is
wrapped in a big endian object file, and _text and _edata are unavailable
or meaningless in that context.

Patch #7 adds the Makefile changes and some code to build the standalone stub
and wrap it.

Patch #8 updates the kernel code that references data in UEFI memory to byte
reverse it if required.

Patch #9 adds runtime services wrappers for the variable store services so they
can be called from the big endian kernel. Other runtime services are not
implemented for now.

Patch #10 enables everything by adding the Kconfig logic.

This is tested on Foundation model and FVP Base model. Booting works fine on
both, however, enumerating the variable store works only on FVP Base, and is
not debuggable on Foundation Model, so I would really appreciate any insights
into the code in patch #9 that may be causing this. There is some trickery
regarding en-/disabling caches and MMU and surely I have gotten something
wrong there.

Ard Biesheuvel (10):
  arm64/efi: efistub: jump to 'stext' directly, not through the header
  arm64/efi: efistub: cover entire static mem footprint in PE/COFF .text
  arm64: add macros to emit little endian ASM constants
  arm64: add EFI little endian constants to linker script
  arm64/efi: update the PE/COFF header to be endian agnostic
  arm64/efi: efistub: avoid using linker defined constants
  arm64/efi: efistub: add support for booting a BE kernel
  arm64/efi: use LE accessors to access UEFI data
  arm64/efi: enable minimal UEFI Runtime Services for big endian
  arm64: Kconfig: enable UEFI on BE kernels

 arch/arm64/Kconfig                          |  10 ++-
 arch/arm64/include/asm/assembler.h          |  18 +++++
 arch/arm64/include/asm/efi.h                |   2 +
 arch/arm64/kernel/Makefile                  |   7 +-
 arch/arm64/kernel/efi-be-call.S             |  55 +++++++++++++++
 arch/arm64/kernel/efi-be-runtime.c          | 104 ++++++++++++++++++++++++++++
 arch/arm64/kernel/efi-entry.S               |  41 ++++++++---
 arch/arm64/kernel/efi-stub.c                |  11 ++-
 arch/arm64/kernel/efi.c                     |  68 +++++++++++-------
 arch/arm64/kernel/efistub-le/Makefile       |  52 ++++++++++++++
 arch/arm64/kernel/efistub-le/efi-le-entry.S |  13 ++++
 arch/arm64/kernel/efistub-le/efistub-le.lds |  35 ++++++++++
 arch/arm64/kernel/efistub-le/le.h           |  12 ++++
 arch/arm64/kernel/efistub-le/strstr.c       |  20 ++++++
 arch/arm64/kernel/head.S                    |  50 +++++++------
 arch/arm64/kernel/image.h                   |  16 ++++-
 drivers/firmware/efi/efi.c                  |  26 ++++---
 drivers/firmware/efi/efivars.c              |   2 +-
 drivers/firmware/efi/libstub/fdt.c          |   4 ++
 19 files changed, 466 insertions(+), 80 deletions(-)
 create mode 100644 arch/arm64/kernel/efi-be-call.S
 create mode 100644 arch/arm64/kernel/efi-be-runtime.c
 create mode 100644 arch/arm64/kernel/efistub-le/Makefile
 create mode 100644 arch/arm64/kernel/efistub-le/efi-le-entry.S
 create mode 100644 arch/arm64/kernel/efistub-le/efistub-le.lds
 create mode 100644 arch/arm64/kernel/efistub-le/le.h
 create mode 100644 arch/arm64/kernel/efistub-le/strstr.c

-- 
1.8.3.2
