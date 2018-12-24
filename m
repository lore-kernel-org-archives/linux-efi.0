From: Ingo Molnar <mingo@kernel.org>
Subject: [GIT PULL] EFI changes for v4.21
Date: Mon, 24 Dec 2018 23:21:32 +0100
Message-ID: <20181224222132.GA109386@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>
List-Id: linux-efi@vger.kernel.org

Linus,

Please pull the latest efi-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git efi-core-for-linus

   # HEAD: 1debf0958fa27b7c469dbf22754929ec59a7c0e7 x86/efi: Don't unmap EFI boot services code/data regions for EFI_OLD_MEMMAP and EFI_MIXED_MODE

The main changes in this cycle were:

  - Allocate the E820 buffer before doing the GetMemoryMap/ExitBootServices
    dance so we don't run out of space

  - Clear EFI boot services mappings when freeing the memory

  - Harden efivars against callers that invoke it on non-EFI boots 

  - Reduce the number of memblock reservations resulting from extensive
    use of the new efi_mem_reserve_persistent() API

  - Other assorted fixes and cleanups.

 Thanks,

	Ingo

------------------>
Ard Biesheuvel (2):
      efi: Permit multiple entries in persistent memreserve data structure
      efi: Reduce the amount of memblock reservations for persistent allocations

Arend van Spriel (1):
      firmware/efi: Add NULL pointer checks in efivars API functions

Julien Thierry (2):
      efi/fdt: Indentation fix
      efi/fdt: Simplify the get_fdt() flow

Nathan Chancellor (1):
      efi/libstub: Disable some warnings for x86{,_64}

Sai Praneeth Prakhya (4):
      x86/mm/pageattr: Introduce helper function to unmap EFI boot services
      x86/efi: Unmap EFI boot services code/data regions from efi_pgd
      x86/efi: Move efi_<reserve/free>_boot_services() to arch/x86
      x86/efi: Don't unmap EFI boot services code/data regions for EFI_OLD_MEMMAP and EFI_MIXED_MODE


 arch/x86/include/asm/efi.h              |  2 +
 arch/x86/include/asm/pgtable_types.h    |  8 ++-
 arch/x86/mm/pageattr.c                  | 40 ++++++++++++-
 arch/x86/platform/efi/efi.c             |  2 +
 arch/x86/platform/efi/quirks.c          | 41 ++++++++++++++
 drivers/firmware/efi/efi.c              | 54 +++++++++++++-----
 drivers/firmware/efi/libstub/Makefile   |  5 +-
 drivers/firmware/efi/libstub/arm-stub.c |  2 +-
 drivers/firmware/efi/libstub/fdt.c      | 30 +++++-----
 drivers/firmware/efi/vars.c             | 99 ++++++++++++++++++++++++++-------
 include/linux/efi.h                     | 19 +++++--
 init/main.c                             |  4 --
 12 files changed, 242 insertions(+), 64 deletions(-)
