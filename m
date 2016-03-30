From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 0/5] UEFI: memory attribute table support
Date: Wed, 30 Mar 2016 18:38:48 +0200
Message-ID: <1459355933-13529-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org
Cc: catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This implements ARM/arm64 support for dealing with the UEFI memory attribute
table, which allows the OS to map UEFI Runtime Services regions with stricter
permissions.

I have tried to implement the early discovery and validation of the table
as generically as possible. I think it should be reusable on x86 as well,
but I haven't tried myself. Note that this also depends on the way we
deal with the reservation of BootServicesData regions going forward.

Note that for 32-bit ARM, this depends on [1], which addresses an issue
with memremap() on that architecture

Patches #1 and #2 implement support for the EFI_MEMORY_RO and EFI_MEMORY_XP
attributes, and as it turns out, this code supports both the (obsolete)
PropertiesTable and the new Memory Attributes table, so I moved them to the
beginning of the series.

Patch #3 adds the GUID and type definitions for the memory attributes table.

Patch #4 implements the generic handling of the table.

Patch #5 wires it up for ARM and arm64.

Changes since v1:
- incorporate feedback from Matt (patches #2 and #4)
- rebased onto v4.6-rc1

[1] http://thread.gmane.org/gmane.linux.ports.arm.kernel/488476

Ard Biesheuvel (5):
  ARM: efi: apply strict permissons for UEFI Runtime Services regions
  arm64: efi: apply strict permissons for UEFI Runtime Services regions
  efi: add support for the EFI_MEMORY_ATTRIBUTES_TABLE config table
  efi: implement generic support for the Memory Attributes table
  arm*: efi: take the Memory Attributes table into account

 arch/arm/include/asm/efi.h         |   1 +
 arch/arm/kernel/efi.c              |  41 +++++
 arch/arm64/include/asm/efi.h       |   2 +
 arch/arm64/kernel/efi.c            |  54 +++++--
 drivers/firmware/efi/Makefile      |   2 +-
 drivers/firmware/efi/arm-init.c    |   1 +
 drivers/firmware/efi/arm-runtime.c |   3 +
 drivers/firmware/efi/efi.c         |   2 +
 drivers/firmware/efi/memattr.c     | 170 ++++++++++++++++++++
 include/linux/efi.h                |  26 +++
 10 files changed, 287 insertions(+), 15 deletions(-)
 create mode 100644 drivers/firmware/efi/memattr.c

-- 
2.5.0
