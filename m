From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 13/40] efi: Implement generic support for the Memory Attributes table
Date: Mon, 25 Apr 2016 21:06:45 +0100
Message-ID: <1461614832-17633-14-git-send-email-matt@codeblueprint.co.uk>
References: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>, Catalin Marinas <catalin.marinas@arm.com>, Leif Lindholm <leif.lindholm@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Peter Jones <pjones@redhat.com>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Will Deacon <will.deacon@arm.com>
List-Id: linux-efi@vger.kernel.org

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

This implements shared support for discovering the presence of the
Memory Attributes table, and for parsing and validating its contents.

The table is validated against the construction rules in the UEFI spec.
Since this is a new table, it makes sense to complain if we encounter
a table that does not follow those rules.

The parsing and validation routine takes a callback that can be specified
per architecture, that gets passed each unique validated region, with the
virtual address retrieved from the ordinary memory map.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Peter Jones <pjones@redhat.com>
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
[ Trim pr_*() strings to 80 cols and use "EFI" consistently. ]
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 drivers/firmware/efi/Makefile  |   2 +-
 drivers/firmware/efi/memattr.c | 182 +++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h            |  13 +++
 3 files changed, 196 insertions(+), 1 deletion(-)
 create mode 100644 drivers/firmware/efi/memattr.c

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
index 000000000000..236004b9a50d
--- /dev/null
+++ b/drivers/firmware/efi/memattr.c
@@ -0,0 +1,182 @@
+/*
+ * Copyright (C) 2016 Linaro Ltd. <ard.biesheuvel@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#define pr_fmt(fmt)	"efi: memattr: " fmt
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
+		pr_err("Failed to map EFI Memory Attributes table @ 0x%lx\n",
+		       efi.mem_attr_table);
+		return -ENOMEM;
+	}
+
+	if (tbl->version > 1) {
+		pr_warn("Unexpected EFI Memory Attributes table version %d\n",
+			tbl->version);
+		goto unmap;
+	}
+
+	tbl_size = sizeof(*tbl) + tbl->num_entries * tbl->desc_size;
+	memblock_reserve(efi.mem_attr_table, tbl_size);
+
+unmap:
+	early_memunmap(tbl, sizeof(*tbl));
+	return 0;
+}
+
+/*
+ * Returns a copy @out of the UEFI memory descriptor @in if it is covered
+ * entirely by a UEFI memory map entry with matching attributes. The virtual
+ * address of @out is set according to the matching entry that was found.
+ */
+static bool entry_is_valid(const efi_memory_desc_t *in, efi_memory_desc_t *out)
+{
+	u64 in_paddr = in->phys_addr;
+	u64 in_size = in->num_pages << EFI_PAGE_SHIFT;
+	efi_memory_desc_t *md;
+
+	*out = *in;
+
+	if (in->type != EFI_RUNTIME_SERVICES_CODE &&
+	    in->type != EFI_RUNTIME_SERVICES_DATA) {
+		pr_warn("Entry type should be RuntimeServiceCode/Data\n");
+		return false;
+	}
+
+	if (!(in->attribute & (EFI_MEMORY_RO | EFI_MEMORY_XP))) {
+		pr_warn("Entry attributes invalid: RO and XP bits both cleared\n");
+		return false;
+	}
+
+	if (PAGE_SIZE > EFI_PAGE_SIZE &&
+	    (!PAGE_ALIGNED(in->phys_addr) ||
+	     !PAGE_ALIGNED(in->num_pages << EFI_PAGE_SHIFT))) {
+		/*
+		 * Since arm64 may execute with page sizes of up to 64 KB, the
+		 * UEFI spec mandates that RuntimeServices memory regions must
+		 * be 64 KB aligned. We need to validate this here since we will
+		 * not be able to tighten permissions on such regions without
+		 * affecting adjacent regions.
+		 */
+		pr_warn("Entry address region misaligned\n");
+		return false;
+	}
+
+	for_each_efi_memory_desc(md) {
+		u64 md_paddr = md->phys_addr;
+		u64 md_size = md->num_pages << EFI_PAGE_SHIFT;
+
+		if (!(md->attribute & EFI_MEMORY_RUNTIME))
+			continue;
+		if (md->virt_addr == 0) {
+			/* no virtual mapping has been installed by the stub */
+			break;
+		}
+
+		if (md_paddr > in_paddr || (in_paddr - md_paddr) >= md_size)
+			continue;
+
+		/*
+		 * This entry covers the start of @in, check whether
+		 * it covers the end as well.
+		 */
+		if (md_paddr + md_size < in_paddr + in_size) {
+			pr_warn("Entry covers multiple EFI memory map regions\n");
+			return false;
+		}
+
+		if (md->type != in->type) {
+			pr_warn("Entry type deviates from EFI memory map region type\n");
+			return false;
+		}
+
+		out->virt_addr = in_paddr + (md->virt_addr - md_paddr);
+
+		return true;
+	}
+
+	pr_warn("No matching entry found in the EFI memory map\n");
+	return false;
+}
+
+/*
+ * To be called after the EFI page tables have been populated. If a memory
+ * attributes table is available, its contents will be used to update the
+ * mappings with tightened permissions as described by the table.
+ * This requires the UEFI memory map to have already been populated with
+ * virtual addresses.
+ */
+int __init efi_memattr_apply_permissions(struct mm_struct *mm,
+					 efi_memattr_perm_setter fn)
+{
+	efi_memory_attributes_table_t *tbl;
+	int i, ret;
+
+	if (tbl_size <= sizeof(*tbl))
+		return 0;
+
+	/*
+	 * We need the EFI memory map to be setup so we can use it to
+	 * lookup the virtual addresses of all entries in the  of EFI
+	 * Memory Attributes table. If it isn't available, this
+	 * function should not be called.
+	 */
+	if (WARN_ON(!efi_enabled(EFI_MEMMAP)))
+		return 0;
+
+	tbl = memremap(efi.mem_attr_table, tbl_size, MEMREMAP_WB);
+	if (!tbl) {
+		pr_err("Failed to map EFI Memory Attributes table @ 0x%lx\n",
+		       efi.mem_attr_table);
+		return -ENOMEM;
+	}
+
+	if (efi_enabled(EFI_DBG))
+		pr_info("Processing EFI Memory Attributes table:\n");
+
+	for (i = ret = 0; ret == 0 && i < tbl->num_entries; i++) {
+		efi_memory_desc_t md;
+		unsigned long size;
+		bool valid;
+		char buf[64];
+
+		valid = entry_is_valid((void *)tbl->entry + i * tbl->desc_size,
+				       &md);
+		size = md.num_pages << EFI_PAGE_SHIFT;
+		if (efi_enabled(EFI_DBG) || !valid)
+			pr_info("%s 0x%012llx-0x%012llx %s\n",
+				valid ? "" : "!", md.phys_addr,
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
index 81af5feba1f7..e29a31d0fc35 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -969,6 +969,19 @@ extern void __init efi_fake_memmap(void);
 static inline void efi_fake_memmap(void) { }
 #endif
 
+/*
+ * efi_memattr_perm_setter - arch specific callback function passed into
+ *                           efi_memattr_apply_permissions() that updates the
+ *                           mapping permissions described by the second
+ *                           argument in the page tables referred to by the
+ *                           first argument.
+ */
+typedef int (*efi_memattr_perm_setter)(struct mm_struct *, efi_memory_desc_t *);
+
+extern int efi_memattr_init(void);
+extern int efi_memattr_apply_permissions(struct mm_struct *mm,
+					 efi_memattr_perm_setter fn);
+
 /* Iterate through an efi_memory_map */
 #define for_each_efi_memory_desc_in_map(m, md)				   \
 	for ((md) = (m)->map;						   \
-- 
2.7.3
