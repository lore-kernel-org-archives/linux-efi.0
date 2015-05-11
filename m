From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 0/8] arm64 UEFI early FDT handling
Date: Mon, 11 May 2015 08:41:52 +0200
Message-ID: <1431326520-17331-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: Ganapatrao.Kulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This is a followup to the "arm64: update/clarify/relax Image and FDT placement
rules" series I sent a while ago:
(http://article.gmane.org/gmane.linux.ports.arm.kernel/407148)

This has now been split in two series: this first series deals with the
early FDT handling, primarily in the context of UEFI, but not exclusively.

A number of minor issues exist in the early UEFI/FDT handling path, such as:
- the FDT placement by the stub may violate the arm64/linux boot protocol in
  some corner cases;
- when booting via UEFI, memreserve entries are removed from the device tree but
  the /reserved-memory node is not
- memory nodes are removed from the device tree in a way that is not officially
  supported by the libfdt API (i.e., you cannot delete nodes while traversing
  the tree)
- removal of memory nodes may discard annotations (such as NUMA topology) that
  should ideally be retained.

Patch #1 splits off the reservation of the FDT image from the reservation of the
memreserve entries and /reserved-memory node.

Patch #2 relaxes the boot protocol requirement on the placement of the FDT.

Patch #3 introduces an arm64 specific version of early_init_dt_add_memory_arch()
so that we can modify it later to ignore DT memory nodes if booting via UEFI.
Note that having this specific version is desirable for other reasons as well,
this is covered by the other followup series.

Patch #4 moves some UEFI+FDT init code around before making changes to it.

Patch #5 moves the UEFI initialization to before the early FDT scanning so we
know at that point whether we are booting via UEFI or not.

Patch #6 changes the UEFI init code so that memory nodes are simply ignored, so
that they don't have to be removed by the stub anymore.

Patch  #7 does the same as #6, but for memreserves and the /reserved-memory
node.

Patch #8 adapts the FDT placement logic used by the stub to take into account
the new relaxed rules.

Ard Biesheuvel (8):
  of/fdt: split off FDT self reservation from memreserve processing
  arm64: use fixmap region for permanent FDT mapping
  arm64: override early_init_dt_add_memory_arch()
  efi: move FDT handling to separate object file
  arm64/efi: move EFI init before early FDT processing
  arm64/efi: ignore DT memory nodes instead of removing them
  arm64/efi: ignore DT memreserve entries instead of removing them
  arm64/efi: adapt to relaxed FDT placement requirements

 Documentation/arm64/booting.txt         | 13 +++--
 arch/arm/mm/init.c                      |  1 +
 arch/arm64/include/asm/boot.h           | 14 ++++++
 arch/arm64/include/asm/efi.h            | 14 ++----
 arch/arm64/include/asm/fixmap.h         | 15 ++++++
 arch/arm64/include/asm/mmu.h            |  1 +
 arch/arm64/kernel/efi.c                 | 14 ++----
 arch/arm64/kernel/head.S                | 39 +--------------
 arch/arm64/kernel/setup.c               | 34 +++++--------
 arch/arm64/mm/Makefile                  |  2 +
 arch/arm64/mm/init.c                    | 35 +++++++++++++-
 arch/arm64/mm/mmu.c                     | 66 +++++++++++++++++++++++++
 arch/powerpc/kernel/prom.c              |  1 +
 drivers/firmware/efi/Makefile           |  2 +
 drivers/firmware/efi/efi-fdt.c          | 77 +++++++++++++++++++++++++++++
 drivers/firmware/efi/efi.c              | 86 ---------------------------------
 drivers/firmware/efi/libstub/arm-stub.c |  5 +-
 drivers/firmware/efi/libstub/efistub.h  |  1 -
 drivers/firmware/efi/libstub/fdt.c      | 51 ++++---------------
 drivers/of/fdt.c                        | 19 ++++++--
 include/linux/efi.h                     |  3 +-
 include/linux/of_fdt.h                  |  2 +
 22 files changed, 274 insertions(+), 221 deletions(-)
 create mode 100644 arch/arm64/include/asm/boot.h
 create mode 100644 drivers/firmware/efi/efi-fdt.c

-- 
1.9.1
