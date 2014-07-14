From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [GIT PULL] EFI urgent fixes
Date: Mon, 14 Jul 2014 13:54:32 +0100
Message-ID: <20140714125432.GI5952@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Folks, please pull the following urgent fixes. Of particular importance
is the patch from Michael that fixes a memory corruption bug in the x86
EFI boot stub.

The following changes since commit 783ee43118dc773bc8b0342c5b230e017d5a04d0:

  efi-pstore: Fix an overflow on 32-bit builds (2014-06-27 07:30:32 +0100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-urgent

for you to fetch changes up to c7fb93ec51d462ec3540a729ba446663c26a0505:

  x86/efi: Include a .bss section within the PE/COFF headers (2014-07-10 14:21:39 +0100)

----------------------------------------------------------------
 * Remove a duplicate copy of linux_banner from the arm64 EFI stub
   which, apart from reducing code duplication also stops the arm64 stub
   being rebuilt every time make is invoked - Ard Biesheuvel

 * Fix the EFI fdt code to not report a boot error if UEFI is
   unavailable since booting without UEFI parameters is a valid use case
   for non-UEFI platforms - Catalin Marinas

 * Include a .bss section in the EFI boot stub PE/COFF headers to fix a
   memory corruption bug - Michael Brown

----------------------------------------------------------------
Ard Biesheuvel (1):
      efi/arm64: efistub: remove local copy of linux_banner

Catalin Marinas (1):
      efi: fdt: Do not report an error during boot if UEFI is not available

Michael Brown (1):
      x86/efi: Include a .bss section within the PE/COFF headers

 arch/arm64/kernel/efi-stub.c |  2 --
 arch/x86/boot/header.S       | 26 ++++++++++++++++++++++----
 arch/x86/boot/tools/build.c  | 38 ++++++++++++++++++++++++++++++--------
 drivers/firmware/efi/efi.c   | 22 +++++++++++++++-------
 drivers/firmware/efi/fdt.c   | 10 ----------
 5 files changed, 67 insertions(+), 31 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
