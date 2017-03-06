From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 07/18] pstore: Move record decompression to function
Date: Mon,  6 Mar 2017 13:55:21 -0800
Message-ID: <1488837332-71582-8-git-send-email-keescook@chromium.org>
References: <1488837332-71582-1-git-send-email-keescook@chromium.org>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <1488837332-71582-1-git-send-email-keescook@chromium.org>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-doc@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Pan Xinhui <xinhui.pan@linux.vnet.ibm.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Paul Mackerras <paulus@samba.org>, Anton Vorontsov <anton@enomsg.org>, linux-acpi@vger.kernel.org, Nathan Fontenot <nfont@linux.vnet.ibm.com>, Len Brown <lenb@kernel.org>, Kees Cook <keescook@chromium.org>, Nobuhiro Iwamatsu <nobuhiro.iwamatsu.kw@hitachi.com>, Geliang Tang <geliangtang@163.com>, Tony Luck <tony.luck@intel.com>, Daniel Axtens <dja@axtens.net>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Colin Cross <ccross@android.com>, linuxppc-dev@lists.ozlabs.org
List-Id: linux-efi@vger.kernel.org

This moves the record decompression logic out to a separate function
to avoid the deep indentation.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/pstore/platform.c | 67 +++++++++++++++++++++++++++++-----------------------
 1 file changed, 37 insertions(+), 30 deletions(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 3fa1575a6e36..0503380704de 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -757,6 +757,37 @@ void pstore_unregister(struct pstore_info *psi)
 }
 EXPORT_SYMBOL_GPL(pstore_unregister);
 
+static void decompress_record(struct pstore_record *record)
+{
+	int unzipped_len;
+
+	/* Only PSTORE_TYPE_DMESG support compression. */
+	if (!record->compressed || record->type != PSTORE_TYPE_DMESG) {
+		pr_warn("ignored compressed record type %d\n", record->type);
+		return;
+	}
+
+	/* No compression method has created the common buffer. */
+	if (!big_oops_buf) {
+		pr_warn("no decompression buffer allocated\n");
+		return;
+	}
+
+	unzipped_len = pstore_decompress(record->buf, big_oops_buf,
+					 record->size, big_oops_buf_sz);
+	if (unzipped_len > 0) {
+		if (record->ecc_notice_size)
+			memcpy(big_oops_buf + unzipped_len,
+			       record->buf + record->size,
+			       record->ecc_notice_size);
+		kfree(record->buf);
+		record->buf = big_oops_buf;
+		record->size = unzipped_len;
+		record->compressed = false;
+	} else
+		pr_err("decompression failed: %d\n", unzipped_len);
+}
+
 /*
  * Read all the records from the persistent store. Create
  * files in our filesystem.  Don't warn about -EEXIST errors
@@ -768,7 +799,6 @@ void pstore_get_records(int quiet)
 	struct pstore_info *psi = psinfo;
 	struct pstore_record	record = { .psi = psi, };
 	int			failed = 0, rc;
-	int			unzipped_len = -1;
 
 	if (!psi)
 		return;
@@ -782,41 +812,18 @@ void pstore_get_records(int quiet)
 				 &record.buf, &record.compressed,
 				 &record.ecc_notice_size,
 				 record.psi)) > 0) {
-		if (record.compressed &&
-		    record.type == PSTORE_TYPE_DMESG) {
-			if (big_oops_buf)
-				unzipped_len = pstore_decompress(
-							record.buf,
-							big_oops_buf,
-							record.size,
-							big_oops_buf_sz);
-
-			if (unzipped_len > 0) {
-				if (record.ecc_notice_size)
-					memcpy(big_oops_buf + unzipped_len,
-					       record.buf + recorrecord.size,
-					       record.ecc_notice_size);
-				kfree(record.buf);
-				record.buf = big_oops_buf;
-				record.size = unzipped_len;
-				record.compressed = false;
-			} else {
-				pr_err("decompression failed;returned %d\n",
-				       unzipped_len);
-				record.compressed = true;
-			}
-		}
+
+		decompress_record(&record);
 		rc = pstore_mkfile(record.type, psi->name, record.id,
 				   record.count, record.buf,
 				   record.compressed,
 				   record.size + record.ecc_notice_size,
 				   record.time, record.psi);
-		if (unzipped_len < 0) {
-			/* Free buffer other than big oops */
+
+		/* Free buffer other than big oops */
+		if (record.buf != big_oops_buf)
 			kfree(record.buf);
-			record.buf = NULL;
-		} else
-			unzipped_len = -1;
+
 		if (rc && (rc != -EEXIST || !quiet))
 			failed++;
 
-- 
2.7.4
