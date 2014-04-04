From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 4/5] efi: Add shared printk wrapper for consistent prefixing
Date: Fri,  4 Apr 2014 13:25:49 +0100
Message-ID: <1396614350-20889-5-git-send-email-leif.lindholm@linaro.org>
References: <1396614350-20889-1-git-send-email-leif.lindholm@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1396614350-20889-1-git-send-email-leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Add a wrapper for printk to standardize the prefix for informational and
error messages from the EFI stub.

Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/efi-stub-helper.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index 3cc5ebe..183289c 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -33,6 +33,9 @@ static void efi_printk(efi_system_table_t *sys_table_arg, char *str)
 	}
 }
 
+#define pr_efi(sys_table, msg)     efi_printk(sys_table, "EFI stub: "msg)
+#define pr_efi_err(sys_table, msg) efi_printk(sys_table, "EFI stub: ERROR: "msg)
+
 
 static efi_status_t efi_get_memory_map(efi_system_table_t *sys_table_arg,
 				       efi_memory_desc_t **map,
@@ -310,7 +313,7 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
 				nr_files * sizeof(*files), (void **)&files);
 	if (status != EFI_SUCCESS) {
-		efi_printk(sys_table_arg, "Failed to alloc mem for file handle list\n");
+		pr_efi_err(sys_table_arg, "Failed to alloc mem for file handle list\n");
 		goto fail;
 	}
 
@@ -374,13 +377,13 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 		status = efi_high_alloc(sys_table_arg, file_size_total, 0x1000,
 				    &file_addr, max_addr);
 		if (status != EFI_SUCCESS) {
-			efi_printk(sys_table_arg, "Failed to alloc highmem for files\n");
+			pr_efi_err(sys_table_arg, "Failed to alloc highmem for files\n");
 			goto close_handles;
 		}
 
 		/* We've run out of free low memory. */
 		if (file_addr > max_addr) {
-			efi_printk(sys_table_arg, "We've run out of free low memory\n");
+			pr_efi_err(sys_table_arg, "We've run out of free low memory\n");
 			status = EFI_INVALID_PARAMETER;
 			goto free_file_total;
 		}
@@ -401,7 +404,7 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 						       &chunksize,
 						       (void *)addr);
 				if (status != EFI_SUCCESS) {
-					efi_printk(sys_table_arg, "Failed to read file\n");
+					pr_efi_err(sys_table_arg, "Failed to read file\n");
 					goto free_file_total;
 				}
 				addr += chunksize;
@@ -486,7 +489,7 @@ static efi_status_t efi_relocate_kernel(efi_system_table_t *sys_table_arg,
 				       &new_addr);
 	}
 	if (status != EFI_SUCCESS) {
-		efi_printk(sys_table_arg, "ERROR: Failed to allocate usable memory for kernel.\n");
+		pr_efi_err(sys_table_arg, "ERROR: Failed to allocate usable memory for kernel.\n");
 		return status;
 	}
 
-- 
1.7.10.4
