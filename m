From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 06/18] Enforce minimum alignment of 1 page on allocations.
Date: Sun, 22 Sep 2013 15:45:30 -0700
Message-ID: <1379889942-3135-7-git-send-email-roy.franz@linaro.org>
References: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1379889942-3135-1-git-send-email-roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The efi_high_alloc() and efi_low_alloc() functions
use the EFI_ALLOCATE_ADDRESS option to the EFI
function allocate_pages(), which requires a minimum
of page alignment, and rejects all other requests.
The existing code could fail to allocate depending
on allocation size, as although repeated allocation
attempts were made, none were guaranteed to be page
aligned.



Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Acked-by: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/efi-stub-helper.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index 2f528fb..9e451c6 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -101,6 +101,13 @@ static efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
 	if (status != EFI_SUCCESS)
 		goto fail;
 
+	/* Enforce minimum alignment that EFI requires when requesting
+	 * a specific address.  We are doing page-based allocations,
+	 * so we must be aligned to a page.
+	 */
+	if (align < EFI_PAGE_SIZE)
+		align = EFI_PAGE_SIZE;
+
 	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
 again:
 	for (i = 0; i < map_size / desc_size; i++) {
@@ -179,6 +186,13 @@ static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 	if (status != EFI_SUCCESS)
 		goto fail;
 
+	/* Enforce minimum alignment that EFI requires when requesting
+	 * a specific address.  We are doing page-based allocations,
+	 * so we must be aligned to a page.
+	 */
+	if (align < EFI_PAGE_SIZE)
+		align = EFI_PAGE_SIZE;
+
 	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
 	for (i = 0; i < map_size / desc_size; i++) {
 		efi_memory_desc_t *desc;
-- 
1.7.10.4
