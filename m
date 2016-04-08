From: David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v16 0/6] arm64, numa: Add numa support for arm64 platforms
Date: Fri,  8 Apr 2016 15:50:22 -0700
Message-ID: <1460155828-8690-1-git-send-email-ddaney.cavm@gmail.com>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>

v16:

	- No functional change.

	- Rebase to v4.6-rc2 to avoid merge conflicts.

v15:

	- Make the distance-map node optional (again), if it is not in
          the device tree, default values are used.

	- Minor cleanups to of_numa.c as suggested by Rob Harring.

v14:
	- Revised patch to unflatten the device tree earlier.

	- Cleanups and added EXPORT_SYMBOL to of_numa.c as suggested
          by Rob Harring

v13:
	- Added patch to unflatten the device tree earlier.

	- Rewrote of_numa.c to work on unflattened the device tree.

	- Cleanup of EXPORTs in arch/arm64/mm/numa.c as suggested by
          Will Deacon.

v12:

	- Replaced 6 patches from Ard Biesheuvel with new simpler, and
          more correct, single patch, also from Ard.

v11:
	- Dropped cleanup patches for other architectures, they will be
          submitted as a separate set after more testing.

	- Added patch set from Ard Biesheuvel that are needed to make
          the whole thing actually work.  Previously this was a
          separate set.

	- Kconfig and other fixes and simplifications as suggested by
          Rob Herring.

	- Rearranged, refactored and reordered so that we don't patch
          new files multiple times.

	- Summary:

		o 6 patches from Ard Biesheuvel to allow use of
		  "memory" nodes with efi stub.

		o 2 patches to document and add of_numa.c

		o 1 patch to add arm64 NUMA support.

		o 1 patch to add NUMA balancing support for arm64.

v10:
	- Incorporated review comments from Rob Herring.
	- Moved numa binding and implementation to devicetree core.
	- Added cleanup patch to remove redundant NODE_DATA macro from asm header files
	- Include numa balancing support for arm64 patch in this series.
	- Fix tile build issue reported by the kbuild robot(patch 7)

v9:	- Added cleanup patch to reuse and avoid redefinition of cpumask_of_pcibus
	  as suggested from Will Deacon and Bjorn Helgaas.
	  - Including patch to Make pci-host-generic driver numa aware.
	  - Incorporated comment from Shannon Zhao.

v8:
	- Incorporated review comments of Mark Rutland and Will Deacon.
	- Added pci helper function and macro for numa.

v7:
	- managing numa memory mapping using memblock.
	- Incorporated review comments of Mark Rutland.

v6:
	- defined and implemented the numa dt binding using
	node property proximity and device node distance-map.
	- renamed dt_numa to of_numa

v5:
        - created base verion of numa.c which creates dummy numa without using dt
          on single socket platforms. Then added patches for dt support.
        - Incorporated review comments from Hanjun Guo.

v4:
done changes as per Arnd review comments.

v3:
Added changes to support numa on arm64 based platforms.
Tested these patches on cavium's multinode(2 node topology) platform.
In this patchset, defined and implemented dt bindings for numa mapping
for core and memory using device node property arm,associativity.

v2:
Defined and implemented numa map for memory, cores to node and
proximity distance matrix of nodes.

v1:
Initial patchset to support numa on arm64 platforms.

Note: 1. This patchset is tested for NUMA and without NUMA with dt
        (both with and without NUMA bindings) on thunderx single
        socket and dual socket boards.

Ard Biesheuvel (1):
  efi: ARM/arm64: ignore DT memory nodes instead of removing them

David Daney (2):
  of, numa: Add NUMA of binding implementation.
  arm64: Move unflatten_device_tree() call earlier.

Ganapatrao Kulkarni (3):
  Documentation, dt, numa: dt bindings for NUMA.
  arm64, numa: Add NUMA support for arm64 platforms.
  arm64, mm, numa: Add NUMA balancing support for arm64.

 Documentation/devicetree/bindings/numa.txt | 275 ++++++++++++++++++++
 arch/arm64/Kconfig                         |  27 ++
 arch/arm64/include/asm/mmu.h               |   1 +
 arch/arm64/include/asm/mmzone.h            |  12 +
 arch/arm64/include/asm/numa.h              |  45 ++++
 arch/arm64/include/asm/pgtable.h           |  15 ++
 arch/arm64/include/asm/topology.h          |  10 +
 arch/arm64/kernel/pci.c                    |  10 +
 arch/arm64/kernel/setup.c                  |  17 +-
 arch/arm64/kernel/smp.c                    |   4 +
 arch/arm64/mm/Makefile                     |   1 +
 arch/arm64/mm/init.c                       |  35 ++-
 arch/arm64/mm/mm.h                         |   1 -
 arch/arm64/mm/mmu.c                        |   2 -
 arch/arm64/mm/numa.c                       | 396 +++++++++++++++++++++++++++++
 drivers/firmware/efi/arm-init.c            |   8 +
 drivers/firmware/efi/libstub/fdt.c         |  24 +-
 drivers/of/Kconfig                         |   3 +
 drivers/of/Makefile                        |   1 +
 drivers/of/of_numa.c                       | 211 +++++++++++++++
 include/linux/of.h                         |   9 +
 21 files changed, 1072 insertions(+), 35 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/numa.txt
 create mode 100644 arch/arm64/include/asm/mmzone.h
 create mode 100644 arch/arm64/include/asm/numa.h
 create mode 100644 arch/arm64/mm/numa.c
 create mode 100644 drivers/of/of_numa.c

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
