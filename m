From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [GIT PULL 00/11] EFI updates
Date: Thu, 29 Nov 2018 18:12:19 +0100
Message-ID: <20181129171230.18699-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Arend van Spriel <arend.vanspriel@broadcom.com>, Bhupesh Sharma <bhsharma@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@intel.com>, Eric Snowberg <eric.snowberg@oracle.com>, Hans de Goede <hdegoede@redhat.com>, Joe Perches <joe@perches.com>, Jon Hunter <jonathanh@nvidia.com>, Julien Thierry <julien.thierry@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Nathan Chancellor <natechancellor@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Sedat Dilek <sedat.dilek@gmail.com>, YiFei Zhu <zhuyifei1999@gmail.com>
List-Id: linux-efi@vger.kernel.org

The following changes since commit 976b489120cdab2b1b3a41ffa14661db43d58190:

  efi: Prevent GICv3 WARN() by mapping the memreserve table before first use (2018-11-27 13:50:20 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-next

for you to fetch changes up to 1d29afdbf7ae878a23627ebee81efcd213f11749:

  efi/x86: earlyprintk - Fix infinite loop on some screen widths (2018-11-28 17:58:42 +0100)

----------------------------------------------------------------
EFI updates for v4.21:
- Allocate the E820 buffer before doing the GetMemoryMap/ExitBootServices
  dance so we don't run out of space (Eric)
- Clear EFI boot services mappings when freeing the memory (Sai)
- Harden efivars against callers that invoke it on non-EFI boots (Arend)
- Reduce the number of memblock reservations resulting from extensive
  use of the new efi_mem_reserve_persistent() API (Ard)
- Other assorted fixes and cleanups.

----------------------------------------------------------------
Ard Biesheuvel (2):
      efi: permit multiple entries in persistent memreserve data structure
      efi: reduce the amount of memblock reservations for persistent allocations

Arend van Spriel (1):
      firmware: efi: add NULL pointer checks in efivars api functions

Eric Snowberg (1):
      x86/efi: Allocate e820 buffer before calling efi_exit_boot_service

Julien Thierry (2):
      efi/fdt: Indentation fix
      efi/fdt: Simplify get_fdt flow

Nathan Chancellor (1):
      efi/libstub: Disable some warnings for x86{,_64}

Sai Praneeth Prakhya (3):
      x86/mm/pageattr: Introduce helper function to unmap EFI boot services
      x86/efi: Unmap EFI boot services code/data regions from efi_pgd
      x86/efi: Move efi_<reserve/free>_boot_services() to arch/x86

YiFei Zhu (1):
      efi/x86: earlyprintk - Fix infinite loop on some screen widths

 arch/x86/boot/compressed/eboot.c        | 65 ++++++++++++++--------
 arch/x86/include/asm/efi.h              |  2 +
 arch/x86/include/asm/pgtable_types.h    |  8 ++-
 arch/x86/mm/pageattr.c                  | 40 ++++++++++++-
 arch/x86/platform/efi/early_printk.c    |  2 +-
 arch/x86/platform/efi/efi.c             |  2 +
 arch/x86/platform/efi/quirks.c          | 25 +++++++++
 drivers/firmware/efi/efi.c              | 55 +++++++++++++-----
 drivers/firmware/efi/libstub/Makefile   |  5 +-
 drivers/firmware/efi/libstub/arm-stub.c |  2 +-
 drivers/firmware/efi/libstub/fdt.c      | 30 +++++-----
 drivers/firmware/efi/vars.c             | 99 ++++++++++++++++++++++++++-------
 include/linux/efi.h                     | 19 +++++--
 init/main.c                             |  4 --
 14 files changed, 269 insertions(+), 89 deletions(-)
