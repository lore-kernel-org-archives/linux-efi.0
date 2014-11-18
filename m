From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 05/13] efi: add common infrastructure for stub-installed virtual mapping
Date: Tue, 18 Nov 2014 13:57:04 +0100
Message-ID: <1416315432-8534-6-git-send-email-ard.biesheuvel@linaro.org>
References: <1416315432-8534-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1416315432-8534-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, geoff.levand-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This introduces the common infrastructure to be shared between arm64
and ARM that wires up the UEFI memory map into system RAM discovery,
virtual mappings for Runtime Services and aligning cache attributes
between kernel and userland (/dev/mem) mappings for regions owned
by UEFI.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/firmware/efi/Kconfig   |   3 +
 drivers/firmware/efi/Makefile  |   1 +
 drivers/firmware/efi/virtmap.c | 134 +++++++++++++++++++++++++++++++++++++++++
 include/linux/efi.h            |  12 +++-
 4 files changed, 149 insertions(+), 1 deletion(-)
 create mode 100644 drivers/firmware/efi/virtmap.c

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index f712d47f30d8..c71498180e67 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -60,6 +60,9 @@ config EFI_RUNTIME_WRAPPERS
 config EFI_ARMSTUB
 	bool
 
+config EFI_VIRTMAP
+	bool
+
 endmenu
 
 config UEFI_CPER
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index aef6a95adef5..3fd26c0ad40b 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -8,3 +8,4 @@ obj-$(CONFIG_UEFI_CPER)			+= cper.o
 obj-$(CONFIG_EFI_RUNTIME_MAP)		+= runtime-map.o
 obj-$(CONFIG_EFI_RUNTIME_WRAPPERS)	+= runtime-wrappers.o
 obj-$(CONFIG_EFI_ARM_STUB)		+= libstub/
+obj-$(CONFIG_EFI_VIRTMAP)		+= virtmap.o
diff --git a/drivers/firmware/efi/virtmap.c b/drivers/firmware/efi/virtmap.c
new file mode 100644
index 000000000000..d1f1d416944f
--- /dev/null
+++ b/drivers/firmware/efi/virtmap.c
@@ -0,0 +1,134 @@
+/*
+ * Copyright (C) 2014 Linaro Ltd.
+ * Author: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/efi.h>
+#include <linux/mm_types.h>
+#include <linux/rbtree.h>
+#include <linux/rwsem.h>
+#include <linux/spinlock.h>
+#include <linux/atomic.h>
+
+#include <asm/efi.h>
+#include <asm/pgtable.h>
+#include <asm/mmu_context.h>
+#include <asm/mmu.h>
+
+static pgd_t efi_pgd[PTRS_PER_PGD] __page_aligned_bss;
+
+static struct mm_struct efi_mm = {
+	.mm_rb			= RB_ROOT,
+	.pgd			= efi_pgd,
+	.mm_users		= ATOMIC_INIT(2),
+	.mm_count		= ATOMIC_INIT(1),
+	.mmap_sem		= __RWSEM_INITIALIZER(efi_mm.mmap_sem),
+	.page_table_lock	= __SPIN_LOCK_UNLOCKED(efi_mm.page_table_lock),
+	.mmlist			= LIST_HEAD_INIT(efi_mm.mmlist),
+	INIT_MM_CONTEXT(efi_mm)
+};
+
+void efi_virtmap_load(void)
+{
+	WARN_ON(preemptible());
+	efi_set_pgd(&efi_mm);
+}
+
+void efi_virtmap_unload(void)
+{
+	efi_set_pgd(current->active_mm);
+}
+
+static pgprot_t efi_md_access_prot(efi_memory_desc_t *md, pgprot_t prot)
+{
+	if (md->attribute & EFI_MEMORY_WB)
+		return prot;
+	if (md->attribute & (EFI_MEMORY_WT|EFI_MEMORY_WC))
+		return pgprot_writecombine(prot);
+	return pgprot_device(prot);
+}
+
+void __init efi_virtmap_init(void)
+{
+	efi_memory_desc_t *md;
+
+	if (!efi_enabled(EFI_BOOT))
+		return;
+
+	for_each_efi_memory_desc(&memmap, md) {
+		u64 paddr, npages, size;
+		pgprot_t prot;
+
+		if (!(md->attribute & EFI_MEMORY_RUNTIME))
+			continue;
+		if (WARN(md->virt_addr == 0,
+			 "UEFI virtual mapping incomplete or missing -- no entry found for 0x%llx\n",
+			 md->phys_addr))
+			return;
+
+		paddr = md->phys_addr;
+		npages = md->num_pages;
+		memrange_efi_to_native(&paddr, &npages);
+		size = npages << PAGE_SHIFT;
+
+		pr_info("  EFI remap 0x%012llx => %p\n",
+			md->phys_addr, (void *)md->virt_addr);
+
+		/*
+		 * Only regions of type EFI_RUNTIME_SERVICES_CODE need to be
+		 * executable, everything else can be mapped with the XN bits
+		 * set.
+		 */
+		if (md->type == EFI_RUNTIME_SERVICES_CODE)
+			prot = efi_md_access_prot(md, PAGE_KERNEL_EXEC);
+		else
+			prot = efi_md_access_prot(md, PAGE_KERNEL);
+
+		create_pgd_mapping(&efi_mm, paddr, md->virt_addr, size, prot);
+	}
+	set_bit(EFI_VIRTMAP, &efi.flags);
+}
+
+/*
+ * Return true for RAM regions that are available for general use.
+ */
+bool efi_mem_is_usable_region(efi_memory_desc_t *md)
+{
+	switch (md->type) {
+	case EFI_LOADER_CODE:
+	case EFI_LOADER_DATA:
+	case EFI_BOOT_SERVICES_CODE:
+	case EFI_BOOT_SERVICES_DATA:
+	case EFI_CONVENTIONAL_MEMORY:
+		return md->attribute & EFI_MEMORY_WB;
+	default:
+		break;
+	}
+	return false;
+}
+
+/*
+ * Translate a EFI virtual address into a physical address: this is necessary,
+ * as some data members of the EFI system table are virtually remapped after
+ * SetVirtualAddressMap() has been called.
+ */
+phys_addr_t efi_to_phys(unsigned long addr)
+{
+	efi_memory_desc_t *md;
+
+	for_each_efi_memory_desc(&memmap, md) {
+		if (!(md->attribute & EFI_MEMORY_RUNTIME))
+			continue;
+		if (md->virt_addr == 0)
+			/* no virtual mapping has been installed by the stub */
+			break;
+		if (md->virt_addr <= addr &&
+		    (addr - md->virt_addr) < (md->num_pages << EFI_PAGE_SHIFT))
+			return md->phys_addr + addr - md->virt_addr;
+	}
+	return addr;
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 2dc8577032b3..2adef3e9bf35 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -941,7 +941,8 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_MEMMAP		4	/* Can we use EFI memory map? */
 #define EFI_64BIT		5	/* Is the firmware 64-bit? */
 #define EFI_PARAVIRT		6	/* Access is via a paravirt interface */
-#define EFI_ARCH_1		7	/* First arch-specific bit */
+#define EFI_VIRTMAP		7	/* Use virtmap installed by the stub */
+#define EFI_ARCH_1		8	/* First arch-specific bit */
 
 #ifdef CONFIG_EFI
 /*
@@ -952,6 +953,7 @@ static inline bool efi_enabled(int feature)
 	return test_bit(feature, &efi.flags) != 0;
 }
 extern void efi_reboot(enum reboot_mode reboot_mode, const char *__unused);
+extern void efi_virtmap_init(void);
 #else
 static inline bool efi_enabled(int feature)
 {
@@ -959,6 +961,7 @@ static inline bool efi_enabled(int feature)
 }
 static inline void
 efi_reboot(enum reboot_mode reboot_mode, const char *__unused) {}
+static inline void efi_virtmap_init(void) {}
 #endif
 
 /*
@@ -1250,4 +1253,11 @@ efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 efi_status_t efi_parse_options(char *cmdline);
 
 bool efi_runtime_disabled(void);
+
+phys_addr_t efi_to_phys(unsigned long addr);
+bool efi_mem_is_usable_region(efi_memory_desc_t *md);
+
+void efi_virtmap_load(void);
+void efi_virtmap_unload(void);
+
 #endif /* _LINUX_EFI_H */
-- 
1.8.3.2
