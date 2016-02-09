From: Robert Richter <rrichter@caviumnetworks.com>
Subject: [PATCH v4 0/6] arm64 UEFI early FDT handling
Date: Tue, 9 Feb 2016 14:53:40 +0100
Message-ID: <1455026026-11571-1-git-send-email-rrichter@caviumnetworks.com>
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
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Will Deacon <will.deacon@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-efi@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org, Leif Lindholm <leif.lindholm@linaro.org>, Robert Richter <rrichter@cavium.com>, Mark Salter <msalter@redhat.com>, Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

From: Robert Richter <rrichter@cavium.com>

Reposting an updated version of this patches ported to 4.5-rc1. It is
a followup to the version 3 from:

 http://lkml.kernel.org/r/1442881288-13962-1-git-send-email-ard.biesheuvel@linaro.org

The series is essential for NUMA on arm64. Early FDT handling is
required to make system topology data from firmware, esp. for cpus and
memory available to the early boot process. Ganapat's numa patches
depend on it. This series has been tested with his series v10 posted
here:

 http://lkml.kernel.org/r/1454407763-1017-1-git-send-email-gkulkarni@caviumnetworks.com

A number of minor issues exist in the early UEFI/FDT handling path, such as:
- when booting via UEFI, memreserve entries are removed from the device tree but
  the /reserved-memory node is not
- memory nodes are removed from the device tree in a way that is not officially
  supported by the libfdt API (i.e., you cannot delete nodes while traversing
  the tree)
- removal of memory nodes may discard annotations (such as NUMA topology) that
  should ideally be retained, or may corrupt the tree by discarding nodes
  referenced by phandles.

Patches #1 and #2 introduce an arm64 specific version of
early_init_dt_add_memory_arch() so that we can modify it later to ignore DT
memory nodes if booting via UEFI.

Patch #3 moves some UEFI+FDT init code around before making changes to it.

Patch #4 moves the UEFI initialization to before the early FDT scanning so we
know at that point whether we are booting via UEFI or not.

Patch #5 changes the UEFI init code so that memory nodes are simply ignored, so
that they don't have to be removed by the stub anymore.

Patch #6 does the same as #5, but for memreserves and the /reserved-memory
node.

Changes since v3:
- prorted to v4.5-rc1

Changes since v2:
- instead of copying the generic implementation, turn
  early_init_dt_add_memory_arch() into a weak alias so that it is still
  accessible to overrides

Changes since v1:
- dropped first two patches, they have been merged into v4.2-rc1
- dropped last patch regarding FDT placement by the stub, this is not entirely
  relevant to the primary issue targeted by this series
- rebased onto for-next/core (arm64) as of today

Ard Biesheuvel (6):
  of/fdt: make generic early_init_dt_add_memory_arch() a weak alias
  arm64: override generic version of early_init_dt_add_memory_arch()
  efi: move FDT handling to separate object file
  arm64/efi: move EFI /chosen node parsing before early FDT processing
  arm64/efi: ignore DT memory nodes instead of removing them
  arm64/efi: ignore DT memreserve entries instead of removing them

 arch/arm64/include/asm/efi.h       |  2 +
 arch/arm64/kernel/setup.c          |  3 ++
 arch/arm64/mm/init.c               | 12 +++++-
 drivers/firmware/efi/Makefile      |  1 +
 drivers/firmware/efi/arm-init.c    | 36 ++++++++++------
 drivers/firmware/efi/efi-fdt.c     | 73 +++++++++++++++++++++++++++++++++
 drivers/firmware/efi/efi.c         | 84 --------------------------------------
 drivers/firmware/efi/libstub/fdt.c | 33 +--------------
 drivers/of/fdt.c                   |  7 +++-
 include/linux/efi.h                |  2 +-
 include/linux/of_fdt.h             |  1 +
 11 files changed, 121 insertions(+), 133 deletions(-)
 create mode 100644 drivers/firmware/efi/efi-fdt.c

-- 
2.7.0.rc3
