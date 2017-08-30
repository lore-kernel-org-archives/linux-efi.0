From: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 11/14] efi/capsule-loader: Use a cached copy of the capsule header
Date: Wed, 30 Aug 2017 21:13:53 +0200
Message-ID: <77c3d7dfbafc5d23298ef751b68e3484d6939dae.1504120436.git.jan.kiszka@siemens.com>
References: <cover.1504120436.git.jan.kiszka@siemens.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1504120436.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <cover.1504120436.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
References: <cover.1504120436.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Hutchings <ben.hutchings-4yDnlxn2s6sWdaTGBSpHTA@public.gmane.org>
Cc: cip-dev-Y7OTERR3vatcpJa9FCkz6gFcV7zePqp5@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

commit 82c3768b8d68c40ecde92338899c838b7c674ffb upstream.

Instead of kmapping the capsule data twice, copy the capsule header
into the capsule info struct we keep locally. This is an improvement
by itself, but will also enable handling of non-standard header formats
more easily.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Reviewed-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Link: http://lkml.kernel.org/r/20170602135207.21708-7-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Signed-off-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/capsule-loader.c | 41 +++++++++++++++--------------------
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
2.12.3
