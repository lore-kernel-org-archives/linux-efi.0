From: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 09/14] efi/capsule: Clean up pr_err/_info() messages
Date: Wed, 30 Aug 2017 21:13:51 +0200
Message-ID: <6df1733d8c500d8fb1c0898443765fc0c6843c32.1504120436.git.jan.kiszka@siemens.com>
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

commit 5dce14b9d1a29cf76331f0fe8eb7efd63e0fcb9a upstream.

Avoid __func__, improve the information provided by some of the
messages.

Signed-off-by: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Reviewed-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Link: http://lkml.kernel.org/r/20170602135207.21708-5-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Signed-off-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/capsule-loader.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index 7b57dda2417d..3fb91e1597a9 100644
--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -70,7 +70,7 @@ static ssize_t efi_capsule_setup_info(struct capsule_info *cap_info,
 	pages_needed = ALIGN(cap_hdr->imagesize, PAGE_SIZE) >> PAGE_SHIFT;
 
 	if (pages_needed == 0) {
-		pr_err("%s: pages count invalid\n", __func__);
+		pr_err("invalid capsule size");
 		return -EINVAL;
 	}
 
@@ -79,8 +79,7 @@ static ssize_t efi_capsule_setup_info(struct capsule_info *cap_info,
 				    cap_hdr->imagesize,
 				    &cap_info->reset_type);
 	if (ret) {
-		pr_err("%s: efi_capsule_supported() failed\n",
-		       __func__);
+		pr_err("capsule not supported\n");
 		return ret;
 	}
 
@@ -115,14 +114,14 @@ static ssize_t efi_capsule_submit_update(struct capsule_info *cap_info)
 	ret = efi_capsule_update(cap_hdr_temp, cap_info->pages);
 	vunmap(cap_hdr_temp);
 	if (ret) {
-		pr_err("%s: efi_capsule_update() failed\n", __func__);
+		pr_err("capsule update failed\n");
 		return ret;
 	}
 
 	/* Indicate capsule binary uploading is done */
 	cap_info->index = NO_FURTHER_WRITE_ACTION;
-	pr_info("%s: Successfully upload capsule file with reboot type '%s'\n",
-		__func__, !cap_info->reset_type ? "RESET_COLD" :
+	pr_info("Successfully upload capsule file with reboot type '%s'\n",
+		!cap_info->reset_type ? "RESET_COLD" :
 		cap_info->reset_type == 1 ? "RESET_WARM" :
 		"RESET_SHUTDOWN");
 	return 0;
@@ -207,8 +206,7 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
 	if (cap_info->header_obtained &&
 	    cap_info->count >= cap_info->total_size) {
 		if (cap_info->count > cap_info->total_size) {
-			pr_err("%s: upload size exceeded header defined size\n",
-			       __func__);
+			pr_err("capsule upload size exceeded header defined size\n");
 			ret = -EINVAL;
 			goto failed;
 		}
@@ -242,7 +240,7 @@ static int efi_capsule_flush(struct file *file, fl_owner_t id)
 	struct capsule_info *cap_info = file->private_data;
 
 	if (cap_info->index > 0) {
-		pr_err("%s: capsule upload not complete\n", __func__);
+		pr_err("capsule upload not complete\n");
 		efi_free_all_buff_pages(cap_info);
 		ret = -ECANCELED;
 	}
@@ -321,8 +319,7 @@ static int __init efi_capsule_loader_init(void)
 
 	ret = misc_register(&efi_capsule_misc);
 	if (ret)
-		pr_err("%s: Failed to register misc char file note\n",
-		       __func__);
+		pr_err("Unable to register capsule loader device\n");
 
 	return ret;
 }
-- 
2.12.3
