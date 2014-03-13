From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 08/15] efi: Add get_dram_base() helper function
Date: Thu, 13 Mar 2014 22:47:01 +0000
Message-ID: <1394750828-16351-9-git-send-email-leif.lindholm@linaro.org>
References: <1394750828-16351-1-git-send-email-leif.lindholm@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1394750828-16351-1-git-send-email-leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Add the get_dram_base() function, shared by arm/arm64.

Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/efi-stub-helper.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index 4c8ab86..4a9986b 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -11,6 +11,10 @@
  */
 #define EFI_READ_CHUNK_SIZE	(1024 * 1024)
 
+/* error code which can't be mistaken for valid address */
+#define EFI_ERROR	(~0UL)
+
+
 struct file_info {
 	efi_file_handle_t *handle;
 	u64 size;
@@ -92,6 +96,32 @@ fail:
 	return status;
 }
 
+
+static unsigned long __init get_dram_base(efi_system_table_t *sys_table)
+{
+	efi_status_t status;
+	unsigned long map_size;
+	unsigned long membase  = EFI_ERROR;
+	struct efi_memory_map map;
+	efi_memory_desc_t *md;
+
+	status = efi_get_memory_map(sys_table, (efi_memory_desc_t **)&map.map,
+				    &map_size, &map.desc_size, NULL, NULL);
+	if (status != EFI_SUCCESS)
+		return membase;
+
+	map.map_end = map.map + map_size;
+
+	for_each_efi_memory_desc(&map, md)
+		if (md->attribute & EFI_MEMORY_WB)
+			if (membase > md->phys_addr)
+				membase = md->phys_addr;
+
+	efi_call_phys1(sys_table->boottime->free_pool, map.map);
+
+	return membase;
+}
+
 /*
  * Allocate at the highest possible address that is not above 'max'.
  */
-- 
1.7.10.4
