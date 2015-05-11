From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 8/8] arm64/efi: adapt to relaxed FDT placement requirements
Date: Mon, 11 May 2015 08:42:00 +0200
Message-ID: <1431326520-17331-9-git-send-email-ard.biesheuvel@linaro.org>
References: <1431326520-17331-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431326520-17331-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: Ganapatrao.Kulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

With the relaxed FDT placement requirements in place, we can change
the allocation strategy used by the stub to put the FDT image higher
up in memory. At the same time, reduce the minimal alignment to 8 bytes,
and impose a 2 MB size limit, as per the new requirements.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm64/include/asm/efi.h            | 10 +++-------
 drivers/firmware/efi/libstub/arm-stub.c |  5 ++---
 drivers/firmware/efi/libstub/efistub.h  |  1 -
 drivers/firmware/efi/libstub/fdt.c      | 18 +++++++++---------
 4 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index 635101f36720..43ea4ecbd361 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -1,6 +1,7 @@
 #ifndef _ASM_EFI_H
 #define _ASM_EFI_H
 
+#include <asm/boot.h>
 #include <asm/io.h>
 #include <asm/neon.h>
 
@@ -38,13 +39,8 @@ extern void efi_init_fdt(void *fdt);
 
 /* arch specific definitions used by the stub code */
 
-/*
- * AArch64 requires the DTB to be 8-byte aligned in the first 512MiB from
- * start of kernel and may not cross a 2MiB boundary. We set alignment to
- * 2MiB so we know it won't cross a 2MiB boundary.
- */
-#define EFI_FDT_ALIGN	SZ_2M   /* used by allocate_new_fdt_and_exit_boot() */
-#define MAX_FDT_OFFSET	SZ_512M
+#define EFI_FDT_ALIGN		MIN_FDT_ALIGN
+#define EFI_FDT_MAX_SIZE	MAX_FDT_SIZE
 
 #define efi_call_early(f, ...) sys_table_arg->boottime->f(__VA_ARGS__)
 
diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index e29560e6b40b..4e5ac133d1dc 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -268,9 +268,8 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 
 	new_fdt_addr = fdt_addr;
 	status = allocate_new_fdt_and_exit_boot(sys_table, handle,
-				&new_fdt_addr, dram_base + MAX_FDT_OFFSET,
-				initrd_addr, initrd_size, cmdline_ptr,
-				fdt_addr, fdt_size);
+				&new_fdt_addr, initrd_addr, initrd_size,
+				cmdline_ptr, fdt_addr, fdt_size);
 
 	/*
 	 * If all went well, we need to return the FDT address to the
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index e334a01cf92f..cf14dafc348a 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -35,7 +35,6 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 					    void *handle,
 					    unsigned long *new_fdt_addr,
-					    unsigned long max_addr,
 					    u64 initrd_addr, u64 initrd_size,
 					    char *cmdline_ptr,
 					    unsigned long fdt_addr,
diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index a7e87cd582f2..ab6ecb22bd6e 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -134,10 +134,6 @@ fdt_set_fail:
 	return EFI_LOAD_ERROR;
 }
 
-#ifndef EFI_FDT_ALIGN
-#define EFI_FDT_ALIGN EFI_PAGE_SIZE
-#endif
-
 /*
  * Allocate memory for a new FDT, then add EFI, commandline, and
  * initrd related fields to the FDT.  This routine increases the
@@ -155,7 +151,6 @@ fdt_set_fail:
 efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 					    void *handle,
 					    unsigned long *new_fdt_addr,
-					    unsigned long max_addr,
 					    u64 initrd_addr, u64 initrd_size,
 					    char *cmdline_ptr,
 					    unsigned long fdt_addr,
@@ -192,8 +187,13 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 	 */
 	new_fdt_size = fdt_size + EFI_PAGE_SIZE;
 	while (1) {
-		status = efi_high_alloc(sys_table, new_fdt_size, EFI_FDT_ALIGN,
-					new_fdt_addr, max_addr);
+		if (new_fdt_size > EFI_FDT_MAX_SIZE) {
+			pr_efi_err(sys_table, "FDT size exceeds EFI_FDT_MAX_SIZE.\n");
+			goto fail;
+		}
+		status = sys_table->boottime->allocate_pool(EFI_LOADER_DATA,
+							    new_fdt_size,
+							    (void **)new_fdt_addr);
 		if (status != EFI_SUCCESS) {
 			pr_efi_err(sys_table, "Unable to allocate memory for new device tree.\n");
 			goto fail;
@@ -227,7 +227,7 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 			 * to get new one that reflects the free/alloc we do
 			 * on the device tree buffer.
 			 */
-			efi_free(sys_table, new_fdt_size, *new_fdt_addr);
+			sys_table->boottime->free_pool((void *)*new_fdt_addr);
 			sys_table->boottime->free_pool(memory_map);
 			new_fdt_size += EFI_PAGE_SIZE;
 		} else {
@@ -285,7 +285,7 @@ fail_free_mmap:
 	sys_table->boottime->free_pool(memory_map);
 
 fail_free_new_fdt:
-	efi_free(sys_table, new_fdt_size, *new_fdt_addr);
+	sys_table->boottime->free_pool((void *)*new_fdt_addr);
 
 fail:
 	sys_table->boottime->free_pool(runtime_map);
-- 
1.9.1
