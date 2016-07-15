From: Austin Christ <austinwc-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH] efi: capsule: allocate whole capsule into virtual memory
Date: Fri, 15 Jul 2016 10:41:31 -0600
Message-ID: <1468600891-15794-1-git-send-email-austinwc@codeaurora.org>
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
which was only allocating the first page of the update, to vmap and
allocates the entire data payload.

Signed-off-by: Austin Christ <austinwc-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
---
 drivers/firmware/efi/capsule-loader.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index c99c24b..c4f3c20 100644
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
 		pr_debug("%s: kmap() failed\n", __func__);
 		return -EFAULT;
 	}
 
 	ret = efi_capsule_update(cap_hdr_temp, cap_info->pages);
-	kunmap(cap_info->pages[0]);
+	vunmap(cap_hdr_temp);
 	if (ret) {
 		pr_err("%s: efi_capsule_update() failed\n", __func__);
 		return ret;
-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
