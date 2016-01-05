From: Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>
Subject: [PATCH] efivars: use to_efivar_entry
Date: Tue,  5 Jan 2016 22:17:17 +0800
Message-ID: <044a291472c1df670c9b1247071f7af3a2c49a7d.1452003358.git.geliangtang@163.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Use to_efivar_entry() instead of open-coding it.

Signed-off-by: Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>
---
 drivers/firmware/efi/efivars.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 756eca8..c5b0d2b 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -386,7 +386,7 @@ static const struct sysfs_ops efivar_attr_ops = {
 
 static void efivar_release(struct kobject *kobj)
 {
-	struct efivar_entry *var = container_of(kobj, struct efivar_entry, kobj);
+	struct efivar_entry *var = to_efivar_entry(kobj);
 	kfree(var);
 }
 
-- 
2.5.0
