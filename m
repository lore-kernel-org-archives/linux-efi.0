From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [PATCH v2 10/16] PM / hibernate: Generate and verify signature of hibernate snapshot
Date: Tue, 11 Aug 2015 14:16:30 +0800
Message-ID: <1439273796-25359-11-git-send-email-jlee@suse.com>
References: <1439273796-25359-1-git-send-email-jlee@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1439273796-25359-1-git-send-email-jlee@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

This is the heart of generating and verifying the signature of
snapshot image of hibernate.

When creating hibernation image, HMAC-SHA1 calculates hash result
of all data pages that are copied to image. The signature is stored
in the header of snapshot, and verified by resuming code when it's
writing snapshot image to memory space.

When the signature verification failed, the hibernate code will stop
to recover system to image kernel and system will boots as normal.

Reviewed-by: Jiri Kosina <jkosina@suse.com>
Tested-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 kernel/power/power.h    |   5 +
 kernel/power/snapshot.c | 254 +++++++++++++++++++++++++++++++++++++++++++++---
 kernel/power/swap.c     |   4 +
 kernel/power/user.c     |   4 +
 4 files changed, 252 insertions(+), 15 deletions(-)

diff --git a/kernel/power/power.h b/kernel/power/power.h
index 7d8f310..ccc1e72 100644
--- a/kernel/power/power.h
+++ b/kernel/power/power.h
@@ -143,6 +143,11 @@ extern int snapshot_read_next(struct snapshot_handle *handle);
 extern int snapshot_write_next(struct snapshot_handle *handle);
 extern void snapshot_write_finalize(struct snapshot_handle *handle);
 extern int snapshot_image_loaded(struct snapshot_handle *handle);
+#ifdef CONFIG_HIBERNATE_VERIFICATION
+extern int snapshot_image_verify(void);
+#else
+static inline int snapshot_image_verify(void) { return 0; }
+#endif
 
 /* If unset, the snapshot device cannot be open. */
 extern atomic_t snapshot_device_available;
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 5235dd4..b8c7e2e 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -36,6 +36,8 @@
 #include <asm/tlbflush.h>
 #include <asm/io.h>
 
+#include <crypto/hash.h>
+
 #include "power.h"
 
 static int swsusp_page_is_free(struct page *);
@@ -1265,7 +1267,214 @@ static inline void copy_data_page(unsigned long dst_pfn, unsigned long src_pfn)
 }
 #endif /* CONFIG_HIGHMEM */
 
-static void
+/* Total number of image pages */
+static unsigned int nr_copy_pages;
+
+/*
+ * Signature of snapshot
+ */
+static u8 signature[HIBERNATION_DIGEST_SIZE];
+
+/* Buffer point array for collecting address of page buffers */
+void **h_buf;
+
+#ifdef CONFIG_HIBERNATE_VERIFICATION
+static int
+__copy_data_pages(struct memory_bitmap *copy_bm, struct memory_bitmap *orig_bm)
+{
+	unsigned long pfn, dst_pfn;
+	struct page *d_page;
+	void *hash_buffer = NULL;
+	struct crypto_shash *tfm = NULL;
+	struct shash_desc *desc = NULL;
+	u8 *key = NULL, *digest = NULL;
+	size_t digest_size, desc_size;
+	int key_err = 0, ret = 0;
+
+	key_err = get_hibernation_key(&key);
+	if (key_err)
+		goto copy_pages;
+
+	tfm = crypto_alloc_shash(HIBERNATION_HMAC, 0, 0);
+	if (IS_ERR(tfm)) {
+		pr_err("PM: Allocate HMAC failed: %ld\n", PTR_ERR(tfm));
+		return PTR_ERR(tfm);
+	}
+
+	ret = crypto_shash_setkey(tfm, key, HIBERNATION_DIGEST_SIZE);
+	if (ret) {
+		pr_err("PM: Set HMAC key failed\n");
+		goto error_setkey;
+	}
+
+	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
+	digest_size = crypto_shash_digestsize(tfm);
+	digest = kzalloc(digest_size + desc_size, GFP_KERNEL);
+	if (!digest) {
+		pr_err("PM: Allocate digest failed\n");
+		ret = -ENOMEM;
+		goto error_digest;
+	}
+
+	desc = (void *) digest + digest_size;
+	desc->tfm = tfm;
+	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+	ret = crypto_shash_init(desc);
+	if (ret < 0)
+		goto error_shash;
+
+copy_pages:
+	memory_bm_position_reset(orig_bm);
+	memory_bm_position_reset(copy_bm);
+	for (;;) {
+		pfn = memory_bm_next_pfn(orig_bm);
+		if (unlikely(pfn == BM_END_OF_MAP))
+			break;
+		dst_pfn = memory_bm_next_pfn(copy_bm);
+		copy_data_page(dst_pfn, pfn);
+
+		/* Generate digest */
+		d_page = pfn_to_page(dst_pfn);
+		if (PageHighMem(d_page)) {
+			void *kaddr = kmap_atomic(d_page);
+
+			copy_page(buffer, kaddr);
+			kunmap_atomic(kaddr);
+			hash_buffer = buffer;
+		} else {
+			hash_buffer = page_address(d_page);
+		}
+
+		if (key_err)
+			continue;
+
+		ret = crypto_shash_update(desc, hash_buffer, PAGE_SIZE);
+		if (ret)
+			goto error_shash;
+	}
+
+	if (key_err)
+		goto error_key;
+
+	ret = crypto_shash_final(desc, digest);
+	if (ret)
+		goto error_shash;
+
+	memset(signature, 0, HIBERNATION_DIGEST_SIZE);
+	memcpy(signature, digest, HIBERNATION_DIGEST_SIZE);
+
+	kfree(digest);
+	crypto_free_shash(tfm);
+
+	return 0;
+
+error_shash:
+	kfree(digest);
+error_setkey:
+error_digest:
+	crypto_free_shash(tfm);
+error_key:
+	return ret;
+}
+
+int snapshot_image_verify(void)
+{
+	struct crypto_shash *tfm;
+	struct shash_desc *desc;
+	u8 *key, *digest;
+	size_t digest_size, desc_size;
+	int ret, i;
+
+	if (!h_buf)
+		return 0;
+
+	ret = get_hibernation_key(&key);
+	if (ret)
+		goto forward_ret;
+
+	tfm = crypto_alloc_shash(HIBERNATION_HMAC, 0, 0);
+	if (IS_ERR(tfm)) {
+		pr_err("PM: Allocate HMAC failed: %ld\n", PTR_ERR(tfm));
+		return PTR_ERR(tfm);
+	}
+
+	ret = crypto_shash_setkey(tfm, key, HIBERNATION_DIGEST_SIZE);
+	if (ret) {
+		pr_err("PM: Set HMAC key failed\n");
+		goto error_setkey;
+	}
+
+	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
+	digest_size = crypto_shash_digestsize(tfm);
+	digest = kzalloc(digest_size + desc_size, GFP_KERNEL);
+	if (!digest) {
+		pr_err("PM: Allocate digest failed\n");
+		ret = -ENOMEM;
+		goto error_digest;
+	}
+	desc = (void *) digest + digest_size;
+	desc->tfm = tfm;
+	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	ret = crypto_shash_init(desc);
+	if (ret < 0)
+		goto error_shash;
+
+	for (i = 0; i < nr_copy_pages; i++) {
+		ret = crypto_shash_update(desc, *(h_buf + i), PAGE_SIZE);
+		if (ret)
+			goto error_shash;
+	}
+
+	ret = crypto_shash_final(desc, digest);
+	if (ret)
+		goto error_shash;
+
+	pr_debug("PM: Signature %*phN\n", HIBERNATION_DIGEST_SIZE, signature);
+	pr_debug("PM: Digest %*phN\n", (int) digest_size, digest);
+	if (memcmp(signature, digest, HIBERNATION_DIGEST_SIZE))
+		ret = -EKEYREJECTED;
+
+error_shash:
+	kfree(h_buf);
+	kfree(digest);
+error_setkey:
+error_digest:
+	crypto_free_shash(tfm);
+forward_ret:
+	if (ret)
+		pr_warn("PM: Signature verifying failed: %d\n", ret);
+	return ret;
+}
+
+static void alloc_h_buf(void)
+{
+	h_buf = kmalloc(sizeof(void *) * nr_copy_pages, GFP_KERNEL);
+	if (!h_buf)
+		pr_err("PM: Allocate buffer point array failed\n");
+}
+#else
+static int
+__copy_data_pages(struct memory_bitmap *copy_bm, struct memory_bitmap *orig_bm)
+{
+	unsigned long pfn;
+
+	memory_bm_position_reset(orig_bm);
+	memory_bm_position_reset(copy_bm);
+	for (;;) {
+		pfn = memory_bm_next_pfn(orig_bm);
+		if (unlikely(pfn == BM_END_OF_MAP))
+			break;
+		copy_data_page(memory_bm_next_pfn(copy_bm), pfn);
+	}
+
+	return 0;
+}
+
+static inline void alloc_h_buf(void) {}
+#endif /* CONFIG_HIBERNATE_VERIFICATION */
+
+static int
 copy_data_pages(struct memory_bitmap *copy_bm, struct memory_bitmap *orig_bm)
 {
 	struct zone *zone;
@@ -1280,18 +1489,10 @@ copy_data_pages(struct memory_bitmap *copy_bm, struct memory_bitmap *orig_bm)
 			if (page_is_saveable(zone, pfn))
 				memory_bm_set_bit(orig_bm, pfn);
 	}
-	memory_bm_position_reset(orig_bm);
-	memory_bm_position_reset(copy_bm);
-	for(;;) {
-		pfn = memory_bm_next_pfn(orig_bm);
-		if (unlikely(pfn == BM_END_OF_MAP))
-			break;
-		copy_data_page(memory_bm_next_pfn(copy_bm), pfn);
-	}
+
+	return __copy_data_pages(copy_bm, orig_bm);
 }
 
-/* Total number of image pages */
-static unsigned int nr_copy_pages;
 /* Number of pages needed for saving the original pfns of the image pages */
 static unsigned int nr_meta_pages;
 /*
@@ -1837,6 +2038,7 @@ swsusp_alloc(struct memory_bitmap *orig_bm, struct memory_bitmap *copy_bm,
 asmlinkage __visible int swsusp_save(void)
 {
 	unsigned int nr_pages, nr_highmem;
+	int ret;
 
 	printk(KERN_INFO "PM: Creating hibernation image:\n");
 
@@ -1859,7 +2061,11 @@ asmlinkage __visible int swsusp_save(void)
 	 * Kill them.
 	 */
 	drain_local_pages(NULL);
-	copy_data_pages(&copy_bm, &orig_bm);
+	ret = copy_data_pages(&copy_bm, &orig_bm);
+	if (ret) {
+		pr_err("PM: Copy data pages failed\n");
+		return ret;
+	}
 
 	/*
 	 * End of critical section. From now on, we can write to memory,
@@ -1914,6 +2120,7 @@ static int init_header(struct swsusp_info *info)
 	info->pages = snapshot_get_image_size();
 	info->size = info->pages;
 	info->size <<= PAGE_SHIFT;
+	memcpy(info->signature, signature, HIBERNATION_DIGEST_SIZE);
 	return init_header_complete(info);
 }
 
@@ -2076,6 +2283,8 @@ load_header(struct swsusp_info *info)
 	if (!error) {
 		nr_copy_pages = info->image_pages;
 		nr_meta_pages = info->pages - info->image_pages - 1;
+		memset(signature, 0, HIBERNATION_DIGEST_SIZE);
+		memcpy(signature, info->signature, HIBERNATION_DIGEST_SIZE);
 	}
 	return error;
 }
@@ -2414,7 +2623,8 @@ prepare_image(struct memory_bitmap *new_bm, struct memory_bitmap *bm)
  *	set for its caller to write to.
  */
 
-static void *get_buffer(struct memory_bitmap *bm, struct chain_allocator *ca)
+static void *get_buffer(struct memory_bitmap *bm, struct chain_allocator *ca,
+		unsigned long *_pfn)
 {
 	struct pbe *pbe;
 	struct page *page;
@@ -2423,6 +2633,9 @@ static void *get_buffer(struct memory_bitmap *bm, struct chain_allocator *ca)
 	if (pfn == BM_END_OF_MAP)
 		return ERR_PTR(-EFAULT);
 
+	if (_pfn)
+		*_pfn = pfn;
+
 	page = pfn_to_page(pfn);
 	if (PageHighMem(page))
 		return get_highmem_page_buffer(page, ca);
@@ -2469,6 +2682,7 @@ static void *get_buffer(struct memory_bitmap *bm, struct chain_allocator *ca)
 int snapshot_write_next(struct snapshot_handle *handle)
 {
 	static struct chain_allocator ca;
+	unsigned long pfn;
 	int error = 0;
 
 	/* Check if we have already loaded the entire image */
@@ -2491,6 +2705,12 @@ int snapshot_write_next(struct snapshot_handle *handle)
 		if (error)
 			return error;
 
+		/* Allocate buffer point array for generating
+		 * digest to compare with signature.
+		 * h_buf will freed in snapshot_image_verify().
+		 */
+		alloc_h_buf();
+
 		error = memory_bm_create(&copy_bm, GFP_ATOMIC, PG_ANY);
 		if (error)
 			return error;
@@ -2513,20 +2733,24 @@ int snapshot_write_next(struct snapshot_handle *handle)
 			chain_init(&ca, GFP_ATOMIC, PG_SAFE);
 			memory_bm_position_reset(&orig_bm);
 			restore_pblist = NULL;
-			handle->buffer = get_buffer(&orig_bm, &ca);
+			handle->buffer = get_buffer(&orig_bm, &ca, &pfn);
 			handle->sync_read = 0;
 			if (IS_ERR(handle->buffer))
 				return PTR_ERR(handle->buffer);
+			if (h_buf)
+				*h_buf = handle->buffer;
 		}
 	} else {
 		copy_last_highmem_page();
 		/* Restore page key for data page (s390 only). */
 		page_key_write(handle->buffer);
-		handle->buffer = get_buffer(&orig_bm, &ca);
+		handle->buffer = get_buffer(&orig_bm, &ca, &pfn);
 		if (IS_ERR(handle->buffer))
 			return PTR_ERR(handle->buffer);
 		if (handle->buffer != buffer)
 			handle->sync_read = 0;
+		if (h_buf)
+			*(h_buf + (handle->cur - nr_meta_pages - 1)) = handle->buffer;
 	}
 	handle->cur++;
 	return PAGE_SIZE;
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 2f30ca9..ff2b36f 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -1085,6 +1085,8 @@ static int load_image(struct swap_map_handle *handle,
 		snapshot_write_finalize(snapshot);
 		if (!snapshot_image_loaded(snapshot))
 			ret = -ENODATA;
+		if (!ret)
+			ret = snapshot_image_verify();
 	}
 	swsusp_show_speed(start, stop, nr_to_read, "Read");
 	return ret;
@@ -1440,6 +1442,8 @@ out_finish:
 				}
 			}
 		}
+		if (!ret)
+			ret = snapshot_image_verify();
 	}
 	swsusp_show_speed(start, stop, nr_to_read, "Read");
 out_clean:
diff --git a/kernel/power/user.c b/kernel/power/user.c
index 526e891..9b891d5 100644
--- a/kernel/power/user.c
+++ b/kernel/power/user.c
@@ -268,6 +268,10 @@ static long snapshot_ioctl(struct file *filp, unsigned int cmd,
 			error = -EPERM;
 			break;
 		}
+		if (snapshot_image_verify()) {
+			error = -EPERM;
+			break;
+		}
 		error = hibernation_restore(data->platform_support);
 		break;
 
-- 
2.1.4
