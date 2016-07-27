From: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH V3 3/4] efi/libstub: Use efi_exit_boot_services() in FDT
Date: Wed, 27 Jul 2016 11:42:24 -0600
Message-ID: <1469641345-17739-4-git-send-email-jhugo@codeaurora.org>
References: <1469641345-17739-1-git-send-email-jhugo@codeaurora.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469641345-17739-1-git-send-email-jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The FDT code directly calls ExitBootServices.  This is inadvisable, and the
FDT code does not handle EFI_INVALID_PARAMETER as required by the spec.
The efi_exit_boot_services() helper handles the EFI_INVALID_PARAMETER
scenario.

Signed-off-by: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
---
 drivers/firmware/efi/libstub/fdt.c | 44 +++++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 10 deletions(-)

diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index 878e661..fdda4e6 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -152,6 +152,33 @@ fdt_set_fail:
 #define EFI_FDT_ALIGN EFI_PAGE_SIZE
 #endif
 
+struct exit_boot_struct {
+	efi_memory_desc_t *runtime_map;
+	int *runtime_entry_count;
+};
+
+static efi_status_t exit_boot_func(efi_system_table_t *sys_table,
+				   void *handle,
+				   efi_memory_desc_t *memory_map,
+				   unsigned long *map_size,
+				   unsigned long *desc_size,
+				   u32 *desc_ver,
+				   unsigned long *mmap_key,
+				   unsigned long buff_size,
+				   void *priv)
+{
+	struct exit_boot_struct *p = priv;
+	/*
+	 * Update the memory map with virtual addresses. The function will also
+	 * populate @runtime_map with copies of just the EFI_MEMORY_RUNTIME
+	 * entries so that we can pass it straight into SetVirtualAddressMap()
+	 */
+	efi_get_virtmap(memory_map, *map_size, *desc_size, p->runtime_map,
+			p->runtime_entry_count);
+
+	return EFI_SUCCESS;
+}
+
 /*
  * Allocate memory for a new FDT, then add EFI, commandline, and
  * initrd related fields to the FDT.  This routine increases the
@@ -182,6 +209,7 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 	unsigned long new_fdt_size;
 	efi_status_t status;
 	int runtime_entry_count = 0;
+	struct exit_boot_struct priv;
 
 	/*
 	 * Get a copy of the current memory map that we will use to prepare
@@ -252,16 +280,12 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 		}
 	}
 
-	/*
-	 * Update the memory map with virtual addresses. The function will also
-	 * populate @runtime_map with copies of just the EFI_MEMORY_RUNTIME
-	 * entries so that we can pass it straight into SetVirtualAddressMap()
-	 */
-	efi_get_virtmap(memory_map, map_size, desc_size, runtime_map,
-			&runtime_entry_count);
-
-	/* Now we are ready to exit_boot_services.*/
-	status = sys_table->boottime->exit_boot_services(handle, mmap_key);
+	sys_table->boottime->free_pool(memory_map);
+	priv.runtime_map = runtime_map;
+	priv.runtime_entry_count = &runtime_entry_count;
+	status = efi_exit_boot_services(sys_table, handle, &memory_map,
+					&map_size, &desc_size, &desc_ver,
+					&mmap_key, &priv, exit_boot_func);
 
 	if (status == EFI_SUCCESS) {
 		efi_set_virtual_address_map_t *svam;
-- 
Qualcomm Datacenter Technologies as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
