From: Peter Jones <pjones@redhat.com>
Subject: [PATCH 3/5] efi: do variable name validation tests in utf8 (v2)
Date: Mon,  8 Feb 2016 14:48:13 -0500
Message-ID: <1454960895-3473-4-git-send-email-pjones@redhat.com>
References: <20160204234211.GI2586@codeblueprint.co.uk>
 <1454960895-3473-1-git-send-email-pjones@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1454960895-3473-1-git-send-email-pjones@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: linux-efi@vger.kernel.org, linux-fsdevel@vger.kernel.org, Peter Jones <pjones@redhat.com>
List-Id: linux-efi@vger.kernel.org

Actually translate from ucs2 to utf8 before doing the test, and then
test against our other utf8 data, instead of fudging it.

v2: - rename efivar_validate()'s "len" parameter to "data_size" for clarity
    - use the right limit on ucs2_as_utf8 and terminate it manually.

Signed-off-by: Peter Jones <pjones@redhat.com>
Acked-by: Matthew Garrett <mjg59@coreos.com>

An earlier version that's not hugely different was:
Tested-by: Lee, Chun-Yi <jlee@suse.com>
---
 drivers/firmware/efi/vars.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 70a0fb1..5c5fde3 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -189,10 +189,19 @@ static const struct variable_validate variable_validate[] = {
 };
 
 bool
-efivar_validate(efi_char16_t *var_name, u8 *data, unsigned long len)
+efivar_validate(efi_char16_t *var_name, u8 *data, unsigned long data_size)
 {
 	int i;
-	u16 *unicode_name = var_name;
+	unsigned long utf8_size;
+	u8 *utf8_name;
+
+	utf8_size = ucs2_utf8size(var_name);
+	utf8_name = kmalloc(utf8_size + 1, GFP_KERNEL);
+	if (!utf8_name)
+		return false;
+
+	ucs2_as_utf8(utf8_name, var_name, utf8_size);
+	utf8_name[utf8_size] = '\0';
 
 	for (i = 0; variable_validate[i].validate != NULL; i++) {
 		const char *name = variable_validate[i].name;
@@ -200,28 +209,29 @@ efivar_validate(efi_char16_t *var_name, u8 *data, unsigned long len)
 
 		for (match = 0; ; match++) {
 			char c = name[match];
-			u16 u = unicode_name[match];
-
-			/* All special variables are plain ascii */
-			if (u > 127)
-				return true;
+			char u = utf8_name[match];
 
 			/* Wildcard in the matching name means we've matched */
-			if (c == '*')
+			if (c == '*') {
+				kfree(utf8_name);
 				return variable_validate[i].validate(var_name,
-							     match, data, len);
+							match, data, data_size);
+			}
 
 			/* Case sensitive match */
 			if (c != u)
 				break;
 
 			/* Reached the end of the string while matching */
-			if (!c)
+			if (!c) {
+				kfree(utf8_name);
 				return variable_validate[i].validate(var_name,
-							     match, data, len);
+							match, data, data_size);
+			}
 		}
 	}
 
+	kfree(utf8_name);
 	return true;
 }
 EXPORT_SYMBOL_GPL(efivar_validate);
-- 
2.5.0

