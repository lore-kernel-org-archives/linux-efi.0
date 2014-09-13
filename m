From: Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 0/6] Warn about illegal accesses to EFI_BOOT_SERVICES_* memory
Date: Sat, 13 Sep 2014 11:36:10 -0700
Message-ID: <1410633376-8822-1-git-send-email-ricardo.neri-calderon@linux.intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Glenn P. Williamson" <glenn.p.williamson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The UEFI specification states that the firmware shall not access the
BOOT_SERVICES_DATA/CODE * memory regions after the operating system has
called ExitBootServices on it. Thus, the operating system is free to use
such regions as it sees fit. Still, buggy UEFI firmware implementations
may want to keep accessing these regions.

The current approach of the kernel is to reserve and map the
EFI_BOOT_SERVICES_* regions until efi_free_boot_services() is called
(after calling SetVirtualAddressMap() on the firmware). Further details
are show in the commit 916f676f8dc0 ("x86, efi: Retain boot service code
until after switching to virtual mode") by Matthew Garrett.

A drawback of the current approach is that silently working around this
kind of illegal accesses encourages the perpetuation of these bugs in
UEFI firmware implementations. Rather, this set of patches proposes a
more verbose behavior: continue reserving the EFI_BOOT_SERVICES_* regions
but not map them. If they are not mapped, any access will cause a page
fault that we can catch. Once the fault is catched, the kernel will fix
it up (i.e., map the page for the firmware to use it) and, more important,
complain about it.

We are guaranteed to not have false positives (i.e., page faults caused
by bad kernel code) as these memory regions are still reserved.

Besides fixing up the illegal accesses, no further action is required to
update the memory map the firmware sees. This is true because after boot,
the firmware would require access to the runtime services memory only,
which should be mapped before calling SetVirtualAddressMap. Furthermore,
a second attempt to update the virtual address map will result in a
EFI_UNSUPPORTED from the firmware, as per the UEFI specification.

Also, there is no need to update the system table as it should have been
when mapping the rest of the memory regions.

Finally, kexec is concerned only about the runtime services memory
sections. Thus we don't need any special arrangements for kexec.

The four last patches of the set implement this approach. The first two
provide a rework for code reuse of the convenience functions that look
for the descriptor of a physical memory address when then be used by the
proposed solution.

Ricardo Neri (6):
  x86/efi: Add function to obtain mem descriptor from phys address
  x86/efi: Use efi_memory_descriptor in mem convenience functions
  x86/efi: Add function to fixup page faults in BOOT_SERVICES_* regions
  x86/efi: Remove __init attribute from memory mapping functions
  yx86/efi: Fixup faults from UEFI firmware
  x86/efi: Introduce EFI_BOOT_SERVICES_WARN

 arch/x86/Kconfig               | 12 ++++++++
 arch/x86/include/asm/efi.h     |  4 +--
 arch/x86/mm/fault.c            |  8 +++++
 arch/x86/platform/efi/efi.c    | 66 ++++++++++++++++++++++++++++++++----------
 arch/x86/platform/efi/efi_32.c |  2 +-
 arch/x86/platform/efi/efi_64.c |  8 ++---
 drivers/firmware/efi/efi.c     | 36 ++++++++++-------------
 include/linux/efi.h            |  9 ++++++
 8 files changed, 101 insertions(+), 44 deletions(-)

-- 
1.9.1
