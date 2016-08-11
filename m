From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 2/2] efi/capsule: Allocate whole capsule into virtual memory
Date: Thu, 11 Aug 2016 11:42:00 +0100
Message-ID: <1470912120-22831-3-git-send-email-matt@codeblueprint.co.uk>
References: <1470912120-22831-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1470912120-22831-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Austin Christ <austinwc@codeaurora.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Bryan O'Donoghue <pure.logic@nexus-software.ie>, Kweh Hock Leong <hock.leong.kweh@intel.com>, "Lee, Chun-Yi" <jlee@suse.com>, stable@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Austin Christ <austinwc@codeaurora.org>

According to UEFI 2.6 section 7.5.3, the capsule should be in contiguous
virtual memory and firmware may consume the capsule immediately. To
correctly implement this functionality, the kernel driver needs to vmap
the entire capsule at the time it is made available to firmware.

The virtual allocation of the capsule update has been changed from kmap,
which was only allocating the first page of the update, to vmap, and
allocates the entire data payload.

Signed-off-by: Austin Christ <austinwc@codeaurora.org>
Reviewed-by: Matt Fleming <matt@codeblueprint.co.uk>
Reviewed-by: Lee, Chun-Yi <jlee@suse.com>
Cc: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Cc: Kweh Hock Leong <hock.leong.kweh@intel.com>
Cc: <stable@vger.kernel.org> # v4.7
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 drivers/firmware/efi/capsule-loader.c | 8 +++++---
 drivers/firmware/efi/capsule.c        | 6 +++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index c99c24bc79b0..9ae6c116c474 100644
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
index 53b9fd2293ee..6eedff45e6d7 100644
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
2.7.3
