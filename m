From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] efi/libstub: arm*: Pass latest memory map to the kernel
Date: Fri,  9 Dec 2016 18:24:03 +0000
Message-ID: <1481307843-18521-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-efi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com
Cc: matt@codeblueprint.co.uk, jhugo@codeaurora.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

As reported by James, the current libstub code involving the annotated
memory map only works somewhat correctly by accident, due to the fact
that a pool allocation happens to be reused immediately, retaining its
former contents.

Instead of juggling memory maps, which makes the code more complex than
it needs to be, simply put a placholder value into the FDT, and only
write the actual value after ExitBootServices() has been called.

Reported-by: James Morse <james.morse@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/libstub/fdt.c | 51 ++++++++++++++++++++++++--------------
 1 file changed, 32 insertions(+), 19 deletions(-)

diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index a6a93116a8f0..5d39dff77f17 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -101,7 +101,7 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 	if (status)
 		goto fdt_set_fail;
 
-	fdt_val64 = cpu_to_fdt64((u64)(unsigned long)memory_map);
+	fdt_val64 = U64_MAX; /* placeholder */
 	status = fdt_setprop(fdt, node, "linux,uefi-mmap-start",
 			     &fdt_val64,  sizeof(fdt_val64));
 	if (status)
@@ -148,6 +148,24 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 	return EFI_LOAD_ERROR;
 }
 
+static efi_status_t update_fdt_memmap(void *fdt, u64 memmap)
+{
+	int node = fdt_path_offset(fdt, "/chosen");
+	efi_status_t status;
+
+	if (node < 0)
+		return EFI_LOAD_ERROR;
+
+	memmap = cpu_to_fdt64(memmap);
+	status = fdt_setprop_inplace(fdt, node, "linux,uefi-mmap-start",
+				     &memmap, sizeof(memmap));
+
+	if (status)
+		return EFI_LOAD_ERROR;
+
+	return EFI_SUCCESS;
+}
+
 #ifndef EFI_FDT_ALIGN
 #define EFI_FDT_ALIGN EFI_PAGE_SIZE
 #endif
@@ -243,15 +261,6 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 			goto fail;
 		}
 
-		/*
-		 * Now that we have done our final memory allocation (and free)
-		 * we can get the memory map key  needed for
-		 * exit_boot_services().
-		 */
-		status = efi_get_memory_map(sys_table, &map);
-		if (status != EFI_SUCCESS)
-			goto fail_free_new_fdt;
-
 		status = update_fdt(sys_table,
 				    (void *)fdt_addr, fdt_size,
 				    (void *)*new_fdt_addr, new_fdt_size,
@@ -266,20 +275,16 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 			/*
 			 * We need to allocate more space for the new
 			 * device tree, so free existing buffer that is
-			 * too small.  Also free memory map, as we will need
-			 * to get new one that reflects the free/alloc we do
-			 * on the device tree buffer.
+			 * too small.
 			 */
 			efi_free(sys_table, new_fdt_size, *new_fdt_addr);
-			sys_table->boottime->free_pool(memory_map);
 			new_fdt_size += EFI_PAGE_SIZE;
 		} else {
 			pr_efi_err(sys_table, "Unable to construct new device tree.\n");
-			goto fail_free_mmap;
+			goto fail_free_new_fdt;
 		}
 	}
 
-	sys_table->boottime->free_pool(memory_map);
 	priv.runtime_map = runtime_map;
 	priv.runtime_entry_count = &runtime_entry_count;
 	status = efi_exit_boot_services(sys_table, handle, &map, &priv,
@@ -288,6 +293,17 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 	if (status == EFI_SUCCESS) {
 		efi_set_virtual_address_map_t *svam;
 
+		status = update_fdt_memmap((void *)*new_fdt_addr,
+					   (u64)memory_map);
+		if (status != EFI_SUCCESS) {
+			/*
+			 * The kernel won't get far without the memory map, but
+			 * may still be able to print something meaningful so
+			 * return success here.
+			 */
+			return EFI_SUCCESS;
+		}
+
 		/* Install the new virtual address map */
 		svam = sys_table->runtime->set_virtual_address_map;
 		status = svam(runtime_entry_count * desc_size, desc_size,
@@ -319,9 +335,6 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 
 	pr_efi_err(sys_table, "Exit boot services failed.\n");
 
-fail_free_mmap:
-	sys_table->boottime->free_pool(memory_map);
-
 fail_free_new_fdt:
 	efi_free(sys_table, new_fdt_size, *new_fdt_addr);
 
-- 
2.7.4
