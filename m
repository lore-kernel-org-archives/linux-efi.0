From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 04/10] efi: Constify HandleProtocol() / LocateHandle() /
 LocateProtocol()
Date: Mon, 2 Jan 2017 11:24:33 +0100
Message-ID: <d9c3a58dc67462e16afb778161f25b415a517d3b.1483318593.git.lukas@wunner.de>
References: <cover.1483318593.git.lukas@wunner.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1483318593.git.lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

GUIDs passed to HandleProtocol() / LocateHandle() / LocateProtocol() are
not modified, so declare them const.  This allows the compiler to place
them in the rodata section instead of generating them on the stack at
runtime.  Pass GUIDs as literals rather than assigning them to temporary
variables to save a bit on code.  (Except for UGA and GOP GUIDs as they
are passed around between functions.)  Constification of the GUIDs is
in compliance with the EFI spec which marks them "IN" for said boot
services.

Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
---
 arch/x86/boot/compressed/eboot.c        | 48 ++++++++++++++++-----------------
 drivers/firmware/efi/libstub/arm-stub.c | 10 +++----
 drivers/firmware/efi/libstub/gop.c      | 12 ++++-----
 drivers/firmware/efi/libstub/random.c   |  6 ++---
 include/linux/efi.h                     |  9 ++++---
 5 files changed, 39 insertions(+), 46 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 6d3aeab..61014f5 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -43,13 +43,12 @@ static inline efi_status_t __open_volume32(void *__image, void **__fh)
 	efi_file_io_interface_t *io;
 	efi_loaded_image_32_t *image = __image;
 	efi_file_handle_32_t *fh;
-	efi_guid_t fs_proto = EFI_FILE_SYSTEM_GUID;
 	efi_status_t status;
 	void *handle = (void *)(unsigned long)image->device_handle;
 	unsigned long func;
 
 	status = efi_call_early(handle_protocol, handle,
-				&fs_proto, (void **)&io);
+				&EFI_FILE_SYSTEM_GUID, (void **)&io);
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table, "Failed to handle fs_proto\n");
 		return status;
@@ -69,13 +68,12 @@ static inline efi_status_t __open_volume64(void *__image, void **__fh)
 	efi_file_io_interface_t *io;
 	efi_loaded_image_64_t *image = __image;
 	efi_file_handle_64_t *fh;
-	efi_guid_t fs_proto = EFI_FILE_SYSTEM_GUID;
 	efi_status_t status;
 	void *handle = (void *)(unsigned long)image->device_handle;
 	unsigned long func;
 
 	status = efi_call_early(handle_protocol, handle,
-				&fs_proto, (void **)&io);
+				&EFI_FILE_SYSTEM_GUID, (void **)&io);
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table, "Failed to handle fs_proto\n");
 		return status;
@@ -173,7 +171,6 @@ void efi_char16_printk(efi_system_table_t *table, efi_char16_t *str)
 		unsigned long size)
 {
 	efi_pci_io_protocol_32 *pci = NULL;
-	efi_guid_t pci_proto = EFI_PCI_IO_PROTOCOL_GUID;
 	u32 *handles = (u32 *)(unsigned long)pci_handle;
 	efi_status_t status;
 	unsigned long nr_pci;
@@ -191,7 +188,8 @@ void efi_char16_printk(efi_system_table_t *table, efi_char16_t *str)
 		u32 h = handles[i];
 
 		status = efi_call_early(handle_protocol, h,
-					&pci_proto, (void **)&pci);
+					&EFI_PCI_IO_PROTOCOL_GUID,
+					(void **)&pci);
 
 		if (status != EFI_SUCCESS)
 			continue;
@@ -280,7 +278,6 @@ void efi_char16_printk(efi_system_table_t *table, efi_char16_t *str)
 		unsigned long size)
 {
 	efi_pci_io_protocol_64 *pci = NULL;
-	efi_guid_t pci_proto = EFI_PCI_IO_PROTOCOL_GUID;
 	u64 *handles = (u64 *)(unsigned long)pci_handle;
 	efi_status_t status;
 	unsigned long nr_pci;
@@ -298,7 +295,8 @@ void efi_char16_printk(efi_system_table_t *table, efi_char16_t *str)
 		u64 h = handles[i];
 
 		status = efi_call_early(handle_protocol, h,
-					&pci_proto, (void **)&pci);
+					&EFI_PCI_IO_PROTOCOL_GUID,
+					(void **)&pci);
 
 		if (status != EFI_SUCCESS)
 			continue;
@@ -333,12 +331,12 @@ static void setup_efi_pci(struct boot_params *params)
 {
 	efi_status_t status;
 	void **pci_handle = NULL;
-	efi_guid_t pci_proto = EFI_PCI_IO_PROTOCOL_GUID;
 	unsigned long size = 0;
 
 	status = efi_call_early(locate_handle,
 				EFI_LOCATE_BY_PROTOCOL,
-				&pci_proto, NULL, &size, pci_handle);
+				&EFI_PCI_IO_PROTOCOL_GUID,
+				NULL, &size, pci_handle);
 
 	if (status == EFI_BUFFER_TOO_SMALL) {
 		status = efi_call_early(allocate_pool,
@@ -351,7 +349,8 @@ static void setup_efi_pci(struct boot_params *params)
 		}
 
 		status = efi_call_early(locate_handle,
-					EFI_LOCATE_BY_PROTOCOL, &pci_proto,
+					EFI_LOCATE_BY_PROTOCOL,
+					&EFI_PCI_IO_PROTOCOL_GUID,
 					NULL, &size, pci_handle);
 	}
 
@@ -369,13 +368,13 @@ static void setup_efi_pci(struct boot_params *params)
 
 static void retrieve_apple_device_properties(struct boot_params *boot_params)
 {
-	efi_guid_t guid = APPLE_PROPERTIES_PROTOCOL_GUID;
 	struct setup_data *data, *new;
 	efi_status_t status;
 	u32 size = 0;
 	void *p;
 
-	status = efi_call_early(locate_protocol, &guid, NULL, &p);
+	status = efi_call_early(locate_protocol,
+				&APPLE_PROPERTIES_PROTOCOL_GUID, NULL, &p);
 	if (status != EFI_SUCCESS)
 		return;
 
@@ -434,7 +433,7 @@ static void setup_quirks(struct boot_params *boot_params)
 setup_uga32(void **uga_handle, unsigned long size, u32 *width, u32 *height)
 {
 	struct efi_uga_draw_protocol *uga = NULL, *first_uga;
-	efi_guid_t uga_proto = EFI_UGA_PROTOCOL_GUID;
+	const efi_guid_t uga_proto = EFI_UGA_PROTOCOL_GUID;
 	unsigned long nr_ugas;
 	u32 *handles = (u32 *)uga_handle;;
 	efi_status_t status = EFI_INVALID_PARAMETER;
@@ -443,7 +442,6 @@ static void setup_quirks(struct boot_params *boot_params)
 	first_uga = NULL;
 	nr_ugas = size / sizeof(u32);
 	for (i = 0; i < nr_ugas; i++) {
-		efi_guid_t pciio_proto = EFI_PCI_IO_PROTOCOL_GUID;
 		u32 w, h, depth, refresh;
 		void *pciio;
 		u32 handle = handles[i];
@@ -453,7 +451,8 @@ static void setup_quirks(struct boot_params *boot_params)
 		if (status != EFI_SUCCESS)
 			continue;
 
-		efi_call_early(handle_protocol, handle, &pciio_proto, &pciio);
+		efi_call_early(handle_protocol, handle,
+			       &EFI_PCI_IO_PROTOCOL_GUID, &pciio);
 
 		status = efi_early->call((unsigned long)uga->get_mode, uga,
 					 &w, &h, &depth, &refresh);
@@ -479,7 +478,7 @@ static void setup_quirks(struct boot_params *boot_params)
 setup_uga64(void **uga_handle, unsigned long size, u32 *width, u32 *height)
 {
 	struct efi_uga_draw_protocol *uga = NULL, *first_uga;
-	efi_guid_t uga_proto = EFI_UGA_PROTOCOL_GUID;
+	const efi_guid_t uga_proto = EFI_UGA_PROTOCOL_GUID;
 	unsigned long nr_ugas;
 	u64 *handles = (u64 *)uga_handle;;
 	efi_status_t status = EFI_INVALID_PARAMETER;
@@ -488,7 +487,6 @@ static void setup_quirks(struct boot_params *boot_params)
 	first_uga = NULL;
 	nr_ugas = size / sizeof(u64);
 	for (i = 0; i < nr_ugas; i++) {
-		efi_guid_t pciio_proto = EFI_PCI_IO_PROTOCOL_GUID;
 		u32 w, h, depth, refresh;
 		void *pciio;
 		u64 handle = handles[i];
@@ -498,7 +496,8 @@ static void setup_quirks(struct boot_params *boot_params)
 		if (status != EFI_SUCCESS)
 			continue;
 
-		efi_call_early(handle_protocol, handle, &pciio_proto, &pciio);
+		efi_call_early(handle_protocol, handle,
+			       &EFI_PCI_IO_PROTOCOL_GUID, &pciio);
 
 		status = efi_early->call((unsigned long)uga->get_mode, uga,
 					 &w, &h, &depth, &refresh);
@@ -523,8 +522,8 @@ static void setup_quirks(struct boot_params *boot_params)
 /*
  * See if we have Universal Graphics Adapter (UGA) protocol
  */
-static efi_status_t setup_uga(struct screen_info *si, efi_guid_t *uga_proto,
-			      unsigned long size)
+static efi_status_t setup_uga(struct screen_info *si,
+			      const efi_guid_t *uga_proto, unsigned long size)
 {
 	efi_status_t status;
 	u32 width, height;
@@ -575,9 +574,9 @@ static efi_status_t setup_uga(struct screen_info *si, efi_guid_t *uga_proto,
 
 void setup_graphics(struct boot_params *boot_params)
 {
-	efi_guid_t graphics_proto = EFI_GRAPHICS_OUTPUT_PROTOCOL_GUID;
+	const efi_guid_t graphics_proto = EFI_GRAPHICS_OUTPUT_PROTOCOL_GUID;
 	struct screen_info *si;
-	efi_guid_t uga_proto = EFI_UGA_PROTOCOL_GUID;
+	const efi_guid_t uga_proto = EFI_UGA_PROTOCOL_GUID;
 	efi_status_t status;
 	unsigned long size;
 	void **gop_handle = NULL;
@@ -618,7 +617,6 @@ struct boot_params *make_boot_params(struct efi_config *c)
 	struct setup_header *hdr;
 	efi_loaded_image_t *image;
 	void *options, *handle;
-	efi_guid_t proto = LOADED_IMAGE_PROTOCOL_GUID;
 	int options_size = 0;
 	efi_status_t status;
 	char *cmdline_ptr;
@@ -642,7 +640,7 @@ struct boot_params *make_boot_params(struct efi_config *c)
 		setup_boot_services32(efi_early);
 
 	status = efi_call_early(handle_protocol, handle,
-				&proto, (void *)&image);
+				&LOADED_IMAGE_PROTOCOL_GUID, (void *)&image);
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table, "Failed to get handle for LOADED_IMAGE_PROTOCOL\n");
 		return NULL;
diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index da72bfb..70d6722 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -71,12 +71,11 @@ efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg,
 	efi_file_io_interface_t *io;
 	efi_loaded_image_t *image = __image;
 	efi_file_handle_t *fh;
-	efi_guid_t fs_proto = EFI_FILE_SYSTEM_GUID;
 	efi_status_t status;
 	void *handle = (void *)(unsigned long)image->device_handle;
 
-	status = sys_table_arg->boottime->handle_protocol(handle,
-				 &fs_proto, (void **)&io);
+	status = efi_call_early(handle_protocol, handle,
+				&EFI_FILE_SYSTEM_GUID, (void **)&io);
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table_arg, "Failed to handle fs_proto\n");
 		return status;
@@ -101,7 +100,7 @@ void efi_char16_printk(efi_system_table_t *sys_table_arg,
 
 static struct screen_info *setup_graphics(efi_system_table_t *sys_table_arg)
 {
-	efi_guid_t gop_proto = EFI_GRAPHICS_OUTPUT_PROTOCOL_GUID;
+	const efi_guid_t gop_proto = EFI_GRAPHICS_OUTPUT_PROTOCOL_GUID;
 	efi_status_t status;
 	unsigned long size;
 	void **gop_handle = NULL;
@@ -153,7 +152,6 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 	char *cmdline_ptr = NULL;
 	int cmdline_size = 0;
 	unsigned long new_fdt_addr;
-	efi_guid_t loaded_image_proto = LOADED_IMAGE_PROTOCOL_GUID;
 	unsigned long reserve_addr = 0;
 	unsigned long reserve_size = 0;
 	int secure_boot = 0;
@@ -175,7 +173,7 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 	 * line.
 	 */
 	status = sys_table->boottime->handle_protocol(handle,
-					&loaded_image_proto, (void *)&image);
+				&LOADED_IMAGE_PROTOCOL_GUID, (void *)&image);
 	if (status != EFI_SUCCESS) {
 		pr_efi_err(sys_table, "Failed to get loaded image protocol\n");
 		goto fail;
diff --git a/drivers/firmware/efi/libstub/gop.c b/drivers/firmware/efi/libstub/gop.c
index 932742e..9513a98 100644
--- a/drivers/firmware/efi/libstub/gop.c
+++ b/drivers/firmware/efi/libstub/gop.c
@@ -111,7 +111,7 @@ static void find_bits(unsigned long mask, u8 *pos, u8 *size)
 
 static efi_status_t
 setup_gop32(efi_system_table_t *sys_table_arg, struct screen_info *si,
-            efi_guid_t *proto, unsigned long size, void **gop_handle)
+	    const efi_guid_t *proto, unsigned long size, void **gop_handle)
 {
 	struct efi_graphics_output_protocol_32 *gop32, *first_gop;
 	unsigned long nr_gops;
@@ -131,7 +131,6 @@ static void find_bits(unsigned long mask, u8 *pos, u8 *size)
 	nr_gops = size / sizeof(u32);
 	for (i = 0; i < nr_gops; i++) {
 		struct efi_graphics_output_mode_info *info = NULL;
-		efi_guid_t conout_proto = EFI_CONSOLE_OUT_DEVICE_GUID;
 		bool conout_found = false;
 		void *dummy = NULL;
 		efi_handle_t h = (efi_handle_t)(unsigned long)handles[i];
@@ -143,7 +142,7 @@ static void find_bits(unsigned long mask, u8 *pos, u8 *size)
 			continue;
 
 		status = efi_call_early(handle_protocol, h,
-					&conout_proto, &dummy);
+					&EFI_CONSOLE_OUT_DEVICE_GUID, &dummy);
 		if (status == EFI_SUCCESS)
 			conout_found = true;
 
@@ -228,7 +227,7 @@ static void find_bits(unsigned long mask, u8 *pos, u8 *size)
 
 static efi_status_t
 setup_gop64(efi_system_table_t *sys_table_arg, struct screen_info *si,
-	    efi_guid_t *proto, unsigned long size, void **gop_handle)
+	    const efi_guid_t *proto, unsigned long size, void **gop_handle)
 {
 	struct efi_graphics_output_protocol_64 *gop64, *first_gop;
 	unsigned long nr_gops;
@@ -248,7 +247,6 @@ static void find_bits(unsigned long mask, u8 *pos, u8 *size)
 	nr_gops = size / sizeof(u64);
 	for (i = 0; i < nr_gops; i++) {
 		struct efi_graphics_output_mode_info *info = NULL;
-		efi_guid_t conout_proto = EFI_CONSOLE_OUT_DEVICE_GUID;
 		bool conout_found = false;
 		void *dummy = NULL;
 		efi_handle_t h = (efi_handle_t)(unsigned long)handles[i];
@@ -260,7 +258,7 @@ static void find_bits(unsigned long mask, u8 *pos, u8 *size)
 			continue;
 
 		status = efi_call_early(handle_protocol, h,
-					&conout_proto, &dummy);
+					&EFI_CONSOLE_OUT_DEVICE_GUID, &dummy);
 		if (status == EFI_SUCCESS)
 			conout_found = true;
 
@@ -323,7 +321,7 @@ static void find_bits(unsigned long mask, u8 *pos, u8 *size)
  * See if we have Graphics Output Protocol
  */
 efi_status_t efi_setup_gop(efi_system_table_t *sys_table_arg,
-			   struct screen_info *si, efi_guid_t *proto,
+			   struct screen_info *si, const efi_guid_t *proto,
 			   unsigned long size)
 {
 	efi_status_t status;
diff --git a/drivers/firmware/efi/libstub/random.c b/drivers/firmware/efi/libstub/random.c
index 7e72954..ffb1130 100644
--- a/drivers/firmware/efi/libstub/random.c
+++ b/drivers/firmware/efi/libstub/random.c
@@ -23,11 +23,10 @@ struct efi_rng_protocol {
 efi_status_t efi_get_random_bytes(efi_system_table_t *sys_table_arg,
 				  unsigned long size, u8 *out)
 {
-	efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;
 	efi_status_t status;
 	struct efi_rng_protocol *rng;
 
-	status = efi_call_early(locate_protocol, &rng_proto, NULL,
+	status = efi_call_early(locate_protocol, &EFI_RNG_PROTOCOL_GUID, NULL,
 				(void **)&rng);
 	if (status != EFI_SUCCESS)
 		return status;
@@ -149,14 +148,13 @@ efi_status_t efi_random_alloc(efi_system_table_t *sys_table_arg,
 
 efi_status_t efi_random_get_seed(efi_system_table_t *sys_table_arg)
 {
-	efi_guid_t rng_proto = EFI_RNG_PROTOCOL_GUID;
 	efi_guid_t rng_algo_raw = EFI_RNG_ALGORITHM_RAW;
 	efi_guid_t rng_table_guid = LINUX_EFI_RANDOM_SEED_TABLE_GUID;
 	struct efi_rng_protocol *rng;
 	struct linux_efi_random_seed *seed;
 	efi_status_t status;
 
-	status = efi_call_early(locate_protocol, &rng_proto, NULL,
+	status = efi_call_early(locate_protocol, &EFI_RNG_PROTOCOL_GUID, NULL,
 				(void **)&rng);
 	if (status != EFI_SUCCESS)
 		return status;
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 6ade102..c4923c1f 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -293,10 +293,11 @@ struct efi_boot_memmap {
 	void *install_protocol_interface;
 	void *reinstall_protocol_interface;
 	void *uninstall_protocol_interface;
-	efi_status_t (*handle_protocol)(efi_handle_t, efi_guid_t *, void **);
+	efi_status_t (*handle_protocol)(efi_handle_t, const efi_guid_t *,
+					void **);
 	void *__reserved;
 	void *register_protocol_notify;
-	efi_status_t (*locate_handle)(int, efi_guid_t *, void *,
+	efi_status_t (*locate_handle)(int, const efi_guid_t *, void *,
 				      unsigned long *, efi_handle_t *);
 	void *locate_device_path;
 	efi_status_t (*install_configuration_table)(efi_guid_t *, void *);
@@ -315,7 +316,7 @@ struct efi_boot_memmap {
 	void *open_protocol_information;
 	void *protocols_per_handle;
 	void *locate_handle_buffer;
-	efi_status_t (*locate_protocol)(efi_guid_t *, void *, void **);
+	efi_status_t (*locate_protocol)(const efi_guid_t *, void *, void **);
 	void *install_multiple_protocol_interfaces;
 	void *uninstall_multiple_protocol_interfaces;
 	void *calculate_crc32;
@@ -1472,7 +1473,7 @@ efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 efi_status_t efi_parse_options(char *cmdline);
 
 efi_status_t efi_setup_gop(efi_system_table_t *sys_table_arg,
-			   struct screen_info *si, efi_guid_t *proto,
+			   struct screen_info *si, const efi_guid_t *proto,
 			   unsigned long size);
 
 bool efi_runtime_disabled(void);
-- 
2.11.0
