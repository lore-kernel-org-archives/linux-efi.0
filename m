From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH v2 2/3] efi/capsule-loader: Use page addresses rather than struct page pointers
Date: Wed, 19 Apr 2017 20:33:01 +0200
Message-ID: <d9cc27fc8217d25c6d7352628a09526cb973e1c1.1492626781.git.jan.kiszka@siemens.com>
References: <cover.1492626781.git.jan.kiszka@siemens.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1492626781.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1492626781.git.jan.kiszka@siemens.com>
References: <cover.1492626781.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Shevchenko <andy.shevchenko@gmail.com>, Bryan O'Donoghue <pure.logic@nexus-software.ie>, Hock Leong Kweh <hock.leong.kweh@intel.com>, Borislav Petkov <bp@alien8.de>, Sascha Weisenberger <sascha.weisenberger@siemens.com>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

To give some leeway to code that handles non-standard capsule headers,
let's keep an array of page addresses rather than struct page pointers.

This gives special implementations of efi_capsule_setup_info() the
opportunity to mangle the payload a bit before it is presented to the
firmware, without putting any knowledge of the nature of such quirks
into the generic code.

Cc: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
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
index 6eedff45e6d7..57f85256feb2 100644
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
@@ -253,10 +253,11 @@ int efi_capsule_update(efi_capsule_header_t *capsule, struct page **pages)
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
index af54be874dd0..2cec67cc18a3 100644
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
2.12.0
