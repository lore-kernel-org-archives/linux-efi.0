From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 1/4] efi/esrt: Don't preformat name
Date: Mon, 14 Dec 2015 18:26:50 +0000
Message-ID: <1450117613-15438-2-git-send-email-matt@codeblueprint.co.uk>
References: <1450117613-15438-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1450117613-15438-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Peter Jones <pjones@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

kobject_init_and_add takes a format string+args, so there's no reason
to do this formatting in advance.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Peter Jones <pjones@redhat.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
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
2.6.2
