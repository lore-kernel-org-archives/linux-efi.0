From: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 1/3] efi/capsule-loader: Redirect calls to efi_capsule_setup_info via weak alias
Date: Wed, 19 Apr 2017 20:33:00 +0200
Message-ID: <bc0b9dc50cdb426b8d6d2341c557099e7db05d34.1492626781.git.jan.kiszka@siemens.com>
References: <cover.1492626781.git.jan.kiszka@siemens.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1492626781.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <cover.1492626781.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
References: <cover.1492626781.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, Hock Leong Kweh <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Sascha Weisenberger <sascha.weisenberger-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

To allow platform specific code to hook into the capsule loading
routines, indirect calls to efi_capsule_setup_info() via a weak alias
of __efi_capsule_setup_info(), allowing platforms to redefine the former
but still use the latter.

Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/capsule-loader.c | 56 +++++++++++++++++------------------
 include/linux/efi.h                   | 12 ++++++++
 2 files changed, 39 insertions(+), 29 deletions(-)

diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index 5b012a467d7d..f7fdeab0bc37 100644
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
@@ -97,6 +71,30 @@ static int efi_capsule_setup_info(struct capsule_info *cap_info,
 }
 
 /**
+ * efi_capsule_setup_info - obtain the efi capsule header in the binary and
+ *			    setup capsule_info structure
+ * @cap_info: pointer to current instance of capsule_info structure
+ * @kbuff: a mapped first page buffer pointer
+ * @hdr_bytes: the total received number of bytes for efi header
+ *
+ * Platforms with non-standard capsule update mechanisms can override
+ * this __weak function so they can perform any required capsule
+ * image munging. See quark_quirk_function() for an example.
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
@@ -186,7 +184,7 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
 
 	/* Setup capsule binary info structure */
 	if (cap_info->header.headersize == 0) {
-		ret = efi_capsule_setup_info(cap_info, kbuff,
+		ret = efi_capsule_setup_info(cap_info, kbuff - cap_info->count,
 					     cap_info->count + write_byte);
 		if (ret)
 			goto fail_unmap;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 94d34e0be24f..af54be874dd0 100644
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
2.12.0
