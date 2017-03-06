From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 13/18] pstore: Allocate records on heap instead of stack
Date: Mon,  6 Mar 2017 13:55:27 -0800
Message-ID: <1488837332-71582-14-git-send-email-keescook@chromium.org>
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

In preparation for handling records off to pstore_mkfile(), allocate the
record instead of reusing stack. This still always frees the record,
though, since pstore_mkfile() isn't yet keeping it.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/pstore/platform.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index d897e2f11b6a..072326625629 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -818,8 +818,7 @@ static void decompress_record(struct pstore_record *record)
 void pstore_get_records(int quiet)
 {
 	struct pstore_info *psi = psinfo;
-	struct pstore_record	record = { .psi = psi, };
-	int			failed = 0, rc;
+	int failed = 0;
 
 	if (!psi)
 		return;
@@ -833,19 +832,34 @@ void pstore_get_records(int quiet)
 	 * may reallocate record.buf. On success, pstore_mkfile() will keep
 	 * the record.buf, so free it only on failure.
 	 */
-	while ((record.size = psi->read(&record)) > 0) {
-		decompress_record(&record);
-		rc = pstore_mkfile(&record);
+	for (;;) {
+		struct pstore_record *record;
+		int rc;
+
+		record = kzalloc(sizeof(*record), GFP_KERNEL);
+		if (!record) {
+			pr_err("out of memory creating record\n");
+			break;
+		}
+		record->psi = psi;
+
+		record->size = psi->read(record);
+
+		/* No more records left in backend? */
+		if (record->size <= 0)
+			break;
+
+		decompress_record(record);
+		rc = pstore_mkfile(record);
 		if (rc) {
 			/* pstore_mkfile() did not take buf, so free it. */
-			kfree(record.buf);
+			kfree(record->buf);
 			if (rc != -EEXIST || !quiet)
 				failed++;
 		}
 
 		/* Reset for next record. */
-		memset(&record, 0, sizeof(record));
-		record.psi = psi;
+		kfree(record);
 	}
 	if (psi->close)
 		psi->close(psi);
-- 
2.7.4
