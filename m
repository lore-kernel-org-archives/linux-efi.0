From: Seiji Aguchi <seiji.aguchi@hds.com>
Subject: [PATCH v3 4/7] efi_pstore: Add ctime to argument of erase callback
Date: Fri, 26 Oct 2012 21:41:43 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41388F017@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-acpi-owner@vger.kernel.org
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "mikew@google.com" <mikew@google.com>, "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>, "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>, "dzickus@redhat.com" <dzickus@redhat.com>
Cc: "dle-develop@lists.sourceforge.net" <dle-develop@lists.sourceforge.net>, Satoru Moriya <satoru.moriya@hds.com>
List-Id: linux-efi@vger.kernel.org

[Issue]

Currently, a variable name, which is used to identify each log entry, consists of type,
id and ctime. But an erase callback does not use ctime.

If efi_pstore supported just one log, type and id were enough.
However, in case of supporting multiple logs, it doesn't work because
it can't distinguish each entry without ctime at erasing time.

 <Example>

 As you can see below, efi_pstore can't differentiate first event from second one without ctime.

 a variable name of first event: dump-type0-1-12345678
 a variable name of second event: dump-type0-1-23456789

  type:0
  id:1
  ctime:12345678, 23456789

[Solution]

This patch adds ctime to an argument of an erase callback.

It works across reboots because ctime of pstore means the date that the record was originally stored.
To do this, efi_pstore saves the ctime to variable name at writing time and passes it to pstore
at reading time. 

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
---
 drivers/acpi/apei/erst.c   |    4 ++--
 drivers/firmware/efivars.c |   15 +++++++--------
 fs/pstore/inode.c          |    3 ++-
 fs/pstore/ram.c            |    2 +-
 include/linux/pstore.h     |    2 +-
 5 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/acpi/apei/erst.c b/drivers/acpi/apei/erst.c
index e4d9d24..0bd6ae4 100644
--- a/drivers/acpi/apei/erst.c
+++ b/drivers/acpi/apei/erst.c
@@ -938,7 +938,7 @@ static int erst_writer(enum pstore_type_id type, enum kmsg_dump_reason reason,
 		       u64 *id, unsigned int part,
 		       size_t size, struct pstore_info *psi);
 static int erst_clearer(enum pstore_type_id type, u64 id,
-			struct pstore_info *psi);
+			struct timespec time, struct pstore_info *psi);
 
 static struct pstore_info erst_info = {
 	.owner		= THIS_MODULE,
@@ -1102,7 +1102,7 @@ static int erst_writer(enum pstore_type_id type, enum kmsg_dump_reason reason,
 }
 
 static int erst_clearer(enum pstore_type_id type, u64 id,
-			struct pstore_info *psi)
+			struct timespec time, struct pstore_info *psi)
 {
 	return erst_clear(id);
 }
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index fbe9202..6cbeea7 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -747,24 +747,25 @@ static int efi_pstore_write(enum pstore_type_id type,
 };
 
 static int efi_pstore_erase(enum pstore_type_id type, u64 id,
-			    struct pstore_info *psi)
+			    struct timespec time, struct pstore_info *psi)
 {
-	char stub_name[DUMP_NAME_LEN];
+	char name[DUMP_NAME_LEN];
 	efi_char16_t efi_name[DUMP_NAME_LEN];
 	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
 	struct efivars *efivars = psi->data;
 	struct efivar_entry *entry, *found = NULL;
 	int i;
 
-	sprintf(stub_name, "dump-type%u-%u-", type, (unsigned int)id);
+	sprintf(name, "dump-type%u-%u-%lu", type, (unsigned int)id,
+		time.tv_sec);
 
 	spin_lock(&efivars->lock);
 
 	for (i = 0; i < DUMP_NAME_LEN; i++)
-		efi_name[i] = stub_name[i];
+		efi_name[i] = name[i];
 
 	/*
-	 * Clean up any entries with the same name
+	 * Clean up an entry with the same name
 	 */
 
 	list_for_each_entry(entry, &efivars->list, list) {
@@ -775,9 +776,6 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id,
 		if (utf16_strncmp(entry->var.VariableName, efi_name,
 				  utf16_strlen(efi_name)))
 			continue;
-		/* Needs to be a prefix */
-		if (entry->var.VariableName[utf16_strlen(efi_name)] == 0)
-			continue;
 
 		/* found */
 		found = entry;
@@ -785,6 +783,7 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id,
 					   &entry->var.VendorGuid,
 					   PSTORE_EFI_ATTRIBUTES,
 					   0, NULL);
+		break;
 	}
 
 	if (found)
diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 4ab572e..4300af6 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -175,7 +175,8 @@ static int pstore_unlink(struct inode *dir, struct dentry *dentry)
 	struct pstore_private *p = dentry->d_inode->i_private;
 
 	if (p->psi->erase)
-		p->psi->erase(p->type, p->id, p->psi);
+		p->psi->erase(p->type, p->id, dentry->d_inode->i_ctime,
+			      p->psi);
 
 	return simple_unlink(dir, dentry);
 }
diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 1a4f6da..749693f 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -237,7 +237,7 @@ static int notrace ramoops_pstore_write_buf(enum pstore_type_id type,
 }
 
 static int ramoops_pstore_erase(enum pstore_type_id type, u64 id,
-				struct pstore_info *psi)
+				struct timespec time, struct pstore_info *psi)
 {
 	struct ramoops_context *cxt = psi->data;
 	struct persistent_ram_zone *prz;
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index ee3034a..f6e9336 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -60,7 +60,7 @@ struct pstore_info {
 			unsigned int part, const char *buf, size_t size,
 			struct pstore_info *psi);
 	int		(*erase)(enum pstore_type_id type, u64 id,
-			struct pstore_info *psi);
+			struct timespec time, struct pstore_info *psi);
 	void		*data;
 };
 
-- 1.7.1
