From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 12/40] efi: Add support for the EFI_MEMORY_ATTRIBUTES_TABLE config table
Date: Mon, 25 Apr 2016 21:06:44 +0100
Message-ID: <1461614832-17633-13-git-send-email-matt@codeblueprint.co.uk>
References: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Catalin Marinas <catalin.marinas@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Peter Jones <pjones@redhat.com>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

This declares the GUID and struct typedef for the new memory attributes
table which contains the permissions that can be used to apply stricter
permissions to UEFI Runtime Services memory regions.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Peter Jones <pjones@redhat.com>
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 drivers/firmware/efi/efi.c |  2 ++
 include/linux/efi.h        | 13 +++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index f7d36c6cc1ad..583e647912a5 100644
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
index c2c0da49876e..81af5feba1f7 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -623,6 +623,10 @@ void efi_native_runtime_setup(void);
 	EFI_GUID(0x3152bca5, 0xeade, 0x433d, \
 		 0x86, 0x2e, 0xc0, 0x1c, 0xdc, 0x29, 0x1f, 0x44)
 
+#define EFI_MEMORY_ATTRIBUTES_TABLE_GUID \
+	EFI_GUID(0xdcfa911d, 0x26eb, 0x469f, \
+		 0xa2, 0x20, 0x38, 0xb7, 0xdc, 0x46, 0x12, 0x20)
+
 typedef struct {
 	efi_guid_t guid;
 	u64 table;
@@ -847,6 +851,14 @@ typedef struct {
 
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
@@ -868,6 +880,7 @@ extern struct efi {
 	unsigned long config_table;	/* config tables */
 	unsigned long esrt;		/* ESRT table */
 	unsigned long properties_table;	/* properties table */
+	unsigned long mem_attr_table;	/* memory attributes table */
 	efi_get_time_t *get_time;
 	efi_set_time_t *set_time;
 	efi_get_wakeup_time_t *get_wakeup_time;
-- 
2.7.3
