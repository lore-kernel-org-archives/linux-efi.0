From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [GIT PULL] EFI urgent fixes
Date: Mon, 8 Sep 2014 22:55:35 +0100
Message-ID: <20140908215535.GD18582@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Folks,

Please queue up the following fixes, mainly for regressions introduced
in the merge window or -rc2.

The following changes since commit 52addcf9d6669fa439387610bc65c92fa0980cef:

  Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to 5d6012d8d72b4107bbc68d9e761aa5e2ddd73b05:

  efi/arm64: Fix fdt-related memory reservation (2014-09-08 20:52:48 +0100)

----------------------------------------------------------------
 * Fix early boot regression affecting x86 EFI boot stub when loading
   initrds above 4GB - Yinghai Lu

 * Relocate GOT entries in the x86 EFI boot stub now that we have
   symbols with global visibility - Matt Fleming

 * Fixes for compiler warnings caused by parameter and variable names
   shadowing types - Mark Rustad

 * General EFI cleanups and simplifications - Mathias Krause

 * fdt memory reservation fix for arm64 - Mark Salter

----------------------------------------------------------------
Mark Rustad (1):
      efi: Resolve some shadow warnings

Mark Salter (1):
      efi/arm64: Fix fdt-related memory reservation

Mathias Krause (4):
      x86/efi: Remove unused efi_call* macros
      x86/efi: Unexport add_efi_memmap variable
      x86/efi: Update comment regarding required phys mapped EFI services
      x86/efi: Mark initialization code as such

Matt Fleming (1):
      x86/efi: Fixup GOT in all boot code paths

Yinghai Lu (1):
      x86/efi: Only load initrd above 4g on second try

 arch/arm64/mm/init.c                |  3 +-
 arch/x86/boot/compressed/eboot.c    | 18 +++++++-----
 arch/x86/boot/compressed/head_32.S  | 54 +++++++++++++++++++++++++----------
 arch/x86/boot/compressed/head_64.S  | 56 +++++++++++++++++++++++++++----------
 arch/x86/include/asm/efi.h          | 31 +++++++-------------
 arch/x86/platform/efi/efi.c         | 20 ++++++-------
 arch/x86/platform/efi/efi_32.c      | 12 ++++----
 arch/x86/platform/efi/efi_64.c      |  6 ++--
 arch/x86/platform/efi/efi_stub_32.S |  4 +--
 drivers/firmware/efi/libstub/fdt.c  | 10 ++++++-
 drivers/firmware/efi/vars.c         | 14 +++++-----
 11 files changed, 140 insertions(+), 88 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
