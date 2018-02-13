From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] efi: Delete an error message for a failed memory allocation
 in efivar_init()
Date: Tue, 13 Feb 2018 17:33:25 +0100
Message-ID: <13c1274c-cff4-5056-cd06-353663af58e1@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 13 Feb 2018 17:28:22 +0100

Omit an extra message for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/firmware/efi/vars.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 9336ffdf6e2c..ffdbc5bc3c56 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -437,10 +437,8 @@ int efivar_init(int (*func)(efi_char16_t *, efi_guid_t, unsigned long, void *),
 	int err = 0;
 
 	variable_name = kzalloc(variable_name_size, GFP_KERNEL);
-	if (!variable_name) {
-		printk(KERN_ERR "efivars: Memory allocation failed.\n");
+	if (!variable_name)
 		return -ENOMEM;
-	}
 
 	if (down_interruptible(&efivars_lock)) {
 		err = -EINTR;
-- 
2.16.1
