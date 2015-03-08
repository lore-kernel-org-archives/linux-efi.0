From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v3 2/8] x86, efi: Copy SETUP_EFI data and access directly
Date: Sat,  7 Mar 2015 16:50:03 -0800
Message-ID: <1425775809-9373-3-git-send-email-yinghai@kernel.org>
References: <1425775809-9373-1-git-send-email-yinghai@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425775809-9373-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jiri Kosina <jkosina@suse.cz>, Chun-Yi Lee <jlee@suse.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pci@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
List-Id: linux-efi@vger.kernel.org

The copy will be in __initdata, and it is small.

We can use pointer to access the setup_data instead of using early_memmap
everywhere.

Cc: Matt Fleming <matt.fleming@intel.com>
Cc: linux-efi@vger.kernel.org
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/efi.h     |  2 +-
 arch/x86/platform/efi/efi.c    | 13 ++-----------
 arch/x86/platform/efi/efi_64.c | 13 ++++++++++++-
 arch/x86/platform/efi/quirks.c | 23 ++++++-----------------
 4 files changed, 21 insertions(+), 30 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 25bce45..edbecd6 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -114,7 +114,7 @@ struct efi_setup_data {
 	u64 reserved[8];
 };
 
-extern u64 efi_setup;
+extern struct efi_setup_data *efi_setup;
 
 #ifdef CONFIG_EFI
 
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index dbc8627..1cd38e8 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -68,7 +68,7 @@ static efi_config_table_type_t arch_tables[] __initdata = {
 	{NULL_GUID, NULL, NULL},
 };
 
-u64 efi_setup;		/* efi setup_data physical address */
+struct efi_setup_data *efi_setup __initdata; /* cached efi setup_data pointer */
 
 static int add_efi_memmap __initdata;
 static int __init setup_add_efi_memmap(char *arg)
@@ -225,20 +225,13 @@ static int __init efi_systab_init(void *phys)
 {
 	if (efi_enabled(EFI_64BIT)) {
 		efi_system_table_64_t *systab64;
-		struct efi_setup_data *data = NULL;
+		struct efi_setup_data *data = efi_setup;
 		u64 tmp = 0;
 
-		if (efi_setup) {
-			data = early_memremap(efi_setup, sizeof(*data));
-			if (!data)
-				return -ENOMEM;
-		}
 		systab64 = early_memremap((unsigned long)phys,
 					 sizeof(*systab64));
 		if (systab64 == NULL) {
 			pr_err("Couldn't map the system table!\n");
-			if (data)
-				early_memunmap(data, sizeof(*data));
 			return -ENOMEM;
 		}
 
@@ -271,8 +264,6 @@ static int __init efi_systab_init(void *phys)
 		tmp |= data ? data->tables : systab64->tables;
 
 		early_memunmap(systab64, sizeof(*systab64));
-		if (data)
-			early_memunmap(data, sizeof(*data));
 #ifdef CONFIG_X86_32
 		if (tmp >> 32) {
 			pr_err("EFI data located above 4GB, disabling EFI.\n");
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 17e80d8..a541c6c 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -292,9 +292,20 @@ void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
 	return (void __iomem *)__va(phys_addr);
 }
 
+static struct efi_setup_data efi_setup_data __initdata;
+
 void __init parse_efi_setup(u64 phys_addr, u32 data_len)
 {
-	efi_setup = phys_addr + sizeof(struct setup_data);
+	struct efi_setup_data *data;
+
+	data = early_memremap(phys_addr + sizeof(struct setup_data),
+			      sizeof(*data));
+	if (!data)
+		return;
+
+	efi_setup_data = *data;
+	early_memunmap(data, sizeof(*data));
+	efi_setup = &efi_setup_data;
 }
 
 void __init efi_runtime_mkexec(void)
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 1c7380d..45fec7d 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -203,9 +203,8 @@ void __init efi_free_boot_services(void)
  */
 int __init efi_reuse_config(u64 tables, int nr_tables)
 {
-	int i, sz, ret = 0;
+	int i, sz;
 	void *p, *tablep;
-	struct efi_setup_data *data;
 
 	if (!efi_setup)
 		return 0;
@@ -213,22 +212,15 @@ int __init efi_reuse_config(u64 tables, int nr_tables)
 	if (!efi_enabled(EFI_64BIT))
 		return 0;
 
-	data = early_memremap(efi_setup, sizeof(*data));
-	if (!data) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	if (!data->smbios)
-		goto out_memremap;
+	if (!efi_setup->smbios)
+		return 0;
 
 	sz = sizeof(efi_config_table_64_t);
 
 	p = tablep = early_memremap(tables, nr_tables * sz);
 	if (!p) {
 		pr_err("Could not map Configuration table!\n");
-		ret = -ENOMEM;
-		goto out_memremap;
+		return -ENOMEM;
 	}
 
 	for (i = 0; i < efi.systab->nr_tables; i++) {
@@ -237,15 +229,12 @@ int __init efi_reuse_config(u64 tables, int nr_tables)
 		guid = ((efi_config_table_64_t *)p)->guid;
 
 		if (!efi_guidcmp(guid, SMBIOS_TABLE_GUID))
-			((efi_config_table_64_t *)p)->table = data->smbios;
+			((efi_config_table_64_t *)p)->table = efi_setup->smbios;
 		p += sz;
 	}
 	early_memunmap(tablep, nr_tables * sz);
 
-out_memremap:
-	early_memunmap(data, sizeof(*data));
-out:
-	return ret;
+	return 0;
 }
 
 void __init efi_apply_memmap_quirks(void)
-- 
1.8.4.5
