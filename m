From: Robert Richter <rrichter@caviumnetworks.com>
Subject: [PATCH v4 5/6] arm64/efi: ignore DT memory nodes instead of removing
 them
Date: Tue, 9 Feb 2016 14:53:45 +0100
Message-ID: <1455026026-11571-6-git-send-email-rrichter@caviumnetworks.com>
References: <1455026026-11571-1-git-send-email-rrichter@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1455026026-11571-1-git-send-email-rrichter@caviumnetworks.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Will Deacon <will.deacon@arm.com>, Matt Fleming <matt@codeblueprint.co.uk>, Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Leif Lindholm <leif.lindholm@linaro.org>, Robert Richter <rrichter@cavium.com>, Mark Salter <msalter@redhat.com>, Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

There are two problems with the UEFI stub DT memory node removal
routine:
- it deletes nodes as it traverses the tree, which happens to work
  but is not supported, as deletion invalidates the node iterator;
- deleting memory nodes entirely may discard annotations in the form
  of additional properties on the nodes.

Now that the UEFI initialization has moved to an earlier stage, we can
actually just ignore any memblocks that are installed after we have
processed the UEFI memory map. This way, it is no longer necessary to
remove the nodes, so we can remove that logic from the stub as well.

Acked-by: Leif Lindholm <leif.lindholm@linaro.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Message-Id: <1442881288-13962-6-git-send-email-ard.biesheuvel@linaro.org>
[ rric: Ported to v4.5-rc1 ]
Signed-off-by: Robert Richter <rrichter@cavium.com>
---
 arch/arm64/mm/init.c               |  6 +++++-
 drivers/firmware/efi/arm-init.c    |  2 +-
 drivers/firmware/efi/libstub/fdt.c | 24 +-----------------------
 3 files changed, 7 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 208c1d359018..eda226e85c71 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -383,5 +383,9 @@ __setup("keepinitrd", keepinitrd_setup);
 
 void __init early_init_dt_add_memory_arch(u64 base, u64 size)
 {
-	early_init_dt_add_memory(base, size);
+	/*
+	 * Ignore DT memory nodes if we are booting via UEFI.
+	 */
+	if (!efi_enabled(EFI_MEMMAP))
+		early_init_dt_add_memory(base, size);
 }
diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index 9fe04648d4d3..ded895706633 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -159,7 +159,7 @@ static __init void reserve_regions(void)
 		size = npages << PAGE_SHIFT;
 
 		if (is_normal_ram(md))
-			early_init_dt_add_memory_arch(paddr, size);
+			early_init_dt_add_memory(paddr, size);
 
 		if (is_reserve_region(md)) {
 			memblock_mark_nomap(paddr, size);
diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index cf7b7d46302a..9df1560d57bc 100644
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
2.7.0.rc3
