From: sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/2] efi: Don't use spinlocks for efi vars
Date: Fri, 18 Dec 2015 11:29:50 +0100
Message-ID: <1450434591-31104-1-git-send-email-sylvain.chouleur@gmail.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

All efivars operations are protected by a spinlock which prevents
interruptions and preemption. This is too restricted, we just need a
lock preventing concurency.
The idea is to use a semaphore of count 1 and to have two ways of
locking, depending on the context:
 - In interrupt context, we call down_trylock(), if it fails we return
 an error
 - In normal context, we call down_interruptible()

We don't use a mutex here because the mutex_trylock() function must not
be called from interrupt context, whereas the down_trylock() can.

This patch also remove the efivars lock to use a single lock for the
whole vars.c file. The goal of this lock is to protect concurrent calls
to efi variable services, registering and unregistering.
This allows to register new efivars operations without having
in-progress call.

Signed-off-by: Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efi/efi-pstore.c |  34 +++++++---
 drivers/firmware/efi/efivars.c    |  10 ++-
 drivers/firmware/efi/vars.c       | 130 +++++++++++++++++++++++++-------------
 fs/efivarfs/inode.c               |   5 +-
 fs/efivarfs/super.c               |   8 ++-
 include/linux/efi.h               |  12 +---
 6 files changed, 130 insertions(+), 69 deletions(-)

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index eac76a79a880..c604af1243fd 100644
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
@@ -140,13 +143,16 @@ static inline void __efi_pstore_scan_sysfs_exit(struct efivar_entry *entry,
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
+	if (ret)
+		return ret;
 	if (stop)
-		__efi_pstore_scan_sysfs_exit(next, &next->list != head);
+		ret = __efi_pstore_scan_sysfs_exit(next, &next->list != head);
+	return ret;
 }
 
 /**
@@ -168,13 +174,17 @@ static int efi_pstore_sysfs_entry_iter(void *data, struct efivar_entry **pos)
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
@@ -186,7 +196,9 @@ static int efi_pstore_sysfs_entry_iter(void *data, struct efivar_entry **pos)
 		efi_pstore_scan_sysfs_enter((*pos), n, head);
 
 		size = efi_pstore_read_func((*pos), data);
-		efi_pstore_scan_sysfs_exit((*pos), n, head, size < 0);
+		ret = efi_pstore_scan_sysfs_exit((*pos), n, head, size < 0);
+		if (ret)
+			return ret;
 		if (size)
 			break;
 	}
@@ -226,7 +238,10 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
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
@@ -341,7 +356,8 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
 	edata.time = time;
 	edata.name = efi_name;
 
-	efivar_entry_iter_begin();
+	if (efivar_entry_iter_begin())
+		return -EINTR;
 	found = __efivar_entry_iter(efi_pstore_erase_func, &efivar_sysfs_list, &edata, &entry);
 
 	if (found && !entry->scanning) {
diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 756eca8c4cf8..3998373d92ef 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -509,7 +509,8 @@ static ssize_t efivar_delete(struct file *filp, struct kobject *kobj,
 		vendor = del_var->VendorGuid;
 	}
 
-	efivar_entry_iter_begin();
+	if (efivar_entry_iter_begin())
+		return -EINTR;
 	entry = efivar_entry_find(name, vendor, &efivar_sysfs_list, true);
 	if (!entry)
 		err = -EINVAL;
@@ -582,7 +583,8 @@ efivar_create_sysfs_entry(struct efivar_entry *new_var)
 		return ret;
 
 	kobject_uevent(&new_var->kobj, KOBJ_ADD);
-	efivar_entry_add(new_var, &efivar_sysfs_list);
+	if (efivar_entry_add(new_var, &efivar_sysfs_list))
+		return -EINTR;
 
 	return 0;
 }
@@ -697,7 +699,9 @@ static int efivars_sysfs_callback(efi_char16_t *name, efi_guid_t vendor,
 
 static int efivar_sysfs_destroy(struct efivar_entry *entry, void *data)
 {
-	efivar_entry_remove(entry);
+	int err = efivar_entry_remove(entry);
+	if (err)
+		return err;
 	efivar_unregister(entry);
 	return 0;
 }
diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 70a0fb10517f..8a44351211e5 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -37,6 +37,13 @@
 /* Private pointer to registered efivars */
 static struct efivars *__efivars;
 
+/*
+ * ->lock protects two things:
+ * 1) efivarfs_list and efivars_sysfs_list
+ * 2) ->ops calls
+ */
+DEFINE_SEMAPHORE(efivars_lock);
+
 static bool efivar_wq_enabled = true;
 DECLARE_WORK(efivar_work, NULL);
 EXPORT_SYMBOL_GPL(efivar_work);
@@ -376,7 +383,10 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 		return -ENOMEM;
 	}
 
-	spin_lock_irq(&__efivars->lock);
+	if (down_interruptible(&efivars_lock)) {
+		err = -EINTR;
+		goto free;
+	}
 
 	/*
 	 * Per EFI spec, the maximum storage allocated for both
@@ -392,7 +402,7 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 		switch (status) {
 		case EFI_SUCCESS:
 			if (!atomic)
-				spin_unlock_irq(&__efivars->lock);
+				up(&efivars_lock);
 
 			variable_name_size = var_name_strnsize(variable_name,
 							       variable_name_size);
@@ -410,7 +420,10 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 				dup_variable_bug(variable_name, &vendor_guid,
 						 variable_name_size);
 				if (!atomic)
-					spin_lock_irq(&__efivars->lock);
+					if (down_interruptible(&efivars_lock)) {
+						err = -EINTR;
+						goto free;
+					}
 
 				status = EFI_NOT_FOUND;
 				break;
@@ -421,7 +434,10 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 				status = EFI_NOT_FOUND;
 
 			if (!atomic)
-				spin_lock_irq(&__efivars->lock);
+				if (down_interruptible(&efivars_lock)) {
+					err = -EINTR;
+					goto free;
+				}
 
 			break;
 		case EFI_NOT_FOUND:
@@ -435,8 +451,8 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 
 	} while (status != EFI_NOT_FOUND);
 
-	spin_unlock_irq(&__efivars->lock);
-
+	up(&efivars_lock);
+free:
 	kfree(variable_name);
 
 	return err;
@@ -447,24 +463,34 @@ EXPORT_SYMBOL_GPL(efivar_init);
  * efivar_entry_add - add entry to variable list
  * @entry: entry to add to list
  * @head: list head
+ *
+ * Returns 0 on success, or a kernel error code on failure.
  */
-void efivar_entry_add(struct efivar_entry *entry, struct list_head *head)
+int efivar_entry_add(struct efivar_entry *entry, struct list_head *head)
 {
-	spin_lock_irq(&__efivars->lock);
+	if (down_interruptible(&efivars_lock))
+		return -EINTR;
 	list_add(&entry->list, head);
-	spin_unlock_irq(&__efivars->lock);
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
-	spin_lock_irq(&__efivars->lock);
+	if (down_interruptible(&efivars_lock))
+		return -EINTR;
 	list_del(&entry->list);
-	spin_unlock_irq(&__efivars->lock);
+	up(&efivars_lock);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(efivar_entry_remove);
 
@@ -481,10 +507,10 @@ EXPORT_SYMBOL_GPL(efivar_entry_remove);
  */
 static void efivar_entry_list_del_unlock(struct efivar_entry *entry)
 {
-	lockdep_assert_held(&__efivars->lock);
+	lockdep_assert_held(&efivars_lock.lock);
 
 	list_del(&entry->list);
-	spin_unlock_irq(&__efivars->lock);
+	up(&efivars_lock);
 }
 
 /**
@@ -507,7 +533,7 @@ int __efivar_entry_delete(struct efivar_entry *entry)
 	const struct efivar_operations *ops = __efivars->ops;
 	efi_status_t status;
 
-	lockdep_assert_held(&__efivars->lock);
+	lockdep_assert_held(&efivars_lock.lock);
 
 	status = ops->set_variable(entry->var.VariableName,
 				   &entry->var.VendorGuid,
@@ -533,12 +559,14 @@ int efivar_entry_delete(struct efivar_entry *entry)
 	const struct efivar_operations *ops = __efivars->ops;
 	efi_status_t status;
 
-	spin_lock_irq(&__efivars->lock);
+	if (down_interruptible(&efivars_lock))
+		return -EINTR;
+
 	status = ops->set_variable(entry->var.VariableName,
 				   &entry->var.VendorGuid,
 				   0, 0, NULL);
 	if (!(status == EFI_SUCCESS || status == EFI_NOT_FOUND)) {
-		spin_unlock_irq(&__efivars->lock);
+		up(&efivars_lock);
 		return efi_status_to_err(status);
 	}
 
@@ -576,10 +604,10 @@ int efivar_entry_set(struct efivar_entry *entry, u32 attributes,
 	efi_char16_t *name = entry->var.VariableName;
 	efi_guid_t vendor = entry->var.VendorGuid;
 
-	spin_lock_irq(&__efivars->lock);
-
+	if (down_interruptible(&efivars_lock))
+		return -EINTR;
 	if (head && efivar_entry_find(name, vendor, head, false)) {
-		spin_unlock_irq(&__efivars->lock);
+		up(&efivars_lock);
 		return -EEXIST;
 	}
 
@@ -588,7 +616,7 @@ int efivar_entry_set(struct efivar_entry *entry, u32 attributes,
 		status = ops->set_variable(name, &vendor,
 					   attributes, size, data);
 
-	spin_unlock_irq(&__efivars->lock);
+	up(&efivars_lock);
 
 	return efi_status_to_err(status);
 
@@ -602,29 +630,28 @@ EXPORT_SYMBOL_GPL(efivar_entry_set);
  * from crash/panic handlers.
  *
  * Crucially, this function will not block if it cannot acquire
- * __efivars->lock. Instead, it returns -EBUSY.
+ * efivars_lock. Instead, it returns -EBUSY.
  */
 static int
 efivar_entry_set_nonblocking(efi_char16_t *name, efi_guid_t vendor,
 			     u32 attributes, unsigned long size, void *data)
 {
 	const struct efivar_operations *ops = __efivars->ops;
-	unsigned long flags;
 	efi_status_t status;
 
-	if (!spin_trylock_irqsave(&__efivars->lock, flags))
+	if (down_trylock(&efivars_lock))
 		return -EBUSY;
 
 	status = check_var_size(attributes, size + ucs2_strsize(name, 1024));
 	if (status != EFI_SUCCESS) {
-		spin_unlock_irqrestore(&__efivars->lock, flags);
+		up(&efivars_lock);
 		return -ENOSPC;
 	}
 
 	status = ops->set_variable_nonblocking(name, &vendor, attributes,
 					       size, data);
 
-	spin_unlock_irqrestore(&__efivars->lock, flags);
+	up(&efivars_lock);
 	return efi_status_to_err(status);
 }
 
@@ -649,7 +676,6 @@ int efivar_entry_set_safe(efi_char16_t *name, efi_guid_t vendor, u32 attributes,
 			  bool block, unsigned long size, void *data)
 {
 	const struct efivar_operations *ops = __efivars->ops;
-	unsigned long flags;
 	efi_status_t status;
 
 	if (!ops->query_variable_store)
@@ -670,21 +696,22 @@ int efivar_entry_set_safe(efi_char16_t *name, efi_guid_t vendor, u32 attributes,
 						    size, data);
 
 	if (!block) {
-		if (!spin_trylock_irqsave(&__efivars->lock, flags))
+		if (down_trylock(&efivars_lock))
 			return -EBUSY;
 	} else {
-		spin_lock_irqsave(&__efivars->lock, flags);
+		if (down_interruptible(&efivars_lock))
+			return -EINTR;
 	}
 
 	status = check_var_size(attributes, size + ucs2_strsize(name, 1024));
 	if (status != EFI_SUCCESS) {
-		spin_unlock_irqrestore(&__efivars->lock, flags);
+		up(&efivars_lock);
 		return -ENOSPC;
 	}
 
 	status = ops->set_variable(name, &vendor, attributes, size, data);
 
-	spin_unlock_irqrestore(&__efivars->lock, flags);
+	up(&efivars_lock);
 
 	return efi_status_to_err(status);
 }
@@ -714,7 +741,7 @@ struct efivar_entry *efivar_entry_find(efi_char16_t *name, efi_guid_t guid,
 	int strsize1, strsize2;
 	bool found = false;
 
-	lockdep_assert_held(&__efivars->lock);
+	lockdep_assert_held(&efivars_lock.lock);
 
 	list_for_each_entry_safe(entry, n, head, list) {
 		strsize1 = ucs2_strsize(name, 1024);
@@ -757,10 +784,11 @@ int efivar_entry_size(struct efivar_entry *entry, unsigned long *size)
 
 	*size = 0;
 
-	spin_lock_irq(&__efivars->lock);
+	if (down_interruptible(&efivars_lock))
+		return -EINTR;
 	status = ops->get_variable(entry->var.VariableName,
 				   &entry->var.VendorGuid, NULL, size, NULL);
-	spin_unlock_irq(&__efivars->lock);
+	up(&efivars_lock);
 
 	if (status != EFI_BUFFER_TOO_SMALL)
 		return efi_status_to_err(status);
@@ -786,7 +814,7 @@ int __efivar_entry_get(struct efivar_entry *entry, u32 *attributes,
 	const struct efivar_operations *ops = __efivars->ops;
 	efi_status_t status;
 
-	lockdep_assert_held(&__efivars->lock);
+	lockdep_assert_held(&efivars_lock.lock);
 
 	status = ops->get_variable(entry->var.VariableName,
 				   &entry->var.VendorGuid,
@@ -809,11 +837,12 @@ int efivar_entry_get(struct efivar_entry *entry, u32 *attributes,
 	const struct efivar_operations *ops = __efivars->ops;
 	efi_status_t status;
 
-	spin_lock_irq(&__efivars->lock);
+	if (down_interruptible(&efivars_lock))
+		return -EINTR;
 	status = ops->get_variable(entry->var.VariableName,
 				   &entry->var.VendorGuid,
 				   attributes, size, data);
-	spin_unlock_irq(&__efivars->lock);
+	up(&efivars_lock);
 
 	return efi_status_to_err(status);
 }
@@ -860,7 +889,8 @@ int efivar_entry_set_get_size(struct efivar_entry *entry, u32 attributes,
 	 * set_variable call, and removal of the variable from the efivars
 	 * list (in the case of an authenticated delete).
 	 */
-	spin_lock_irq(&__efivars->lock);
+	if (down_interruptible(&efivars_lock))
+		return -EINTR;
 
 	/*
 	 * Ensure that the available space hasn't shrunk below the safe level
@@ -900,7 +930,7 @@ int efivar_entry_set_get_size(struct efivar_entry *entry, u32 attributes,
 	if (status == EFI_NOT_FOUND)
 		efivar_entry_list_del_unlock(entry);
 	else
-		spin_unlock_irq(&__efivars->lock);
+		up(&efivars_lock);
 
 	if (status && status != EFI_BUFFER_TOO_SMALL)
 		return efi_status_to_err(status);
@@ -908,7 +938,7 @@ int efivar_entry_set_get_size(struct efivar_entry *entry, u32 attributes,
 	return 0;
 
 out:
-	spin_unlock_irq(&__efivars->lock);
+	up(&efivars_lock);
 	return err;
 
 }
@@ -921,9 +951,9 @@ EXPORT_SYMBOL_GPL(efivar_entry_set_get_size);
  * efivar_entry_iter_end() is called. This function is usually used in
  * conjunction with __efivar_entry_iter() or efivar_entry_iter().
  */
-void efivar_entry_iter_begin(void)
+int efivar_entry_iter_begin(void)
 {
-	spin_lock_irq(&__efivars->lock);
+	return down_interruptible(&efivars_lock);
 }
 EXPORT_SYMBOL_GPL(efivar_entry_iter_begin);
 
@@ -934,7 +964,7 @@ EXPORT_SYMBOL_GPL(efivar_entry_iter_begin);
  */
 void efivar_entry_iter_end(void)
 {
-	spin_unlock_irq(&__efivars->lock);
+	up(&efivars_lock);
 }
 EXPORT_SYMBOL_GPL(efivar_entry_iter_end);
 
@@ -1010,7 +1040,9 @@ int efivar_entry_iter(int (*func)(struct efivar_entry *, void *),
 {
 	int err = 0;
 
-	efivar_entry_iter_begin();
+	err = efivar_entry_iter_begin();
+	if (err)
+		return err;
 	err = __efivar_entry_iter(func, head, data, NULL);
 	efivar_entry_iter_end();
 
@@ -1055,12 +1087,16 @@ int efivars_register(struct efivars *efivars,
 		     const struct efivar_operations *ops,
 		     struct kobject *kobject)
 {
-	spin_lock_init(&efivars->lock);
+	if (down_trylock(&efivars_lock))
+		return -EBUSY;
+
 	efivars->ops = ops;
 	efivars->kobject = kobject;
 
 	__efivars = efivars;
 
+	up(&efivars_lock);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(efivars_register);
@@ -1076,6 +1112,9 @@ int efivars_unregister(struct efivars *efivars)
 {
 	int rv;
 
+	if (down_trylock(&efivars_lock))
+		return -EBUSY;
+
 	if (!__efivars) {
 		printk(KERN_ERR "efivars not registered\n");
 		rv = -EINVAL;
@@ -1091,6 +1130,7 @@ int efivars_unregister(struct efivars *efivars)
 
 	rv = 0;
 out:
+	up(&efivars_lock);
 	return rv;
 }
 EXPORT_SYMBOL_GPL(efivars_unregister);
diff --git a/fs/efivarfs/inode.c b/fs/efivarfs/inode.c
index 3381b9da9ee6..5cea84ef7a44 100644
--- a/fs/efivarfs/inode.c
+++ b/fs/efivarfs/inode.c
@@ -132,7 +132,10 @@ static int efivarfs_create(struct inode *dir, struct dentry *dentry,
 
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
index 86a2121828c3..45ef421f545f 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -158,7 +158,9 @@ static int efivarfs_callback(efi_char16_t *name16, efi_guid_t vendor,
 	kfree(name);
 
 	efivar_entry_size(entry, &size);
-	efivar_entry_add(entry, &efivarfs_list);
+	err = efivar_entry_add(entry, &efivarfs_list);
+	if (err)
+		goto fail_inode;
 
 	mutex_lock(&inode->i_mutex);
 	inode->i_private = entry;
@@ -179,7 +181,9 @@ fail:
 
 static int efivarfs_destroy(struct efivar_entry *entry, void *data)
 {
-	efivar_entry_remove(entry);
+	int err = efivar_entry_remove(entry);
+	if (err)
+		return err;
 	kfree(entry);
 	return 0;
 }
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 569b5a866bb1..2e60803fa4ba 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1096,12 +1096,6 @@ struct efivar_operations {
 };
 
 struct efivars {
-	/*
-	 * ->lock protects two things:
-	 * 1) efivarfs_list and efivars_sysfs_list
-	 * 2) ->ops calls
-	 */
-	spinlock_t lock;
 	struct kset *kset;
 	struct kobject *kobject;
 	const struct efivar_operations *ops;
@@ -1169,8 +1163,8 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 		void *data, bool atomic, bool duplicates,
 		struct list_head *head);
 
-void efivar_entry_add(struct efivar_entry *entry, struct list_head *head);
-void efivar_entry_remove(struct efivar_entry *entry);
+int efivar_entry_add(struct efivar_entry *entry, struct list_head *head);
+int efivar_entry_remove(struct efivar_entry *entry);
 
 int __efivar_entry_delete(struct efivar_entry *entry);
 int efivar_entry_delete(struct efivar_entry *entry);
@@ -1187,7 +1181,7 @@ int efivar_entry_set_get_size(struct efivar_entry *entry, u32 attributes,
 int efivar_entry_set_safe(efi_char16_t *name, efi_guid_t vendor, u32 attributes,
 			  bool block, unsigned long size, void *data);
 
-void efivar_entry_iter_begin(void);
+int efivar_entry_iter_begin(void);
 void efivar_entry_iter_end(void);
 
 int __efivar_entry_iter(int (*func)(struct efivar_entry *, void *),
-- 
2.6.3
