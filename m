From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v4 4/8] efi: efistub: allow allocation alignment larger than EFI_PAGE_SIZE
Date: Mon, 22 Dec 2014 10:59:00 +0000
Message-ID: <1419245944-2424-5-git-send-email-ard.biesheuvel@linaro.org>
References: <1419245944-2424-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1419245944-2424-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, geoff.levand-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On systems with 64 KB pages, it is preferable for UEFI memory map
entries to be 64 KB aligned multiples of 64 KB, because it relieves
us of having to deal with the residues.
So, if EFI_ALLOC_ALIGN is #define'd by the platform, use it to round
up all memory allocations made.

Acked-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index a920fec8fe88..e766df60fbfb 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -32,6 +32,15 @@
 
 static unsigned long __chunk_size = EFI_READ_CHUNK_SIZE;
 
+/*
+ * Allow the platform to override the allocation granularity: this allows
+ * systems that have the capability to run with a larger page size to deal
+ * with the allocations for initrd and fdt more efficiently.
+ */
+#ifndef EFI_ALLOC_ALIGN
+#define EFI_ALLOC_ALIGN		EFI_PAGE_SIZE
+#endif
+
 struct file_info {
 	efi_file_handle_t *handle;
 	u64 size;
@@ -150,10 +159,10 @@ efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
 	 * a specific address.  We are doing page-based allocations,
 	 * so we must be aligned to a page.
 	 */
-	if (align < EFI_PAGE_SIZE)
-		align = EFI_PAGE_SIZE;
+	if (align < EFI_ALLOC_ALIGN)
+		align = EFI_ALLOC_ALIGN;
 
-	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
+	nr_pages = round_up(size, EFI_ALLOC_ALIGN) / EFI_PAGE_SIZE;
 again:
 	for (i = 0; i < map_size / desc_size; i++) {
 		efi_memory_desc_t *desc;
@@ -235,10 +244,10 @@ efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 	 * a specific address.  We are doing page-based allocations,
 	 * so we must be aligned to a page.
 	 */
-	if (align < EFI_PAGE_SIZE)
-		align = EFI_PAGE_SIZE;
+	if (align < EFI_ALLOC_ALIGN)
+		align = EFI_ALLOC_ALIGN;
 
-	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
+	nr_pages = round_up(size, EFI_ALLOC_ALIGN) / EFI_PAGE_SIZE;
 	for (i = 0; i < map_size / desc_size; i++) {
 		efi_memory_desc_t *desc;
 		unsigned long m = (unsigned long)map;
@@ -292,7 +301,7 @@ void efi_free(efi_system_table_t *sys_table_arg, unsigned long size,
 	if (!size)
 		return;
 
-	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
+	nr_pages = round_up(size, EFI_ALLOC_ALIGN) / EFI_PAGE_SIZE;
 	efi_call_early(free_pages, addr, nr_pages);
 }
 
@@ -561,7 +570,7 @@ efi_status_t efi_relocate_kernel(efi_system_table_t *sys_table_arg,
 	 * to the preferred address.  If that fails, allocate as low
 	 * as possible while respecting the required alignment.
 	 */
-	nr_pages = round_up(alloc_size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
+	nr_pages = round_up(alloc_size, EFI_ALLOC_ALIGN) / EFI_PAGE_SIZE;
 	status = efi_call_early(allocate_pages,
 				EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
 				nr_pages, &efi_addr);
-- 
1.8.3.2
