From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/4] efi: efivars: don't rely on blocking operations in non-blocking set_var()
Date: Thu, 19 Nov 2015 14:36:29 +0100
Message-ID: <1447940191-30705-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1447940191-30705-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1447940191-30705-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The non-blocking version of efivar_entry_set() gives up directly on
failure to acquire __efivars->lock. However, it also calls check_var_size(),
whose implementation calls the ordinary query_variable_info() and
set_variable() runtime service wrappers, meaning we could still deadlock
if efivar_entry_set_nonblocking() is called from an atomic context that
interrupted a runtime service already in progress on the same CPU.

So drop the call to check_var_size(). This is potentially unsafe on some
UEFI implementations that fail to boot if the varstore fills up, but
those systems are unlikely to be using efi-pstore in the first place.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/vars.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 70a0fb10517f..caccdbffc1d0 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -615,12 +615,6 @@ efivar_entry_set_nonblocking(efi_char16_t *name, efi_guid_t vendor,
 	if (!spin_trylock_irqsave(&__efivars->lock, flags))
 		return -EBUSY;
 
-	status = check_var_size(attributes, size + ucs2_strsize(name, 1024));
-	if (status != EFI_SUCCESS) {
-		spin_unlock_irqrestore(&__efivars->lock, flags);
-		return -ENOSPC;
-	}
-
 	status = ops->set_variable_nonblocking(name, &vendor, attributes,
 					       size, data);
 
@@ -652,9 +646,6 @@ int efivar_entry_set_safe(efi_char16_t *name, efi_guid_t vendor, u32 attributes,
 	unsigned long flags;
 	efi_status_t status;
 
-	if (!ops->query_variable_store)
-		return -ENOSYS;
-
 	/*
 	 * If the EFI variable backend provides a non-blocking
 	 * ->set_variable() operation and we're in a context where we
@@ -669,6 +660,9 @@ int efivar_entry_set_safe(efi_char16_t *name, efi_guid_t vendor, u32 attributes,
 		return efivar_entry_set_nonblocking(name, vendor, attributes,
 						    size, data);
 
+	if (!ops->query_variable_store)
+		return -ENOSYS;
+
 	if (!block) {
 		if (!spin_trylock_irqsave(&__efivars->lock, flags))
 			return -EBUSY;
-- 
1.9.1
