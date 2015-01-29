From: Ivan Khoronzhuk <ivan.khoronzhuk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] firmware: efi: remove unneeded guid unparse
Date: Thu, 29 Jan 2015 16:35:02 +0200
Message-ID: <1422542102-19348-1-git-send-email-ivan.khoronzhuk@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ivan Khoronzhuk <ivan.khoronzhuk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

There is no reason to translate guid number to string here.
So remove it in order to not do unneeded work.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/efi.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 9035c1b..f6be017 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -272,15 +272,10 @@ static __init int match_config_table(efi_guid_t *guid,
 				     unsigned long table,
 				     efi_config_table_type_t *table_types)
 {
-	u8 str[EFI_VARIABLE_GUID_LEN + 1];
 	int i;
 
 	if (table_types) {
-		efi_guid_unparse(guid, str);
-
 		for (i = 0; efi_guidcmp(table_types[i].guid, NULL_GUID); i++) {
-			efi_guid_unparse(&table_types[i].guid, str);
-
 			if (!efi_guidcmp(*guid, table_types[i].guid)) {
 				*(table_types[i].ptr) = table;
 				pr_cont(" %s=0x%lx ",
-- 
1.9.1
