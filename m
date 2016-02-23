From: David Daney <ddaney.cavm@gmail.com>
Subject: [PATCH v12 1/5] efi: ARM/arm64: ignore DT memory nodes instead of removing them
Date: Mon, 22 Feb 2016 17:58:19 -0800
Message-ID: <1456192703-2274-2-git-send-email-ddaney.cavm@gmail.com>
References: <1456192703-2274-1-git-send-email-ddaney.cavm@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1456192703-2274-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Frank Rowand <frowand.list@gmail.com>, Grant Likely <grant.likely@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, linux-efi@vger.kernel.org, Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>, Robert Richter <rrichter@cavium.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

There are two problems with the UEFI stub DT memory node removal
routine:
- it deletes nodes as it traverses the tree, which happens to work
  but is not supported, as deletion invalidates the node iterator;
- deleting memory nodes entirely may discard annotations in the form
  of additional properties on the nodes.

Since the discovery of DT memory nodes occurs strictly before the
UEFI init sequence, we can simply clear the memblock memory table
before parsing the UEFI memory map. This way, it is no longer
necessary to remove the nodes, so we can remove that logic from the
stub as well.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: David Daney <david.daney@cavium.com>
---
 drivers/firmware/efi/arm-init.c    |  8 ++++++++
 drivers/firmware/efi/libstub/fdt.c | 24 +-----------------------
 2 files changed, 9 insertions(+), 23 deletions(-)

diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index 9e15d57..40c9d85 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -143,6 +143,14 @@ static __init void reserve_regions(void)
 	if (efi_enabled(EFI_DBG))
 		pr_info("Processing EFI memory map:\n");
 
+	/*
+	 * Discard memblocks discovered so far: if there are any at this
+	 * point, they originate from memory nodes in the DT, and UEFI
+	 * uses its own memory map instead.
+	 */
+	memblock_dump_all();
+	memblock_remove(0, ULLONG_MAX);
+
 	for_each_efi_memory_desc(&memmap, md) {
 		paddr = md->phys_addr;
 		npages = md->num_pages;
diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index cf7b7d4..9df1560 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -24,7 +24,7 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 			unsigned long map_size, unsigned long desc_size,
 			u32 desc_ver)
 {
-	int node, prev, num_rsv;
+	int node, num_rsv;
 	int status;
 	u32 fdt_val32;
 	u64 fdt_val64;
@@ -54,28 +54,6 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 		goto fdt_set_fail;
 
 	/*
-	 * Delete any memory nodes present. We must delete nodes which
-	 * early_init_dt_scan_memory may try to use.
-	 */
-	prev = 0;
-	for (;;) {
-		const char *type;
-		int len;
-
-		node = fdt_next_node(fdt, prev, NULL);
-		if (node < 0)
-			break;
-
-		type = fdt_getprop(fdt, node, "device_type", &len);
-		if (type && strncmp(type, "memory", len) == 0) {
-			fdt_del_node(fdt, node);
-			continue;
-		}
-
-		prev = node;
-	}
-
-	/*
 	 * Delete all memory reserve map entries. When booting via UEFI,
 	 * kernel will use the UEFI memory map to find reserved regions.
 	 */
-- 
1.8.3.1
