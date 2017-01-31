From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 02/10] x86/efi: Deduplicate efi_char16_printk()
Date: Tue, 31 Jan 2017 13:21:34 +0000
Message-ID: <1485868902-20401-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1485868902-20401-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485868902-20401-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>

Eliminate the separate 32 bit and 64 bit code paths by way of the shiny
new efi_call_proto() macro.

No functional change intended.

Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/x86/boot/compressed/eboot.c | 26 ++------------------------
 include/linux/efi.h              |  8 ++++----
 2 files changed, 6 insertions(+), 28 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index f1cf284d631e..6d3aeabbce68 100644
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
index 5b1af30ece55..6642c4d9d11d 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1240,17 +1240,17 @@ struct efivar_entry {
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
2.7.4
