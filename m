From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 0/6] arm/efi: fix memblock reallocation crash due to
 persistent reservations
Date: Wed,  7 Nov 2018 15:16:05 +0100
Message-ID: <20181107141611.12076-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org, linux@armlinux.org.uk
Cc: marc.zyngier@arm.com, bhsharma@redhat.com, linux-efi@vger.kernel.org, will.deacon@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

This series addresses the kexec/kdump crash on arm64 system with many CPUs
that was reported by Bhupesh.

Patch #1 fixes the actual crash, but may result in memblock_reserve() to
fail. This is fixed in patch #4, where the point that the persistent
reservations are applied is moved to after memblock_allow_resize() has
been called.

Patches #2 and #3 contain some minor preparatory changes that are
required on ARM to ensure that efi_apply_persistent_mem_reservations()
can be called at some point (i.e., when memblock resizing is already
permitted and early memremap() is still usable)

Patches #5 and #6 optimize the EFI persistent memreserve infrastructure
so that fewer memblock reservations are required.

Changes since v1:
- Russell pointed out that switching to ordinary memremap() was not
  possible this early, and so I refactored the ARM early boot code
  slightly so that we can keep using early_memremap().

Ard Biesheuvel (6):
  arm64: memblock: don't permit memblock resizing until linear mapping
    is up
  ARM: mm: permit memblock resizing right after mapping the linear
    region
  ARM: mm: permit early_memremap() to be used in paging_init()
  efi/arm: defer persistent reservations until after paging_init()
  efi: permit multiple entries in persistent memreserve data structure
  efi: reduce the amount of memblock reservations for persistent
    allocations

 arch/arm/kernel/setup.c                 |  2 -
 arch/arm/mm/init.c                      |  1 -
 arch/arm/mm/mmu.c                       |  5 ++
 arch/arm64/kernel/setup.c               |  1 +
 arch/arm64/mm/init.c                    |  2 -
 arch/arm64/mm/mmu.c                     |  2 +
 drivers/firmware/efi/efi.c              | 59 ++++++++++++++------
 drivers/firmware/efi/libstub/arm-stub.c |  2 +-
 include/linux/efi.h                     | 23 +++++++-
 9 files changed, 72 insertions(+), 25 deletions(-)

-- 
2.19.1
