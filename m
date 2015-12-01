From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 4/7] efi: add nonblocking option to efi_query_variable_store()
Date: Tue,  1 Dec 2015 11:50:17 +0100
Message-ID: <1448967020-20190-5-git-send-email-ard.biesheuvel@linaro.org>
References: <1448967020-20190-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1448967020-20190-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The function efi_query_variable_store() may be invoked by
efivar_entry_set_nonblocking(), which itself takes care to only call
a non-blocking version of the SetVariable() runtime wrapper. However,
efi_query_variable_store() may call the SetVariable() wrapper directly,
as well as the wrapper for QueryVariableInfo(), both of which could
deadlock in the same way we are trying to prevent by calling
efivar_entry_set_nonblocking() in the first place.

So instead, modify efi_query_variable_store() to use the non-blocking
variants of both SetVariable() and QueryVariableInfo() if invoked with
the 'nonblocking' argument set to true.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/x86/platform/efi/quirks.c | 37 ++++++++++++++------
 drivers/firmware/efi/vars.c    | 16 +++++++--
 include/linux/efi.h            | 12 +++++--
 3 files changed, 49 insertions(+), 16 deletions(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 1c7380da65ff..cbe542f5c75d 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -60,16 +60,27 @@ void efi_delete_dummy_variable(void)
  * Return EFI_SUCCESS if it is safe to write 'size' bytes to the variable
  * store.
  */
-efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
+efi_status_t efi_query_variable_store(u32 attributes, unsigned long size,
+				      bool nonblocking)
 {
 	efi_status_t status;
 	u64 storage_size, remaining_size, max_size;
+	efi_set_variable_t *set_variable;
+	efi_query_variable_info_t *query_variable_info;
 
 	if (!(attributes & EFI_VARIABLE_NON_VOLATILE))
 		return 0;
 
-	status = efi.query_variable_info(attributes, &storage_size,
-					 &remaining_size, &max_size);
+	if (nonblocking) {
+		set_variable = efi.set_variable_nonblocking;
+		query_variable_info = efi.query_variable_info_nonblocking;
+	} else {
+		set_variable = efi.set_variable;
+		query_variable_info = efi.query_variable_info;
+	}
+
+	status = query_variable_info(attributes, &storage_size,
+				     &remaining_size, &max_size);
 	if (status != EFI_SUCCESS)
 		return status;
 
@@ -92,18 +103,22 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 		if (!dummy)
 			return EFI_OUT_OF_RESOURCES;
 
-		status = efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
-					  EFI_VARIABLE_NON_VOLATILE |
-					  EFI_VARIABLE_BOOTSERVICE_ACCESS |
-					  EFI_VARIABLE_RUNTIME_ACCESS,
-					  dummy_size, dummy);
+		status = set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
+				      EFI_VARIABLE_NON_VOLATILE |
+				      EFI_VARIABLE_BOOTSERVICE_ACCESS |
+				      EFI_VARIABLE_RUNTIME_ACCESS,
+				      dummy_size, dummy);
 
 		if (status == EFI_SUCCESS) {
 			/*
 			 * This should have failed, so if it didn't make sure
 			 * that we delete it...
 			 */
-			efi_delete_dummy_variable();
+			set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
+				     EFI_VARIABLE_NON_VOLATILE |
+				     EFI_VARIABLE_BOOTSERVICE_ACCESS |
+				     EFI_VARIABLE_RUNTIME_ACCESS,
+				     0, NULL);
 		}
 
 		kfree(dummy);
@@ -112,8 +127,8 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 		 * The runtime code may now have triggered a garbage collection
 		 * run, so check the variable info again
 		 */
-		status = efi.query_variable_info(attributes, &storage_size,
-						 &remaining_size, &max_size);
+		status = query_variable_info(attributes, &storage_size,
+					     &remaining_size, &max_size);
 
 		if (status != EFI_SUCCESS)
 			return status;
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
1.9.1
