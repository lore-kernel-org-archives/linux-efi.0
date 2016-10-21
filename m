From: Roy Franz <roy.franz-ZPxbGqLxI0U@public.gmane.org>
Subject: [PATCH] Fix allocation size calculations
Date: Fri, 21 Oct 2016 11:47:54 -0700
Message-ID: <20161021184754.26844-1-roy.franz@hpe.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roy.franz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
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
This error seems to be present since the EFI stub was introduced, going
back 3.10.


 drivers/firmware/efi/libstub/efi-stub-helper.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index aded106..9575c44 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -194,6 +194,7 @@ efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
 		align = EFI_ALLOC_ALIGN;
 
 	nr_pages = round_up(size, EFI_ALLOC_ALIGN) / EFI_PAGE_SIZE;
+	size = nr_pages * EFI_PAGE_SIZE;
 again:
 	for (i = 0; i < map_size / desc_size; i++) {
 		efi_memory_desc_t *desc;
@@ -208,7 +209,7 @@ efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
 			continue;
 
 		start = desc->phys_addr;
-		end = start + desc->num_pages * (1UL << EFI_PAGE_SHIFT);
+		end = start + desc->num_pages * EFI_PAGE_SIZE;
 
 		if (end > max)
 			end = max;
@@ -286,6 +287,7 @@ efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 		align = EFI_ALLOC_ALIGN;
 
 	nr_pages = round_up(size, EFI_ALLOC_ALIGN) / EFI_PAGE_SIZE;
+	size = nr_pages * EFI_PAGE_SIZE;
 	for (i = 0; i < map_size / desc_size; i++) {
 		efi_memory_desc_t *desc;
 		unsigned long m = (unsigned long)map;
@@ -300,7 +302,7 @@ efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 			continue;
 
 		start = desc->phys_addr;
-		end = start + desc->num_pages * (1UL << EFI_PAGE_SHIFT);
+		end = start + desc->num_pages * EFI_PAGE_SIZE;
 
 		/*
 		 * Don't allocate at 0x0. It will confuse code that
-- 
2.9.3
