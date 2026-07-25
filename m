Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B3C2C181
	for <linux-efi@vger.kernel.org>; Sat, 25 Jul 2026 13:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784986298; cv=none; b=k3HvEoQ8AMBkx0LJtZbPHUJSSrkHMHgU7+LmrPx/ePfe02Ds9qNoCnsuYIeqkooIpOMx+tOmSgip9qT8SBVqUWoybyEQvk+U6BxsQ3COW3Jx2HUzY+5e0vp8yAoDwCGKNjo5uolOvJl/NbCt+PnTqgb6xSE5aKiZJqLy3/COp6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784986298; c=relaxed/simple;
	bh=kmt/4GkF599tvpEqF+FCtG5b5w552nPfoGE1z7N2snA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=T3fJCpH7THmbViJ/6wfyOoNjQxdHoMws/Tdz7UwDaJlLf7ED+9/dU8KrpZqHAOqDKbPaM+uombrowJ/8dDBzvnjbo3PdgQl8dxL5LVIO8zlw31JvJyO2aEovsRAYz2917SGl3KSTaZXBUOT1KtDZJApXpD+2hPlQODAFoE87tEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TS7Abgsi; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TS7Abgsi"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4954f5e8020so6456215e9.2
        for <linux-efi@vger.kernel.org>; Sat, 25 Jul 2026 06:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784986292; x=1785591092; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jxjNC91EAnowiVmfYJTspYInwCXVKZ/rQl6vdAco4wA=;
        b=TS7AbgsiRcsLPBTB4svjEhr36bZj0yfKzXJSFXvumP3coxxGR2mjWeRUM86f/JUNHj
         Cwik8EUhl+e/tQ2klWYZ+X8AjCSqiHoWI7Pj9WrBZP5Pugu3gE4k4V8eLRBA/pZR2/gy
         Ysn5mA+2vTHzYcoMgFqMTMGa8VOP/sfHeAo983VHiM/aTnGaQ8W/BSeNanSLnju5zRMa
         O3yi+tJRvpHovivnOP0GxMEw3//QVXAldpYQD61Qn7CtvJut4Wx2E4oer14Hhi32zDRn
         Zc5Hf5YuVpYXxBOypIBiWV7s0iIwBaocoiwasYQqSbsgGSbmtHHI7s4Og882kEyyh9n9
         /f6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784986292; x=1785591092;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jxjNC91EAnowiVmfYJTspYInwCXVKZ/rQl6vdAco4wA=;
        b=Mh8eiXxCQRnB80PF8s1RuPCUjxMDRiTXWQR8tw3qcjDUWNj0LNVuGrEY32qgRXCYki
         6Vxni1rE5wQvRBJfmXg+VCqXepp9J1B2tLIMBGq0SWP2lxDkmPWWIPZd9EcYT1lUUDYM
         h38sQVNa+dUzRvWMsEfSehm/Aw5xY0D8L/vg930hF0m0aURg+iZBC4hkhrcVb6pjta1g
         G4Urx2Po6gDMAzEBht6y79h92WhrdsB8ejAdNrc/mAP5o5cz3SchH9rZyQ2PdhzorE6h
         0bqhoDQHfdOfiZI68tZvPG7+w7yOO5ueKCpzH3tzF47OvcKeQM/r3ou3E3DyQSRYJ3Wx
         u5lA==
X-Forwarded-Encrypted: i=1; AHgh+RrJwtjEXzQVmMTa66CrGhEwTkGb+BPQiUFI6sg2TVzX1YXOnrB8ci3/ExBfcG9W3dF9YcwqcvsBo7M=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXiNSa9Ez3fJ+p4CWyVncq1Q3gf3osf9SopwvJ5Ej/PSHNVwC7
	jqYcgOT6FPW4iso0YNagREcpqMCfVfefQ61NM+/iKF91ZXVqoOQlZVWI
X-Gm-Gg: AR+sD1080+3o4CV7Ak3Fr5ej/ys/4A+a9TZZZkPd/o5KRDZggbClqxXRuTtxdmWYPAI
	oGNZfAXZLS8czvuVHXQET84mNnwQx0reyjL+AMapLDoSMIhskgDKktlVz53WBHvjjPRIRivQ52w
	+uTumWrqH/+fP52J1NQKM8XLaPLkad/8it5ZZCcVqUCoug2dXzPsMadFeA/prBcTI5FEKpTlRuA
	pIX3NhSkN14DXqbuJqWg7so4KVmcSUzH9KMFOGWYKJs362sPrUOvzrYLBbGsMXKKKW5ZS35T1Dc
	3MabOYofEkVXCpB9s8J8d9eBLz1cIG6qQkjA7cONbyy9TTsunqihwSZN4r15u0MkwxSbX9ACpNn
	7+nSnC0k2BHUUjnB6GgTKe7KHOjtBDUqdIk2usGah6STvRkxK0gUm6hQ6T6LyS+hnL9zh7GqVXh
	kiY3/yHQIKiwpu3O5CSP+Nwr9eCGqdw8pZnps29h8b77GqE0M111sm4iihzbYuRZ+0F/b8QhKyV
	e/1jWcTD3dtiu6f39XVPMWBWyafD/SZ3Gl4xFBgbubfE158Ny7c8goIHfuMwtLnnntMySGY9qSn
	BOpQ1pq5cg==
X-Received: by 2002:a7b:cb4c:0:b0:495:779c:fbef with SMTP id 5b1f17b1804b1-496b57350ccmr18969515e9.37.1784986291871;
        Sat, 25 Jul 2026 06:31:31 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-b344-be01-c902-8e3f-9491-60c2.310.pool.telefonica.de. [2a02:3100:b344:be01:c902:8e3f:9491:60c2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4957b842691sm119888725e9.1.2026.07.25.06.31.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 25 Jul 2026 06:31:30 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>,
	linux-arm-kernel@lists.infradead.org
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	linux-efi@vger.kernel.org,
	Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	linux-kernel@vger.kernel.org,
	Kevin Cernekee <cernekee@gmail.com>,
	Gregory Fong <gregory.0xf0@gmail.com>
Subject: [PATCH v3] ARM: set !LPAE MAX_PHYSMEM_BITS to 32 and remove supersection mappings
Date: Sat, 25 Jul 2026 15:31:22 +0200
Message-Id: <20260725133122.2723-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An ARM randconfig with CONFIG_GET_FREE_REGION=y and CONFIG_WERROR=y
fails to build:

  include/linux/minmax.h:86:37: error: conversion from 'long long
  unsigned int' to 'resource_size_t' {aka 'unsigned int'} changes
  value from '68719476735' to '4294967295' [-Werror=overflow]

Commit 14b80582c43e ("resource: Introduce alloc_free_mem_region()")
made kernel/resource.c clamp against
(1ULL << MAX_PHYSMEM_BITS) - 1.  resource_size_t is 32-bit without
LPAE, but ARM's default MAX_PHYSMEM_BITS is 36.

That default was added by commit db57f88e4ccb ("ARM: 8411/1: Add
default SPARSEMEM settings") because several platforms needed at
least 36 physical address bits.  !LPAE could map addresses above
32 bits only through supersections.

CONFIG_IO_36, added by commit 23bdf86aa06e ("[ARM] 3377/2: add
support for intel xsc3 core"), enabled these for XSC3 I/O.  IXP23xx
placed static I/O mappings above 4GiB until its removal in 2012, and
IOP13xx ioremap()ed its PCIe windows there until its removal in 2019.
The only remaining XSC3 platform, PXA3xx, has nothing above 4GiB.

Supersection address bits overlap the descriptor domain field, so
IO_36 also renumbered the domains to make DOMAIN_IO zero.  Remove
IO_36, the alternate domain numbering, and ioremap()'s supersection
path.  Reject !LPAE ioremap ranges extending past 4GiB before
phys_addr_t truncation, drop the now-unneeded high static-mapping
exclusion, and reduce ioremap alignment from 16MiB to the 2MiB
covered by a PMD's pair of sections.

The other supersection user, create_36bit_mapping(), was added by
commit 0b7cd62ecdc1 ("[ARM] 3017/1: Add support for 36-bit addresses
to create_mapping()") for IXP2350 and carried IXP23xx's high static
mappings.  Before this change, its only remaining call path was
efi_create_mapping() -> create_mapping_late(), for an EFI runtime
region above 4GiB.

No real-world user of this !LPAE path is known.  AArch32 UEFI
requires RAM described by its memory map to be identity-mapped
during boot services, which a 32-bit virtual address space cannot
provide above 4GiB.  Systems needing wider physical addressing are
expected to use LPAE.

Remove create_36bit_mapping() and the supersection definitions.  If
firmware nevertheless advertises such a region on !LPAE,
efi_create_mapping() rejects it before __pfn_to_phys() truncates its
address to a low alias.  EFI runtime services remain disabled, but
the kernel continues to boot.  LPAE kernels are unaffected.

With no remaining !LPAE mappings above 4GiB, set MAX_PHYSMEM_BITS to
32 for !LPAE and retain 36 for LPAE, where phys_addr_t is 64-bit.

Link: https://lore.kernel.org/all/3c79d2dc-8fbd-40fc-8b2d-9d1b4f8ed34e@app.fastmail.com/
Link: https://lore.kernel.org/all/CAK8P3a2MCdUbN0QSb+M3g5_6HjPsaQwtKxFjADMZWomdry4-Ww@mail.gmail.com/
Fixes: 14b80582c43e ("resource: Introduce alloc_free_mem_region()")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
v3: per Arnd's request, remove the remaining supersection code as
well: create_36bit_mapping() and the PMD_SECT_SUPER/SUPERSECTION_*
definitions.  efi_create_mapping() now rejects EFI runtime regions
extending beyond 4GiB on !LPAE with -ERANGE before __pfn_to_phys()
truncates their addresses, so efi_virtmap_init() keeps runtime
services disabled.  Corrected history: the 36-bit default came from
db57f88e4ccb, and create_36bit_mapping() served IXP23xx's static
mappings.  Retitled (was: "ARM: set !LPAE MAX_PHYSMEM_BITS to 32 and
remove IO_36").

Build-tested: multi_v7 + EFI (!LPAE and LPAE), pxa3xx_defconfig
(XSC3; build only - QEMU has no XSC3 emulation), versatile_defconfig,
and the originally failing GET_FREE_REGION + WERROR configuration.
Boot-tested on QEMU virt/Cortex-A15 with 32-bit EDK2, covering the
rejection boundaries: stock firmware keeps runtime services on
!LPAE; a runtime region ending exactly at 4GiB is accepted and
mapped; regions crossing 4GiB, starting exactly at 4GiB, and
entirely above it are each rejected on !LPAE with runtime services
cleanly disabled and the boot continuing; an LPAE kernel maps the
>4GiB region; efivars works in every enabled case.  versatilepb
(ARMv5, UP, !SMP ioremap path) boots to a shell.  Applies to v6.1
with a one-line include-context fixup in efi.c.

v2: https://lore.kernel.org/all/20260724174748.65958-1-kmehltretter@gmail.com/
    fold in the IO_36 removal and its ioremap path, as requested by
    Arnd; correct the history (IOP13xx was removed in 2019, not 2012).

v1: https://lore.kernel.org/all/20260724063048.12565-1-kmehltretter@gmail.com/

 arch/arm/include/asm/domain.h               | 17 -----
 arch/arm/include/asm/memory.h               |  4 +-
 arch/arm/include/asm/pgtable-2level-hwdef.h |  1 -
 arch/arm/include/asm/pgtable-2level.h       |  7 --
 arch/arm/include/asm/sparsemem.h            |  4 ++
 arch/arm/kernel/efi.c                       | 13 ++++
 arch/arm/mm/Kconfig                         |  7 --
 arch/arm/mm/ioremap.c                       | 53 ++------------
 arch/arm/mm/mmu.c                           | 76 +--------------------
 9 files changed, 27 insertions(+), 155 deletions(-)

diff --git a/arch/arm/include/asm/domain.h b/arch/arm/include/asm/domain.h
index d48859fdf32c..f91c2a72b9dc 100644
--- a/arch/arm/include/asm/domain.h
+++ b/arch/arm/include/asm/domain.h
@@ -18,27 +18,10 @@
  *  DOMAIN_IO     - domain 2 includes all IO only
  *  DOMAIN_USER   - domain 1 includes all user memory only
  *  DOMAIN_KERNEL - domain 0 includes all kernel memory only
- *
- * The domain numbering depends on whether we support 36 physical
- * address for I/O or not.  Addresses above the 32 bit boundary can
- * only be mapped using supersections and supersections can only
- * be set for domain 0.  We could just default to DOMAIN_IO as zero,
- * but there may be systems with supersection support and no 36-bit
- * addressing.  In such cases, we want to map system memory with
- * supersections to reduce TLB misses and footprint.
- *
- * 36-bit addressing and supersections are only available on
- * CPUs based on ARMv6+ or the Intel XSC3 core.
  */
-#ifndef CONFIG_IO_36
 #define DOMAIN_KERNEL	0
 #define DOMAIN_USER	1
 #define DOMAIN_IO	2
-#else
-#define DOMAIN_KERNEL	2
-#define DOMAIN_USER	1
-#define DOMAIN_IO	0
-#endif
 #define DOMAIN_VECTORS	3
 
 /*
diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index 7c2fa7dcec6d..e25749bfbf90 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -89,9 +89,9 @@
 
 #if !defined(CONFIG_SMP) && !defined(CONFIG_ARM_LPAE)
 /*
- * Allow 16MB-aligned ioremap pages
+ * Allow 2MB-aligned ioremap pages
  */
-#define IOREMAP_MAX_ORDER	24
+#define IOREMAP_MAX_ORDER	21
 #endif
 
 #define VECTORS_BASE		UL(0xffff0000)
diff --git a/arch/arm/include/asm/pgtable-2level-hwdef.h b/arch/arm/include/asm/pgtable-2level-hwdef.h
index 556937e1790e..3fa254ac8a26 100644
--- a/arch/arm/include/asm/pgtable-2level-hwdef.h
+++ b/arch/arm/include/asm/pgtable-2level-hwdef.h
@@ -35,7 +35,6 @@
 #define PMD_SECT_APX		(_AT(pmdval_t, 1) << 15)	/* v6 */
 #define PMD_SECT_S		(_AT(pmdval_t, 1) << 16)	/* v6 */
 #define PMD_SECT_nG		(_AT(pmdval_t, 1) << 17)	/* v6 */
-#define PMD_SECT_SUPER		(_AT(pmdval_t, 1) << 18)	/* v6 */
 #define PMD_SECT_AF		(_AT(pmdval_t, 0))
 
 #define PMD_SECT_UNCACHED	(_AT(pmdval_t, 0))
diff --git a/arch/arm/include/asm/pgtable-2level.h b/arch/arm/include/asm/pgtable-2level.h
index 6b5392e20f41..7e1c08fdd029 100644
--- a/arch/arm/include/asm/pgtable-2level.h
+++ b/arch/arm/include/asm/pgtable-2level.h
@@ -96,13 +96,6 @@
 #define SECTION_SIZE		(1UL << SECTION_SHIFT)
 #define SECTION_MASK		(~(SECTION_SIZE-1))
 
-/*
- * ARMv6 supersection address mask and size definitions.
- */
-#define SUPERSECTION_SHIFT	24
-#define SUPERSECTION_SIZE	(1UL << SUPERSECTION_SHIFT)
-#define SUPERSECTION_MASK	(~(SUPERSECTION_SIZE-1))
-
 #define USER_PTRS_PER_PGD	(TASK_SIZE / PGDIR_SIZE)
 
 /*
diff --git a/arch/arm/include/asm/sparsemem.h b/arch/arm/include/asm/sparsemem.h
index 421e3415338a..6b512be3a34a 100644
--- a/arch/arm/include/asm/sparsemem.h
+++ b/arch/arm/include/asm/sparsemem.h
@@ -19,7 +19,11 @@
  * These can be overridden in your mach/memory.h.
  */
 #if !defined(MAX_PHYSMEM_BITS) || !defined(SECTION_SIZE_BITS)
+#ifdef CONFIG_ARM_LPAE
 #define MAX_PHYSMEM_BITS	36
+#else
+#define MAX_PHYSMEM_BITS	32
+#endif
 #define SECTION_SIZE_BITS	28
 #endif
 
diff --git a/arch/arm/kernel/efi.c b/arch/arm/kernel/efi.c
index 6f9ec7d28a71..c14275257a8a 100644
--- a/arch/arm/kernel/efi.c
+++ b/arch/arm/kernel/efi.c
@@ -6,6 +6,7 @@
 #include <linux/efi.h>
 #include <linux/memblock.h>
 #include <linux/screen_info.h>
+#include <linux/sizes.h>
 
 #include <asm/efi.h>
 #include <asm/mach/map.h>
@@ -54,6 +55,18 @@ int __init efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md)
 		.length		= md->num_pages * EFI_PAGE_SIZE,
 	};
 
+	/*
+	 * Non-LPAE page tables cannot map EFI runtime regions extending
+	 * beyond the 32-bit physical address space.
+	 */
+	if (!IS_ENABLED(CONFIG_ARM_LPAE) &&
+	    (md->phys_addr >= SZ_4G ||
+	     md->num_pages > (SZ_4G - md->phys_addr) / EFI_PAGE_SIZE)) {
+		pr_warn("EFI runtime region at 0x%llx exceeds 32-bit physical address space\n",
+			md->phys_addr);
+		return -ERANGE;
+	}
+
 	/*
 	 * Order is important here: memory regions may have all of the
 	 * bits below set (and usually do), so we check them in order of
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index 871bd58d2ccc..07f1165ca794 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -328,7 +328,6 @@ config CPU_XSC3
 	select CPU_PABRT_LEGACY
 	select CPU_THUMB_CAPABLE
 	select CPU_TLB_V4WBI if MMU
-	select IO_36
 
 # Marvell PJ1 (Mohawk)
 config CPU_MOHAWK
@@ -652,12 +651,6 @@ config CPU_V7M_NUM_IRQ
 
 	  If unsure, keep default value.
 
-#
-# CPU supports 36-bit I/O
-#
-config IO_36
-	bool
-
 comment "Processor Features"
 
 config ARM_LPAE
diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index 27e64f782cb3..539b6c2995af 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -30,8 +30,6 @@
 #include <linux/sizes.h>
 #include <linux/memblock.h>
 
-#include <asm/cp15.h>
-#include <asm/cputype.h>
 #include <asm/cacheflush.h>
 #include <asm/early_ioremap.h>
 #include <asm/mmu_context.h>
@@ -236,39 +234,6 @@ remap_area_sections(unsigned long virt, unsigned long pfn,
 	return 0;
 }
 
-static int
-remap_area_supersections(unsigned long virt, unsigned long pfn,
-			 size_t size, const struct mem_type *type)
-{
-	unsigned long addr = virt, end = virt + size;
-	pmd_t *pmd = pmd_off_k(addr);
-
-	/*
-	 * Remove and free any PTE-based mapping, and
-	 * sync the current kernel mapping.
-	 */
-	unmap_area_sections(virt, size);
-	do {
-		unsigned long super_pmd_val, i;
-
-		super_pmd_val = __pfn_to_phys(pfn) | type->prot_sect |
-				PMD_SECT_SUPER;
-		super_pmd_val |= ((pfn >> (32 - PAGE_SHIFT)) & 0xf) << 20;
-
-		for (i = 0; i < 8; i++) {
-			pmd[0] = __pmd(super_pmd_val);
-			pmd[1] = __pmd(super_pmd_val);
-			flush_pmd_entry(pmd);
-
-			addr += PMD_SIZE;
-			pmd += 2;
-		}
-
-		pfn += SUPERSECTION_SIZE >> PAGE_SHIFT;
-	} while (addr < end);
-
-	return 0;
-}
 #endif
 
 static void __iomem * __arm_ioremap_pfn_caller(unsigned long pfn,
@@ -278,15 +243,17 @@ static void __iomem * __arm_ioremap_pfn_caller(unsigned long pfn,
 	int err;
 	unsigned long addr;
 	struct vm_struct *area;
-	phys_addr_t paddr = __pfn_to_phys(pfn);
+	phys_addr_t paddr;
 
 #ifndef CONFIG_ARM_LPAE
 	/*
-	 * High mappings must be supersection aligned
+	 * The physical range must not extend beyond the 32-bit
+	 * phys_addr_t
 	 */
-	if (pfn >= 0x100000 && (paddr & ~SUPERSECTION_MASK))
+	if (((u64)pfn << PAGE_SHIFT) + offset + size > SZ_4G)
 		return NULL;
 #endif
+	paddr = __pfn_to_phys(pfn);
 
 	type = get_mem_type(mtype);
 	if (!type)
@@ -300,7 +267,7 @@ static void __iomem * __arm_ioremap_pfn_caller(unsigned long pfn,
 	/*
 	 * Try to reuse one of the static mapping whenever possible.
 	 */
-	if (size && !(sizeof(phys_addr_t) == 4 && pfn >= 0x100000)) {
+	if (size) {
 		struct static_vm *svm;
 
 		svm = find_static_vm_paddr(paddr, size, mtype);
@@ -326,13 +293,7 @@ static void __iomem * __arm_ioremap_pfn_caller(unsigned long pfn,
 	area->phys_addr = paddr;
 
 #if !defined(CONFIG_SMP) && !defined(CONFIG_ARM_LPAE)
-	if (DOMAIN_IO == 0 &&
-	    (((cpu_architecture() >= CPU_ARCH_ARMv6) && (get_cr() & CR_XP)) ||
-	       cpu_is_xsc3()) && pfn >= 0x100000 &&
-	       !((paddr | size | addr) & ~SUPERSECTION_MASK)) {
-		area->flags |= VM_ARM_SECTION_MAPPING;
-		err = remap_area_supersections(addr, pfn, size, type);
-	} else if (!((paddr | size | addr) & ~PMD_MASK)) {
+	if (!((paddr | size | addr) & ~PMD_MASK)) {
 		area->flags |= VM_ARM_SECTION_MAPPING;
 		err = remap_area_sections(addr, pfn, size, type);
 	} else
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index 23b87b5ef7f1..5d0ae2529872 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -854,69 +854,6 @@ static void __init alloc_init_p4d(pgd_t *pgd, unsigned long addr,
 	} while (p4d++, addr = next, addr != end);
 }
 
-#ifndef CONFIG_ARM_LPAE
-static void __init create_36bit_mapping(struct mm_struct *mm,
-					struct map_desc *md,
-					const struct mem_type *type,
-					bool ng)
-{
-	unsigned long addr, length, end;
-	phys_addr_t phys;
-	pgd_t *pgd;
-
-	addr = md->virtual;
-	phys = __pfn_to_phys(md->pfn);
-	length = PAGE_ALIGN(md->length);
-
-	if (!(cpu_architecture() >= CPU_ARCH_ARMv6 || cpu_is_xsc3())) {
-		pr_err("MM: CPU does not support supersection mapping for 0x%08llx at 0x%08lx\n",
-		       (long long)__pfn_to_phys((u64)md->pfn), addr);
-		return;
-	}
-
-	/* N.B.	ARMv6 supersections are only defined to work with domain 0.
-	 *	Since domain assignments can in fact be arbitrary, the
-	 *	'domain == 0' check below is required to insure that ARMv6
-	 *	supersections are only allocated for domain 0 regardless
-	 *	of the actual domain assignments in use.
-	 */
-	if (type->domain) {
-		pr_err("MM: invalid domain in supersection mapping for 0x%08llx at 0x%08lx\n",
-		       (long long)__pfn_to_phys((u64)md->pfn), addr);
-		return;
-	}
-
-	if ((addr | length | __pfn_to_phys(md->pfn)) & ~SUPERSECTION_MASK) {
-		pr_err("MM: cannot create mapping for 0x%08llx at 0x%08lx invalid alignment\n",
-		       (long long)__pfn_to_phys((u64)md->pfn), addr);
-		return;
-	}
-
-	/*
-	 * Shift bits [35:32] of address into bits [23:20] of PMD
-	 * (See ARMv6 spec).
-	 */
-	phys |= (((md->pfn >> (32 - PAGE_SHIFT)) & 0xF) << 20);
-
-	pgd = pgd_offset(mm, addr);
-	end = addr + length;
-	do {
-		p4d_t *p4d = p4d_offset(pgd, addr);
-		pud_t *pud = pud_offset(p4d, addr);
-		pmd_t *pmd = pmd_offset(pud, addr);
-		int i;
-
-		for (i = 0; i < 16; i++)
-			*pmd++ = __pmd(phys | type->prot_sect | PMD_SECT_SUPER |
-				       (ng ? PMD_SECT_nG : 0));
-
-		addr += SUPERSECTION_SIZE;
-		phys += SUPERSECTION_SIZE;
-		pgd += SUPERSECTION_SIZE >> PGDIR_SHIFT;
-	} while (addr != end);
-}
-#endif	/* !CONFIG_ARM_LPAE */
-
 static void __init __create_mapping(struct mm_struct *mm, struct map_desc *md,
 				    void *(*alloc)(unsigned long sz),
 				    bool ng)
@@ -928,16 +865,6 @@ static void __init __create_mapping(struct mm_struct *mm, struct map_desc *md,
 
 	type = &mem_types[md->type];
 
-#ifndef CONFIG_ARM_LPAE
-	/*
-	 * Catch 36-bit addresses
-	 */
-	if (md->pfn >= 0x100000) {
-		create_36bit_mapping(mm, md, type, ng);
-		return;
-	}
-#endif
-
 	addr = md->virtual & PAGE_MASK;
 	phys = __pfn_to_phys(md->pfn);
 	length = PAGE_ALIGN(md->length + (md->virtual & ~PAGE_MASK));
@@ -964,8 +891,7 @@ static void __init __create_mapping(struct mm_struct *mm, struct map_desc *md,
  * Create the page directory entries and any necessary
  * page tables for the mapping specified by `md'.  We
  * are able to cope here with varying sizes and address
- * offsets, and we take full advantage of sections and
- * supersections.
+ * offsets, and we take full advantage of sections.
  */
 static void __init create_mapping(struct map_desc *md)
 {
-- 
2.53.0
