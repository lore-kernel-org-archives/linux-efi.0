From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/3] efi: don't use spinlocks for efi vars
Date: Fri, 22 Apr 2016 09:13:22 +0200
Message-ID: <1461309203-11806-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1461309203-11806-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461309203-11806-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
Cc: sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

All efivars operations are protected by a spinlock which prevents
interruptions and preemption. This is too restricted, we just need a
lock preventing concurrency.
The idea is to use a semaphore of count 1 and to have two ways of
locking, depending on the context:
- In interrupt context, we call down_trylock(), if it fails we return
  an error
- In normal context, we call down_interruptible()

We don't use a mutex here because the mutex_trylock() function must not
be called from interrupt context, whereas the down_trylock() can.

Signed-off-by: Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/efi-pstore.c |  36 +++--
 drivers/firmware/efi/efivars.c    |  22 ++-
 drivers/firmware/efi/vars.c       | 145 ++++++++++++--------
 fs/efivarfs/inode.c               |   5 +-
 fs/efivarfs/super.c               |   9 +-
 include/linux/efi.h               |   6 +-
 6 files changed, 149 insertions(+), 74 deletions(-)

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index eac76a79a880..7bfaffb0e672 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -121,16 +121,19 @@ static void efi_pstore_scan_sysfs_enter(struct efivar_entry *pos,
  * @entry: deleting entry
  * @turn_off_scanning: Check if a scanning flag should be turned off
  */
-static inline void __efi_pstore_scan_sysfs_exit(struct efivar_entry *entry,
+static inline int __efi_pstore_scan_sysfs_exit(struct efivar_entry *entry,
 						bool turn_off_scanning)
 {
 	if (entry->deleting) {
 		list_del(&entry->list);
 		efivar_entry_iter_end();
 		efivar_unregister(entry);
-		efivar_entry_iter_begin();
+		if (efivar_entry_iter_begin())
+			return -EINTR;
 	} else if (turn_off_scanning)
 		entry->scanning = false;
+
+	return 0;
 }
 
 /**
@@ -140,13 +143,18 @@ static inline void __efi_pstore_scan_sysfs_exit(struct efivar_entry *entry,
  * @head: list head
  * @stop: a flag checking if scanning will stop
  */
-static void efi_pstore_scan_sysfs_exit(struct efivar_entry *pos,
+static int efi_pstore_scan_sysfs_exit(struct efivar_entry *pos,
 				       struct efivar_entry *next,
 				       struct list_head *head, bool stop)
 {
-	__efi_pstore_scan_sysfs_exit(pos, true);
+	int ret = __efi_pstore_scan_sysfs_exit(pos, true);
+
+	if (ret)
+		return ret;
+
 	if (stop)
-		__efi_pstore_scan_sysfs_exit(next, &next->list != head);
+		ret = __efi_pstore_scan_sysfs_exit(next, &next->list != head);
+	return ret;
 }
 
 /**
@@ -168,13 +176,17 @@ static int efi_pstore_sysfs_entry_iter(void *data, struct efivar_entry **pos)
 	struct efivar_entry *entry, *n;
 	struct list_head *head = &efivar_sysfs_list;
 	int size = 0;
+	int ret;
 
 	if (!*pos) {
 		list_for_each_entry_safe(entry, n, head, list) {
 			efi_pstore_scan_sysfs_enter(entry, n, head);
 
 			size = efi_pstore_read_func(entry, data);
-			efi_pstore_scan_sysfs_exit(entry, n, head, size < 0);
+			ret = efi_pstore_scan_sysfs_exit(entry, n, head,
+							 size < 0);
+			if (ret)
+				return ret;
 			if (size)
 				break;
 		}
@@ -186,7 +198,9 @@ static int efi_pstore_sysfs_entry_iter(void *data, struct efivar_entry **pos)
 		efi_pstore_scan_sysfs_enter((*pos), n, head);
 
 		size = efi_pstore_read_func((*pos), data);
-		efi_pstore_scan_sysfs_exit((*pos), n, head, size < 0);
+		ret = efi_pstore_scan_sysfs_exit((*pos), n, head, size < 0);
+		if (ret)
+			return ret;
 		if (size)
 			break;
 	}
@@ -226,7 +240,10 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 	if (!*data.buf)
 		return -ENOMEM;
 
-	efivar_entry_iter_begin();
+	if (efivar_entry_iter_begin()) {
+		kfree(*data.buf);
+		return -EINTR;
+	}
 	size = efi_pstore_sysfs_entry_iter(&data,
 					   (struct efivar_entry **)&psi->data);
 	efivar_entry_iter_end();
@@ -341,7 +358,8 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
 	edata.time = time;
 	edata.name = efi_name;
 
-	efivar_entry_iter_begin();
+	if (efivar_entry_iter_begin())
+		return -EINTR;
 	found = __efivar_entry_iter(efi_pstore_erase_func, &efivar_sysfs_list, &edata, &entry);
 
 	if (found && !entry->scanning) {
diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 096adcbcb5a9..e9d7ee055a23 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -510,7 +510,8 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 		vendor = del_var->VendorGuid;
 	}
 
-	efivar_entry_iter_begin();
+	if (efivar_entry_iter_begin())
+		return -EINTR;
 	entry = efivar_entry_find(name, vendor, &efivar_sysfs_list, true);
 	if (!entry)
 		err = -EINVAL;
@@ -575,7 +576,10 @@ efivar_create_sysfs_entry(struct efivar_entry *new_var)
 		return ret;
 
 	kobject_uevent(&new_var->kobj, KOBJ_ADD);
-	efivar_entry_add(new_var, &efivar_sysfs_list);
+	if (efivar_entry_add(new_var, &efivar_sysfs_list)) {
+		efivar_unregister(new_var);
+		return -EINTR;
+	}
 
 	return 0;
 }
@@ -690,7 +694,10 @@ static int efivars_sysfs_callback(efi_char16_t *name, efi_guid_t vendor,
 
 static int efivar_sysfs_destroy(struct efivar_entry *entry, void *data)
 {
-	efivar_entry_remove(entry);
+	int err = efivar_entry_remove(entry);
+
+	if (err)
+		return err;
 	efivar_unregister(entry);
 	return 0;
 }
@@ -698,7 +705,14 @@ static int efivar_sysfs_destroy(struct efivar_entry *entry, void *data)
 static void efivars_sysfs_exit(void)
 {
 	/* Remove all entries and destroy */
-	__efivar_entry_iter(efivar_sysfs_destroy, &efivar_sysfs_list, NULL, NULL);
+	int err;
+
+	err = __efivar_entry_iter(efivar_sysfs_destroy, &efivar_sysfs_list,
+				  NULL, NULL);
+	if (err) {
+		pr_err("efivars: Failed to destroy sysfs entries\n");
+		return;
+	}
 
 	if (efivars_new_var)
 		sysfs_remove_bin_file(&efivars_kset->kobj, efivars_new_var);
diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 3dea50041c24..bd6e1ff9ae32 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -43,7 +43,7 @@ static struct efivars *__efivars;
  * 2) ->ops calls
  * 3) (un)registration of __efivars
  */
-static DEFINE_SPINLOCK(efivars_lock);
+static DEFINE_SEMAPHORE(efivars_lock);
 
 static bool efivar_wq_enabled = true;
 DECLARE_WORK(efivar_work, NULL);
@@ -461,7 +461,10 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 		return -ENOMEM;
 	}
 
-	spin_lock_irq(&efivars_lock);
+	if (down_interruptible(&efivars_lock)) {
+		err = -EINTR;
+		goto free;
+	}
 
 	/*
 	 * Per EFI spec, the maximum storage allocated for both
@@ -477,7 +480,7 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 		switch (status) {
 		case EFI_SUCCESS:
 			if (!atomic)
-				spin_unlock_irq(&efivars_lock);
+				up(&efivars_lock);
 
 			variable_name_size = var_name_strnsize(variable_name,
 							       variable_name_size);
@@ -494,8 +497,12 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 			    variable_is_present(variable_name, &vendor_guid, head)) {
 				dup_variable_bug(variable_name, &vendor_guid,
 						 variable_name_size);
-				if (!atomic)
-					spin_lock_irq(&efivars_lock);
+				if (!atomic) {
+					if (down_interruptible(&efivars_lock)) {
+						err = -EINTR;
+						goto free;
+					}
+				}
 
 				status = EFI_NOT_FOUND;
 				break;
@@ -505,8 +512,12 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 			if (err)
 				status = EFI_NOT_FOUND;
 
-			if (!atomic)
-				spin_lock_irq(&efivars_lock);
+			if (!atomic) {
+				if (down_interruptible(&efivars_lock)) {
+					err = -EINTR;
+					goto free;
+				}
+			}
 
 			break;
 		case EFI_NOT_FOUND:
@@ -520,8 +531,8 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 
 	} while (status != EFI_NOT_FOUND);
 
-	spin_unlock_irq(&efivars_lock);
-
+	up(&efivars_lock);
+free:
 	kfree(variable_name);
 
 	return err;
@@ -532,24 +543,34 @@ EXPORT_SYMBOL_GPL(efivar_init);
  * efivar_entry_add - add entry to variable list
  * @entry: entry to add to list
  * @head: list head
+ *
+ * Returns 0 on success, or a kernel error code on failure.
  */
-void efivar_entry_add(struct efivar_entry *entry, struct list_head *head)
+int efivar_entry_add(struct efivar_entry *entry, struct list_head *head)
 {
-	spin_lock_irq(&efivars_lock);
+	if (down_interruptible(&efivars_lock))
+		return -EINTR;
 	list_add(&entry->list, head);
-	spin_unlock_irq(&efivars_lock);
+	up(&efivars_lock);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(efivar_entry_add);
 
 /**
  * efivar_entry_remove - remove entry from variable list
  * @entry: entry to remove from list
+ *
+ * Returns 0 on success, or a kernel error code on failure.
  */
-void efivar_entry_remove(struct efivar_entry *entry)
+int efivar_entry_remove(struct efivar_entry *entry)
 {
-	spin_lock_irq(&efivars_lock);
+	if (down_interruptible(&efivars_lock))
+		return -EINTR;
 	list_del(&entry->list);
-	spin_unlock_irq(&efivars_lock);
+	up(&efivars_lock);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(efivar_entry_remove);
 
@@ -566,10 +587,10 @@ EXPORT_SYMBOL_GPL(efivar_entry_remove);
  */
 static void efivar_entry_list_del_unlock(struct efivar_entry *entry)
 {
-	lockdep_assert_held(&efivars_lock);
+	lockdep_assert_held(&efivars_lock.lock);
 
 	list_del(&entry->list);
-	spin_unlock_irq(&efivars_lock);
+	up(&efivars_lock);
 }
 
 /**
@@ -592,7 +613,7 @@ int __efivar_entry_delete(struct efivar_entry *entry)
 	const struct efivar_operations *ops = __efivars->ops;
 	efi_status_t status;
 
-	lockdep_assert_held(&efivars_lock);
+	lockdep_assert_held(&efivars_lock.lock);
 
 	status = ops->set_variable(entry->var.VariableName,
 				   &entry->var.VendorGuid,
@@ -610,20 +631,22 @@ EXPORT_SYMBOL_GPL(__efivar_entry_delete);
  * variable list. It is the caller's responsibility to free @entry
  * once we return.
  *
- * Returns 0 on success, or a converted EFI status code if
- * set_variable() fails.
+ * Returns 0 on success, -EINTR if we can't grab the semaphore,
+ * converted EFI status code if set_variable() fails.
  */
 int efivar_entry_delete(struct efivar_entry *entry)
 {
 	const struct efivar_operations *ops = __efivars->ops;
 	efi_status_t status;
 
-	spin_lock_irq(&efivars_lock);
+	if (down_interruptible(&efivars_lock))
+		return -EINTR;
+
 	status = ops->set_variable(entry->var.VariableName,
 				   &entry->var.VendorGuid,
 				   0, 0, NULL);
 	if (!(status == EFI_SUCCESS || status == EFI_NOT_FOUND)) {
-		spin_unlock_irq(&efivars_lock);
+		up(&efivars_lock);
 		return efi_status_to_err(status);
 	}
 
@@ -649,9 +672,9 @@ EXPORT_SYMBOL_GPL(efivar_entry_delete);
  * If @head is not NULL a lookup is performed to determine whether
  * the entry is already on the list.
  *
- * Returns 0 on success, -EEXIST if a lookup is performed and the entry
- * already exists on the list, or a converted EFI status code if
- * set_variable() fails.
+ * Returns 0 on success, -EINTR if we can't grab the semaphore,
+ * -EEXIST if a lookup is performed and the entry already exists on
+ * the list, or a converted EFI status code if set_variable() fails.
  */
 int efivar_entry_set(struct efivar_entry *entry, u32 attributes,
 		     unsigned long size, void *data, struct list_head *head)
@@ -661,10 +684,10 @@ int efivar_entry_set(struct efivar_entry *entry, u32 attributes,
 	efi_char16_t *name = entry->var.VariableName;
 	efi_guid_t vendor = entry->var.VendorGuid;
 
-	spin_lock_irq(&efivars_lock);
-
+	if (down_interruptible(&efivars_lock))
+		return -EINTR;
 	if (head && efivar_entry_find(name, vendor, head, false)) {
-		spin_unlock_irq(&efivars_lock);
+		up(&efivars_lock);
 		return -EEXIST;
 	}
 
@@ -673,7 +696,7 @@ int efivar_entry_set(struct efivar_entry *entry, u32 attributes,
 		status = ops->set_variable(name, &vendor,
 					   attributes, size, data);
 
-	spin_unlock_irq(&efivars_lock);
+	up(&efivars_lock);
 
 	return efi_status_to_err(status);
 
@@ -694,23 +717,22 @@ efivar_entry_set_nonblocking(efi_char16_t *name, efi_guid_t vendor,
 			     u32 attributes, unsigned long size, void *data)
 {
 	const struct efivar_operations *ops = __efivars->ops;
-	unsigned long flags;
 	efi_status_t status;
 
-	if (!spin_trylock_irqsave(&efivars_lock, flags))
+	if (down_trylock(&efivars_lock))
 		return -EBUSY;
 
 	status = check_var_size_nonblocking(attributes,
 					    size + ucs2_strsize(name, 1024));
 	if (status != EFI_SUCCESS) {
-		spin_unlock_irqrestore(&efivars_lock, flags);
+		up(&efivars_lock);
 		return -ENOSPC;
 	}
 
 	status = ops->set_variable_nonblocking(name, &vendor, attributes,
 					       size, data);
 
-	spin_unlock_irqrestore(&efivars_lock, flags);
+	up(&efivars_lock);
 	return efi_status_to_err(status);
 }
 
@@ -735,7 +757,6 @@ int efivar_entry_set_safe(efi_char16_t *name, efi_guid_t vendor, u32 attributes,
 			  bool block, unsigned long size, void *data)
 {
 	const struct efivar_operations *ops = __efivars->ops;
-	unsigned long flags;
 	efi_status_t status;
 
 	if (!ops->query_variable_store)
@@ -756,21 +777,22 @@ int efivar_entry_set_safe(efi_char16_t *name, efi_guid_t vendor, u32 attributes,
 						    size, data);
 
 	if (!block) {
-		if (!spin_trylock_irqsave(&efivars_lock, flags))
+		if (down_trylock(&efivars_lock))
 			return -EBUSY;
 	} else {
-		spin_lock_irqsave(&efivars_lock, flags);
+		if (down_interruptible(&efivars_lock))
+			return -EINTR;
 	}
 
 	status = check_var_size(attributes, size + ucs2_strsize(name, 1024));
 	if (status != EFI_SUCCESS) {
-		spin_unlock_irqrestore(&efivars_lock, flags);
+		up(&efivars_lock);
 		return -ENOSPC;
 	}
 
 	status = ops->set_variable(name, &vendor, attributes, size, data);
 
-	spin_unlock_irqrestore(&efivars_lock, flags);
+	up(&efivars_lock);
 
 	return efi_status_to_err(status);
 }
@@ -800,7 +822,7 @@ struct efivar_entry *efivar_entry_find(efi_char16_t *name, efi_guid_t guid,
 	int strsize1, strsize2;
 	bool found = false;
 
-	lockdep_assert_held(&efivars_lock);
+	lockdep_assert_held(&efivars_lock.lock);
 
 	list_for_each_entry_safe(entry, n, head, list) {
 		strsize1 = ucs2_strsize(name, 1024);
@@ -843,10 +865,11 @@ int efivar_entry_size(struct efivar_entry *entry, unsigned long *size)
 
 	*size = 0;
 
-	spin_lock_irq(&efivars_lock);
+	if (down_interruptible(&efivars_lock))
+		return -EINTR;
 	status = ops->get_variable(entry->var.VariableName,
 				   &entry->var.VendorGuid, NULL, size, NULL);
-	spin_unlock_irq(&efivars_lock);
+	up(&efivars_lock);
 
 	if (status != EFI_BUFFER_TOO_SMALL)
 		return efi_status_to_err(status);
@@ -872,7 +895,7 @@ int __efivar_entry_get(struct efivar_entry *entry, u32 *attributes,
 	const struct efivar_operations *ops = __efivars->ops;
 	efi_status_t status;
 
-	lockdep_assert_held(&efivars_lock);
+	lockdep_assert_held(&efivars_lock.lock);
 
 	status = ops->get_variable(entry->var.VariableName,
 				   &entry->var.VendorGuid,
@@ -895,11 +918,12 @@ int efivar_entry_get(struct efivar_entry *entry, u32 *attributes,
 	const struct efivar_operations *ops = __efivars->ops;
 	efi_status_t status;
 
-	spin_lock_irq(&efivars_lock);
+	if (down_interruptible(&efivars_lock))
+		return -EINTR;
 	status = ops->get_variable(entry->var.VariableName,
 				   &entry->var.VendorGuid,
 				   attributes, size, data);
-	spin_unlock_irq(&efivars_lock);
+	up(&efivars_lock);
 
 	return efi_status_to_err(status);
 }
@@ -946,7 +970,8 @@ int efivar_entry_set_get_size(struct efivar_entry *entry, u32 attributes,
 	 * set_variable call, and removal of the variable from the efivars
 	 * list (in the case of an authenticated delete).
 	 */
-	spin_lock_irq(&efivars_lock);
+	if (down_interruptible(&efivars_lock))
+		return -EINTR;
 
 	/*
 	 * Ensure that the available space hasn't shrunk below the safe level
@@ -986,7 +1011,7 @@ int efivar_entry_set_get_size(struct efivar_entry *entry, u32 attributes,
 	if (status == EFI_NOT_FOUND)
 		efivar_entry_list_del_unlock(entry);
 	else
-		spin_unlock_irq(&efivars_lock);
+		up(&efivars_lock);
 
 	if (status && status != EFI_BUFFER_TOO_SMALL)
 		return efi_status_to_err(status);
@@ -994,7 +1019,7 @@ int efivar_entry_set_get_size(struct efivar_entry *entry, u32 attributes,
 	return 0;
 
 out:
-	spin_unlock_irq(&efivars_lock);
+	up(&efivars_lock);
 	return err;
 
 }
@@ -1007,9 +1032,9 @@ EXPORT_SYMBOL_GPL(efivar_entry_set_get_size);
  * efivar_entry_iter_end() is called. This function is usually used in
  * conjunction with __efivar_entry_iter() or efivar_entry_iter().
  */
-void efivar_entry_iter_begin(void)
+int efivar_entry_iter_begin(void)
 {
-	spin_lock_irq(&efivars_lock);
+	return down_interruptible(&efivars_lock);
 }
 EXPORT_SYMBOL_GPL(efivar_entry_iter_begin);
 
@@ -1020,7 +1045,7 @@ EXPORT_SYMBOL_GPL(efivar_entry_iter_begin);
  */
 void efivar_entry_iter_end(void)
 {
-	spin_unlock_irq(&efivars_lock);
+	up(&efivars_lock);
 }
 EXPORT_SYMBOL_GPL(efivar_entry_iter_end);
 
@@ -1096,7 +1121,9 @@ int efivar_entry_iter(int (*func)(struct efivar_entry *, void *),
 {
 	int err = 0;
 
-	efivar_entry_iter_begin();
+	err = efivar_entry_iter_begin();
+	if (err)
+		return err;
 	err = __efivar_entry_iter(func, head, data, NULL);
 	efivar_entry_iter_end();
 
@@ -1141,12 +1168,17 @@ int efivars_register(struct efivars *efivars,
 		     const struct efivar_operations *ops,
 		     struct kobject *kobject)
 {
-	spin_lock_irq(&efivars_lock);
+	if (down_interruptible(&efivars_lock))
+		return -EINTR;
+
 	efivars->ops = ops;
 	efivars->kobject = kobject;
 
 	__efivars = efivars;
-	spin_unlock_irq(&efivars_lock);
+
+	pr_info("Registered efivars operations\n");
+
+	up(&efivars_lock);
 
 	return 0;
 }
@@ -1163,7 +1195,9 @@ int efivars_unregister(struct efivars *efivars)
 {
 	int rv;
 
-	spin_lock_irq(&efivars_lock);
+	if (down_interruptible(&efivars_lock))
+		return -EINTR;
+
 	if (!__efivars) {
 		printk(KERN_ERR "efivars not registered\n");
 		rv = -EINVAL;
@@ -1175,11 +1209,12 @@ int efivars_unregister(struct efivars *efivars)
 		goto out;
 	}
 
+	pr_info("Unregistered efivars operations\n");
 	__efivars = NULL;
 
 	rv = 0;
 out:
-	spin_unlock_irq(&efivars_lock);
+	up(&efivars_lock);
 	return rv;
 }
 EXPORT_SYMBOL_GPL(efivars_unregister);
diff --git a/fs/efivarfs/inode.c b/fs/efivarfs/inode.c
index e2ab6d0497f2..6d74a79b07d1 100644
--- a/fs/efivarfs/inode.c
+++ b/fs/efivarfs/inode.c
@@ -139,7 +139,10 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 
 	inode->i_private = var;
 
-	efivar_entry_add(var, &efivarfs_list);
+	err = efivar_entry_add(var, &efivarfs_list);
+	if (err)
+		goto out;
+
 	d_instantiate(dentry, inode);
 	dget(dentry);
 out:
diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 553c5d2db4a4..f3c511d3515a 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -162,7 +162,9 @@ static int efivarfs_callback(efi_char16_t *name16, efi_guid_t vendor,
 	kfree(name);
 
 	efivar_entry_size(entry, &size);
-	efivar_entry_add(entry, &efivarfs_list);
+	err = efivar_entry_add(entry, &efivarfs_list);
+	if (err)
+		goto fail_inode;
 
 	inode_lock(inode);
 	inode->i_private = entry;
@@ -183,7 +185,10 @@ fail:
 
 static int efivarfs_destroy(struct efivar_entry *entry, void *data)
 {
-	efivar_entry_remove(entry);
+	int err = efivar_entry_remove(entry);
+
+	if (err)
+		return err;
 	kfree(entry);
 	return 0;
 }
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 6af3bb24e4e9..b088eae349b8 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1225,8 +1225,8 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 		void *data, bool atomic, bool duplicates,
 		struct list_head *head);
 
-void efivar_entry_add(struct efivar_entry *entry, struct list_head *head);
-void efivar_entry_remove(struct efivar_entry *entry);
+int efivar_entry_add(struct efivar_entry *entry, struct list_head *head);
+int efivar_entry_remove(struct efivar_entry *entry);
 
 int __efivar_entry_delete(struct efivar_entry *entry);
 int efivar_entry_delete(struct efivar_entry *entry);
@@ -1243,7 +1243,7 @@ int efivar_entry_set_get_size(struct efivar_entry *entry, u32 attributes,
 int efivar_entry_set_safe(efi_char16_t *name, efi_guid_t vendor, u32 attributes,
 			  bool block, unsigned long size, void *data);
 
-void efivar_entry_iter_begin(void);
+int efivar_entry_iter_begin(void);
 void efivar_entry_iter_end(void);
 
 int __efivar_entry_iter(int (*func)(struct efivar_entry *, void *),
-- 
2.5.0
