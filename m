From: Colin King <colin.king@canonical.com>
Subject: [PATCH] efi: make const array 'apple' static
Date: Fri,  2 Mar 2018 14:35:30 +0000
Message-ID: <20180302143530.1713-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate the const read-only array 'buf' on the stack but instead
make it static. Makes the object code smaller by 64 bytes:

Before:
   text	   data	    bss	    dec	    hex	filename
   9264	      1	     16	   9281	   2441	arch/x86/boot/compressed/eboot.o

After:
   text	   data	    bss	    dec	    hex	filename
   9200	      1	     16	   9217	   2401	arch/x86/boot/compressed/eboot.o

(gcc version 7.2.0 x86_64)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 arch/x86/boot/compressed/eboot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 886a9115af62..f2251c1c9853 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -423,7 +423,7 @@ static void retrieve_apple_device_properties(struct boot_params *boot_params)
 
 static void setup_quirks(struct boot_params *boot_params)
 {
-	efi_char16_t const apple[] = { 'A', 'p', 'p', 'l', 'e', 0 };
+	static efi_char16_t const apple[] = { 'A', 'p', 'p', 'l', 'e', 0 };
 	efi_char16_t *fw_vendor = (efi_char16_t *)(unsigned long)
 		efi_table_attr(efi_system_table, fw_vendor, sys_table);
 
-- 
2.15.1
