From: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 6/7] efi/capsule: Factor out overloadable efi_capsule_identify_image
Date: Fri, 24 Mar 2017 18:34:19 +0100
Message-ID: <f24c01dde18c5aacad052a20200041f479fabc54.1490376860.git.jan.kiszka@siemens.com>
References: <cover.1490376860.git.jan.kiszka@siemens.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1490376860.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <cover.1490376860.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
References: <cover.1490376860.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, Hock Leong Kweh <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Sascha Weisenberger <sascha.weisenberger-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Another step to prepare Quark's CSH capsule format: Factor out the weak
efi_capsule_identify_image function which is supposed to tell standard-
conforming images apart from the special ones. The conforming version of
it is __efi_capsule_identify_image, and that is called unless
efi_capsule_identify_image is overloaded by an architecture-specific
quirk implementation.

efi_capsule_setup_info calls the image identification callback and is
prepared for the case, efi_hdr_displacement becomes > 0 and the total
image size > than what the standard EFI header reports.

Signed-off-by: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
---
 drivers/firmware/efi/capsule-loader.c | 89 ++++++++++++++++++++++-------------
 include/linux/efi.h                   | 18 +++++++
 2 files changed, 73 insertions(+), 34 deletions(-)

diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index 59e2694..50cacd4 100644
--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -20,26 +20,15 @@
 
 #define NO_FURTHER_WRITE_ACTION -1
 
-struct capsule_info {
-	bool		header_obtained;
-	int		reset_type;
-	long		index;
-	size_t		count;
-	size_t		total_size;
-	unsigned int	efi_hdr_displacement;
-	struct page	**pages;
-	size_t		page_bytes_remain;
-};
-
 /**
  * efi_free_all_buff_pages - free all previous allocated buffer pages
- * @cap_info: pointer to current instance of capsule_info structure
+ * @cap_info: pointer to current instance of efi_capsule_info structure
  *
  *	In addition to freeing buffer pages, it flags NO_FURTHER_WRITE_ACTION
  *	to cease processing data in subsequent write(2) calls until close(2)
  *	is called.
  **/
-static void efi_free_all_buff_pages(struct capsule_info *cap_info)
+static void efi_free_all_buff_pages(struct efi_capsule_info *cap_info)
 {
 	while (cap_info->index > 0)
 		__free_page(cap_info->pages[--cap_info->index]);
@@ -47,28 +36,63 @@ static void efi_free_all_buff_pages(struct capsule_info *cap_info)
 	cap_info->index = NO_FURTHER_WRITE_ACTION;
 }
 
+int __efi_capsule_identify_image(struct efi_capsule_info *cap_info,
+				 void *header, size_t hdr_bytes)
+{
+	efi_capsule_header_t *cap_hdr = header;
+
+	/* Only process data block that is larger than efi header size */
+	if (hdr_bytes < sizeof(efi_capsule_header_t))
+		return 0;
+
+	cap_info->total_size = cap_hdr->imagesize;
+	cap_info->efi_hdr_displacement = 0;
+
+	return 1;
+}
+
+/**
+ * efi_capsule_identify_image - identify the capsule image layout and initialize
+ * 				efi_capsule_info fields accordingly
+ * @cap_info: pointer to current instance of efi_capsule_info structure
+ * @header: mapped image header
+ * @hdr_bytes: the total received number of bytes for header
+ *
+ * Return 1 on success, 0 if insufficient data was read so far, otherwise
+ * negative error code.
+ */
+int __weak efi_capsule_identify_image(struct efi_capsule_info *cap_info,
+				      void *header, size_t hdr_bytes)
+{
+	return __efi_capsule_identify_image(cap_info, header, hdr_bytes);
+}
+
 /**
  * efi_capsule_setup_info - obtain the efi capsule header in the binary and
- *			    setup capsule_info structure
- * @cap_info: pointer to current instance of capsule_info structure
+ *			    setup efi_capsule_info structure
+ * @cap_info: pointer to current instance of efi_capsule_info structure
  * @kbuff: a mapped first page buffer pointer
  * @hdr_bytes: the total received number of bytes for efi header
  **/
-static int efi_capsule_setup_info(struct capsule_info *cap_info,
+static int efi_capsule_setup_info(struct efi_capsule_info *cap_info,
 				  void *kbuff, size_t hdr_bytes)
 {
 	efi_capsule_header_t *cap_hdr;
 	size_t pages_needed;
-	int ret;
 	void *temp_page;
-
-	/* Only process data block that is larger than efi header size */
-	if (hdr_bytes < sizeof(efi_capsule_header_t))
-		return 0;
+	void *header;
+	int ret;
 
 	/* Reset back to the correct offset of header */
-	cap_hdr = kbuff - cap_info->count;
-	pages_needed = ALIGN(cap_hdr->imagesize, PAGE_SIZE) >> PAGE_SHIFT;
+	header = kbuff - cap_info->count;
+
+	ret = efi_capsule_identify_image(cap_info, header, hdr_bytes);
+	if (ret <= 0)
+		return ret;
+
+	cap_hdr = header + cap_info->efi_hdr_displacement;
+
+	pages_needed = ALIGN(cap_info->total_size, PAGE_SIZE) >> PAGE_SHIFT;
 
 	if (pages_needed == 0) {
 		pr_err("invalid capsule size");
@@ -77,16 +101,13 @@ static int efi_capsule_setup_info(struct capsule_info *cap_info,
 
 	/* Check if the capsule binary supported */
 	ret = efi_capsule_supported(cap_hdr->guid, cap_hdr->flags,
-				    cap_hdr->imagesize,
+				    cap_info->total_size,
 				    &cap_info->reset_type);
 	if (ret) {
 		pr_err("capsule not supported\n");
 		return ret;
 	}
 
-	cap_info->efi_hdr_displacement = 0;
-
-	cap_info->total_size = cap_hdr->imagesize;
 	temp_page = krealloc(cap_info->pages,
 			     pages_needed * sizeof(void *),
 			     GFP_KERNEL | __GFP_ZERO);
@@ -102,9 +123,9 @@ static int efi_capsule_setup_info(struct capsule_info *cap_info,
 /**
  * efi_capsule_submit_update - invoke the efi_capsule_update API once binary
  *			       upload done
- * @cap_info: pointer to current instance of capsule_info structure
+ * @cap_info: pointer to current instance of efi_capsule_info structure
  **/
-static ssize_t efi_capsule_submit_update(struct capsule_info *cap_info)
+static ssize_t efi_capsule_submit_update(struct efi_capsule_info *cap_info)
 {
 	efi_capsule_header_t *cap_hdr;
 	void *mapped_pages;
@@ -157,7 +178,7 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
 				 size_t count, loff_t *offp)
 {
 	int ret = 0;
-	struct capsule_info *cap_info = file->private_data;
+	struct efi_capsule_info *cap_info = file->private_data;
 	struct page *page;
 	void *kbuff = NULL;
 	size_t write_byte;
@@ -244,7 +265,7 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
 static int efi_capsule_flush(struct file *file, fl_owner_t id)
 {
 	int ret = 0;
-	struct capsule_info *cap_info = file->private_data;
+	struct efi_capsule_info *cap_info = file->private_data;
 
 	if (cap_info->index > 0) {
 		pr_err("capsule upload not complete\n");
@@ -265,7 +286,7 @@ static int efi_capsule_flush(struct file *file, fl_owner_t id)
  **/
 static int efi_capsule_release(struct inode *inode, struct file *file)
 {
-	struct capsule_info *cap_info = file->private_data;
+	struct efi_capsule_info *cap_info = file->private_data;
 
 	kfree(cap_info->pages);
 	kfree(file->private_data);
@@ -278,14 +299,14 @@ static int efi_capsule_release(struct inode *inode, struct file *file)
  * @inode: not used
  * @file: file pointer
  *
- *	Will allocate each capsule_info memory for each file open call.
+ *	Will allocate each efi_capsule_info memory for each file open call.
  *	This provided the capability to support multiple file open feature
  *	where user is not needed to wait for others to finish in order to
  *	upload their capsule binary.
  **/
 static int efi_capsule_open(struct inode *inode, struct file *file)
 {
-	struct capsule_info *cap_info;
+	struct efi_capsule_info *cap_info;
 
 	cap_info = kzalloc(sizeof(*cap_info), GFP_KERNEL);
 	if (!cap_info)
diff --git a/include/linux/efi.h b/include/linux/efi.h
index d83095c6..5561817 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1397,6 +1397,18 @@ int efivars_sysfs_init(void);
 #define EFIVARS_DATA_SIZE_MAX 1024
 
 #endif /* CONFIG_EFI_VARS */
+
+struct efi_capsule_info {
+	bool		header_obtained;
+	int		reset_type;
+	long		index;
+	size_t		count;
+	size_t		total_size;
+	unsigned int	efi_hdr_displacement;
+	struct page	**pages;
+	size_t		page_bytes_remain;
+};
+
 extern bool efi_capsule_pending(int *reset_type);
 
 extern int efi_capsule_supported(efi_guid_t guid, u32 flags,
@@ -1406,6 +1418,12 @@ extern int efi_capsule_update(efi_capsule_header_t *capsule,
 			      unsigned int efi_hdr_displacement,
 			      struct page **pages);
 
+int __efi_capsule_identify_image(struct efi_capsule_info *cap_info,
+				 void *header, size_t hdr_bytes);
+
+int efi_capsule_identify_image(struct efi_capsule_info *cap_info, void *header,
+			       size_t hdr_bytes);
+
 #ifdef CONFIG_EFI_RUNTIME_MAP
 int efi_runtime_map_init(struct kobject *);
 int efi_get_runtime_map_size(void);
-- 
2.10.2
