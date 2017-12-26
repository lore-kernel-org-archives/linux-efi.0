From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [RFT PATCH] efi: capsule-loader: reinstate virtual capsule mapping
Date: Tue, 26 Dec 2017 13:21:42 +0000
Message-ID: <20171226132142.3254-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, Richard Ruigrok <rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Ge Song <ge.song-PT9Dzx9SjPiXmMXjJBpWqg@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Commit 82c3768b8d68 ("efi/capsule-loader: Use a cached copy of the
capsule header") refactored the capsule loading code that maps the
capsule header, to avoid having to map it several times. However,
as it turns out, the vmap() call we ended up removing did not just
map the header, but the entire capsule image, and dropping this
virtual mapping breaks capsules that are processed by the firmware
immediately (i.e., without a reboot).

Unfortunately, that change was part of a larger refactor that allowed
a quirk to be implemented for Quark, which has a non-standard memory
layout for capsules, and we have slightly painted ourselves into a
corner by allowing quirk code to mangle the capsule header and memory
layout.

So we need to fix this without breaking Quark. Fortunately, Quark does
not appear to care about the virtual mapping, and so we can simply
do a partial revert of commit 2a457fb31df6 ("efi/capsule-loader: Use
page addresses rather than struct page pointers"), and create a vmap()
mapping of the entire capsule (including header) based on the reinstated
struct page array, unless running on Quark, in which case we pass the
capsule header copy as before.

Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Cc: Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Cc: Richard Ruigrok <rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Ge Song <ge.song-PT9Dzx9SjPiXmMXjJBpWqg@public.gmane.org>

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/x86/platform/efi/quirks.c        | 13 +++++-
 drivers/firmware/efi/capsule-loader.c | 45 ++++++++++++++++----
 include/linux/efi.h                   |  4 +-
 3 files changed, 52 insertions(+), 10 deletions(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 8a99a2e96537..5b513ccffde4 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -592,7 +592,18 @@ static int qrk_capsule_setup_info(struct capsule_info *cap_info, void **pkbuff,
 	/*
 	 * Update the first page pointer to skip over the CSH header.
 	 */
-	cap_info->pages[0] += csh->headersize;
+	cap_info->phys[0] += csh->headersize;
+
+	/*
+	 * cap_info->capsule should point at a virtual mapping of the entire
+	 * capsule, starting at the capsule header. Our image has the Quark
+	 * security header prepended, so we cannot rely on the default vmap()
+	 * mapping created by the generic capsule code.
+	 * Given that the Quark firmware does not appear to care about the
+	 * virtual mapping, let's just point cap_info->capsule at our copy
+	 * of the capsule header.
+	 */
+	cap_info->capsule = &cap_info->header;
 
 	return 1;
 }
diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index 51d2874942a2..e456f4602df1 100644
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
@@ -71,6 +67,14 @@ int __efi_capsule_setup_info(struct capsule_info *cap_info)
 
 	cap_info->pages = temp_page;
 
+	temp_page = krealloc(cap_info->phys,
+			     pages_needed * sizeof(phys_addr_t *),
+			     GFP_KERNEL | __GFP_ZERO);
+	if (!temp_page)
+		return -ENOMEM;
+
+	cap_info->phys = temp_page;
+
 	return 0;
 }
 
@@ -105,9 +109,24 @@ int __weak efi_capsule_setup_info(struct capsule_info *cap_info, void *kbuff,
  **/
 static ssize_t efi_capsule_submit_update(struct capsule_info *cap_info)
 {
+	bool do_vunmap = false;
 	int ret;
 
-	ret = efi_capsule_update(&cap_info->header, cap_info->pages);
+	/*
+	 * cap_info->capsule may have been assigned already by a quirk
+	 * handler, so only overwrite it if it is NULL
+	 */
+	if (!cap_info->capsule) {
+		cap_info->capsule = vmap(cap_info->pages, cap_info->index,
+					 VM_MAP, PAGE_KERNEL);
+		if (!cap_info->capsule)
+			return -ENOMEM;
+		do_vunmap = true;
+	}
+
+	ret = efi_capsule_update(cap_info->capsule, cap_info->phys);
+	if (do_vunmap)
+		vunmap(cap_info->capsule);
 	if (ret) {
 		pr_err("capsule update failed\n");
 		return ret;
@@ -165,10 +184,12 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
 			goto failed;
 		}
 
-		cap_info->pages[cap_info->index++] = page_to_phys(page);
+		cap_info->pages[cap_info->index] = page;
+		cap_info->phys[cap_info->index] = page_to_phys(page);
 		cap_info->page_bytes_remain = PAGE_SIZE;
+		cap_info->index++;
 	} else {
-		page = phys_to_page(cap_info->pages[cap_info->index - 1]);
+		page = cap_info->pages[cap_info->index - 1];
 	}
 
 	kbuff = kmap(page);
@@ -252,6 +273,7 @@ static int efi_capsule_release(struct inode *inode, struct file *file)
 	struct capsule_info *cap_info = file->private_data;
 
 	kfree(cap_info->pages);
+	kfree(cap_info->phys);
 	kfree(file->private_data);
 	file->private_data = NULL;
 	return 0;
@@ -281,6 +303,13 @@ static int efi_capsule_open(struct inode *inode, struct file *file)
 		return -ENOMEM;
 	}
 
+	cap_info->phys = kzalloc(sizeof(void *), GFP_KERNEL);
+	if (!cap_info->phys) {
+		kfree(cap_info->pages);
+		kfree(cap_info);
+		return -ENOMEM;
+	}
+
 	file->private_data = cap_info;
 
 	return 0;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index d813f7b04da7..29fdf8029cf6 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -140,11 +140,13 @@ struct efi_boot_memmap {
 
 struct capsule_info {
 	efi_capsule_header_t	header;
+	efi_capsule_header_t	*capsule;
 	int			reset_type;
 	long			index;
 	size_t			count;
 	size_t			total_size;
-	phys_addr_t		*pages;
+	struct page		**pages;
+	phys_addr_t		*phys;
 	size_t			page_bytes_remain;
 };
 
-- 
2.11.0
