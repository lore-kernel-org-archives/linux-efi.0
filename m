From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [RFC][PATCH 5/7 v2] efivars: Move pstore code out of efivars.c
Date: Mon, 11 Feb 2013 14:45:28 +0000
Message-ID: <20130211144528.GK6197@console-pimps.org>
References: <1360357158-8168-1-git-send-email-matt@console-pimps.org>
 <1360357158-8168-6-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1360357158-8168-6-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Anton Vorontsov <cbouatmailru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Move the persistence storage code to efi/pstore.c now that it uses the
new efivar API, helping us to reduce the size of efivars.c. This move
also allows us to delete the code that was previously necessary when
CONFIG_PSTORE was disabled.

Cc: Anton Vorontsov <cbouatmailru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

v2: Use efivar_entry_set_safe() for QueryVariableInfo() +
    SetVariable() atomicity.

 MAINTAINERS                   |   2 +-
 drivers/firmware/efi/Kconfig  |  12 ++
 drivers/firmware/efi/Makefile |   1 +
 drivers/firmware/efi/pstore.c | 227 ++++++++++++++++++++++++++++++++++
 drivers/firmware/efivars.c    | 275 ------------------------------------------
 include/linux/efi.h           |  28 +++++
 6 files changed, 269 insertions(+), 276 deletions(-)
 create mode 100644 drivers/firmware/efi/pstore.c

diff --git a/MAINTAINERS b/MAINTAINERS
index e37219d..c31e5a4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6091,7 +6091,7 @@ S:	Maintained
 T:	git git://git.infradead.org/users/cbou/linux-pstore.git
 F:	fs/pstore/
 F:	include/linux/pstore*
-F:	drivers/firmware/efivars.c
+F:	drivers/firmware/efi/pstore.c
 F:	drivers/acpi/apei/erst.c
 
 PTP HARDWARE CLOCK SUPPORT
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index a4f213c..f664de2 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -29,4 +29,16 @@ config EFI_VARS_SYSFS
 	  Subsequent efibootmgr releases may be found at:
 	  <http://linux.dell.com/efibootmgr>
 
+config EFI_VARS_PSTORE
+	tristate "EFI Variable Persistent Storage"
+	depends on PSTORE
+	depends on EFI_VARS_SYSFS
+	default n
+	help
+	  This option enables panic and oops messages to be stored in
+	  EFI variables, which allows them to be examined after the
+	  machine has been rebooted.
+
+	  If unsure, say N.
+
 endmenu
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 73ec68b..0b8d7e0 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -2,3 +2,4 @@
 # Makefile for linux kernel
 #
 obj-$(CONFIG_EFI_VARS_SYSFS)		+= sysfs.o
+obj-$(CONFIG_EFI_VARS_PSTORE)		+= pstore.o
diff --git a/drivers/firmware/efi/pstore.c b/drivers/firmware/efi/pstore.c
new file mode 100644
index 0000000..594e82d
--- /dev/null
+++ b/drivers/firmware/efi/pstore.c
@@ -0,0 +1,227 @@
+#include <linux/efi.h>
+#include <linux/module.h>
+#include <linux/pstore.h>
+
+#define DUMP_NAME_LEN 52
+
+#define PSTORE_EFI_ATTRIBUTES \
+	(EFI_VARIABLE_NON_VOLATILE | \
+	 EFI_VARIABLE_BOOTSERVICE_ACCESS | \
+	 EFI_VARIABLE_RUNTIME_ACCESS)
+
+static int efi_pstore_open(struct pstore_info *psi)
+{
+	efivar_entry_iter_begin();
+	psi->data = NULL;
+	return 0;
+}
+
+static int efi_pstore_close(struct pstore_info *psi)
+{
+	efivar_entry_iter_end();
+	psi->data = NULL;
+	return 0;
+}
+
+struct pstore_read_data {
+	u64 *id;
+	enum pstore_type_id *type;
+	int *count;
+	struct timespec *timespec;
+	char **buf;
+};
+
+static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
+{
+	struct pstore_read_data *cb_data = data;
+	char name[DUMP_NAME_LEN];
+	int i;
+	int cnt;
+	unsigned int part;
+	unsigned long time, size;
+	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
+
+	if (efi_guidcmp(entry->var.VendorGuid, vendor))
+		return 0;
+
+	for (i = 0; i < DUMP_NAME_LEN; i++)
+		name[i] = entry->var.VariableName[i];
+
+	if (sscanf(name, "dump-type%u-%u-%d-%lu",
+		   cb_data->type, &part, &cnt, &time) == 4) {
+		*cb_data->id = part;
+		*cb_data->count = cnt;
+		cb_data->timespec->tv_sec = time;
+		cb_data->timespec->tv_nsec = 0;
+	} else if (sscanf(name, "dump-type%u-%u-%lu",
+			  cb_data->type, &part, &time) == 3) {
+		/*
+		 * Check if an old format,
+		 * which doesn't support holding
+		 * multiple logs, remains.
+		 */
+		*cb_data->id = part;
+		*cb_data->count = 0;
+		cb_data->timespec->tv_sec = time;
+		cb_data->timespec->tv_nsec = 0;
+	} else
+		return 0;
+
+	efivar_entry_size(entry, &size);
+	*cb_data->buf = kmalloc(size, GFP_KERNEL);
+	if (*cb_data->buf == NULL)
+		return -ENOMEM;
+	memcpy(*cb_data->buf, entry->var.Data, size);
+	return size;
+}
+
+static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
+			       int *count, struct timespec *timespec,
+			       char **buf, struct pstore_info *psi)
+{
+	struct pstore_read_data data;
+
+	data.id = id;
+	data.type = type;
+	data.count = count;
+	data.timespec = timespec;
+	data.buf = buf;
+
+	return __efivar_entry_iter(efi_pstore_read_func, &data,
+				   (struct efivar_entry **)&psi->data);
+}
+
+static int efi_pstore_write(enum pstore_type_id type,
+		enum kmsg_dump_reason reason, u64 *id,
+		unsigned int part, int count, size_t size,
+		struct pstore_info *psi)
+{
+	struct efivar_entry *entry;
+	char name[DUMP_NAME_LEN];
+	efi_char16_t efi_name[DUMP_NAME_LEN];
+	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
+	int i, ret = 0;
+
+	sprintf(name, "dump-type%u-%u-%d-%lu", type, part, count,
+		get_seconds());
+
+	for (i = 0; i < DUMP_NAME_LEN; i++)
+		efi_name[i] = name[i];
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry)
+		return -ENOMEM;
+
+	memcpy(entry->var.VariableName, efi_name,
+	       utf16_strsize(efi_name, DUMP_NAME_LEN * 2));
+	memcpy(&(entry->var.VendorGuid), &vendor, sizeof(vendor));
+
+	ret = efivar_entry_set_safe(entry, PSTORE_EFI_ATTRIBUTES,
+				    size, psi->buf);
+
+	if (size && !ret)
+		ret = efivar_create_sysfs_entry(entry);
+
+	*id = part;
+	return ret;
+};
+
+struct pstore_erase_data {
+	u64 id;
+	enum pstore_type_id type;
+	int count;
+	struct timespec time;
+	efi_char16_t *name;
+};
+
+/*
+ * Clean up an entry with the same name
+ */
+static int efi_pstore_erase_func(struct efivar_entry *entry, void *data)
+{
+	struct pstore_erase_data *ed = data;
+	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
+	efi_char16_t efi_name_old[DUMP_NAME_LEN];
+	efi_char16_t *efi_name = ed->name;
+	unsigned long utf16_len = utf16_strlen(ed->name);
+	char name_old[DUMP_NAME_LEN];
+	int i;
+
+	if (efi_guidcmp(entry->var.VendorGuid, vendor))
+		return 0;
+
+	if (utf16_strncmp(entry->var.VariableName,
+			  efi_name, (size_t)utf16_len)) {
+		/*
+		 * Check if an old format, which doesn't support
+		 * holding multiple logs, remains.
+		 */
+		sprintf(name_old, "dump-type%u-%u-%lu", ed->type,
+			(unsigned int)ed->id, ed->time.tv_sec);
+
+		for (i = 0; i < DUMP_NAME_LEN; i++)
+			efi_name_old[i] = name_old[i];
+
+		if (utf16_strncmp(entry->var.VariableName, efi_name_old,
+				  utf16_strlen(efi_name_old)))
+			return 0;
+	}
+
+	/* found */
+	__efivar_entry_delete(entry);
+	return 1;
+}
+
+static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
+			    struct timespec time, struct pstore_info *psi)
+{
+	struct pstore_erase_data edata;
+	char name[DUMP_NAME_LEN];
+	efi_char16_t efi_name[DUMP_NAME_LEN];
+	int i;
+
+	sprintf(name, "dump-type%u-%u-%d-%lu", type, (unsigned int)id, count,
+		time.tv_sec);
+
+	for (i = 0; i < DUMP_NAME_LEN; i++)
+		efi_name[i] = name[i];
+
+	edata.id = id;
+	edata.type = type;
+	edata.count = count;
+	edata.time = time;
+	edata.name = efi_name;
+
+	return efivar_entry_iter(efi_pstore_erase_func, &edata);
+}
+
+static struct pstore_info efi_pstore_info = {
+	.owner		= THIS_MODULE,
+	.name		= "efi",
+	.open		= efi_pstore_open,
+	.close		= efi_pstore_close,
+	.read		= efi_pstore_read,
+	.write		= efi_pstore_write,
+	.erase		= efi_pstore_erase,
+};
+
+static __init int efivars_pstore_init(void)
+{
+	efi_pstore_info.buf = kmalloc(4096, GFP_KERNEL);
+	if (!efi_pstore_info.buf)
+		return -ENOMEM;
+
+	efi_pstore_info.bufsize = 1024;
+	spin_lock_init(&efi_pstore_info.buf_lock);
+
+	pstore_register(&efi_pstore_info);
+
+	return 0;
+}
+
+static __exit void efivars_pstore_exit(void)
+{
+}
+
+module_init(efivars_pstore_init);
+module_exit(efivars_pstore_exit);
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index a72b374..4599e44 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -32,7 +32,6 @@
 #include <linux/kobject.h>
 #include <linux/device.h>
 #include <linux/slab.h>
-#include <linux/pstore.h>
 #include <linux/ctype.h>
 
 #include <linux/fs.h>
@@ -41,47 +40,12 @@
 
 #include <asm/uaccess.h>
 
-#define DUMP_NAME_LEN 52
-
 static struct efivars generic_efivars;
 static struct efivar_operations generic_ops;
 
 /* Private pointer to registered efivars */
 static struct efivars *__efivars;
 
-#define PSTORE_EFI_ATTRIBUTES \
-	(EFI_VARIABLE_NON_VOLATILE | \
-	 EFI_VARIABLE_BOOTSERVICE_ACCESS | \
-	 EFI_VARIABLE_RUNTIME_ACCESS)
-
-/*
- * Return the number of bytes is the length of this string
- * Note: this is NOT the same as the number of unicode characters
- */
-static inline unsigned long
-utf16_strsize(efi_char16_t *data, unsigned long maxlength)
-{
-	return utf16_strnlen(data, maxlength/sizeof(efi_char16_t)) * sizeof(efi_char16_t);
-}
-
-static inline int
-utf16_strncmp(const efi_char16_t *a, const efi_char16_t *b, size_t len)
-{
-	while (1) {
-		if (len == 0)
-			return 0;
-		if (*a < *b)
-			return -1;
-		if (*a > *b)
-			return 1;
-		if (*a == 0) /* implies *b == 0 */
-			return 0;
-		a++;
-		b++;
-		len--;
-	}
-}
-
 static bool
 validate_device_path(struct efi_variable *var, int match, u8 *buffer,
 		     unsigned long len)
@@ -785,238 +749,6 @@ static const struct inode_operations efivarfs_dir_inode_operations = {
 	.create = efivarfs_create,
 };
 
-static struct pstore_info efi_pstore_info;
-
-#if defined(CONFIG_PSTORE) && (defined(CONFIG_EFI_VARS_SYSFS) || defined(CONFIG_EFI_VARS_SYSFS_MODULE))
-
-static int efi_pstore_open(struct pstore_info *psi)
-{
-	efivar_entry_iter_begin();
-	psi->data = NULL;
-	return 0;
-}
-
-static int efi_pstore_close(struct pstore_info *psi)
-{
-	efivar_entry_iter_end();
-	psi->data = NULL;
-	return 0;
-}
-
-struct pstore_read_data {
-	u64 *id;
-	enum pstore_type_id *type;
-	int *count;
-	struct timespec *timespec;
-	char **buf;
-};
-
-static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
-{
-	struct pstore_read_data *cb_data = data;
-	char name[DUMP_NAME_LEN];
-	int i;
-	int cnt;
-	unsigned int part;
-	unsigned long time, size;
-	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
-
-	if (efi_guidcmp(entry->var.VendorGuid, vendor))
-		return 0;
-
-	for (i = 0; i < DUMP_NAME_LEN; i++)
-		name[i] = entry->var.VariableName[i];
-
-	if (sscanf(name, "dump-type%u-%u-%d-%lu",
-		   cb_data->type, &part, &cnt, &time) == 4) {
-		*cb_data->id = part;
-		*cb_data->count = cnt;
-		cb_data->timespec->tv_sec = time;
-		cb_data->timespec->tv_nsec = 0;
-	} else if (sscanf(name, "dump-type%u-%u-%lu",
-			  cb_data->type, &part, &time) == 3) {
-		/*
-		 * Check if an old format,
-		 * which doesn't support holding
-		 * multiple logs, remains.
-		 */
-		*cb_data->id = part;
-		*cb_data->count = 0;
-		cb_data->timespec->tv_sec = time;
-		cb_data->timespec->tv_nsec = 0;
-	} else
-		return 0;
-
-	efivar_entry_size(entry, &size);
-	*cb_data->buf = kmalloc(size, GFP_KERNEL);
-	if (*cb_data->buf == NULL)
-		return -ENOMEM;
-	memcpy(*cb_data->buf, entry->var.Data, size);
-	return size;
-}
-
-static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
-			       int *count, struct timespec *timespec,
-			       char **buf, struct pstore_info *psi)
-{
-	struct pstore_read_data data;
-
-	data.id = id;
-	data.type = type;
-	data.count = count;
-	data.timespec = timespec;
-	data.buf = buf;
-
-	return __efivar_entry_iter(efi_pstore_read_func, &data,
-				   (struct efivar_entry **)&psi->data);
-}
-
-static int efi_pstore_write(enum pstore_type_id type,
-		enum kmsg_dump_reason reason, u64 *id,
-		unsigned int part, int count, size_t size,
-		struct pstore_info *psi)
-{
-	struct efivar_entry *entry;
-	char name[DUMP_NAME_LEN];
-	efi_char16_t efi_name[DUMP_NAME_LEN];
-	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
-	int i, ret = 0;
-
-	sprintf(name, "dump-type%u-%u-%d-%lu", type, part, count,
-		get_seconds());
-
-	for (i = 0; i < DUMP_NAME_LEN; i++)
-		efi_name[i] = name[i];
-
-	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
-	if (!entry)
-		return -ENOMEM;
-
-	memcpy(entry->var.VariableName, efi_name,
-	       utf16_strsize(efi_name, DUMP_NAME_LEN * 2));
-	memcpy(&(entry->var.VendorGuid), &vendor, sizeof(vendor));
-
-	ret = efivar_entry_set_safe(entry, PSTORE_EFI_ATTRIBUTES,
-				    size, psi->buf);
-
-	if (size && !ret)
-		ret = efivar_create_sysfs_entry(entry);
-
-	*id = part;
-	return ret;
-};
-
-struct pstore_erase_data {
-	u64 id;
-	enum pstore_type_id type;
-	int count;
-	struct timespec time;
-	efi_char16_t *name;
-};
-
-/*
- * Clean up an entry with the same name
- */
-static int efi_pstore_erase_func(struct efivar_entry *entry, void *data)
-{
-	struct pstore_erase_data *ed = data;
-	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
-	efi_char16_t efi_name_old[DUMP_NAME_LEN];
-	efi_char16_t *efi_name = ed->name;
-	unsigned long utf16_len = utf16_strlen(ed->name);
-	char name_old[DUMP_NAME_LEN];
-	int i;
-
-	if (efi_guidcmp(entry->var.VendorGuid, vendor))
-		return 0;
-
-	if (utf16_strncmp(entry->var.VariableName,
-			  efi_name, (size_t)utf16_len)) {
-		/*
-		 * Check if an old format, which doesn't support
-		 * holding multiple logs, remains.
-		 */
-		sprintf(name_old, "dump-type%u-%u-%lu", ed->type,
-			(unsigned int)ed->id, ed->time.tv_sec);
-
-		for (i = 0; i < DUMP_NAME_LEN; i++)
-			efi_name_old[i] = name_old[i];
-
-		if (utf16_strncmp(entry->var.VariableName, efi_name_old,
-				  utf16_strlen(efi_name_old)))
-			return 0;
-	}
-
-	/* found */
-	__efivar_entry_delete(entry);
-	return 1;
-}
-
-static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
-			    struct timespec time, struct pstore_info *psi)
-{
-	struct pstore_erase_data edata;
-	char name[DUMP_NAME_LEN];
-	efi_char16_t efi_name[DUMP_NAME_LEN];
-	int i;
-
-	sprintf(name, "dump-type%u-%u-%d-%lu", type, (unsigned int)id, count,
-		time.tv_sec);
-
-	for (i = 0; i < DUMP_NAME_LEN; i++)
-		efi_name[i] = name[i];
-
-	edata.id = id;
-	edata.type = type;
-	edata.count = count;
-	edata.time = time;
-	edata.name = efi_name;
-
-	return efivar_entry_iter(efi_pstore_erase_func, &edata);
-}
-#else
-static int efi_pstore_open(struct pstore_info *psi)
-{
-	return 0;
-}
-
-static int efi_pstore_close(struct pstore_info *psi)
-{
-	return 0;
-}
-
-static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
-			       int *count, struct timespec *timespec,
-			       char **buf, struct pstore_info *psi)
-{
-	return -1;
-}
-
-static int efi_pstore_write(enum pstore_type_id type,
-		enum kmsg_dump_reason reason, u64 *id,
-		unsigned int part, int count, size_t size,
-		struct pstore_info *psi)
-{
-	return 0;
-}
-
-static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
-			    struct timespec time, struct pstore_info *psi)
-{
-	return 0;
-}
-#endif
-
-static struct pstore_info efi_pstore_info = {
-	.owner		= THIS_MODULE,
-	.name		= "efi",
-	.open		= efi_pstore_open,
-	.close		= efi_pstore_close,
-	.read		= efi_pstore_read,
-	.write		= efi_pstore_write,
-	.erase		= efi_pstore_erase,
-};
-
 /*
  * Let's not leave out systab information that snuck into
  * the efivars driver
@@ -1707,13 +1439,6 @@ efivars_init(void)
 		       error);
 	}
 
-	efi_pstore_info.buf = kmalloc(4096, GFP_KERNEL);
-	if (efi_pstore_info.buf) {
-		efi_pstore_info.bufsize = 4096;
-		spin_lock_init(&efi_pstore_info.buf_lock);
-		pstore_register(&efi_pstore_info);
-	}
-
 	register_filesystem(&efivarfs_type);
 
 	return error;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 09e8ec7..b81928b 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -744,6 +744,34 @@ utf16_strlen(efi_char16_t *s)
 
 #ifdef CONFIG_EFI_VARS
 /*
+ * Return the number of bytes is the length of this string
+ * Note: this is NOT the same as the number of unicode characters
+ */
+static inline unsigned long
+utf16_strsize(efi_char16_t *data, unsigned long maxlength)
+{
+	return utf16_strnlen(data, maxlength/sizeof(efi_char16_t)) * sizeof(efi_char16_t);
+}
+
+static inline int
+utf16_strncmp(const efi_char16_t *a, const efi_char16_t *b, size_t len)
+{
+	while (1) {
+		if (len == 0)
+			return 0;
+		if (*a < *b)
+			return -1;
+		if (*a > *b)
+			return 1;
+		if (*a == 0) /* implies *b == 0 */
+			return 0;
+		a++;
+		b++;
+		len--;
+	}
+}
+
+/*
  * EFI Variable support.
  *
  * Different firmware drivers can expose their EFI-like variables using
-- 
1.7.11.7
