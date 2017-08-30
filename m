From: Jan Kiszka <jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 06/14] efi/capsule: Allocate whole capsule into virtual memory
Date: Wed, 30 Aug 2017 21:13:48 +0200
Message-ID: <061853f3503a7b71d174cf585068e7f728137b05.1504120436.git.jan.kiszka@siemens.com>
References: <cover.1504120436.git.jan.kiszka@siemens.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1504120436.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
In-Reply-To: <cover.1504120436.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
References: <cover.1504120436.git.jan.kiszka-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Hutchings <ben.hutchings-4yDnlxn2s6sWdaTGBSpHTA@public.gmane.org>
Cc: cip-dev-Y7OTERR3vatcpJa9FCkz6gFcV7zePqp5@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Austin Christ <austinwc-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>

commit 6862e6ad95e984991a6ceec592cf67831658f928 upstream.

According to UEFI 2.6 section 7.5.3, the capsule should be in contiguous
virtual memory and firmware may consume the capsule immediately. To
correctly implement this functionality, the kernel driver needs to vmap
the entire capsule at the time it is made available to firmware.

The virtual allocation of the capsule update has been changed from kmap,
which was only allocating the first page of the update, to vmap, and
allocates the entire data payload.

Signed-off-by: Austin Christ <austinwc-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Reviewed-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Reviewed-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v4.7
Cc: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
Cc: Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: H. Peter Anvin <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Link: http://lkml.kernel.org/r/1470912120-22831-3-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Signed-off-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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
index 61e51249ef40..1106773468b2 100644
--- a/drivers/firmware/efi/capsule.c
+++ b/drivers/firmware/efi/capsule.c
@@ -194,9 +194,9 @@ efi_capsule_update_locked(efi_capsule_header_t *capsule,
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
2.12.3
