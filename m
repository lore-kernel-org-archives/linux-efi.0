From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 1/9] efi/libstub: Fix allocation size calculations
Date: Sat, 12 Nov 2016 21:32:29 +0000
Message-ID: <20161112213237.8804-2-matt@codeblueprint.co.uk>
References: <20161112213237.8804-1-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161112213237.8804-1-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Roy Franz <roy.franz-ZPxbGqLxI0U@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Roy Franz <roy.franz-ZPxbGqLxI0U@public.gmane.org>

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
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index aded10662020..4b74bf86c74d 100644
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
2.10.0
