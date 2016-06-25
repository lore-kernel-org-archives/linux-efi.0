From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 1/7] efibc: Report more information in the error messages
Date: Sat, 25 Jun 2016 08:20:24 +0100
Message-ID: <1466839230-12781-2-git-send-email-matt@codeblueprint.co.uk>
References: <1466839230-12781-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1466839230-12781-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: "Compostella, Jeremy" <jeremy.compostella@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Arnd Bergmann <arnd@arndb.de>, Robert Elliott <elliott@hpe.com>
List-Id: linux-efi@vger.kernel.org

From: "Compostella, Jeremy" <jeremy.compostella@intel.com>

Report the name of the EFI variable if the value size is too large or
if efibc_set_variable() fails to allocate the struct efivar_entry
object.  If efibc_set_variable() fails because the value size is too
large, it also reports the value size in the error message.

Signed-off-by: Jeremy Compostella <jeremy.compostella@intel.com>
Reported-by: Robert Elliott <elliott@hpe.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 drivers/firmware/efi/efibc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efi/efibc.c b/drivers/firmware/efi/efibc.c
index 8dd0c7085e59..568335d4239a 100644
--- a/drivers/firmware/efi/efibc.c
+++ b/drivers/firmware/efi/efibc.c
@@ -37,13 +37,15 @@ static int efibc_set_variable(const char *name, const char *value)
 	size_t size = (strlen(value) + 1) * sizeof(efi_char16_t);
 
 	if (size > sizeof(entry->var.Data)) {
-		pr_err("value is too large");
+		pr_err("value is too large (%zu bytes) for %s EFI variable\n",
+		       size, name);
 		return -EINVAL;
 	}
 
 	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
 	if (!entry) {
-		pr_err("failed to allocate efivar entry");
+		pr_err("failed to allocate efivar entry for %s EFI variable\n",
+		       name);
 		return -ENOMEM;
 	}
 
-- 
2.7.3
