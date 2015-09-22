From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 0/6] arm64 UEFI early FDT handling
Date: Mon, 21 Sep 2015 17:21:22 -0700
Message-ID: <1442881288-13962-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This is a followup to the "arm64: update/clarify/relax Image and FDT placement
rules" series I sent a while ago:
(http://article.gmane.org/gmane.linux.ports.arm.kernel/407148)

This has now been split in two series: this first series deals with the
early FDT handling, primarily in the context of UEFI, but not exclusively.

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
 arch/arm64/kernel/efi.c            | 26 ++++--
 arch/arm64/kernel/setup.c          |  3 +
 arch/arm64/mm/init.c               | 12 ++-
 drivers/firmware/efi/Makefile      |  1 +
 drivers/firmware/efi/efi-fdt.c     | 73 +++++++++++++++++
 drivers/firmware/efi/efi.c         | 84 --------------------
 drivers/firmware/efi/libstub/fdt.c | 33 +-------
 drivers/of/fdt.c                   |  7 +-
 include/linux/efi.h                |  2 +-
 include/linux/of_fdt.h             |  1 +
 11 files changed, 116 insertions(+), 128 deletions(-)
 create mode 100644 drivers/firmware/efi/efi-fdt.c

-- 
1.9.1
