From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/2] efi: add support for UEFIv2.5 Properties table
Date: Wed,  9 Sep 2015 10:08:15 +0200
Message-ID: <1441786096-8514-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Version 2.5 of the UEFI spec introduces a new configuration table
called the 'EFI Properties table'. Currently, it is only used to
convey whether the Memory Protection feature is enabled, which splits
PE/COFF images into separate code and data memory regions.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/efi.c | 32 ++++++++++++++++++--------------
 include/linux/efi.h        | 13 +++++++++++++
 2 files changed, 31 insertions(+), 14 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index d6144e3b97c5..5cbb8d31da33 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -26,20 +26,21 @@
 #include <linux/platform_device.h>
 
 struct efi __read_mostly efi = {
-	.mps        = EFI_INVALID_TABLE_ADDR,
-	.acpi       = EFI_INVALID_TABLE_ADDR,
-	.acpi20     = EFI_INVALID_TABLE_ADDR,
-	.smbios     = EFI_INVALID_TABLE_ADDR,
-	.smbios3    = EFI_INVALID_TABLE_ADDR,
-	.sal_systab = EFI_INVALID_TABLE_ADDR,
-	.boot_info  = EFI_INVALID_TABLE_ADDR,
-	.hcdp       = EFI_INVALID_TABLE_ADDR,
-	.uga        = EFI_INVALID_TABLE_ADDR,
-	.uv_systab  = EFI_INVALID_TABLE_ADDR,
-	.fw_vendor  = EFI_INVALID_TABLE_ADDR,
-	.runtime    = EFI_INVALID_TABLE_ADDR,
-	.config_table  = EFI_INVALID_TABLE_ADDR,
-	.esrt       = EFI_INVALID_TABLE_ADDR,
+	.mps			= EFI_INVALID_TABLE_ADDR,
+	.acpi			= EFI_INVALID_TABLE_ADDR,
+	.acpi20			= EFI_INVALID_TABLE_ADDR,
+	.smbios			= EFI_INVALID_TABLE_ADDR,
+	.smbios3		= EFI_INVALID_TABLE_ADDR,
+	.sal_systab		= EFI_INVALID_TABLE_ADDR,
+	.boot_info		= EFI_INVALID_TABLE_ADDR,
+	.hcdp			= EFI_INVALID_TABLE_ADDR,
+	.uga			= EFI_INVALID_TABLE_ADDR,
+	.uv_systab		= EFI_INVALID_TABLE_ADDR,
+	.fw_vendor		= EFI_INVALID_TABLE_ADDR,
+	.runtime		= EFI_INVALID_TABLE_ADDR,
+	.config_table		= EFI_INVALID_TABLE_ADDR,
+	.esrt			= EFI_INVALID_TABLE_ADDR,
+	.properties_table	= EFI_INVALID_TABLE_ADDR,
 };
 EXPORT_SYMBOL(efi);
 
@@ -105,6 +106,8 @@ static ssize_t systab_show(struct kobject *kobj,
 		str += sprintf(str, "BOOTINFO=0x%lx\n", efi.boot_info);
 	if (efi.uga != EFI_INVALID_TABLE_ADDR)
 		str += sprintf(str, "UGA=0x%lx\n", efi.uga);
+	if (efi.properties_table != EFI_INVALID_TABLE_ADDR)
+		str += sprintf(str, "PROP=0x%lx\n", efi.properties_table);
 
 	return str - buf;
 }
@@ -362,6 +365,7 @@ static __initdata efi_config_table_type_t common_tables[] = {
 	{SMBIOS3_TABLE_GUID, "SMBIOS 3.0", &efi.smbios3},
 	{UGA_IO_PROTOCOL_GUID, "UGA", &efi.uga},
 	{EFI_SYSTEM_RESOURCE_TABLE_GUID, "ESRT", &efi.esrt},
+	{EFI_PROPERTIES_TABLE_GUID, "PROP", &efi.properties_table},
 	{NULL_GUID, NULL, NULL},
 };
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 85ef051ac6fb..5b4f3ac08053 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -595,6 +595,9 @@ void efi_native_runtime_setup(void);
 #define DEVICE_TREE_GUID \
     EFI_GUID(  0xb1b621d5, 0xf19c, 0x41a5, 0x83, 0x0b, 0xd9, 0x15, 0x2c, 0x69, 0xaa, 0xe0 )
 
+#define EFI_PROPERTIES_TABLE_GUID \
+    EFI_GUID(  0x880aaca3, 0x4adc, 0x4a04, 0x90, 0x79, 0xb7, 0x47, 0x34, 0x08, 0x25, 0xe5 )
+
 typedef struct {
 	efi_guid_t guid;
 	u64 table;
@@ -808,6 +811,15 @@ typedef struct _efi_file_io_interface {
 #define EFI_FILE_MODE_WRITE	0x0000000000000002
 #define EFI_FILE_MODE_CREATE	0x8000000000000000
 
+typedef struct {
+	u32 version;
+	u32 length;
+	u64 memory_protection_attribute;
+} efi_properties_table_t;
+
+#define EFI_PROPERTIES_TABLE_VERSION	0x00010000
+#define EFI_PROPERTIES_RUNTIME_MEMORY_PROTECTION_NON_EXECUTABLE_PE_DATA	0x1
+
 #define EFI_INVALID_TABLE_ADDR		(~0UL)
 
 /*
@@ -830,6 +842,7 @@ extern struct efi {
 	unsigned long runtime;		/* runtime table */
 	unsigned long config_table;	/* config tables */
 	unsigned long esrt;		/* ESRT table */
+	unsigned long properties_table;	/* properties table */
 	efi_get_time_t *get_time;
 	efi_set_time_t *set_time;
 	efi_get_wakeup_time_t *get_wakeup_time;
-- 
1.9.1
