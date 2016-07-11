From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 1/3] efi: use a file local lock for efivars
Date: Mon, 11 Jul 2016 16:59:23 +0200
Message-ID: <1468249165-25523-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1468249165-25523-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468249165-25523-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch replaces the spinlock in the efivars struct with a single lock
for the whole vars.c file.  The goal of this lock is to protect concurrent
calls to efi variable services, registering and unregistering. This allows
us to register new efivars operations without having in-progress call.

Signed-off-by: Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
[ardb: rebased onto v4.7-rc3]
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/vars.c | 83 +++++++++++---------
 include/linux/efi.h         |  6 --
 2 files changed, 47 insertions(+), 42 deletions(-)

diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index d3b751383286..d0d807e1287e 100644
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
@@ -434,7 +442,7 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 		return -ENOMEM;
 	}
 
-	spin_lock_irq(&__efivars->lock);
+	spin_lock_irq(&efivars_lock);
 
 	/*
 	 * Per EFI spec, the maximum storage allocated for both
@@ -450,7 +458,7 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 		switch (status) {
 		case EFI_SUCCESS:
 			if (duplicates)
-				spin_unlock_irq(&__efivars->lock);
+				spin_unlock_irq(&efivars_lock);
 
 			variable_name_size = var_name_strnsize(variable_name,
 							       variable_name_size);
@@ -477,7 +485,7 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 			}
 
 			if (duplicates)
-				spin_lock_irq(&__efivars->lock);
+				spin_lock_irq(&efivars_lock);
 
 			break;
 		case EFI_NOT_FOUND:
@@ -491,7 +499,7 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 
 	} while (status != EFI_NOT_FOUND);
 
-	spin_unlock_irq(&__efivars->lock);
+	spin_unlock_irq(&efivars_lock);
 
 	kfree(variable_name);
 
@@ -506,9 +514,9 @@ EXPORT_SYMBOL_GPL(efivar_init);
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
 
@@ -518,9 +526,9 @@ EXPORT_SYMBOL_GPL(efivar_entry_add);
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
 
@@ -537,10 +545,10 @@ EXPORT_SYMBOL_GPL(efivar_entry_remove);
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
@@ -563,7 +571,7 @@ int __efivar_entry_delete(struct efivar_entry *entry)
 	const struct efivar_operations *ops = __efivars->ops;
 	efi_status_t status;
 
-	lockdep_assert_held(&__efivars->lock);
+	lockdep_assert_held(&efivars_lock);
 
 	status = ops->set_variable(entry->var.VariableName,
 				   &entry->var.VendorGuid,
@@ -589,12 +597,12 @@ int efivar_entry_delete(struct efivar_entry *entry)
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
 
@@ -632,10 +640,10 @@ int efivar_entry_set(struct efivar_entry *entry, u32 attributes,
 	efi_char16_t *name = entry->var.VariableName;
 	efi_guid_t vendor = entry->var.VendorGuid;
 
-	spin_lock_irq(&__efivars->lock);
+	spin_lock_irq(&efivars_lock);
 
 	if (head && efivar_entry_find(name, vendor, head, false)) {
-		spin_unlock_irq(&__efivars->lock);
+		spin_unlock_irq(&efivars_lock);
 		return -EEXIST;
 	}
 
@@ -644,7 +652,7 @@ int efivar_entry_set(struct efivar_entry *entry, u32 attributes,
 		status = ops->set_variable(name, &vendor,
 					   attributes, size, data);
 
-	spin_unlock_irq(&__efivars->lock);
+	spin_unlock_irq(&efivars_lock);
 
 	return efi_status_to_err(status);
 
@@ -658,7 +666,7 @@ EXPORT_SYMBOL_GPL(efivar_entry_set);
  * from crash/panic handlers.
  *
  * Crucially, this function will not block if it cannot acquire
- * __efivars->lock. Instead, it returns -EBUSY.
+ * efivars_lock. Instead, it returns -EBUSY.
  */
 static int
 efivar_entry_set_nonblocking(efi_char16_t *name, efi_guid_t vendor,
@@ -668,20 +676,20 @@ efivar_entry_set_nonblocking(efi_char16_t *name, efi_guid_t vendor,
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
 
@@ -727,21 +735,21 @@ int efivar_entry_set_safe(efi_char16_t *name, efi_guid_t vendor, u32 attributes,
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
@@ -771,7 +779,7 @@ struct efivar_entry *efivar_entry_find(efi_char16_t *name, efi_guid_t guid,
 	int strsize1, strsize2;
 	bool found = false;
 
-	lockdep_assert_held(&__efivars->lock);
+	lockdep_assert_held(&efivars_lock);
 
 	list_for_each_entry_safe(entry, n, head, list) {
 		strsize1 = ucs2_strsize(name, 1024);
@@ -814,10 +822,10 @@ int efivar_entry_size(struct efivar_entry *entry, unsigned long *size)
 
 	*size = 0;
 
-	spin_lock_irq(&__efivars->lock);
+	spin_lock_irq(&efivars_lock);
 	status = ops->get_variable(entry->var.VariableName,
 				   &entry->var.VendorGuid, NULL, size, NULL);
-	spin_unlock_irq(&__efivars->lock);
+	spin_unlock_irq(&efivars_lock);
 
 	if (status != EFI_BUFFER_TOO_SMALL)
 		return efi_status_to_err(status);
@@ -843,7 +851,7 @@ int __efivar_entry_get(struct efivar_entry *entry, u32 *attributes,
 	const struct efivar_operations *ops = __efivars->ops;
 	efi_status_t status;
 
-	lockdep_assert_held(&__efivars->lock);
+	lockdep_assert_held(&efivars_lock);
 
 	status = ops->get_variable(entry->var.VariableName,
 				   &entry->var.VendorGuid,
@@ -866,11 +874,11 @@ int efivar_entry_get(struct efivar_entry *entry, u32 *attributes,
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
@@ -917,7 +925,7 @@ int efivar_entry_set_get_size(struct efivar_entry *entry, u32 attributes,
 	 * set_variable call, and removal of the variable from the efivars
 	 * list (in the case of an authenticated delete).
 	 */
-	spin_lock_irq(&__efivars->lock);
+	spin_lock_irq(&efivars_lock);
 
 	/*
 	 * Ensure that the available space hasn't shrunk below the safe level
@@ -957,7 +965,7 @@ int efivar_entry_set_get_size(struct efivar_entry *entry, u32 attributes,
 	if (status == EFI_NOT_FOUND)
 		efivar_entry_list_del_unlock(entry);
 	else
-		spin_unlock_irq(&__efivars->lock);
+		spin_unlock_irq(&efivars_lock);
 
 	if (status && status != EFI_BUFFER_TOO_SMALL)
 		return efi_status_to_err(status);
@@ -965,7 +973,7 @@ int efivar_entry_set_get_size(struct efivar_entry *entry, u32 attributes,
 	return 0;
 
 out:
-	spin_unlock_irq(&__efivars->lock);
+	spin_unlock_irq(&efivars_lock);
 	return err;
 
 }
@@ -980,7 +988,7 @@ EXPORT_SYMBOL_GPL(efivar_entry_set_get_size);
  */
 void efivar_entry_iter_begin(void)
 {
-	spin_lock_irq(&__efivars->lock);
+	spin_lock_irq(&efivars_lock);
 }
 EXPORT_SYMBOL_GPL(efivar_entry_iter_begin);
 
@@ -991,7 +999,7 @@ EXPORT_SYMBOL_GPL(efivar_entry_iter_begin);
  */
 void efivar_entry_iter_end(void)
 {
-	spin_unlock_irq(&__efivars->lock);
+	spin_unlock_irq(&efivars_lock);
 }
 EXPORT_SYMBOL_GPL(efivar_entry_iter_end);
 
@@ -1112,11 +1120,12 @@ int efivars_register(struct efivars *efivars,
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
@@ -1133,6 +1142,7 @@ int efivars_unregister(struct efivars *efivars)
 {
 	int rv;
 
+	spin_lock_irq(&efivars_lock);
 	if (!__efivars) {
 		printk(KERN_ERR "efivars not registered\n");
 		rv = -EINVAL;
@@ -1148,6 +1158,7 @@ int efivars_unregister(struct efivars *efivars)
 
 	rv = 0;
 out:
+	spin_unlock_irq(&efivars_lock);
 	return rv;
 }
 EXPORT_SYMBOL_GPL(efivars_unregister);
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 407b15abc227..ab05bfa6464d 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1230,12 +1230,6 @@ struct efivar_operations {
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
1.9.1
