From: Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 1/1 linux-next] efi/capsule: kmap() can't fail
Date: Tue, 25 Apr 2017 20:10:51 +0200
Message-ID: <20170425181051.2187-1-fabf@skynet.be>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Remove NULL test on kmap()

Signed-off-by: Fabian Frederick <fabf-AgBVmzD5pcezQB+pC5nmwQ@public.gmane.org>
---
 drivers/firmware/efi/capsule-loader.c | 5 -----
 drivers/firmware/efi/capsule.c        | 4 ----
 2 files changed, 9 deletions(-)

diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index 9ae6c11..bf8b2ef 100644
--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -183,11 +183,6 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
 	page = cap_info->pages[cap_info->index - 1];
 
 	kbuff = kmap(page);
-	if (!kbuff) {
-		pr_debug("%s: kmap() failed\n", __func__);
-		ret = -EFAULT;
-		goto failed;
-	}
 	kbuff += PAGE_SIZE - cap_info->page_bytes_remain;
 
 	/* Copy capsule binary data from user space to kernel space buffer */
diff --git a/drivers/firmware/efi/capsule.c b/drivers/firmware/efi/capsule.c
index 6eedff4..e603ccf 100644
--- a/drivers/firmware/efi/capsule.c
+++ b/drivers/firmware/efi/capsule.c
@@ -247,10 +247,6 @@ int efi_capsule_update(efi_capsule_header_t *capsule, struct page **pages)
 		efi_capsule_block_desc_t *sglist;
 
 		sglist = kmap(sg_pages[i]);
-		if (!sglist) {
-			rv = -ENOMEM;
-			goto out;
-		}
 
 		for (j = 0; j < SGLIST_PER_PAGE && count > 0; j++) {
 			u64 sz = min_t(u64, imagesize, PAGE_SIZE);
-- 
2.9.3
