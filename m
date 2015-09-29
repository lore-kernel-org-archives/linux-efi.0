From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 0/6] arm64 UEFI early FDT handling
Date: Tue, 29 Sep 2015 09:38:57 +0200
Message-ID: <CAKv+Gu8m2M9920yPRcrjmPeJPXKj=xd7ypH+ZFcYEm+_t5a5ig@mail.gmail.com>
References: <1442881288-13962-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442881288-13962-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(+ Grant)

On 22 September 2015 at 02:21, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> This is a followup to the "arm64: update/clarify/relax Image and FDT placement
> rules" series I sent a while ago:
> (http://article.gmane.org/gmane.linux.ports.arm.kernel/407148)
>
> This has now been split in two series: this first series deals with the
> early FDT handling, primarily in the context of UEFI, but not exclusively.
>
> A number of minor issues exist in the early UEFI/FDT handling path, such as:
> - when booting via UEFI, memreserve entries are removed from the device tree but
>   the /reserved-memory node is not

After reading Documentation/devicetree/bindings/reserved-memory/reserved-memory.txt
again, I think simply ignoring the reserved-memory node is not the way
to go. The reason is that it may contain dynamic allocations that are
referenced by other nodes in the DT, and there is no good technical
reason IMO to disallow those. OTOH, static allocations may conflict
with the UEFI memory map, so those need to be dropped or at least
checked against the memory map. The problem here is that static nodes
may also be referenced by phandle, so we need to handle the referring
node in some way as well.

So I think we have a number of options:
- ignore /memreserve/s and reject static allocations in
/reserved-memory (*) but honor dynamic ones
- ignore /memreserve/s and honor all of /reserved-memory after
checking that static allocations don't conflict
- honor all /memreserve/s and /reserved-memory nodes and check all for conflicts
- ...

(*) static allocations for regions that the UEFI memory map does not
describe should be OK, though

I personally prefer the first one, since a dynamic allocation
implicitly conveys that the region does not contain anything special
when coming out of boot, and there is very little we need to do other
than perform the actual reservation. Static allocations are ambiguous
in the sense that there is no annotation that explains the choice of
address.

Thoughts, please?

-- 
Ard.


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
>  arch/arm64/kernel/efi.c            | 26 ++++--
>  arch/arm64/kernel/setup.c          |  3 +
>  arch/arm64/mm/init.c               | 12 ++-
>  drivers/firmware/efi/Makefile      |  1 +
>  drivers/firmware/efi/efi-fdt.c     | 73 +++++++++++++++++
>  drivers/firmware/efi/efi.c         | 84 --------------------
>  drivers/firmware/efi/libstub/fdt.c | 33 +-------
>  drivers/of/fdt.c                   |  7 +-
>  include/linux/efi.h                |  2 +-
>  include/linux/of_fdt.h             |  1 +
>  11 files changed, 116 insertions(+), 128 deletions(-)
>  create mode 100644 drivers/firmware/efi/efi-fdt.c
>
> --
> 1.9.1
>
