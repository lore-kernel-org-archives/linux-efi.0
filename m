From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 06/10] efi: Constify EFI_FILE_PROTOCOL.GetInfo()
Date: Mon, 2 Jan 2017 11:24:33 +0100
Message-ID: <a14e271025a5cb235b464abe77ccbced9dfc7d80.1483318593.git.lukas@wunner.de>
References: <cover.1483318593.git.lukas@wunner.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1483318593.git.lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

GUIDs passed to EFI_FILE_PROTOCOL.GetInfo() are not modified, so declare
them const.  This allows the compiler to place them in the rodata
section instead of generating them on the stack at runtime.  Pass GUIDs
as literals rather than assigning them to temporary variables to save a
bit on code.  Constification of the GUIDs is in compliance with the EFI
spec which marks them "IN" for this protocol function.

Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 5 ++---
 include/linux/efi.h                            | 2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 6ee9164..8e06307 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -345,7 +345,6 @@ static efi_status_t efi_file_size(efi_system_table_t *sys_table_arg, void *__fh,
 	efi_file_handle_t *h, *fh = __fh;
 	efi_file_info_t *info;
 	efi_status_t status;
-	efi_guid_t info_guid = EFI_FILE_INFO_ID;
 	unsigned long info_sz;
 
 	status = efi_call_proto(efi_file_handle, open, fh, &h, filename_16,
@@ -360,7 +359,7 @@ static efi_status_t efi_file_size(efi_system_table_t *sys_table_arg, void *__fh,
 	*handle = h;
 
 	info_sz = 0;
-	status = efi_call_proto(efi_file_handle, get_info, h, &info_guid,
+	status = efi_call_proto(efi_file_handle, get_info, h, &EFI_FILE_INFO_ID,
 				&info_sz, NULL);
 	if (status != EFI_BUFFER_TOO_SMALL) {
 		efi_printk(sys_table_arg, "Failed to get file info size\n");
@@ -375,7 +374,7 @@ static efi_status_t efi_file_size(efi_system_table_t *sys_table_arg, void *__fh,
 		return status;
 	}
 
-	status = efi_call_proto(efi_file_handle, get_info, h, &info_guid,
+	status = efi_call_proto(efi_file_handle, get_info, h, &EFI_FILE_INFO_ID,
 				&info_sz, info);
 	if (status == EFI_BUFFER_TOO_SMALL) {
 		efi_call_early(free_pool, info);
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 0c260f0..6ed28e1 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -838,7 +838,7 @@ struct efi_fdt_params {
 	void *write;
 	void *get_position;
 	void *set_position;
-	efi_status_t (*get_info)(struct _efi_file_handle *, efi_guid_t *,
+	efi_status_t (*get_info)(struct _efi_file_handle *, const efi_guid_t *,
 			unsigned long *, void *);
 	void *set_info;
 	void *flush;
-- 
2.11.0
