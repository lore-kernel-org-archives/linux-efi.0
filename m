From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 09/10] efi: Constify efi_guidcmp() arguments
Date: Mon, 2 Jan 2017 11:24:33 +0100
Message-ID: <6cbd46695186be8648555a1ce01548ac8888fee2.1483318593.git.lukas@wunner.de>
References: <cover.1483318593.git.lukas@wunner.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1483318593.git.lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

GUIDs passed to efi_guidcmp() are not modified, so declare them const.
This allows the compiler to place them in the rodata section instead of
generating them on the stack at runtime.  Pass GUIDs as literals rather
than assigning them to temporary variables to save a bit on code.

Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>
Cc: Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
---
 drivers/firmware/efi/efi-pstore.c  | 6 ++----
 drivers/firmware/efi/libstub/fdt.c | 3 +--
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index 0911449..e7c9fd1 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -46,7 +46,6 @@ static inline u64 generic_id(unsigned long timestamp,
 
 static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 {
-	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
 	struct pstore_read_data *cb_data = data;
 	char name[DUMP_NAME_LEN], data_type;
 	int i;
@@ -54,7 +53,7 @@ static int efi_pstore_read_func(struct efivar_entry *entry, void *data)
 	unsigned int part;
 	unsigned long time, size;
 
-	if (efi_guidcmp(entry->var.VendorGuid, vendor))
+	if (efi_guidcmp(entry->var.VendorGuid, LINUX_EFI_CRASH_GUID))
 		return 0;
 
 	for (i = 0; i < DUMP_NAME_LEN; i++)
@@ -299,14 +298,13 @@ struct pstore_erase_data {
 static int efi_pstore_erase_func(struct efivar_entry *entry, void *data)
 {
 	struct pstore_erase_data *ed = data;
-	efi_guid_t vendor = LINUX_EFI_CRASH_GUID;
 	efi_char16_t efi_name_old[DUMP_NAME_LEN];
 	efi_char16_t *efi_name = ed->name;
 	unsigned long ucs2_len = ucs2_strlen(ed->name);
 	char name_old[DUMP_NAME_LEN];
 	int i;
 
-	if (efi_guidcmp(entry->var.VendorGuid, vendor))
+	if (efi_guidcmp(entry->var.VendorGuid, LINUX_EFI_CRASH_GUID))
 		return 0;
 
 	if (ucs2_strncmp(entry->var.VariableName,
diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index a6a9311..6ebc3bb 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -332,7 +332,6 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 
 void *get_fdt(efi_system_table_t *sys_table, unsigned long *fdt_size)
 {
-	efi_guid_t fdt_guid = DEVICE_TREE_GUID;
 	efi_config_table_t *tables;
 	void *fdt;
 	int i;
@@ -341,7 +340,7 @@ void *get_fdt(efi_system_table_t *sys_table, unsigned long *fdt_size)
 	fdt = NULL;
 
 	for (i = 0; i < sys_table->nr_tables; i++)
-		if (efi_guidcmp(tables[i].guid, fdt_guid) == 0) {
+		if (efi_guidcmp(tables[i].guid, DEVICE_TREE_GUID) == 0) {
 			fdt = (void *) tables[i].table;
 			if (fdt_check_header(fdt) != 0) {
 				pr_efi_err(sys_table, "Invalid header detected on UEFI supplied FDT, ignoring ...\n");
-- 
2.11.0
