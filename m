From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 2/5] efibc: Fix excessive stack footprint warning
Date: Fri,  6 May 2016 22:39:28 +0100
Message-ID: <1462570771-13324-3-git-send-email-matt@codeblueprint.co.uk>
References: <1462570771-13324-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1462570771-13324-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Compostella <jeremy.compostella@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-efi@vger.kernel.org

From: Jeremy Compostella <jeremy.compostella@intel.com>

gcc complains about a newly added file for the EFI Bootloader Control:

drivers/firmware/efi/efibc.c: In function 'efibc_set_variable':
drivers/firmware/efi/efibc.c:53:1: error: the frame size of 2272 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]

The problem is the declaration of a local variable of type struct
efivar_entry, which is by itself larger than the warning limit of 1024
bytes.

Use dynamic memory allocation instead of stack memory for the entry
object.

This patch also fixes a potential buffer overflow.

Reported-by: Ingo Molnar <mingo@kernel.org>
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Jeremy Compostella <jeremy.compostella@intel.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
[ Updated changelog to include gcc error ]
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 drivers/firmware/efi/efibc.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/firmware/efi/efibc.c b/drivers/firmware/efi/efibc.c
index 2e0c7ccd9d9e..8dd0c7085e59 100644
--- a/drivers/firmware/efi/efibc.c
+++ b/drivers/firmware/efi/efibc.c
@@ -17,6 +17,7 @@
 #include <linux/efi.h>
 #include <linux/module.h>
 #include <linux/reboot.h>
+#include <linux/slab.h>
 
 static void efibc_str_to_str16(const char *str, efi_char16_t *str16)
 {
@@ -28,41 +29,52 @@ static void efibc_str_to_str16(const char *str, efi_char16_t *str16)
 	str16[i] = '\0';
 }
 
-static void efibc_set_variable(const char *name, const char *value)
+static int efibc_set_variable(const char *name, const char *value)
 {
 	int ret;
 	efi_guid_t guid = LINUX_EFI_LOADER_ENTRY_GUID;
-	struct efivar_entry entry;
+	struct efivar_entry *entry;
 	size_t size = (strlen(value) + 1) * sizeof(efi_char16_t);
 
-	if (size > sizeof(entry.var.Data))
+	if (size > sizeof(entry->var.Data)) {
 		pr_err("value is too large");
+		return -EINVAL;
+	}
 
-	efibc_str_to_str16(name, entry.var.VariableName);
-	efibc_str_to_str16(value, (efi_char16_t *)entry.var.Data);
-	memcpy(&entry.var.VendorGuid, &guid, sizeof(guid));
+	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry) {
+		pr_err("failed to allocate efivar entry");
+		return -ENOMEM;
+	}
 
-	ret = efivar_entry_set(&entry,
+	efibc_str_to_str16(name, entry->var.VariableName);
+	efibc_str_to_str16(value, (efi_char16_t *)entry->var.Data);
+	memcpy(&entry->var.VendorGuid, &guid, sizeof(guid));
+
+	ret = efivar_entry_set(entry,
 			       EFI_VARIABLE_NON_VOLATILE
 			       | EFI_VARIABLE_BOOTSERVICE_ACCESS
 			       | EFI_VARIABLE_RUNTIME_ACCESS,
-			       size, entry.var.Data, NULL);
+			       size, entry->var.Data, NULL);
 	if (ret)
 		pr_err("failed to set %s EFI variable: 0x%x\n",
 		       name, ret);
+
+	kfree(entry);
+	return ret;
 }
 
 static int efibc_reboot_notifier_call(struct notifier_block *notifier,
 				      unsigned long event, void *data)
 {
 	const char *reason = "shutdown";
+	int ret;
 
 	if (event == SYS_RESTART)
 		reason = "reboot";
 
-	efibc_set_variable("LoaderEntryRebootReason", reason);
-
-	if (!data)
+	ret = efibc_set_variable("LoaderEntryRebootReason", reason);
+	if (ret || !data)
 		return NOTIFY_DONE;
 
 	efibc_set_variable("LoaderEntryOneShot", (char *)data);
-- 
2.7.3
