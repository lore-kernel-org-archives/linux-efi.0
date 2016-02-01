From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 08/14] efivars: Use to_efivar_entry
Date: Mon,  1 Feb 2016 22:07:02 +0000
Message-ID: <1454364428-494-9-git-send-email-matt@codeblueprint.co.uk>
References: <1454364428-494-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454364428-494-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Geliang Tang <geliangtang@163.com>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

From: Geliang Tang <geliangtang@163.com>

Use to_efivar_entry() instead of open-coding it.

Signed-off-by: Geliang Tang <geliangtang@163.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 drivers/firmware/efi/efivars.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 756eca8c4cf8..c5b0d2bc1111 100644
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
2.6.2
