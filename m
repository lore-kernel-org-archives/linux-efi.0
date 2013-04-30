From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [patch] efi: remove "kfree(NULL)"
Date: Tue, 30 Apr 2013 10:43:44 +0300
Message-ID: <20130430074344.GE7237@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

No need to free a NULL pointer.

Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 66928a3..7067b56 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -420,10 +420,8 @@ efivar_create_sysfs_entry(struct efivar_entry *new_var)
 
 	short_name = kzalloc(short_name_size, GFP_KERNEL);
 
-	if (!short_name) {
-		kfree(short_name);
+	if (!short_name)
 		return 1;
-	}
 
 	/* Convert Unicode to normal chars (assume top bits are 0),
 	   ala UTF-8 */
