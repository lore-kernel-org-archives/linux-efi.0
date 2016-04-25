From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 06/40] efi: Iterate over efi.memmap in for_each_efi_memory_desc
Date: Mon, 25 Apr 2016 21:06:38 +0100
Message-ID: <1461614832-17633-7-git-send-email-matt@codeblueprint.co.uk>
References: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1461614832-17633-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Leif Lindholm <leif.lindholm@linaro.org>, Mark Salter <msalter@redhat.com>
List-Id: linux-efi@vger.kernel.org

Most of the users of for_each_efi_memory_desc() are equally happy
iterating over the EFI memory map in efi.memmap instead of 'memmap',
since the former is usually a pointer to the latter.

For those users that want to specify an EFI memory map other than
efi.memmap, that can be done using for_each_efi_memory_desc_in_map().
One such example is in the libstub code where the firmware is queried
directly for the memory map, it gets iterated over, and then freed.

This change goes part of the way toward deleting the global 'memmap'
variable, which is not universally available on all architectures
(notably ia64) and is rather poorly named.

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Salter <msalter@redhat.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 arch/x86/platform/efi/efi.c                    | 43 ++++++++------------------
 arch/x86/platform/efi/efi_64.c                 | 10 ++----
 arch/x86/platform/efi/quirks.c                 | 10 +++---
 drivers/firmware/efi/arm-init.c                |  4 +--
 drivers/firmware/efi/arm-runtime.c             |  2 +-
 drivers/firmware/efi/efi.c                     |  6 +---
 drivers/firmware/efi/fake_mem.c                |  3 +-
 drivers/firmware/efi/libstub/efi-stub-helper.c |  6 ++--
 include/linux/efi.h                            | 11 ++++++-
 9 files changed, 39 insertions(+), 56 deletions(-)

diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index df393eab0e50..6f499819a27f 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -119,11 +119,10 @@ void efi_get_time(struct timespec *now)
 
 void __init efi_find_mirror(void)
 {
-	void *p;
+	efi_memory_desc_t *md;
 	u64 mirror_size = 0, total_size = 0;
 
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		efi_memory_desc_t *md = p;
+	for_each_efi_memory_desc(md) {
 		unsigned long long start = md->phys_addr;
 		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
 
@@ -146,10 +145,9 @@ void __init efi_find_mirror(void)
 
 static void __init do_add_efi_memmap(void)
 {
-	void *p;
+	efi_memory_desc_t *md;
 
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		efi_memory_desc_t *md = p;
+	for_each_efi_memory_desc(md) {
 		unsigned long long start = md->phys_addr;
 		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
 		int e820_type;
@@ -226,17 +224,13 @@ void __init efi_print_memmap(void)
 {
 #ifdef EFI_DEBUG
 	efi_memory_desc_t *md;
-	void *p;
-	int i;
+	int i = 0;
 
-	for (p = memmap.map, i = 0;
-	     p < memmap.map_end;
-	     p += memmap.desc_size, i++) {
+	for_each_efi_memory_desc(md) {
 		char buf[64];
 
-		md = p;
 		pr_info("mem%02u: %s range=[0x%016llx-0x%016llx] (%lluMB)\n",
-			i, efi_md_typeattr_format(buf, sizeof(buf), md),
+			i++, efi_md_typeattr_format(buf, sizeof(buf), md),
 			md->phys_addr,
 			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1,
 			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
@@ -550,12 +544,9 @@ void __init efi_set_executable(efi_memory_desc_t *md, bool executable)
 void __init runtime_code_page_mkexec(void)
 {
 	efi_memory_desc_t *md;
-	void *p;
 
 	/* Make EFI runtime service code area executable */
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		md = p;
-
+	for_each_efi_memory_desc(md) {
 		if (md->type != EFI_RUNTIME_SERVICES_CODE)
 			continue;
 
@@ -602,12 +593,10 @@ void __init old_map_region(efi_memory_desc_t *md)
 /* Merge contiguous regions of the same type and attribute */
 static void __init efi_merge_regions(void)
 {
-	void *p;
 	efi_memory_desc_t *md, *prev_md = NULL;
 
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+	for_each_efi_memory_desc(md) {
 		u64 prev_size;
-		md = p;
 
 		if (!prev_md) {
 			prev_md = md;
@@ -650,15 +639,13 @@ static void __init save_runtime_map(void)
 {
 #ifdef CONFIG_KEXEC_CORE
 	efi_memory_desc_t *md;
-	void *tmp, *p, *q = NULL;
+	void *tmp, *q = NULL;
 	int count = 0;
 
 	if (efi_enabled(EFI_OLD_MEMMAP))
 		return;
 
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		md = p;
-
+	for_each_efi_memory_desc(md) {
 		if (!(md->attribute & EFI_MEMORY_RUNTIME) ||
 		    (md->type == EFI_BOOT_SERVICES_CODE) ||
 		    (md->type == EFI_BOOT_SERVICES_DATA))
@@ -814,7 +801,6 @@ static void __init kexec_enter_virtual_mode(void)
 #ifdef CONFIG_KEXEC_CORE
 	efi_memory_desc_t *md;
 	unsigned int num_pages;
-	void *p;
 
 	efi.systab = NULL;
 
@@ -838,8 +824,7 @@ static void __init kexec_enter_virtual_mode(void)
 	* Map efi regions which were passed via setup_data. The virt_addr is a
 	* fixed addr which was used in first kernel of a kexec boot.
 	*/
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		md = p;
+	for_each_efi_memory_desc(md) {
 		efi_map_region_fixed(md); /* FIXME: add error handling */
 		get_systab_virt_addr(md);
 	}
@@ -1009,13 +994,11 @@ void __init efi_enter_virtual_mode(void)
 u32 efi_mem_type(unsigned long phys_addr)
 {
 	efi_memory_desc_t *md;
-	void *p;
 
 	if (!efi_enabled(EFI_MEMMAP))
 		return 0;
 
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		md = p;
+	for_each_efi_memory_desc(md) {
 		if ((md->phys_addr <= phys_addr) &&
 		    (phys_addr < (md->phys_addr +
 				  (md->num_pages << EFI_PAGE_SHIFT))))
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 49e4dd4a1f58..6e7242be1c87 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -55,14 +55,12 @@ struct efi_scratch efi_scratch;
 static void __init early_code_mapping_set_exec(int executable)
 {
 	efi_memory_desc_t *md;
-	void *p;
 
 	if (!(__supported_pte_mask & _PAGE_NX))
 		return;
 
 	/* Make EFI service code area executable */
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		md = p;
+	for_each_efi_memory_desc(md) {
 		if (md->type == EFI_RUNTIME_SERVICES_CODE ||
 		    md->type == EFI_BOOT_SERVICES_CODE)
 			efi_set_executable(md, executable);
@@ -253,7 +251,7 @@ int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 	 * Map all of RAM so that we can access arguments in the 1:1
 	 * mapping when making EFI runtime calls.
 	 */
-	for_each_efi_memory_desc(&memmap, md) {
+	for_each_efi_memory_desc(md) {
 		if (md->type != EFI_CONVENTIONAL_MEMORY &&
 		    md->type != EFI_LOADER_DATA &&
 		    md->type != EFI_LOADER_CODE)
@@ -398,7 +396,6 @@ void __init efi_runtime_update_mappings(void)
 	unsigned long pfn;
 	pgd_t *pgd = efi_pgd;
 	efi_memory_desc_t *md;
-	void *p;
 
 	if (efi_enabled(EFI_OLD_MEMMAP)) {
 		if (__supported_pte_mask & _PAGE_NX)
@@ -409,9 +406,8 @@ void __init efi_runtime_update_mappings(void)
 	if (!efi_enabled(EFI_NX_PE_DATA))
 		return;
 
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+	for_each_efi_memory_desc(md) {
 		unsigned long pf = 0;
-		md = p;
 
 		if (!(md->attribute & EFI_MEMORY_RUNTIME))
 			continue;
diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index ab50ada1d56e..097cb09d917b 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -195,10 +195,9 @@ static bool can_free_region(u64 start, u64 size)
 */
 void __init efi_reserve_boot_services(void)
 {
-	void *p;
+	efi_memory_desc_t *md;
 
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		efi_memory_desc_t *md = p;
+	for_each_efi_memory_desc(md) {
 		u64 start = md->phys_addr;
 		u64 size = md->num_pages << EFI_PAGE_SHIFT;
 		bool already_reserved;
@@ -250,10 +249,9 @@ void __init efi_reserve_boot_services(void)
 
 void __init efi_free_boot_services(void)
 {
-	void *p;
+	efi_memory_desc_t *md;
 
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		efi_memory_desc_t *md = p;
+	for_each_efi_memory_desc(md) {
 		unsigned long long start = md->phys_addr;
 		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
 
diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
index 008ed1993b72..d5f6b0ca521e 100644
--- a/drivers/firmware/efi/arm-init.c
+++ b/drivers/firmware/efi/arm-init.c
@@ -40,7 +40,7 @@ static phys_addr_t efi_to_phys(unsigned long addr)
 {
 	efi_memory_desc_t *md;
 
-	for_each_efi_memory_desc(&memmap, md) {
+	for_each_efi_memory_desc_in_map(&memmap, md) {
 		if (!(md->attribute & EFI_MEMORY_RUNTIME))
 			continue;
 		if (md->virt_addr == 0)
@@ -145,7 +145,7 @@ static __init void reserve_regions(void)
 	if (efi_enabled(EFI_DBG))
 		pr_info("Processing EFI memory map:\n");
 
-	for_each_efi_memory_desc(&memmap, md) {
+	for_each_efi_memory_desc_in_map(&memmap, md) {
 		paddr = md->phys_addr;
 		npages = md->num_pages;
 
diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
index 771750df6b7d..1cfbfaf57a2d 100644
--- a/drivers/firmware/efi/arm-runtime.c
+++ b/drivers/firmware/efi/arm-runtime.c
@@ -48,7 +48,7 @@ static bool __init efi_virtmap_init(void)
 	init_new_context(NULL, &efi_mm);
 
 	systab_found = false;
-	for_each_efi_memory_desc(&memmap, md) {
+	for_each_efi_memory_desc(md) {
 		phys_addr_t phys = md->phys_addr;
 		int ret;
 
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 3a69ed5ecfcb..4b533ce73374 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -620,16 +620,12 @@ char * __init efi_md_typeattr_format(char *buf, size_t size,
  */
 u64 __weak efi_mem_attributes(unsigned long phys_addr)
 {
-	struct efi_memory_map *map;
 	efi_memory_desc_t *md;
-	void *p;
 
 	if (!efi_enabled(EFI_MEMMAP))
 		return 0;
 
-	map = efi.memmap;
-	for (p = map->map; p < map->map_end; p += map->desc_size) {
-		md = p;
+	for_each_efi_memory_desc(md) {
 		if ((md->phys_addr <= phys_addr) &&
 		    (phys_addr < (md->phys_addr +
 		    (md->num_pages << EFI_PAGE_SHIFT))))
diff --git a/drivers/firmware/efi/fake_mem.c b/drivers/firmware/efi/fake_mem.c
index ed3a854950cc..f55b75b2e1f4 100644
--- a/drivers/firmware/efi/fake_mem.c
+++ b/drivers/firmware/efi/fake_mem.c
@@ -68,8 +68,7 @@ void __init efi_fake_memmap(void)
 		return;
 
 	/* count up the number of EFI memory descriptor */
-	for (old = memmap.map; old < memmap.map_end; old += memmap.desc_size) {
-		md = old;
+	for_each_efi_memory_desc(md) {
 		start = md->phys_addr;
 		end = start + (md->num_pages << EFI_PAGE_SHIFT) - 1;
 
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 29ed2f9b218c..3bd127f95315 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -125,10 +125,12 @@ unsigned long get_dram_base(efi_system_table_t *sys_table_arg)
 
 	map.map_end = map.map + map_size;
 
-	for_each_efi_memory_desc(&map, md)
-		if (md->attribute & EFI_MEMORY_WB)
+	for_each_efi_memory_desc_in_map(&map, md) {
+		if (md->attribute & EFI_MEMORY_WB) {
 			if (membase > md->phys_addr)
 				membase = md->phys_addr;
+		}
+	}
 
 	efi_call_early(free_pool, map.map);
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 1545098b0565..17ef4471e603 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -958,11 +958,20 @@ static inline void efi_fake_memmap(void) { }
 #endif
 
 /* Iterate through an efi_memory_map */
-#define for_each_efi_memory_desc(m, md)					   \
+#define for_each_efi_memory_desc_in_map(m, md)				   \
 	for ((md) = (m)->map;						   \
 	     (md) <= (efi_memory_desc_t *)((m)->map_end - (m)->desc_size); \
 	     (md) = (void *)(md) + (m)->desc_size)
 
+/**
+ * for_each_efi_memory_desc - iterate over descriptors in efi.memmap
+ * @md: the efi_memory_desc_t * iterator
+ *
+ * Once the loop finishes @md must not be accessed.
+ */
+#define for_each_efi_memory_desc(md) \
+	for_each_efi_memory_desc_in_map(efi.memmap, md)
+
 /*
  * Format an EFI memory descriptor's type and attributes to a user-provided
  * character buffer, as per snprintf(), and return the buffer.
-- 
2.7.3
