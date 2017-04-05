From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 6/8] efi/capsule-loader: indirect calls to efi_capsule_setup_info via weak alias
Date: Wed,  5 Apr 2017 10:23:15 +0100
Message-ID: <20170405092317.27921-7-ard.biesheuvel@linaro.org>
References: <20170405092317.27921-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170405092317.27921-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org, hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, sascha.weisenberger-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org, jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

To allow platform specific code to hook into the capsule loading
routines, indirect calls to efi_capsule_setup_info() via a weak alias
of __efi_capsule_setup_info(), allowing platforms to redefine the former
but still use the latter.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/capsule-loader.c | 52 +++++++++-----------
 include/linux/efi.h                   | 12 +++++
 2 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index 5b012a467d7d..d68a1ecebbf3 100644
--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -20,16 +20,6 @@
 
 #define NO_FURTHER_WRITE_ACTION -1
 
-struct capsule_info {
-	efi_capsule_header_t	header;
-	int			reset_type;
-	long			index;
-	size_t			count;
-	size_t			total_size;
-	struct page		**pages;
-	size_t			page_bytes_remain;
-};
-
 /**
  * efi_free_all_buff_pages - free all previous allocated buffer pages
  * @cap_info: pointer to current instance of capsule_info structure
@@ -46,28 +36,13 @@ static void efi_free_all_buff_pages(struct capsule_info *cap_info)
 	cap_info->index = NO_FURTHER_WRITE_ACTION;
 }
 
-/**
- * efi_capsule_setup_info - obtain the efi capsule header in the binary and
- *			    setup capsule_info structure
- * @cap_info: pointer to current instance of capsule_info structure
- * @kbuff: a mapped first page buffer pointer
- * @hdr_bytes: the total received number of bytes for efi header
- **/
-static int efi_capsule_setup_info(struct capsule_info *cap_info,
-				  void *kbuff, size_t hdr_bytes)
+int __efi_capsule_setup_info(struct capsule_info *cap_info)
 {
 	size_t pages_needed;
 	int ret;
 	void *temp_page;
 
-	/* Only process data block that is larger than efi header size */
-	if (hdr_bytes < sizeof(efi_capsule_header_t))
-		return 0;
-
-	/* Reset back to the correct offset of header */
-	kbuff -= cap_info->count;
-	memcpy(&cap_info->header, kbuff, sizeof(cap_info->header));
-	pages_needed = ALIGN(cap_info->header.imagesize, PAGE_SIZE) / PAGE_SIZE;
+	pages_needed = ALIGN(cap_info->total_size, PAGE_SIZE) / PAGE_SIZE;
 
 	if (pages_needed == 0) {
 		pr_err("invalid capsule size");
@@ -84,7 +59,6 @@ static int efi_capsule_setup_info(struct capsule_info *cap_info,
 		return ret;
 	}
 
-	cap_info->total_size = cap_info->header.imagesize;
 	temp_page = krealloc(cap_info->pages,
 			     pages_needed * sizeof(void *),
 			     GFP_KERNEL | __GFP_ZERO);
@@ -97,6 +71,26 @@ static int efi_capsule_setup_info(struct capsule_info *cap_info,
 }
 
 /**
+ * efi_capsule_setup_info - obtain the efi capsule header in the binary and
+ *			    setup capsule_info structure
+ * @cap_info: pointer to current instance of capsule_info structure
+ * @kbuff: a mapped first page buffer pointer
+ * @hdr_bytes: the total received number of bytes for efi header
+ **/
+int __weak efi_capsule_setup_info(struct capsule_info *cap_info, void *kbuff,
+				  size_t hdr_bytes)
+{
+	/* Only process data block that is larger than efi header size */
+	if (hdr_bytes < sizeof(efi_capsule_header_t))
+		return 0;
+
+	memcpy(&cap_info->header, kbuff, sizeof(cap_info->header));
+	cap_info->total_size = cap_info->header.imagesize;
+
+	return __efi_capsule_setup_info(cap_info);
+}
+
+/**
  * efi_capsule_submit_update - invoke the efi_capsule_update API once binary
  *			       upload done
  * @cap_info: pointer to current instance of capsule_info structure
@@ -186,7 +180,7 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
 
 	/* Setup capsule binary info structure */
 	if (cap_info->header.headersize == 0) {
-		ret = efi_capsule_setup_info(cap_info, kbuff,
+		ret = efi_capsule_setup_info(cap_info, kbuff - cap_info->count,
 					     cap_info->count + write_byte);
 		if (ret)
 			goto fail_unmap;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index ec36f42a2add..a7379a2b5680 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -137,6 +137,18 @@ struct efi_boot_memmap {
 #define EFI_CAPSULE_POPULATE_SYSTEM_TABLE	0x00020000
 #define EFI_CAPSULE_INITIATE_RESET		0x00040000
 
+struct capsule_info {
+	efi_capsule_header_t	header;
+	int			reset_type;
+	long			index;
+	size_t			count;
+	size_t			total_size;
+	struct page		**pages;
+	size_t			page_bytes_remain;
+};
+
+int __efi_capsule_setup_info(struct capsule_info *cap_info);
+
 /*
  * Allocation types for calls to boottime->allocate_pages.
  */
-- 
2.9.3
