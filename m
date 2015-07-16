From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [RFC PATCH 12/16] PM / hibernate: Forward signature verifying result and key to image kernel
Date: Thu, 16 Jul 2015 22:25:26 +0800
Message-ID: <1437056730-15247-13-git-send-email-jlee@suse.com>
References: <1437056730-15247-1-git-send-email-jlee@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437056730-15247-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

Due to the memory space of boot kernel will be overwritten after restoring
snapshot image and switching to image kernel. There have some informations
should be forwarded from boot kernel to image kernel: the result of
signature verifying, flag of enforce verifying signature and swsusp key.
That because those informations did not include in hibernate image or
produced when restoring.

The significant reason is image kernel needs swsusp key to sign image for
next hibernate cycle, otherwise the signature generating will be failed in
next cycle. In additional, it's also useful to expose the verification
result in dmesg after recovery.

The codes in hibernate key handler allocates an empty page as the buffer
of forward information that will be included in snapshot iamge, then keeps
page frame number in image header. When restoring snapshot image to memory
space of boot kernel, snapshot codes will asking key handler to fill forward
informations to buffer page. Then restoring swsusp key data to key page,
and cleaning this page buffer for next cycle.

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 arch/x86/power/hibernate_keys.c | 63 +++++++++++++++++++++++++++++++++++++++++
 kernel/power/hibernate.c        |  1 +
 kernel/power/power.h            |  6 ++++
 kernel/power/snapshot.c         | 27 +++++++++++++++++-
 kernel/power/user.c             |  1 +
 5 files changed, 97 insertions(+), 1 deletion(-)

diff --git a/arch/x86/power/hibernate_keys.c b/arch/x86/power/hibernate_keys.c
index 775c6d8..9c3d2fe 100644
--- a/arch/x86/power/hibernate_keys.c
+++ b/arch/x86/power/hibernate_keys.c
@@ -20,6 +20,15 @@ static u64 keys_phys_addr;
 /* A page used to keep swsusp keys */
 static struct swsusp_keys *swsusp_keys;
 
+/* Forward information and keys from boot kernel to image kernel */
+struct forward_info {
+	bool            sig_enforce;
+	int             sig_verify_ret;
+	struct swsusp_keys swsusp_keys;
+};
+
+static struct forward_info *forward_buff;
+
 void __init parse_swsusp_keys(u64 phys_addr, u32 data_len)
 {
 	struct setup_data *swsusp_setup_data;
@@ -62,6 +71,55 @@ bool swsusp_page_is_keys(struct page *page)
 	return ret;
 }
 
+unsigned long get_forward_buff_pfn(void)
+{
+	if (!forward_buff)
+		return 0;
+
+	return page_to_pfn(virt_to_page(forward_buff));
+}
+
+void fill_forward_info(void *forward_buff_page, int verify_ret)
+{
+	struct forward_info *info;
+
+	if (!forward_buff_page)
+		return;
+
+	memset(forward_buff_page, 0, PAGE_SIZE);
+	info = (struct forward_info *)forward_buff_page;
+	info->sig_verify_ret = verify_ret;
+
+	if (swsusp_keys && !swsusp_keys->skey_status) {
+		info->swsusp_keys = *swsusp_keys;
+		memset(swsusp_keys, 0, PAGE_SIZE);
+	} else
+		pr_info("PM: Fill swsusp keys failed\n");
+
+	pr_info("PM: Filled sign information to forward buffer\n");
+}
+
+void restore_sig_forward_info(void)
+{
+	if (!forward_buff) {
+		pr_warn("PM: Did not allocate forward buffer\n");
+		return;
+	}
+
+	if (forward_buff->sig_verify_ret)
+		pr_warn("PM: Signature verifying failed: %d\n",
+			forward_buff->sig_verify_ret);
+
+	if (swsusp_keys) {
+		memset(swsusp_keys, 0, PAGE_SIZE);
+		*swsusp_keys = forward_buff->swsusp_keys;
+		pr_info("PM: Restored swsusp keys\n");
+	}
+
+	/* clean forward information buffer for next round */
+	memset(forward_buff, 0, PAGE_SIZE);
+}
+
 static int __init init_hibernate_keys(void)
 {
 	struct swsusp_keys *keys;
@@ -76,6 +134,11 @@ static int __init init_hibernate_keys(void)
 	swsusp_keys = (struct swsusp_keys *)get_zeroed_page(GFP_KERNEL);
 	if (swsusp_keys) {
 		*swsusp_keys = *keys;
+		forward_buff = (struct forward_info *)get_zeroed_page(GFP_KERNEL);
+		if (!forward_buff) {
+			pr_err("PM: Allocate forward buffer failed\n");
+			ret = -ENOMEM;
+		}
 	} else {
 		pr_err("PM: Allocate swsusp keys page failed\n");
 		ret = -ENOMEM;
diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 690f78f..640ca8a 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -702,6 +702,7 @@ int hibernate(void)
 		pm_restore_gfp_mask();
 	} else {
 		pr_debug("PM: Image restored successfully.\n");
+		restore_sig_forward_info();
 	}
 
  Free_bitmaps:
diff --git a/kernel/power/power.h b/kernel/power/power.h
index a09b21d..5ee0074 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -12,6 +12,7 @@ struct swsusp_info {
 	unsigned long		image_pages;
 	unsigned long		pages;
 	unsigned long		size;
+	unsigned long           forward_buff_pfn;
 	u8                      signature[SWSUSP_DIGEST_SIZE];
 } __aligned(PAGE_SIZE);
 
@@ -20,8 +21,13 @@ struct swsusp_info {
 /* arch/x86/power/hibernate_keys.c */
 extern int get_swsusp_key(u8 **skey);
 extern bool swsusp_page_is_keys(struct page *page);
+extern unsigned long get_forward_buff_pfn(void);
+extern void fill_forward_info(void *forward_buff_page, int verify_ret);
+extern void restore_sig_forward_info(void);
 #else
 static inline bool swsusp_page_is_keys(struct page *page) { return false; }
+static inline unsigned long get_forward_buff_pfn(void) { return 0; }
+static inline void restore_sig_forward_info(void) {}
 #endif
 
 /* kernel/power/snapshot.c */
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index c2bce90..a19ac11 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1281,6 +1281,14 @@ static unsigned int nr_copy_pages;
  */
 static u8 signature[SWSUSP_DIGEST_SIZE];
 
+/*
+ * Keep the pfn of forwarding information buffer from resume target.
+ * Writing swsusp keys to this buffer in snapshot image before restoring.
+ */
+unsigned long forward_buff_pfn;
+
+void *forward_buff;
+
 /* Buffer point array for collecting address of page buffers */
 void **h_buf;
 
@@ -1383,13 +1391,24 @@ error_key:
 	return ret;
 }
 
+static void snapshot_fill_sig_forward_info(int verify_ret)
+{
+	if (!forward_buff_pfn || !forward_buff) {
+		pr_err("PM: Did not find forward buffer\n");
+		return;
+	}
+
+	/* Fill swsusp keys to snapshot in memory for next round */
+	fill_forward_info(forward_buff, verify_ret);
+}
+
 int snapshot_image_verify(void)
 {
 	struct crypto_shash *tfm;
 	struct shash_desc *desc;
 	u8 *key, *digest;
 	size_t digest_size, desc_size;
-	int ret, i;
+	int i, ret = 0;
 
 	if (!h_buf)
 		return 0;
@@ -1450,6 +1469,7 @@ error_digest:
 forward_ret:
 	if (ret)
 		pr_warn("PM: Signature verifying failed: %d\n", ret);
+	snapshot_fill_sig_forward_info(ret);
 	return ret;
 }
 
@@ -2126,6 +2146,7 @@ static int init_header(struct swsusp_info *info)
 	info->pages = snapshot_get_image_size();
 	info->size = info->pages;
 	info->size <<= PAGE_SHIFT;
+	info->forward_buff_pfn = get_forward_buff_pfn();
 	memcpy(info->signature, signature, SWSUSP_DIGEST_SIZE);
 	return init_header_complete(info);
 }
@@ -2289,6 +2310,7 @@ load_header(struct swsusp_info *info)
 	if (!error) {
 		nr_copy_pages = info->image_pages;
 		nr_meta_pages = info->pages - info->image_pages - 1;
+		forward_buff_pfn = info->forward_buff_pfn;
 		memset(signature, 0, SWSUSP_DIGEST_SIZE);
 		memcpy(signature, info->signature, SWSUSP_DIGEST_SIZE);
 	}
@@ -2757,6 +2779,9 @@ int snapshot_write_next(struct snapshot_handle *handle)
 			handle->sync_read = 0;
 		if (h_buf)
 			*(h_buf + (handle->cur - nr_meta_pages - 1)) = handle->buffer;
+		/* Keep the buffer of swsusp keys in snapshot */
+		if (forward_buff_pfn && pfn == forward_buff_pfn)
+			forward_buff = handle->buffer;
 	}
 	handle->cur++;
 	return PAGE_SIZE;
diff --git a/kernel/power/user.c b/kernel/power/user.c
index 9b891d5..ffd327a 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -241,6 +241,7 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 		if (!data->frozen || data->ready)
 			break;
 		pm_restore_gfp_mask();
+		restore_sig_forward_info();
 		free_basic_memory_bitmaps();
 		data->free_bitmaps = false;
 		thaw_processes();
-- 
1.8.4.5
