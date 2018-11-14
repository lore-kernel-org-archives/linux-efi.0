From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [GIT PULL 0/5] EFI fixes for v4.20
Date: Wed, 14 Nov 2018 09:55:39 -0800
Message-ID: <20181114175544.12860-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Waiman Long <longman@redhat.com>
List-Id: linux-efi@vger.kernel.org

The following changes since commit ccda4af0f4b92f7b4c308d3acc262f4a7e3affad:

  Linux 4.20-rc2 (2018-11-11 17:12:31 -0600)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git efi-urgent

for you to fetch changes up to 844d2592ed2f1903f8e38d8d395fd0d38ecdd536:

  efi: permit calling efi_mem_reserve_persistent from atomic context (2018-11-14 05:49:28 -0800)

----------------------------------------------------------------
EFI fixes for v4.20:
- fix incorrect 'on stack' annotation of efi_rts_work (all EFI arches)
- revert deferred memory map unmapping on ARM
- pack the FDT before handing over to the OS (ARM, arm64)
- fixes for new persistent memreserve feature (ARM, arm64)

----------------------------------------------------------------
Ard Biesheuvel (4):
      efi: arm: revert deferred unmap of early memmap mapping
      efi/arm: libstub: pack FDT after populating it
      efi/arm: defer persistent reservations until after paging_init()
      efi: permit calling efi_mem_reserve_persistent from atomic context

Waiman Long (1):
      efi: Fix debugobjects warning on efi_rts_work

 arch/arm64/kernel/setup.c               |  1 +
 drivers/firmware/efi/arm-init.c         |  4 ++++
 drivers/firmware/efi/arm-runtime.c      |  2 +-
 drivers/firmware/efi/efi.c              | 35 ++++++++++++++++++++++-----------
 drivers/firmware/efi/libstub/arm-stub.c |  3 +++
 drivers/firmware/efi/libstub/fdt.c      |  4 ++++
 drivers/firmware/efi/memmap.c           |  3 +++
 drivers/firmware/efi/runtime-wrappers.c |  2 +-
 include/linux/efi.h                     |  7 +++++++
 9 files changed, 47 insertions(+), 14 deletions(-)
