From: Pan Bian <bianpan2016-9Onoh4P/yGk@public.gmane.org>
Subject: efi/esrt: use memunmap rather kfree to free the remapping
Date: Sun, 29 Oct 2017 22:51:02 +0800
Message-ID: <1509288662-7880-1-git-send-email-bianpan2016@163.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pan Bian <bianpan2016-9Onoh4P/yGk@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The remapping result of memremap should be freed with memunmap, not
kfree.

Signed-off-by: Pan Bian <bianpan2016-9Onoh4P/yGk@public.gmane.org>
---
 drivers/firmware/efi/esrt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/esrt.c b/drivers/firmware/efi/esrt.c
index bd7ed3c..3ef7001 100644
--- a/drivers/firmware/efi/esrt.c
+++ b/drivers/firmware/efi/esrt.c
@@ -431,7 +431,7 @@ static int __init esrt_sysfs_init(void)
 err_remove_esrt:
 	kobject_put(esrt_kobj);
 err:
-	kfree(esrt);
+	memunmap(esrt);
 	esrt = NULL;
 	return error;
 }
-- 
1.9.1
