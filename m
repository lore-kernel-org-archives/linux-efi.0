From: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 13/14] efi/capsule-loader: Use page addresses rather than struct page pointers
Date: Wed, 30 Aug 2017 21:13:55 +0200
Message-ID: <01f0bf4cd9c202d2c871295c3068ea22f05dd50e.1504120436.git.jan.kiszka@siemens.com>
References: <cover.1504120436.git.jan.kiszka@siemens.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1504120436.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <cover.1504120436.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
References: <cover.1504120436.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Hutchings <ben.hutchings-4yDnlxn2s6sWdaTGBSpHTA@public.gmane.org>
Cc: cip-dev-Y7OTERR3vatcpJa9FCkz6gFcV7zePqp5@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

commit 2a457fb31df62c6b482f78e4f74aaed99271f44d upstream.

To give some leeway to code that handles non-standard capsule headers,
let's keep an array of page addresses rather than struct page pointers.

This gives special implementations of efi_capsule_setup_info() the
opportunity to mangle the payload a bit before it is presented to the
firmware, without putting any knowledge of the nature of such quirks
into the generic code.

Tested-by: Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Link: http://lkml.kernel.org/r/20170602135207.21708-10-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Signed-off-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/capsule-loader.c | 12 ++++++++----
 drivers/firmware/efi/capsule.c        |  7 ++++---
 include/linux/efi.h                   |  4 ++--
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index f7fdeab0bc37..feeafb673c07 100644
--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -20,6 +20,10 @@
 
 #define NO_FURTHER_WRITE_ACTION -1
 
+#ifndef phys_to_page
+#define phys_to_page(x)		pfn_to_page((x) >> PAGE_SHIFT)
+#endif
+
 /**
  * efi_free_all_buff_pages - free all previous allocated buffer pages
  * @cap_info: pointer to current instance of capsule_info structure
@@ -31,7 +35,7 @@
 static void efi_free_all_buff_pages(struct capsule_info *cap_info)
 {
 	while (cap_info->index > 0)
-		__free_page(cap_info->pages[--cap_info->index]);
+		__free_page(phys_to_page(cap_info->pages[--cap_info->index]));
 
 	cap_info->index = NO_FURTHER_WRITE_ACTION;
 }
@@ -161,12 +165,12 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
 			goto failed;
 		}
 
-		cap_info->pages[cap_info->index++] = page;
+		cap_info->pages[cap_info->index++] = page_to_phys(page);
 		cap_info->page_bytes_remain = PAGE_SIZE;
+	} else {
+		page = phys_to_page(cap_info->pages[cap_info->index - 1]);
 	}
 
-	page = cap_info->pages[cap_info->index - 1];
-
 	kbuff = kmap(page);
 	if (!kbuff) {
 		ret = -ENOMEM;
diff --git a/drivers/firmware/efi/capsule.c b/drivers/firmware/efi/capsule.c
index 1106773468b2..4a867c65d740 100644
--- a/drivers/firmware/efi/capsule.c
+++ b/drivers/firmware/efi/capsule.c
@@ -218,7 +218,7 @@ efi_capsule_update_locked(efi_capsule_header_t *capsule,
  *
  * Return 0 on success, a converted EFI status code on failure.
  */
-int efi_capsule_update(efi_capsule_header_t *capsule, struct page **pages)
+int efi_capsule_update(efi_capsule_header_t *capsule, phys_addr_t *pages)
 {
 	u32 imagesize = capsule->imagesize;
 	efi_guid_t guid = capsule->guid;
@@ -257,10 +257,11 @@ int efi_capsule_update(efi_capsule_header_t *capsule, struct page **pages)
 		}
 
 		for (j = 0; j < SGLIST_PER_PAGE && count > 0; j++) {
-			u64 sz = min_t(u64, imagesize, PAGE_SIZE);
+			u64 sz = min_t(u64, imagesize,
+				       PAGE_SIZE - (u64)*pages % PAGE_SIZE);
 
 			sglist[j].length = sz;
-			sglist[j].data = page_to_phys(*pages++);
+			sglist[j].data = *pages++;
 
 			imagesize -= sz;
 			count--;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index b386097e45bc..23a2a274bc6c 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -135,7 +135,7 @@ struct capsule_info {
 	long			index;
 	size_t			count;
 	size_t			total_size;
-	struct page		**pages;
+	phys_addr_t		*pages;
 	size_t			page_bytes_remain;
 };
 
@@ -1246,7 +1246,7 @@ extern int efi_capsule_supported(efi_guid_t guid, u32 flags,
 				 size_t size, int *reset);
 
 extern int efi_capsule_update(efi_capsule_header_t *capsule,
-			      struct page **pages);
+			      phys_addr_t *pages);
 
 #ifdef CONFIG_EFI_RUNTIME_MAP
 int efi_runtime_map_init(struct kobject *);
-- 
2.12.3
