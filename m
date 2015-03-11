From: Ross Lagerwall <ross.lagerwall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] efivarfs: Ensure VariableName is NULL-terminated
Date: Wed, 11 Mar 2015 12:00:55 +0000
Message-ID: <1426075255-18037-1-git-send-email-ross.lagerwall@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ross Lagerwall <ross.lagerwall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Some buggy firmware implementations update VariableNameSize on success
such that it does not include the final NULL character which results in
garbage in the efivarfs name entries.  Use kzalloc on the efivar_entry
(as is done in efivars.c) to ensure that the name is always
NULL-terminated.

Signed-off-by: Ross Lagerwall <ross.lagerwall-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
---
 fs/efivarfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index ddbce42..acf9a67 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -121,7 +121,7 @@ static int efivarfs_callback(efi_char16_t *name16, efi_guid_t vendor,
 	int len, i;
 	int err = -ENOMEM;
 
-	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry)
 		return err;
 
-- 
2.1.0
