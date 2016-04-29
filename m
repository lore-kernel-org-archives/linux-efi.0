From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] efibc: avoid stack overflow warning
Date: Fri, 29 Apr 2016 19:48:31 +0200
Message-ID: <1461952128-2135409-1-git-send-email-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, "Compostella, Jeremy" <jeremy.compostella@intel.com>, Ingo Molnar <mingo@kernel.org>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

gcc complains about a newly added file for the EFI Bootloader Control:

drivers/firmware/efi/efibc.c: In function 'efibc_set_variable':
drivers/firmware/efi/efibc.c:53:1: error: the frame size of 2272 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]

The problem is the declaration of a local variable of type
struct efivar_entry, which is by itself larger than the warning
limit of 1024 bytes.

We know that the reboot notifiers are not called from a deep stack,
so this is not an actual bug, but we should still try to rework
the code to avoid the warning. We also know that reboot notifiers
are never run concurrently on multiple CPUs, so there is no problem
in just making the variable 'static'.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 06f7d4a1618d ("efibc: Add EFI Bootloader Control module")
---
 drivers/firmware/efi/efibc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/efibc.c b/drivers/firmware/efi/efibc.c
index 2e0c7ccd9d9e..83ac90efa03f 100644
--- a/drivers/firmware/efi/efibc.c
+++ b/drivers/firmware/efi/efibc.c
@@ -31,8 +31,9 @@ static void efibc_str_to_str16(const char *str, efi_char16_t *str16)
 static void efibc_set_variable(const char *name, const char *value)
 {
 	int ret;
-	efi_guid_t guid = LINUX_EFI_LOADER_ENTRY_GUID;
-	struct efivar_entry entry;
+	static struct efivar_entry entry = {
+		.var.VendorGuid = LINUX_EFI_LOADER_ENTRY_GUID,
+	};
 	size_t size = (strlen(value) + 1) * sizeof(efi_char16_t);
 
 	if (size > sizeof(entry.var.Data))
@@ -40,7 +41,6 @@ static void efibc_set_variable(const char *name, const char *value)
 
 	efibc_str_to_str16(name, entry.var.VariableName);
 	efibc_str_to_str16(value, (efi_char16_t *)entry.var.Data);
-	memcpy(&entry.var.VendorGuid, &guid, sizeof(guid));
 
 	ret = efivar_entry_set(&entry,
 			       EFI_VARIABLE_NON_VOLATILE
-- 
2.7.0
