From: Leif Lindholm <leif.lindholm@linaro.org>
Subject: [PATCH 05/22] Add shared printk wrapper for consistent prefixing
Date: Wed,  5 Feb 2014 17:03:56 +0000
Message-ID: <1391619853-10601-6-git-send-email-leif.lindholm@linaro.org>
References: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-efi@vger.kernel.org
Cc: Roy Franz <roy.franz@linaro.org>, Leif Lindholm <leif.lindholm@linaro.org>, patches@linaro.org
List-Id: linux-efi@vger.kernel.org

From: Roy Franz <roy.franz@linaro.org>

Add a wrapper for printk to standardize the prefix for informational and
error messages from the EFI stub.

Signed-off-by: Roy Franz <roy.franz@linaro.org>
Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
---
 drivers/firmware/efi/efi-stub-helper.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index b6bffbf..eb5d2eb 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -45,6 +45,9 @@ static void efi_printk(efi_system_table_t *sys_table_arg, char *str)
 	}
 }
 
+#define pr_efi(sys_table, msg)     efi_printk(sys_table, "EFI stub: "msg)
+#define pr_efi_err(sys_table, msg) efi_printk(sys_table, "EFI stub: ERROR: "msg)
+
 
 static efi_status_t efi_get_memory_map(efi_system_table_t *sys_table_arg,
 				       efi_memory_desc_t **map,
@@ -324,7 +327,7 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 				nr_files * sizeof(*files),
 				(void **)&files);
 	if (status != EFI_SUCCESS) {
-		efi_printk(sys_table_arg, "Failed to alloc mem for file handle list\n");
+		pr_efi_err(sys_table_arg, "Failed to alloc mem for file handle list\n");
 		goto fail;
 	}
 
@@ -376,13 +379,13 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 					image->device_handle, &fs_proto,
 						(void **)&io);
 			if (status != EFI_SUCCESS) {
-				efi_printk(sys_table_arg, "Failed to handle fs_proto\n");
+				pr_efi_err(sys_table_arg, "Failed to handle fs_proto\n");
 				goto free_files;
 			}
 
 			status = efi_call_phys2(io->open_volume, io, &fh);
 			if (status != EFI_SUCCESS) {
-				efi_printk(sys_table_arg, "Failed to open volume\n");
+				pr_efi_err(sys_table_arg, "Failed to open volume\n");
 				goto free_files;
 			}
 		}
@@ -390,7 +393,7 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 		status = efi_call_phys5(fh->open, fh, &h, filename_16,
 					EFI_FILE_MODE_READ, (u64)0);
 		if (status != EFI_SUCCESS) {
-			efi_printk(sys_table_arg, "Failed to open file: ");
+			pr_efi_err(sys_table_arg, "Failed to open file: ");
 			efi_char16_printk(sys_table_arg, filename_16);
 			efi_printk(sys_table_arg, "\n");
 			goto close_handles;
@@ -402,7 +405,7 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 		status = efi_call_phys4(h->get_info, h, &info_guid,
 					&info_sz, NULL);
 		if (status != EFI_BUFFER_TOO_SMALL) {
-			efi_printk(sys_table_arg, "Failed to get file info size\n");
+			pr_efi_err(sys_table_arg, "Failed to get file info size\n");
 			goto close_handles;
 		}
 
@@ -411,7 +414,7 @@ grow:
 					EFI_LOADER_DATA, info_sz,
 					(void **)&info);
 		if (status != EFI_SUCCESS) {
-			efi_printk(sys_table_arg, "Failed to alloc mem for file info\n");
+			pr_efi_err(sys_table_arg, "Failed to alloc mem for file info\n");
 			goto close_handles;
 		}
 
@@ -427,7 +430,7 @@ grow:
 		efi_call_phys1(sys_table_arg->boottime->free_pool, info);
 
 		if (status != EFI_SUCCESS) {
-			efi_printk(sys_table_arg, "Failed to get file info\n");
+			pr_efi_err(sys_table_arg, "Failed to get file info\n");
 			goto close_handles;
 		}
 
@@ -446,13 +449,13 @@ grow:
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
@@ -473,7 +476,7 @@ grow:
 							&chunksize,
 							(void *)addr);
 				if (status != EFI_SUCCESS) {
-					efi_printk(sys_table_arg, "Failed to read file\n");
+					pr_efi_err(sys_table_arg, "Failed to read file\n");
 					goto free_file_total;
 				}
 				addr += chunksize;
@@ -558,7 +561,7 @@ static efi_status_t efi_relocate_kernel(efi_system_table_t *sys_table_arg,
 				       &new_addr);
 	}
 	if (status != EFI_SUCCESS) {
-		efi_printk(sys_table_arg, "ERROR: Failed to allocate usable memory for kernel.\n");
+		pr_efi_err(sys_table_arg, "ERROR: Failed to allocate usable memory for kernel.\n");
 		return status;
 	}
 
-- 
1.7.10.4
