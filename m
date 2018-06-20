From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH V3] x86/efi: Free allocated memory if remap fails
Date: Tue, 19 Jun 2018 20:03:26 -0700
Message-ID: <1529463806-4046-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sai Praneeth <sai.praneeth.prakhya@intel.com>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>, Dave Hansen <dave.hansen@intel.com>, Bhupesh Sharma <bhsharma@redhat.com>, Ricardo Neri <ricardo.neri@intel.com>, Peter Zijlstra <peterz@infradead.org>, Ravi Shankar <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

efi_memmap_alloc(), as the name suggests, allocates memory for a new efi
memory map. It's referenced from couple of places, namely,
efi_arch_mem_reserve() and efi_free_boot_services(). These callers,
after allocating memory, remap it for further use. As usual, a routine
check is performed to confirm successful remap. If the remap fails,
ideally, the allocated memory should be freed but presently we just
return without freeing it up. Hence, fix this bug by introducing
efi_memmap_free() which frees memory allocated by efi_memmap_alloc().

As efi_memmap_alloc() allocates memory depending on whether mm_init()
has already been invoked or not, introduce a new argument called "late"
that lets us know which type of allocation was performed by
efi_memmap_alloc(). Later, this is used by efi_memmap_free() to invoke
the appropriate method to free the allocated memory. The other main
purpose "late" argument serves is to make sure that efi_memmap_alloc()
and efi_memmap_free() are always binded properly i.e. there could be a
scenario in which efi_memmap_alloc() is used before slab_is_available()
and efi_memmap_free() could be used after slab_is_available(). Without
"late", this could break because allocation would have been done using
memblock_alloc() while freeing will be done using __free_pages().

Since these API's could easily be misused make it explicit, so that the
caller has to pass "late" argument to efi_memmap_alloc() and later use
the same for efi_memmap_free().

Also, efi_fake_memmap() references efi_memmap_alloc() but it frees
memory correctly using memblock_free(), but replace it with
efi_memmap_free() to maintain consistency, as in, allocate memory with
efi_memmap_alloc() and free memory with efi_memmap_free().

It's a fact that memremap() and early_memremap() might never fail and
this code might never get a chance to run but to maintain good kernel
programming semantics, we might need this patch.

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Cc: Lee Chun-Yi <jlee@suse.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Shankar <ravi.v.shankar@intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---

Changes from V2 to V3:
----------------------
1. Add a new argument "late" to efi_memmap_alloc(), so that
    efi_memmap_alloc() could communicate the type of allocation performed.
2. Re-introduce efi_memmap_free() (from V1) but with an extra argument
    "late", to know the type of allocation performed by efi_memmap_alloc().

Changes from V1 to V2:
----------------------
1. Fix the bug of freeing memory map that was just installed by correctly
    calling free_pages().
2. Call memblock_free() and __free_pages() directly from the appropriate
    places instead of efi_memmap_free().

Note: Patch based on Linus's mainline tree V4.18-rc1

 arch/x86/platform/efi/quirks.c  | 16 ++++++++++++----
 drivers/firmware/efi/fake_mem.c |  5 +++--
 drivers/firmware/efi/memmap.c   | 38 ++++++++++++++++++++++++++++++++++++--
 include/linux/efi.h             |  3 ++-
 4 files changed, 53 insertions(+), 9 deletions(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 36c1f8b9f7e0..ef5698a3af7a 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -248,6 +248,7 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
 	efi_memory_desc_t md;
 	int num_entries;
 	void *new;
+	bool late;
 
 	if (efi_mem_desc_lookup(addr, &md)) {
 		pr_err("Failed to lookup EFI memory descriptor for %pa\n", &addr);
@@ -276,7 +277,7 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
 
 	new_size = efi.memmap.desc_size * num_entries;
 
-	new_phys = efi_memmap_alloc(num_entries);
+	new_phys = efi_memmap_alloc(num_entries, &late);
 	if (!new_phys) {
 		pr_err("Could not allocate boot services memmap\n");
 		return;
@@ -285,6 +286,7 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
 	new = early_memremap(new_phys, new_size);
 	if (!new) {
 		pr_err("Failed to map new boot services memmap\n");
+		efi_memmap_free(new_phys, num_entries, late);
 		return;
 	}
 
@@ -375,6 +377,7 @@ void __init efi_free_boot_services(void)
 	efi_memory_desc_t *md;
 	int num_entries = 0;
 	void *new, *new_md;
+	bool late;
 
 	for_each_efi_memory_desc(md) {
 		unsigned long long start = md->phys_addr;
@@ -420,7 +423,7 @@ void __init efi_free_boot_services(void)
 		return;
 
 	new_size = efi.memmap.desc_size * num_entries;
-	new_phys = efi_memmap_alloc(num_entries);
+	new_phys = efi_memmap_alloc(num_entries, &late);
 	if (!new_phys) {
 		pr_err("Failed to allocate new EFI memmap\n");
 		return;
@@ -429,7 +432,7 @@ void __init efi_free_boot_services(void)
 	new = memremap(new_phys, new_size, MEMREMAP_WB);
 	if (!new) {
 		pr_err("Failed to map new EFI memmap\n");
-		return;
+		goto free_mem;
 	}
 
 	/*
@@ -452,8 +455,13 @@ void __init efi_free_boot_services(void)
 
 	if (efi_memmap_install(new_phys, num_entries)) {
 		pr_err("Could not install new EFI memmap\n");
-		return;
+		goto free_mem;
 	}
+
+	return;
+
+free_mem:
+	efi_memmap_free(new_phys, num_entries, late);
 }
 
 /*
diff --git a/drivers/firmware/efi/fake_mem.c b/drivers/firmware/efi/fake_mem.c
index 6c7d60c239b5..52cb2b7fc2f7 100644
--- a/drivers/firmware/efi/fake_mem.c
+++ b/drivers/firmware/efi/fake_mem.c
@@ -57,6 +57,7 @@ void __init efi_fake_memmap(void)
 	phys_addr_t new_memmap_phy;
 	void *new_memmap;
 	int i;
+	bool late;
 
 	if (!nr_fake_mem)
 		return;
@@ -71,7 +72,7 @@ void __init efi_fake_memmap(void)
 	}
 
 	/* allocate memory for new EFI memmap */
-	new_memmap_phy = efi_memmap_alloc(new_nr_map);
+	new_memmap_phy = efi_memmap_alloc(new_nr_map, &late);
 	if (!new_memmap_phy)
 		return;
 
@@ -79,7 +80,7 @@ void __init efi_fake_memmap(void)
 	new_memmap = early_memremap(new_memmap_phy,
 				    efi.memmap.desc_size * new_nr_map);
 	if (!new_memmap) {
-		memblock_free(new_memmap_phy, efi.memmap.desc_size * new_nr_map);
+		efi_memmap_free(new_memmap_phy, new_nr_map, late);
 		return;
 	}
 
diff --git a/drivers/firmware/efi/memmap.c b/drivers/firmware/efi/memmap.c
index 5fc70520e04c..678e85704054 100644
--- a/drivers/firmware/efi/memmap.c
+++ b/drivers/firmware/efi/memmap.c
@@ -32,6 +32,7 @@ static phys_addr_t __init __efi_memmap_alloc_late(unsigned long size)
 /**
  * efi_memmap_alloc - Allocate memory for the EFI memory map
  * @num_entries: Number of entries in the allocated map.
+ * @late: Type of allocation performed (late or early?).
  *
  * Depending on whether mm_init() has already been invoked or not,
  * either memblock or "normal" page allocation is used.
@@ -39,17 +40,50 @@ static phys_addr_t __init __efi_memmap_alloc_late(unsigned long size)
  * Returns the physical address of the allocated memory map on
  * success, zero on failure.
  */
-phys_addr_t __init efi_memmap_alloc(unsigned int num_entries)
+phys_addr_t __init efi_memmap_alloc(unsigned int num_entries, bool *late)
 {
 	unsigned long size = num_entries * efi.memmap.desc_size;
 
-	if (slab_is_available())
+	if (!late)
+		return 0;
+
+	*late = slab_is_available();
+
+	if (*late)
 		return __efi_memmap_alloc_late(size);
 
 	return __efi_memmap_alloc_early(size);
 }
 
 /**
+ * efi_memmap_free - Free memory allocated by efi_memmap_alloc()
+ * @mem: Physical address allocated by efi_memmap_alloc().
+ * @num_entries: Number of entries in the allocated map.
+ * @late: What type of allocation did efi_memmap_alloc() perform?
+ *
+ * Use this function _only_ in conjunction with efi_memmap_alloc().
+ * efi_memmap_alloc() allocates memory depending on whether mm_init()
+ * has already been invoked or not. It uses either memblock or "normal"
+ * page allocation. Since the allocation is done in two different ways,
+ * similarly, we free it in two different ways.
+ *
+ */
+void __init efi_memmap_free(phys_addr_t mem, unsigned int num_entries, bool late)
+{
+	unsigned long size = num_entries * efi.memmap.desc_size;
+	unsigned int order = get_order(size);
+	phys_addr_t end = mem + size - 1;
+
+	if (late) {
+		__free_pages(pfn_to_page(PHYS_PFN(mem)), order);
+		return;
+	}
+
+	if (memblock_free(mem, size))
+		pr_err("Failed to free mem from %pa to %pa\n", &mem, &end);
+}
+
+/**
  * __efi_memmap_init - Common code for mapping the EFI memory map
  * @data: EFI memory map data
  * @late: Use early or late mapping function?
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 56add823f190..f7f98d9a76f2 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1007,7 +1007,7 @@ static inline efi_status_t efi_query_variable_store(u32 attributes,
 #endif
 extern void __iomem *efi_lookup_mapped_addr(u64 phys_addr);
 
-extern phys_addr_t __init efi_memmap_alloc(unsigned int num_entries);
+extern phys_addr_t __init efi_memmap_alloc(unsigned int num_entries, bool *late);
 extern int __init efi_memmap_init_early(struct efi_memory_map_data *data);
 extern int __init efi_memmap_init_late(phys_addr_t addr, unsigned long size);
 extern void __init efi_memmap_unmap(void);
@@ -1016,6 +1016,7 @@ extern int __init efi_memmap_split_count(efi_memory_desc_t *md,
 					 struct range *range);
 extern void __init efi_memmap_insert(struct efi_memory_map *old_memmap,
 				     void *buf, struct efi_mem_range *mem);
+void __init efi_memmap_free(phys_addr_t mem, unsigned int num_entries, bool late);
 
 extern int efi_config_init(efi_config_table_type_t *arch_tables);
 #ifdef CONFIG_EFI_ESRT
-- 
2.7.4
