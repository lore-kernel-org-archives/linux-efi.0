From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 22/29] x86/efi: Remove unused find_bits() function
Date: Fri,  9 Sep 2016 16:18:44 +0100
Message-ID: <20160909151851.27577-23-matt@codeblueprint.co.uk>
References: <20160909151851.27577-1-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160909151851.27577-1-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Lukas Wunner <lukas@wunner.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

Left behind by commit fc37206427ce ("efi/libstub: Move Graphics Output
Protocol handling to generic code").

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/boot/compressed/eboot.c | 23 -----------------------
 1 file changed, 23 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index ec6d2ef12baf..f7fc85bf8221 100644
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
2.9.3
