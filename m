From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH 1/6] efi: Introduce efi_memmap_free() to free memory allocated by efi_memmap_alloc()
Date: Mon,  2 Jul 2018 18:50:49 -0700
Message-ID: <1530582654-25662-2-git-send-email-sai.praneeth.prakhya@intel.com>
References: <1530582654-25662-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1530582654-25662-1-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sai Praneeth <sai.praneeth.prakhya@intel.com>, Lee Chun-Yi <jlee@suse.com>, Dave Young <dyoung@redhat.com>, Borislav Petkov <bp@alien8.de>, Laszlo Ersek <lersek@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>, Dave Hansen <dave.hansen@intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Nicolai Stange <nicstange@gmail.com>, Naresh Bhat <naresh.bhat@linaro.org>, Ricardo Neri <ricardo.neri@intel.com>, Peter Zijlstra <peterz@infradead.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>, Ravi Shankar <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dan Williams <dan.j.williams@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

efi_memmap_alloc() allocates memory depending on whether mm_init() has
already been invoked or not. Apart from memblock_alloc() memory and
alloc_pages() memory, efi memory map could also have a third variant of
memory allocation and that is memblock_reserved. This happens only for
the memory map passed to kernel by firmware and thus can happen only
once during boot process.

In order to identify these three different types of allocations and thus
to call the appropriate free() variant, introduce an enum named
efi_memmap_type and also introduce a efi memmap API named
efi_memmap_free() to free memory allocated by efi_memmap_alloc().

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Suggested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Lee Chun-Yi <jlee@suse.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Laszlo Ersek <lersek@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Nicolai Stange <nicstange@gmail.com>
Cc: Naresh Bhat <naresh.bhat@linaro.org>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>
Cc: Ravi Shankar <ravi.v.shankar@intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/firmware/efi/memmap.c | 28 ++++++++++++++++++++++++++++
 include/linux/efi.h           |  8 ++++++++
 2 files changed, 36 insertions(+)

diff --git a/drivers/firmware/efi/memmap.c b/drivers/firmware/efi/memmap.c
index 5fc70520e04c..0686e063c644 100644
--- a/drivers/firmware/efi/memmap.c
+++ b/drivers/firmware/efi/memmap.c
@@ -12,6 +12,7 @@
 #include <asm/early_ioremap.h>
 #include <linux/memblock.h>
 #include <linux/slab.h>
+#include <linux/bootmem.h>
 
 static phys_addr_t __init __efi_memmap_alloc_early(unsigned long size)
 {
@@ -50,6 +51,33 @@ phys_addr_t __init efi_memmap_alloc(unsigned int num_entries)
 }
 
 /**
+ * efi_memmap_free - Free memory allocated by efi_memmap_alloc()
+ * @mem: Physical address allocated by efi_memmap_alloc().
+ * @num_entries: Number of entries in the allocated map.
+ * @alloc_type: What type of allocation did efi_memmap_alloc() perform?
+ *
+ * Use this function to free memory allocated by efi_memmap_alloc().
+ * efi_memmap_alloc() allocates memory depending on whether mm_init()
+ * has already been invoked or not. It uses either memblock or "normal"
+ * page allocation, similarly, we free it in two different ways. Also
+ * note that there is a third type of memory used by memmap which is
+ * memblock_reserved() and is passed by EFI stub to kernel.
+ */
+void __init efi_memmap_free(phys_addr_t mem, unsigned int num_entries,
+			    enum efi_memmap_type alloc_type)
+{
+	unsigned long size = num_entries * efi.memmap.desc_size;
+	unsigned int order = get_order(size);
+
+	if (alloc_type == BUDDY_ALLOCATOR)
+		__free_pages(pfn_to_page(PHYS_PFN(mem)), order);
+	else if (alloc_type == MEMBLOCK)
+		memblock_free(mem, size);
+	else
+		free_bootmem(mem, size);
+}
+
+/**
  * __efi_memmap_init - Common code for mapping the EFI memory map
  * @data: EFI memory map data
  * @late: Use early or late mapping function?
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 56add823f190..455875c01ed1 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -765,6 +765,12 @@ struct efi_memory_map_data {
 	unsigned long desc_size;
 };
 
+enum efi_memmap_type {
+	EFI_STUB,
+	MEMBLOCK,
+	BUDDY_ALLOCATOR,
+};
+
 struct efi_memory_map {
 	phys_addr_t phys_map;
 	void *map;
@@ -1016,6 +1022,8 @@ extern int __init efi_memmap_split_count(efi_memory_desc_t *md,
 					 struct range *range);
 extern void __init efi_memmap_insert(struct efi_memory_map *old_memmap,
 				     void *buf, struct efi_mem_range *mem);
+extern void __init efi_memmap_free(phys_addr_t mem, unsigned int num_entries,
+				   enum efi_memmap_type alloc_type);
 
 extern int efi_config_init(efi_config_table_type_t *arch_tables);
 #ifdef CONFIG_EFI_ESRT
-- 
2.7.4
