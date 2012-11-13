From: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Subject: [PATCH v5 7/7] efi_pstore: Add a format check for an existing
 variable name at erasing time
Date: Tue, 13 Nov 2012 16:39:36 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D4138C1604@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luck, Tony (tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org)" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <anton.vorontsov-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Matthew Garrett (mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org)" <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dzickus-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dzickus-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <dle-develop-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, Satoru Moriya <satoru.moriya-7rDLJAbr9SE@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

[Issue]

a format of variable name has been updated to type, id, count and ctime
to support holding multiple logs.

Format of current variable name
  dump-type0-1-2-12345678

  type:0
  id:1
  count:2
  ctime:12345678

On the other hand, if an old variable name before being updated
remains, users can't erase it via /dev/pstore.

Format of old variable name
  dump-type0-1-12345678

  type:0
  id:1
  ctime:12345678

[Solution]

This patch add a format check for the old variable name in a erase callback to make it erasable.

Signed-off-by: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Acked-by: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 drivers/firmware/efivars.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 60d2905..904d0c7 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -773,6 +773,8 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
 {
 	char name[DUMP_NAME_LEN];
 	efi_char16_t efi_name[DUMP_NAME_LEN];
+	char name_old[DUMP_NAME_LEN];
+	efi_char16_t efi_name_old[DUMP_NAME_LEN];
 	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
 	struct efivars *efivars = psi->data;
 	struct efivar_entry *entry, *found = NULL;
@@ -796,8 +798,22 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
 		if (efi_guidcmp(entry->var.VendorGuid, vendor))
 			continue;
 		if (utf16_strncmp(entry->var.VariableName, efi_name,
-				  utf16_strlen(efi_name)))
-			continue;
+				  utf16_strlen(efi_name))) {
+			/*
+			 * Check if an old format,
+			 * which doesn't support holding
+			 * multiple logs, remains.
+			 */
+			sprintf(name_old, "dump-type%u-%u-%lu", type,
+				(unsigned int)id, time.tv_sec);
+
+			for (i = 0; i < DUMP_NAME_LEN; i++)
+				efi_name_old[i] = name_old[i];
+
+			if (utf16_strncmp(entry->var.VariableName, efi_name_old,
+					  utf16_strlen(efi_name_old)))
+				continue;
+		}
 
 		/* found */
 		found = entry;
-- 
1.7.1
