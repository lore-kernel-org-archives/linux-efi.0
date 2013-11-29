From: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3] efi-pstore: Make efi-pstore return a unique id
Date: Fri, 29 Nov 2013 15:58:57 +0800
Message-ID: <87txevabb2.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


This version for fixing following errors:
    >> efi-pstore.c:(.text+0x84c6cc): undefined reference to `__udivdi3'
    >> efi-pstore.c:(.text+0x84c6e0): undefined reference to `__umoddi3'

Pstore fs expects that backends provide a uniqued id which could avoid
pstore making entries as duplication or denominating entries the same
name. So I combine the timestamp, part and count into id.

Signed-off-by: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/firmware/efi/efi-pstore.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index 5002d50..154fa5f 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -39,6 +39,12 @@ struct pstore_read_data {
 	char **buf;
 };
 
+static inline u64 generic_id(unsigned long timestamp,
+			     unsigned int part, int count)
+{
+	return (timestamp * 100 + part) * 1000 + count;
+}
+
 static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 {
 	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
@@ -57,7 +63,7 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 
 	if (sscanf(name, "dump-type%u-%u-%d-%lu-%c",
 		   cb_data->type, &part, &cnt, &time, &data_type) == 5) {
-		*cb_data->id = part;
+		*cb_data->id = generic_id(time, part, cnt);
 		*cb_data->count = cnt;
 		cb_data->timespec->tv_sec = time;
 		cb_data->timespec->tv_nsec = 0;
@@ -67,7 +73,7 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 			*cb_data->compressed = false;
 	} else if (sscanf(name, "dump-type%u-%u-%d-%lu",
 		   cb_data->type, &part, &cnt, &time) == 4) {
-		*cb_data->id = part;
+		*cb_data->id = generic_id(time, part, cnt);
 		*cb_data->count = cnt;
 		cb_data->timespec->tv_sec = time;
 		cb_data->timespec->tv_nsec = 0;
@@ -79,7 +85,7 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 		 * which doesn't support holding
 		 * multiple logs, remains.
 		 */
-		*cb_data->id = part;
+		*cb_data->id = generic_id(time, part, 0);
 		*cb_data->count = 0;
 		cb_data->timespec->tv_sec = time;
 		cb_data->timespec->tv_nsec = 0;
@@ -199,14 +205,16 @@ static int efi_pstore_erase(enum pstore_type_id type, u64 id, int count,
 	char name[DUMP_NAME_LEN];
 	efi_char16_t efi_name[DUMP_NAME_LEN];
 	int found, i;
+	unsigned int part;
 
-	sprintf(name, "dump-type%u-%u-%d-%lu", type, (unsigned int)id, count,
-		time.tv_sec);
+	do_div(id, 1000);
+	part = do_div(id, 100);
+	sprintf(name, "dump-type%u-%u-%d-%lu", type, part, count, time.tv_sec);
 
 	for (i = 0; i < DUMP_NAME_LEN; i++)
 		efi_name[i] = name[i];
 
-	edata.id = id;
+	edata.id = part;
 	edata.type = type;
 	edata.count = count;
 	edata.time = time;
-- 
1.8.4.2
