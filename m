From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 2/2] x86/efi: Deduplicate efi_char16_printk()
Date: Mon, 7 Nov 2016 12:17:00 +0100
Message-ID: <a07e587429c2a720a6afe51c2cc68ee6985e50d0.1478510356.git.lukas@wunner.de>
References: <cover.1478510356.git.lukas@wunner.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1478510356.git.lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Eliminate the separate 32 bit and 64 bit code paths by way of the shiny
new efi_call_proto() macro.

No functional change intended.

Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
---
 arch/x86/boot/compressed/eboot.c | 26 ++------------------------
 include/linux/efi.h              |  8 ++++----
 2 files changed, 6 insertions(+), 28 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index f1cf284..6d3aeab 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -101,30 +101,8 @@ efi_open_volume(efi_system_table_t *sys_table, void *__image, void **__fh)
 
 void efi_char16_printk(efi_system_table_t *table, efi_char16_t *str)
 {
-	unsigned long output_string;
-	size_t offset;
-
-	if (efi_early->is64) {
-		struct efi_simple_text_output_protocol_64 *out;
-		u64 *func;
-
-		offset = offsetof(typeof(*out), output_string);
-		output_string = efi_early->text_output + offset;
-		out = (typeof(out))(unsigned long)efi_early->text_output;
-		func = (u64 *)output_string;
-
-		efi_early->call(*func, out, str);
-	} else {
-		struct efi_simple_text_output_protocol_32 *out;
-		u32 *func;
-
-		offset = offsetof(typeof(*out), output_string);
-		output_string = efi_early->text_output + offset;
-		out = (typeof(out))(unsigned long)efi_early->text_output;
-		func = (u32 *)output_string;
-
-		efi_early->call(*func, out, str);
-	}
+	efi_call_proto(efi_simple_text_output_protocol, output_string,
+		       efi_early->text_output, str);
 }
 
 static efi_status_t
diff --git a/include/linux/efi.h b/include/linux/efi.h
index a07a476..4995869 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1238,17 +1238,17 @@ struct efivar_entry {
 	bool deleting;
 };
 
-struct efi_simple_text_output_protocol_32 {
+typedef struct {
 	u32 reset;
 	u32 output_string;
 	u32 test_string;
-};
+} efi_simple_text_output_protocol_32_t;
 
-struct efi_simple_text_output_protocol_64 {
+typedef struct {
 	u64 reset;
 	u64 output_string;
 	u64 test_string;
-};
+} efi_simple_text_output_protocol_64_t;
 
 struct efi_simple_text_output_protocol {
 	void *reset;
-- 
2.10.1
