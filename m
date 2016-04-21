From: Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>
Subject: [PATCH] efivarfs: merge boolean flag arguments
Date: Thu, 21 Apr 2016 15:24:29 +0200
Message-ID: <1461245069-10221-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>
Cc: kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vaishali.thakkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, saurabh.truth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

The parameters atomic and duplicates of efivar_init always have opposite
values.  Drop the parameter atomic, replace the uses of !atomic with
duplicates, and update the call sites accordingly.

The code using duplicates is slightly reorganized with an else, to avoid
duplicating the lock code.

Signed-off-by: Julia Lawall <Julia.Lawall-L2FTfq7BK8M@public.gmane.org>

---
Not tested.  I have assumed that the calls to both variable_is_present and
dup_variable_bug need to be out of the lock.

 drivers/firmware/efi/efivars.c |    5 ++---
 drivers/firmware/efi/vars.c    |   23 ++++++++++-------------
 fs/efivarfs/super.c            |    3 +--
 include/linux/efi.h            |    3 +--
 4 files changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 096adcb..116b244 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -661,7 +661,7 @@ static void efivar_update_sysfs_entries(struct work_struct *work)
 			return;
 
 		err = efivar_init(efivar_update_sysfs_entry, entry,
-				  true, false, &efivar_sysfs_list);
+				  false, &efivar_sysfs_list);
 		if (!err)
 			break;
 
@@ -730,8 +730,7 @@ int efivars_sysfs_init(void)
 		return -ENOMEM;
 	}
 
-	efivar_init(efivars_sysfs_callback, NULL, false,
-		    true, &efivar_sysfs_list);
+	efivar_init(efivars_sysfs_callback, NULL, true, &efivar_sysfs_list);
 
 	error = create_efivars_bin_attributes();
 	if (error) {
diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 0ac594c..758c73c 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -437,8 +437,7 @@ static void dup_variable_bug(efi_char16_t *str16, efi_guid_t *vendor_guid,
  * Returns 0 on success, or a kernel error code on failure.
  */
 int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
-		void *data, bool atomic, bool duplicates,
-		struct list_head *head)
+		void *data, bool duplicates, struct list_head *head)
 {
 	const struct efivar_operations *ops = __efivars->ops;
 	unsigned long variable_name_size = 1024;
@@ -468,7 +467,7 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 						&vendor_guid);
 		switch (status) {
 		case EFI_SUCCESS:
-			if (!atomic)
+			if (duplicates)
 				spin_unlock_irq(&__efivars->lock);
 
 			variable_name_size = var_name_strnsize(variable_name,
@@ -483,21 +482,19 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 			 * and may end up looping here forever.
 			 */
 			if (duplicates &&
-			    variable_is_present(variable_name, &vendor_guid, head)) {
+			    variable_is_present(variable_name, &vendor_guid,
+						head)) {
 				dup_variable_bug(variable_name, &vendor_guid,
 						 variable_name_size);
-				if (!atomic)
-					spin_lock_irq(&__efivars->lock);
-
 				status = EFI_NOT_FOUND;
-				break;
+			} else {
+				err = func(variable_name, vendor_guid,
+					   variable_name_size, data);
+				if (err)
+					status = EFI_NOT_FOUND;
 			}
 
-			err = func(variable_name, vendor_guid, variable_name_size, data);
-			if (err)
-				status = EFI_NOT_FOUND;
-
-			if (!atomic)
+			if (duplicates)
 				spin_lock_irq(&__efivars->lock);
 
 			break;
diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 553c5d2..9cb54a3 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -216,8 +216,7 @@ static int efivarfs_fill_super(struct super_block *sb, void *data, int silent)
 
 	INIT_LIST_HEAD(&efivarfs_list);
 
-	err = efivar_init(efivarfs_callback, (void *)sb, false,
-			  true, &efivarfs_list);
+	err = efivar_init(efivarfs_callback, (void *)sb, true, &efivarfs_list);
 	if (err)
 		__efivar_entry_iter(efivarfs_destroy, &efivarfs_list, NULL, NULL);
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 5b1d5c5..7b8b2c5 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1189,8 +1189,7 @@ int efivars_unregister(struct efivars *efivars);
 struct kobject *efivars_kobject(void);
 
 int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
-		void *data, bool atomic, bool duplicates,
-		struct list_head *head);
+		void *data, bool duplicates, struct list_head *head);
 
 void efivar_entry_add(struct efivar_entry *entry, struct list_head *head);
 void efivar_entry_remove(struct efivar_entry *entry);
