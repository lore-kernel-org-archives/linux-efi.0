From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 2/2] arm64/efi: Don't pad between EFI_MEMORY_RUNTIME regions
Date: Fri, 25 Sep 2015 23:02:19 +0100
Message-ID: <1443218539-7610-3-git-send-email-matt@codeblueprint.co.uk>
References: <1443218539-7610-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1443218539-7610-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Leif Lindholm <leif.lindholm@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, stable@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>, Mark Rutland <mark.rutland@arm.com>, Mark Salter <msalter@redhat.com>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

The new Properties Table feature introduced in UEFIv2.5 may split
memory regions that cover PE/COFF memory images into separate code
and data regions. Since these regions only differ in the type (runtime
code vs runtime data) and the permission bits, but not in the memory
type attributes (UC/WC/WT/WB), the spec does not require them to be
aligned to 64 KB.

Since the relative offset of PE/COFF .text and .data segments cannot
be changed on the fly, this means that we can no longer pad out those
regions to be mappable using 64 KB pages.
Unfortunately, there is no annotation in the UEFI memory map that
identifies data regions that were split off from a code region, so we
must apply this logic to all adjacent runtime regions whose attributes
only differ in the permission bits.

So instead of rounding each memory region to 64 KB alignment at both
ends, only round down regions that are not directly preceded by another
runtime region with the same type attributes. Since the UEFI spec does
not mandate that the memory map be sorted, this means we also need to
sort it first.

Note that this change will result in all EFI_MEMORY_RUNTIME regions whose
start addresses are not aligned to the OS page size to be mapped with
executable permissions (i.e., on kernels compiled with 64 KB pages).
However, since these mappings are only active during the time that UEFI
Runtime Services are being invoked, the window for abuse is rather small.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Tested-by: Mark Salter <msalter@redhat.com>
Reviewed-by: Mark Salter <msalter@redhat.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: Mark Rutland <mark.rutland@arm.com> [UEFI 2.4 only]
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: <stable@vger.kernel.org> # v4.0+
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/arm64/kernel/efi.c                 |  3 +-
 drivers/firmware/efi/libstub/arm-stub.c | 88 +++++++++++++++++++++++++++------
 2 files changed, 75 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index e8ca6eaedd02..13671a9cf016 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -258,7 +258,8 @@ static bool __init efi_virtmap_init(void)
 		 */
 		if (!is_normal_ram(md))
 			prot = __pgprot(PROT_DEVICE_nGnRE);
-		else if (md->type == EFI_RUNTIME_SERVICES_CODE)
+		else if (md->type == EFI_RUNTIME_SERVICES_CODE ||
+			 !PAGE_ALIGNED(md->phys_addr))
 			prot = PAGE_KERNEL_EXEC;
 		else
 			prot = PAGE_KERNEL;
diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index e29560e6b40b..950c87f5d279 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/efi.h>
+#include <linux/sort.h>
 #include <asm/efi.h>
 
 #include "efistub.h"
@@ -305,6 +306,44 @@ fail:
  */
 #define EFI_RT_VIRTUAL_BASE	0x40000000
 
+static int cmp_mem_desc(const void *l, const void *r)
+{
+	const efi_memory_desc_t *left = l, *right = r;
+
+	return (left->phys_addr > right->phys_addr) ? 1 : -1;
+}
+
+/*
+ * Returns whether region @left ends exactly where region @right starts,
+ * or false if either argument is NULL.
+ */
+static bool regions_are_adjacent(efi_memory_desc_t *left,
+				 efi_memory_desc_t *right)
+{
+	u64 left_end;
+
+	if (left == NULL || right == NULL)
+		return false;
+
+	left_end = left->phys_addr + left->num_pages * EFI_PAGE_SIZE;
+
+	return left_end == right->phys_addr;
+}
+
+/*
+ * Returns whether region @left and region @right have compatible memory type
+ * mapping attributes, and are both EFI_MEMORY_RUNTIME regions.
+ */
+static bool regions_have_compatible_memory_type_attrs(efi_memory_desc_t *left,
+						      efi_memory_desc_t *right)
+{
+	static const u64 mem_type_mask = EFI_MEMORY_WB | EFI_MEMORY_WT |
+					 EFI_MEMORY_WC | EFI_MEMORY_UC |
+					 EFI_MEMORY_RUNTIME;
+
+	return ((left->attribute ^ right->attribute) & mem_type_mask) == 0;
+}
+
 /*
  * efi_get_virtmap() - create a virtual mapping for the EFI memory map
  *
@@ -317,33 +356,52 @@ void efi_get_virtmap(efi_memory_desc_t *memory_map, unsigned long map_size,
 		     int *count)
 {
 	u64 efi_virt_base = EFI_RT_VIRTUAL_BASE;
-	efi_memory_desc_t *out = runtime_map;
+	efi_memory_desc_t *in, *prev = NULL, *out = runtime_map;
 	int l;
 
-	for (l = 0; l < map_size; l += desc_size) {
-		efi_memory_desc_t *in = (void *)memory_map + l;
+	/*
+	 * To work around potential issues with the Properties Table feature
+	 * introduced in UEFI 2.5, which may split PE/COFF executable images
+	 * in memory into several RuntimeServicesCode and RuntimeServicesData
+	 * regions, we need to preserve the relative offsets between adjacent
+	 * EFI_MEMORY_RUNTIME regions with the same memory type attributes.
+	 * The easiest way to find adjacent regions is to sort the memory map
+	 * before traversing it.
+	 */
+	sort(memory_map, map_size / desc_size, desc_size, cmp_mem_desc, NULL);
+
+	for (l = 0; l < map_size; l += desc_size, prev = in) {
 		u64 paddr, size;
 
+		in = (void *)memory_map + l;
 		if (!(in->attribute & EFI_MEMORY_RUNTIME))
 			continue;
 
+		paddr = in->phys_addr;
+		size = in->num_pages * EFI_PAGE_SIZE;
+
 		/*
 		 * Make the mapping compatible with 64k pages: this allows
 		 * a 4k page size kernel to kexec a 64k page size kernel and
 		 * vice versa.
 		 */
-		paddr = round_down(in->phys_addr, SZ_64K);
-		size = round_up(in->num_pages * EFI_PAGE_SIZE +
-				in->phys_addr - paddr, SZ_64K);
-
-		/*
-		 * Avoid wasting memory on PTEs by choosing a virtual base that
-		 * is compatible with section mappings if this region has the
-		 * appropriate size and physical alignment. (Sections are 2 MB
-		 * on 4k granule kernels)
-		 */
-		if (IS_ALIGNED(in->phys_addr, SZ_2M) && size >= SZ_2M)
-			efi_virt_base = round_up(efi_virt_base, SZ_2M);
+		if (!regions_are_adjacent(prev, in) ||
+		    !regions_have_compatible_memory_type_attrs(prev, in)) {
+
+			paddr = round_down(in->phys_addr, SZ_64K);
+			size += in->phys_addr - paddr;
+
+			/*
+			 * Avoid wasting memory on PTEs by choosing a virtual
+			 * base that is compatible with section mappings if this
+			 * region has the appropriate size and physical
+			 * alignment. (Sections are 2 MB on 4k granule kernels)
+			 */
+			if (IS_ALIGNED(in->phys_addr, SZ_2M) && size >= SZ_2M)
+				efi_virt_base = round_up(efi_virt_base, SZ_2M);
+			else
+				efi_virt_base = round_up(efi_virt_base, SZ_64K);
+		}
 
 		in->virt_addr = efi_virt_base + in->phys_addr - paddr;
 		efi_virt_base += size;
-- 
2.1.0
