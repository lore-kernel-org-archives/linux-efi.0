From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 09/13] efi/capsule-loader: Use page addresses rather than struct page pointers
Date: Fri,  2 Jun 2017 13:52:03 +0000
Message-ID: <20170602135207.21708-10-ard.biesheuvel@linaro.org>
References: <20170602135207.21708-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170602135207.21708-1-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

To give some leeway to code that handles non-standard capsule headers,
let's keep an array of page addresses rather than struct page pointers.

This gives special implementations of efi_capsule_setup_info() the
opportunity to mangle the payload a bit before it is presented to the
firmware, without putting any knowledge of the nature of such quirks
into the generic code.

Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Tested-by: "Bryan O'Donoghue" <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/capsule-loader.c | 12 ++++++++----
 drivers/firmware/efi/capsule.c        |  7 ++++---
 include/linux/efi.h                   |  4 ++--
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index cbc3526953d5..ec8ac5c4dd84 100644
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
 	kbuff += PAGE_SIZE - cap_info->page_bytes_remain;
 
diff --git a/drivers/firmware/efi/capsule.c b/drivers/firmware/efi/capsule.c
index e603ccf39d80..901b9306bf94 100644
--- a/drivers/firmware/efi/capsule.c
+++ b/drivers/firmware/efi/capsule.c
@@ -214,7 +214,7 @@ efi_capsule_update_locked(efi_capsule_header_t *capsule,
  *
  * Return 0 on success, a converted EFI status code on failure.
  */
-int efi_capsule_update(efi_capsule_header_t *capsule, struct page **pages)
+int efi_capsule_update(efi_capsule_header_t *capsule, phys_addr_t *pages)
 {
 	u32 imagesize = capsule->imagesize;
 	efi_guid_t guid = capsule->guid;
@@ -249,10 +249,11 @@ int efi_capsule_update(efi_capsule_header_t *capsule, struct page **pages)
 		sglist = kmap(sg_pages[i]);
 
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
index a7379a2b5680..8269bcb8ccf7 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -143,7 +143,7 @@ struct capsule_info {
 	long			index;
 	size_t			count;
 	size_t			total_size;
-	struct page		**pages;
+	phys_addr_t		*pages;
 	size_t			page_bytes_remain;
 };
 
@@ -1415,7 +1415,7 @@ extern int efi_capsule_supported(efi_guid_t guid, u32 flags,
 				 size_t size, int *reset);
 
 extern int efi_capsule_update(efi_capsule_header_t *capsule,
-			      struct page **pages);
+			      phys_addr_t *pages);
 
 #ifdef CONFIG_EFI_RUNTIME_MAP
 int efi_runtime_map_init(struct kobject *);
-- 
2.9.3
