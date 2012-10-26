From: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Subject: [PATCH v3 2/7] efi_pstore: Add a logic erasing entries to an erase
 callback
Date: Fri, 26 Oct 2012 21:40:39 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D41388EFE6@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Luck, Tony (tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org)" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Matthew Garrett (mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org)" <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dzickus-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dzickus-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Satoru Moriya <satoru.moriya-7rDLJAbr9SE@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

[Issue]

Currently, efi_pstore driver simply overwrites existing panic messages in NVRAM.
So, in the following scenario, we will lose 1st panic messages.
 
 1. kernel panics.
 2. efi_pstore is kicked and writes panic messages to NVRAM.
 3. system reboots.
 4. kernel panics again before a user checks the 1st panic messages in NVRAM.

[Solution]

A reasonable solution to fix the issue is just holding multiple logs without erasing
existing entries.

This patch freshly adds a logic erasing existing entries, which shared with a write callback,
to an erase callback.
To support holding multiple logs, the write callback doesn't need to erase any entries and
it will be removed in a subsequent patch.

Signed-off-by: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
---
 drivers/firmware/efivars.c |   46 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 45 insertions(+), 1 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 37ac21a..bee14cc 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -784,7 +784,51 @@ static int efi_pstore_write(enum pstore_type_id type,
 static int efi_pstore_erase(enum pstore_type_id type, u64 id,
 			    struct pstore_info *psi)
 {
-	efi_pstore_write(type, 0, &id, (unsigned int)id, 0, psi);
+	char stub_name[DUMP_NAME_LEN];
+	efi_char16_t efi_name[DUMP_NAME_LEN];
+	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
+	struct efivars *efivars = psi->data;
+	struct efivar_entry *entry, *found = NULL;
+	int i;
+
+	sprintf(stub_name, "dump-type%u-%u-", type, (unsigned int)id);
+
+	spin_lock(&efivars->lock);
+
+	for (i = 0; i < DUMP_NAME_LEN; i++)
+		efi_name[i] = stub_name[i];
+
+	/*
+	 * Clean up any entries with the same name
+	 */
+
+	list_for_each_entry(entry, &efivars->list, list) {
+		get_var_data_locked(efivars, &entry->var);
+
+		if (efi_guidcmp(entry->var.VendorGuid, vendor))
+			continue;
+		if (utf16_strncmp(entry->var.VariableName, efi_name,
+				  utf16_strlen(efi_name)))
+			continue;
+		/* Needs to be a prefix */
+		if (entry->var.VariableName[utf16_strlen(efi_name)] == 0)
+			continue;
+
+		/* found */
+		found = entry;
+		efivars->ops->set_variable(entry->var.VariableName,
+					   &entry->var.VendorGuid,
+					   PSTORE_EFI_ATTRIBUTES,
+					   0, NULL);
+	}
+
+	if (found)
+		list_del(&found->list);
+
+	spin_unlock(&efivars->lock);
+
+	if (found)
+		efivar_unregister(found);
 
 	return 0;
 }
-- 1.7.1
