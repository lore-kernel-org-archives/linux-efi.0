From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 0/5] arm64 UEFI early FDT handling
Date: Wed, 26 Aug 2015 10:06:26 +0200
Message-ID: <1440576391-25725-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ganapatrao.Kulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, haojian.zhuang-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leo.yan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
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

Patch #1 introduces an arm64 specific version of early_init_dt_add_memory_arch()
so that we can modify it later to ignore DT memory nodes if booting via UEFI.

Patch #2 moves some UEFI+FDT init code around before making changes to it.

Patch #3 moves the UEFI initialization to before the early FDT scanning so we
know at that point whether we are booting via UEFI or not.

Patch #4 changes the UEFI init code so that memory nodes are simply ignored, so
that they don't have to be removed by the stub anymore.

Patch #5 does the same as #6, but for memreserves and the /reserved-memory
node.

Changes since v1:
- dropped first two patches, they have been merged into v4.2-rc1
- dropped last patch regarding FDT placement by the stub, this is not entirely
  relevant to the primary issue targeted by this series
- rebased onto for-next/core (arm64) as of today

Ard Biesheuvel (5):
  arm64: clone early_init_dt_add_memory_arch() to override default
  efi: move FDT handling to separate object file
  arm64/efi: move EFI init before early FDT processing
  arm64/efi: ignore DT memory nodes instead of removing them
  arm64/efi: ignore DT memreserve entries instead of removing them

 arch/arm64/include/asm/efi.h       |  4 +-
 arch/arm64/kernel/efi.c            | 14 +---
 arch/arm64/kernel/setup.c          |  4 +-
 arch/arm64/mm/init.c               | 54 +++++++++++-
 drivers/firmware/efi/Makefile      |  1 +
 drivers/firmware/efi/efi-fdt.c     | 77 ++++++++++++++++++
 drivers/firmware/efi/efi.c         | 86 --------------------
 drivers/firmware/efi/libstub/fdt.c | 33 +-------
 include/linux/efi.h                |  3 +-
 9 files changed, 143 insertions(+), 133 deletions(-)
 create mode 100644 drivers/firmware/efi/efi-fdt.c

-- 
1.9.1
