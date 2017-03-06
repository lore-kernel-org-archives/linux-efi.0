From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 08/18] pstore: Switch pstore_mkfile to pass record
Date: Mon,  6 Mar 2017 13:55:22 -0800
Message-ID: <1488837332-71582-9-git-send-email-keescook@chromium.org>
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

Instead of the long list of arguments, just pass the new record struct.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/pstore/inode.c    | 57 +++++++++++++++++++++++++++++-----------------------
 fs/pstore/internal.h |  5 +----
 fs/pstore/platform.c |  6 +-----
 3 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 57c0646479f5..a98787bab3e6 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -302,9 +302,7 @@ bool pstore_is_mounted(void)
  * Load it up with "size" bytes of data from "buf".
  * Set the mtime & ctime to the date that this record was originally stored.
  */
-int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
-		  char *data, bool compressed, size_t size,
-		  struct timespec time, struct pstore_info *psi)
+int pstore_mkfile(struct pstore_record *record)
 {
 	struct dentry		*root = pstore_sb->s_root;
 	struct dentry		*dentry;
@@ -313,12 +311,13 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
 	char			name[PSTORE_NAMELEN];
 	struct pstore_private	*private, *pos;
 	unsigned long		flags;
+	size_t			size = record->size + record->ecc_notice_size;
 
 	spin_lock_irqsave(&allpstore_lock, flags);
 	list_for_each_entry(pos, &allpstore, list) {
-		if (pos->type == type &&
-		    pos->id == id &&
-		    pos->psi == psi) {
+		if (pos->type == record->type &&
+		    pos->id == record->id &&
+		    pos->psi == record->psi) {
 			rc = -EEXIST;
 			break;
 		}
@@ -336,48 +335,56 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
 	private = kmalloc(sizeof *private + size, GFP_KERNEL);
 	if (!private)
 		goto fail_alloc;
-	private->type = type;
-	private->id = id;
-	private->count = count;
-	private->psi = psi;
+	private->type = record->type;
+	private->id = record->id;
+	private->count = record->count;
+	private->psi = record->psi;
 
-	switch (type) {
+	switch (record->type) {
 	case PSTORE_TYPE_DMESG:
 		scnprintf(name, sizeof(name), "dmesg-%s-%lld%s",
-			  psname, id, compressed ? ".enc.z" : "");
+			  record->psi->name, record->id,
+			  record->compressed ? ".enc.z" : "");
 		break;
 	case PSTORE_TYPE_CONSOLE:
-		scnprintf(name, sizeof(name), "console-%s-%lld", psname, id);
+		scnprintf(name, sizeof(name), "console-%s-%lld",
+			  record->psi->name, record->id);
 		break;
 	case PSTORE_TYPE_FTRACE:
-		scnprintf(name, sizeof(name), "ftrace-%s-%lld", psname, id);
+		scnprintf(name, sizeof(name), "ftrace-%s-%lld",
+			  record->psi->name, record->id);
 		break;
 	case PSTORE_TYPE_MCE:
-		scnprintf(name, sizeof(name), "mce-%s-%lld", psname, id);
+		scnprintf(name, sizeof(name), "mce-%s-%lld",
+			  record->psi->name, record->id);
 		break;
 	case PSTORE_TYPE_PPC_RTAS:
-		scnprintf(name, sizeof(name), "rtas-%s-%lld", psname, id);
+		scnprintf(name, sizeof(name), "rtas-%s-%lld",
+			  record->psi->name, record->id);
 		break;
 	case PSTORE_TYPE_PPC_OF:
 		scnprintf(name, sizeof(name), "powerpc-ofw-%s-%lld",
-			  psname, id);
+			  record->psi->name, record->id);
 		break;
 	case PSTORE_TYPE_PPC_COMMON:
 		scnprintf(name, sizeof(name), "powerpc-common-%s-%lld",
-			  psname, id);
+			  record->psi->name, record->id);
 		break;
 	case PSTORE_TYPE_PMSG:
-		scnprintf(name, sizeof(name), "pmsg-%s-%lld", psname, id);
+		scnprintf(name, sizeof(name), "pmsg-%s-%lld",
+			  record->psi->name, record->id);
 		break;
 	case PSTORE_TYPE_PPC_OPAL:
-		sprintf(name, "powerpc-opal-%s-%lld", psname, id);
+		scnprintf(name, sizeof(name), "powerpc-opal-%s-%lld",
+			  record->psi->name, record->id);
 		break;
 	case PSTORE_TYPE_UNKNOWN:
-		scnprintf(name, sizeof(name), "unknown-%s-%lld", psname, id);
+		scnprintf(name, sizeof(name), "unknown-%s-%lld",
+			  record->psi->name, record->id);
 		break;
 	default:
 		scnprintf(name, sizeof(name), "type%d-%s-%lld",
-			  type, psname, id);
+			  record->type, record->psi->name, record->id);
 		break;
 	}
 
@@ -387,13 +394,13 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id, int count,
 	if (!dentry)
 		goto fail_lockedalloc;
 
-	memcpy(private->data, data, size);
+	memcpy(private->data, record->buf, size);
 	inode->i_size = private->size = size;
 
 	inode->i_private = private;
 
-	if (time.tv_sec)
-		inode->i_mtime = inode->i_ctime = time;
+	if (record->time.tv_sec)
+		inode->i_mtime = inode->i_ctime = record->time;
 
 	d_add(dentry, inode);
 
diff --git a/fs/pstore/internal.h b/fs/pstore/internal.h
index da416e6591c9..af1df5a36d86 100644
--- a/fs/pstore/internal.h
+++ b/fs/pstore/internal.h
@@ -25,10 +25,7 @@ extern struct pstore_info *psinfo;
 
 extern void	pstore_set_kmsg_bytes(int);
 extern void	pstore_get_records(int);
-extern int	pstore_mkfile(enum pstore_type_id, char *psname, u64 id,
-			      int count, char *data, bool compressed,
-			      size_t size, struct timespec time,
-			      struct pstore_info *psi);
+extern int	pstore_mkfile(struct pstore_record *record);
 extern bool	pstore_is_mounted(void);
 
 #endif
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 0503380704de..168e03fd5e58 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -814,11 +814,7 @@ void pstore_get_records(int quiet)
 				 record.psi)) > 0) {
 
 		decompress_record(&record);
-		rc = pstore_mkfile(record.type, psi->name, record.id,
-				   record.count, record.buf,
-				   record.compressed,
-				   record.size + record.ecc_notice_size,
-				   record.time, record.psi);
+		rc = pstore_mkfile(&record);
 
 		/* Free buffer other than big oops */
 		if (record.buf != big_oops_buf)
-- 
2.7.4
