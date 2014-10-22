From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 08/10] dmi: add support for SMBIOS 3.0 64-bit entry point
Date: Wed, 22 Oct 2014 16:21:51 +0200
Message-ID: <1413987713-30528-9-git-send-email-ard.biesheuvel@linaro.org>
References: <1413987713-30528-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1413987713-30528-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yi.li-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The DMTF SMBIOS reference spec v3.0.0 defines a new 64-bit entry point,
which enables support for SMBIOS structure tables residing at a physical
offset over 4 GB. This is especially important for upcoming arm64
platforms whose system RAM resides entirely above the 4 GB boundary.

For the UEFI case, this code attempts to detect the new SMBIOS 3.0
header magic at the offset passed in the SMBIOS3_TABLE_GUID UEFI
configuration table. If this configuration table is not provided, or
if we fail to parse the header, we fall back to using the legacy
SMBIOS_TABLE_GUID configuration table. This is in line with the spec,
that allows both configuration tables to be provided, but mandates that
they must point to the same structure table, unless the version pointed
to by the 64-bit entry point is a superset of the 32-bit one.

For the non-UEFI case, the detection logic is modified to look for the
SMBIOS 3.0 header magic before it looks for the legacy header magic.

Note that this patch is based on version 3.0.0d [draft] of the
specification, which is expected not to deviate from the final version
in ways that would affect the correctness of this implementation.

Tested-by: Suravee Suthikulpanit <suravee.suthikulpanit-5C7GfCeVMHo@public.gmane.org>
Acked-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/dmi_scan.c | 70 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 68 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index 17afc51f3054..a698b90ed14f 100644
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
+		 * bound for the number of structures in the table.
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
+		 * According to the DMTF SMBIOS reference spec v3.0.0, it is
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
-- 
1.8.3.2
