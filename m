From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.7 011/143] efi/capsule: Allocate whole capsule into virtual memory
Date: Mon,  5 Sep 2016 18:43:07 +0200
Message-ID: <20160905164431.094954825@linuxfoundation.org>
References: <20160905164430.593075551@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160905164430.593075551@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, Austin Christ <austinwc@codeaurora.org>, Matt Fleming <matt@codeblueprint.co.uk>, "Lee, Chun-Yi" <jlee@suse.com>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, Bryan ODonoghue <pure.logic@nexus-software.ie>, Denys Vlasenko <dvlasenk@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Kweh Hock Leong <hock.leong.kweh@intel.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
List-Id: linux-efi@vger.kernel.org

4.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Austin Christ <austinwc@codeaurora.org>

commit 6862e6ad95e984991a6ceec592cf67831658f928 upstream.

According to UEFI 2.6 section 7.5.3, the capsule should be in contiguous
virtual memory and firmware may consume the capsule immediately. To
correctly implement this functionality, the kernel driver needs to vmap
the entire capsule at the time it is made available to firmware.

The virtual allocation of the capsule update has been changed from kmap,
which was only allocating the first page of the update, to vmap, and
allocates the entire data payload.

Signed-off-by: Austin Christ <austinwc@codeaurora.org>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
Reviewed-by: Matt Fleming <matt@codeblueprint.co.uk>
Reviewed-by: Lee, Chun-Yi <jlee@suse.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Cc: Denys Vlasenko <dvlasenk@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Kweh Hock Leong <hock.leong.kweh@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org
Link: http://lkml.kernel.org/r/1470912120-22831-3-git-send-email-matt@codeblueprint.co.uk
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/firmware/efi/capsule-loader.c |    8 +++++---
 drivers/firmware/efi/capsule.c        |    6 +++---
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/mutex.h>
 #include <linux/efi.h>
+#include <linux/vmalloc.h>
 
 #define NO_FURTHER_WRITE_ACTION -1
 
@@ -108,14 +109,15 @@ static ssize_t efi_capsule_submit_update
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
--- a/drivers/firmware/efi/capsule.c
+++ b/drivers/firmware/efi/capsule.c
@@ -190,9 +190,9 @@ efi_capsule_update_locked(efi_capsule_he
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
