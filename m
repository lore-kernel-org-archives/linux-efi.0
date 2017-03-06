From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 11/18] pstore: Always allocate buffer for decompression
Date: Mon,  6 Mar 2017 13:55:25 -0800
Message-ID: <1488837332-71582-12-git-send-email-keescook@chromium.org>
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

Currently, pstore_mkfile() performs a memcpy() of the record contents,
so it can live anywhere. However, this is needlessly wasteful. In
preparation of pstore_mkfile() keeping the record contents, always
allocate a buffer for the contents.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/pstore/platform.c | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 879658b4c679..c0d401e732e6 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -768,6 +768,7 @@ EXPORT_SYMBOL_GPL(pstore_unregister);
 static void decompress_record(struct pstore_record *record)
 {
 	int unzipped_len;
+	char *decompressed;
 
 	/* Only PSTORE_TYPE_DMESG support compression. */
 	if (!record->compressed || record->type != PSTORE_TYPE_DMESG) {
@@ -783,17 +784,29 @@ static void decompress_record(struct pstore_record *record)
 
 	unzipped_len = pstore_decompress(record->buf, big_oops_buf,
 					 record->size, big_oops_buf_sz);
-	if (unzipped_len > 0) {
-		if (record->ecc_notice_size)
-			memcpy(big_oops_buf + unzipped_len,
-			       record->buf + record->size,
-			       record->ecc_notice_size);
-		kfree(record->buf);
-		record->buf = big_oops_buf;
-		record->size = unzipped_len;
-		record->compressed = false;
-	} else
+	if (unzipped_len <= 0) {
 		pr_err("decompression failed: %d\n", unzipped_len);
+		return;
+	}
+
+	/* Build new buffer for decompressed contents. */
+	decompressed = kmalloc(unzipped_len + record->ecc_notice_size,
+			       GFP_KERNEL);
+	if (!decompressed) {
+		pr_err("decompression ran out of memory\n");
+		return;
+	}
+	memcpy(decompressed, big_oops_buf, unzipped_len);
+
+	/* Append ECC notice to decompressed buffer. */
+	memcpy(decompressed + unzipped_len, record->buf + record->size,
+	       record->ecc_notice_size);
+
+	/* Swap out compresed contents with decompressed contents. */
+	kfree(record->buf);
+	record->buf = decompressed;
+	record->size = unzipped_len;
+	record->compressed = false;
 }
 
 /*
@@ -819,13 +832,10 @@ void pstore_get_records(int quiet)
 		decompress_record(&record);
 		rc = pstore_mkfile(&record);
 
-		/* Free buffer other than big oops */
-		if (record.buf != big_oops_buf)
-			kfree(record.buf);
-
 		if (rc && (rc != -EEXIST || !quiet))
 			failed++;
 
+		kfree(record.buf);
 		memset(&record, 0, sizeof(record));
 		record.psi = psi;
 	}
-- 
2.7.4
