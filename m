From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 08/10] efi: Constify
 EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL.OutputString()
Date: Mon, 2 Jan 2017 11:24:33 +0100
Message-ID: <38bdd3bb76c7f3ac958a13d1bb9d31132f05d931.1483318593.git.lukas@wunner.de>
References: <cover.1483318593.git.lukas@wunner.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1483318593.git.lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

UCS-2 strings passed to EFI_SIMPLE_TEXT_OUTPUT_PROTOCOL.OutputString()
are not modified, so can be declared const.  This allows the compiler to
place them in the rodata section instead of generating them on the stack
at runtime, such as with the '\r' string passed from efi_printk() to
efi_char16_printk().  Constification of such strings is in compliance
with the EFI spec which marks them "IN" for this protocol function.

Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
---
 arch/x86/boot/compressed/eboot.c               | 2 +-
 drivers/firmware/efi/libstub/arm-stub.c        | 2 +-
 drivers/firmware/efi/libstub/efi-stub-helper.c | 2 +-
 drivers/firmware/efi/libstub/efistub.h         | 2 +-
 include/linux/efi.h                            | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 61014f5..fee5693 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -97,7 +97,7 @@ static inline efi_status_t __open_volume64(void *__image, void **__fh)
 	return __open_volume32(__image, __fh);
 }
 
-void efi_char16_printk(efi_system_table_t *table, efi_char16_t *str)
+void efi_char16_printk(efi_system_table_t *table, const efi_char16_t *str)
 {
 	efi_call_proto(efi_simple_text_output_protocol, output_string,
 		       efi_early->text_output, str);
diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 70d6722..1053ec2 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -90,7 +90,7 @@ efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg,
 }
 
 void efi_char16_printk(efi_system_table_t *sys_table_arg,
-			      efi_char16_t *str)
+		       const efi_char16_t *str)
 {
 	struct efi_simple_text_output_protocol *out;
 
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 8e06307..a9b6e4d 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -48,7 +48,7 @@ void efi_printk(efi_system_table_t *sys_table_arg, char *str)
 
 		ch[0] = *s8;
 		if (*s8 == '\n') {
-			efi_char16_t nl[2] = { '\r', 0 };
+			const efi_char16_t nl[2] = { '\r', 0 };
 			efi_char16_printk(sys_table_arg, nl);
 		}
 
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index 2fe7746..12dee6b 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -24,7 +24,7 @@
 #define EFI_ALLOC_ALIGN		EFI_PAGE_SIZE
 #endif
 
-void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
+void efi_char16_printk(efi_system_table_t *, const efi_char16_t *);
 
 efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg, void *__image,
 			     void **__fh);
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 6ed28e1..24a3e55 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1257,7 +1257,7 @@ struct efivar_entry {
 
 struct efi_simple_text_output_protocol {
 	void *reset;
-	efi_status_t (*output_string)(void *, void *);
+	efi_status_t (*output_string)(void *, const void *);
 	void *test_string;
 };
 
-- 
2.11.0
