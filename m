From: Geliang Tang <geliangtang@163.com>
Subject: [PATCH] pstore: add lzo/lz4 compression support
Date: Tue, 16 Feb 2016 21:52:05 +0800
Message-ID: <2ee9bd401adc806e6202445576db3e00cf62a9f2.1455630542.git.geliangtang@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Like zlib compression in pstore, this patch added lzo and lz4
compression support so that users can have more options and better
compression ratio.

The original code treats the compressed data together with the
uncompressed ECC correction notice by using zlib decompress. The
ECC correction notice is missing in the decompression process. The
treatment also makes lzo and lz4 not working. So I treat them
separately by using pstore_decompress() to treat the compressed
data, and memcpy() to treat the uncompressed ECC correction notice.

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 drivers/firmware/efi/efi-pstore.c |   1 +
 fs/pstore/Kconfig                 |  34 +++++-
 fs/pstore/platform.c              | 217 ++++++++++++++++++++++++++++++++++++--
 fs/pstore/ram.c                   |  10 +-
 include/linux/pstore.h            |   3 +-
 5 files changed, 250 insertions(+), 15 deletions(-)

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index eac76a7..cd8c35f 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -210,6 +210,7 @@ static int efi_pstore_sysfs_entry_iter(void *data, struct efivar_entry **pos)
 static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 			       int *count, struct timespec *timespec,
 			       char **buf, bool *compressed,
+			       ssize_t *ecc_notice_size,
 			       struct pstore_info *psi)
 {
 	struct pstore_read_data data;
diff --git a/fs/pstore/Kconfig b/fs/pstore/Kconfig
index 360ae43..8777616 100644
--- a/fs/pstore/Kconfig
+++ b/fs/pstore/Kconfig
@@ -1,8 +1,6 @@
 config PSTORE
 	tristate "Persistent store support"
 	default n
-	select ZLIB_DEFLATE
-	select ZLIB_INFLATE
 	help
 	   This option enables generic access to platform level
 	   persistent storage via "pstore" filesystem that can
@@ -14,6 +12,38 @@ config PSTORE
 	   If you don't have a platform persistent store driver,
 	   say N.
 
+choice
+        prompt "Choose compression algorithm"
+        depends on PSTORE
+        default PSTORE_ZLIB_COMPRESS
+        help
+          This option chooses compression algorithm.
+
+config PSTORE_ZLIB_COMPRESS
+        bool "ZLIB"
+        depends on PSTORE
+        select ZLIB_DEFLATE
+        select ZLIB_INFLATE
+        help
+          This option enables ZLIB compression algorithm support.
+
+config PSTORE_LZO_COMPRESS
+        bool "LZO"
+        depends on PSTORE
+        select LZO_COMPRESS
+        select LZO_DECOMPRESS
+        help
+          This option enables LZO compression algorithm support.
+
+config PSTORE_LZ4_COMPRESS
+        bool "LZ4"
+        depends on PSTORE
+        select LZ4_COMPRESS
+        select LZ4_DECOMPRESS
+        help
+          This option enables LZ4 compression algorithm support.
+endchoice
+
 config PSTORE_CONSOLE
 	bool "Log kernel console messages"
 	depends on PSTORE
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 588461b..ce09f5b 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -28,7 +28,15 @@
 #include <linux/console.h>
 #include <linux/module.h>
 #include <linux/pstore.h>
+#ifdef CONFIG_PSTORE_ZLIB_COMPRESS
 #include <linux/zlib.h>
+#endif
+#ifdef CONFIG_PSTORE_LZO_COMPRESS
+#include <linux/lzo.h>
+#endif
+#ifdef CONFIG_PSTORE_LZ4_COMPRESS
+#include <linux/lz4.h>
+#endif
 #include <linux/string.h>
 #include <linux/timer.h>
 #include <linux/slab.h>
@@ -69,10 +77,23 @@ struct pstore_info *psinfo;
 static char *backend;
 
 /* Compression parameters */
+#ifdef CONFIG_PSTORE_ZLIB_COMPRESS
 #define COMPR_LEVEL 6
 #define WINDOW_BITS 12
 #define MEM_LEVEL 4
 static struct z_stream_s stream;
+#else
+static unsigned char *workspace;
+#endif
+
+struct pstore_zbackend {
+	int (*compress)(const void *in, void *out, size_t inlen, size_t outlen);
+	int (*decompress)(void *in, void *out, size_t inlen, size_t outlen);
+	void (*allocate)(void);
+	void (*free)(void);
+
+	const char *name;
+};
 
 static char *big_oops_buf;
 static size_t big_oops_buf_sz;
@@ -129,9 +150,9 @@ bool pstore_cannot_block_path(enum kmsg_dump_reason reason)
 }
 EXPORT_SYMBOL_GPL(pstore_cannot_block_path);
 
+#ifdef CONFIG_PSTORE_ZLIB_COMPRESS
 /* Derived from logfs_compress() */
-static int pstore_compress(const void *in, void *out, size_t inlen,
-							size_t outlen)
+static int compress_zlib(const void *in, void *out, size_t inlen, size_t outlen)
 {
 	int err, ret;
 
@@ -165,7 +186,7 @@ error:
 }
 
 /* Derived from logfs_uncompress */
-static int pstore_decompress(void *in, void *out, size_t inlen, size_t outlen)
+static int decompress_zlib(void *in, void *out, size_t inlen, size_t outlen)
 {
 	int err, ret;
 
@@ -194,7 +215,7 @@ error:
 	return ret;
 }
 
-static void allocate_buf_for_compression(void)
+static void allocate_zlib(void)
 {
 	size_t size;
 	size_t cmpr;
@@ -237,7 +258,7 @@ static void allocate_buf_for_compression(void)
 
 }
 
-static void free_buf_for_compression(void)
+static void free_zlib(void)
 {
 	kfree(stream.workspace);
 	stream.workspace = NULL;
@@ -245,6 +266,183 @@ static void free_buf_for_compression(void)
 	big_oops_buf = NULL;
 }
 
+static struct pstore_zbackend backend_zlib = {
+	.compress	= compress_zlib,
+	.decompress	= decompress_zlib,
+	.allocate	= allocate_zlib,
+	.free		= free_zlib,
+	.name		= "zlib",
+};
+#endif
+
+#ifdef CONFIG_PSTORE_LZO_COMPRESS
+static int compress_lzo(const void *in, void *out, size_t inlen, size_t outlen)
+{
+	int ret;
+
+	ret = lzo1x_1_compress(in, inlen, out, &outlen, workspace);
+	if (ret != LZO_E_OK) {
+		pr_err("lzo_compress error, ret = %d!\n", ret);
+		return -EIO;
+	}
+
+	return outlen;
+}
+
+static int decompress_lzo(void *in, void *out, size_t inlen, size_t outlen)
+{
+	int ret;
+
+	ret = lzo1x_decompress_safe(in, inlen, out, &outlen);
+	if (ret != LZO_E_OK) {
+		pr_err("lzo_decompress error, ret = %d!\n", ret);
+		return -EIO;
+	}
+
+	return outlen;
+}
+
+static void allocate_lzo(void)
+{
+	big_oops_buf_sz = lzo1x_worst_compress(psinfo->bufsize);
+	big_oops_buf = kmalloc(big_oops_buf_sz, GFP_KERNEL);
+	if (big_oops_buf) {
+		workspace = kmalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
+		if (!workspace) {
+			pr_err("No memory for compression workspace; skipping compression\n");
+			kfree(big_oops_buf);
+			big_oops_buf = NULL;
+		}
+	} else {
+		pr_err("No memory for uncompressed data; skipping compression\n");
+		workspace = NULL;
+	}
+}
+
+static void free_lzo(void)
+{
+	kfree(workspace);
+	kfree(big_oops_buf);
+	big_oops_buf = NULL;
+}
+
+static struct pstore_zbackend backend_lzo = {
+	.compress	= compress_lzo,
+	.decompress	= decompress_lzo,
+	.allocate	= allocate_lzo,
+	.free		= free_lzo,
+	.name		= "lzo",
+};
+#endif
+
+#ifdef CONFIG_PSTORE_LZ4_COMPRESS
+static int compress_lz4(const void *in, void *out, size_t inlen, size_t outlen)
+{
+	int ret;
+
+	ret = lz4_compress(in, inlen, out, &outlen, workspace);
+	if (ret) {
+		pr_err("lz4_compress error, ret = %d!\n", ret);
+		return -EIO;
+	}
+
+	return outlen;
+}
+
+static int decompress_lz4(void *in, void *out, size_t inlen, size_t outlen)
+{
+	int ret;
+
+	ret = lz4_decompress_unknownoutputsize(in, inlen, out, &outlen);
+	if (ret) {
+		pr_err("lz4_decompress error, ret = %d!\n", ret);
+		return -EIO;
+	}
+
+	return outlen;
+}
+
+static void allocate_lz4(void)
+{
+	big_oops_buf_sz = lz4_compressbound(psinfo->bufsize);
+	big_oops_buf = kmalloc(big_oops_buf_sz, GFP_KERNEL);
+	if (big_oops_buf) {
+		workspace = kmalloc(LZ4_MEM_COMPRESS, GFP_KERNEL);
+		if (!workspace) {
+			pr_err("No memory for compression workspace; skipping compression\n");
+			kfree(big_oops_buf);
+			big_oops_buf = NULL;
+		}
+	} else {
+		pr_err("No memory for uncompressed data; skipping compression\n");
+		workspace = NULL;
+	}
+}
+
+static void free_lz4(void)
+{
+	kfree(workspace);
+	kfree(big_oops_buf);
+	big_oops_buf = NULL;
+}
+
+static struct pstore_zbackend backend_lz4 = {
+	.compress	= compress_lz4,
+	.decompress	= decompress_lz4,
+	.allocate	= allocate_lz4,
+	.free		= free_lz4,
+	.name		= "lz4",
+};
+#endif
+
+static struct pstore_zbackend *zbackend[] = {
+#ifdef CONFIG_PSTORE_ZLIB_COMPRESS
+	&backend_zlib,
+#endif
+#ifdef CONFIG_PSTORE_LZO_COMPRESS
+	&backend_lzo,
+#endif
+#ifdef CONFIG_PSTORE_LZ4_COMPRESS
+	&backend_lz4,
+#endif
+	NULL
+};
+
+static int pstore_compress(const void *in, void *out,
+			   size_t inlen, size_t outlen)
+{
+	if (zbackend[0] && !zbackend[1])
+		return zbackend[0]->compress(in, out, inlen, outlen);
+	else
+		return -EIO;
+}
+
+static int pstore_decompress(void *in, void *out, size_t inlen, size_t outlen)
+{
+	if (zbackend[0] && !zbackend[1])
+		return zbackend[0]->decompress(in, out, inlen, outlen);
+	else
+		return -EIO;
+}
+
+static void allocate_buf_for_compression(void)
+{
+	if (zbackend[0] && !zbackend[1]) {
+		pr_info("using %s compression\n", zbackend[0]->name);
+		zbackend[0]->allocate();
+	} else {
+		pr_err("allocate compression buffer error!\n");
+	}
+}
+
+static void free_buf_for_compression(void)
+{
+	if (zbackend[0] && !zbackend[1])
+		zbackend[0]->free();
+	else
+		pr_err("free compression buffer error!\n");
+}
+
 /*
  * Called when compression fails, since the printk buffer
  * would be fetched for compression calling it again when
@@ -527,6 +725,7 @@ void pstore_get_records(int quiet)
 	int			failed = 0, rc;
 	bool			compressed;
 	int			unzipped_len = -1;
+	ssize_t			ecc_notice_size = 0;
 
 	if (!psi)
 		return;
@@ -536,7 +735,7 @@ void pstore_get_records(int quiet)
 		goto out;
 
 	while ((size = psi->read(&id, &type, &count, &time, &buf, &compressed,
-				psi)) > 0) {
+				 &ecc_notice_size, psi)) > 0) {
 		if (compressed && (type == PSTORE_TYPE_DMESG)) {
 			if (big_oops_buf)
 				unzipped_len = pstore_decompress(buf,
@@ -544,6 +743,9 @@ void pstore_get_records(int quiet)
 							big_oops_buf_sz);
 
 			if (unzipped_len > 0) {
+				if (ecc_notice_size)
+					memcpy(big_oops_buf + unzipped_len,
+					       buf + size, ecc_notice_size);
 				kfree(buf);
 				buf = big_oops_buf;
 				size = unzipped_len;
@@ -555,7 +757,8 @@ void pstore_get_records(int quiet)
 			}
 		}
 		rc = pstore_mkfile(type, psi->name, id, count, buf,
-				  compressed, (size_t)size, time, psi);
+				   compressed, size + ecc_notice_size,
+				   time, psi);
 		if (unzipped_len < 0) {
 			/* Free buffer other than big oops */
 			kfree(buf);
diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 319c3a6..11ec024 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -181,10 +181,10 @@ static bool prz_ok(struct persistent_ram_zone *prz)
 static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
 				   int *count, struct timespec *time,
 				   char **buf, bool *compressed,
+				   ssize_t *ecc_notice_size,
 				   struct pstore_info *psi)
 {
 	ssize_t size;
-	ssize_t ecc_notice_size;
 	struct ramoops_context *cxt = psi->data;
 	struct persistent_ram_zone *prz = NULL;
 	int header_length = 0;
@@ -229,16 +229,16 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
 	size = persistent_ram_old_size(prz) - header_length;
 
 	/* ECC correction notice */
-	ecc_notice_size = persistent_ram_ecc_string(prz, NULL, 0);
+	*ecc_notice_size = persistent_ram_ecc_string(prz, NULL, 0);
 
-	*buf = kmalloc(size + ecc_notice_size + 1, GFP_KERNEL);
+	*buf = kmalloc(size + *ecc_notice_size + 1, GFP_KERNEL);
 	if (*buf == NULL)
 		return -ENOMEM;
 
 	memcpy(*buf, (char *)persistent_ram_old(prz) + header_length, size);
-	persistent_ram_ecc_string(prz, *buf + size, ecc_notice_size + 1);
+	persistent_ram_ecc_string(prz, *buf + size, *ecc_notice_size + 1);
 
-	return size + ecc_notice_size;
+	return size;
 }
 
 static size_t ramoops_write_kmsg_hdr(struct persistent_ram_zone *prz,
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index 831479f..899e95e 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -58,7 +58,8 @@ struct pstore_info {
 	int		(*close)(struct pstore_info *psi);
 	ssize_t		(*read)(u64 *id, enum pstore_type_id *type,
 			int *count, struct timespec *time, char **buf,
-			bool *compressed, struct pstore_info *psi);
+			bool *compressed, ssize_t *ecc_notice_size,
+			struct pstore_info *psi);
 	int		(*write)(enum pstore_type_id type,
 			enum kmsg_dump_reason reason, u64 *id,
 			unsigned int part, int count, bool compressed,
-- 
2.5.0
