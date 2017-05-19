From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: [PATCH] efi-pstore: Fix write/erase id tracking
Date: Fri, 19 May 2017 11:27:01 -0700
Message-ID: <20170519182701.GA63464@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Marta Lofstedt <marta.lofstedt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Prior to the pstore interface refactoring, the "id" generated during
a backend pstore_write() was only retained by the internal pstore
inode tracking list. Additionally the "part" was ignored, so EFI
would encode this in the id. This corrects the misunderstandings
and correctly sets "id" during pstore_write(), and uses "part"
directly during pstore_erase().

Reported-by: Marta Lofstedt <marta.lofstedt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Fixes: 76cc9580e3fb ("pstore: Replace arguments for write() API")
Fixes: a61072aae693 ("pstore: Replace arguments for erase() API")
Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
Since the pstore refactor broke this, I intend to push this via the
pstore tree.
---
 drivers/firmware/efi/efi-pstore.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index 44148fd4c9f2..dda2e96328c0 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -53,6 +53,7 @@ static int efi_pstore_read_func(struct efivar_entry *entry,
 	if (sscanf(name, "dump-type%u-%u-%d-%lu-%c",
 		   &record->type, &part, &cnt, &time, &data_type) == 5) {
 		record->id = generic_id(time, part, cnt);
+		record->part = part;
 		record->count = cnt;
 		record->time.tv_sec = time;
 		record->time.tv_nsec = 0;
@@ -64,6 +65,7 @@ static int efi_pstore_read_func(struct efivar_entry *entry,
 	} else if (sscanf(name, "dump-type%u-%u-%d-%lu",
 		   &record->type, &part, &cnt, &time) == 4) {
 		record->id = generic_id(time, part, cnt);
+		record->part = part;
 		record->count = cnt;
 		record->time.tv_sec = time;
 		record->time.tv_nsec = 0;
@@ -77,6 +79,7 @@ static int efi_pstore_read_func(struct efivar_entry *entry,
 		 * multiple logs, remains.
 		 */
 		record->id = generic_id(time, part, 0);
+		record->part = part;
 		record->count = 0;
 		record->time.tv_sec = time;
 		record->time.tv_nsec = 0;
@@ -241,9 +244,15 @@ static int efi_pstore_write(struct pstore_record *record)
 	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
 	int i, ret = 0;
 
+	record->time.tv_sec = get_seconds();
+	record->time.tv_nsec = 0;
+
+	record->id = generic_id(record->time.tv_sec, record->part,
+				record->count);
+
 	snprintf(name, sizeof(name), "dump-type%u-%u-%d-%lu-%c",
 		 record->type, record->part, record->count,
-		 get_seconds(), record->compressed ? 'C' : 'D');
+		 record->time.tv_sec, record->compressed ? 'C' : 'D');
 
 	for (i = 0; i < DUMP_NAME_LEN; i++)
 		efi_name[i] = name[i];
@@ -255,7 +264,6 @@ static int efi_pstore_write(struct pstore_record *record)
 	if (record->reason == KMSG_DUMP_OOPS)
 		efivar_run_worker();
 
-	record->id = record->part;
 	return ret;
 };
 
@@ -287,7 +295,7 @@ static int efi_pstore_erase_func(struct efivar_entry *entry, void *data)
 		 * holding multiple logs, remains.
 		 */
 		snprintf(name_old, sizeof(name_old), "dump-type%u-%u-%lu",
-			ed->record->type, (unsigned int)ed->record->id,
+			ed->record->type, ed->record->part,
 			ed->record->time.tv_sec);
 
 		for (i = 0; i < DUMP_NAME_LEN; i++)
@@ -320,10 +328,7 @@ static int efi_pstore_erase(struct pstore_record *record)
 	char name[DUMP_NAME_LEN];
 	efi_char16_t efi_name[DUMP_NAME_LEN];
 	int found, i;
-	unsigned int part;
 
-	do_div(record->id, 1000);
-	part = do_div(record->id, 100);
 	snprintf(name, sizeof(name), "dump-type%u-%u-%d-%lu",
 		 record->type, record->part, record->count,
 		 record->time.tv_sec);
-- 
2.7.4


-- 
Kees Cook
Pixel Security
