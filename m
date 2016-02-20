From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v11 00/10] arm64, numa: Add numa support for arm64 platforms
Date: Sat, 20 Feb 2016 09:20:05 +0100
Message-ID: <CAKv+Gu8FRdif_WDZPqs7gHxXMu=6SqDd6A54dQc1KWuGwxpf0w@mail.gmail.com>
References: <1455930799-5371-1-git-send-email-ddaney.cavm@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455930799-5371-1-git-send-email-ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hello David,

On 20 February 2016 at 02:13, David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
>
> v11:
>         - Dropped cleanup patches for other architectures, they will be
>           submitted as a separate set after more testing.
>
>         - Added patch set from Ard Biesheuvel that are needed to make
>           the whole thing actually work.  Previously this was a
>           separate set.
>

This series is out of date, unfortunately. The EFI init code is now
(as of v4.5-rc1) shared between ARM and arm64, which means that any
changes you make must be made on both sides. This applies to the split
between parsing the EFI dt nodes and performing the actual EFI init,
but also to the early_init_dt_add_memory_arch() changes. I am happy to
have a go at this, but first I need a clear statement from whoever
maintains that area that keeping memory nodes *just* for the
annotations (and otherwise ignore them) is the way forward (Rob?
Grant?)

Also, please drop the 6th patch. As i replied to Robert when he
reposted these patches, we need to honor the /reserved-memory node
rather than remove it. I will follow up with an updated
/reserved-memory node validation patch for the EFI stub once these
changes are in.


>         - Kconfig and other fixes and simplifications as suggested by Rob Herring.
>
>         - Rearranged, refactored and reordered so that we don't patch
>           new files multiple times.
>
>         - Summary:
>
>                 o 6 patches from Ard Biesheuvel to allow use of
>                   "memory" nodes with efi stub.
>
>                 o 2 patches to document and add of_numa.c
>
>                 o 1 patch to add arm64 NUMA support.
>
>                 o 1 patch to add NUMA balancing support for arm64.
>
> v10:
>         - Incorporated review comments from Rob Herring.
>         - Moved numa binding and implementation to devicetree core.
>         - Added cleanup patch to remove redundant NODE_DATA macro from asm header files
>         - Include numa balancing support for arm64 patch in this series.
>         - Fix tile build issue reported by the kbuild robot(patch 7)
>
> v9:     - Added cleanup patch to reuse and avoid redefinition of cpumask_of_pcibus
>           as suggested from Will Deacon and Bjorn Helgaas.
>           - Including patch to Make pci-host-generic driver numa aware.
>           - Incorporated comment from Shannon Zhao.
>
> v8:
>         - Incorporated review comments of Mark Rutland and Will Deacon.
>         - Added pci helper function and macro for numa.
>
> v7:
>         - managing numa memory mapping using memblock.
>         - Incorporated review comments of Mark Rutland.
>
> v6:
>         - defined and implemented the numa dt binding using
>         node property proximity and device node distance-map.
>         - renamed dt_numa to of_numa
>
> v5:
>         - created base verion of numa.c which creates dummy numa without using dt
>           on single socket platforms. Then added patches for dt support.
>         - Incorporated review comments from Hanjun Guo.
>
> v4:
> done changes as per Arnd review comments.
>
> v3:
> Added changes to support numa on arm64 based platforms.
> Tested these patches on cavium's multinode(2 node topology) platform.
> In this patchset, defined and implemented dt bindings for numa mapping
> for core and memory using device node property arm,associativity.
>
> v2:
> Defined and implemented numa map for memory, cores to node and
> proximity distance matrix of nodes.
>
> v1:
> Initial patchset to support numa on arm64 platforms.
>
> Note: 1. This patchset is tested for NUMA and without NUMA with dt
>         (both with and without NUMA bindings) on thunderx single
>         socket and dual socket boards.
>
>
> Ard Biesheuvel (6):
>   of/fdt: make generic early_init_dt_add_memory_arch() a weak alias
>   arm64: override generic version of early_init_dt_add_memory_arch()
>   efi: move FDT handling to separate object file
>   arm64/efi: move EFI /chosen node parsing before early FDT processing
>   arm64/efi: ignore DT memory nodes instead of removing them
>   arm64/efi: ignore DT memreserve entries instead of removing them
>
> Ganapatrao Kulkarni (4):
>   Documentation, dt, numa: dt bindings for NUMA.
>   dt, numa: Add NUMA dt binding implementation.
>   arm64, numa: Add NUMA support for arm64 platforms.
>   arm64, mm, numa: Add NUMA balancing support for arm64.
>
>  Documentation/devicetree/bindings/numa.txt | 272 +++++++++++++++++++
>  arch/arm64/Kconfig                         |  27 ++
>  arch/arm64/include/asm/efi.h               |   2 +
>  arch/arm64/include/asm/mmzone.h            |  12 +
>  arch/arm64/include/asm/numa.h              |  45 ++++
>  arch/arm64/include/asm/pgtable.h           |  15 ++
>  arch/arm64/include/asm/topology.h          |  10 +
>  arch/arm64/kernel/pci.c                    |  10 +
>  arch/arm64/kernel/setup.c                  |   7 +
>  arch/arm64/kernel/smp.c                    |   4 +
>  arch/arm64/mm/Makefile                     |   1 +
>  arch/arm64/mm/init.c                       |  46 +++-
>  arch/arm64/mm/mmu.c                        |   1 +
>  arch/arm64/mm/numa.c                       | 403 +++++++++++++++++++++++++++++
>  drivers/firmware/efi/Makefile              |   1 +
>  drivers/firmware/efi/arm-init.c            |  36 ++-
>  drivers/firmware/efi/efi-fdt.c             |  73 ++++++
>  drivers/firmware/efi/efi.c                 |  84 ------
>  drivers/firmware/efi/libstub/fdt.c         |  33 +--
>  drivers/of/Kconfig                         |   3 +
>  drivers/of/Makefile                        |   1 +
>  drivers/of/fdt.c                           |   7 +-
>  drivers/of/of_numa.c                       | 211 +++++++++++++++
>  include/linux/efi.h                        |   2 +-
>  include/linux/of.h                         |   9 +
>  include/linux/of_fdt.h                     |   1 +
>  26 files changed, 1178 insertions(+), 138 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/numa.txt
>  create mode 100644 arch/arm64/include/asm/mmzone.h
>  create mode 100644 arch/arm64/include/asm/numa.h
>  create mode 100644 arch/arm64/mm/numa.c
>  create mode 100644 drivers/firmware/efi/efi-fdt.c
>  create mode 100644 drivers/of/of_numa.c
>
> --
> 1.8.3.1
>
