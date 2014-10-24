From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/6] efi: split off remapping code from efi_config_init()
Date: Fri, 24 Oct 2014 14:39:41 +0200
Message-ID: <1414154384-15385-4-git-send-email-ard.biesheuvel@linaro.org>
References: <1414154384-15385-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414154384-15385-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Split of the remapping code from efi_config_init() so that the caller
can perform its own remapping. This is necessary to correctly handle
virtually remapped UEFI memory regions under kexec, as efi.systab will
have been updated to a virtual address.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/efi.c | 49 +++++++++++++++++++++++++++++-----------------
 include/linux/efi.h        |  2 ++
 2 files changed, 33 insertions(+), 18 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 9035c1b74d58..0de77db4fb88 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -293,9 +293,10 @@ static __init int match_config_table(efi_guid_t *guid,
 	return 0;
 }
 
-int __init efi_config_init(efi_config_table_type_t *arch_tables)
+int __init efi_config_parse_tables(void *config_tables, int count,
+				   efi_config_table_type_t *arch_tables)
 {
-	void *config_tables, *tablep;
+	void *tablep;
 	int i, sz;
 
 	if (efi_enabled(EFI_64BIT))
@@ -303,19 +304,9 @@ int __init efi_config_init(efi_config_table_type_t *arch_tables)
 	else
 		sz = sizeof(efi_config_table_32_t);
 
-	/*
-	 * Let's see what config tables the firmware passed to us.
-	 */
-	config_tables = early_memremap(efi.systab->tables,
-				       efi.systab->nr_tables * sz);
-	if (config_tables == NULL) {
-		pr_err("Could not map Configuration table!\n");
-		return -ENOMEM;
-	}
-
 	tablep = config_tables;
 	pr_info("");
-	for (i = 0; i < efi.systab->nr_tables; i++) {
+	for (i = 0; i < count; i++) {
 		efi_guid_t guid;
 		unsigned long table;
 
@@ -328,8 +319,6 @@ int __init efi_config_init(efi_config_table_type_t *arch_tables)
 			if (table64 >> 32) {
 				pr_cont("\n");
 				pr_err("Table located above 4GB, disabling EFI.\n");
-				early_memunmap(config_tables,
-					       efi.systab->nr_tables * sz);
 				return -EINVAL;
 			}
 #endif
@@ -344,13 +333,37 @@ int __init efi_config_init(efi_config_table_type_t *arch_tables)
 		tablep += sz;
 	}
 	pr_cont("\n");
-	early_memunmap(config_tables, efi.systab->nr_tables * sz);
-
 	set_bit(EFI_CONFIG_TABLES, &efi.flags);
-
 	return 0;
 }
 
+int __init efi_config_init(efi_config_table_type_t *arch_tables)
+{
+	void *config_tables;
+	int sz, ret;
+
+	if (efi_enabled(EFI_64BIT))
+		sz = sizeof(efi_config_table_64_t);
+	else
+		sz = sizeof(efi_config_table_32_t);
+
+	/*
+	 * Let's see what config tables the firmware passed to us.
+	 */
+	config_tables = early_memremap(efi.systab->tables,
+				       efi.systab->nr_tables * sz);
+	if (config_tables == NULL) {
+		pr_err("Could not map Configuration table!\n");
+		return -ENOMEM;
+	}
+
+	ret = efi_config_parse_tables(config_tables, efi.systab->nr_tables,
+				      arch_tables);
+
+	early_memunmap(config_tables, efi.systab->nr_tables * sz);
+	return ret;
+}
+
 #ifdef CONFIG_EFI_VARS_MODULE
 static int __init efi_load_efivars(void)
 {
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 27d69388ded0..abd3e91964a6 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -875,6 +875,8 @@ static inline efi_status_t efi_query_variable_store(u32 attributes, unsigned lon
 #endif
 extern void __iomem *efi_lookup_mapped_addr(u64 phys_addr);
 extern int efi_config_init(efi_config_table_type_t *arch_tables);
+extern int efi_config_parse_tables(void *config_tables, int count,
+				   efi_config_table_type_t *arch_tables);
 extern u64 efi_get_iobase (void);
 extern u32 efi_mem_type (unsigned long phys_addr);
 extern u64 efi_mem_attributes (unsigned long phys_addr);
-- 
1.8.3.2
