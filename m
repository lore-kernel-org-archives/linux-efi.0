From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [RFC PATCH] dmi: add support for SMBIOS 3.0 64-bit entry point
Date: Mon, 13 Oct 2014 15:48:33 +0200
Message-ID: <1413208113-16374-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Suravee.Suthikulpanit-5C7GfCeVMHo@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Version 3.0 of the DTMF SMBIOS reference spec defines a new entry point
type that supports a 64-bit address for the SMBIOS structure table. This
is needed by platforms whose system RAM resides above the 4 GB physical
address boundary, such as upcoming 64-bit ARM platforms.

This is a preliminary RFC implementation, as there is no definition available
yet for SMBIOS3_TABLE_GUID, which the (currently still in draft) SMBIOS v3.0
spec refers to.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/dmi_scan.c | 70 +++++++++++++++++++++++++++++++++++++++++++--
 drivers/firmware/efi/efi.c  |  4 +++
 include/linux/efi.h         |  6 +++-
 3 files changed, 77 insertions(+), 3 deletions(-)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 17afc51f3054..6e33072c3ac3 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -93,6 +93,12 @@ static void dmi_table(u8 *buf, int len, int num,
 		const struct dmi_header *dm = (const struct dmi_header *)data;
 
 		/*
+		 * 7.45 End-of-Table (Type 127) [SMBIOS reference spec v3.0.0]
+		 */
+		if (dm->type == 127)
+			break;
+
+		/*
 		 *  We want to know the total length (formatted area and
 		 *  strings) before decoding to make sure we won't run off the
 		 *  table in dmi_decode or dmi_string
@@ -107,7 +113,7 @@ static void dmi_table(u8 *buf, int len, int num,
 	}
 }
 
-static u32 dmi_base;
+static phys_addr_t dmi_base;
 static u16 dmi_len;
 static u16 dmi_num;
 
@@ -514,12 +520,72 @@ static int __init dmi_present(const u8 *buf)
 	return 1;
 }
 
+/*
+ * Check for the SMBIOS 3.0 64-bit entry point signature. Unlike the legacy
+ * 32-bit entry point, there is no embedded DMI header (_DMI_) in here.
+ */
+static int __init dmi_smbios3_present(const u8 *buf)
+{
+	if (memcmp(buf, "_SM3_", 5) == 0 &&
+	    buf[6] < 32 && dmi_checksum(buf, buf[6])) {
+		dmi_ver = get_unaligned_be16(buf + 7);
+		dmi_len = get_unaligned_le32(buf + 12);
+		dmi_base = get_unaligned_le64(buf + 16);
+
+		/*
+		 * The 64-bit SMBIOS 3.0 entry point no longer has a field
+		 * containing the number of structures present in the table.
+		 * Instead, it defines the table size as a maximum size, and
+		 * relies on the end-of-table structure type (#127) to be used
+		 * to signal the end of the table.
+		 * So let's define dmi_num as an upper bound as well: each
+		 * structure has a 4 byte header, so dmi_len / 4 is an upper
+		 * bound of the number of structures in the table.
+		 */
+		dmi_num = dmi_len / 4;
+
+		if (dmi_walk_early(dmi_decode) == 0) {
+			pr_info("SMBIOS %d.%d present.\n",
+			        dmi_ver >> 8, dmi_ver & 0xFF);
+			dmi_format_ids(dmi_ids_string, sizeof(dmi_ids_string));
+			printk(KERN_DEBUG "DMI: %s\n", dmi_ids_string);
+			return 0;
+		}
+	}
+	return 1;
+}
+
 void __init dmi_scan_machine(void)
 {
 	char __iomem *p, *q;
 	char buf[32];
 
 	if (efi_enabled(EFI_CONFIG_TABLES)) {
+		/*
+		 * According to the DTMF SMBIOS reference spec v3.0.0, it is
+		 * allowed to define both the 64-bit entry point (smbios3) and
+		 * the 32-bit entry point (smbios), in which case they should
+		 * either both point to the same SMBIOS structure table, or the
+		 * table pointed to by the 64-bit entry point should contain a
+		 * superset of the table contents pointed to by the 32-bit entry
+		 * point (section 5.2)
+		 * This implies that the 64-bit entry point should have
+		 * precedence if it is defined and supported by the OS. If we
+		 * have the 64-bit entry point, but fail to decode it, fall
+		 * back to the legacy one (if available)
+		 */
+		if (efi.smbios3 != EFI_INVALID_TABLE_ADDR) {
+			p = dmi_early_remap(efi.smbios3, 32);
+			if (p == NULL)
+				goto error;
+			memcpy_fromio(buf, p, 32);
+			dmi_early_unmap(p, 32);
+
+			if (!dmi_smbios3_present(buf)) {
+				dmi_available = 1;
+				goto out;
+			}
+		}
 		if (efi.smbios == EFI_INVALID_TABLE_ADDR)
 			goto error;
 
@@ -552,7 +618,7 @@ void __init dmi_scan_machine(void)
 		memset(buf, 0, 16);
 		for (q = p; q < p + 0x10000; q += 16) {
 			memcpy_fromio(buf + 16, q, 16);
-			if (!dmi_present(buf)) {
+			if (!dmi_smbios3_present(buf) || !dmi_present(buf)) {
 				dmi_available = 1;
 				dmi_early_unmap(p, 0x10000);
 				goto out;
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 8590099ac148..9035c1b74d58 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -30,6 +30,7 @@ struct efi __read_mostly efi = {
 	.acpi       = EFI_INVALID_TABLE_ADDR,
 	.acpi20     = EFI_INVALID_TABLE_ADDR,
 	.smbios     = EFI_INVALID_TABLE_ADDR,
+	.smbios3    = EFI_INVALID_TABLE_ADDR,
 	.sal_systab = EFI_INVALID_TABLE_ADDR,
 	.boot_info  = EFI_INVALID_TABLE_ADDR,
 	.hcdp       = EFI_INVALID_TABLE_ADDR,
@@ -86,6 +87,8 @@ static ssize_t systab_show(struct kobject *kobj,
 		str += sprintf(str, "ACPI=0x%lx\n", efi.acpi);
 	if (efi.smbios != EFI_INVALID_TABLE_ADDR)
 		str += sprintf(str, "SMBIOS=0x%lx\n", efi.smbios);
+	if (efi.smbios3 != EFI_INVALID_TABLE_ADDR)
+		str += sprintf(str, "SMBIOS3=0x%lx\n", efi.smbios3);
 	if (efi.hcdp != EFI_INVALID_TABLE_ADDR)
 		str += sprintf(str, "HCDP=0x%lx\n", efi.hcdp);
 	if (efi.boot_info != EFI_INVALID_TABLE_ADDR)
@@ -260,6 +263,7 @@ static __initdata efi_config_table_type_t common_tables[] = {
 	{MPS_TABLE_GUID, "MPS", &efi.mps},
 	{SAL_SYSTEM_TABLE_GUID, "SALsystab", &efi.sal_systab},
 	{SMBIOS_TABLE_GUID, "SMBIOS", &efi.smbios},
+	{SMBIOS3_TABLE_GUID, "SMBIOS 3.0", &efi.smbios3},
 	{UGA_IO_PROTOCOL_GUID, "UGA", &efi.uga},
 	{NULL_GUID, NULL, NULL},
 };
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 0949f9c7e872..7704f587fc15 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -547,6 +547,9 @@ void efi_native_runtime_setup(void);
 #define SMBIOS_TABLE_GUID    \
     EFI_GUID(  0xeb9d2d31, 0x2d88, 0x11d3, 0x9a, 0x16, 0x0, 0x90, 0x27, 0x3f, 0xc1, 0x4d )
 
+#define SMBIOS3_TABLE_GUID    \
+    EFI_GUID(  0x00000000, 0x0000, 0x0000, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 )
+
 #define SAL_SYSTEM_TABLE_GUID    \
     EFI_GUID(  0xeb9d2d32, 0x2d88, 0x11d3, 0x9a, 0x16, 0x0, 0x90, 0x27, 0x3f, 0xc1, 0x4d )
 
@@ -810,7 +813,8 @@ extern struct efi {
 	unsigned long mps;		/* MPS table */
 	unsigned long acpi;		/* ACPI table  (IA64 ext 0.71) */
 	unsigned long acpi20;		/* ACPI table  (ACPI 2.0) */
-	unsigned long smbios;		/* SM BIOS table */
+	unsigned long smbios;		/* SM BIOS table (32 bit entry point) */
+	unsigned long smbios3;		/* SM BIOS table (64 bit entry point) */
 	unsigned long sal_systab;	/* SAL system table */
 	unsigned long boot_info;	/* boot info table */
 	unsigned long hcdp;		/* HCDP table */
-- 
1.8.3.2
