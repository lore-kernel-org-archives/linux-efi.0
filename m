From: ard <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 4/7] efi: add nonblocking option to efi_query_variable_store()
Date: Mon, 14 Dec 2015 11:40:28 +0100
Message-ID: <1450089631-26791-5-git-send-email-ard.biesheuvel@linaro.org>
References: <1450089631-26791-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450089631-26791-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

The function efi_query_variable_store() may be invoked by
efivar_entry_set_nonblocking(), which itself takes care to only call
a non-blocking version of the SetVariable() runtime wrapper. However,
efi_query_variable_store() may call the SetVariable() wrapper directly,
as well as the wrapper for QueryVariableInfo(), both of which could
deadlock in the same way we are trying to prevent by calling
efivar_entry_set_nonblocking() in the first place.

So instead, modify efi_query_variable_store() to use the non-blocking
variants of QueryVariableInfo() (and give up rather than free up space
if the available space is below EFI_MIN_RESERVE) if invoked with the
'nonblocking' argument set to true.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/x86/platform/efi/quirks.c | 33 +++++++++++++++++++-
 drivers/firmware/efi/vars.c    | 16 ++++++++--
 include/linux/efi.h            | 12 +++++--
 3 files changed, 55 insertions(+), 6 deletions(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 1c7380da65ff..261808c21a84 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -54,13 +54,41 @@ void efi_delete_dummy_variable(void)
 }
 
 /*
+ * In the nonblocking case we do not attempt to perform garbage
+ * collection if we do not have enough free space. Rather, we do the
+ * bare minimum check and give up immediately if the available space
+ * is below EFI_MIN_RESERVE.
+ *
+ * This function is intended to be small and simple because it is
+ * invoked from crash handler paths.
+ */
+static efi_status_t query_variable_store_nonblocking(u32 attributes,
+						     unsigned long size)
+{
+	efi_status_t status;
+	u64 storage_size, remaining_size, max_size;
+
+	status = efi.query_variable_info_nonblocking(attributes, &storage_size
+						     &remaining_size,
+						     &max_size);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	if (remaining_size - size < EFI_MIN_RESERVE)
+		return EFI_OUT_OF_RESOURCES;
+
+	return EFI_SUCCESS;
+}
+
+/*
  * Some firmware implementations refuse to boot if there's insufficient space
  * in the variable store. Ensure that we never use more than a safe limit.
  *
  * Return EFI_SUCCESS if it is safe to write 'size' bytes to the variable
  * store.
  */
-efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
+efi_status_t efi_query_variable_store(u32 attributes, unsigned long size,
+				      bool nonblocking)
 {
 	efi_status_t status;
 	u64 storage_size, remaining_size, max_size;
@@ -68,6 +96,9 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 	if (!(attributes & EFI_VARIABLE_NON_VOLATILE))
 		return 0;
 
+	if (nonblocking)
+		return query_variable_store_nonblocking(attributes, size);
+
 	status = efi.query_variable_info(attributes, &storage_size,
 					 &remaining_size, &max_size);
 	if (status != EFI_SUCCESS)
diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 70a0fb10517f..d2a49626a335 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -234,7 +234,18 @@ check_var_size(u32 attributes, unsigned long size)
 	if (!fops->query_variable_store)
 		return EFI_UNSUPPORTED;
 
-	return fops->query_variable_store(attributes, size);
+	return fops->query_variable_store(attributes, size, false);
+}
+
+static efi_status_t
+check_var_size_nonblocking(u32 attributes, unsigned long size)
+{
+	const struct efivar_operations *fops = __efivars->ops;
+
+	if (!fops->query_variable_store)
+		return EFI_UNSUPPORTED;
+
+	return fops->query_variable_store(attributes, size, true);
 }
 
 static int efi_status_to_err(efi_status_t status)
@@ -615,7 +626,8 @@ efivar_entry_set_nonblocking(efi_char16_t *name, efi_guid_t vendor,
 	if (!spin_trylock_irqsave(&__efivars->lock, flags))
 		return -EBUSY;
 
-	status = check_var_size(attributes, size + ucs2_strsize(name, 1024));
+	status = check_var_size_nonblocking(attributes,
+					    size + ucs2_strsize(name, 1024));
 	if (status != EFI_SUCCESS) {
 		spin_unlock_irqrestore(&__efivars->lock, flags);
 		return -ENOSPC;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index ad1e177ba48e..09f1559e7525 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -525,7 +525,9 @@ typedef efi_status_t efi_query_capsule_caps_t(efi_capsule_header_t **capsules,
 					      unsigned long count,
 					      u64 *max_size,
 					      int *reset_type);
-typedef efi_status_t efi_query_variable_store_t(u32 attributes, unsigned long size);
+typedef efi_status_t efi_query_variable_store_t(u32 attributes,
+						unsigned long size,
+						bool nonblocking);
 
 void efi_native_runtime_setup(void);
 
@@ -881,13 +883,17 @@ extern void efi_enter_virtual_mode (void);	/* switch EFI to virtual mode, if pos
 #ifdef CONFIG_X86
 extern void efi_late_init(void);
 extern void efi_free_boot_services(void);
-extern efi_status_t efi_query_variable_store(u32 attributes, unsigned long size);
+extern efi_status_t efi_query_variable_store(u32 attributes,
+					     unsigned long size,
+					     bool nonblocking);
 extern void efi_find_mirror(void);
 #else
 static inline void efi_late_init(void) {}
 static inline void efi_free_boot_services(void) {}
 
-static inline efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
+static inline efi_status_t efi_query_variable_store(u32 attributes,
+						    unsigned long size,
+						    bool nonblocking)
 {
 	return EFI_SUCCESS;
 }
-- 
2.5.0
