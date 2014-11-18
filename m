From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 00/13] arm64: stable UEFI mappings for kexec
Date: Tue, 18 Nov 2014 13:56:59 +0100
Message-ID: <1416315432-8534-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, geoff.levand-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This is v3 of the series to update the UEFI memory map handling for the arm64
architecture so that:
- virtual mappings of UEFI Runtime Services are stable across kexec
- userland mappings via /dev/mem use cache attributes that are compatible with
  the memory type of the UEFI memory map entry
- code that can be reused for 32-bit ARM is moved to a common area.

This time, I tried to address the following concerns:
- raised by Mark Salter, regarding the use of page_is_ram() in ACPI code, and
  the ability to infer memory attributes from it;
- raised by Mark Rutland, regarding the need to address the non-EFI case as
  well.

The general idea is to make more use of the iomem resource table. In this
series, instead of not installing memblocks for reserved regions, they are
installed using memblock_add() directly (which is page size agnostic, and so
doesn't do any rounding), which is closer to Mark Salter's original approach,
only now, there is no need to deal with the unaligned residues. As a result, all
memory with the EFI_MEMORY_WB attribute is covered by a 'System RAM' iomem
resource, which makes page_is_ram() work as expected again.

Then, in addition to memblock_reserve()'ing the RAM regions reserved by UEFI,
they are memblock_remove()'d as well, but only after the 'System RAM' regions
have been set up by the existing code. This way, we can wire up pfn_valid() and
page_is_ram() so that the former will tell us whether the kernel may actually be
using a pfn, whereas the latter will tell us whether it needs to be mapped
MT_NORMAL. This greatly simplifies the /dev/mem handling under
CONFIG_STRICT_DEVMEM, and unifies the EFI and non-EFI cases.

All UEFI memory regions are installed as iomem resources themselves. This helps
prevent drivers from attaching to devices that are also driven by the firmware,
but regions subordinate to 'System RAM' are also added. This is an example taken
from QEMU/mach-virt:

04000000-07ffffff : UEFI Runtime I/O
09000000-09000fff : /pl011@9000000
  09000000-09000fff : uart-pl011
09010000-09010fff : UEFI Runtime I/O
0a000000-0a0001ff : a000000.virtio_mmio
[...]
0a003e00-0a003fff : a003e00.virtio_mmio
40000000-bfffffff : System RAM
  40080000-406ff1e3 : Kernel code
  4073d000-407e4fff : Kernel data
  b711d000-b71dffff : UEFI Reserved
  bfb21000-bfb34fff : UEFI Reserved
  bfb35000-bfb66fff : UEFI Reserved
  bfb6a000-bfb6afff : UEFI Reserved
  bfb82000-bfb82fff : UEFI Reserved

MMIO regions without the EFI_MEMORY_RUNTIME attribute will be registered as
'UEFI Reserved', non-busy and non-exclusive, so drivers (and /dev/mem) can still
bind to them.

Changes with respect to v2:
- removed EFI specific memory attribute handling from virtmap.c
- added iomem resource handling
- make /dev/mem handling EFI-agnostic
- added two patches to round up allocations done by the stub to 64 KB; this is
  not strictly necessary now that we are using memblock_add() directly, but it
  is an improvement for arm64 regardless.

============== v1 blurb ==================

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

Ard Biesheuvel (13):
  arm64/mm: add explicit struct_mm argument to __create_mapping()
  arm64/mm: add create_pgd_mapping() to create private page tables
  arm64: improve CONFIG_STRICT_DEVMEM handling
  efi: split off remapping code from efi_config_init()
  efi: add common infrastructure for stub-installed virtual mapping
  efi: register iomem resources for UEFI reserved regions
  arm64/efi: move SetVirtualAddressMap() to UEFI stub
  arm64/efi: remove free_boot_services() and friends
  arm64/efi: remove idmap manipulations from UEFI code
  arm64/efi: use UEFI memory map unconditionally if available
  arm64/efi: use plain memblock API for adding and removing reserved RAM
  efi: efistub: allow allocation alignment larger than EFI_PAGE_SIZE
  arm64/efi: set EFI_ALLOC_ALIGN to 64 KB

 arch/arm64/Kconfig                             |   1 +
 arch/arm64/include/asm/efi.h                   |  20 +-
 arch/arm64/include/asm/mmu.h                   |   5 +-
 arch/arm64/include/asm/pgtable.h               |   5 +
 arch/arm64/kernel/efi.c                        | 331 +++----------------------
 arch/arm64/kernel/setup.c                      |   2 +-
 arch/arm64/mm/mmap.c                           |   5 +-
 arch/arm64/mm/mmu.c                            |  75 +++---
 drivers/firmware/efi/Kconfig                   |   3 +
 drivers/firmware/efi/Makefile                  |   1 +
 drivers/firmware/efi/efi.c                     |  49 ++--
 drivers/firmware/efi/libstub/efi-stub-helper.c |  25 +-
 drivers/firmware/efi/libstub/fdt.c             | 107 +++++++-
 drivers/firmware/efi/virtmap.c                 | 173 +++++++++++++
 include/linux/efi.h                            |  14 +-
 15 files changed, 447 insertions(+), 369 deletions(-)
 create mode 100644 drivers/firmware/efi/virtmap.c

-- 
1.8.3.2
