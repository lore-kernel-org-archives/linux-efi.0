From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: [PATCH] efi-pstore: Fix read iter after pstore API refactor
Date: Fri, 12 May 2017 14:58:54 -0700
Message-ID: <20170512215854.GA85220@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>, Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

During the internal pstore API refactoring, the EFI vars read entry was
accidentally made to update a stack variable instead of the pstore
private data pointer. This corrects the problem (and removes the now
needless argument).

Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
 drivers/firmware/efi/efi-pstore.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index 93d8cdbe7ef4..9e6f14c354f1 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -155,25 +155,20 @@ static int efi_pstore_scan_sysfs_exit(struct efivar_entry *pos,
  * efi_pstore_sysfs_entry_iter
  *
  * @record: pstore record to pass to callback
- * @pos: entry to begin iterating from
  *
  * You MUST call efivar_enter_iter_begin() before this function, and
  * efivar_entry_iter_end() afterwards.
  *
- * It is possible to begin iteration from an arbitrary entry within
- * the list by passing @pos. @pos is updated on return to point to
- * the next entry of the last one passed to efi_pstore_read_func().
- * To begin iterating from the beginning of the list @pos must be %NULL.
  */
-static int efi_pstore_sysfs_entry_iter(struct pstore_record *record,
-				       struct efivar_entry **pos)
+static int efi_pstore_sysfs_entry_iter(struct pstore_record *record)
 {
+	struct efivar_entry *pos = (struct efivar_entry *)record->psi->data;
 	struct efivar_entry *entry, *n;
 	struct list_head *head = &efivar_sysfs_list;
 	int size = 0;
 	int ret;
 
-	if (!*pos) {
+	if (!pos) {
 		list_for_each_entry_safe(entry, n, head, list) {
 			efi_pstore_scan_sysfs_enter(entry, n, head);
 
@@ -185,21 +180,21 @@ static int efi_pstore_sysfs_entry_iter(struct pstore_record *record,
 			if (size)
 				break;
 		}
-		*pos = n;
+		pos = n;
 		return size;
 	}
 
-	list_for_each_entry_safe_from((*pos), n, head, list) {
-		efi_pstore_scan_sysfs_enter((*pos), n, head);
+	list_for_each_entry_safe_from(pos, n, head, list) {
+		efi_pstore_scan_sysfs_enter(pos, n, head);
 
-		size = efi_pstore_read_func((*pos), record);
-		ret = efi_pstore_scan_sysfs_exit((*pos), n, head, size < 0);
+		size = efi_pstore_read_func(pos, record);
+		ret = efi_pstore_scan_sysfs_exit(pos, n, head, size < 0);
 		if (ret)
 			return ret;
 		if (size)
 			break;
 	}
-	*pos = n;
+	pos = n;
 	return size;
 }
 
@@ -218,7 +213,6 @@ static int efi_pstore_sysfs_entry_iter(struct pstore_record *record,
  */
 static ssize_t efi_pstore_read(struct pstore_record *record)
 {
-	struct efivar_entry *entry = (struct efivar_entry *)record->psi->data;
 	ssize_t size;
 
 	record->buf = kzalloc(EFIVARS_DATA_SIZE_MAX, GFP_KERNEL);
@@ -229,7 +223,7 @@ static ssize_t efi_pstore_read(struct pstore_record *record)
 		size = -EINTR;
 		goto out;
 	}
-	size = efi_pstore_sysfs_entry_iter(record, &entry);
+	size = efi_pstore_sysfs_entry_iter(record);
 	efivar_entry_iter_end();
 
 out:
-- 
2.7.4


-- 
Kees Cook
Pixel Security
