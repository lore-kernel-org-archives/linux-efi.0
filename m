From: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Subject: [PATCH v6 6/7] efi_pstore: Add a format check for an existing
 variable name at reading time
Date: Wed, 14 Nov 2012 20:28:50 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D4138CA723@USINDEM103.corp.hds.com>
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
remains, users can't read it via /dev/pstore.

Format of old variable name
  dump-type0-1-12345678

  type:0
  id:1
  ctime:12345678

[Solution]

This patch add a format check for the old variable name in a read callback
to make it readable.

Signed-off-by: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Acked-by: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 drivers/firmware/efivars.c |   38 ++++++++++++++++++++++++++++----------
 1 files changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 7ad3aae..bf7a6f9 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -681,17 +681,35 @@ static ssize_t efi_pstore_read(u64 *id, enum pstore_type_id *type,
 				*count = cnt;
 				timespec->tv_sec = time;
 				timespec->tv_nsec = 0;
-				get_var_data_locked(efivars, &efivars->walk_entry->var);
-				size = efivars->walk_entry->var.DataSize;
-				*buf = kmalloc(size, GFP_KERNEL);
-				if (*buf == NULL)
-					return -ENOMEM;
-				memcpy(*buf, efivars->walk_entry->var.Data,
-				       size);
-				efivars->walk_entry = list_entry(efivars->walk_entry->list.next,
-					           struct efivar_entry, list);
-				return size;
+			} else if (sscanf(name, "dump-type%u-%u-%lu",
+				   type, &part, &time) == 3) {
+				/*
+				 * Check if an old format,
+				 * which doesn't support holding
+				 * multiple logs, remains.
+				 */
+				*id = part;
+				*count = 0;
+				timespec->tv_sec = time;
+				timespec->tv_nsec = 0;
+			} else {
+				efivars->walk_entry = list_entry(
+						efivars->walk_entry->list.next,
+						struct efivar_entry, list);
+				continue;
 			}
+
+			get_var_data_locked(efivars, &efivars->walk_entry->var);
+			size = efivars->walk_entry->var.DataSize;
+			*buf = kmalloc(size, GFP_KERNEL);
+			if (*buf == NULL)
+				return -ENOMEM;
+			memcpy(*buf, efivars->walk_entry->var.Data,
+			       size);
+			efivars->walk_entry = list_entry(
+					efivars->walk_entry->list.next,
+					struct efivar_entry, list);
+			return size;
 		}
 		efivars->walk_entry = list_entry(efivars->walk_entry->list.next,
 						 struct efivar_entry, list);
-- 
1.7.1
