From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 06/10] efi: dmi: add support for SMBIOS 3.0 UEFI configuration table
Date: Tue, 28 Oct 2014 17:18:39 +0100
Message-ID: <1414513123-20400-7-git-send-email-ard.biesheuvel@linaro.org>
References: <1414513123-20400-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414513123-20400-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, yi.li-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This adds support to the UEFI side for detecting the presence of
a SMBIOS 3.0 64-bit entry point. This allows the actual SMBIOS
structure table to reside at a physical offset over 4 GB, which
cannot be supported by the legacy SMBIOS 32-bit entry point.

Since the firmware can legally provide both entry points, store
the SMBIOS 3.0 entry point in a separate variable, and let the
DMI decoding layer decide which one will be used.

Tested-by: Suravee Suthikulpanit <suravee.suthikulpanit-5C7GfCeVMHo@public.gmane.org>
Acked-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/efi.c | 4 ++++
 drivers/xen/efi.c          | 1 +
 include/linux/efi.h        | 6 +++++-
 3 files changed, 10 insertions(+), 1 deletion(-)

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
diff --git a/drivers/xen/efi.c b/drivers/xen/efi.c
index 1f850c97482f..f745db270171 100644
--- a/drivers/xen/efi.c
+++ b/drivers/xen/efi.c
@@ -294,6 +294,7 @@ static const struct efi efi_xen __initconst = {
 	.acpi                     = EFI_INVALID_TABLE_ADDR,
 	.acpi20                   = EFI_INVALID_TABLE_ADDR,
 	.smbios                   = EFI_INVALID_TABLE_ADDR,
+	.smbios3                  = EFI_INVALID_TABLE_ADDR,
 	.sal_systab               = EFI_INVALID_TABLE_ADDR,
 	.boot_info                = EFI_INVALID_TABLE_ADDR,
 	.hcdp                     = EFI_INVALID_TABLE_ADDR,
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 0949f9c7e872..0238d612750e 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -547,6 +547,9 @@ void efi_native_runtime_setup(void);
 #define SMBIOS_TABLE_GUID    \
     EFI_GUID(  0xeb9d2d31, 0x2d88, 0x11d3, 0x9a, 0x16, 0x0, 0x90, 0x27, 0x3f, 0xc1, 0x4d )
 
+#define SMBIOS3_TABLE_GUID    \
+    EFI_GUID(  0xf2fd1544, 0x9794, 0x4a2c, 0x99, 0x2e, 0xe5, 0xbb, 0xcf, 0x20, 0xe3, 0x94 )
+
 #define SAL_SYSTEM_TABLE_GUID    \
     EFI_GUID(  0xeb9d2d32, 0x2d88, 0x11d3, 0x9a, 0x16, 0x0, 0x90, 0x27, 0x3f, 0xc1, 0x4d )
 
@@ -810,7 +813,8 @@ extern struct efi {
 	unsigned long mps;		/* MPS table */
 	unsigned long acpi;		/* ACPI table  (IA64 ext 0.71) */
 	unsigned long acpi20;		/* ACPI table  (ACPI 2.0) */
-	unsigned long smbios;		/* SM BIOS table */
+	unsigned long smbios;		/* SMBIOS table (32 bit entry point) */
+	unsigned long smbios3;		/* SMBIOS table (64 bit entry point) */
 	unsigned long sal_systab;	/* SAL system table */
 	unsigned long boot_info;	/* boot info table */
 	unsigned long hcdp;		/* HCDP table */
-- 
1.8.3.2
