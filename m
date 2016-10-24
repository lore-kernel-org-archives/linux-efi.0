From: Roy Franz <roy.franz-ZPxbGqLxI0U@public.gmane.org>
Subject: [PATCH v2] Fix allocation size calculations
Date: Mon, 24 Oct 2016 12:06:13 -0700
Message-ID: <20161024190613.8010-1-roy.franz@hpe.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roy.franz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Roy Franz <roy.franz-ZPxbGqLxI0U@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Adjust the size used in calculations to match the actual size of allocation
that will be performed based on EFI size/alignment constraints.
efi_high_alloc() and efi_low_alloc() used the passed size in bytes directly
to find space in the memory map for the allocation, rather than the actual
allocation size that has been adjusted for size and alignment constraints.
This results in failed allocations and retries in efi_high_alloc().  The
same error is present in efi_low_alloc(), although failure will only happen
if the lowest memory block is small.
Adjust allocation size computation to respect EFI_ALLOC_ALIGN, which is
the minimum alignment that should always be enforced, and at 64k on arm64
is bigger than EFI_PAGE_SIZE.
Also use EFI_PAGE_SIZE consistently and remove use of EFI_PAGE_SHIFT to
calculate page size.

Signed-off-by: Roy Franz <roy.franz-ZPxbGqLxI0U@public.gmane.org>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 28 +++++++++++++++++---------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index aded106..b97dfac 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -161,6 +161,7 @@ unsigned long get_dram_base(efi_system_table_t *sys_table_arg)
 
 /*
  * Allocate at the highest possible address that is not above 'max'.
+ * Align the allocation address and size to 'align'.
  */
 efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
 			    unsigned long size, unsigned long align,
@@ -186,14 +187,17 @@ efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
 		goto fail;
 
 	/*
-	 * Enforce minimum alignment that EFI requires when requesting
-	 * a specific address.  We are doing page-based allocations,
-	 * so we must be aligned to a page.
+	 * Enforce minimum alignment that EFI or Linux requires when
+	 * requesting a specific address.  We are doing page-based (or
+	 * larger) allocations, and both the address and size must meet
+	 * alignment constraints. Arm64 requires 64k alignment, while other
+	 * arches simply require 4k.
 	 */
 	if (align < EFI_ALLOC_ALIGN)
 		align = EFI_ALLOC_ALIGN;
 
-	nr_pages = round_up(size, EFI_ALLOC_ALIGN) / EFI_PAGE_SIZE;
+	nr_pages = round_up(size, align) / EFI_PAGE_SIZE;
+	size = nr_pages * EFI_PAGE_SIZE;
 again:
 	for (i = 0; i < map_size / desc_size; i++) {
 		efi_memory_desc_t *desc;
@@ -208,7 +212,7 @@ efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
 			continue;
 
 		start = desc->phys_addr;
-		end = start + desc->num_pages * (1UL << EFI_PAGE_SHIFT);
+		end = start + desc->num_pages * EFI_PAGE_SIZE;
 
 		if (end > max)
 			end = max;
@@ -254,6 +258,7 @@ efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
 
 /*
  * Allocate at the lowest possible address.
+ * Align the allocation address and size to 'align'.
  */
 efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 			   unsigned long size, unsigned long align,
@@ -278,14 +283,17 @@ efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 		goto fail;
 
 	/*
-	 * Enforce minimum alignment that EFI requires when requesting
-	 * a specific address.  We are doing page-based allocations,
-	 * so we must be aligned to a page.
+	 * Enforce minimum alignment that EFI or Linux requires when
+	 * requesting a specific address.  We are doing page-based (or
+	 * larger) allocations, and both the address and size must meet
+	 * alignment constraints. Arm64 requires 64k alignment, while other
+	 * arches simply require 4k.
 	 */
 	if (align < EFI_ALLOC_ALIGN)
 		align = EFI_ALLOC_ALIGN;
 
-	nr_pages = round_up(size, EFI_ALLOC_ALIGN) / EFI_PAGE_SIZE;
+	nr_pages = round_up(size, align) / EFI_PAGE_SIZE;
+	size = nr_pages * EFI_PAGE_SIZE;
 	for (i = 0; i < map_size / desc_size; i++) {
 		efi_memory_desc_t *desc;
 		unsigned long m = (unsigned long)map;
@@ -300,7 +308,7 @@ efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 			continue;
 
 		start = desc->phys_addr;
-		end = start + desc->num_pages * (1UL << EFI_PAGE_SHIFT);
+		end = start + desc->num_pages * EFI_PAGE_SIZE;
 
 		/*
 		 * Don't allocate at 0x0. It will confuse code that
-- 
2.9.3
