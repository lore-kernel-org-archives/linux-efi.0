From: David Daney <ddaney.cavm@gmail.com>
Subject: [PATCH v12 0/5] arm64, numa: Add numa support for arm64 platforms
Date: Mon, 22 Feb 2016 17:58:18 -0800
Message-ID: <1456192703-2274-1-git-send-email-ddaney.cavm@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Frank Rowand <frowand.list@gmail.com>, Grant Likely <grant.likely@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, linux-efi@vger.kernel.org, Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>, Robert Richter <rrichter@cavium.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
List-Id: linux-efi@vger.kernel.org

From: David Daney <david.daney@cavium.com>

v12:

	- Replaced 6 patches from Ard Biesheuvel with new simpler, and
          more correct, single patch, also from Ard.

v11:
	- Dropped cleanup patches for other architectures, they will be
          submitted as a separate set after more testing.

	- Added patch set from Ard Biesheuvel that are needed to make
          the whole thing actually work.  Previously this was a
          separate set.

	- Kconfig and other fixes and simplifications as suggested by Rob Herring.

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

Ganapatrao Kulkarni (4):
  Documentation, dt, numa: dt bindings for NUMA.
  dt, numa: Add NUMA dt binding implementation.
  arm64, numa: Add NUMA support for arm64 platforms.
  arm64, mm, numa: Add NUMA balancing support for arm64.

 Documentation/devicetree/bindings/numa.txt | 272 +++++++++++++++++++
 arch/arm64/Kconfig                         |  27 ++
 arch/arm64/include/asm/mmzone.h            |  12 +
 arch/arm64/include/asm/numa.h              |  45 ++++
 arch/arm64/include/asm/pgtable.h           |  15 ++
 arch/arm64/include/asm/topology.h          |  10 +
 arch/arm64/kernel/pci.c                    |  10 +
 arch/arm64/kernel/setup.c                  |   4 +
 arch/arm64/kernel/smp.c                    |   4 +
 arch/arm64/mm/Makefile                     |   1 +
 arch/arm64/mm/init.c                       |  34 ++-
 arch/arm64/mm/mmu.c                        |   1 +
 arch/arm64/mm/numa.c                       | 403 +++++++++++++++++++++++++++++
 drivers/firmware/efi/arm-init.c            |   8 +
 drivers/firmware/efi/libstub/fdt.c         |  24 +-
 drivers/of/Kconfig                         |   3 +
 drivers/of/Makefile                        |   1 +
 drivers/of/of_numa.c                       | 211 +++++++++++++++
 include/linux/of.h                         |   9 +
 19 files changed, 1066 insertions(+), 28 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/numa.txt
 create mode 100644 arch/arm64/include/asm/mmzone.h
 create mode 100644 arch/arm64/include/asm/numa.h
 create mode 100644 arch/arm64/mm/numa.c
 create mode 100644 drivers/of/of_numa.c

-- 
1.8.3.1
