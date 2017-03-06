From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 14/18] pstore: Do not duplicate record metadata
Date: Mon,  6 Mar 2017 13:55:28 -0800
Message-ID: <1488837332-71582-15-git-send-email-keescook@chromium.org>
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

This switches the inode-private data from carrying duplicate metadata to
keeping the record passed in during pstore_mkfile().

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/pstore/inode.c    | 57 ++++++++++++++++++++++++++--------------------------
 fs/pstore/platform.c |  6 ++----
 2 files changed, 30 insertions(+), 33 deletions(-)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 3d1f047e4f41..0ea281b457fa 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -47,12 +47,8 @@ static LIST_HEAD(allpstore);
 
 struct pstore_private {
 	struct list_head list;
-	struct pstore_info *psi;
-	enum pstore_type_id type;
-	u64	id;
-	int	count;
-	ssize_t	size;
-	char    *buf;
+	struct pstore_record *record;
+	size_t total_size;
 };
 
 struct pstore_ftrace_seq_data {
@@ -67,7 +63,10 @@ static void free_pstore_private(struct pstore_private *private)
 {
 	if (!private)
 		return;
-	kfree(private->buf);
+	if (private->record) {
+		kfree(private->record->buf);
+		kfree(private->record);
+	}
 	kfree(private);
 }
 
@@ -80,9 +79,9 @@ static void *pstore_ftrace_seq_start(struct seq_file *s, loff_t *pos)
 	if (!data)
 		return NULL;
 
-	data->off = ps->size % REC_SIZE;
+	data->off = ps->total_size % REC_SIZE;
 	data->off += *pos * REC_SIZE;
-	if (data->off + REC_SIZE > ps->size) {
+	if (data->off + REC_SIZE > ps->total_size) {
 		kfree(data);
 		return NULL;
 	}
@@ -102,7 +101,7 @@ static void *pstore_ftrace_seq_next(struct seq_file *s, void *v, loff_t *pos)
 	struct pstore_ftrace_seq_data *data = v;
 
 	data->off += REC_SIZE;
-	if (data->off + REC_SIZE > ps->size)
+	if (data->off + REC_SIZE > ps->total_size)
 		return NULL;
 
 	(*pos)++;
@@ -113,7 +112,9 @@ static int pstore_ftrace_seq_show(struct seq_file *s, void *v)
 {
 	struct pstore_private *ps = s->private;
 	struct pstore_ftrace_seq_data *data = v;
-	struct pstore_ftrace_record *rec = (void *)(ps->buf + data->off);
+	struct pstore_ftrace_record *rec;
+
+	rec = (struct pstore_ftrace_record *)(ps->record->buf + data->off);
 
 	seq_printf(s, "CPU:%d ts:%llu %08lx  %08lx  %pf <- %pF\n",
 		   pstore_ftrace_decode_cpu(rec),
@@ -133,7 +134,7 @@ static const struct seq_operations pstore_ftrace_seq_ops = {
 
 static int pstore_check_syslog_permissions(struct pstore_private *ps)
 {
-	switch (ps->type) {
+	switch (ps->record->type) {
 	case PSTORE_TYPE_DMESG:
 	case PSTORE_TYPE_CONSOLE:
 		return check_syslog_permissions(SYSLOG_ACTION_READ_ALL,
@@ -149,9 +150,10 @@ static ssize_t pstore_file_read(struct file *file, char __user *userbuf,
 	struct seq_file *sf = file->private_data;
 	struct pstore_private *ps = sf->private;
 
-	if (ps->type == PSTORE_TYPE_FTRACE)
+	if (ps->record->type == PSTORE_TYPE_FTRACE)
 		return seq_read(file, userbuf, count, ppos);
-	return simple_read_from_buffer(userbuf, count, ppos, ps->buf, ps->size);
+	return simple_read_from_buffer(userbuf, count, ppos,
+				       ps->record->buf, ps->total_size);
 }
 
 static int pstore_file_open(struct inode *inode, struct file *file)
@@ -165,7 +167,7 @@ static int pstore_file_open(struct inode *inode, struct file *file)
 	if (err)
 		return err;
 
-	if (ps->type == PSTORE_TYPE_FTRACE)
+	if (ps->record->type == PSTORE_TYPE_FTRACE)
 		sops = &pstore_ftrace_seq_ops;
 
 	err = seq_open(file, sops);
@@ -201,17 +203,18 @@ static const struct file_operations pstore_file_operations = {
 static int pstore_unlink(struct inode *dir, struct dentry *dentry)
 {
 	struct pstore_private *p = d_inode(dentry)->i_private;
+	struct pstore_record *record = p->record;
 	int err;
 
 	err = pstore_check_syslog_permissions(p);
 	if (err)
 		return err;
 
-	if (p->psi->erase) {
-		mutex_lock(&p->psi->read_mutex);
-		p->psi->erase(p->type, p->id, p->count,
-			      d_inode(dentry)->i_ctime, p->psi);
-		mutex_unlock(&p->psi->read_mutex);
+	if (record->psi->erase) {
+		mutex_lock(&record->psi->read_mutex);
+		record->psi->erase(record->type, record->id, record->count,
+			      d_inode(dentry)->i_ctime, record->psi);
+		mutex_unlock(&record->psi->read_mutex);
 	} else {
 		return -EPERM;
 	}
@@ -323,9 +326,9 @@ int pstore_mkfile(struct pstore_record *record)
 
 	spin_lock_irqsave(&allpstore_lock, flags);
 	list_for_each_entry(pos, &allpstore, list) {
-		if (pos->type == record->type &&
-		    pos->id == record->id &&
-		    pos->psi == record->psi) {
+		if (pos->record->type == record->type &&
+		    pos->record->id == record->id &&
+		    pos->record->psi == record->psi) {
 			rc = -EEXIST;
 			break;
 		}
@@ -343,10 +346,7 @@ int pstore_mkfile(struct pstore_record *record)
 	private = kzalloc(sizeof(*private), GFP_KERNEL);
 	if (!private)
 		goto fail_alloc;
-	private->type = record->type;
-	private->id = record->id;
-	private->count = record->count;
-	private->psi = record->psi;
+	private->record = record;
 
 	switch (record->type) {
 	case PSTORE_TYPE_DMESG:
@@ -402,8 +402,7 @@ int pstore_mkfile(struct pstore_record *record)
 	if (!dentry)
 		goto fail_lockedalloc;
 
-	private->buf = record->buf;
-	inode->i_size = private->size = size;
+	inode->i_size = private->total_size = size;
 
 	inode->i_private = private;
 
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 072326625629..aa3d6e572ede 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -852,14 +852,12 @@ void pstore_get_records(int quiet)
 		decompress_record(record);
 		rc = pstore_mkfile(record);
 		if (rc) {
-			/* pstore_mkfile() did not take buf, so free it. */
+			/* pstore_mkfile() did not take record, so free it. */
 			kfree(record->buf);
+			kfree(record);
 			if (rc != -EEXIST || !quiet)
 				failed++;
 		}
-
-		/* Reset for next record. */
-		kfree(record);
 	}
 	if (psi->close)
 		psi->close(psi);
-- 
2.7.4
