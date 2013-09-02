From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH v3 2/5] efi: provide a generic efi_config_init()
Date: Mon, 2 Sep 2013 10:29:02 +0100
Message-ID: <20130902092902.GE28598@console-pimps.org>
References: <1375901660-23541-1-git-send-email-leif.lindholm@linaro.org>
 <1375901660-23541-3-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ia64-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1375901660-23541-3-git-send-email-leif.lindholm@linaro.org>
Sender: linux-ia64-owner@vger.kernel.org
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org, matt.fleming@intel.com, tony.luck@gmail.com, grant.likely@secretlab.ca
List-Id: linux-efi@vger.kernel.org

On Wed, 07 Aug, at 07:54:17PM, Leif Lindholm wrote:
> Common to (U)EFI support on all platforms is the global "efi" data
> structure, and the code that parses the System Table to locate
> addresses to populate that structure with.
>=20
> This patch adds both of these to the global EFI driver code.
>=20
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> ---
>  drivers/firmware/efi/efi.c |  108 ++++++++++++++++++++++++++++++++++=
++++++++++
>  include/linux/efi.h        |    7 +++
>  2 files changed, 115 insertions(+)

This patch actually breaks git bisection,

/home/build/git/efi/arch/x86/platform/efi/efi.c:581:19: error: conflict=
ing types for =E2=80=98efi_config_init=E2=80=99
In file included from /home/build/git/efi/arch/x86/platform/efi/efi.c:3=
3:0:
/home/build/git/efi/include/linux/efi.h:596:12: note: previous declarat=
ion of =E2=80=98efi_config_init=E2=80=99 was here

I've merged patches 2,3 and 4 into the following single patch so that
the ability to bisect isn't lost. Does it look OK? It boots fine on my
test machines.

---

=46rom b985deaf988691cb62359f3379bdef3604278d15 Mon Sep 17 00:00:00 200=
1
=46rom: Leif Lindholm <leif.lindholm@linaro.org>
Date: Wed, 7 Aug 2013 19:54:17 +0100
Subject: [PATCH] efi: x86: ia64: provide a generic efi_config_init()

Common to (U)EFI support on all platforms is the global "efi" data
structure, and the code that parses the System Table to locate
addresses to populate that structure with.

This patch adds both of these to the global EFI driver code and
removes the local definition of the global "efi" data structure from
the x86 and ia64 code.

[ Squash into one big patch to avoid breaking bisection - Matt ]

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
Acked-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/ia64/kernel/efi.c      |  54 +++++-----------------
 arch/x86/platform/efi/efi.c |  96 ++++--------------------------------=
---
 drivers/firmware/efi/efi.c  | 108 ++++++++++++++++++++++++++++++++++++=
++++++++
 include/linux/efi.h         |   7 +++
 4 files changed, 134 insertions(+), 131 deletions(-)

diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
index 51bce59..da5b462 100644
--- a/arch/ia64/kernel/efi.c
+++ b/arch/ia64/kernel/efi.c
@@ -44,10 +44,15 @@
=20
 #define EFI_DEBUG	0
=20
+static __initdata unsigned long palo_phys;
+
+static __initdata efi_config_table_type_t arch_tables[] =3D {
+	{PROCESSOR_ABSTRACTION_LAYER_OVERWRITE_GUID, "PALO", &palo_phys},
+	{NULL_GUID, NULL, 0},
+};
+
 extern efi_status_t efi_call_phys (void *, ...);
=20
-struct efi efi;
-EXPORT_SYMBOL(efi);
 static efi_runtime_services_t *runtime;
 static u64 mem_limit =3D ~0UL, max_addr =3D ~0UL, min_addr =3D 0UL;
=20
@@ -423,9 +428,9 @@ static u8 __init palo_checksum(u8 *buffer, u32 leng=
th)
  * Parse and handle PALO table which is published at:
  * http://www.dig64.org/home/DIG64_PALO_R1_0.pdf
  */
-static void __init handle_palo(unsigned long palo_phys)
+static void __init handle_palo(unsigned long phys_addr)
 {
-	struct palo_table *palo =3D __va(palo_phys);
+	struct palo_table *palo =3D __va(phys_addr);
 	u8  checksum;
=20
 	if (strncmp(palo->signature, PALO_SIG, sizeof(PALO_SIG) - 1)) {
@@ -467,12 +472,10 @@ void __init
 efi_init (void)
 {
 	void *efi_map_start, *efi_map_end;
-	efi_config_table_t *config_tables;
 	efi_char16_t *c16;
 	u64 efi_desc_size;
 	char *cp, vendor[100] =3D "unknown";
 	int i;
-	unsigned long palo_phys;
=20
 	/*
 	 * It's too early to be able to use the standard kernel command line
@@ -514,8 +517,6 @@ efi_init (void)
 		       efi.systab->hdr.revision >> 16,
 		       efi.systab->hdr.revision & 0xffff);
=20
-	config_tables =3D __va(efi.systab->tables);
-
 	/* Show what we know for posterity */
 	c16 =3D __va(efi.systab->fw_vendor);
 	if (c16) {
@@ -528,43 +529,10 @@ efi_init (void)
 	       efi.systab->hdr.revision >> 16,
 	       efi.systab->hdr.revision & 0xffff, vendor);
=20
-	efi.mps        =3D EFI_INVALID_TABLE_ADDR;
-	efi.acpi       =3D EFI_INVALID_TABLE_ADDR;
-	efi.acpi20     =3D EFI_INVALID_TABLE_ADDR;
-	efi.smbios     =3D EFI_INVALID_TABLE_ADDR;
-	efi.sal_systab =3D EFI_INVALID_TABLE_ADDR;
-	efi.boot_info  =3D EFI_INVALID_TABLE_ADDR;
-	efi.hcdp       =3D EFI_INVALID_TABLE_ADDR;
-	efi.uga        =3D EFI_INVALID_TABLE_ADDR;
-
 	palo_phys      =3D EFI_INVALID_TABLE_ADDR;
=20
-	for (i =3D 0; i < (int) efi.systab->nr_tables; i++) {
-		if (efi_guidcmp(config_tables[i].guid, MPS_TABLE_GUID) =3D=3D 0) {
-			efi.mps =3D config_tables[i].table;
-			printk(" MPS=3D0x%lx", config_tables[i].table);
-		} else if (efi_guidcmp(config_tables[i].guid, ACPI_20_TABLE_GUID) =3D=
=3D 0) {
-			efi.acpi20 =3D config_tables[i].table;
-			printk(" ACPI 2.0=3D0x%lx", config_tables[i].table);
-		} else if (efi_guidcmp(config_tables[i].guid, ACPI_TABLE_GUID) =3D=3D=
 0) {
-			efi.acpi =3D config_tables[i].table;
-			printk(" ACPI=3D0x%lx", config_tables[i].table);
-		} else if (efi_guidcmp(config_tables[i].guid, SMBIOS_TABLE_GUID) =3D=
=3D 0) {
-			efi.smbios =3D config_tables[i].table;
-			printk(" SMBIOS=3D0x%lx", config_tables[i].table);
-		} else if (efi_guidcmp(config_tables[i].guid, SAL_SYSTEM_TABLE_GUID)=
 =3D=3D 0) {
-			efi.sal_systab =3D config_tables[i].table;
-			printk(" SALsystab=3D0x%lx", config_tables[i].table);
-		} else if (efi_guidcmp(config_tables[i].guid, HCDP_TABLE_GUID) =3D=3D=
 0) {
-			efi.hcdp =3D config_tables[i].table;
-			printk(" HCDP=3D0x%lx", config_tables[i].table);
-		} else if (efi_guidcmp(config_tables[i].guid,
-			 PROCESSOR_ABSTRACTION_LAYER_OVERWRITE_GUID) =3D=3D 0) {
-			palo_phys =3D config_tables[i].table;
-			printk(" PALO=3D0x%lx", config_tables[i].table);
-		}
-	}
-	printk("\n");
+	if (efi_config_init(arch_tables) !=3D 0)
+		return;
=20
 	if (palo_phys !=3D EFI_INVALID_TABLE_ADDR)
 		handle_palo(palo_phys);
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 90f6ed1..ed2be58 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -60,19 +60,6 @@
=20
 static efi_char16_t efi_dummy_name[6] =3D { 'D', 'U', 'M', 'M', 'Y', 0=
 };
=20
-struct efi __read_mostly efi =3D {
-	.mps        =3D EFI_INVALID_TABLE_ADDR,
-	.acpi       =3D EFI_INVALID_TABLE_ADDR,
-	.acpi20     =3D EFI_INVALID_TABLE_ADDR,
-	.smbios     =3D EFI_INVALID_TABLE_ADDR,
-	.sal_systab =3D EFI_INVALID_TABLE_ADDR,
-	.boot_info  =3D EFI_INVALID_TABLE_ADDR,
-	.hcdp       =3D EFI_INVALID_TABLE_ADDR,
-	.uga        =3D EFI_INVALID_TABLE_ADDR,
-	.uv_systab  =3D EFI_INVALID_TABLE_ADDR,
-};
-EXPORT_SYMBOL(efi);
-
 struct efi_memory_map memmap;
=20
 static struct efi efi_phys __initdata;
@@ -80,6 +67,13 @@ static efi_system_table_t efi_systab __initdata;
=20
 unsigned long x86_efi_facility;
=20
+static __initdata efi_config_table_type_t arch_tables[] =3D {
+#ifdef CONFIG_X86_UV
+	{UV_SYSTEM_TABLE_GUID, "UVsystab", &efi.uv_systab},
+#endif
+	{NULL_GUID, NULL, 0},
+};
+
 /*
  * Returns 1 if 'facility' is enabled, 0 otherwise.
  */
@@ -578,80 +572,6 @@ static int __init efi_systab_init(void *phys)
 	return 0;
 }
=20
-static int __init efi_config_init(u64 tables, int nr_tables)
-{
-	void *config_tables, *tablep;
-	int i, sz;
-
-	if (efi_enabled(EFI_64BIT))
-		sz =3D sizeof(efi_config_table_64_t);
-	else
-		sz =3D sizeof(efi_config_table_32_t);
-
-	/*
-	 * Let's see what config tables the firmware passed to us.
-	 */
-	config_tables =3D early_ioremap(tables, nr_tables * sz);
-	if (config_tables =3D=3D NULL) {
-		pr_err("Could not map Configuration table!\n");
-		return -ENOMEM;
-	}
-
-	tablep =3D config_tables;
-	pr_info("");
-	for (i =3D 0; i < efi.systab->nr_tables; i++) {
-		efi_guid_t guid;
-		unsigned long table;
-
-		if (efi_enabled(EFI_64BIT)) {
-			u64 table64;
-			guid =3D ((efi_config_table_64_t *)tablep)->guid;
-			table64 =3D ((efi_config_table_64_t *)tablep)->table;
-			table =3D table64;
-#ifdef CONFIG_X86_32
-			if (table64 >> 32) {
-				pr_cont("\n");
-				pr_err("Table located above 4GB, disabling EFI.\n");
-				early_iounmap(config_tables,
-					      efi.systab->nr_tables * sz);
-				return -EINVAL;
-			}
-#endif
-		} else {
-			guid =3D ((efi_config_table_32_t *)tablep)->guid;
-			table =3D ((efi_config_table_32_t *)tablep)->table;
-		}
-		if (!efi_guidcmp(guid, MPS_TABLE_GUID)) {
-			efi.mps =3D table;
-			pr_cont(" MPS=3D0x%lx ", table);
-		} else if (!efi_guidcmp(guid, ACPI_20_TABLE_GUID)) {
-			efi.acpi20 =3D table;
-			pr_cont(" ACPI 2.0=3D0x%lx ", table);
-		} else if (!efi_guidcmp(guid, ACPI_TABLE_GUID)) {
-			efi.acpi =3D table;
-			pr_cont(" ACPI=3D0x%lx ", table);
-		} else if (!efi_guidcmp(guid, SMBIOS_TABLE_GUID)) {
-			efi.smbios =3D table;
-			pr_cont(" SMBIOS=3D0x%lx ", table);
-#ifdef CONFIG_X86_UV
-		} else if (!efi_guidcmp(guid, UV_SYSTEM_TABLE_GUID)) {
-			efi.uv_systab =3D table;
-			pr_cont(" UVsystab=3D0x%lx ", table);
-#endif
-		} else if (!efi_guidcmp(guid, HCDP_TABLE_GUID)) {
-			efi.hcdp =3D table;
-			pr_cont(" HCDP=3D0x%lx ", table);
-		} else if (!efi_guidcmp(guid, UGA_IO_PROTOCOL_GUID)) {
-			efi.uga =3D table;
-			pr_cont(" UGA=3D0x%lx ", table);
-		}
-		tablep +=3D sz;
-	}
-	pr_cont("\n");
-	early_iounmap(config_tables, efi.systab->nr_tables * sz);
-	return 0;
-}
-
 static int __init efi_runtime_init(void)
 {
 	efi_runtime_services_t *runtime;
@@ -745,7 +665,7 @@ void __init efi_init(void)
 		efi.systab->hdr.revision >> 16,
 		efi.systab->hdr.revision & 0xffff, vendor);
=20
-	if (efi_config_init(efi.systab->tables, efi.systab->nr_tables))
+	if (efi_config_init(arch_tables))
 		return;
=20
 	set_bit(EFI_CONFIG_TABLES, &x86_efi_facility);
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 5145fa3..e1010d4 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -13,11 +13,27 @@
  * This file is released under the GPLv2.
  */
=20
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kobject.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/efi.h>
+#include <linux/io.h>
+
+struct efi __read_mostly efi =3D {
+	.mps        =3D EFI_INVALID_TABLE_ADDR,
+	.acpi       =3D EFI_INVALID_TABLE_ADDR,
+	.acpi20     =3D EFI_INVALID_TABLE_ADDR,
+	.smbios     =3D EFI_INVALID_TABLE_ADDR,
+	.sal_systab =3D EFI_INVALID_TABLE_ADDR,
+	.boot_info  =3D EFI_INVALID_TABLE_ADDR,
+	.hcdp       =3D EFI_INVALID_TABLE_ADDR,
+	.uga        =3D EFI_INVALID_TABLE_ADDR,
+	.uv_systab  =3D EFI_INVALID_TABLE_ADDR,
+};
+EXPORT_SYMBOL(efi);
=20
 static struct kobject *efi_kobj;
 static struct kobject *efivars_kobj;
@@ -132,3 +148,95 @@ err_put:
 }
=20
 subsys_initcall(efisubsys_init);
+
+
+static __initdata efi_config_table_type_t common_tables[] =3D {
+	{ACPI_20_TABLE_GUID, "ACPI 2.0", &efi.acpi20},
+	{ACPI_TABLE_GUID, "ACPI", &efi.acpi},
+	{HCDP_TABLE_GUID, "HCDP", &efi.hcdp},
+	{MPS_TABLE_GUID, "MPS", &efi.mps},
+	{SAL_SYSTEM_TABLE_GUID, "SALsystab", &efi.sal_systab},
+	{SMBIOS_TABLE_GUID, "SMBIOS", &efi.smbios},
+	{UGA_IO_PROTOCOL_GUID, "UGA", &efi.uga},
+	{NULL_GUID, NULL, 0},
+};
+
+static __init int match_config_table(efi_guid_t *guid,
+				     unsigned long table,
+				     efi_config_table_type_t *table_types)
+{
+	u8 str[EFI_VARIABLE_GUID_LEN + 1];
+	int i;
+
+	if (table_types) {
+		efi_guid_unparse(guid, str);
+
+		for (i =3D 0; efi_guidcmp(table_types[i].guid, NULL_GUID); i++) {
+			efi_guid_unparse(&table_types[i].guid, str);
+
+			if (!efi_guidcmp(*guid, table_types[i].guid)) {
+				*(table_types[i].ptr) =3D table;
+				pr_cont(" %s=3D0x%lx ",
+					table_types[i].name, table);
+				return 1;
+			}
+		}
+	}
+
+	return 0;
+}
+
+int __init efi_config_init(efi_config_table_type_t *arch_tables)
+{
+	void *config_tables, *tablep;
+	int i, sz;
+
+	if (efi_enabled(EFI_64BIT))
+		sz =3D sizeof(efi_config_table_64_t);
+	else
+		sz =3D sizeof(efi_config_table_32_t);
+
+	/*
+	 * Let's see what config tables the firmware passed to us.
+	 */
+	config_tables =3D early_memremap(efi.systab->tables,
+				       efi.systab->nr_tables * sz);
+	if (config_tables =3D=3D NULL) {
+		pr_err("Could not map Configuration table!\n");
+		return -ENOMEM;
+	}
+
+	tablep =3D config_tables;
+	pr_info("");
+	for (i =3D 0; i < efi.systab->nr_tables; i++) {
+		efi_guid_t guid;
+		unsigned long table;
+
+		if (efi_enabled(EFI_64BIT)) {
+			u64 table64;
+			guid =3D ((efi_config_table_64_t *)tablep)->guid;
+			table64 =3D ((efi_config_table_64_t *)tablep)->table;
+			table =3D table64;
+#ifndef CONFIG_64BIT
+			if (table64 >> 32) {
+				pr_cont("\n");
+				pr_err("Table located above 4GB, disabling EFI.\n");
+				early_iounmap(config_tables,
+					       efi.systab->nr_tables * sz);
+				return -EINVAL;
+			}
+#endif
+		} else {
+			guid =3D ((efi_config_table_32_t *)tablep)->guid;
+			table =3D ((efi_config_table_32_t *)tablep)->table;
+		}
+
+		if (!match_config_table(&guid, table, common_tables))
+			match_config_table(&guid, table, arch_tables);
+
+		tablep +=3D sz;
+	}
+	pr_cont("\n");
+	early_iounmap(config_tables, efi.systab->nr_tables * sz);
+	return 0;
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 5f8f176..09d9e42 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -404,6 +404,12 @@ typedef struct {
 	unsigned long table;
 } efi_config_table_t;
=20
+typedef struct {
+	efi_guid_t guid;
+	const char *name;
+	unsigned long *ptr;
+} efi_config_table_type_t;
+
 #define EFI_SYSTEM_TABLE_SIGNATURE ((u64)0x5453595320494249ULL)
=20
 #define EFI_2_30_SYSTEM_TABLE_REVISION  ((2 << 16) | (30))
@@ -587,6 +593,7 @@ static inline efi_status_t efi_query_variable_store=
(u32 attributes, unsigned lon
 }
 #endif
 extern void __iomem *efi_lookup_mapped_addr(u64 phys_addr);
+extern int efi_config_init(efi_config_table_type_t *arch_tables);
 extern u64 efi_get_iobase (void);
 extern u32 efi_mem_type (unsigned long phys_addr);
 extern u64 efi_mem_attributes (unsigned long phys_addr);
--=20
1.8.1.4

--=20
Matt Fleming, Intel Open Source Technology Center
--
To unsubscribe from this list: send the line "unsubscribe linux-ia64" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
