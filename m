From: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 08/14] efi/capsule: Remove pr_debug() on ENOMEM or EFAULT
Date: Wed, 30 Aug 2017 21:13:50 +0200
Message-ID: <918df7a26ab93ce1ef4faaccd77b73d5bf1da2db.1504120436.git.jan.kiszka@siemens.com>
References: <cover.1504120436.git.jan.kiszka@siemens.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1504120436.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <cover.1504120436.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
References: <cover.1504120436.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Hutchings <ben.hutchings-4yDnlxn2s6sWdaTGBSpHTA@public.gmane.org>
Cc: cip-dev-Y7OTERR3vatcpJa9FCkz6gFcV7zePqp5@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>

commit 7367633f0bfd783ae5838141f3af88bba6c45eb9 upstream.

Both cases are not worth a debug log message - the error code is telling
enough.

Signed-off-by: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Reviewed-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Link: http://lkml.kernel.org/r/20170602135207.21708-4-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Signed-off-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/capsule-loader.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index 91e91f7a8807..7b57dda2417d 100644
--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -88,10 +88,8 @@ static ssize_t efi_capsule_setup_info(struct capsule_info *cap_info,
 	temp_page = krealloc(cap_info->pages,
 			     pages_needed * sizeof(void *),
 			     GFP_KERNEL | __GFP_ZERO);
-	if (!temp_page) {
-		pr_debug("%s: krealloc() failed\n", __func__);
+	if (!temp_page)
 		return -ENOMEM;
-	}
 
 	cap_info->pages = temp_page;
 	cap_info->header_obtained = true;
@@ -111,10 +109,8 @@ static ssize_t efi_capsule_submit_update(struct capsule_info *cap_info)
 
 	cap_hdr_temp = vmap(cap_info->pages, cap_info->index,
 			VM_MAP, PAGE_KERNEL);
-	if (!cap_hdr_temp) {
-		pr_debug("%s: vmap() failed\n", __func__);
+	if (!cap_hdr_temp)
 		return -ENOMEM;
-	}
 
 	ret = efi_capsule_update(cap_hdr_temp, cap_info->pages);
 	vunmap(cap_hdr_temp);
@@ -171,7 +167,6 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
 	if (!cap_info->page_bytes_remain) {
 		page = alloc_page(GFP_KERNEL);
 		if (!page) {
-			pr_debug("%s: alloc_page() failed\n", __func__);
 			ret = -ENOMEM;
 			goto failed;
 		}
@@ -184,7 +179,6 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
 
 	kbuff = kmap(page);
 	if (!kbuff) {
-		pr_debug("%s: kmap() failed\n", __func__);
 		ret = -ENOMEM;
 		goto failed;
 	}
@@ -193,7 +187,6 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
 	/* Copy capsule binary data from user space to kernel space buffer */
 	write_byte = min_t(size_t, count, cap_info->page_bytes_remain);
 	if (copy_from_user(kbuff, buff, write_byte)) {
-		pr_debug("%s: copy_from_user() failed\n", __func__);
 		ret = -EFAULT;
 		goto fail_unmap;
 	}
-- 
2.12.3
