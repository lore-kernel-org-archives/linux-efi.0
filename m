From: Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
Subject: [PATCH] efi/esrt: don't preformat name
Date: Fri, 20 Nov 2015 11:30:17 +0100
Message-ID: <1448015417-16712-1-git-send-email-linux@rasmusvillemoes.dk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

kobject_init_and_add takes a format string+args, so there's no reason
to do this formatting in advance.

Signed-off-by: Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>
---
 drivers/firmware/efi/esrt.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/esrt.c b/drivers/firmware/efi/esrt.c
index 22c5285f7705..75feb3f5829b 100644
--- a/drivers/firmware/efi/esrt.c
+++ b/drivers/firmware/efi/esrt.c
@@ -167,14 +167,11 @@ static struct kset *esrt_kset;
 static int esre_create_sysfs_entry(void *esre, int entry_num)
 {
 	struct esre_entry *entry;
-	char name[20];
 
 	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry)
 		return -ENOMEM;
 
-	sprintf(name, "entry%d", entry_num);
-
 	entry->kobj.kset = esrt_kset;
 
 	if (esrt->fw_resource_version == 1) {
@@ -182,7 +179,7 @@ static int esre_create_sysfs_entry(void *esre, int entry_num)
 
 		entry->esre.esre1 = esre;
 		rc = kobject_init_and_add(&entry->kobj, &esre1_ktype, NULL,
-					  "%s", name);
+					  "entry%d", entry_num);
 		if (rc) {
 			kfree(entry);
 			return rc;
-- 
2.6.1
