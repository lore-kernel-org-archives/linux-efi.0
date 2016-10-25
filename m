From: Roy Franz <roy.franz-ZPxbGqLxI0U@public.gmane.org>
Subject: [PATCH v3] Fix allocation size calculations
Date: Tue, 25 Oct 2016 09:36:34 -0700
Message-ID: <20161025163634.11893-1-roy.franz@hpe.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roy.franz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Roy Franz <roy.franz-ZPxbGqLxI0U@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Adjust the size used in calculations to match the actual size of allocation
that will be performed based on EFI size/alignment constraints.
efi_high_alloc() and efi_low_alloc() use the passed size in bytes directly
to find space in the memory map for the allocation, rather than the actual
allocation size that has been adjusted for size and alignment constraints.
This results in failed allocations and retries in efi_high_alloc().  The
same error is present in efi_low_alloc(), although failure will only happen
if the lowest memory block is small.
Also use EFI_PAGE_SIZE consistently and remove use of EFI_PAGE_SHIFT to
calculate page size.

Signed-off-by: Roy Franz <roy.franz-ZPxbGqLxI0U@public.gmane.org>
---

v3:
 * Revert incorrect additional size alignment
 * Simplify size and nr_pages calculation
 * Reword comments regarding alignment.  Old comments mention page
   alignment, but for arm64 we enforce larger alignment.  Clarify that
   the greater alignment is a Linux requirement, unlike the page alignment
   that is an EFI requirement.
v2:
 * Add addition size alignment
 * Update comments regarding page alignment


 drivers/firmware/efi/libstub/efi-stub-helper.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index aded106..4b74bf8 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -186,14 +186,16 @@ efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
 		goto fail;
 
 	/*
-	 * Enforce minimum alignment that EFI requires when requesting
-	 * a specific address.  We are doing page-based allocations,
-	 * so we must be aligned to a page.
+	 * Enforce minimum alignment that EFI or Linux requires when
+	 * requesting a specific address.  We are doing page-based (or
+	 * larger) allocations, and both the address and size must meet
+	 * alignment constraints.
 	 */
 	if (align < EFI_ALLOC_ALIGN)
 		align = EFI_ALLOC_ALIGN;
 
-	nr_pages = round_up(size, EFI_ALLOC_ALIGN) / EFI_PAGE_SIZE;
+	size = round_up(size, EFI_ALLOC_ALIGN);
+	nr_pages = size / EFI_PAGE_SIZE;
 again:
 	for (i = 0; i < map_size / desc_size; i++) {
 		efi_memory_desc_t *desc;
@@ -208,7 +210,7 @@ efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
 			continue;
 
 		start = desc->phys_addr;
-		end = start + desc->num_pages * (1UL << EFI_PAGE_SHIFT);
+		end = start + desc->num_pages * EFI_PAGE_SIZE;
 
 		if (end > max)
 			end = max;
@@ -278,14 +280,16 @@ efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 		goto fail;
 
 	/*
-	 * Enforce minimum alignment that EFI requires when requesting
-	 * a specific address.  We are doing page-based allocations,
-	 * so we must be aligned to a page.
+	 * Enforce minimum alignment that EFI or Linux requires when
+	 * requesting a specific address.  We are doing page-based (or
+	 * larger) allocations, and both the address and size must meet
+	 * alignment constraints.
 	 */
 	if (align < EFI_ALLOC_ALIGN)
 		align = EFI_ALLOC_ALIGN;
 
-	nr_pages = round_up(size, EFI_ALLOC_ALIGN) / EFI_PAGE_SIZE;
+	size = round_up(size, EFI_ALLOC_ALIGN);
+	nr_pages = size / EFI_PAGE_SIZE;
 	for (i = 0; i < map_size / desc_size; i++) {
 		efi_memory_desc_t *desc;
 		unsigned long m = (unsigned long)map;
@@ -300,7 +304,7 @@ efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 			continue;
 
 		start = desc->phys_addr;
-		end = start + desc->num_pages * (1UL << EFI_PAGE_SHIFT);
+		end = start + desc->num_pages * EFI_PAGE_SIZE;
 
 		/*
 		 * Don't allocate at 0x0. It will confuse code that
-- 
2.9.3
