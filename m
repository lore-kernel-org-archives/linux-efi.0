From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch] efi: locking fix in efivar_entry_set_safe()
Date: Tue, 30 Apr 2013 10:43:12 +0300
Message-ID: <20130430074312.GD7237@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Gundersen <teg-B22kvLQNl6c@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

The intent is that if we aren't allowed to block because we're in an
NMI or an emergency then we only take the lock if it is uncontended.

Part of the problem is the test is reversed so we return -EBUSY if we
acquire the lock.

Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
Static checker stuff.  I haven't tested this.

diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 1d80c1c..f34d8fe 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -622,10 +622,12 @@ int efivar_entry_set_safe(efi_char16_t *name, efi_guid_t vendor, u32 attributes,
 	if (!ops->query_variable_store)
 		return -ENOSYS;
 
-	if (!block && spin_trylock_irqsave(&__efivars->lock, flags))
-		return -EBUSY;
-	else
+	if (!block) {
+		if (!spin_trylock_irqsave(&__efivars->lock, flags))
+			return -EBUSY;
+	} else {
 		spin_lock_irqsave(&__efivars->lock, flags);
+	}
 
 	status = check_var_size(attributes, size + ucs2_strsize(name, 1024));
 	if (status != EFI_SUCCESS) {
