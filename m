From: Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 3/7] pstore: Manage buffer position for async write
Date: Thu, 28 Jul 2016 00:08:27 +0900
Message-ID: <1469632111-23260-4-git-send-email-namhyung@kernel.org>
References: <1469632111-23260-1-git-send-email-namhyung@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <1469632111-23260-1-git-send-email-namhyung@kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: kvm@vger.kernel.org, qemu-devel@nongnu.org, virtualization@lists.linux-foundation.org
Cc: Tony Luck <tony.luck@intel.com>, Kees Cook <keescook@chromium.org>, Matt Fleming <matt@codeblueprint.co.uk>, Anton Vorontsov <anton@enomsg.org>, LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Colin Cross <ccross@android.com>
List-Id: linux-efi@vger.kernel.org

Some pstore backend only supports async mode, so it's possible to do
some IO at the same time.  In this case we need to manage the single
psinfo->buf not to broken by concurrent IO.

For example PSTORE_TYPE_CONSOLE IO is serialized by psinfo->buf_lock but
later IO can be issued before finishing previous request.  In this case
it overwrites psinfo->buf so the previous result might be broken.

This patch adds psinfo->bufpos field to keep track of current position
in order to use psinfo->buf as a ring buffer.  However it's just a
simple, best-effort way of doing that, and provides no 100% guarantee.
It's only effective for small concurrent IO like PSTORE_TYPE_CONSOLE
IMHO.

The new PSTORE_FLAGS_ASYNC flag enables management of buffer position.
The pstore_prepare_buf() is called before accessing the psinfo->buf and
the pstore_update_buf() is called after accessing the buf.

The pstore_get_buf() is provided for psinfo->write callback to determine
the current position of available buffer.

Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Colin Cross <ccross@android.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: linux-efi@vger.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 drivers/firmware/efi/efi-pstore.c |  2 +-
 fs/pstore/platform.c              | 48 +++++++++++++++++++++++++++++++--------
 include/linux/pstore.h            |  4 ++++
 3 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index 4daa5acd9117..ae0ffe259e07 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -259,7 +259,7 @@ static int efi_pstore_write(enum pstore_type_id type,
 
 	efivar_entry_set_safe(efi_name, vendor, PSTORE_EFI_ATTRIBUTES,
 			      !pstore_cannot_block_path(reason),
-			      size, psi->buf);
+			      size, pstore_get_buf(psi));
 
 	if (reason == KMSG_DUMP_OOPS)
 		efivar_run_worker();
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 76dd604a0f2c..26e2808cf554 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -150,6 +150,27 @@ bool pstore_cannot_block_path(enum kmsg_dump_reason reason)
 }
 EXPORT_SYMBOL_GPL(pstore_cannot_block_path);
 
+static void *pstore_prepare_buf(struct pstore_info *psi, size_t len)
+{
+	if (psi->bufpos + len > psi->bufsize ||
+	    (psi->flags & PSTORE_FLAGS_ASYNC) == 0)
+		psi->bufpos = 0;
+
+	return psi->buf + psi->bufpos;
+}
+
+static void pstore_update_buf(struct pstore_info *psi, size_t len)
+{
+	if (psi->flags & PSTORE_FLAGS_ASYNC)
+		psi->bufpos += len;
+}
+
+void *pstore_get_buf(struct pstore_info *psi)
+{
+	return psi->buf + psi->bufpos;
+}
+EXPORT_SYMBOL_GPL(pstore_get_buf);
+
 #ifdef CONFIG_PSTORE_ZLIB_COMPRESS
 /* Derived from logfs_compress() */
 static int compress_zlib(const void *in, void *out, size_t inlen, size_t outlen)
@@ -455,18 +476,21 @@ static size_t copy_kmsg_to_buffer(int hsize, size_t len)
 {
 	size_t total_len;
 	size_t diff;
+	void *dst;
 
 	total_len = hsize + len;
+	dst = pstore_prepare_buf(psinfo, total_len);
 
 	if (total_len > psinfo->bufsize) {
 		diff = total_len - psinfo->bufsize + hsize;
-		memcpy(psinfo->buf, big_oops_buf, hsize);
-		memcpy(psinfo->buf + hsize, big_oops_buf + diff,
+		memcpy(dst, big_oops_buf, hsize);
+		memcpy(dst + hsize, big_oops_buf + diff,
 					psinfo->bufsize - hsize);
 		total_len = psinfo->bufsize;
 	} else
-		memcpy(psinfo->buf, big_oops_buf, total_len);
+		memcpy(dst, big_oops_buf, total_len);
 
+	pstore_update_buf(psinfo, total_len);
 	return total_len;
 }
 
@@ -500,7 +524,7 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 	}
 	oopscount++;
 	while (total < kmsg_bytes) {
-		char *dst;
+		char *dst, *buf;
 		unsigned long size;
 		int hsize;
 		int zipped_len = -1;
@@ -514,6 +538,7 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 		} else {
 			dst = psinfo->buf;
 			size = psinfo->bufsize;
+			psinfo->bufpos = 0;
 		}
 
 		hsize = sprintf(dst, "%s#%d Part%u\n", why, oopscount, part);
@@ -524,8 +549,9 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 			break;
 
 		if (big_oops_buf && is_locked) {
-			zipped_len = pstore_compress(dst, psinfo->buf,
-						hsize + len, psinfo->bufsize);
+			buf = pstore_prepare_buf(psinfo, hsize + len);
+			zipped_len = pstore_compress(dst, buf, hsize + len,
+						psinfo->bufsize - psinfo->bufpos);
 
 			if (zipped_len > 0) {
 				compressed = true;
@@ -543,6 +569,7 @@ static void pstore_dump(struct kmsg_dumper *dumper,
 			pstore_new_entry = 1;
 
 		total += total_len;
+		pstore_update_buf(psinfo, total_len);
 		part++;
 	}
 	if (is_locked)
@@ -573,6 +600,7 @@ static void pstore_console_write(struct console *con, const char *s, unsigned c)
 
 	while (s < e) {
 		unsigned long flags;
+		void *dst;
 		u64 id;
 
 		if (c > psinfo->bufsize)
@@ -584,8 +612,10 @@ static void pstore_console_write(struct console *con, const char *s, unsigned c)
 		} else {
 			spin_lock_irqsave(&psinfo->buf_lock, flags);
 		}
-		memcpy(psinfo->buf, s, c);
+		dst = pstore_prepare_buf(psinfo, c);
+		memcpy(dst, s, c);
 		psinfo->write(PSTORE_TYPE_CONSOLE, 0, &id, 0, 0, 0, c, psinfo);
+		pstore_update_buf(psinfo, c);
 		spin_unlock_irqrestore(&psinfo->buf_lock, flags);
 		s += c;
 		c = e - s;
@@ -619,8 +649,8 @@ static int pstore_write_compat(enum pstore_type_id type,
 			       bool compressed, size_t size,
 			       struct pstore_info *psi)
 {
-	return psi->write_buf(type, reason, id, part, psinfo->buf, compressed,
-			     size, psi);
+	return psi->write_buf(type, reason, id, part, pstore_get_buf(psinfo),
+			      compressed, size, psi);
 }
 
 /*
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index 9790904de6d2..14f524177b1f 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -52,6 +52,7 @@ struct pstore_info {
 	spinlock_t	buf_lock;	/* serialize access to 'buf' */
 	char		*buf;
 	size_t		bufsize;
+	size_t		bufpos;
 	struct mutex	read_mutex;	/* serialize open/read/close */
 	int		flags;
 	int		(*open)(struct pstore_info *psi);
@@ -79,8 +80,11 @@ struct pstore_info {
 #define PSTORE_FLAGS_FTRACE	(1 << 2)
 #define PSTORE_FLAGS_PMSG	(1 << 3)
 
+#define PSTORE_FLAGS_ASYNC      (1 << 30)
+
 extern int pstore_register(struct pstore_info *);
 extern void pstore_unregister(struct pstore_info *);
 extern bool pstore_cannot_block_path(enum kmsg_dump_reason reason);
+extern void *pstore_get_buf(struct pstore_info *);
 
 #endif /*_LINUX_PSTORE_H*/
-- 
2.8.0
