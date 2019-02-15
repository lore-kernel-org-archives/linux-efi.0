From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [GIT PULL 0/2] EFI fixes for v5.0-rc
Date: Fri, 15 Feb 2019 13:33:31 +0100
Message-ID: <20190215123333.21209-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Mike Rapoport <rppt@linux.ibm.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-efi@vger.kernel.org

The following changes since commit 1f947a7a011fcceb14cb912f5481a53b18f1879a:

  Merge branch 'akpm' (patches from Andrew) (2019-02-12 17:15:33 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/efi/efi.git tags/efi-urgent

for you to fetch changes up to 98f19a800ac41cffa72a17b019eaf8160a01c22b:

  efi/arm: Revert "Defer persistent reservations until after paging_init()" (2019-02-15 09:58:04 +0100)

----------------------------------------------------------------
Yet another fix for the EFI memreserve code used by the GICv3 driver on
arm64.

----------------------------------------------------------------
Ard Biesheuvel (2):
      arm64: account for GICv3 LPI tables in static memblock reserve table
      efi/arm: Revert "Defer persistent reservations until after paging_init()"

 arch/arm64/include/asm/memory.h         | 11 +++++++++++
 arch/arm64/kernel/setup.c               |  1 -
 drivers/firmware/efi/efi.c              |  4 ----
 drivers/firmware/efi/libstub/arm-stub.c |  3 ---
 include/linux/efi.h                     |  7 -------
 include/linux/memblock.h                |  3 ---
 mm/memblock.c                           | 10 ++++++++--
 7 files changed, 19 insertions(+), 20 deletions(-)
