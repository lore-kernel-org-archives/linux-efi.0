From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 00/10] arm64 EFI patches for 3.19
Date: Tue, 28 Oct 2014 17:18:33 +0100
Message-ID: <1414513123-20400-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yi.li-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Version v2 of arm64/efi patches for 3.19.
Changes since previous version:
- dropped patch #6 'arm64/efi: use UEFI memory map unconditionally if available'
  (will be revisited later, but due to other changes in the pipeline regarding
  the virtual mapping of UEFI Runtime Services, it makes sense to defer this
  to 3.20)
- added patch #10 'efi: efi-stub: notify on DTB absence'

Note that Matt Fleming has given his approval for taking all of these through
the arm64 tree.

@Matt: may we have your ack on patches #6, #7 and #10 please? Patch #7 covers
DMI not EFI but get_maintainer.pl is not very helpful here. (The patch is cc'ed
to akpm and Tony Luck [ia64 maintainer])

Patches #1 - #3 are fixes for compliance with the UEFI and PE/COFF specs.
No issues are known that require these patches, so there is no reason to
pull them into a stable release.

Patch #4 fixes is_reserve_region() to correctly identify UEFI memory regions
that need to be reserved by the OS. This patch supersedes the patch sent as
part of the v1 series: 'arm64/efi: reserve regions of type ACPI_MEMORY_NVS'

Patch #5 removes a redundant set_bit(EFI_CONFIG_TABLES) call.

Patches #6 - #9 implement DMI/SMBIOS for arm64, both the existing 32-bit
version and the upcoming 3.0 version that allows the SMBIOS structure table
to reside at a physical offset that cannot be encoded in 32-bits. It also
installs a 'Hardware name: xxx' string that is printed along with oopses
and kernel call stack dumps on systems that implement DMI/SMBIOS.

Patch #10 is a patch from Mark Rutland I picked up that improves the
diagnostic output of the EFI stub regarding the origin of the device
tree blob.

Please refer to the patches themselves for version history. Acks and/or
comments appreciated.

Ard Biesheuvel (8):
  arm64/efi: efistub: jump to 'stext' directly, not through the header
  arm64/efi: set PE/COFF section alignment to 4 KB
  arm64/efi: set PE/COFF file alignment to 512 bytes
  arm64/efi: invert UEFI memory region reservation logic
  arm64/efi: drop redundant set_bit(EFI_CONFIG_TABLES)
  efi: dmi: add support for SMBIOS 3.0 UEFI configuration table
  dmi: add support for SMBIOS 3.0 64-bit entry point
  arm64: dmi: set DMI string as dump stack arch description

Mark Rutland (1):
  efi: efi-stub: notify on DTB absence

Yi Li (1):
  arm64: dmi: Add SMBIOS/DMI support

 arch/arm64/Kconfig                      | 11 ++++++
 arch/arm64/include/asm/dmi.h            | 31 +++++++++++++++
 arch/arm64/kernel/efi-entry.S           |  3 +-
 arch/arm64/kernel/efi.c                 | 37 +++++++++++------
 arch/arm64/kernel/head.S                | 24 +++++++----
 arch/arm64/kernel/vmlinux.lds.S         | 17 ++++++++
 drivers/firmware/dmi_scan.c             | 70 ++++++++++++++++++++++++++++++++-
 drivers/firmware/efi/efi.c              |  4 ++
 drivers/firmware/efi/libstub/arm-stub.c | 11 +++++-
 drivers/xen/efi.c                       |  1 +
 include/linux/efi.h                     |  6 ++-
 11 files changed, 191 insertions(+), 24 deletions(-)
 create mode 100644 arch/arm64/include/asm/dmi.h

-- 
1.8.3.2
