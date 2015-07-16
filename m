From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [RFC PATCH 11/16] PM / hibernate: Avoid including swsusp key to hibernate image
Date: Thu, 16 Jul 2015 22:25:25 +0800
Message-ID: <1437056730-15247-12-git-send-email-jlee@suse.com>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437056730-15247-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

The HMAC key should only resides in kernel memory space but not leak
to outside. To avoid including swsusp key in hibernate snapshot image,
this patch adds the checking block in the code for asking saveable
pages to make sure the key page should not marked as saveable.

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 arch/x86/power/hibernate_keys.c | 14 ++++++++++++++
 kernel/power/power.h            |  3 +++
 kernel/power/snapshot.c         |  6 ++++++
 3 files changed, 23 insertions(+)

diff --git a/arch/x86/power/hibernate_keys.c b/arch/x86/power/hibernate_keys.c
index 4a68b86..775c6d8 100644
--- a/arch/x86/power/hibernate_keys.c
+++ b/arch/x86/power/hibernate_keys.c
@@ -48,6 +48,20 @@ int get_swsusp_key(u8 **skey)
 	return swsusp_keys->skey_status;
 }
 
+bool swsusp_page_is_keys(struct page *page)
+{
+	bool ret = false;
+
+	if (!swsusp_keys || swsusp_keys->skey_status)
+		return ret;
+
+	ret = (page_to_pfn(page) == page_to_pfn(virt_to_page(swsusp_keys)));
+	if (ret)
+		pr_info("PM: Avoid snapshot the page of swsusp key.\n");
+
+	return ret;
+}
+
 static int __init init_hibernate_keys(void)
 {
 	struct swsusp_keys *keys;
diff --git a/kernel/power/power.h b/kernel/power/power.h
index 25c541e..a09b21d 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -19,6 +19,9 @@ struct swsusp_info {
 #ifdef CONFIG_HIBERNATE_VERIFICATION
 /* arch/x86/power/hibernate_keys.c */
 extern int get_swsusp_key(u8 **skey);
+extern bool swsusp_page_is_keys(struct page *page);
+#else
+static inline bool swsusp_page_is_keys(struct page *page) { return false; }
 #endif
 
 /* kernel/power/snapshot.c */
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index af60731..c2bce90 100644
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
1.8.4.5
