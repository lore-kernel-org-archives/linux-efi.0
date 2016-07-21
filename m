From: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH V2 0/4] Handle EFI_INVALID_PARAMETER from ExitBootServices
Date: Thu, 21 Jul 2016 14:28:10 -0600
Message-ID: <1469132894-17103-1-git-send-email-jhugo@codeaurora.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

According to the UEFI spec, the UEFI OS Loader (aka the stub) should
transition from UEFI to the OS by getting the current memory map from UEFI,
then calling ExitBootServices.  The spec states that ExitBootServices may
return EFI_INVALID_PARAMETER if the memory map reference provided by the stub
is not current, ie UEFI handled some event prior to ExitBootServices which
modified the map.  The spec states that to handle this scenario, the stub shall
get the updated map, and invoke ExitBootServices again.  The spec also states
that once ExitBootServices is invoked, even if it returns error, the only
APIs the stub is allowed to invoke is GetMemoryMap and ExitBootServices.

The EFI_INVALID_PARAMETER scenario has been seen in the wild previously in
x86 but the fix - d3768d885c6c ("x86, efi: retry ExitBootServices() on failure")
still violates the spec.  The FDT code does not handle this scenario, but
instances of it are now observed.

This patch series aims to provide a spec complaint solution that can be reused
in all stubs, thus preventing each arch or variant from reinventing the wheel
and likely getting it wrong.

[V2]
-Define EFI_MMAP_NR_SLACK_SLOTS per Mark Rutland
-Use desc_size as firmware may exceed the defined struct size per Ard Biesheuvel

[V1]
-Allocate headspace on the memory map buffer for reuse per Ard Biesheuvel
-Create a shared helper address the issue universally per Matt Fleming

Jeffrey Hugo (4):
  efi/libstub: Allocate headspace in efi_get_memory_map()
  efi/libstub: Introduce ExitBootServices helper
  efi/libstub: Use efi_exit_boot_services() in FDT
  x86/efi: Use efi_exit_boot_services()

 arch/x86/boot/compressed/eboot.c               | 132 +++++++++++++------------
 drivers/firmware/efi/libstub/efi-stub-helper.c | 129 ++++++++++++++++++++++--
 drivers/firmware/efi/libstub/fdt.c             |  52 +++++++---
 drivers/firmware/efi/libstub/random.c          |   3 +-
 include/linux/efi.h                            |  22 ++++-
 5 files changed, 249 insertions(+), 89 deletions(-)

-- 
Qualcomm Datacenter Technologies as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
