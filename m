From: Jan Kiszka <jan.kiszka@siemens.com>
Subject: [PATCH 1/2] efi/capsule: Prepare for loading images with security header
Date: Wed, 15 Feb 2017 19:14:39 +0100
Message-ID: <c9105c31c480e4b1bd59e4c1ab392b6b44cf72b0.1487182480.git.jan.kiszka@siemens.com>
References: <cover.1487182480.git.jan.kiszka@siemens.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1487182480.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1487182480.git.jan.kiszka@siemens.com>
References: <cover.1487182480.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Shevchenko <andy.shevchenko@gmail.com>
List-Id: linux-efi@vger.kernel.org

The Quark security header is nicely located in front of the capsule
image, but we still need to pass the image to the update service as if
there was none. Prepare efi_capsule_update for this by taking an image
offset that encodes the start of the EFI standard capsule.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 drivers/firmware/efi/capsule-loader.c |  2 +-
 drivers/firmware/efi/capsule.c        | 19 +++++++++++++++----
 include/linux/efi.h                   |  2 +-
 3 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index 9ae6c11..63ceca9 100644
--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -116,7 +116,7 @@ static ssize_t efi_capsule_submit_update(struct capsule_info *cap_info)
 		return -EFAULT;
 	}
 
-	ret = efi_capsule_update(cap_hdr_temp, cap_info->pages);
+	ret = efi_capsule_update(cap_hdr_temp, 0, cap_info->pages);
 	vunmap(cap_hdr_temp);
 	if (ret) {
 		pr_err("%s: efi_capsule_update() failed\n", __func__);
diff --git a/drivers/firmware/efi/capsule.c b/drivers/firmware/efi/capsule.c
index 6eedff4..f025ccf 100644
--- a/drivers/firmware/efi/capsule.c
+++ b/drivers/firmware/efi/capsule.c
@@ -184,6 +184,7 @@ efi_capsule_update_locked(efi_capsule_header_t *capsule,
 /**
  * efi_capsule_update - send a capsule to the firmware
  * @capsule: capsule to send to firmware
+ * @image_offs: image offset on first data page
  * @pages: an array of capsule data pages
  *
  * Build a scatter gather list with EFI capsule block descriptors to
@@ -214,9 +215,11 @@ efi_capsule_update_locked(efi_capsule_header_t *capsule,
  *
  * Return 0 on success, a converted EFI status code on failure.
  */
-int efi_capsule_update(efi_capsule_header_t *capsule, struct page **pages)
+int efi_capsule_update(efi_capsule_header_t *capsule, unsigned int image_offs,
+		       struct page **pages)
 {
 	u32 imagesize = capsule->imagesize;
+	u32 total_size = imagesize + image_offs;
 	efi_guid_t guid = capsule->guid;
 	unsigned int count, sg_count;
 	u32 flags = capsule->flags;
@@ -224,11 +227,14 @@ int efi_capsule_update(efi_capsule_header_t *capsule, struct page **pages)
 	int rv, reset_type;
 	int i, j;
 
-	rv = efi_capsule_supported(guid, flags, imagesize, &reset_type);
+	if (image_offs >= PAGE_SIZE)
+		return -EINVAL;
+
+	rv = efi_capsule_supported(guid, flags, total_size, &reset_type);
 	if (rv)
 		return rv;
 
-	count = DIV_ROUND_UP(imagesize, PAGE_SIZE);
+	count = DIV_ROUND_UP(total_size, PAGE_SIZE);
 	sg_count = sg_pages_num(count);
 
 	sg_pages = kzalloc(sg_count * sizeof(*sg_pages), GFP_KERNEL);
@@ -255,8 +261,13 @@ int efi_capsule_update(efi_capsule_header_t *capsule, struct page **pages)
 		for (j = 0; j < SGLIST_PER_PAGE && count > 0; j++) {
 			u64 sz = min_t(u64, imagesize, PAGE_SIZE);
 
-			sglist[j].length = sz;
 			sglist[j].data = page_to_phys(*pages++);
+			if (image_offs > 0) {
+				sglist[j].data += image_offs;
+				sz -= image_offs;
+				image_offs = 0;
+			}
+			sglist[j].length = sz;
 
 			imagesize -= sz;
 			count--;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 5b1af30..57e27a1 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1399,7 +1399,7 @@ extern int efi_capsule_supported(efi_guid_t guid, u32 flags,
 				 size_t size, int *reset);
 
 extern int efi_capsule_update(efi_capsule_header_t *capsule,
-			      struct page **pages);
+			      unsigned int image_offs, struct page **pages);
 
 #ifdef CONFIG_EFI_RUNTIME_MAP
 int efi_runtime_map_init(struct kobject *);
-- 
2.1.4
