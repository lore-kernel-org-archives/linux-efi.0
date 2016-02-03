From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/5] efi: do variable name validation tests in utf8
Date: Wed,  3 Feb 2016 08:02:45 -0500
Message-ID: <1454504567-2826-3-git-send-email-pjones@redhat.com>
References: <1454504567-2826-1-git-send-email-pjones@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454504567-2826-1-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Actually translate from ucs2 to utf8 before doing the test, and then
test against our other utf8 data, instead of fudging it.

Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/firmware/efi/vars.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 70a0fb1..36c5a6e 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -192,7 +192,15 @@ bool
 efivar_validate(efi_char16_t *var_name, u8 *data, unsigned long len)
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
+	ucs2_as_utf8(utf8_name, var_name, len);
 
 	for (i = 0; variable_validate[i].validate != NULL; i++) {
 		const char *name = variable_validate[i].name;
@@ -200,28 +208,29 @@ efivar_validate(efi_char16_t *var_name, u8 *data, unsigned long len)
 
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
 							     match, data, len);
+			}
 
 			/* Case sensitive match */
 			if (c != u)
 				break;
 
 			/* Reached the end of the string while matching */
-			if (!c)
+			if (!c) {
+				kfree(utf8_name);
 				return variable_validate[i].validate(var_name,
 							     match, data, len);
+			}
 		}
 	}
 
+	kfree(utf8_name);
 	return true;
 }
 EXPORT_SYMBOL_GPL(efivar_validate);
-- 
2.5.0
