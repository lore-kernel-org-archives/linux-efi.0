From: Ge Song <ge.song-PT9Dzx9SjPiXmMXjJBpWqg@public.gmane.org>
Subject: [PATCH 1/2] Revert "efi/capsule-loader: Use page addresses rather than struct page pointers"
Date: Tue, 19 Dec 2017 18:45:37 +0800
Message-ID: <1513680337-5421-1-git-send-email-ge.song@hxt-semitech.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ge Song <ge.song-PT9Dzx9SjPiXmMXjJBpWqg@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

This reverts commit 2a457fb31df62c6b482f78e4f74aaed99271f44d.

Use "struct page **pages" to record allocated pages. In UEFI spec 2.6,
section 7.5.3 Update Capsule, the description of the parameter
CapsuleHeaderArray in UpdateCapsule() is "Virtual pointer to an array
of virtual pointers to the capsules being passed into update capsule.
Each capsules is assumed to stored in contiguous virtual memory". Pages
is used to record allocated physical pages that store the capsule deliverd
from userspace, after that it can be used by vmap() to request a
continious virtual memory space

Signed-off-by: Ge Song <ge.song-PT9Dzx9SjPiXmMXjJBpWqg@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 drivers/firmware/efi/capsule-loader.c | 12 ++++--------
 drivers/firmware/efi/capsule.c        |  7 +++----
 include/linux/efi.h                   |  4 ++--
 3 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index ec8ac5c4dd84..cbc3526953d5 100644
--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -20,10 +20,6 @@
 
 #define NO_FURTHER_WRITE_ACTION -1
 
-#ifndef phys_to_page
-#define phys_to_page(x)		pfn_to_page((x) >> PAGE_SHIFT)
-#endif
-
 /**
  * efi_free_all_buff_pages - free all previous allocated buffer pages
  * @cap_info: pointer to current instance of capsule_info structure
@@ -35,7 +31,7 @@
 static void efi_free_all_buff_pages(struct capsule_info *cap_info)
 {
 	while (cap_info->index > 0)
-		__free_page(phys_to_page(cap_info->pages[--cap_info->index]));
+		__free_page(cap_info->pages[--cap_info->index]);
 
 	cap_info->index = NO_FURTHER_WRITE_ACTION;
 }
@@ -165,12 +161,12 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
 			goto failed;
 		}
 
-		cap_info->pages[cap_info->index++] = page_to_phys(page);
+		cap_info->pages[cap_info->index++] = page;
 		cap_info->page_bytes_remain = PAGE_SIZE;
-	} else {
-		page = phys_to_page(cap_info->pages[cap_info->index - 1]);
 	}
 
+	page = cap_info->pages[cap_info->index - 1];
+
 	kbuff = kmap(page);
 	kbuff += PAGE_SIZE - cap_info->page_bytes_remain;
 
diff --git a/drivers/firmware/efi/capsule.c b/drivers/firmware/efi/capsule.c
index 901b9306bf94..e603ccf39d80 100644
--- a/drivers/firmware/efi/capsule.c
+++ b/drivers/firmware/efi/capsule.c
@@ -214,7 +214,7 @@ efi_capsule_update_locked(efi_capsule_header_t *capsule,
  *
  * Return 0 on success, a converted EFI status code on failure.
  */
-int efi_capsule_update(efi_capsule_header_t *capsule, phys_addr_t *pages)
+int efi_capsule_update(efi_capsule_header_t *capsule, struct page **pages)
 {
 	u32 imagesize = capsule->imagesize;
 	efi_guid_t guid = capsule->guid;
@@ -249,11 +249,10 @@ int efi_capsule_update(efi_capsule_header_t *capsule, phys_addr_t *pages)
 		sglist = kmap(sg_pages[i]);
 
 		for (j = 0; j < SGLIST_PER_PAGE && count > 0; j++) {
-			u64 sz = min_t(u64, imagesize,
-				       PAGE_SIZE - (u64)*pages % PAGE_SIZE);
+			u64 sz = min_t(u64, imagesize, PAGE_SIZE);
 
 			sglist[j].length = sz;
-			sglist[j].data = *pages++;
+			sglist[j].data = page_to_phys(*pages++);
 
 			imagesize -= sz;
 			count--;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 8269bcb8ccf7..a7379a2b5680 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -143,7 +143,7 @@ struct capsule_info {
 	long			index;
 	size_t			count;
 	size_t			total_size;
-	phys_addr_t		*pages;
+	struct page		**pages;
 	size_t			page_bytes_remain;
 };
 
@@ -1415,7 +1415,7 @@ extern int efi_capsule_supported(efi_guid_t guid, u32 flags,
 				 size_t size, int *reset);
 
 extern int efi_capsule_update(efi_capsule_header_t *capsule,
-			      phys_addr_t *pages);
+			      struct page **pages);
 
 #ifdef CONFIG_EFI_RUNTIME_MAP
 int efi_runtime_map_init(struct kobject *);
-- 
2.7.4
