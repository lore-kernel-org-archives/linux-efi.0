From: Vaishali Thakkar <vaishali.thakkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] efi: Use GFP_ATOMIC instead of GFP_KERNEL
Date: Mon, 11 Apr 2016 16:23:29 +0530
Message-ID: <1460372009-10785-1-git-send-email-vaishali.thakkar@oracle.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vaishali Thakkar <vaishali.thakkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Function dup_variable_bug is called inside the spinlock.
This may lead to issues when kzalloc sleeps, so it is
better to use GFP_ATOMIC in this spinlocked context.

Problem found using Coccinelle.

Signed-off-by: Vaishali Thakkar <vaishali.thakkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/firmware/efi/vars.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 0ac594c..d5e2f28 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -411,7 +411,7 @@ static void dup_variable_bug(efi_char16_t *str16, efi_guid_t *vendor_guid,
 	 */
 	efivar_wq_enabled = false;
 
-	str8 = kzalloc(len8, GFP_KERNEL);
+	str8 = kzalloc(len8, GFP_ATOMIC);
 	if (!str8)
 		return;
 
-- 
2.1.4
