From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH] efi: mv efi_guid_unparse -> efi_guid_to_str
Date: Thu, 18 Dec 2014 16:02:17 +0100
Message-ID: <1418914937-9614-1-git-send-email-bp@alien8.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>

Call it what it does - "unparse" is plain-misleading.

Signed-off-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
---
 block/partitions/efi.c         | 2 +-
 drivers/firmware/efi/efi.c     | 4 ++--
 drivers/firmware/efi/efivars.c | 6 +++---
 fs/efivarfs/super.c            | 2 +-
 include/linux/efi.h            | 2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index 56d08fd75b1a..26cb624ace05 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -715,7 +715,7 @@ int efi_partition(struct parsed_partitions *state)
 			state->parts[i + 1].flags = ADDPART_FLAG_RAID;
 
 		info = &state->parts[i + 1].info;
-		efi_guid_unparse(&ptes[i].unique_partition_guid, info->uuid);
+		efi_guid_to_str(&ptes[i].unique_partition_guid, info->uuid);
 
 		/* Naively convert UTF16-LE to 7 bits. */
 		label_max = min(ARRAY_SIZE(info->volname) - 1,
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 9035c1b74d58..a85d8ac20ec6 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -276,10 +276,10 @@ static __init int match_config_table(efi_guid_t *guid,
 	int i;
 
 	if (table_types) {
-		efi_guid_unparse(guid, str);
+		efi_guid_to_str(guid, str);
 
 		for (i = 0; efi_guidcmp(table_types[i].guid, NULL_GUID); i++) {
-			efi_guid_unparse(&table_types[i].guid, str);
+			efi_guid_to_str(&table_types[i].guid, str);
 
 			if (!efi_guidcmp(*guid, table_types[i].guid)) {
 				*(table_types[i].ptr) = table;
diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index f256ecd8a176..7b2e0496e0c0 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -39,7 +39,7 @@
  *   fix locking per Peter Chubb's findings
  *
  *  25 Mar 2002 - Matt Domsch <Matt_Domsch-8PEkshWhKlo@public.gmane.org>
- *   move uuid_unparse() to include/asm-ia64/efi.h:efi_guid_unparse()
+ *   move uuid_unparse() to include/asm-ia64/efi.h:efi_guid_to_str()
  *
  *  12 Feb 2002 - Matt Domsch <Matt_Domsch-8PEkshWhKlo@public.gmane.org>
  *   use list_for_each_safe when deleting vars.
@@ -128,7 +128,7 @@ efivar_guid_read(struct efivar_entry *entry, char *buf)
 	if (!entry || !buf)
 		return 0;
 
-	efi_guid_unparse(&var->VendorGuid, str);
+	efi_guid_to_str(&var->VendorGuid, str);
 	str += strlen(str);
 	str += sprintf(str, "\n");
 
@@ -569,7 +569,7 @@ efivar_create_sysfs_entry(struct efivar_entry *new_var)
 	   private variables from another's.         */
 
 	*(short_name + strlen(short_name)) = '-';
-	efi_guid_unparse(&new_var->var.VendorGuid,
+	efi_guid_to_str(&new_var->var.VendorGuid,
 			 short_name + strlen(short_name));
 
 	new_var->kobj.kset = efivars_kset;
diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 6dad1176ec52..ddbce42548c9 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -140,7 +140,7 @@ static int efivarfs_callback(efi_char16_t *name16, efi_guid_t vendor,
 
 	name[len] = '-';
 
-	efi_guid_unparse(&entry->var.VendorGuid, name + len + 1);
+	efi_guid_to_str(&entry->var.VendorGuid, name + len + 1);
 
 	name[len + EFI_VARIABLE_GUID_LEN+1] = '\0';
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 0238d612750e..b674837e2b98 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -848,7 +848,7 @@ efi_guidcmp (efi_guid_t left, efi_guid_t right)
 }
 
 static inline char *
-efi_guid_unparse(efi_guid_t *guid, char *out)
+efi_guid_to_str(efi_guid_t *guid, char *out)
 {
 	sprintf(out, "%pUl", guid->b);
         return out;
-- 
2.2.0.33.gc18b867
