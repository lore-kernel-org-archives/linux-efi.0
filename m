From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: [PATCH 07/11] efi: Add support for UEFIv2.5 Properties table
Date: Mon, 12 Oct 2015 14:56:10 +0100
Message-ID: <1444658174-23378-8-git-send-email-matt@codeblueprint.co.uk>
References: <1444658174-23378-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444658174-23378-1-git-send-email-matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Version 2.5 of the UEFI spec introduces a new configuration table
called the 'EFI Properties table'. Currently, it is only used to
convey whether the Memory Protection feature is enabled, which splits
PE/COFF images into separate code and data memory regions.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Acked-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efi/efi.c | 30 ++++++++++++++++--------------
 include/linux/efi.h        | 13 +++++++++++++
 2 files changed, 29 insertions(+), 14 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 278d4d88d250..c297d78f50fd 100644
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
 
@@ -365,6 +366,7 @@ static __initdata efi_config_table_type_t common_tables[] = {
 	{SMBIOS3_TABLE_GUID, "SMBIOS 3.0", &efi.smbios3},
 	{UGA_IO_PROTOCOL_GUID, "UGA", &efi.uga},
 	{EFI_SYSTEM_RESOURCE_TABLE_GUID, "ESRT", &efi.esrt},
+	{EFI_PROPERTIES_TABLE_GUID, "PROP", &efi.properties_table},
 	{NULL_GUID, NULL, NULL},
 };
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 4677d8a1bfd0..d6a9bee755f2 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -596,6 +596,9 @@ void efi_native_runtime_setup(void);
 #define DEVICE_TREE_GUID \
     EFI_GUID(  0xb1b621d5, 0xf19c, 0x41a5, 0x83, 0x0b, 0xd9, 0x15, 0x2c, 0x69, 0xaa, 0xe0 )
 
+#define EFI_PROPERTIES_TABLE_GUID \
+    EFI_GUID(  0x880aaca3, 0x4adc, 0x4a04, 0x90, 0x79, 0xb7, 0x47, 0x34, 0x08, 0x25, 0xe5 )
+
 typedef struct {
 	efi_guid_t guid;
 	u64 table;
@@ -809,6 +812,15 @@ typedef struct _efi_file_io_interface {
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
@@ -831,6 +843,7 @@ extern struct efi {
 	unsigned long runtime;		/* runtime table */
 	unsigned long config_table;	/* config tables */
 	unsigned long esrt;		/* ESRT table */
+	unsigned long properties_table;	/* properties table */
 	efi_get_time_t *get_time;
 	efi_set_time_t *set_time;
 	efi_get_wakeup_time_t *get_wakeup_time;
-- 
2.1.0
