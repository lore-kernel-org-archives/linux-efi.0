From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/3] efi/libstub: sanity check the /reserved-memory DT node
Date: Wed,  7 Oct 2015 09:35:28 +0100
Message-ID: <1444206929-13374-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1444206929-13374-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444206929-13374-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

One of the DT bindings supported by the Linux kernel is the
/reserved-memory node, which may contain both static and dynamic
reservations that the kernel honors very early on, before using any
memory outside of the static footprint of the kernel.

On arm64, we started out by ignoring all memory reservations, but after
merging commit 0ceac9e094b0 ("009800efi/arm64: Fix fdt-related memory
reservation inadvertently"), the /reserved-memory node is preserved,
which may result in reservations that conflict with memory regions that
have already been allocated for other purposes by UEFI.

So let's sanity check the contents of this node in the EFI stub, by
trying to allocate each static reservation as EfiLoaderData (which will
result in UEFI leaving this memory alone until it releases it to the
kernel), and if that fails, check whether the region is either already
reserved in the UEFI memory map (as EfiReservedMemoryType memory), or
is completely disjoint from the UEFI memory map to begin with. If all
of that fails, the region is apparently allocated for some other purpose
by UEFI, which means we will not be able to honor the reservation. If
this happens, we abort the boot, since we cannot really be sure that it
is safe to proceed.

NOTE: there is an implicit assumption in this approach that reservations
can tolerate being allocated and freed again for temporary use by UEFI.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/libstub/fdt.c | 144 +++++++++++++++++++-
 1 file changed, 142 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index 354172bee81c..0ef16923b4f0 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -13,12 +13,140 @@
 #include <linux/efi.h>
 #include <linux/libfdt.h>
 #include <asm/efi.h>
+#include <asm/unaligned.h>
 
 #include "efistub.h"
 
+/*
+ * Return whether the reserved region [addr, addr + size) can be considered as
+ * 'reserved' from the POV of UEFI. This is the case if the region is entirely
+ * covered by a EfiReservedMemoryType region or if the region does not appear in
+ * the UEFI memory map at all.
+ */
+static bool region_is_reserved(efi_system_table_t *sys_table_arg,
+			       u64 addr, u64 size,
+			       efi_memory_desc_t *memory_map,
+			       unsigned long map_size,
+			       unsigned long desc_size)
+{
+	int i;
+
+	for (i = 0; i < map_size; i += desc_size) {
+		efi_memory_desc_t *entry = (void *)memory_map + i;
+		u64 entry_end = entry->phys_addr +
+				entry->num_pages * EFI_PAGE_SIZE;
+
+		/* disregard this entry if it does not intersect the region */
+		if (entry_end <= addr || entry->phys_addr >= (addr + size))
+			continue;
+
+		/* if it does intersect the region, it must cover it entirely */
+		if (addr < entry->phys_addr || (addr + size) > entry_end)
+			return false;
+
+		return (entry->type == EFI_RESERVED_TYPE);
+	}
+
+	/* not covered by the UEFI memory map */
+	return true;
+}
+
+static u64 get_node_val(const void *prop, u32 num_cells)
+{
+	if (num_cells == 1)
+		return be32_to_cpup(prop);
+	else
+		return get_unaligned_be64(prop);
+}
+
+static efi_status_t handle_reserved_memory(efi_system_table_t *sys_table_arg,
+					   void *fdt, int node,
+					   efi_memory_desc_t *memory_map,
+					   unsigned long map_size,
+					   unsigned long desc_size)
+{
+	efi_status_t status;
+	const void *prop;
+	u32 addr_cells, size_cells, stride;
+	int len;
+
+	prop = fdt_getprop(fdt, node, "#address-cells", &len);
+	if (!prop || !len)
+		goto err_missing_node;
+	addr_cells = be32_to_cpup(prop);
+
+	prop = fdt_getprop(fdt, node, "#size-cells", &len);
+	if (!prop || !len)
+		goto err_missing_node;
+	size_cells = be32_to_cpup(prop);
+
+	stride = (addr_cells + size_cells) * sizeof(u32);
+
+	/* enumerate each subnode and look for 'reg' properties */
+	for (;;) {
+		int depth, i;
+
+		node = fdt_next_node(fdt, node, &depth);
+		if (node < 0 || depth < 1)
+			/* done with /reserved-memory node */
+			break;
+
+		/*
+		 * Check for a 'reg' property. If it does not have one, this is
+		 * a dynamic allocation that we can ignore.
+		 */
+		prop = fdt_getprop(fdt, node, "reg", &len);
+		if (!prop)
+			continue;
+
+		for (i = 0; i < len; i += stride) {
+			const u32 *val = prop + i;
+			u64 addr, size;
+			u32 pages;
+
+			/* discover each addr/size tuple in the reg property */
+			addr = get_node_val(val, addr_cells);
+			size = get_node_val(val + addr_cells, size_cells);
+
+			pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
+
+			/* allocate the region as EfiLoaderData */
+			status = efi_call_early(allocate_pages,
+						EFI_ALLOCATE_ADDRESS,
+						EFI_LOADER_DATA,
+						pages, &addr);
+
+			/*
+			 * If we fail to allocate the reserved region, it could
+			 * be reserved already (i.e., as EfiReservedMemoryType)
+			 * or not appear in the UEFI memory map at all. In both
+			 * cases, we can be sure that UEFI will not touch it, so
+			 * we can simply ignore it.
+			 */
+			if (status != EFI_SUCCESS &&
+			    !region_is_reserved(sys_table_arg, addr, size,
+						memory_map, map_size,
+						desc_size)) {
+				pr_efi_err(sys_table_arg, "Failed to reserve /reserved-memory node!\n");
+				return status;
+			}
+		}
+	}
+	return EFI_SUCCESS;
+
+err_missing_node:
+	pr_efi_err(sys_table_arg, "Missing /reserved-memory #cells properties!\n");
+	return EFI_LOAD_ERROR;
+}
+
 static efi_status_t sanity_check_fdt(efi_system_table_t *sys_table,
-				     void *fdt, unsigned long fdt_size)
+				     void *fdt, unsigned long fdt_size,
+				     efi_memory_desc_t *memory_map,
+				     unsigned long map_size,
+				     unsigned long desc_size)
 {
+	int node;
+
 	if (fdt_check_header(fdt)) {
 		pr_efi_err(sys_table, "Device Tree header not valid!\n");
 		return EFI_LOAD_ERROR;
@@ -33,6 +161,17 @@ static efi_status_t sanity_check_fdt(efi_system_table_t *sys_table,
 		return EFI_LOAD_ERROR;
 	}
 
+	/*
+	 * If we have a /reserved-memory node, ensure that all regions are
+	 * free by explicitly allocating them as LoaderData. If this fails,
+	 * we bail since we have no clue if the system can actually boot
+	 * without these reservations.
+	 */
+	node = fdt_path_offset(fdt, "/reserved-memory");
+	if (node >= 0)
+		return handle_reserved_memory(sys_table, fdt, node, memory_map,
+					      map_size, desc_size);
+
 	return EFI_SUCCESS;
 }
 
@@ -218,7 +357,8 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 	}
 
 	if (fdt_addr) {
-		status = sanity_check_fdt(sys_table, (void*)fdt_addr, fdt_size);
+		status = sanity_check_fdt(sys_table, (void *)fdt_addr, fdt_size,
+					  runtime_map, map_size, desc_size);
 		if (status != EFI_SUCCESS)
 			goto fail;
 	}
-- 
1.9.1
