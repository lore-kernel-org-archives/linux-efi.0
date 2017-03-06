From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 12/18] pstore: Pass record contents instead of copying
Date: Mon,  6 Mar 2017 13:55:26 -0800
Message-ID: <1488837332-71582-13-git-send-email-keescook@chromium.org>
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

pstore_mkfile() shouldn't have to memcpy the record contents. It can use
the existing copy instead. This adjusts the allocation lifetime management
and renames the contents variable from "data" to "buf" to assist moving to
struct pstore_record in the future.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/pstore/inode.c    | 22 +++++++++++++++-------
 fs/pstore/platform.c | 16 ++++++++++++----
 2 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index a98787bab3e6..3d1f047e4f41 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -52,7 +52,7 @@ struct pstore_private {
 	u64	id;
 	int	count;
 	ssize_t	size;
-	char	data[];
+	char    *buf;
 };
 
 struct pstore_ftrace_seq_data {
@@ -63,6 +63,14 @@ struct pstore_ftrace_seq_data {
 
 #define REC_SIZE sizeof(struct pstore_ftrace_record)
 
+static void free_pstore_private(struct pstore_private *private)
+{
+	if (!private)
+		return;
+	kfree(private->buf);
+	kfree(private);
+}
+
 static void *pstore_ftrace_seq_start(struct seq_file *s, loff_t *pos)
 {
 	struct pstore_private *ps = s->private;
@@ -105,7 +113,7 @@ static int pstore_ftrace_seq_show(struct seq_file *s, void *v)
 {
 	struct pstore_private *ps = s->private;
 	struct pstore_ftrace_seq_data *data = v;
-	struct pstore_ftrace_record *rec = (void *)(ps->data + data->off);
+	struct pstore_ftrace_record *rec = (void *)(ps->buf + data->off);
 
 	seq_printf(s, "CPU:%d ts:%llu %08lx  %08lx  %pf <- %pF\n",
 		   pstore_ftrace_decode_cpu(rec),
@@ -143,7 +151,7 @@ static ssize_t pstore_file_read(struct file *file, char __user *userbuf,
 
 	if (ps->type == PSTORE_TYPE_FTRACE)
 		return seq_read(file, userbuf, count, ppos);
-	return simple_read_from_buffer(userbuf, count, ppos, ps->data, ps->size);
+	return simple_read_from_buffer(userbuf, count, ppos, ps->buf, ps->size);
 }
 
 static int pstore_file_open(struct inode *inode, struct file *file)
@@ -221,7 +229,7 @@ static void pstore_evict_inode(struct inode *inode)
 		spin_lock_irqsave(&allpstore_lock, flags);
 		list_del(&p->list);
 		spin_unlock_irqrestore(&allpstore_lock, flags);
-		kfree(p);
+		free_pstore_private(p);
 	}
 }
 
@@ -332,7 +340,7 @@ int pstore_mkfile(struct pstore_record *record)
 		goto fail;
 	inode->i_mode = S_IFREG | 0444;
 	inode->i_fop = &pstore_file_operations;
-	private = kmalloc(sizeof *private + size, GFP_KERNEL);
+	private = kzalloc(sizeof(*private), GFP_KERNEL);
 	if (!private)
 		goto fail_alloc;
 	private->type = record->type;
@@ -394,7 +402,7 @@ int pstore_mkfile(struct pstore_record *record)
 	if (!dentry)
 		goto fail_lockedalloc;
 
-	memcpy(private->data, record->buf, size);
+	private->buf = record->buf;
 	inode->i_size = private->size = size;
 
 	inode->i_private = private;
@@ -414,7 +422,7 @@ int pstore_mkfile(struct pstore_record *record)
 
 fail_lockedalloc:
 	inode_unlock(d_inode(root));
-	kfree(private);
+	free_pstore_private(private);
 fail_alloc:
 	iput(inode);
 
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index c0d401e732e6..d897e2f11b6a 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -828,14 +828,22 @@ void pstore_get_records(int quiet)
 	if (psi->open && psi->open(psi))
 		goto out;
 
+	/*
+	 * Backend callback read() allocates record.buf. decompress_record()
+	 * may reallocate record.buf. On success, pstore_mkfile() will keep
+	 * the record.buf, so free it only on failure.
+	 */
 	while ((record.size = psi->read(&record)) > 0) {
 		decompress_record(&record);
 		rc = pstore_mkfile(&record);
+		if (rc) {
+			/* pstore_mkfile() did not take buf, so free it. */
+			kfree(record.buf);
+			if (rc != -EEXIST || !quiet)
+				failed++;
+		}
 
-		if (rc && (rc != -EEXIST || !quiet))
-			failed++;
-
-		kfree(record.buf);
+		/* Reset for next record. */
 		memset(&record, 0, sizeof(record));
 		record.psi = psi;
 	}
-- 
2.7.4
