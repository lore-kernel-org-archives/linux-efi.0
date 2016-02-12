From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 3/5] efi: Do variable name validation tests in utf8
Date: Fri, 12 Feb 2016 11:27:10 +0000
Message-ID: <1455276432-9931-4-git-send-email-matt@codeblueprint.co.uk>
References: <1455276432-9931-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455276432-9931-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Matthew Garrett <mjg59-JW9irJGTvgXQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Actually translate from ucs2 to utf8 before doing the test, and then
test against our other utf8 data, instead of fudging it.

Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Acked-by: Matthew Garrett <mjg59-JW9irJGTvgXQT0dZR+AlfA@public.gmane.org>
Tested-by: "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 drivers/firmware/efi/vars.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 70a0fb10517f..5c5fde3e6c37 100644
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
2.6.2
