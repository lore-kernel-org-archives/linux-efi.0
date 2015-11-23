From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 00/13] UEFI boot and runtime services support for 32-bit ARM
Date: Mon, 23 Nov 2015 10:06:20 +0100
Message-ID: <1448269593-20758-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, kuleshovmail-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, ryan.harkin-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This series adds support for booting the 32-bit ARM kernel directly from
UEFI firmware using a builtin UEFI stub. It mostly reuses refactored arm64
code, and the differences (primarily the PE/COFF header and entry point and
the efi_create_mapping() implementation) are split out into arm64 and ARM
versions.

Changes since v2:
- Some issues pointed out by Russell and Matt that were not introduced by this
  series but merely became apparent due to the code movement in patch #4 have
  been addressed in a separate 2-piece series I sent out this morning. This v3
  is rebased on top of those patches.
- Added a patch (#9) that adds support for creating non-global mappings. This
  addresses a concern raised by Russell in response to v2 where the use of
  global mappings combined with a flawed context switch and TBL flush sequence
  could result in memory corruption.
- Rebased onto v4.4-rc2

Changes since v1:
- The primary difference between this version and the first one is that all
  prerequisites have either been merged, dropped for now (early FDT handling)
  or folded into this series (MEMBLOCK_NOMAP). IOW, this series can be applied
  on top of v4.4-rc1 directly.
- Dropped handling of UEFI permission bits. The reason is that the UEFIv2.5
  approach (EFI_PROPERTIES_TABLE) is flawed, and will be replaced by something
  better in the next version of the spec.

Patch #1 adds support for the MEMBLOCK_NOMAP attribute to the generic memblock
code. Its purpose is to annotate memory regions as normal memory even if they
are removed from the kernel direct mapping.

Patch #2 implements MEMBLOCK_NOMAP support for arm64

Patch #3 updates the EFI init code to remove UEFI reserved regions and regions
used by runtime services from the kernel direct mapping

Patch #4 splits off most of arch/arm64/kernel/efi.c into arch agnostic files
arm-init.c and arm-runtime.c under drivers/firmware/efi.

Patch #5 refactors the code split off in patch #1 to isolate the arm64 specific
pieces, and change a couple of arm64-isms that ARM handles slightly differently.

Patch #6 enables the generic early_ioremap and early_memremap implementations
for ARM. It reuses the kmap fixmap region, which is not used that early anyway.

Patch #7 splits off the core functionality of create_mapping() into a new
function __create_mapping() that we can reuse for mapping UEFI runtime regions.

Patch #8 factors out the early_alloc() routine so we can invoke __create_mapping
using another (late) allocator.

Patch #9 adds support to __create_mapping() for creating non-global translation
table entries. (new in v3)

Patch #10 implements create_mapping_late() that uses a late allocator.

Patch #11 implements MEMBLOCK_NOMAP support for ARM

Patch #12 implements the UEFI support in the kernel proper to probe the UEFI
memory map and map the runtime services.

Patch #13 ties together all of the above, by implementing the UEFI stub, and
introducing the Kconfig symbols that allow all of this to be built.

Instructions how to build and run the 32-bit ARM UEFI firmware can be found here:
https://wiki.linaro.org/LEG/UEFIforQEMU
Ard Biesheuvel (12):
  mm/memblock: add MEMBLOCK_NOMAP attribute to memblock memory table
  arm64: only consider memblocks with NOMAP cleared for linear mapping
  arm64/efi: mark UEFI reserved regions as MEMBLOCK_NOMAP
  arm64/efi: split off EFI init and runtime code for reuse by 32-bit ARM
  arm64/efi: refactor EFI init and runtime code for reuse by 32-bit ARM
  ARM: add support for generic early_ioremap/early_memremap
  ARM: split off core mapping logic from create_mapping
  ARM: factor out allocation routine from __create_mapping()
  ARM: add support for non-global kernel mappings
  ARM: implement create_mapping_late() for EFI use
  ARM: only consider memblocks with NOMAP cleared for linear mapping
  ARM: wire up UEFI init and runtime support

Roy Franz (1):
  ARM: add UEFI stub support

 arch/arm/Kconfig                          |  20 ++
 arch/arm/boot/compressed/Makefile         |   4 +-
 arch/arm/boot/compressed/efi-header.S     | 130 ++++++++
 arch/arm/boot/compressed/head.S           |  54 +++-
 arch/arm/boot/compressed/vmlinux.lds.S    |   7 +
 arch/arm/include/asm/Kbuild               |   1 +
 arch/arm/include/asm/efi.h                |  83 +++++
 arch/arm/include/asm/fixmap.h             |  29 +-
 arch/arm/include/asm/mach/map.h           |   2 +
 arch/arm/include/asm/mmu_context.h        |   2 +-
 arch/arm/kernel/Makefile                  |   1 +
 arch/arm/kernel/efi.c                     |  38 +++
 arch/arm/kernel/setup.c                   |  10 +-
 arch/arm/mm/init.c                        |   5 +-
 arch/arm/mm/ioremap.c                     |   9 +
 arch/arm/mm/mmu.c                         | 128 +++++---
 arch/arm64/include/asm/efi.h              |   9 +
 arch/arm64/kernel/efi.c                   | 342 ++------------------
 arch/arm64/mm/init.c                      |   2 +-
 arch/arm64/mm/mmu.c                       |   2 +
 drivers/firmware/efi/Makefile             |   4 +
 drivers/firmware/efi/arm-init.c           | 209 ++++++++++++
 drivers/firmware/efi/arm-runtime.c        | 135 ++++++++
 drivers/firmware/efi/efi.c                |   2 +
 drivers/firmware/efi/libstub/Makefile     |   9 +
 drivers/firmware/efi/libstub/arm-stub.c   |   4 +-
 drivers/firmware/efi/libstub/arm32-stub.c |  85 +++++
 include/linux/memblock.h                  |   8 +
 mm/memblock.c                             |  28 ++
 29 files changed, 990 insertions(+), 372 deletions(-)
 create mode 100644 arch/arm/boot/compressed/efi-header.S
 create mode 100644 arch/arm/include/asm/efi.h
 create mode 100644 arch/arm/kernel/efi.c
 create mode 100644 drivers/firmware/efi/arm-init.c
 create mode 100644 drivers/firmware/efi/arm-runtime.c
 create mode 100644 drivers/firmware/efi/libstub/arm32-stub.c

-- 
1.9.1
