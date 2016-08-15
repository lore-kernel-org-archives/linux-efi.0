From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH] x86/efi: Remove unused find_bits() function
Date: Mon, 15 Aug 2016 13:52:34 +0200
Message-ID: <494a2f40906bb220168d835b37e609232fe0ffdf.1471261734.git.lukas@wunner.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Left behind by commit fc37206427ce ("efi/libstub: Move Graphics Output
Protocol handling to generic code").

Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
---
 arch/x86/boot/compressed/eboot.c | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index ec6d2ef..f7fc85b 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -286,29 +286,6 @@ void efi_char16_printk(efi_system_table_t *table, efi_char16_t *str)
 	}
 }
 
-static void find_bits(unsigned long mask, u8 *pos, u8 *size)
-{
-	u8 first, len;
-
-	first = 0;
-	len = 0;
-
-	if (mask) {
-		while (!(mask & 0x1)) {
-			mask = mask >> 1;
-			first++;
-		}
-
-		while (mask & 0x1) {
-			mask = mask >> 1;
-			len++;
-		}
-	}
-
-	*pos = first;
-	*size = len;
-}
-
 static efi_status_t
 __setup_efi_pci32(efi_pci_io_protocol_32 *pci, struct pci_setup_rom **__rom)
 {
-- 
2.8.1
