From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 15/18] pstore: Replace arguments for erase() API
Date: Mon,  6 Mar 2017 13:55:29 -0800
Message-ID: <1488837332-71582-16-git-send-email-keescook@chromium.org>
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

This removes the argument list for the erase() callback and replaces it
with a pointer to the backend record details to be removed.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/acpi/apei/erst.c          |  8 +++-----
 drivers/firmware/efi/efi-pstore.c | 26 +++++++++++---------------
 fs/pstore/inode.c                 | 12 +++++-------
 fs/pstore/ram.c                   | 15 +++++++--------
 include/linux/pstore.h            | 16 +++++-----------
 5 files changed, 31 insertions(+), 46 deletions(-)

diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index 440588d189e7..7207e5fc9d3d 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -927,8 +927,7 @@ static int erst_open_pstore(struct pstore_info *psi);
 static int erst_close_pstore(struct pstore_info *psi);
 static ssize_t erst_reader(struct pstore_record *record);
 static int erst_writer(struct pstore_record *record);
-static int erst_clearer(enum pstore_type_id type, u64 id, int count,
-			struct timespec time, struct pstore_info *psi);
+static int erst_clearer(struct pstore_record *record);
 
 static struct pstore_info erst_info = {
 	.owner		= THIS_MODULE,
@@ -1100,10 +1099,9 @@ static int erst_writer(struct pstore_record *record)
 	return ret;
 }
 
-static int erst_clearer(enum pstore_type_id type, u64 id, int count,
-			struct timespec time, struct pstore_info *psi)
+static int erst_clearer(struct pstore_record *record)
 {
-	return erst_clear(id);
+	return erst_clear(record->id);
 }
 
 static int __init erst_init(void)
diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index f81e3ec6f1c0..93d8cdbe7ef4 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -266,10 +266,7 @@ static int efi_pstore_write(struct pstore_record *record)
 };
 
 struct pstore_erase_data {
-	u64 id;
-	enum pstore_type_id type;
-	int count;
-	struct timespec time;
+	struct pstore_record *record;
 	efi_char16_t *name;
 };
 
@@ -295,8 +292,9 @@ static int efi_pstore_erase_func(struct efivar_entry *entry, void *data)
 		 * Check if an old format, which doesn't support
 		 * holding multiple logs, remains.
 		 */
-		sprintf(name_old, "dump-type%u-%u-%lu", ed->type,
-			(unsigned int)ed->id, ed->time.tv_sec);
+		snprintf(name_old, sizeof(name_old), "dump-type%u-%u-%lu",
+			ed->record->type, (unsigned int)ed->record->id,
+			ed->record->time.tv_sec);
 
 		for (i = 0; i < DUMP_NAME_LEN; i++)
 			efi_name_old[i] = name_old[i];
@@ -321,8 +319,7 @@ static int efi_pstore_erase_func(struct efivar_entry *entry, void *data)
 	return 1;
 }
 
-static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
-			    struct timespec time, struct pstore_info *psi)
+static int efi_pstore_erase(struct pstore_record *record)
 {
 	struct pstore_erase_data edata;
 	struct efivar_entry *entry = NULL;
@@ -331,17 +328,16 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
 	int found, i;
 	unsigned int part;
 
-	do_div(id, 1000);
-	part = do_div(id, 100);
-	sprintf(name, "dump-type%u-%u-%d-%lu", type, part, count, time.tv_sec);
+	do_div(record->id, 1000);
+	part = do_div(record->id, 100);
+	snprintf(name, sizeof(name), "dump-type%u-%u-%d-%lu",
+		 record->type, record->part, record->count,
+		 record->time.tv_sec);
 
 	for (i = 0; i < DUMP_NAME_LEN; i++)
 		efi_name[i] = name[i];
 
-	edata.id = part;
-	edata.type = type;
-	edata.count = count;
-	edata.time = time;
+	edata.record = record;
 	edata.name = efi_name;
 
 	if (efivar_entry_iter_begin())
diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 0ea281b457fa..06504b69575b 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -210,14 +210,12 @@ static int pstore_unlink(struct inode *dir, struct dentry *dentry)
 	if (err)
 		return err;
 
-	if (record->psi->erase) {
-		mutex_lock(&record->psi->read_mutex);
-		record->psi->erase(record->type, record->id, record->count,
-			      d_inode(dentry)->i_ctime, record->psi);
-		mutex_unlock(&record->psi->read_mutex);
-	} else {
+	if (!record->psi->erase)
 		return -EPERM;
-	}
+
+	mutex_lock(&record->psi->read_mutex);
+	record->psi->erase(record);
+	mutex_unlock(&record->psi->read_mutex);
 
 	return simple_unlink(dir, dentry);
 }
diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index ca6e2a814e37..a18575fe32e9 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -469,25 +469,24 @@ static int notrace ramoops_pstore_write_buf_user(enum pstore_type_id type,
 	return -EINVAL;
 }
 
-static int ramoops_pstore_erase(enum pstore_type_id type, u64 id, int count,
-				struct timespec time, struct pstore_info *psi)
+static int ramoops_pstore_erase(struct pstore_record *record)
 {
-	struct ramoops_context *cxt = psi->data;
+	struct ramoops_context *cxt = record->psi->data;
 	struct persistent_ram_zone *prz;
 
-	switch (type) {
+	switch (record->type) {
 	case PSTORE_TYPE_DMESG:
-		if (id >= cxt->max_dump_cnt)
+		if (record->id >= cxt->max_dump_cnt)
 			return -EINVAL;
-		prz = cxt->dprzs[id];
+		prz = cxt->dprzs[record->id];
 		break;
 	case PSTORE_TYPE_CONSOLE:
 		prz = cxt->cprz;
 		break;
 	case PSTORE_TYPE_FTRACE:
-		if (id >= cxt->max_ftrace_cnt)
+		if (record->id >= cxt->max_ftrace_cnt)
 			return -EINVAL;
-		prz = cxt->fprzs[id];
+		prz = cxt->fprzs[record->id];
 		break;
 	case PSTORE_TYPE_PMSG:
 		prz = cxt->mprz;
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index c672de41e9b5..a4b2c21a512e 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -177,15 +177,11 @@ struct pstore_record {
  *
  * @erase:
  *	Delete a record from backend storage.  Different backends
- *	identify records differently, so all possible methods of
- *	identification are included to help the backend locate the
- *	record to remove.
+ *	identify records differently, so entire original record is
+ *	passed back to assist in identification of what the backend
+ *	should remove from storage.
  *
- *	@type:	in: pstore record type to write
- *	@id:	in: per-type unique identifier for the record
- *	@count:	in: Oops count
- *	@time:	in: timestamp for the record
- *	@psi:	in: pointer to the struct pstore_info for the backend
+ *	@record:	pointer to record metadata.
  *
  *	Returns 0 on success, and non-zero on error.
  *
@@ -215,9 +211,7 @@ struct pstore_info {
 			enum kmsg_dump_reason reason, u64 *id,
 			unsigned int part, const char __user *buf,
 			bool compressed, size_t size, struct pstore_info *psi);
-	int		(*erase)(enum pstore_type_id type, u64 id,
-			int count, struct timespec time,
-			struct pstore_info *psi);
+	int		(*erase)(struct pstore_record *record);
 };
 
 /* Supported frontends */
-- 
2.7.4
