From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/5] efi: add support for the EFI_MEMORY_ATTRIBUTES_TABLE config table
Date: Mon, 22 Feb 2016 15:25:56 +0100
Message-ID: <1456151158-25849-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1456151158-25849-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456151158-25849-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This declares the GUID and struct typedef for the new memory attributes
table which contains the permissions that can be used to apply stricter
permissions to UEFI Runtime Services memory regions.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/efi.c |  2 ++
 include/linux/efi.h        | 13 +++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 3a69ed5ecfcb..5683865baa92 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -43,6 +43,7 @@ struct efi __read_mostly efi = {
 	.config_table		= EFI_INVALID_TABLE_ADDR,
 	.esrt			= EFI_INVALID_TABLE_ADDR,
 	.properties_table	= EFI_INVALID_TABLE_ADDR,
+	.mem_attr_table		= EFI_INVALID_TABLE_ADDR,
 };
 EXPORT_SYMBOL(efi);
 
@@ -338,6 +339,7 @@ static __initdata efi_config_table_type_t common_tables[] = {
 	{UGA_IO_PROTOCOL_GUID, "UGA", &efi.uga},
 	{EFI_SYSTEM_RESOURCE_TABLE_GUID, "ESRT", &efi.esrt},
 	{EFI_PROPERTIES_TABLE_GUID, "PROP", &efi.properties_table},
+	{EFI_MEMORY_ATTRIBUTES_TABLE_GUID, "MEMATTR", &efi.mem_attr_table},
 	{NULL_GUID, NULL, NULL},
 };
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 42be9c92fdf0..808d97299c70 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -619,6 +619,10 @@ void efi_native_runtime_setup(void);
 	EFI_GUID(0x880aaca3, 0x4adc, 0x4a04, \
 		 0x90, 0x79, 0xb7, 0x47, 0x34, 0x08, 0x25, 0xe5)
 
+#define EFI_MEMORY_ATTRIBUTES_TABLE_GUID \
+	EFI_GUID(0xdcfa911d, 0x26eb, 0x469f, \
+		 0xa2, 0x20, 0x38, 0xb7, 0xdc, 0x46, 0x12, 0x20)
+
 typedef struct {
 	efi_guid_t guid;
 	u64 table;
@@ -843,6 +847,14 @@ typedef struct {
 
 #define EFI_INVALID_TABLE_ADDR		(~0UL)
 
+typedef struct {
+	u32 version;
+	u32 num_entries;
+	u32 desc_size;
+	u32 reserved;
+	efi_memory_desc_t entry[0];
+} efi_memory_attributes_table_t;
+
 /*
  * All runtime access to EFI goes through this structure:
  */
@@ -864,6 +876,7 @@ extern struct efi {
 	unsigned long config_table;	/* config tables */
 	unsigned long esrt;		/* ESRT table */
 	unsigned long properties_table;	/* properties table */
+	unsigned long mem_attr_table;	/* memory attributes table */
 	efi_get_time_t *get_time;
 	efi_set_time_t *set_time;
 	efi_get_wakeup_time_t *get_wakeup_time;
-- 
2.5.0
