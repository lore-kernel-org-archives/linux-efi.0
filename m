From: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 5/7] efi/capsule: Prepare for loading images with security header
Date: Fri, 24 Mar 2017 18:34:18 +0100
Message-ID: <47e87c8eccc0ee5c4033ece037c0bffc32782876.1490376860.git.jan.kiszka@siemens.com>
References: <cover.1490376860.git.jan.kiszka@siemens.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1490376860.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <cover.1490376860.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
References: <cover.1490376860.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, Hock Leong Kweh <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Sascha Weisenberger <sascha.weisenberger-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The Quark security header is nicely located in front of the capsule
image, but we still need to pass the image to the update service as if
there was none. Prepare efi_capsule_update and its user for this by
defining and evaluating a EFI header displacement in the image located
in memory. For standard-conforming capsules, this displacement is 0.

Signed-off-by: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
---
 drivers/firmware/efi/capsule-loader.c | 19 +++++++++++++------
 drivers/firmware/efi/capsule.c        | 21 +++++++++++++++++----
 include/linux/efi.h                   |  1 +
 3 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index 37d3f6e..59e2694 100644
--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -26,6 +26,7 @@ struct capsule_info {
 	long		index;
 	size_t		count;
 	size_t		total_size;
+	unsigned int	efi_hdr_displacement;
 	struct page	**pages;
 	size_t		page_bytes_remain;
 };
@@ -83,6 +84,8 @@ static int efi_capsule_setup_info(struct capsule_info *cap_info,
 		return ret;
 	}
 
+	cap_info->efi_hdr_displacement = 0;
+
 	cap_info->total_size = cap_hdr->imagesize;
 	temp_page = krealloc(cap_info->pages,
 			     pages_needed * sizeof(void *),
@@ -103,16 +106,20 @@ static int efi_capsule_setup_info(struct capsule_info *cap_info,
  **/
 static ssize_t efi_capsule_submit_update(struct capsule_info *cap_info)
 {
+	efi_capsule_header_t *cap_hdr;
+	void *mapped_pages;
 	int ret;
-	void *cap_hdr_temp;
 
-	cap_hdr_temp = vmap(cap_info->pages, cap_info->index,
-			VM_MAP, PAGE_KERNEL);
-	if (!cap_hdr_temp)
+	mapped_pages = vmap(cap_info->pages, cap_info->index,
+			    VM_MAP, PAGE_KERNEL);
+	if (!mapped_pages)
 		return -ENOMEM;
 
-	ret = efi_capsule_update(cap_hdr_temp, cap_info->pages);
-	vunmap(cap_hdr_temp);
+	cap_hdr = mapped_pages + cap_info->efi_hdr_displacement;
+
+	ret = efi_capsule_update(cap_hdr, cap_info->efi_hdr_displacement,
+				 cap_info->pages);
+	vunmap(mapped_pages);
 	if (ret) {
 		pr_err("capsule update failed\n");
 		return ret;
diff --git a/drivers/firmware/efi/capsule.c b/drivers/firmware/efi/capsule.c
index 6eedff4..a60c4c4 100644
--- a/drivers/firmware/efi/capsule.c
+++ b/drivers/firmware/efi/capsule.c
@@ -184,6 +184,8 @@ efi_capsule_update_locked(efi_capsule_header_t *capsule,
 /**
  * efi_capsule_update - send a capsule to the firmware
  * @capsule: capsule to send to firmware
+ * @efi_hdr_displacement: EFI header offset on first data page (only needed for
+ * non-conforming CSH capsules)
  * @pages: an array of capsule data pages
  *
  * Build a scatter gather list with EFI capsule block descriptors to
@@ -214,9 +216,12 @@ efi_capsule_update_locked(efi_capsule_header_t *capsule,
  *
  * Return 0 on success, a converted EFI status code on failure.
  */
-int efi_capsule_update(efi_capsule_header_t *capsule, struct page **pages)
+int efi_capsule_update(efi_capsule_header_t *capsule,
+		       unsigned int efi_hdr_displacement,
+		       struct page **pages)
 {
 	u32 imagesize = capsule->imagesize;
+	u32 total_size = imagesize + efi_hdr_displacement;
 	efi_guid_t guid = capsule->guid;
 	unsigned int count, sg_count;
 	u32 flags = capsule->flags;
@@ -224,11 +229,14 @@ int efi_capsule_update(efi_capsule_header_t *capsule, struct page **pages)
 	int rv, reset_type;
 	int i, j;
 
-	rv = efi_capsule_supported(guid, flags, imagesize, &reset_type);
+	if (efi_hdr_displacement > PAGE_SIZE - sizeof(efi_capsule_header_t))
+		return -EINVAL;
+
+	rv = efi_capsule_supported(guid, flags, total_size, &reset_type);
 	if (rv)
 		return rv;
 
-	count = DIV_ROUND_UP(imagesize, PAGE_SIZE);
+	count = DIV_ROUND_UP(total_size, PAGE_SIZE);
 	sg_count = sg_pages_num(count);
 
 	sg_pages = kzalloc(sg_count * sizeof(*sg_pages), GFP_KERNEL);
@@ -255,8 +263,13 @@ int efi_capsule_update(efi_capsule_header_t *capsule, struct page **pages)
 		for (j = 0; j < SGLIST_PER_PAGE && count > 0; j++) {
 			u64 sz = min_t(u64, imagesize, PAGE_SIZE);
 
-			sglist[j].length = sz;
 			sglist[j].data = page_to_phys(*pages++);
+			if (efi_hdr_displacement > 0) {
+				sglist[j].data += efi_hdr_displacement;
+				sz -= efi_hdr_displacement;
+				efi_hdr_displacement = 0;
+			}
+			sglist[j].length = sz;
 
 			imagesize -= sz;
 			count--;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 94d34e0..d83095c6 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1403,6 +1403,7 @@ extern int efi_capsule_supported(efi_guid_t guid, u32 flags,
 				 size_t size, int *reset);
 
 extern int efi_capsule_update(efi_capsule_header_t *capsule,
+			      unsigned int efi_hdr_displacement,
 			      struct page **pages);
 
 #ifdef CONFIG_EFI_RUNTIME_MAP
-- 
2.10.2
