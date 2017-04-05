From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 5/8] efi/capsule-loader: use cached copy of capsule header
Date: Wed,  5 Apr 2017 10:23:14 +0100
Message-ID: <20170405092317.27921-6-ard.biesheuvel@linaro.org>
References: <20170405092317.27921-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170405092317.27921-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org, hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, sascha.weisenberger-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org, jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Instead of kmapping the capsule data twice, copy the capsule header
into the capsule info struct we keep locally. This is an improvement
by itself, but will also enable handling of non-standard header formats
more easily.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/capsule-loader.c | 41 ++++++++------------
 1 file changed, 17 insertions(+), 24 deletions(-)

diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index 37d3f6ec2d28..5b012a467d7d 100644
--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -21,13 +21,13 @@
 #define NO_FURTHER_WRITE_ACTION -1
 
 struct capsule_info {
-	bool		header_obtained;
-	int		reset_type;
-	long		index;
-	size_t		count;
-	size_t		total_size;
-	struct page	**pages;
-	size_t		page_bytes_remain;
+	efi_capsule_header_t	header;
+	int			reset_type;
+	long			index;
+	size_t			count;
+	size_t			total_size;
+	struct page		**pages;
+	size_t			page_bytes_remain;
 };
 
 /**
@@ -56,7 +56,6 @@ static void efi_free_all_buff_pages(struct capsule_info *cap_info)
 static int efi_capsule_setup_info(struct capsule_info *cap_info,
 				  void *kbuff, size_t hdr_bytes)
 {
-	efi_capsule_header_t *cap_hdr;
 	size_t pages_needed;
 	int ret;
 	void *temp_page;
@@ -66,8 +65,9 @@ static int efi_capsule_setup_info(struct capsule_info *cap_info,
 		return 0;
 
 	/* Reset back to the correct offset of header */
-	cap_hdr = kbuff - cap_info->count;
-	pages_needed = ALIGN(cap_hdr->imagesize, PAGE_SIZE) >> PAGE_SHIFT;
+	kbuff -= cap_info->count;
+	memcpy(&cap_info->header, kbuff, sizeof(cap_info->header));
+	pages_needed = ALIGN(cap_info->header.imagesize, PAGE_SIZE) / PAGE_SIZE;
 
 	if (pages_needed == 0) {
 		pr_err("invalid capsule size");
@@ -75,15 +75,16 @@ static int efi_capsule_setup_info(struct capsule_info *cap_info,
 	}
 
 	/* Check if the capsule binary supported */
-	ret = efi_capsule_supported(cap_hdr->guid, cap_hdr->flags,
-				    cap_hdr->imagesize,
+	ret = efi_capsule_supported(cap_info->header.guid,
+				    cap_info->header.flags,
+				    cap_info->header.imagesize,
 				    &cap_info->reset_type);
 	if (ret) {
 		pr_err("capsule not supported\n");
 		return ret;
 	}
 
-	cap_info->total_size = cap_hdr->imagesize;
+	cap_info->total_size = cap_info->header.imagesize;
 	temp_page = krealloc(cap_info->pages,
 			     pages_needed * sizeof(void *),
 			     GFP_KERNEL | __GFP_ZERO);
@@ -91,7 +92,6 @@ static int efi_capsule_setup_info(struct capsule_info *cap_info,
 		return -ENOMEM;
 
 	cap_info->pages = temp_page;
-	cap_info->header_obtained = true;
 
 	return 0;
 }
@@ -104,15 +104,8 @@ static int efi_capsule_setup_info(struct capsule_info *cap_info,
 static ssize_t efi_capsule_submit_update(struct capsule_info *cap_info)
 {
 	int ret;
-	void *cap_hdr_temp;
 
-	cap_hdr_temp = vmap(cap_info->pages, cap_info->index,
-			VM_MAP, PAGE_KERNEL);
-	if (!cap_hdr_temp)
-		return -ENOMEM;
-
-	ret = efi_capsule_update(cap_hdr_temp, cap_info->pages);
-	vunmap(cap_hdr_temp);
+	ret = efi_capsule_update(&cap_info->header, cap_info->pages);
 	if (ret) {
 		pr_err("capsule update failed\n");
 		return ret;
@@ -192,7 +185,7 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
 	cap_info->page_bytes_remain -= write_byte;
 
 	/* Setup capsule binary info structure */
-	if (!cap_info->header_obtained) {
+	if (cap_info->header.headersize == 0) {
 		ret = efi_capsule_setup_info(cap_info, kbuff,
 					     cap_info->count + write_byte);
 		if (ret)
@@ -203,7 +196,7 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
 	kunmap(page);
 
 	/* Submit the full binary to efi_capsule_update() API */
-	if (cap_info->header_obtained &&
+	if (cap_info->header.headersize > 0 &&
 	    cap_info->count >= cap_info->total_size) {
 		if (cap_info->count > cap_info->total_size) {
 			pr_err("capsule upload size exceeded header defined size\n");
-- 
2.9.3
