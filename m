From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] arm64/efi: don't pad between EFI_MEMORY_RUNTIME regions
Date: Fri,  4 Sep 2015 15:06:26 +0200
Message-ID: <1441371986-4554-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The new Properties Table feature introduced in UEFIv2.5 may split
memory regions that cover PE/COFF memory images into separate code
and data regions.

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

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---

As discussed off list, this is the arm64 side of what we should backport
to stable to prevent firmware that adheres to the current version of the
UEFI v2.5 spec with the memprotect feature enabled from blowing up the system
upon the first OS call into the runtime services.

For arm64, we already map things in order, but since the spec does not mandate
a sorted memory map, we need to sort it to be sure. This also allows us to
easily find adjacent regions with < 64 KB granularity, which the current version
of the spec allows if they only differ in permission bits (which the spec says
are 'unused' on AArch64, which could be interpreted as 'allowed but ignored').

@Matt: I don't know what your timeline is for fixing this on the x86 side, but
perhaps it makes sense to keep those patches together? Your call.

 drivers/firmware/efi/libstub/arm-stub.c | 62 +++++++++++++++-----
 1 file changed, 47 insertions(+), 15 deletions(-)

diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index e29560e6b40b..cb4e9c4de952 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/efi.h>
+#include <linux/sort.h>
 #include <asm/efi.h>
 
 #include "efistub.h"
@@ -305,6 +306,13 @@ fail:
  */
 #define EFI_RT_VIRTUAL_BASE	0x40000000
 
+static int cmp_mem_desc(const void *a, const void *b)
+{
+	const efi_memory_desc_t *left = a, *right = b;
+
+	return (left->phys_addr > right->phys_addr) ? 1 : -1;
+}
+
 /*
  * efi_get_virtmap() - create a virtual mapping for the EFI memory map
  *
@@ -316,34 +324,58 @@ void efi_get_virtmap(efi_memory_desc_t *memory_map, unsigned long map_size,
 		     unsigned long desc_size, efi_memory_desc_t *runtime_map,
 		     int *count)
 {
+	static const u64 mem_type_mask = EFI_MEMORY_WB | EFI_MEMORY_WT |
+					 EFI_MEMORY_WC | EFI_MEMORY_UC |
+					 EFI_MEMORY_RUNTIME;
+
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
+		if (!prev ||
+		    ((prev->attribute ^ in->attribute) & mem_type_mask) != 0 ||
+		    paddr != (prev->phys_addr + prev->num_pages * EFI_PAGE_SIZE)) {
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
1.9.1
