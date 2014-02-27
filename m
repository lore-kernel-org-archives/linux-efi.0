From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH 00/13] EFI mixed mode
Date: Thu, 27 Feb 2014 19:46:31 +0000
Message-ID: <1393530404-12479-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch series enables booting a 64-bit kernel on 32-bit EFI
firmware.

Note that no boot loader changes should be necessary to take advantage
of these patches, and if your bootloader of choice uses the EFI handover
protocol (Syslinux, efilinux, Grub) you should automatically be able to
boot a CONFIG_X86_64 kernel on 32-bit EFI by enabling CONFIG_EFI_MIXED.

This series does not implement mixed mode support for the EFI boot stub,
so it won't work with gummiboot or directly from the EFI shell.

The full series is available on the 'mixed-mode' branch here,

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git

Matt Fleming (13):
  x86/boot: Cleanup header.S by removing some #ifdefs
  x86, tools: Consolidate #ifdef code
  x86/mm/pageattr: Always dump the right page table in an oops
  x86/efi: Delete dead code when checking for non-native
  efi: Add separate 32-bit/64-bit definitions
  x86/efi: Build our own EFI services pointer table
  x86/efi: Add early thunk code to go from 64-bit to 32-bit
  x86/efi: Split the boot stub into 32/64 code paths
  x86/efi: Firmware agnostic handover entry points
  x86/efi: Add mixed runtime services support
  x86/efi: Wire up CONFIG_EFI_MIXED
  x86/boot: Don't overwrite cr4 when enabling PAE
  x86/efi: Re-disable interrupts after calling firmware services

 arch/x86/Kconfig                       |   14 +
 arch/x86/boot/Makefile                 |    2 +-
 arch/x86/boot/compressed/eboot.c       | 1044 ++++++++++++++++++++++++++------
 arch/x86/boot/compressed/eboot.h       |   60 ++
 arch/x86/boot/compressed/efi_stub_64.S |   29 +
 arch/x86/boot/compressed/head_32.S     |   50 +-
 arch/x86/boot/compressed/head_64.S     |  108 +++-
 arch/x86/boot/header.S                 |   23 +-
 arch/x86/boot/tools/build.c            |   76 ++-
 arch/x86/include/asm/efi.h             |   38 +-
 arch/x86/include/asm/pgtable_types.h   |    2 +
 arch/x86/kernel/setup.c                |    2 +-
 arch/x86/mm/fault.c                    |    7 +-
 arch/x86/mm/pageattr.c                 |   12 +-
 arch/x86/platform/efi/Makefile         |    1 +
 arch/x86/platform/efi/efi.c            |  170 +++---
 arch/x86/platform/efi/efi_64.c         |  328 +++++++++-
 arch/x86/platform/efi/efi_stub_64.S    |  157 +++++
 arch/x86/platform/efi/efi_thunk_64.S   |   65 ++
 drivers/firmware/efi/efi-stub-helper.c |  148 ++---
 include/linux/efi.h                    |  252 ++++++++
 21 files changed, 2140 insertions(+), 448 deletions(-)
 create mode 100644 arch/x86/platform/efi/efi_thunk_64.S

-- 
1.8.5.3
