From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch] efi: fix an error code
Date: Thu, 13 Oct 2016 11:51:37 +0300
Message-ID: <20161013085137.GD16198@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

We should return -ENOMEM here, instead of success.

Fixes: 475fb4e8b2f4 ('efi / ACPI: load SSTDs from EFI variables')
Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 1ac199c..a4944e2 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -259,8 +259,10 @@ static __init int efivar_ssdt_load(void)
 		}
 
 		data = kmalloc(size, GFP_KERNEL);
-		if (!data)
+		if (!data) {
+			ret = -ENOMEM;
 			goto free_entry;
+		}
 
 		ret = efivar_entry_get(entry, NULL, &size, data);
 		if (ret) {
