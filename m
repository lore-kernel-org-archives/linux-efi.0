From: Seiji Aguchi <seiji.aguchi@hds.com>
Subject: [RESEND][PATCH v4 6/7] efi_pstore: Add a format check for an
 existing variable name at reading time
Date: Thu, 1 Nov 2012 23:02:26 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D4138B43CB@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "mikew@google.com" <mikew@google.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>, "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>, "dzickus@redhat.com" <dzickus@redhat.com>
Cc: "dle-develop@lists.sourceforge.net" <dle-develop@lists.sourceforge.net>, Satoru Moriya <satoru.moriya@hds.com>
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

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
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
