From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 0/7] ARM: efi: PE/COFF cleanup/hardening
Date: Thu, 29 Jun 2017 08:18:42 +0000
Message-ID: <20170629081849.15081-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This is the ARM counterpart of the changes now in v4.12 to clean up
the PE/COFF header (which makes the kernel zImage loadable directly from
UEFI), and to enhance it with hardening and debug features.

Russell: patches #4 - #7 need your ack before I can take them via the EFI
tree. Please let me know if you have any objections, either to the patches
themselves, or to them going via another tree. Thanks.

v1 blurb:

First of all, the cleanup consists of making the header comply with the
PE/COFF spec (#1), removing the .reloc section (#2) and replacing all
open coded constants with #defines from linux/pe.h (#3)

Patch #4 is a standalone patch that removes ksymtab/kcrctab sections that
may get pulled in inadvertently when the decompressor is built with EFI
support. Note that these sections are tiny and harmless by themselves, but
the linker may dump them in unexpected places if they are not placed
explicitly, which may interfere with the image layout. This is especially
important when signing zImages for UEFI secure boot.

Patch #5 changes the description of the decompressor in memory, so that the
UEFI firmware can apply strict ro/nx protections, resulting in a more secure
execution environment for the UEFI stub.

Patch #6 splits the decompressor .start and .text output sections, so that
the ELF view aligns with the PE/COFF view of the binary. This is necessary
for patch #7 to work as expected.

Patch #7 enhances the decompressor binary with a NB10 Codeview debug entry
referring to the path to arch/arm/boot/compressed/vmlinux on the build host.
This is a debug feature that allows seamless source level single step debugging
of the UEFI stub while executing in the context of the firmware.

v2: - rebase onto v4.12-rc7+
    - simplify #3

Ard Biesheuvel (7):
  arm: efi: remove forbidden values from the PE/COFF header
  arm: efi: remove pointless dummy .reloc section
  arm: efi: replace open coded constants with symbolic ones
  arm: compressed: discard ksymtab/kcrctab sections
  arm: efi: split zImage code and data into separate PE/COFF sections
  arm: compressed: put zImage header and EFI header in dedicated section
  arm: efi: add PE/COFF debug table to EFI header

 arch/arm/boot/compressed/Makefile      |   4 +
 arch/arm/boot/compressed/efi-header.S  | 214 ++++++++++++--------
 arch/arm/boot/compressed/vmlinux.lds.S |  39 +++-
 3 files changed, 168 insertions(+), 89 deletions(-)

-- 
2.9.3
