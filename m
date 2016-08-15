From: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH V4 1/4] efi/libstub: Allocate headspace in efi_get_memory_map()
Date: Mon, 15 Aug 2016 13:22:10 -0600
Message-ID: <1471288933-31810-2-git-send-email-jhugo@codeaurora.org>
References: <1471288933-31810-1-git-send-email-jhugo@codeaurora.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471288933-31810-1-git-send-email-jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

efi_get_memory_map() allocates a buffer to store the memory map that it
retrieves.  This buffer may need to be reused by the client after
ExitBootServices() is called, at which point allocations are not longer
permitted.  To support this usecase, provide the allocated buffer size back
to the client, and allocate some additional headroom to account for any
reasonable growth in the map that is likely to happen between the call to
efi_get_memory_map() and the client reusing the buffer.

Signed-off-by: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
---
 arch/x86/boot/compressed/eboot.c               | 12 +++-
 drivers/firmware/efi/libstub/efi-stub-helper.c | 96 ++++++++++++++++++--------
 drivers/firmware/efi/libstub/fdt.c             | 17 +++--
 drivers/firmware/efi/libstub/random.c          | 12 +++-
 include/linux/efi.h                            | 15 ++--
 5 files changed, 107 insertions(+), 45 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 52fef60..31d0ca5 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1010,7 +1010,7 @@ static efi_status_t exit_boot(struct boot_params *boot_params,
 			      void *handle, bool is64)
 {
 	struct efi_info *efi = &boot_params->efi_info;
-	unsigned long map_sz, key, desc_size;
+	unsigned long map_sz, key, desc_size, buff_size;
 	efi_memory_desc_t *mem_map;
 	struct setup_data *e820ext;
 	const char *signature;
@@ -1021,14 +1021,20 @@ static efi_status_t exit_boot(struct boot_params *boot_params,
 	bool called_exit = false;
 	u8 nr_entries;
 	int i;
+	efi_boottime_memory_map_t map;
 
 	nr_desc = 0;
 	e820ext = NULL;
 	e820ext_size = 0;
+	map.map = &mem_map;
+	map.map_size = &map_sz;
+	map.desc_size = &desc_size;
+	map.desc_ver = &desc_version;
+	map.key_ptr = &key;
+	map.buff_size = &buff_size;
 
 get_map:
-	status = efi_get_memory_map(sys_table, &mem_map, &map_sz, &desc_size,
-				    &desc_version, &key);
+	status = efi_get_memory_map(sys_table, &map);
 
 	if (status != EFI_SUCCESS)
 		return status;
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 3bd127f9..bbb5166 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -41,6 +41,8 @@ static unsigned long __chunk_size = EFI_READ_CHUNK_SIZE;
 #define EFI_ALLOC_ALIGN		EFI_PAGE_SIZE
 #endif
 
+#define EFI_MMAP_NR_SLACK_SLOTS	8
+
 struct file_info {
 	efi_file_handle_t *handle;
 	u64 size;
@@ -63,49 +65,62 @@ void efi_printk(efi_system_table_t *sys_table_arg, char *str)
 	}
 }
 
+static inline bool mmap_has_headroom(unsigned long buff_size,
+				     unsigned long map_size,
+				     unsigned long desc_size)
+{
+	unsigned long slack = buff_size - map_size;
+
+	return slack / desc_size >= EFI_MMAP_NR_SLACK_SLOTS;
+}
+
 efi_status_t efi_get_memory_map(efi_system_table_t *sys_table_arg,
-				efi_memory_desc_t **map,
-				unsigned long *map_size,
-				unsigned long *desc_size,
-				u32 *desc_ver,
-				unsigned long *key_ptr)
+				efi_boottime_memory_map_t *map)
 {
 	efi_memory_desc_t *m = NULL;
 	efi_status_t status;
 	unsigned long key;
 	u32 desc_version;
 
-	*map_size = sizeof(*m) * 32;
+	*map->desc_size = sizeof(*m);
+	*map->map_size = *map->desc_size * 32;
+	*map->buff_size = *map->map_size;
 again:
-	/*
-	 * Add an additional efi_memory_desc_t because we're doing an
-	 * allocation which may be in a new descriptor region.
-	 */
-	*map_size += sizeof(*m);
 	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
-				*map_size, (void **)&m);
+				*map->map_size, (void **)&m);
 	if (status != EFI_SUCCESS)
 		goto fail;
 
-	*desc_size = 0;
+	*map->desc_size = 0;
 	key = 0;
-	status = efi_call_early(get_memory_map, map_size, m,
-				&key, desc_size, &desc_version);
-	if (status == EFI_BUFFER_TOO_SMALL) {
+	status = efi_call_early(get_memory_map, map->map_size, m,
+				&key, map->desc_size, &desc_version);
+	if (status == EFI_BUFFER_TOO_SMALL ||
+	    !mmap_has_headroom(*map->buff_size, *map->map_size,
+			       *map->desc_size)) {
 		efi_call_early(free_pool, m);
+		/*
+		 * Make sure there is some entries of headroom so that the
+		 * buffer can be reused for a new map after allocations are
+		 * no longer permitted.  Its unlikely that the map will grow to
+		 * exceed this headroom once we are ready to trigger
+		 * ExitBootServices()
+		 */
+		*map->map_size += *map->desc_size * EFI_MMAP_NR_SLACK_SLOTS;
+		*map->buff_size = *map->map_size;
 		goto again;
 	}
 
 	if (status != EFI_SUCCESS)
 		efi_call_early(free_pool, m);
 
-	if (key_ptr && status == EFI_SUCCESS)
-		*key_ptr = key;
-	if (desc_ver && status == EFI_SUCCESS)
-		*desc_ver = desc_version;
+	if (map->key_ptr && status == EFI_SUCCESS)
+		*map->key_ptr = key;
+	if (map->desc_ver && status == EFI_SUCCESS)
+		*map->desc_ver = desc_version;
 
 fail:
-	*map = m;
+	*map->map = m;
 	return status;
 }
 
@@ -113,13 +128,20 @@ fail:
 unsigned long get_dram_base(efi_system_table_t *sys_table_arg)
 {
 	efi_status_t status;
-	unsigned long map_size;
+	unsigned long map_size, buff_size;
 	unsigned long membase  = EFI_ERROR;
 	struct efi_memory_map map;
 	efi_memory_desc_t *md;
+	efi_boottime_memory_map_t boot_map;
 
-	status = efi_get_memory_map(sys_table_arg, (efi_memory_desc_t **)&map.map,
-				    &map_size, &map.desc_size, NULL, NULL);
+	boot_map.map = (efi_memory_desc_t **)&map.map;
+	boot_map.map_size = &map_size;
+	boot_map.desc_size = &map.desc_size;
+	boot_map.desc_ver = NULL;
+	boot_map.key_ptr = NULL;
+	boot_map.buff_size = &buff_size;
+
+	status = efi_get_memory_map(sys_table_arg, &boot_map);
 	if (status != EFI_SUCCESS)
 		return membase;
 
@@ -144,15 +166,22 @@ efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
 			    unsigned long size, unsigned long align,
 			    unsigned long *addr, unsigned long max)
 {
-	unsigned long map_size, desc_size;
+	unsigned long map_size, desc_size, buff_size;
 	efi_memory_desc_t *map;
 	efi_status_t status;
 	unsigned long nr_pages;
 	u64 max_addr = 0;
 	int i;
+	efi_boottime_memory_map_t boot_map;
+
+	boot_map.map = &map;
+	boot_map.map_size = &map_size;
+	boot_map.desc_size = &desc_size;
+	boot_map.desc_ver = NULL;
+	boot_map.key_ptr = NULL;
+	boot_map.buff_size = &buff_size;
 
-	status = efi_get_memory_map(sys_table_arg, &map, &map_size, &desc_size,
-				    NULL, NULL);
+	status = efi_get_memory_map(sys_table_arg, &boot_map);
 	if (status != EFI_SUCCESS)
 		goto fail;
 
@@ -230,14 +259,21 @@ efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 			   unsigned long size, unsigned long align,
 			   unsigned long *addr)
 {
-	unsigned long map_size, desc_size;
+	unsigned long map_size, desc_size, buff_size;
 	efi_memory_desc_t *map;
 	efi_status_t status;
 	unsigned long nr_pages;
 	int i;
+	efi_boottime_memory_map_t boot_map;
+
+	boot_map.map = &map;
+	boot_map.map_size = &map_size;
+	boot_map.desc_size = &desc_size;
+	boot_map.desc_ver = NULL;
+	boot_map.key_ptr = NULL;
+	boot_map.buff_size = &buff_size;
 
-	status = efi_get_memory_map(sys_table_arg, &map, &map_size, &desc_size,
-				    NULL, NULL);
+	status = efi_get_memory_map(sys_table_arg, &boot_map);
 	if (status != EFI_SUCCESS)
 		goto fail;
 
diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index e58abfa..e94846d 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -175,13 +175,21 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 					    unsigned long fdt_addr,
 					    unsigned long fdt_size)
 {
-	unsigned long map_size, desc_size;
+	unsigned long map_size, desc_size, buff_size;
 	u32 desc_ver;
 	unsigned long mmap_key;
 	efi_memory_desc_t *memory_map, *runtime_map;
 	unsigned long new_fdt_size;
 	efi_status_t status;
 	int runtime_entry_count = 0;
+	efi_boottime_memory_map_t map;
+
+	map.map = &runtime_map;
+	map.map_size = &map_size;
+	map.desc_size = &desc_size;
+	map.desc_ver = &desc_ver;
+	map.key_ptr = &mmap_key;
+	map.buff_size = &buff_size;
 
 	/*
 	 * Get a copy of the current memory map that we will use to prepare
@@ -189,8 +197,7 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 	 * subsequent allocations adding entries, since they could not affect
 	 * the number of EFI_MEMORY_RUNTIME regions.
 	 */
-	status = efi_get_memory_map(sys_table, &runtime_map, &map_size,
-				    &desc_size, &desc_ver, &mmap_key);
+	status = efi_get_memory_map(sys_table, &map);
 	if (status != EFI_SUCCESS) {
 		pr_efi_err(sys_table, "Unable to retrieve UEFI memory map.\n");
 		return status;
@@ -199,6 +206,7 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 	pr_efi(sys_table,
 	       "Exiting boot services and installing virtual address map...\n");
 
+	map.map = &memory_map;
 	/*
 	 * Estimate size of new FDT, and allocate memory for it. We
 	 * will allocate a bigger buffer if this ends up being too
@@ -218,8 +226,7 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 		 * we can get the memory map key  needed for
 		 * exit_boot_services().
 		 */
-		status = efi_get_memory_map(sys_table, &memory_map, &map_size,
-					    &desc_size, &desc_ver, &mmap_key);
+		status = efi_get_memory_map(sys_table, &map);
 		if (status != EFI_SUCCESS)
 			goto fail_free_new_fdt;
 
diff --git a/drivers/firmware/efi/libstub/random.c b/drivers/firmware/efi/libstub/random.c
index 53f6d3f..46c14ee 100644
--- a/drivers/firmware/efi/libstub/random.c
+++ b/drivers/firmware/efi/libstub/random.c
@@ -73,12 +73,20 @@ efi_status_t efi_random_alloc(efi_system_table_t *sys_table_arg,
 			      unsigned long random_seed)
 {
 	unsigned long map_size, desc_size, total_slots = 0, target_slot;
+	unsigned long buff_size;
 	efi_status_t status;
 	efi_memory_desc_t *memory_map;
 	int map_offset;
+	efi_boottime_memory_map_t map;
 
-	status = efi_get_memory_map(sys_table_arg, &memory_map, &map_size,
-				    &desc_size, NULL, NULL);
+	map.map = &memory_map;
+	map.map_size = &map_size;
+	map.desc_size = &desc_size;
+	map.desc_ver = NULL;
+	map.key_ptr = NULL;
+	map.buff_size = &buff_size;
+
+	status = efi_get_memory_map(sys_table_arg, &map);
 	if (status != EFI_SUCCESS)
 		return status;
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index f196dd0..61400a1 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -118,6 +118,15 @@ typedef struct {
 	u32 imagesize;
 } efi_capsule_header_t;
 
+typedef struct {
+	efi_memory_desc_t **map;
+	unsigned long *map_size;
+	unsigned long *desc_size;
+	u32 *desc_ver;
+	unsigned long *key_ptr;
+	unsigned long *buff_size;
+} efi_boottime_memory_map_t;
+
 /*
  * EFI capsule flags
  */
@@ -1430,11 +1439,7 @@ char *efi_convert_cmdline(efi_system_table_t *sys_table_arg,
 			  efi_loaded_image_t *image, int *cmd_line_len);
 
 efi_status_t efi_get_memory_map(efi_system_table_t *sys_table_arg,
-				efi_memory_desc_t **map,
-				unsigned long *map_size,
-				unsigned long *desc_size,
-				u32 *desc_ver,
-				unsigned long *key_ptr);
+				efi_boottime_memory_map_t *map);
 
 efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 			   unsigned long size, unsigned long align,
-- 
Qualcomm Datacenter Technologies as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
