From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 0/9] UEFI boot and runtime services support for 32-bit ARM
Date: Thu,  1 Oct 2015 19:04:14 +0200
Message-ID: <1443719063-6832-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org
Cc: ryan.harkin-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This series adds support for booting the 32-bit ARM kernel directly from
UEFI firmware using a builtin UEFI stub. It mostly reuses refactored arm64
code, and the differences (primarily the PE/COFF header and entry point and
the efi_create_mapping() implementation) are split out into arm64 and ARM
versions.

Patch #1 splits off most of arch/arm64/kernel/efi.c into arch agnostic files
arm-init.c and arm-runtime.c under drivers/firmware/efi.

Patch #2 refactors the code split off in patch #1 to isolate the arm64 specific
pieces, and change a couple of arm64-isms that ARM handles slightly differently.

Patch #3 enables the generic early_ioremap and early_memremap implementations
for ARM. It reuses the kmap fixmap region, which is not used that early anyway.

Patch #4 adds support to ARM for the MEMBLOCK_NOMAP region flag.

Patch #5 splits off the core functionality of create_mapping() into a new
function __create_mapping() that we can reuse for mapping UEFI runtime regions.

Patch #6 factors out the early_alloc() routine so we can invoke __create_mapping
using another (late) allocator.

Patch #7 implements create_mapping_late() that uses a late allocator.

Patch #8 implements the UEFI support in the kernel proper to probe the UEFI
memory map and map the runtime services.

Patch #9 ties together all of the above, by implementing the UEFI stub, and
introducing the Kconfig symbols that allow all of this to be built.

There are a number of prerequisites for this series that have all been sent to
the linux-arm-kernel mailing list at some point (and mostly ignored).

Matt Fleming's efi-next branch:
https://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/log/?h=next

arm64: EFI stub isolation:
http://thread.gmane.org/gmane.linux.kernel.efi/6414

arm64: remove UEFI reserved regions from linear mapping (aka MEMBLOCK_NOMAP)
http://thread.gmane.org/gmane.linux.kernel.mm/138474

arm64 UEFI early FDT handling
http://thread.gmane.org/gmane.linux.kernel.efi/6334

arm64/efi: adapt to UEFI 2.5 properties table changes
http://thread.gmane.org/gmane.linux.kernel.efi/5847

The complete series (including all prerequisites) can be found here:
https://git.linaro.org/people/ard.biesheuvel/linux-arm.git/shortlog/refs/heads/arm32-uefi-support

Instructions how to build and run the 32-bit ARM UEFI firmware can be found here:
https://wiki.linaro.org/LEG/UEFIforQEMU

Ard Biesheuvel (8):
  arm64/efi: split off EFI init and runtime code for reuse by 32-bit ARM
  arm64/efi: refactor EFI init and runtime code for reuse by 32-bit ARM
  ARM: add support for generic early_ioremap/early_memremap
  ARM: only consider memblocks with NOMAP cleared for linear mapping
  ARM: split off core mapping logic from create_mapping
  ARM: factor out allocation routine from __create_mapping()
  ARM: implement create_mapping_late() for EFI use
  ARM: wire up UEFI init and runtime support

Roy Franz (1):
  ARM: add UEFI stub support

 arch/arm/Kconfig                        |  20 +
 arch/arm/boot/compressed/Makefile       |   5 +-
 arch/arm/boot/compressed/efi-header.S   | 130 +++++++
 arch/arm/boot/compressed/efi-stub.c     |  89 +++++
 arch/arm/boot/compressed/head.S         |  54 ++-
 arch/arm/boot/compressed/vmlinux.lds.S  |   7 +
 arch/arm/include/asm/Kbuild             |   1 +
 arch/arm/include/asm/efi.h              |  92 +++++
 arch/arm/include/asm/fixmap.h           |  28 +-
 arch/arm/include/asm/mach/map.h         |   1 +
 arch/arm/kernel/Makefile                |   1 +
 arch/arm/kernel/devtree.c               |   4 +
 arch/arm/kernel/efi.c                   |  71 ++++
 arch/arm/kernel/setup.c                 |  10 +-
 arch/arm/mm/init.c                      |  16 +-
 arch/arm/mm/ioremap.c                   |   9 +
 arch/arm/mm/mmu.c                       | 110 ++++--
 arch/arm64/include/asm/efi.h            |  16 +
 arch/arm64/kernel/efi.c                 | 392 ++------------------
 drivers/firmware/efi/Makefile           |   4 +-
 drivers/firmware/efi/arm-init.c         | 215 +++++++++++
 drivers/firmware/efi/arm-runtime.c      | 148 ++++++++
 drivers/firmware/efi/efi.c              |   4 +-
 drivers/firmware/efi/libstub/Makefile   |  12 +
 drivers/firmware/efi/libstub/arm-stub.c |   4 +-
 25 files changed, 1046 insertions(+), 397 deletions(-)
 create mode 100644 arch/arm/boot/compressed/efi-header.S
 create mode 100644 arch/arm/boot/compressed/efi-stub.c
 create mode 100644 arch/arm/include/asm/efi.h
 create mode 100644 arch/arm/kernel/efi.c
 create mode 100644 drivers/firmware/efi/arm-init.c
 create mode 100644 drivers/firmware/efi/arm-runtime.c

-- 
1.9.1
