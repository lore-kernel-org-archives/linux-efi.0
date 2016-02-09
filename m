From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 0/6] arm64 UEFI early FDT handling
Date: Tue, 9 Feb 2016 15:35:42 +0100
Message-ID: <CAKv+Gu-osoi53cpikDtZitJJX2gtZyhOMuvYf=cfeZi8zJ-LDg@mail.gmail.com>
References: <1455026026-11571-1-git-send-email-rrichter@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455026026-11571-1-git-send-email-rrichter-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Richter <rrichter-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(+ Grant)

On 9 February 2016 at 14:53, Robert Richter <rrichter-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org> wrote:
> From: Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
>
> Reposting an updated version of this patches ported to 4.5-rc1. It is
> a followup to the version 3 from:
>
>  http://lkml.kernel.org/r/1442881288-13962-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
>
> The series is essential for NUMA on arm64. Early FDT handling is
> required to make system topology data from firmware, esp. for cpus and
> memory available to the early boot process. Ganapat's numa patches
> depend on it. This series has been tested with his series v10 posted
> here:
>
>  http://lkml.kernel.org/r/1454407763-1017-1-git-send-email-gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org
>

Hello Robert,

This series does not reflect anymore what we think is the best way to
deal with memory nodes and memreserves on UEFI systems.
Please refer to this thread:
http://thread.gmane.org/gmane.linux.kernel.efi/6464

As far as the memory nodes are concerned, if it is the best place to
store these NUMA annotations, then we should indeed preserve them, but
I think the discussion stalled without any conclusion having been
reached. As far as the /reserved-memory node is concerned, that one we
should really keep, so at least patch 6/6 of this series should be
replaced with something based on the series above.

Thanks,
Ard.


> A number of minor issues exist in the early UEFI/FDT handling path, such as:
> - when booting via UEFI, memreserve entries are removed from the device tree but
>   the /reserved-memory node is not
> - memory nodes are removed from the device tree in a way that is not officially
>   supported by the libfdt API (i.e., you cannot delete nodes while traversing
>   the tree)
> - removal of memory nodes may discard annotations (such as NUMA topology) that
>   should ideally be retained, or may corrupt the tree by discarding nodes
>   referenced by phandles.
>
> Patches #1 and #2 introduce an arm64 specific version of
> early_init_dt_add_memory_arch() so that we can modify it later to ignore DT
> memory nodes if booting via UEFI.
>
> Patch #3 moves some UEFI+FDT init code around before making changes to it.
>
> Patch #4 moves the UEFI initialization to before the early FDT scanning so we
> know at that point whether we are booting via UEFI or not.
>
> Patch #5 changes the UEFI init code so that memory nodes are simply ignored, so
> that they don't have to be removed by the stub anymore.
>
> Patch #6 does the same as #5, but for memreserves and the /reserved-memory
> node.
>
> Changes since v3:
> - prorted to v4.5-rc1
>
> Changes since v2:
> - instead of copying the generic implementation, turn
>   early_init_dt_add_memory_arch() into a weak alias so that it is still
>   accessible to overrides
>
> Changes since v1:
> - dropped first two patches, they have been merged into v4.2-rc1
> - dropped last patch regarding FDT placement by the stub, this is not entirely
>   relevant to the primary issue targeted by this series
> - rebased onto for-next/core (arm64) as of today
>
> Ard Biesheuvel (6):
>   of/fdt: make generic early_init_dt_add_memory_arch() a weak alias
>   arm64: override generic version of early_init_dt_add_memory_arch()
>   efi: move FDT handling to separate object file
>   arm64/efi: move EFI /chosen node parsing before early FDT processing
>   arm64/efi: ignore DT memory nodes instead of removing them
>   arm64/efi: ignore DT memreserve entries instead of removing them
>
>  arch/arm64/include/asm/efi.h       |  2 +
>  arch/arm64/kernel/setup.c          |  3 ++
>  arch/arm64/mm/init.c               | 12 +++++-
>  drivers/firmware/efi/Makefile      |  1 +
>  drivers/firmware/efi/arm-init.c    | 36 ++++++++++------
>  drivers/firmware/efi/efi-fdt.c     | 73 +++++++++++++++++++++++++++++++++
>  drivers/firmware/efi/efi.c         | 84 --------------------------------------
>  drivers/firmware/efi/libstub/fdt.c | 33 +--------------
>  drivers/of/fdt.c                   |  7 +++-
>  include/linux/efi.h                |  2 +-
>  include/linux/of_fdt.h             |  1 +
>  11 files changed, 121 insertions(+), 133 deletions(-)
>  create mode 100644 drivers/firmware/efi/efi-fdt.c
>
> --
> 2.7.0.rc3
