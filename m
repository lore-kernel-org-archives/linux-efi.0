From: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: [PATCH 1/4] efi/libstub: Allocate headspace in efi_get_memory_map()
Date: Sun, 17 Jul 2016 14:45:59 -0600
Message-ID: <1468788362-3962-2-git-send-email-jhugo@codeaurora.org>
References: <1468788362-3962-1-git-send-email-jhugo@codeaurora.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468788362-3962-1-git-send-email-jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
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
 arch/x86/boot/compressed/eboot.c               |  4 ++--
 drivers/firmware/efi/libstub/efi-stub-helper.c | 29 +++++++++++++++++++-------
 drivers/firmware/efi/libstub/fdt.c             |  8 ++++---
 drivers/firmware/efi/libstub/random.c          |  3 ++-
 include/linux/efi.h                            |  3 ++-
 5 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 52fef60..9036ec9 100644
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
@@ -1028,7 +1028,7 @@ static efi_status_t exit_boot(struct boot_params *boot_params,
 
 get_map:
 	status = efi_get_memory_map(sys_table, &mem_map, &map_sz, &desc_size,
-				    &desc_version, &key);
+				    &desc_version, &key, &buff_size);
 
 	if (status != EFI_SUCCESS)
 		return status;
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 3bd127f9..9286ff6 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -68,7 +68,8 @@ efi_status_t efi_get_memory_map(efi_system_table_t *sys_table_arg,
 				unsigned long *map_size,
 				unsigned long *desc_size,
 				u32 *desc_ver,
-				unsigned long *key_ptr)
+				unsigned long *key_ptr,
+				unsigned long *buff_size)
 {
 	efi_memory_desc_t *m = NULL;
 	efi_status_t status;
@@ -76,12 +77,14 @@ efi_status_t efi_get_memory_map(efi_system_table_t *sys_table_arg,
 	u32 desc_version;
 
 	*map_size = sizeof(*m) * 32;
+	*buff_size = *map_size;
 again:
 	/*
 	 * Add an additional efi_memory_desc_t because we're doing an
 	 * allocation which may be in a new descriptor region.
 	 */
 	*map_size += sizeof(*m);
+	*buff_size = *map_size;
 	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
 				*map_size, (void **)&m);
 	if (status != EFI_SUCCESS)
@@ -91,8 +94,17 @@ again:
 	key = 0;
 	status = efi_call_early(get_memory_map, map_size, m,
 				&key, desc_size, &desc_version);
-	if (status == EFI_BUFFER_TOO_SMALL) {
+	if (status == EFI_BUFFER_TOO_SMALL ||
+				(*buff_size - *map_size) / sizeof(*m) < 8) {
 		efi_call_early(free_pool, m);
+		/*
+		 * Make sure there is 8 entries worth of headroom so that the
+		 * buffer can be reused for a new map after allocations are
+		 * no longer permitted.  Its unlikely that the map will grow to
+		 * exceed this headroom once we are ready to trigger
+		 * ExitBootServices()
+		 */
+		*map_size += sizeof(*m) * 8;
 		goto again;
 	}
 
@@ -113,13 +125,14 @@ fail:
 unsigned long get_dram_base(efi_system_table_t *sys_table_arg)
 {
 	efi_status_t status;
-	unsigned long map_size;
+	unsigned long map_size, buff_size;
 	unsigned long membase  = EFI_ERROR;
 	struct efi_memory_map map;
 	efi_memory_desc_t *md;
 
 	status = efi_get_memory_map(sys_table_arg, (efi_memory_desc_t **)&map.map,
-				    &map_size, &map.desc_size, NULL, NULL);
+				    &map_size, &map.desc_size, NULL, NULL,
+				    &buff_size);
 	if (status != EFI_SUCCESS)
 		return membase;
 
@@ -144,7 +157,7 @@ efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
 			    unsigned long size, unsigned long align,
 			    unsigned long *addr, unsigned long max)
 {
-	unsigned long map_size, desc_size;
+	unsigned long map_size, desc_size, buff_size;
 	efi_memory_desc_t *map;
 	efi_status_t status;
 	unsigned long nr_pages;
@@ -152,7 +165,7 @@ efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
 	int i;
 
 	status = efi_get_memory_map(sys_table_arg, &map, &map_size, &desc_size,
-				    NULL, NULL);
+				    NULL, NULL, &buff_size);
 	if (status != EFI_SUCCESS)
 		goto fail;
 
@@ -230,14 +243,14 @@ efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 			   unsigned long size, unsigned long align,
 			   unsigned long *addr)
 {
-	unsigned long map_size, desc_size;
+	unsigned long map_size, desc_size, buff_size;
 	efi_memory_desc_t *map;
 	efi_status_t status;
 	unsigned long nr_pages;
 	int i;
 
 	status = efi_get_memory_map(sys_table_arg, &map, &map_size, &desc_size,
-				    NULL, NULL);
+				    NULL, NULL, &buff_size);
 	if (status != EFI_SUCCESS)
 		goto fail;
 
diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index e58abfa..878e661 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -175,7 +175,7 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 					    unsigned long fdt_addr,
 					    unsigned long fdt_size)
 {
-	unsigned long map_size, desc_size;
+	unsigned long map_size, desc_size, buff_size;
 	u32 desc_ver;
 	unsigned long mmap_key;
 	efi_memory_desc_t *memory_map, *runtime_map;
@@ -190,7 +190,8 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 	 * the number of EFI_MEMORY_RUNTIME regions.
 	 */
 	status = efi_get_memory_map(sys_table, &runtime_map, &map_size,
-				    &desc_size, &desc_ver, &mmap_key);
+				    &desc_size, &desc_ver, &mmap_key,
+				    &buff_size);
 	if (status != EFI_SUCCESS) {
 		pr_efi_err(sys_table, "Unable to retrieve UEFI memory map.\n");
 		return status;
@@ -219,7 +220,8 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
 		 * exit_boot_services().
 		 */
 		status = efi_get_memory_map(sys_table, &memory_map, &map_size,
-					    &desc_size, &desc_ver, &mmap_key);
+					    &desc_size, &desc_ver, &mmap_key,
+					    &buff_size);
 		if (status != EFI_SUCCESS)
 			goto fail_free_new_fdt;
 
diff --git a/drivers/firmware/efi/libstub/random.c b/drivers/firmware/efi/libstub/random.c
index 53f6d3f..9dd8534 100644
--- a/drivers/firmware/efi/libstub/random.c
+++ b/drivers/firmware/efi/libstub/random.c
@@ -73,12 +73,13 @@ efi_status_t efi_random_alloc(efi_system_table_t *sys_table_arg,
 			      unsigned long random_seed)
 {
 	unsigned long map_size, desc_size, total_slots = 0, target_slot;
+	unsigned long buff_size;
 	efi_status_t status;
 	efi_memory_desc_t *memory_map;
 	int map_offset;
 
 	status = efi_get_memory_map(sys_table_arg, &memory_map, &map_size,
-				    &desc_size, NULL, NULL);
+				    &desc_size, NULL, NULL, &buff_size);
 	if (status != EFI_SUCCESS)
 		return status;
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index f196dd0..c47fc5f 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1434,7 +1434,8 @@ efi_status_t efi_get_memory_map(efi_system_table_t *sys_table_arg,
 				unsigned long *map_size,
 				unsigned long *desc_size,
 				u32 *desc_ver,
-				unsigned long *key_ptr);
+				unsigned long *key_ptr,
+				unsigned long *buff_size);
 
 efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 			   unsigned long size, unsigned long align,
-- 
Qualcomm Datacenter Technologies as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
