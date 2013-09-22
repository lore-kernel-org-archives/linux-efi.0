From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 11/18] Rename __get_map() to efi_get_memory_map()
Date: Sun, 22 Sep 2013 15:45:35 -0700
Message-ID: <1379889942-3135-12-git-send-email-roy.franz@linaro.org>
References: <1379889942-3135-1-git-send-email-roy.franz@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1379889942-3135-1-git-send-email-roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Rename function in preparation for making it more flexible
and sharing it.

Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/efi-stub-helper.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index 8331892..4ac274b 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -46,10 +46,10 @@ static void efi_printk(efi_system_table_t *sys_table_arg, char *str)
 }
 
 
-static efi_status_t __get_map(efi_system_table_t *sys_table_arg,
-			      efi_memory_desc_t **map,
-			      unsigned long *map_size,
-			      unsigned long *desc_size)
+static efi_status_t efi_get_memory_map(efi_system_table_t *sys_table_arg,
+				       efi_memory_desc_t **map,
+				       unsigned long *map_size,
+				       unsigned long *desc_size)
 {
 	efi_memory_desc_t *m = NULL;
 	efi_status_t status;
@@ -97,7 +97,7 @@ static efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
 	u64 max_addr = 0;
 	int i;
 
-	status = __get_map(sys_table_arg, &map, &map_size, &desc_size);
+	status = efi_get_memory_map(sys_table_arg, &map, &map_size, &desc_size);
 	if (status != EFI_SUCCESS)
 		goto fail;
 
@@ -182,7 +182,7 @@ static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 	unsigned long nr_pages;
 	int i;
 
-	status = __get_map(sys_table_arg, &map, &map_size, &desc_size);
+	status = efi_get_memory_map(sys_table_arg, &map, &map_size, &desc_size);
 	if (status != EFI_SUCCESS)
 		goto fail;
 
-- 
1.7.10.4
