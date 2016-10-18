From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 8/8] efi: efivar_ssdt_load: Don't return success on allocation failure
Date: Tue, 18 Oct 2016 15:33:18 +0100
Message-ID: <20161018143318.15673-9-matt@codeblueprint.co.uk>
References: <20161018143318.15673-1-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161018143318.15673-1-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

We should return -ENOMEM here, instead of success.

Fixes: 475fb4e8b2f4 ("efi / ACPI: load SSTDs from EFI variables")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/efi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 1ac199cd75e7..a4944e22f294 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -259,8 +259,10 @@ static __init int efivar_ssdt_load(void)
 		}
 
 		data = kmalloc(size, GFP_KERNEL);
-		if (!data)
+		if (!data) {
+			ret = -ENOMEM;
 			goto free_entry;
+		}
 
 		ret = efivar_entry_get(entry, NULL, &size, data);
 		if (ret) {
-- 
2.10.0
