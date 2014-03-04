From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [GIT PULL] EFI mixed mode support
Date: Tue, 4 Mar 2014 23:43:19 +0000
Message-ID: <20140304234319.GC17362@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Peter, I've got the mixed mode support in two branches.

'mixed-mode' is a clean topic branch against -rc3, which will generate
conflicts when you merge it with the EFI 'next' branch.

I performed the merge myself in 'mixed-mode-merged' so you can take a
look there to see how I resolved the conflicts.

If you want another option, just let me know.

The following changes since commit 6d0abeca3242a88cab8232e4acd7e2bf088f3bc2:

  Linux 3.14-rc3 (2014-02-16 13:30:25 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git mixed-mode

for you to fetch changes up to 18c46461d9e42d398536055f31f58cdcd2c6347e:

  x86/efi: Re-disable interrupts after calling firmware services (2014-03-04 21:44:00 +0000)

----------------------------------------------------------------
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
 arch/x86/boot/compressed/eboot.c       | 1018 +++++++++++++++++++++++++-------
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
 arch/x86/platform/efi/efi.c            |  141 +++--
 arch/x86/platform/efi/efi_64.c         |  335 ++++++++++-
 arch/x86/platform/efi/efi_stub_64.S    |  157 +++++
 arch/x86/platform/efi/efi_thunk_64.S   |   65 ++
 drivers/firmware/efi/efi-stub-helper.c |  148 ++---
 include/linux/efi.h                    |  252 ++++++++
 21 files changed, 2116 insertions(+), 424 deletions(-)
 create mode 100644 arch/x86/platform/efi/efi_thunk_64.S

-- 
Matt Fleming, Intel Open Source Technology Center
