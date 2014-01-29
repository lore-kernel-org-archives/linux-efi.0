From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [RFC][PATCH 00/11] EFI mixed mode
Date: Wed, 29 Jan 2014 16:23:46 +0000
Message-ID: <1391012637-4839-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch series enables booting a 64-bit kernel on 32-bit EFI
firmware. It's marked as RFC because I'm just after some general
feedback on the approach taken.

Note that no boot loader changes should be necessary to take advantage
of these patches.

Tested Qemu + OVMF with Syslinux.

Some things that I'm going to fix up meanwhile are,

 o failure for > 4GB arg ptrs to EFI services should be graceful

 o revisit whether it's OK to mark the identity-mapped kernel
   text as executable.

 o I'm pretty sure these patches break 32-bit boot completely

 o The ARM EFI stub doesn't handle relocations so can't jump through
   global function pointers

The full series is available on the 'mixed-mode' branch here,

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git

Matt Fleming (11):
  x86/boot: Cleanup header.S by removing some #ifdefs
  x86, tools: Consolidate #ifdef code
  x86/mm/pageattr: Make __lookup_address_in_pgd() global
  x86/efi: Delete dead code when checking for non-native
  efi: Add separate 32-bit/64-bit definitions
  x86/efi: Build our own EFI services pointer table
  x86/efi: Add early thunk code to go from 64-bit to 32-bit
  x86/efi: Split the boot stub into 32/64 code paths
  x86/efi: Firmware agnostic handover entry points
  x86/efi: Add mixed runtime services support
  x86/efi: Wire up CONFIG_EFI_MIXED

 arch/x86/Kconfig                       |  10 +
 arch/x86/boot/Makefile                 |   2 +-
 arch/x86/boot/compressed/eboot.c       | 669 +++++++++++++++++++++++++++------
 arch/x86/boot/compressed/eboot.h       |  60 +++
 arch/x86/boot/compressed/efi_stub_64.S |  29 ++
 arch/x86/boot/compressed/head_64.S     | 123 +++++-
 arch/x86/boot/header.S                 |  23 +-
 arch/x86/boot/tools/build.c            |  73 ++--
 arch/x86/include/asm/efi.h             |  38 +-
 arch/x86/include/asm/pgtable_types.h   |   2 +
 arch/x86/kernel/setup.c                |   2 +-
 arch/x86/mm/fault.c                    |   7 +-
 arch/x86/mm/pageattr.c                 |  12 +-
 arch/x86/platform/efi/Makefile         |   1 +
 arch/x86/platform/efi/efi.c            | 154 ++++----
 arch/x86/platform/efi/efi_64.c         | 328 +++++++++++++++-
 arch/x86/platform/efi/efi_stub_64.S    | 161 ++++++++
 arch/x86/platform/efi/efi_thunk.S      |  65 ++++
 drivers/firmware/efi/efi-stub-helper.c | 142 ++-----
 include/linux/efi.h                    | 252 +++++++++++++
 20 files changed, 1807 insertions(+), 346 deletions(-)
 create mode 100644 arch/x86/platform/efi/efi_thunk.S

-- 
1.8.3.1
