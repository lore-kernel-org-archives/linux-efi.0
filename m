From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 09/18] pstore: Replace arguments for read() API
Date: Mon,  6 Mar 2017 13:55:23 -0800
Message-ID: <1488837332-71582-10-git-send-email-keescook@chromium.org>
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

The argument list for the pstore_read() interface is unwieldy. This changes
passes the new struct pstore_record instead. The erst backend was already
doing something similar internally.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/powerpc/kernel/nvram_64.c    |  61 +++++++++++-----------
 drivers/acpi/apei/erst.c          |  38 ++++++--------
 drivers/firmware/efi/efi-pstore.c | 104 ++++++++++++++++----------------------
 fs/pstore/platform.c              |   7 +--
 fs/pstore/ram.c                   |  53 ++++++++++---------
 include/linux/pstore.h            |  20 +++-----
 6 files changed, 124 insertions(+), 159 deletions(-)

diff --git a/arch/powerpc/kernel/nvram_64.c b/arch/powerpc/kernel/nvram_64.c
index d5e2b8309939..7f192001d09a 100644
--- a/arch/powerpc/kernel/nvram_64.c
+++ b/arch/powerpc/kernel/nvram_64.c
@@ -442,10 +442,7 @@ static int nvram_pstore_write(enum pstore_type_id type,
  * Returns the length of the data we read from each partition.
  * Returns 0 if we've been called before.
  */
-static ssize_t nvram_pstore_read(u64 *id, enum pstore_type_id *type,
-				int *count, struct timespec *time, char **buf,
-				bool *compressed, ssize_t *ecc_notice_size,
-				struct pstore_info *psi)
+static ssize_t nvram_pstore_read(struct pstore_record *record)
 {
 	struct oops_log_info *oops_hdr;
 	unsigned int err_type, id_no, size = 0;
@@ -459,40 +456,40 @@ static ssize_t nvram_pstore_read(u64 *id, enum pstore_type_id *type,
 	switch (nvram_type_ids[read_type]) {
 	case PSTORE_TYPE_DMESG:
 		part = &oops_log_partition;
-		*type = PSTORE_TYPE_DMESG;
+		record->type = PSTORE_TYPE_DMESG;
 		break;
 	case PSTORE_TYPE_PPC_COMMON:
 		sig = NVRAM_SIG_SYS;
 		part = &common_partition;
-		*type = PSTORE_TYPE_PPC_COMMON;
-		*id = PSTORE_TYPE_PPC_COMMON;
-		time->tv_sec = 0;
-		time->tv_nsec = 0;
+		record->type = PSTORE_TYPE_PPC_COMMON;
+		record->id = PSTORE_TYPE_PPC_COMMON;
+		record->time.tv_sec = 0;
+		record->time.tv_nsec = 0;
 		break;
 #ifdef CONFIG_PPC_PSERIES
 	case PSTORE_TYPE_PPC_RTAS:
 		part = &rtas_log_partition;
-		*type = PSTORE_TYPE_PPC_RTAS;
-		time->tv_sec = last_rtas_event;
-		time->tv_nsec = 0;
+		record->type = PSTORE_TYPE_PPC_RTAS;
+		record->time.tv_sec = last_rtas_event;
+		record->time.tv_nsec = 0;
 		break;
 	case PSTORE_TYPE_PPC_OF:
 		sig = NVRAM_SIG_OF;
 		part = &of_config_partition;
-		*type = PSTORE_TYPE_PPC_OF;
-		*id = PSTORE_TYPE_PPC_OF;
-		time->tv_sec = 0;
-		time->tv_nsec = 0;
+		record->type = PSTORE_TYPE_PPC_OF;
+		record->id = PSTORE_TYPE_PPC_OF;
+		record->time.tv_sec = 0;
+		record->time.tv_nsec = 0;
 		break;
 #endif
 #ifdef CONFIG_PPC_POWERNV
 	case PSTORE_TYPE_PPC_OPAL:
 		sig = NVRAM_SIG_FW;
 		part = &skiboot_partition;
-		*type = PSTORE_TYPE_PPC_OPAL;
-		*id = PSTORE_TYPE_PPC_OPAL;
-		time->tv_sec = 0;
-		time->tv_nsec = 0;
+		record->type = PSTORE_TYPE_PPC_OPAL;
+		record->id = PSTORE_TYPE_PPC_OPAL;
+		record->time.tv_sec = 0;
+		record->time.tv_nsec = 0;
 		break;
 #endif
 	default:
@@ -520,10 +517,10 @@ static ssize_t nvram_pstore_read(u64 *id, enum pstore_type_id *type,
 		return 0;
 	}
 
-	*count = 0;
+	record->count = 0;
 
 	if (part->os_partition)
-		*id = id_no;
+		record->id = id_no;
 
 	if (nvram_type_ids[read_type] == PSTORE_TYPE_DMESG) {
 		size_t length, hdr_size;
@@ -533,28 +530,28 @@ static ssize_t nvram_pstore_read(u64 *id, enum pstore_type_id *type,
 			/* Old format oops header had 2-byte record size */
 			hdr_size = sizeof(u16);
 			length = be16_to_cpu(oops_hdr->version);
-			time->tv_sec = 0;
-			time->tv_nsec = 0;
+			record->time.tv_sec = 0;
+			record->time.tv_nsec = 0;
 		} else {
 			hdr_size = sizeof(*oops_hdr);
 			length = be16_to_cpu(oops_hdr->report_length);
-			time->tv_sec = be64_to_cpu(oops_hdr->timestamp);
-			time->tv_nsec = 0;
+			record->time.tv_sec = be64_to_cpu(oops_hdr->timestamp);
+			record->time.tv_nsec = 0;
 		}
-		*buf = kmemdup(buff + hdr_size, length, GFP_KERNEL);
+		record->buf = kmemdup(buff + hdr_size, length, GFP_KERNEL);
 		kfree(buff);
-		if (*buf == NULL)
+		if (record->buf == NULL)
 			return -ENOMEM;
 
-		*ecc_notice_size = 0;
+		record->ecc_notice_size = 0;
 		if (err_type == ERR_TYPE_KERNEL_PANIC_GZ)
-			*compressed = true;
+			record->compressed = true;
 		else
-			*compressed = false;
+			record->compressed = false;
 		return length;
 	}
 
-	*buf = buff;
+	record->buf = buff;
 	return part->size;
 }
 
diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index ec4f507b524f..bbefb7522f80 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -925,10 +925,7 @@ static int erst_check_table(struct acpi_table_erst *erst_tab)
 
 static int erst_open_pstore(struct pstore_info *psi);
 static int erst_close_pstore(struct pstore_info *psi);
-static ssize_t erst_reader(u64 *id, enum pstore_type_id *type, int *count,
-			   struct timespec *time, char **buf,
-			   bool *compressed, ssize_t *ecc_notice_size,
-			   struct pstore_info *psi);
+static ssize_t erst_reader(struct pstore_record *record);
 static int erst_writer(enum pstore_type_id type, enum kmsg_dump_reason reason,
 		       u64 *id, unsigned int part, int count, bool compressed,
 		       size_t size, struct pstore_info *psi);
@@ -986,10 +983,7 @@ static int erst_close_pstore(struct pstore_info *psi)
 	return 0;
 }
 
-static ssize_t erst_reader(u64 *id, enum pstore_type_id *type, int *count,
-			   struct timespec *time, char **buf,
-			   bool *compressed, ssize_t *ecc_notice_size,
-			   struct pstore_info *psi)
+static ssize_t erst_reader(struct pstore_record *record)
 {
 	int rc;
 	ssize_t len = 0;
@@ -1027,33 +1021,33 @@ static ssize_t erst_reader(u64 *id, enum pstore_type_id *type, int *count,
 	if (uuid_le_cmp(rcd->hdr.creator_id, CPER_CREATOR_PSTORE) != 0)
 		goto skip;
 
-	*buf = kmalloc(len, GFP_KERNEL);
-	if (*buf == NULL) {
+	record->buf = kmalloc(len, GFP_KERNEL);
+	if (record->buf == NULL) {
 		rc = -ENOMEM;
 		goto out;
 	}
-	memcpy(*buf, rcd->data, len - sizeof(*rcd));
-	*id = record_id;
-	*compressed = false;
-	*ecc_notice_size = 0;
+	memcpy(record->buf, rcd->data, len - sizeof(*rcd));
+	record->id = record_id;
+	record->compressed = false;
+	record->ecc_notice_size = 0;
 	if (uuid_le_cmp(rcd->sec_hdr.section_type,
 			CPER_SECTION_TYPE_DMESG_Z) == 0) {
-		*type = PSTORE_TYPE_DMESG;
-		*compressed = true;
+		record->type = PSTORE_TYPE_DMESG;
+		record->compressed = true;
 	} else if (uuid_le_cmp(rcd->sec_hdr.section_type,
 			CPER_SECTION_TYPE_DMESG) == 0)
-		*type = PSTORE_TYPE_DMESG;
+		record->type = PSTORE_TYPE_DMESG;
 	else if (uuid_le_cmp(rcd->sec_hdr.section_type,
 			     CPER_SECTION_TYPE_MCE) == 0)
-		*type = PSTORE_TYPE_MCE;
+		record->type = PSTORE_TYPE_MCE;
 	else
-		*type = PSTORE_TYPE_UNKNOWN;
+		record->type = PSTORE_TYPE_UNKNOWN;
 
 	if (rcd->hdr.validation_bits & CPER_VALID_TIMESTAMP)
-		time->tv_sec = rcd->hdr.timestamp;
+		record->time.tv_sec = rcd->hdr.timestamp;
 	else
-		time->tv_sec = 0;
-	time->tv_nsec = 0;
+		record->time.tv_sec = 0;
+	record->time.tv_nsec = 0;
 
 out:
 	kfree(rcd);
diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index f402ba2eed46..bda24129e85b 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -28,26 +28,16 @@ static int efi_pstore_close(struct pstore_info *psi)
 	return 0;
 }
 
-struct pstore_read_data {
-	u64 *id;
-	enum pstore_type_id *type;
-	int *count;
-	struct timespec *timespec;
-	bool *compressed;
-	ssize_t *ecc_notice_size;
-	char **buf;
-};
-
 static inline u64 generic_id(unsigned long timestamp,
 			     unsigned int part, int count)
 {
 	return ((u64) timestamp * 100 + part) * 1000 + count;
 }
 
-static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
+static int efi_pstore_read_func(struct efivar_entry *entry,
+				struct pstore_record *record)
 {
 	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
-	struct pstore_read_data *cb_data = data;
 	char name[DUMP_NAME_LEN], data_type;
 	int i;
 	int cnt;
@@ -61,37 +51,37 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 		name[i] = entry->var.VariableName[i];
 
 	if (sscanf(name, "dump-type%u-%u-%d-%lu-%c",
-		   cb_data->type, &part, &cnt, &time, &data_type) == 5) {
-		*cb_data->id = generic_id(time, part, cnt);
-		*cb_data->count = cnt;
-		cb_data->timespec->tv_sec = time;
-		cb_data->timespec->tv_nsec = 0;
+		   &record->type, &part, &cnt, &time, &data_type) == 5) {
+		record->id = generic_id(time, part, cnt);
+		record->count = cnt;
+		record->time.tv_sec = time;
+		record->time.tv_nsec = 0;
 		if (data_type == 'C')
-			*cb_data->compressed = true;
+			record->compressed = true;
 		else
-			*cb_data->compressed = false;
-		*cb_data->ecc_notice_size = 0;
+			record->compressed = false;
+		record->ecc_notice_size = 0;
 	} else if (sscanf(name, "dump-type%u-%u-%d-%lu",
-		   cb_data->type, &part, &cnt, &time) == 4) {
-		*cb_data->id = generic_id(time, part, cnt);
-		*cb_data->count = cnt;
-		cb_data->timespec->tv_sec = time;
-		cb_data->timespec->tv_nsec = 0;
-		*cb_data->compressed = false;
-		*cb_data->ecc_notice_size = 0;
+		   &record->type, &part, &cnt, &time) == 4) {
+		record->id = generic_id(time, part, cnt);
+		record->count = cnt;
+		record->time.tv_sec = time;
+		record->time.tv_nsec = 0;
+		record->compressed = false;
+		record->ecc_notice_size = 0;
 	} else if (sscanf(name, "dump-type%u-%u-%lu",
-			  cb_data->type, &part, &time) == 3) {
+			  &record->type, &part, &time) == 3) {
 		/*
 		 * Check if an old format,
 		 * which doesn't support holding
 		 * multiple logs, remains.
 		 */
-		*cb_data->id = generic_id(time, part, 0);
-		*cb_data->count = 0;
-		cb_data->timespec->tv_sec = time;
-		cb_data->timespec->tv_nsec = 0;
-		*cb_data->compressed = false;
-		*cb_data->ecc_notice_size = 0;
+		record->id = generic_id(time, part, 0);
+		record->count = 0;
+		record->time.tv_sec = time;
+		record->time.tv_nsec = 0;
+		record->compressed = false;
+		record->ecc_notice_size = 0;
 	} else
 		return 0;
 
@@ -99,7 +89,7 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 	__efivar_entry_get(entry, &entry->var.Attributes,
 			   &entry->var.DataSize, entry->var.Data);
 	size = entry->var.DataSize;
-	memcpy(*cb_data->buf, entry->var.Data,
+	memcpy(record->buf, entry->var.Data,
 	       (size_t)min_t(unsigned long, EFIVARS_DATA_SIZE_MAX, size));
 
 	return size;
@@ -164,7 +154,7 @@ static int efi_pstore_scan_sysfs_exit(struct efivar_entry *pos,
 /**
  * efi_pstore_sysfs_entry_iter
  *
- * @data: function-specific data to pass to callback
+ * @record: pstore record to pass to callback
  * @pos: entry to begin iterating from
  *
  * You MUST call efivar_enter_iter_begin() before this function, and
@@ -175,7 +165,8 @@ static int efi_pstore_scan_sysfs_exit(struct efivar_entry *pos,
  * the next entry of the last one passed to efi_pstore_read_func().
  * To begin iterating from the beginning of the list @pos must be %NULL.
  */
-static int efi_pstore_sysfs_entry_iter(void *data, struct efivar_entry **pos)
+static int efi_pstore_sysfs_entry_iter(struct pstore_record *record,
+				       struct efivar_entry **pos)
 {
 	struct efivar_entry *entry, *n;
 	struct list_head *head = &efivar_sysfs_list;
@@ -186,7 +177,7 @@ static int efi_pstore_sysfs_entry_iter(void *data, struct efivar_entry **pos)
 		list_for_each_entry_safe(entry, n, head, list) {
 			efi_pstore_scan_sysfs_enter(entry, n, head);
 
-			size = efi_pstore_read_func(entry, data);
+			size = efi_pstore_read_func(entry, record);
 			ret = efi_pstore_scan_sysfs_exit(entry, n, head,
 							 size < 0);
 			if (ret)
@@ -201,7 +192,7 @@ static int efi_pstore_sysfs_entry_iter(void *data, struct efivar_entry **pos)
 	list_for_each_entry_safe_from((*pos), n, head, list) {
 		efi_pstore_scan_sysfs_enter((*pos), n, head);
 
-		size = efi_pstore_read_func((*pos), data);
+		size = efi_pstore_read_func((*pos), record);
 		ret = efi_pstore_scan_sysfs_exit((*pos), n, head, size < 0);
 		if (ret)
 			return ret;
@@ -225,36 +216,27 @@ static int efi_pstore_sysfs_entry_iter(void *data, struct efivar_entry **pos)
  * size < 0: Failed to get data of entry logging via efi_pstore_write(),
  *           and pstore will stop reading entry.
  */
-static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
-			       int *count, struct timespec *timespec,
-			       char **buf, bool *compressed,
-			       ssize_t *ecc_notice_size,
-			       struct pstore_info *psi)
+static ssize_t efi_pstore_read(struct pstore_record *record)
 {
-	struct pstore_read_data data;
+	struct efivar_entry *entry = (struct efivar_entry *)record->psi->data;
 	ssize_t size;
 
-	data.id = id;
-	data.type = type;
-	data.count = count;
-	data.timespec = timespec;
-	data.compressed = compressed;
-	data.ecc_notice_size = ecc_notice_size;
-	data.buf = buf;
-
-	*data.buf = kzalloc(EFIVARS_DATA_SIZE_MAX, GFP_KERNEL);
-	if (!*data.buf)
+	record->buf = kzalloc(EFIVARS_DATA_SIZE_MAX, GFP_KERNEL);
+	if (!record->buf)
 		return -ENOMEM;
 
 	if (efivar_entry_iter_begin()) {
-		kfree(*data.buf);
-		return -EINTR;
+		size = -EINTR;
+		goto out;
 	}
-	size = efi_pstore_sysfs_entry_iter(&data,
-					   (struct efivar_entry **)&psi->data);
+	size = efi_pstore_sysfs_entry_iter(record, &entry);
 	efivar_entry_iter_end();
-	if (size <= 0)
-		kfree(*data.buf);
+
+out:
+	if (size <= 0) {
+		kfree(record->buf);
+		record->buf = NULL;
+	}
 	return size;
 }
 
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 168e03fd5e58..47968c2f2d0d 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -807,12 +807,7 @@ void pstore_get_records(int quiet)
 	if (psi->open && psi->open(psi))
 		goto out;
 
-	while ((record.size = psi->read(&record.id, &record.type,
-				 &record.count, &record.time,
-				 &record.buf, &record.compressed,
-				 &record.ecc_notice_size,
-				 record.psi)) > 0) {
-
+	while ((record.size = psi->read(&record)) > 0) {
 		decompress_record(&record);
 		rc = pstore_mkfile(&record);
 
diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 11f918d34b1e..ca6e2a814e37 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -235,35 +235,34 @@ static ssize_t ftrace_log_combine(struct persistent_ram_zone *dest,
 	return 0;
 }
 
-static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
-				   int *count, struct timespec *time,
-				   char **buf, bool *compressed,
-				   ssize_t *ecc_notice_size,
-				   struct pstore_info *psi)
+static ssize_t ramoops_pstore_read(struct pstore_record *record)
 {
 	ssize_t size = 0;
-	struct ramoops_context *cxt = psi->data;
+	struct ramoops_context *cxt = record->psi->data;
 	struct persistent_ram_zone *prz = NULL;
 	int header_length = 0;
 	bool free_prz = false;
 
-	/* Ramoops headers provide time stamps for PSTORE_TYPE_DMESG, but
+	/*
+	 * Ramoops headers provide time stamps for PSTORE_TYPE_DMESG, but
 	 * PSTORE_TYPE_CONSOLE and PSTORE_TYPE_FTRACE don't currently have
 	 * valid time stamps, so it is initialized to zero.
 	 */
-	time->tv_sec = 0;
-	time->tv_nsec = 0;
-	*compressed = false;
+	record->time.tv_sec = 0;
+	record->time.tv_nsec = 0;
+	record->compressed = false;
 
 	/* Find the next valid persistent_ram_zone for DMESG */
 	while (cxt->dump_read_cnt < cxt->max_dump_cnt && !prz) {
 		prz = ramoops_get_next_prz(cxt->dprzs, &cxt->dump_read_cnt,
-					   cxt->max_dump_cnt, id, type,
+					   cxt->max_dump_cnt, &record->id,
+					   &record->type,
 					   PSTORE_TYPE_DMESG, 1);
 		if (!prz_ok(prz))
 			continue;
 		header_length = ramoops_read_kmsg_hdr(persistent_ram_old(prz),
-						      time, compressed);
+						      &record->time,
+						      &record->compressed);
 		/* Clear and skip this DMESG record if it has no valid header */
 		if (!header_length) {
 			persistent_ram_free_old(prz);
@@ -274,18 +273,20 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
 
 	if (!prz_ok(prz))
 		prz = ramoops_get_next_prz(&cxt->cprz, &cxt->console_read_cnt,
-					   1, id, type, PSTORE_TYPE_CONSOLE, 0);
+					   1, &record->id, &record->type,
+					   PSTORE_TYPE_CONSOLE, 0);
 
 	if (!prz_ok(prz))
 		prz = ramoops_get_next_prz(&cxt->mprz, &cxt->pmsg_read_cnt,
-					   1, id, type, PSTORE_TYPE_PMSG, 0);
+					   1, &record->id, &record->type,
+					   PSTORE_TYPE_PMSG, 0);
 
 	/* ftrace is last since it may want to dynamically allocate memory. */
 	if (!prz_ok(prz)) {
 		if (!(cxt->flags & RAMOOPS_FLAG_FTRACE_PER_CPU)) {
 			prz = ramoops_get_next_prz(cxt->fprzs,
-					&cxt->ftrace_read_cnt, 1, id, type,
-					PSTORE_TYPE_FTRACE, 0);
+					&cxt->ftrace_read_cnt, 1, &record->id,
+					&record->type, PSTORE_TYPE_FTRACE, 0);
 		} else {
 			/*
 			 * Build a new dummy record which combines all the
@@ -302,8 +303,10 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
 			while (cxt->ftrace_read_cnt < cxt->max_ftrace_cnt) {
 				prz_next = ramoops_get_next_prz(cxt->fprzs,
 						&cxt->ftrace_read_cnt,
-						cxt->max_ftrace_cnt, id,
-						type, PSTORE_TYPE_FTRACE, 0);
+						cxt->max_ftrace_cnt,
+						&record->id,
+						&record->type,
+						PSTORE_TYPE_FTRACE, 0);
 
 				if (!prz_ok(prz_next))
 					continue;
@@ -316,7 +319,7 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
 				if (size)
 					goto out;
 			}
-			*id = 0;
+			record->id = 0;
 			prz = tmp_prz;
 		}
 	}
@@ -329,17 +332,19 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
 	size = persistent_ram_old_size(prz) - header_length;
 
 	/* ECC correction notice */
-	*ecc_notice_size = persistent_ram_ecc_string(prz, NULL, 0);
+	record->ecc_notice_size = persistent_ram_ecc_string(prz, NULL, 0);
 
-	*buf = kmalloc(size + *ecc_notice_size + 1, GFP_KERNEL);
-	if (*buf == NULL) {
+	record->buf = kmalloc(size + record->ecc_notice_size + 1, GFP_KERNEL);
+	if (record->buf == NULL) {
 		size = -ENOMEM;
 		goto out;
 	}
 
-	memcpy(*buf, (char *)persistent_ram_old(prz) + header_length, size);
+	memcpy(record->buf, (char *)persistent_ram_old(prz) + header_length,
+	       size);
 
-	persistent_ram_ecc_string(prz, *buf + size, *ecc_notice_size + 1);
+	persistent_ram_ecc_string(prz, record->buf + size,
+				  record->ecc_notice_size + 1);
 
 out:
 	if (free_prz) {
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index 7b25f7f17915..8b51c9da8d16 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -111,16 +111,11 @@ struct pstore_record {
  *	Read next available backend record. Called after a successful
  *	@open.
  *
- *	@id:	out: unique identifier for the record
- *	@type:	out: pstore record type
- *	@count: out: for PSTORE_TYPE_DMESG, the Oops count.
- *	@time:	out: timestamp for the record
- *	@buf:	out: kmalloc copy of record contents, to be freed by pstore
- *	@compressed:
- *		out: if the record contents are compressed
- *	@ecc_notice_size:
- *		out: ECC information
- *	@psi:	in: pointer to the struct pstore_info for the backend
+ *	@record:
+ *		pointer to record to populate. @buf should be allocated
+ *		by the backend and filled. At least @type and @id should
+ *		be populated, since these are used when creating pstorefs
+ *		file names.
  *
  *	Returns record size on success, zero when no more records are
  *	available, or negative on error.
@@ -207,10 +202,7 @@ struct pstore_info {
 
 	int		(*open)(struct pstore_info *psi);
 	int		(*close)(struct pstore_info *psi);
-	ssize_t		(*read)(u64 *id, enum pstore_type_id *type,
-			int *count, struct timespec *time, char **buf,
-			bool *compressed, ssize_t *ecc_notice_size,
-			struct pstore_info *psi);
+	ssize_t		(*read)(struct pstore_record *record);
 	int		(*write)(enum pstore_type_id type,
 			enum kmsg_dump_reason reason, u64 *id,
 			unsigned int part, int count, bool compressed,
-- 
2.7.4
