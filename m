From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v4 0/8] stable UEFI virtual mappings for kexec
Date: Mon, 22 Dec 2014 10:58:56 +0000
Message-ID: <1419245944-2424-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, geoff.levand-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This is v4 of the series to update the UEFI memory map handling for the arm64
architecture so that virtual mappings of UEFI Runtime Services are stable across
kexec.

To de-risk the adoption of the subset of patches that are essential to get kexec
working on UEFI systems, in this v4 I dropped all the patches related to the
iomem resource table, /dev/mem permissions and memory attributes etc. These
topics will be revisited asap in a separate series.

The primary changes with respect to v3 in the patches that were kept are:
- instead of reording the memory map so that part of it can double as input
  argument to SetVirtualAddressMap(), increase the allocation size for the
  memory map so that we can use some of it as scratch space and use that to
  prepare the input to SVAM() instead.
- added some acks
- rebased onto v3.19-rc1

NOTE: these changes trigger an issue on AMD Seattle that we (Mark Rutland and I)
consider a firmware bug. It appears that, during the call to SVAM() (which is
called with a 1:1 mapping as per the UEFI spec) the virtual mapping being
installed is dereferenced prematurely. This went unnoticed in the original
situation, as the virtual mappings were just kernel mappings that are always
accessible. However, in the new situation, those mappings are only active
during Runtime Service invocations, and performing any kind of access through
them at any other time triggers a fault.

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

Ard Biesheuvel (8):
  arm64/mm: add explicit struct_mm argument to __create_mapping()
  arm64/mm: add create_pgd_mapping() to create private page tables
  efi: split off remapping code from efi_config_init()
  efi: efistub: allow allocation alignment larger than EFI_PAGE_SIZE
  arm64/efi: set EFI_ALLOC_ALIGN to 64 KB
  arm64/efi: move SetVirtualAddressMap() to UEFI stub
  arm64/efi: remove free_boot_services() and friends
  arm64/efi: remove idmap manipulations from UEFI code

 arch/arm64/include/asm/efi.h                   |  24 +-
 arch/arm64/include/asm/mmu.h                   |   5 +-
 arch/arm64/include/asm/pgtable.h               |   5 +
 arch/arm64/kernel/efi.c                        | 360 ++++++++-----------------
 arch/arm64/kernel/setup.c                      |   2 +-
 arch/arm64/mm/mmu.c                            |  60 ++---
 drivers/firmware/efi/efi.c                     |  49 ++--
 drivers/firmware/efi/libstub/efi-stub-helper.c |  25 +-
 drivers/firmware/efi/libstub/fdt.c             | 137 +++++++++-
 include/linux/efi.h                            |   2 +
 10 files changed, 348 insertions(+), 321 deletions(-)

-- 
1.8.3.2
