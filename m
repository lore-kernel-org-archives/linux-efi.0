From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [GIT PULL] EFI changes for v3.19
Date: Fri, 14 Nov 2014 21:42:23 +0000
Message-ID: <20141114214223.GA6810@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Folks,

Please queue up the following changes for v3.19. 

Inclued are two straight forward changes from Mathias, and another
attempt from Ard at moving the x86 EFI boot stub to the libstub library.

It would be great to get these baking in linux-next for a bit.

The following changes since commit cac7f2429872d3733dc3f9915857b1691da2eb2f:

  Linux 3.18-rc2 (2014-10-26 16:48:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git tags/efi-next

for you to fetch changes up to 8266e31ed0fedb7ee16ebc86e80468f7cc1bbb4e:

  x86, ptdump: Add section for EFI runtime services (2014-11-11 22:28:57 +0000)

----------------------------------------------------------------
 * Support module unload for efivarfs - Mathias Krause

 * Another attempt at moving x86 to libstub taking advantage of the
   __pure attribute - Ard Biesheuvel

 * Add EFI runtime services section to ptdump - Mathias Krause

----------------------------------------------------------------
Ard Biesheuvel (1):
      efi/x86: Move x86 back to libstub

Mathias Krause (2):
      efivarfs: Allow unloading when build as module
      x86, ptdump: Add section for EFI runtime services

 arch/x86/boot/compressed/Makefile       |  3 ++-
 arch/x86/boot/compressed/eboot.c        |  8 ++++----
 arch/x86/boot/compressed/eboot.h        | 16 ----------------
 arch/x86/include/asm/efi.h              | 24 ++++++++++++++++++++++++
 arch/x86/include/asm/pgtable_64_types.h |  2 ++
 arch/x86/mm/dump_pagetables.c           |  3 +++
 arch/x86/platform/efi/efi_64.c          |  3 +--
 drivers/firmware/efi/Makefile           |  2 +-
 fs/efivarfs/super.c                     | 11 +++++++++--
 9 files changed, 46 insertions(+), 26 deletions(-)

-- 
Matt Fleming, Intel Open Source Technology Center
