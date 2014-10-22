From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 00/10] arm64 EFI patches for 3.19
Date: Wed, 22 Oct 2014 16:21:43 +0200
Message-ID: <1413987713-30528-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yi.li-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This is a bit of a mixed bag of patches that we would like to see merged for
3.19. Most of them have been posted and discussed on linux-efi and/or LAKML
before, and one of them has even been merged and reverted twice.

Patches #1 - #4 are fixes for compliance with the UEFI and PE/COFF specs.
No issues are known that require these patches, so there is no reason to
pull them into a stable release.

Patches #5 and #6 address minor issues in the arm64 EFI init code.

Patches #7 - #10 implement DMI/SMBIOS for arm64, both the existing 32-bit
version and the upcoming 3.0 version that allows the SMBIOS structure table
to reside at a physical offset that cannot be encoded in 32-bits. It also
install a 'Hardware: xxx' string that is printed along with oopses and
kernel call stack dumps on systems that implement DMI/SMBIOS.

Please refer to the patches themselves for version history. Acks and/or
comments appreciated.

Ard Biesheuvel (9):
  arm64/efi: efistub: jump to 'stext' directly, not through the header
  arm64/efi: set PE/COFF section alignment to 4 KB
  arm64/efi: set PE/COFF file alignment to 512 bytes
  arm64/efi: reserve regions of type ACPI_MEMORY_NVS
  arm64/efi: drop redundant set_bit(EFI_CONFIG_TABLES)
  arm64/efi: use UEFI memory map unconditionally if available
  efi: dmi: add support for SMBIOS 3.0 UEFI configuration table
  dmi: add support for SMBIOS 3.0 64-bit entry point
  arm64: dmi: set DMI string as dump stack arch description

Yi Li (1):
  arm64: dmi: Add SMBIOS/DMI support

 arch/arm64/Kconfig              | 11 +++++++
 arch/arm64/include/asm/dmi.h    | 31 ++++++++++++++++++
 arch/arm64/kernel/efi-entry.S   |  3 +-
 arch/arm64/kernel/efi.c         | 29 +++++++++++------
 arch/arm64/kernel/head.S        | 24 +++++++++-----
 arch/arm64/kernel/vmlinux.lds.S | 17 ++++++++++
 drivers/firmware/dmi_scan.c     | 70 +++++++++++++++++++++++++++++++++++++++--
 drivers/firmware/efi/efi.c      |  4 +++
 include/linux/efi.h             |  6 +++-
 9 files changed, 175 insertions(+), 20 deletions(-)
 create mode 100644 arch/arm64/include/asm/dmi.h

-- 
1.8.3.2
