From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 4/5] efi: implement generic support for the Memory Attributes table
Date: Mon, 22 Feb 2016 15:29:14 +0100
Message-ID: <1456151355-25943-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1456151158-25849-4-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456151158-25849-4-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This implements shared support for discovering the presence of the
Memory Attributes table, and for parsing and validating its contents.

The table is validated against the construction rules in the UEFI spec.
Since this is a new table, it makes sense to complain if we encounter
a table that does not follow those rules.

The parsing and validation routine takes a callback that can be specified
per architecture, that gets passed each unique validated region, with the
virtual address retrieved from the ordinary memory map.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/Makefile  |   2 +-
 drivers/firmware/efi/memattr.c | 137 ++++++++++++++++++++
 include/linux/efi.h            |   6 +
 3 files changed, 144 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 62e654f255f4..d5be62399130 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -9,7 +9,7 @@
 #
 KASAN_SANITIZE_runtime-wrappers.o	:= n
 
-obj-$(CONFIG_EFI)			+= efi.o vars.o reboot.o
+obj-$(CONFIG_EFI)			+= efi.o vars.o reboot.o memattr.o
 obj-$(CONFIG_EFI_VARS)			+= efivars.o
 obj-$(CONFIG_EFI_ESRT)			+= esrt.o
 obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
diff --git a/drivers/firmware/efi/memattr.c b/drivers/firmware/efi/memattr.c
new file mode 100644
index 000000000000..059cf4522a7d
--- /dev/null
+++ b/drivers/firmware/efi/memattr.c
@@ -0,0 +1,137 @@
+/*
+ * Copyright (C) 2016 Linaro Ltd. <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/efi.h>
+#include <linux/init.h>
+#include <linux/io.h>
+#include <linux/memblock.h>
+
+#include <asm/early_ioremap.h>
+
+static int __initdata tbl_size;
+
+/*
+ * Reserve the memory associated with the Memory Attributes configuration
+ * table, if it exists.
+ */
+int __init efi_memattr_init(void)
+{
+	efi_memory_attributes_table_t *tbl;
+
+	if (efi.mem_attr_table == EFI_INVALID_TABLE_ADDR)
+		return 0;
+
+	tbl = early_memremap(efi.mem_attr_table, sizeof(*tbl));
+	if (!tbl) {
+		pr_err("Failed to map EFI Memory Attribute table @ 0x%lx\n",
+		       efi.mem_attr_table);
+		return -ENOMEM;
+	}
+
+	tbl_size = sizeof(*tbl) + tbl->num_entries * tbl->desc_size;
+	memblock_reserve(efi.mem_attr_table, tbl_size);
+	early_memunmap(tbl, sizeof(*tbl));
+	return 0;
+}
+
+/*
+ * Returns a copy @out of the UEFI memory descriptor @in if it is covered
+ * entirely by a UEFI memory map entry with matching attributes. The virtual
+ * address of @out is set according to the matching entry that was found.
+ */
+static bool validate_entry(const efi_memory_desc_t *in, efi_memory_desc_t *out)
+{
+	u64 in_paddr = in->phys_addr;
+	u64 in_size = in->num_pages << EFI_PAGE_SHIFT;
+	efi_memory_desc_t *md;
+
+	if (in->type != EFI_RUNTIME_SERVICES_CODE &&
+	    in->type != EFI_RUNTIME_SERVICES_DATA) {
+		pr_warn("MEMATTR table entry type should be RuntimeServiceCode or RuntimeServicesData\n");
+		return false;
+	}
+	if (!(in->attribute & (EFI_MEMORY_RO | EFI_MEMORY_XP))) {
+		pr_warn("MEMATTR table entry attributes invalid: RO and XP bits both cleared\n");
+		return false;
+	}
+	if (PAGE_SIZE > EFI_PAGE_SIZE &&
+	    (!PAGE_ALIGNED(in->phys_addr) ||
+	     !PAGE_ALIGNED(in->num_pages << EFI_PAGE_SHIFT))) {
+		pr_warn("MEMATTR table entry misaligned\n");
+		return false;
+	}
+	for_each_efi_memory_desc(&memmap, md) {
+		u64 md_paddr = md->phys_addr;
+		u64 md_size = md->num_pages << EFI_PAGE_SHIFT;
+
+		if (!(md->attribute & EFI_MEMORY_RUNTIME))
+			continue;
+		if (md->virt_addr == 0)
+			/* no virtual mapping has been installed by the stub */
+			break;
+		if (md_paddr <= in_paddr && (in_paddr - md_paddr) < md_size) {
+			/*
+			 * This entry covers the start of @in, check whether
+			 * it covers the end as well.
+			 */
+			if (md_paddr + md_size < in_paddr + in_size) {
+				pr_warn("MEMATTR table entry covers multiple UEFI memory map regions\n");
+				return false;
+			}
+			if (md->type != in->type) {
+				pr_warn("MEMATTR table entry type deviates from UEFI memory map region type\n");
+				return false;
+			}
+			*out = *in;
+			out->virt_addr = in_paddr +
+					 (md->virt_addr - md->phys_addr);
+			return true;
+		}
+	}
+	return false;
+}
+
+int __init efi_memattr_apply_permissions(struct mm_struct *mm,
+					 efi_memattr_perm_setter fn)
+{
+	efi_memory_attributes_table_t *tbl;
+	int i, ret;
+
+	if (tbl_size <= sizeof(*tbl))
+		return 0;
+
+	tbl = memremap(efi.mem_attr_table, tbl_size, MEMREMAP_WB);
+	if (!tbl) {
+		pr_err("Failed to map EFI Memory Attribute table @ 0x%lx\n",
+		       efi.mem_attr_table);
+		return -ENOMEM;
+	}
+
+	if (efi_enabled(EFI_DBG))
+		pr_info("Processing UEFI Memory Attributes table:\n");
+
+	for (i = ret = 0; ret == 0 && i < tbl->num_entries; i++) {
+		efi_memory_desc_t md;
+		unsigned long size;
+		bool valid;
+		char buf[64];
+
+		valid = validate_entry((void *)tbl->entry + i * tbl->desc_size,
+				       &md);
+		size = md.num_pages << EFI_PAGE_SHIFT;
+		if (efi_enabled(EFI_DBG) || !valid)
+			pr_info("  0x%012llx-0x%012llx %s\n", md.phys_addr,
+				md.phys_addr + size - 1,
+				efi_md_typeattr_format(buf, sizeof(buf), &md));
+
+		if (valid)
+			ret = fn(mm, &md);
+	}
+	memunmap(tbl);
+	return ret;
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 808d97299c70..94e41872e5e6 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -966,6 +966,12 @@ extern void __init efi_fake_memmap(void);
 static inline void efi_fake_memmap(void) { }
 #endif
 
+typedef int (*efi_memattr_perm_setter)(struct mm_struct *, efi_memory_desc_t *);
+
+extern int efi_memattr_init(void);
+extern int efi_memattr_apply_permissions(struct mm_struct *mm,
+					 efi_memattr_perm_setter fn);
+
 /* Iterate through an efi_memory_map */
 #define for_each_efi_memory_desc(m, md)					   \
 	for ((md) = (m)->map;						   \
-- 
2.5.0
