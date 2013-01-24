From: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Subject: [PATCH v5 -next 2/2]efi_pstore: Introducing workqueue updating
 sysfs entries
Date: Thu, 24 Jan 2013 00:41:51 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D414A541C8@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Luck, Tony (tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org)" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "cbouatmailru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <cbouatmailru-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "dzickus-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dzickus-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Satoru Moriya <satoru.moriya-7rDLJAbr9SE@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

[Problem]
efi_pstore creates sysfs entries, which enable users to access to NVRAM,
in a write callback. If a kernel panic happens in an interrupt context,
it may fail because it could sleep due to dynamic memory allocations during
creating sysfs entries.

[Patch Description]
This patch removes sysfs operations from a write callback by introducing 
a workqueue updating sysfs entries which is scheduled after the write
callback is called.

Also, the workqueue is kicked in a just oops case.
A system will go down in other cases such as panic, clean shutdown and emergency 
restart. And we don't need to create sysfs entries because there is no chance for 
users to access to them.

efi_pstore will be robust against a kernel panic in an interrupt context with this patch.

Signed-off-by: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
---
 drivers/firmware/efivars.c |   85 +++++++++++++++++++++++++++++++++++++++++---
 include/linux/efi.h        |    3 +-
 2 files changed, 82 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index a64fb7b..6922511 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -158,6 +158,13 @@ efivar_create_sysfs_entry(struct efivars *efivars,
 			  efi_char16_t *variable_name,
 			  efi_guid_t *vendor_guid);
 
+/*
+ * Prototype for workqueue functions updating sysfs entry
+ */
+
+static void efivar_update_sysfs_entries(struct work_struct *);
+static DECLARE_WORK(efivar_work, efivar_update_sysfs_entries);
+
 /* Return the number of unicode characters in data */
 static unsigned long
 utf16_strnlen(efi_char16_t *s, size_t maxlength)
@@ -1248,11 +1255,8 @@ static int efi_pstore_write(enum pstore_type_id type,
 
 	spin_unlock_irqrestore(&efivars->lock, flags);
 
-	if (size)
-		ret = efivar_create_sysfs_entry(efivars,
-					  utf16_strsize(efi_name,
-							DUMP_NAME_LEN * 2),
-					  efi_name, &vendor);
+	if (reason == KMSG_DUMP_OOPS)
+		schedule_work(&efivar_work);
 
 	*id = part;
 	return ret;
@@ -1496,6 +1500,75 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 	return count;
 }
 
+static bool variable_is_present(efi_char16_t *variable_name, efi_guid_t *vendor)
+{
+	struct efivar_entry *entry, *n;
+	struct efivars *efivars = &__efivars;
+	unsigned long strsize1, strsize2;
+	bool found = false;
+
+	strsize1 = utf16_strsize(variable_name, 1024);
+	list_for_each_entry_safe(entry, n, &efivars->list, list) {
+		strsize2 = utf16_strsize(entry->var.VariableName, 1024);
+		if (strsize1 == strsize2 &&
+			!memcmp(variable_name, &(entry->var.VariableName),
+				strsize2) &&
+			!efi_guidcmp(entry->var.VendorGuid,
+				*vendor)) {
+			found = true;
+			break;
+		}
+	}
+	return found;
+}
+
+static void efivar_update_sysfs_entries(struct work_struct *work)
+{
+	struct efivars *efivars = &__efivars;
+	efi_guid_t vendor;
+	efi_char16_t *variable_name;
+	unsigned long variable_name_size = 1024;
+	efi_status_t status = EFI_NOT_FOUND;
+	bool found;
+
+	/* Add new sysfs entries */
+	while (1) {
+		variable_name = kzalloc(variable_name_size, GFP_KERNEL);
+		if (!variable_name) {
+			pr_err("efivars: Memory allocation failed.\n");
+			return;
+		}
+
+		spin_lock_irq(&efivars->lock);
+		found = false;
+		while (1) {
+			variable_name_size = 1024;
+			status = efivars->ops->get_next_variable(
+							&variable_name_size,
+							variable_name,
+							&vendor);
+			if (status != EFI_SUCCESS) {
+				break;
+			} else {
+				if (!variable_is_present(variable_name,
+				    &vendor)) {
+					found = true;
+					break;
+				}
+			}
+		}
+		spin_unlock_irq(&efivars->lock);
+
+		if (!found) {
+			kfree(variable_name);
+			break;
+		} else
+			efivar_create_sysfs_entry(efivars,
+						  variable_name_size,
+						  variable_name, &vendor);
+	}
+}
+
 /*
  * Let's not leave out systab information that snuck into
  * the efivars driver
@@ -1833,6 +1906,8 @@ err_put:
 static void __exit
 efivars_exit(void)
 {
+	cancel_work_sync(&efivar_work);
+
 	if (efi_enabled) {
 		unregister_efivars(&__efivars);
 		kobject_put(efi_kobj);
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 8b84916..6f94a25 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -728,7 +728,8 @@ struct efivars {
 	 * 1) ->list - adds, removals, reads, writes
 	 * 2) ops.[gs]et_variable() calls.
 	 * It must not be held when creating sysfs entries or calling kmalloc.
-	 * ops.get_next_variable() is only called from register_efivars(),
+	 * ops.get_next_variable() is only called from register_efivars()
+	 * or efivar_update_sysfs_entry(),
 	 * which is protected by the BKL, so that path is safe.
 	 */
 	spinlock_t lock;
-- 1.7.1 
