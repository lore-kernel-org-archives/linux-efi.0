From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [PATCH v2 11/16] PM / hibernate: Avoid including hibernation key to hibernate image
Date: Tue, 11 Aug 2015 14:16:31 +0800
Message-ID: <1439273796-25359-12-git-send-email-jlee@suse.com>
References: <1439273796-25359-1-git-send-email-jlee@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1439273796-25359-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

The HMAC key should only resides in kernel memory space but not leak
to outside. To avoid including hibernation key in hibernate snapshot
image, this patch adds the checking block in the code for asking saveable
pages to make sure the key page should not marked as saveable.

Reviewed-by: Jiri Kosina <jkosina@suse.com>
Tested-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 arch/x86/power/hibernate_keys.c | 15 +++++++++++++++
 kernel/power/power.h            |  3 +++
 kernel/power/snapshot.c         |  6 ++++++
 3 files changed, 24 insertions(+)

diff --git a/arch/x86/power/hibernate_keys.c b/arch/x86/power/hibernate_keys.c
index 357dc0e..f44823e 100644
--- a/arch/x86/power/hibernate_keys.c
+++ b/arch/x86/power/hibernate_keys.c
@@ -47,6 +47,21 @@ int get_hibernation_key(u8 **hkey)
 	return hibernation_keys->hkey_status;
 }
 
+
+bool swsusp_page_is_keys(struct page *page)
+{
+	bool ret = false;
+
+	if (!hibernation_keys || hibernation_keys->hkey_status)
+		return ret;
+
+	ret = (page_to_pfn(page) == page_to_pfn(virt_to_page(hibernation_keys)));
+	if (ret)
+		pr_info("PM: Avoid snapshot the page of hibernation key.\n");
+
+	return ret;
+}
+
 static int __init init_hibernation_keys(void)
 {
 	struct hibernation_keys *keys;
diff --git a/kernel/power/power.h b/kernel/power/power.h
index ccc1e72..6d1d406 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -19,6 +19,9 @@ struct swsusp_info {
 #ifdef CONFIG_HIBERNATE_VERIFICATION
 /* arch/x86/power/hibernate_keys.c */
 extern int get_hibernation_key(u8 **hkey);
+extern bool swsusp_page_is_keys(struct page *page);
+#else
+static inline bool swsusp_page_is_keys(struct page *page) { return false; }
 #endif
 
 /* kernel/power/snapshot.c */
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index b8c7e2e..5522028 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1093,6 +1093,9 @@ static struct page *saveable_highmem_page(struct zone *zone, unsigned long pfn)
 
 	BUG_ON(!PageHighMem(page));
 
+	if (swsusp_page_is_keys(page))
+		return NULL;
+
 	if (swsusp_page_is_forbidden(page) ||  swsusp_page_is_free(page) ||
 	    PageReserved(page))
 		return NULL;
@@ -1155,6 +1158,9 @@ static struct page *saveable_page(struct zone *zone, unsigned long pfn)
 
 	BUG_ON(PageHighMem(page));
 
+	if (swsusp_page_is_keys(page))
+		return NULL;
+
 	if (swsusp_page_is_forbidden(page) || swsusp_page_is_free(page))
 		return NULL;
 
-- 
2.1.4
