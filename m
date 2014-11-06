From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 00/10] arm64: stable UEFI mappings for kexec
Date: Thu,  6 Nov 2014 15:13:16 +0100
Message-ID: <1415283206-14713-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This is v2 of the series to update the UEFI memory map handling for the arm64
architecture so that:
- virtual mappings of UEFI Runtime Services are stable across kexec
- userland mappings via /dev/mem use cache attributes that are compatible with
  the memory type of the UEFI memory map entry
- code that can be reused for 32-bit ARM is moved to a common area.

Changes since v2 are primarily the move of reusable infrastructure to
drivers/firmware/efi/virtmap.c, and the newly added handling of /dev/mem
mappings.

The main premise of these patches is that, in order to support kexec, we need
to add code to the kernel that is able to deal with the state of the firmware
after SetVirtualAddressMap() [SVAM] has been called. However, if we are going to
deal with that anyway, why not make that the default state, and have only a
single code path for both cases.

This means SVAM() needs to move to the stub, and hence the code that invents
the virtual layout needs to move with it. The result is that the kernel proper
is entered with the virt_addr members of all EFI_MEMORY_RUNTIME regions
assigned, and the mapping installed into the firmware. The kernel proper needs
to set up the page tables, and switch to them while performing the runtime
services calls. Note that there is also an efi_to_phys() to translate the values
of the fw_vendor and tables fields of the EFI system table. Again, this is
something we need to do anyway under kexec, or we end up handing over state
between one kernel and the next, which implies different code paths between
non-kexec and kexec.

The layout is chosen such that it used the userland half of the virtual address
space (TTBR0), which means no additional alignment or reservation is required
to ensure that it will always be available.

One thing that may stand out is the reordering of the memory map. The reason
for doing this is that we can use the same memory map as input to SVAM(). The
alternative is allocating memory for it using boot services, but that clutters
up the existing logic a bit between getting the memory map, populating the fdt,
and loop again if it didn't fit.

Ard Biesheuvel (10):
  arm64/mm: add explicit struct_mm argument to __create_mapping()
  arm64/mm: add create_pgd_mapping() to create private page tables
  efi: split off remapping code from efi_config_init()
  efi: add common infrastructure for stub-installed virtual mapping
  arm64/efi: move SetVirtualAddressMap() to UEFI stub
  arm64/efi: remove free_boot_services() and friends
  arm64/efi: remove idmap manipulations from UEFI code
  arm64/efi: use UEFI memory map unconditionally if available
  arm64/efi: ignore unusable regions instead of reserving them
  arm64/efi: improve /dev/mem mmap() handling under UEFI

 arch/arm64/Kconfig                 |   1 +
 arch/arm64/include/asm/efi.h       |  18 +-
 arch/arm64/include/asm/mmu.h       |   5 +-
 arch/arm64/include/asm/pgtable.h   |   5 +
 arch/arm64/kernel/efi.c            | 351 ++++++-------------------------------
 arch/arm64/kernel/setup.c          |   2 +-
 arch/arm64/mm/mmu.c                |  78 +++++----
 drivers/firmware/efi/Kconfig       |   3 +
 drivers/firmware/efi/Makefile      |   1 +
 drivers/firmware/efi/efi.c         |  49 ++++--
 drivers/firmware/efi/libstub/fdt.c | 107 ++++++++++-
 drivers/firmware/efi/virtmap.c     | 224 +++++++++++++++++++++++
 include/linux/efi.h                |  17 +-
 13 files changed, 496 insertions(+), 365 deletions(-)
 create mode 100644 drivers/firmware/efi/virtmap.c

-- 
1.8.3.2
