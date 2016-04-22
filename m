From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/3] efi: use a file local lock for efivars
Date: Fri, 22 Apr 2016 09:13:21 +0200
Message-ID: <1461309203-11806-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1461309203-11806-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461309203-11806-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
Cc: sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch replaces the spinlock in the efivars struct with a single lock
for the whole vars.c file.  The goal of this lock is to protect concurrent
calls to efi variable services, registering and unregistering. This allows
us to register new efivars operations without having in-progress call.

Signed-off-by: Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/vars.c | 85 +++++++++++---------
 include/linux/efi.h         |  6 --
 2 files changed, 48 insertions(+), 43 deletions(-)

diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 0ac594c0a234..3dea50041c24 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -37,6 +37,14 @@
 /* Private pointer to registered efivars */
 static struct efivars *__efivars;
 
+/*
+ * efivars_lock protects three things:
+ * 1) efivarfs_list and efivars_sysfs_list
+ * 2) ->ops calls
+ * 3) (un)registration of __efivars
+ */
+static DEFINE_SPINLOCK(efivars_lock);
+
 static bool efivar_wq_enabled = true;
 DECLARE_WORK(efivar_work, NULL);
 EXPORT_SYMBOL_GPL(efivar_work);
@@ -453,7 +461,7 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 		return -ENOMEM;
 	}
 
-	spin_lock_irq(&__efivars->lock);
+	spin_lock_irq(&efivars_lock);
 
 	/*
 	 * Per EFI spec, the maximum storage allocated for both
@@ -469,7 +477,7 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 		switch (status) {
 		case EFI_SUCCESS:
 			if (!atomic)
-				spin_unlock_irq(&__efivars->lock);
+				spin_unlock_irq(&efivars_lock);
 
 			variable_name_size = var_name_strnsize(variable_name,
 							       variable_name_size);
@@ -487,7 +495,7 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 				dup_variable_bug(variable_name, &vendor_guid,
 						 variable_name_size);
 				if (!atomic)
-					spin_lock_irq(&__efivars->lock);
+					spin_lock_irq(&efivars_lock);
 
 				status = EFI_NOT_FOUND;
 				break;
@@ -498,7 +506,7 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 				status = EFI_NOT_FOUND;
 
 			if (!atomic)
-				spin_lock_irq(&__efivars->lock);
+				spin_lock_irq(&efivars_lock);
 
 			break;
 		case EFI_NOT_FOUND:
@@ -512,7 +520,7 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 
 	} while (status != EFI_NOT_FOUND);
 
-	spin_unlock_irq(&__efivars->lock);
+	spin_unlock_irq(&efivars_lock);
 
 	kfree(variable_name);
 
@@ -527,9 +535,9 @@ EXPORT_SYMBOL_GPL(efivar_init);
  */
 void efivar_entry_add(struct efivar_entry *entry, struct list_head *head)
 {
-	spin_lock_irq(&__efivars->lock);
+	spin_lock_irq(&efivars_lock);
 	list_add(&entry->list, head);
-	spin_unlock_irq(&__efivars->lock);
+	spin_unlock_irq(&efivars_lock);
 }
 EXPORT_SYMBOL_GPL(efivar_entry_add);
 
@@ -539,9 +547,9 @@ EXPORT_SYMBOL_GPL(efivar_entry_add);
  */
 void efivar_entry_remove(struct efivar_entry *entry)
 {
-	spin_lock_irq(&__efivars->lock);
+	spin_lock_irq(&efivars_lock);
 	list_del(&entry->list);
-	spin_unlock_irq(&__efivars->lock);
+	spin_unlock_irq(&efivars_lock);
 }
 EXPORT_SYMBOL_GPL(efivar_entry_remove);
 
@@ -558,10 +566,10 @@ EXPORT_SYMBOL_GPL(efivar_entry_remove);
  */
 static void efivar_entry_list_del_unlock(struct efivar_entry *entry)
 {
-	lockdep_assert_held(&__efivars->lock);
+	lockdep_assert_held(&efivars_lock);
 
 	list_del(&entry->list);
-	spin_unlock_irq(&__efivars->lock);
+	spin_unlock_irq(&efivars_lock);
 }
 
 /**
@@ -584,7 +592,7 @@ int __efivar_entry_delete(struct efivar_entry *entry)
 	const struct efivar_operations *ops = __efivars->ops;
 	efi_status_t status;
 
-	lockdep_assert_held(&__efivars->lock);
+	lockdep_assert_held(&efivars_lock);
 
 	status = ops->set_variable(entry->var.VariableName,
 				   &entry->var.VendorGuid,
@@ -610,12 +618,12 @@ int efivar_entry_delete(struct efivar_entry *entry)
 	const struct efivar_operations *ops = __efivars->ops;
 	efi_status_t status;
 
-	spin_lock_irq(&__efivars->lock);
+	spin_lock_irq(&efivars_lock);
 	status = ops->set_variable(entry->var.VariableName,
 				   &entry->var.VendorGuid,
 				   0, 0, NULL);
 	if (!(status == EFI_SUCCESS || status == EFI_NOT_FOUND)) {
-		spin_unlock_irq(&__efivars->lock);
+		spin_unlock_irq(&efivars_lock);
 		return efi_status_to_err(status);
 	}
 
@@ -653,10 +661,10 @@ int efivar_entry_set(struct efivar_entry *entry, u32 attributes,
 	efi_char16_t *name = entry->var.VariableName;
 	efi_guid_t vendor = entry->var.VendorGuid;
 
-	spin_lock_irq(&__efivars->lock);
+	spin_lock_irq(&efivars_lock);
 
 	if (head && efivar_entry_find(name, vendor, head, false)) {
-		spin_unlock_irq(&__efivars->lock);
+		spin_unlock_irq(&efivars_lock);
 		return -EEXIST;
 	}
 
@@ -665,7 +673,7 @@ int efivar_entry_set(struct efivar_entry *entry, u32 attributes,
 		status = ops->set_variable(name, &vendor,
 					   attributes, size, data);
 
-	spin_unlock_irq(&__efivars->lock);
+	spin_unlock_irq(&efivars_lock);
 
 	return efi_status_to_err(status);
 
@@ -679,7 +687,7 @@ EXPORT_SYMBOL_GPL(efivar_entry_set);
  * from crash/panic handlers.
  *
  * Crucially, this function will not block if it cannot acquire
- * __efivars->lock. Instead, it returns -EBUSY.
+ * efivars_lock. Instead, it returns -EBUSY.
  */
 static int
 efivar_entry_set_nonblocking(efi_char16_t *name, efi_guid_t vendor,
@@ -689,20 +697,20 @@ efivar_entry_set_nonblocking(efi_char16_t *name, efi_guid_t vendor,
 	unsigned long flags;
 	efi_status_t status;
 
-	if (!spin_trylock_irqsave(&__efivars->lock, flags))
+	if (!spin_trylock_irqsave(&efivars_lock, flags))
 		return -EBUSY;
 
 	status = check_var_size_nonblocking(attributes,
 					    size + ucs2_strsize(name, 1024));
 	if (status != EFI_SUCCESS) {
-		spin_unlock_irqrestore(&__efivars->lock, flags);
+		spin_unlock_irqrestore(&efivars_lock, flags);
 		return -ENOSPC;
 	}
 
 	status = ops->set_variable_nonblocking(name, &vendor, attributes,
 					       size, data);
 
-	spin_unlock_irqrestore(&__efivars->lock, flags);
+	spin_unlock_irqrestore(&efivars_lock, flags);
 	return efi_status_to_err(status);
 }
 
@@ -748,21 +756,21 @@ int efivar_entry_set_safe(efi_char16_t *name, efi_guid_t vendor, u32 attributes,
 						    size, data);
 
 	if (!block) {
-		if (!spin_trylock_irqsave(&__efivars->lock, flags))
+		if (!spin_trylock_irqsave(&efivars_lock, flags))
 			return -EBUSY;
 	} else {
-		spin_lock_irqsave(&__efivars->lock, flags);
+		spin_lock_irqsave(&efivars_lock, flags);
 	}
 
 	status = check_var_size(attributes, size + ucs2_strsize(name, 1024));
 	if (status != EFI_SUCCESS) {
-		spin_unlock_irqrestore(&__efivars->lock, flags);
+		spin_unlock_irqrestore(&efivars_lock, flags);
 		return -ENOSPC;
 	}
 
 	status = ops->set_variable(name, &vendor, attributes, size, data);
 
-	spin_unlock_irqrestore(&__efivars->lock, flags);
+	spin_unlock_irqrestore(&efivars_lock, flags);
 
 	return efi_status_to_err(status);
 }
@@ -792,7 +800,7 @@ struct efivar_entry *efivar_entry_find(efi_char16_t *name, efi_guid_t guid,
 	int strsize1, strsize2;
 	bool found = false;
 
-	lockdep_assert_held(&__efivars->lock);
+	lockdep_assert_held(&efivars_lock);
 
 	list_for_each_entry_safe(entry, n, head, list) {
 		strsize1 = ucs2_strsize(name, 1024);
@@ -835,10 +843,10 @@ int efivar_entry_size(struct efivar_entry *entry, unsigned long *size)
 
 	*size = 0;
 
-	spin_lock_irq(&__efivars->lock);
+	spin_lock_irq(&efivars_lock);
 	status = ops->get_variable(entry->var.VariableName,
 				   &entry->var.VendorGuid, NULL, size, NULL);
-	spin_unlock_irq(&__efivars->lock);
+	spin_unlock_irq(&efivars_lock);
 
 	if (status != EFI_BUFFER_TOO_SMALL)
 		return efi_status_to_err(status);
@@ -864,7 +872,7 @@ int __efivar_entry_get(struct efivar_entry *entry, u32 *attributes,
 	const struct efivar_operations *ops = __efivars->ops;
 	efi_status_t status;
 
-	lockdep_assert_held(&__efivars->lock);
+	lockdep_assert_held(&efivars_lock);
 
 	status = ops->get_variable(entry->var.VariableName,
 				   &entry->var.VendorGuid,
@@ -887,11 +895,11 @@ int efivar_entry_get(struct efivar_entry *entry, u32 *attributes,
 	const struct efivar_operations *ops = __efivars->ops;
 	efi_status_t status;
 
-	spin_lock_irq(&__efivars->lock);
+	spin_lock_irq(&efivars_lock);
 	status = ops->get_variable(entry->var.VariableName,
 				   &entry->var.VendorGuid,
 				   attributes, size, data);
-	spin_unlock_irq(&__efivars->lock);
+	spin_unlock_irq(&efivars_lock);
 
 	return efi_status_to_err(status);
 }
@@ -938,7 +946,7 @@ int efivar_entry_set_get_size(struct efivar_entry *entry, u32 attributes,
 	 * set_variable call, and removal of the variable from the efivars
 	 * list (in the case of an authenticated delete).
 	 */
-	spin_lock_irq(&__efivars->lock);
+	spin_lock_irq(&efivars_lock);
 
 	/*
 	 * Ensure that the available space hasn't shrunk below the safe level
@@ -978,7 +986,7 @@ int efivar_entry_set_get_size(struct efivar_entry *entry, u32 attributes,
 	if (status == EFI_NOT_FOUND)
 		efivar_entry_list_del_unlock(entry);
 	else
-		spin_unlock_irq(&__efivars->lock);
+		spin_unlock_irq(&efivars_lock);
 
 	if (status && status != EFI_BUFFER_TOO_SMALL)
 		return efi_status_to_err(status);
@@ -986,7 +994,7 @@ int efivar_entry_set_get_size(struct efivar_entry *entry, u32 attributes,
 	return 0;
 
 out:
-	spin_unlock_irq(&__efivars->lock);
+	spin_unlock_irq(&efivars_lock);
 	return err;
 
 }
@@ -1001,7 +1009,7 @@ EXPORT_SYMBOL_GPL(efivar_entry_set_get_size);
  */
 void efivar_entry_iter_begin(void)
 {
-	spin_lock_irq(&__efivars->lock);
+	spin_lock_irq(&efivars_lock);
 }
 EXPORT_SYMBOL_GPL(efivar_entry_iter_begin);
 
@@ -1012,7 +1020,7 @@ EXPORT_SYMBOL_GPL(efivar_entry_iter_begin);
  */
 void efivar_entry_iter_end(void)
 {
-	spin_unlock_irq(&__efivars->lock);
+	spin_unlock_irq(&efivars_lock);
 }
 EXPORT_SYMBOL_GPL(efivar_entry_iter_end);
 
@@ -1133,11 +1141,12 @@ int efivars_register(struct efivars *efivars,
 		     const struct efivar_operations *ops,
 		     struct kobject *kobject)
 {
-	spin_lock_init(&efivars->lock);
+	spin_lock_irq(&efivars_lock);
 	efivars->ops = ops;
 	efivars->kobject = kobject;
 
 	__efivars = efivars;
+	spin_unlock_irq(&efivars_lock);
 
 	return 0;
 }
@@ -1154,6 +1163,7 @@ int efivars_unregister(struct efivars *efivars)
 {
 	int rv;
 
+	spin_lock_irq(&efivars_lock);
 	if (!__efivars) {
 		printk(KERN_ERR "efivars not registered\n");
 		rv = -EINVAL;
@@ -1169,6 +1179,7 @@ int efivars_unregister(struct efivars *efivars)
 
 	rv = 0;
 out:
+	spin_unlock_irq(&efivars_lock);
 	return rv;
 }
 EXPORT_SYMBOL_GPL(efivars_unregister);
diff --git a/include/linux/efi.h b/include/linux/efi.h
index e29a31d0fc35..6af3bb24e4e9 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1158,12 +1158,6 @@ struct efivar_operations {
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
-- 
2.5.0
