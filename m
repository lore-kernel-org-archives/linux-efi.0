From: Austin Christ <austinwc-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH v2] efi: capsule: allocate whole capsule into virtual memory
Date: Thu, 28 Jul 2016 15:30:29 -0600
Message-ID: <1469741429-17606-1-git-send-email-austinwc@codeaurora.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, jbrasen-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Austin Christ <austinwc-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

According to UEFI 2.6 section 7.5.3, the capsule should be in contiguous
virtual memory and firmware may consume the capsule immediately. To
correctly implement this functionality, the kernel driver needs to vmap
the entire capsule at the time it is made available to firmware.

The virtual allocation of the capsule update has been changed from kmap,
which was only allocating the first page of the update, to vmap, and
allocates the entire data payload.

Signed-off-by: Austin Christ <austinwc-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Reviewed-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Reviewed-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
---
 drivers/firmware/efi/capsule-loader.c | 8 +++++---
 drivers/firmware/efi/capsule.c        | 6 +++---
 2 files changed, 8 insertions(+), 6 deletions(-)

Changes:
- v2:
 - update comment and fix log output

diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index c99c24b..9ae6c11 100644
--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/mutex.h>
 #include <linux/efi.h>
+#include <linux/vmalloc.h>
 
 #define NO_FURTHER_WRITE_ACTION -1
 
@@ -108,14 +109,15 @@ static ssize_t efi_capsule_submit_update(struct capsule_info *cap_info)
 	int ret;
 	void *cap_hdr_temp;
 
-	cap_hdr_temp = kmap(cap_info->pages[0]);
+	cap_hdr_temp = vmap(cap_info->pages, cap_info->index,
+			VM_MAP, PAGE_KERNEL);
 	if (!cap_hdr_temp) {
-		pr_debug("%s: kmap() failed\n", __func__);
+		pr_debug("%s: vmap() failed\n", __func__);
 		return -EFAULT;
 	}
 
 	ret = efi_capsule_update(cap_hdr_temp, cap_info->pages);
-	kunmap(cap_info->pages[0]);
+	vunmap(cap_hdr_temp);
 	if (ret) {
 		pr_err("%s: efi_capsule_update() failed\n", __func__);
 		return ret;
diff --git a/drivers/firmware/efi/capsule.c b/drivers/firmware/efi/capsule.c
index 53b9fd2..6eedff4 100644
--- a/drivers/firmware/efi/capsule.c
+++ b/drivers/firmware/efi/capsule.c
@@ -190,9 +190,9 @@ efi_capsule_update_locked(efi_capsule_header_t *capsule,
  * map the capsule described by @capsule with its data in @pages and
  * send it to the firmware via the UpdateCapsule() runtime service.
  *
- * @capsule must be a virtual mapping of the first page in @pages
- * (@pages[0]) in the kernel address space. That is, a
- * capsule_header_t that describes the entire contents of the capsule
+ * @capsule must be a virtual mapping of the complete capsule update in the
+ * kernel address space, as the capsule can be consumed immediately.
+ * A capsule_header_t that describes the entire contents of the capsule
  * must be at the start of the first data page.
  *
  * Even though this function will validate that the firmware supports
-- 
Qualcomm Datacenter Technologies as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
