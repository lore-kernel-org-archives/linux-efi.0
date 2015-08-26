From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2] arm64/efi: base UEFI mapping permissions on region attributes
Date: Wed, 26 Aug 2015 15:30:02 +0200
Message-ID: <1440595802-20359-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Currently, we infer the UEFI memory region mapping permissions
from the memory region type (i.e., runtime services code are
mapped RWX and runtime services data mapped RW-). This appears to
work fine but is not entirely UEFI spec compliant. So instead, use
the designated permission attributes to decide how these regions
should be mapped.

Since UEFIv2.5 introduces a new EFI_MEMORY_RO permission attribute,
and redefines EFI_MEMORY_WP as a cacheability attribute, use only
the former as a read-only attribute. For setting the PXN bit, the
corresponding EFI_MEMORY_XP attribute is used.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
Changes since v1:
- rewrote page size and alignment check to be more legible
- use code that is STRICT_MM_TYPECHECKS compliant

Example output of a recent Tianocore build on FVP Foundation model
is attached below.

 arch/arm64/kernel/efi.c | 37 +++++++++++++-------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index ab21e0d58278..c8d587f46f3e 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -235,7 +235,7 @@ static bool __init efi_virtmap_init(void)
 
 	for_each_efi_memory_desc(&memmap, md) {
 		u64 paddr, npages, size;
-		pgprot_t prot;
+		pteval_t prot_val;
 
 		if (!(md->attribute & EFI_MEMORY_RUNTIME))
 			continue;
@@ -247,22 +247,33 @@ static bool __init efi_virtmap_init(void)
 		memrange_efi_to_native(&paddr, &npages);
 		size = npages << PAGE_SHIFT;
 
-		pr_info("  EFI remap 0x%016llx => %p\n",
-			md->phys_addr, (void *)md->virt_addr);
+		if (!is_normal_ram(md))
+			prot_val = PROT_DEVICE_nGnRE;
+		else
+			prot_val = pgprot_val(PAGE_KERNEL_EXEC);
 
 		/*
-		 * Only regions of type EFI_RUNTIME_SERVICES_CODE need to be
-		 * executable, everything else can be mapped with the XN bits
-		 * set.
+		 * On 64 KB granule kernels, only use strict permissions when
+		 * the region does not share a 64 KB page frame with another
+		 * region at either end.
 		 */
-		if (!is_normal_ram(md))
-			prot = __pgprot(PROT_DEVICE_nGnRE);
-		else if (md->type == EFI_RUNTIME_SERVICES_CODE)
-			prot = PAGE_KERNEL_EXEC;
-		else
-			prot = PAGE_KERNEL;
+		if (PAGE_SIZE == EFI_PAGE_SIZE ||
+		    (PAGE_ALIGNED(md->virt_addr) &&
+		     PAGE_ALIGNED(md->phys_addr + md->num_pages * EFI_PAGE_SIZE))) {
+
+			if (md->attribute & EFI_MEMORY_RO)
+				prot_val |= PTE_RDONLY;
+			if (md->attribute & EFI_MEMORY_XP)
+				prot_val |= PTE_PXN;
+		}
+
+		pr_info("  EFI remap 0x%016llx => %p (R%c%c)\n",
+			md->phys_addr, (void *)md->virt_addr,
+			prot_val & PTE_RDONLY ? '-' : 'W',
+			prot_val & PTE_PXN ? '-' : 'X');
 
-		create_pgd_mapping(&efi_mm, paddr, md->virt_addr, size, prot);
+		create_pgd_mapping(&efi_mm, paddr, md->virt_addr, size,
+				   __pgprot(prot_val));
 	}
 	return true;
 }
-- 
1.9.1

Processing EFI memory map:
  0x00000c000000-0x00000ffeffff [Memory Mapped I/O  |RUN|XP|  |  |  |   |  |  |  |UC]
  0x00001c170000-0x00001c170fff [Memory Mapped I/O  |RUN|XP|  |  |  |   |  |  |  |UC]
  ...
  0x0008fabf0000-0x0008fac0ffff [Runtime Data       |RUN|XP|  |  |  |   |WB|WT|WC|UC]*
  0x0008fac10000-0x0008fac1ffff [Runtime Code       |RUN|  |  |  |RO|   |WB|WT|WC|UC]*
  0x0008fac20000-0x0008fac4ffff [Runtime Data       |RUN|XP|  |  |  |   |WB|WT|WC|UC]*
  0x0008fac50000-0x0008fac5ffff [Runtime Code       |RUN|  |  |  |RO|   |WB|WT|WC|UC]*
  0x0008fac60000-0x0008fac8ffff [Runtime Data       |RUN|XP|  |  |  |   |WB|WT|WC|UC]*
  0x0008fac90000-0x0008fac9ffff [Runtime Code       |RUN|  |  |  |RO|   |WB|WT|WC|UC]*
  0x0008faca0000-0x0008fad4ffff [Runtime Data       |RUN|XP|  |  |  |   |WB|WT|WC|UC]*
  0x0008fad50000-0x0008fad5ffff [Runtime Data       |RUN|XP|  |  |  |   |WB|WT|WC|UC]*
  0x0008fad60000-0x0008fad6ffff [Runtime Code       |RUN|  |  |  |RO|   |WB|WT|WC|UC]*
  0x0008fad70000-0x0008fae8ffff [Runtime Data       |RUN|XP|  |  |  |   |WB|WT|WC|UC]*
  0x0008fae90000-0x0008fae9ffff [Runtime Data       |RUN|XP|  |  |  |   |WB|WT|WC|UC]*
  0x0008faea0000-0x0008faeaffff [Runtime Code       |RUN|  |  |  |RO|   |WB|WT|WC|UC]*
  0x0008faeb0000-0x0008faf2ffff [Runtime Data       |RUN|XP|  |  |  |   |WB|WT|WC|UC]*
  0x0008faf30000-0x0008faf3ffff [Runtime Data       |RUN|XP|  |  |  |   |WB|WT|WC|UC]*
  0x0008faf40000-0x0008faf4ffff [Runtime Code       |RUN|  |  |  |RO|   |WB|WT|WC|UC]*
  0x0008faf50000-0x0008faf7ffff [Runtime Data       |RUN|XP|  |  |  |   |WB|WT|WC|UC]*
  ...
  0x0008fff50000-0x0008fff5ffff [Runtime Data       |RUN|XP|  |  |  |   |WB|WT|WC|UC]*
  0x0008fff60000-0x0008fff6ffff [Runtime Code       |RUN|  |  |  |RO|   |WB|WT|WC|UC]*
  0x0008fff70000-0x0008fff8ffff [Runtime Data       |RUN|XP|  |  |  |   |WB|WT|WC|UC]*
  0x0008fff90000-0x0008fff9ffff [Conventional Memory|   |  |  |  |  |   |WB|WT|WC|UC]
  0x0008fffa0000-0x0008fffeffff [Runtime Data       |RUN|XP|  |  |  |   |WB|WT|WC|UC]*
...
Remapping and enabling EFI services.
  EFI remap 0x000000000c000000 => 0000000040000000 (RW-)
  EFI remap 0x000000001c170000 => 0000000043ff0000 (RW-)
  EFI remap 0x00000008fabf0000 => 0000000044000000 (RW-)
  EFI remap 0x00000008fac10000 => 0000000044020000 (R-X)
  EFI remap 0x00000008fac20000 => 0000000044030000 (RW-)
  EFI remap 0x00000008fac50000 => 0000000044060000 (R-X)
  EFI remap 0x00000008fac60000 => 0000000044070000 (RW-)
  EFI remap 0x00000008fac90000 => 00000000440a0000 (R-X)
  EFI remap 0x00000008faca0000 => 00000000440b0000 (RW-)
  EFI remap 0x00000008fad50000 => 0000000044160000 (RW-)
  EFI remap 0x00000008fad60000 => 0000000044170000 (R-X)
  EFI remap 0x00000008fad70000 => 0000000044180000 (RW-)
  EFI remap 0x00000008fae90000 => 00000000442a0000 (RW-)
  EFI remap 0x00000008faea0000 => 00000000442b0000 (R-X)
  EFI remap 0x00000008faeb0000 => 00000000442c0000 (RW-)
  EFI remap 0x00000008faf30000 => 0000000044340000 (RW-)
  EFI remap 0x00000008faf40000 => 0000000044350000 (R-X)
  EFI remap 0x00000008faf50000 => 0000000044360000 (RW-)
  EFI remap 0x00000008fff50000 => 0000000044390000 (RW-)
  EFI remap 0x00000008fff60000 => 00000000443a0000 (R-X)
  EFI remap 0x00000008fff70000 => 00000000443b0000 (RW-)
  EFI remap 0x00000008fffa0000 => 00000000443d0000 (RW-)
