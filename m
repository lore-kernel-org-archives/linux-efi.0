From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 05/10] efi: Constify InstallConfigurationTable()
Date: Mon, 2 Jan 2017 11:24:33 +0100
Message-ID: <8d90a074b0bb7b50f7a87ced010ffab2e077e141.1483318593.git.lukas@wunner.de>
References: <cover.1483318593.git.lukas@wunner.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1483318593.git.lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

GUIDs passed to InstallConfigurationTable() are not modified, so declare
them const.  This allows the compiler to place them in the rodata
section instead of generating them on the stack at runtime.  Pass GUIDs
as literals rather than assigning them to temporary variables to save a
bit on code.  Constification of the GUIDs is in compliance with the EFI
spec which marks them "IN" for this boot service.

Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
---
 drivers/firmware/efi/libstub/arm32-stub.c | 2 +-
 drivers/firmware/efi/libstub/random.c     | 5 ++---
 include/linux/efi.h                       | 2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/firmware/efi/libstub/arm32-stub.c b/drivers/firmware/efi/libstub/arm32-stub.c
index e1f0b28..1be40b6 100644
--- a/drivers/firmware/efi/libstub/arm32-stub.c
+++ b/drivers/firmware/efi/libstub/arm32-stub.c
@@ -26,7 +26,7 @@ efi_status_t check_platform_features(efi_system_table_t *sys_table_arg)
 	return EFI_SUCCESS;
 }
 
-static efi_guid_t screen_info_guid = LINUX_EFI_ARM_SCREEN_INFO_TABLE_GUID;
+static const efi_guid_t screen_info_guid = LINUX_EFI_ARM_SCREEN_INFO_TABLE_GUID;
 
 struct screen_info *alloc_screen_info(efi_system_table_t *sys_table_arg)
 {
diff --git a/drivers/firmware/efi/libstub/random.c b/drivers/firmware/efi/libstub/random.c
index ffb1130..c29a722 100644
--- a/drivers/firmware/efi/libstub/random.c
+++ b/drivers/firmware/efi/libstub/random.c
@@ -149,7 +149,6 @@ efi_status_t efi_random_alloc(efi_system_table_t *sys_table_arg,
 efi_status_t efi_random_get_seed(efi_system_table_t *sys_table_arg)
 {
 	efi_guid_t rng_algo_raw = EFI_RNG_ALGORITHM_RAW;
-	efi_guid_t rng_table_guid = LINUX_EFI_RANDOM_SEED_TABLE_GUID;
 	struct efi_rng_protocol *rng;
 	struct linux_efi_random_seed *seed;
 	efi_status_t status;
@@ -179,8 +178,8 @@ efi_status_t efi_random_get_seed(efi_system_table_t *sys_table_arg)
 		goto err_freepool;
 
 	seed->size = RANDOM_SEED_SIZE;
-	status = efi_call_early(install_configuration_table, &rng_table_guid,
-				seed);
+	status = efi_call_early(install_configuration_table,
+				&LINUX_EFI_RANDOM_SEED_TABLE_GUID, seed);
 	if (status != EFI_SUCCESS)
 		goto err_freepool;
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index c4923c1f..0c260f0 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -300,7 +300,7 @@ struct efi_boot_memmap {
 	efi_status_t (*locate_handle)(int, const efi_guid_t *, void *,
 				      unsigned long *, efi_handle_t *);
 	void *locate_device_path;
-	efi_status_t (*install_configuration_table)(efi_guid_t *, void *);
+	efi_status_t (*install_configuration_table)(const efi_guid_t *, void *);
 	void *load_image;
 	void *start_image;
 	void *exit;
-- 
2.11.0
