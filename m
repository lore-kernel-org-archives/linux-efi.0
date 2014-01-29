From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [RFC][PATCH 08/11] x86/efi: Split the boot stub into 32/64 code paths
Date: Wed, 29 Jan 2014 16:23:54 +0000
Message-ID: <1391012637-4839-9-git-send-email-matt@console-pimps.org>
References: <1391012637-4839-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391012637-4839-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Make the decision which code path to take at runtime based on
efi_early->is64.

Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/boot/compressed/eboot.c | 398 +++++++++++++++++++++++++++++++--------
 1 file changed, 323 insertions(+), 75 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 9eff6cd473b7..4e428380bd56 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -75,10 +75,10 @@ static void efi_printk(efi_system_table_t *, char *);
 static void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
 
 static efi_status_t
-efi_file_size(efi_system_table_t *sys_table, void *__fh,
-	      efi_char16_t *filename_16, void **handle, u64 *file_sz)
+__file_size32(void *__fh, efi_char16_t *filename_16,
+	      void **handle, u64 *file_sz)
 {
-	efi_file_handle_t *h, *fh = __fh;
+	efi_file_handle_32_t *h, *fh = __fh;
 	efi_file_info_t *info;
 	efi_status_t status;
 	efi_guid_t info_guid = EFI_FILE_INFO_ID;
@@ -127,30 +127,134 @@ grow:
 	return status;
 }
 
+static efi_status_t
+__file_size64(void *__fh, efi_char16_t *filename_16,
+	      void **handle, u64 *file_sz)
+{
+	efi_file_handle_64_t *h, *fh = __fh;
+	efi_file_info_t *info;
+	efi_status_t status;
+	efi_guid_t info_guid = EFI_FILE_INFO_ID;
+	u32 info_sz;
+
+	status = efi_early->call((unsigned long)fh->open, fh, &h, filename_16,
+				 EFI_FILE_MODE_READ, (u64)0);
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table, "Failed to open file: ");
+		efi_char16_printk(sys_table, filename_16);
+		efi_printk(sys_table, "\n");
+		return status;
+	}
+
+	*handle = h;
+
+	info_sz = 0;
+	status = efi_early->call((unsigned long)h->get_info, h, &info_guid,
+				 &info_sz, NULL);
+	if (status != EFI_BUFFER_TOO_SMALL) {
+		efi_printk(sys_table, "Failed to get file info size\n");
+		return status;
+	}
+
+grow:
+	status = efi_early->call(efi_early->allocate_pool, EFI_LOADER_DATA,
+				 info_sz, (void **)&info);
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table, "Failed to alloc mem for file info\n");
+		return status;
+	}
+
+	status = efi_early->call((unsigned long)h->get_info, h, &info_guid,
+				 &info_sz, info);
+	if (status == EFI_BUFFER_TOO_SMALL) {
+		efi_early->call(efi_early->free_pool, info);
+		return status;
+	}
+
+	*file_sz = info->file_size;
+	efi_early->call(efi_early->free_pool, info);
+
+	if (status != EFI_SUCCESS)
+		efi_printk(sys_table, "Failed to get initrd info\n");
+
+	return status;
+}
+static efi_status_t
+efi_file_size(efi_system_table_t *sys_table, void *__fh,
+	      efi_char16_t *filename_16, void **handle, u64 *file_sz)
+{
+	if (efi_early->is64)
+		return __file_size64(__fh, filename_16, handle, file_sz);
+
+	return __file_size32(__fh, filename_16, handle, file_sz);
+}
+
 static inline efi_status_t
 efi_file_read(void *__fh, void *handle, unsigned long *size, void *addr)
 {
-	efi_file_handle_t *fh = __fh;
-	return efi_early->call((unsigned long)fh->read, fh, handle, size, addr);
+	unsigned long func;
+
+	if (efi_early->is64) {
+		efi_file_handle_64_t *fh = __fh;
+
+		func = (unsigned long)fh->read;
+		return efi_early->call(func, fh, handle, size, addr);
+	} else {
+		efi_file_handle_32_t *fh = __fh;
+
+		func = (unsigned long)fh->read;
+		return efi_early->call(func, fh, handle, size, addr);
+	}
 }
 
 static inline efi_status_t efi_file_close(void *__fh, void *handle)
 {
-	efi_file_handle_t *fh = __fh;
+	if (efi_early->is64) {
+		efi_file_handle_64_t *fh = __fh;
+
+		return efi_early->call((unsigned long)fh->close, handle);
+	} else {
+		efi_file_handle_32_t *fh = __fh;
 
-	return efi_early->call((unsigned long)fh->close, handle);
+		return efi_early->call((unsigned long)fh->close, handle);
+	}
 }
 
-static inline efi_status_t
-efi_open_volume(efi_system_table_t *sys_table, void *__image, void **__fh)
+static inline efi_status_t __open_volume32(void *__image, void **__fh)
+{
+	efi_file_io_interface_t *io;
+	efi_loaded_image_32_t *image = __image;
+	efi_file_handle_32_t *fh;
+	efi_guid_t fs_proto = EFI_FILE_SYSTEM_GUID;
+	efi_status_t status;
+	void *handle = (void *)(unsigned long)image->device_handle;
+	unsigned long func;
+
+	status = efi_early->call(efi_early->handle_protocol, handle,
+				 &fs_proto, (void **)&io);
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table, "Failed to handle fs_proto\n");
+		return status;
+	}
+
+	func = (unsigned long)io->open_volume;
+	status = efi_early->call(func, io, &fh);
+	if (status != EFI_SUCCESS)
+		efi_printk(sys_table, "Failed to open volume\n");
+
+	*__fh = fh;
+	return status;
+}
+
+static inline efi_status_t __open_volume64(void *__image, void **__fh)
 {
 	efi_file_io_interface_t *io;
-	efi_loaded_image_t *image = __image;
-	efi_file_handle_t *fh;
+	efi_loaded_image_64_t *image = __image;
+	efi_file_handle_64_t *fh;
 	efi_guid_t fs_proto = EFI_FILE_SYSTEM_GUID;
 	efi_status_t status;
 	void *handle = (void *)(unsigned long)image->device_handle;
-	u32 func;
+	unsigned long func;
 
 	status = efi_early->call(efi_early->handle_protocol, handle,
 				 &fs_proto, (void **)&io);
@@ -168,19 +272,39 @@ efi_open_volume(efi_system_table_t *sys_table, void *__image, void **__fh)
 	return status;
 }
 
-static inline void
-efi_char16_printk(efi_system_table_t *table, efi_char16_t *str)
+static inline efi_status_t
+efi_open_volume(efi_system_table_t *sys_table, void *__image, void **__fh)
+{
+	if (efi_early->is64)
+		return __open_volume64(__image, __fh);
+
+	return __open_volume32(__image, __fh);
+}
+
+static void efi_char16_printk(efi_system_table_t *table, efi_char16_t *str)
 {
-	struct efi_simple_text_output_protocol *out;
 	unsigned long output_string;
 	size_t offset;
-	unsigned long *func;
 
-	offset = offsetof(typeof(*out), output_string);
-	output_string = efi_early->text_output + offset;
-	func = (unsigned long *)output_string;
+	if (efi_early->is64) {
+		struct efi_simple_text_output_protocol_64 *out;
+		u64 *func;
+
+		offset = offsetof(typeof(*out), output_string);
+		output_string = efi_early->text_output + offset;
+		func = (u64 *)output_string;
 
-	efi_early->call(*func, efi_early->text_output, str);
+		efi_early->call(*func, efi_early->text_output, str);
+	} else {
+		struct efi_simple_text_output_protocol_32 *out;
+		u32 *func;
+
+		offset = offsetof(typeof(*out), output_string);
+		output_string = efi_early->text_output + offset;
+		func = (u32 *)output_string;
+
+		efi_early->call(*func, efi_early->text_output, str);
+	}
 }
 
 #include "../../../../drivers/firmware/efi/efi-stub-helper.c"
@@ -208,6 +332,127 @@ static void find_bits(unsigned long mask, u8 *pos, u8 *size)
 	*size = len;
 }
 
+static efi_status_t
+__setup_efi_pci32(efi_pci_io_protocol *__pci, struct pci_setup_rom **__rom)
+{
+	efi_pci_io_protocol_32 *pci;
+	struct pci_setup_rom *rom;
+	efi_status_t status;
+	unsigned long size;
+	uint64_t attributes;
+
+	pci = (efi_pci_io_protocol_32 *)__pci;
+
+	status = efi_early->call(pci->attributes, pci,
+				 EfiPciIoAttributeOperationGet, 0, 0,
+				 &attributes);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	if (!pci->romimage || !pci->romsize)
+		return EFI_INVALID_PARAMETER;
+
+	size = pci->romsize + sizeof(*rom);
+
+	status = efi_early->call(efi_early->allocate_pool,
+				 EFI_LOADER_DATA, size, &rom);
+
+	if (status != EFI_SUCCESS)
+		return status;
+
+	rom->data.type = SETUP_PCI;
+	rom->data.len = size - sizeof(struct setup_data);
+	rom->data.next = 0;
+	rom->pcilen = pci->romsize;
+	*__rom = rom;
+
+	status = efi_early->call(pci->pci.read, pci, EfiPciIoWidthUint16,
+				 PCI_VENDOR_ID, 1, &(rom->vendor));
+
+	if (status != EFI_SUCCESS)
+		goto free_struct;
+
+	status = efi_early->call(pci->pci.read, pci, EfiPciIoWidthUint16,
+				 PCI_DEVICE_ID, 1, &(rom->devid));
+
+	if (status != EFI_SUCCESS)
+		goto free_struct;
+
+	status = efi_early->call(pci->get_location, pci, &(rom->segment),
+				 &(rom->bus), &(rom->device), &(rom->function));
+
+	if (status != EFI_SUCCESS)
+		goto free_struct;
+
+	memcpy(rom->romdata, pci->romimage, pci->romsize);
+	return status;
+
+free_struct:
+	efi_early->call(efi_early->free_pool, rom);
+	return status;
+}
+
+static efi_status_t
+__setup_efi_pci64(efi_pci_io_protocol *__pci, struct pci_setup_rom **__rom)
+{
+	efi_pci_io_protocol_64 *pci;
+	struct pci_setup_rom *rom;
+	efi_status_t status;
+	unsigned long size;
+	uint64_t attributes;
+
+	pci = (efi_pci_io_protocol_64 *)__pci;
+
+	status = efi_early->call(pci->attributes, pci,
+				 EfiPciIoAttributeOperationGet, 0,
+				 &attributes);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	if (!pci->romimage || !pci->romsize)
+		return EFI_INVALID_PARAMETER;
+
+	size = pci->romsize + sizeof(*rom);
+
+	status = efi_early->call(efi_early->allocate_pool,
+				 EFI_LOADER_DATA, size, &rom);
+
+	if (status != EFI_SUCCESS)
+		return status;
+
+	rom->data.type = SETUP_PCI;
+	rom->data.len = size - sizeof(struct setup_data);
+	rom->data.next = 0;
+	rom->pcilen = pci->romsize;
+	*__rom = rom;
+
+	status = efi_early->call(pci->pci.read, pci, EfiPciIoWidthUint16,
+				 PCI_VENDOR_ID, 1, &(rom->vendor));
+
+	if (status != EFI_SUCCESS)
+		goto free_struct;
+
+	status = efi_early->call(pci->pci.read, pci, EfiPciIoWidthUint16,
+				 PCI_DEVICE_ID, 1, &(rom->devid));
+
+	if (status != EFI_SUCCESS)
+		goto free_struct;
+
+	status = efi_early->call(pci->get_location, pci, &(rom->segment),
+				 &(rom->bus), &(rom->device), &(rom->function));
+
+	if (status != EFI_SUCCESS)
+		goto free_struct;
+
+	memcpy(rom->romdata, pci->romimage, pci->romsize);
+	return status;
+
+free_struct:
+	efi_early->call(efi_early->free_pool, rom);
+	return status;
+
+}
+
 static efi_status_t setup_efi_pci(struct boot_params *params)
 {
 	efi_pci_io_protocol *pci;
@@ -246,7 +491,6 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 	nr_pci = size / sizeof(void *);
 	for (i = 0; i < nr_pci; i++) {
 		void *h = pci_handle[i];
-		uint64_t attributes;
 		struct pci_setup_rom *rom;
 
 		status = efi_early->call(efi_early->handle_protocol, h,
@@ -258,71 +502,72 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 		if (!pci)
 			continue;
 
-#ifdef CONFIG_X86_64
-		status = efi_early->call((unsigned long)pci->attributes, pci,
-					 EfiPciIoAttributeOperationGet, 0,
-					 &attributes);
-#else
-		status = efi_early->call((unsigned long)pci->attributes, pci,
-					 EfiPciIoAttributeOperationGet, 0, 0,
-					 &attributes);
-#endif
-		if (status != EFI_SUCCESS)
-			continue;
-
-		if (!pci->romimage || !pci->romsize)
-			continue;
-
-		size = pci->romsize + sizeof(*rom);
-
-		status = efi_early->call(efi_early->allocate_pool,
-					 EFI_LOADER_DATA, size, &rom);
+		if (efi_early->is64)
+			status = __setup_efi_pci64(pci, &rom);
+		else
+			status = __setup_efi_pci32(pci, &rom);
 
 		if (status != EFI_SUCCESS)
 			continue;
 
-		rom->data.type = SETUP_PCI;
-		rom->data.len = size - sizeof(struct setup_data);
-		rom->data.next = 0;
-		rom->pcilen = pci->romsize;
+		if (data)
+			data->next = (unsigned long)rom;
+		else
+			params->hdr.setup_data = (unsigned long)rom;
 
-		status = efi_early->call((unsigned long)pci->pci.read, pci,
-					 EfiPciIoWidthUint16, PCI_VENDOR_ID,
-					 1, &(rom->vendor));
+		data = (struct setup_data *)rom;
+	}
 
-		if (status != EFI_SUCCESS)
-			goto free_struct;
+free_handle:
+	efi_early->call(efi_early->free_pool, pci_handle);
+	return status;
+}
 
-		status = efi_early->call((unsigned long)pci->pci.read, pci,
-					 EfiPciIoWidthUint16, PCI_DEVICE_ID,
-					 1, &(rom->devid));
+static efi_status_t
+__gop_query32(struct efi_graphics_output_protocol *__gop,
+	      struct efi_graphics_output_mode_info **info,
+	      unsigned long *size, u32 *fb_base, u32 *fb_size)
+{
+	struct efi_graphics_output_protocol_32 *gop;
+	struct efi_graphics_output_protocol_mode_32 *mode;
+	efi_status_t status;
+	unsigned long m;
 
-		if (status != EFI_SUCCESS)
-			goto free_struct;
+	gop = (struct efi_graphics_output_protocol_32 *)__gop;
 
-		status = efi_early->call((unsigned long)pci->get_location, pci,
-					 &(rom->segment), &(rom->bus),
-					 &(rom->device), &(rom->function));
+	m = gop->mode;
+	mode = (struct efi_graphics_output_protocol_mode_32 *)m;
 
-		if (status != EFI_SUCCESS)
-			goto free_struct;
+	status = efi_early->call(gop->query_mode, gop, mode->mode, size, info);
+	if (status != EFI_SUCCESS)
+		return status;
 
-		memcpy(rom->romdata, pci->romimage, pci->romsize);
+	*fb_base = mode->frame_buffer_base;
+	*fb_size = mode->frame_buffer_size;
+	return status;
+}
 
-		if (data)
-			data->next = (unsigned long)rom;
-		else
-			params->hdr.setup_data = (unsigned long)rom;
+static efi_status_t
+__gop_query64(struct efi_graphics_output_protocol *__gop,
+	      struct efi_graphics_output_mode_info **info,
+	      unsigned long *size, u32 *fb_base, u32 *fb_size)
+{
+	struct efi_graphics_output_protocol_64 *gop;
+	struct efi_graphics_output_protocol_mode_64 *mode;
+	efi_status_t status;
+	unsigned long m;
 
-		data = (struct setup_data *)rom;
+	gop = (struct efi_graphics_output_protocol_64 *)__gop;
 
-		continue;
-	free_struct:
-		efi_early->call(efi_early->free_pool, rom);
-	}
+	m = gop->mode;
+	mode = (struct efi_graphics_output_protocol_mode_64 *)m;
 
-free_handle:
-	efi_early->call(efi_early->free_pool, pci_handle);
+	status = efi_early->call(gop->query_mode, gop, mode->mode, size, info);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	*fb_base = mode->frame_buffer_base;
+	*fb_size = mode->frame_buffer_size;
 	return status;
 }
 
@@ -375,8 +620,13 @@ static efi_status_t setup_gop(struct screen_info *si, efi_guid_t *proto,
 		if (status == EFI_SUCCESS)
 			conout_found = true;
 
-		status = efi_early->call((unsigned long)gop->query_mode, gop,
-					 gop->mode->mode, &size, &info);
+		if (efi_early->is64)
+			status = __gop_query64(gop, &info, &size,
+					       &fb_base, &fb_size);
+		else
+			status = __gop_query32(gop, &info, &size,
+					       &fb_base, &fb_size);
+
 		if (status == EFI_SUCCESS && (!first_gop || conout_found)) {
 			/*
 			 * Systems that use the UEFI Console Splitter may
@@ -387,8 +637,6 @@ static efi_status_t setup_gop(struct screen_info *si, efi_guid_t *proto,
 			 */
 			width = info->horizontal_resolution;
 			height = info->vertical_resolution;
-			fb_base = gop->mode->frame_buffer_base;
-			fb_size = gop->mode->frame_buffer_size;
 			pixel_format = info->pixel_format;
 			pixel_info = info->pixel_information;
 			pixels_per_scan_line = info->pixels_per_scan_line;
-- 
1.8.3.1
