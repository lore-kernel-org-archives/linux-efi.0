From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 05/17] Add minimum address parameter to efi_low_alloc()
Date: Tue,  6 Aug 2013 20:45:01 -0700
Message-ID: <1375847113-24884-6-git-send-email-roy.franz@linaro.org>
References: <1375847113-24884-1-git-send-email-roy.franz@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375847113-24884-1-git-send-email-roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dave.martin-5wv7dgnIgG8@public.gmane.org, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This allows allocations to be made low in memory while
avoiding allocations at the base of memory.

Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/x86/boot/compressed/eboot.c       |   11 ++++++-----
 drivers/firmware/efi/efi-stub-helper.c |    5 ++++-
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 2a4430a..f44ef2f 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -458,7 +458,7 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 	}
 
 	status = efi_low_alloc(sys_table, 0x4000, 1,
-			       (unsigned long *)&boot_params);
+			       (unsigned long *)&boot_params, 0);
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table, "Failed to alloc lowmem for boot params\n");
 		return NULL;
@@ -505,7 +505,7 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 			options_size++;	/* NUL termination */
 
 			status = efi_low_alloc(sys_table, options_size, 1,
-					   &cmdline);
+					   &cmdline, 0);
 			if (status != EFI_SUCCESS) {
 				efi_printk(sys_table, "Failed to alloc mem for cmdline\n");
 				goto fail;
@@ -563,7 +563,8 @@ static efi_status_t exit_boot(struct boot_params *boot_params,
 again:
 	size += sizeof(*mem_map) * 2;
 	_size = size;
-	status = efi_low_alloc(sys_table, size, 1, (unsigned long *)&mem_map);
+	status = efi_low_alloc(sys_table, size, 1,
+			       (unsigned long *)&mem_map, 0);
 	if (status != EFI_SUCCESS)
 		return status;
 
@@ -697,7 +698,7 @@ static efi_status_t relocate_kernel(struct setup_header *hdr)
 				nr_pages, &start);
 	if (status != EFI_SUCCESS) {
 		status = efi_low_alloc(sys_table, hdr->init_size,
-				   hdr->kernel_alignment, &start);
+				   hdr->kernel_alignment, &start, 0);
 		if (status != EFI_SUCCESS)
 			efi_printk(sys_table, "Failed to alloc mem for kernel\n");
 	}
@@ -745,7 +746,7 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
 
 	gdt->size = 0x800;
 	status = efi_low_alloc(sys_table, gdt->size, 8,
-			   (unsigned long *)&gdt->address);
+			   (unsigned long *)&gdt->address, 0);
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table, "Failed to alloc mem for gdt\n");
 		goto fail;
diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index 8e6a7f9..63e3556 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -167,7 +167,7 @@ fail:
  */
 static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 			      unsigned long size, unsigned long align,
-			      unsigned long *addr)
+			      unsigned long *addr, unsigned long min)
 {
 	unsigned long map_size, desc_size;
 	efi_memory_desc_t *map;
@@ -204,6 +204,9 @@ static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 		if (start == 0x0)
 			start += 8;
 
+		if (start < min)
+			start = min;
+
 		start = round_up(start, align);
 		if ((start + size) > end)
 			continue;
-- 
1.7.10.4
