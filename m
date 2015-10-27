From: Timur Tabi <timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH] arm64: efi: make sure vmlinux load address aligned on 2MBytes
Date: Tue, 27 Oct 2015 16:24:01 -0500
Message-ID: <1445981041-8774-1-git-send-email-timur@codeaurora.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mark.rutland-5wv7dgnIgG8@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Shanker Donthineni <shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Langsdorf <mlangsdo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, jcm-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Shanker Donthineni <shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

The vmlinux image load address must be aligned to 2MB, as documented
in Documentation/arm64/booting.txt. Otherwise, __create_page_tables
in head.S will create incorrect page table entries.

Signed-off-by: Shanker Donthineni <shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Signed-off-by: Timur Tabi <timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
---
 arch/arm64/kernel/efi-stub.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
index 816120e..df1433d 100644
--- a/arch/arm64/kernel/efi-stub.c
+++ b/arch/arm64/kernel/efi-stub.c
@@ -21,7 +21,7 @@ efi_status_t __init handle_kernel_image(efi_system_table_t *sys_table_arg,
 					unsigned long dram_base,
 					efi_loaded_image_t *image)
 {
-	efi_status_t status;
+	efi_status_t status = EFI_LOAD_ERROR;
 	unsigned long kernel_size, kernel_memsize = 0;
 	unsigned long nr_pages;
 	void *old_image_addr = (void *)*image_addr;
@@ -39,15 +39,18 @@ efi_status_t __init handle_kernel_image(efi_system_table_t *sys_table_arg,
 		 * value or a NULL pointer). It will also ensure that, on
 		 * platforms where the [dram_base, dram_base + TEXT_OFFSET)
 		 * interval is partially occupied by the firmware (like on APM
-		 * Mustang), we can still place the kernel at the address
-		 * 'dram_base + TEXT_OFFSET'.
+		 * Mustang) and dram_base is aligned on 2Mbytes, we can still
+		 * place the kernel at the address 'dram_base + TEXT_OFFSET'.
 		 */
-		*image_addr = *reserve_addr = dram_base + TEXT_OFFSET;
-		nr_pages = round_up(kernel_memsize, EFI_ALLOC_ALIGN) /
+		if (IS_ALIGNED(dram_base, SZ_2M)) {
+			*image_addr = *reserve_addr = dram_base + TEXT_OFFSET;
+			nr_pages = round_up(kernel_memsize, EFI_ALLOC_ALIGN) /
 			   EFI_PAGE_SIZE;
-		status = efi_call_early(allocate_pages, EFI_ALLOCATE_ADDRESS,
+			status = efi_call_early(allocate_pages,
+					EFI_ALLOCATE_ADDRESS,
 					EFI_LOADER_DATA, nr_pages,
 					(efi_physical_addr_t *)reserve_addr);
+		}
 		if (status != EFI_SUCCESS) {
 			kernel_memsize += TEXT_OFFSET;
 			status = efi_low_alloc(sys_table_arg, kernel_memsize,
-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
