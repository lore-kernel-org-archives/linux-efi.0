From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: [PATCH 1/2] efi: Deduplicate efi_file_size() / _read() / _close()
Date: Mon, 7 Nov 2016 12:17:00 +0100
Message-ID: <4615f38e37a82f374bf4ff47331637443b357805.1478510356.git.lukas@wunner.de>
References: <cover.1478510356.git.lukas@wunner.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1478510356.git.lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

There's one ARM, one x86_32 and one x86_64 version which can be folded
into a single shared version by masking their differences with the shiny
new efi_call_proto() macro.

No functional change intended.

Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Signed-off-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
---
 arch/x86/boot/compressed/eboot.c               | 148 -------------------------
 drivers/firmware/efi/libstub/arm-stub.c        |  69 ------------
 drivers/firmware/efi/libstub/efi-stub-helper.c |  63 +++++++++++
 drivers/firmware/efi/libstub/efistub.h         |   8 --
 4 files changed, 63 insertions(+), 225 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index ff01c8f..f1cf284 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -38,154 +38,6 @@ static void setup_boot_services##bits(struct efi_config *c)		\
 BOOT_SERVICES(32);
 BOOT_SERVICES(64);
 
-void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
-
-static efi_status_t
-__file_size32(void *__fh, efi_char16_t *filename_16,
-	      void **handle, u64 *file_sz)
-{
-	efi_file_handle_32_t *h, *fh = __fh;
-	efi_file_info_t *info;
-	efi_status_t status;
-	efi_guid_t info_guid = EFI_FILE_INFO_ID;
-	u32 info_sz;
-
-	status = efi_early->call((unsigned long)fh->open, fh, &h, filename_16,
-				 EFI_FILE_MODE_READ, (u64)0);
-	if (status != EFI_SUCCESS) {
-		efi_printk(sys_table, "Failed to open file: ");
-		efi_char16_printk(sys_table, filename_16);
-		efi_printk(sys_table, "\n");
-		return status;
-	}
-
-	*handle = h;
-
-	info_sz = 0;
-	status = efi_early->call((unsigned long)h->get_info, h, &info_guid,
-				 &info_sz, NULL);
-	if (status != EFI_BUFFER_TOO_SMALL) {
-		efi_printk(sys_table, "Failed to get file info size\n");
-		return status;
-	}
-
-grow:
-	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
-				info_sz, (void **)&info);
-	if (status != EFI_SUCCESS) {
-		efi_printk(sys_table, "Failed to alloc mem for file info\n");
-		return status;
-	}
-
-	status = efi_early->call((unsigned long)h->get_info, h, &info_guid,
-				 &info_sz, info);
-	if (status == EFI_BUFFER_TOO_SMALL) {
-		efi_call_early(free_pool, info);
-		goto grow;
-	}
-
-	*file_sz = info->file_size;
-	efi_call_early(free_pool, info);
-
-	if (status != EFI_SUCCESS)
-		efi_printk(sys_table, "Failed to get initrd info\n");
-
-	return status;
-}
-
-static efi_status_t
-__file_size64(void *__fh, efi_char16_t *filename_16,
-	      void **handle, u64 *file_sz)
-{
-	efi_file_handle_64_t *h, *fh = __fh;
-	efi_file_info_t *info;
-	efi_status_t status;
-	efi_guid_t info_guid = EFI_FILE_INFO_ID;
-	u64 info_sz;
-
-	status = efi_early->call((unsigned long)fh->open, fh, &h, filename_16,
-				 EFI_FILE_MODE_READ, (u64)0);
-	if (status != EFI_SUCCESS) {
-		efi_printk(sys_table, "Failed to open file: ");
-		efi_char16_printk(sys_table, filename_16);
-		efi_printk(sys_table, "\n");
-		return status;
-	}
-
-	*handle = h;
-
-	info_sz = 0;
-	status = efi_early->call((unsigned long)h->get_info, h, &info_guid,
-				 &info_sz, NULL);
-	if (status != EFI_BUFFER_TOO_SMALL) {
-		efi_printk(sys_table, "Failed to get file info size\n");
-		return status;
-	}
-
-grow:
-	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
-				info_sz, (void **)&info);
-	if (status != EFI_SUCCESS) {
-		efi_printk(sys_table, "Failed to alloc mem for file info\n");
-		return status;
-	}
-
-	status = efi_early->call((unsigned long)h->get_info, h, &info_guid,
-				 &info_sz, info);
-	if (status == EFI_BUFFER_TOO_SMALL) {
-		efi_call_early(free_pool, info);
-		goto grow;
-	}
-
-	*file_sz = info->file_size;
-	efi_call_early(free_pool, info);
-
-	if (status != EFI_SUCCESS)
-		efi_printk(sys_table, "Failed to get initrd info\n");
-
-	return status;
-}
-efi_status_t
-efi_file_size(efi_system_table_t *sys_table, void *__fh,
-	      efi_char16_t *filename_16, void **handle, u64 *file_sz)
-{
-	if (efi_early->is64)
-		return __file_size64(__fh, filename_16, handle, file_sz);
-
-	return __file_size32(__fh, filename_16, handle, file_sz);
-}
-
-efi_status_t
-efi_file_read(void *handle, unsigned long *size, void *addr)
-{
-	unsigned long func;
-
-	if (efi_early->is64) {
-		efi_file_handle_64_t *fh = handle;
-
-		func = (unsigned long)fh->read;
-		return efi_early->call(func, handle, size, addr);
-	} else {
-		efi_file_handle_32_t *fh = handle;
-
-		func = (unsigned long)fh->read;
-		return efi_early->call(func, handle, size, addr);
-	}
-}
-
-efi_status_t efi_file_close(void *handle)
-{
-	if (efi_early->is64) {
-		efi_file_handle_64_t *fh = handle;
-
-		return efi_early->call((unsigned long)fh->close, handle);
-	} else {
-		efi_file_handle_32_t *fh = handle;
-
-		return efi_early->call((unsigned long)fh->close, handle);
-	}
-}
-
 static inline efi_status_t __open_volume32(void *__image, void **__fh)
 {
 	efi_file_io_interface_t *io;
diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index b4f7d78..6fca48c 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -91,75 +91,6 @@ efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg,
 	return status;
 }
 
-efi_status_t efi_file_close(void *handle)
-{
-	efi_file_handle_t *fh = handle;
-
-	return fh->close(handle);
-}
-
-efi_status_t
-efi_file_read(void *handle, unsigned long *size, void *addr)
-{
-	efi_file_handle_t *fh = handle;
-
-	return fh->read(handle, size, addr);
-}
-
-
-efi_status_t
-efi_file_size(efi_system_table_t *sys_table_arg, void *__fh,
-	      efi_char16_t *filename_16, void **handle, u64 *file_sz)
-{
-	efi_file_handle_t *h, *fh = __fh;
-	efi_file_info_t *info;
-	efi_status_t status;
-	efi_guid_t info_guid = EFI_FILE_INFO_ID;
-	unsigned long info_sz;
-
-	status = fh->open(fh, &h, filename_16, EFI_FILE_MODE_READ, (u64)0);
-	if (status != EFI_SUCCESS) {
-		efi_printk(sys_table_arg, "Failed to open file: ");
-		efi_char16_printk(sys_table_arg, filename_16);
-		efi_printk(sys_table_arg, "\n");
-		return status;
-	}
-
-	*handle = h;
-
-	info_sz = 0;
-	status = h->get_info(h, &info_guid, &info_sz, NULL);
-	if (status != EFI_BUFFER_TOO_SMALL) {
-		efi_printk(sys_table_arg, "Failed to get file info size\n");
-		return status;
-	}
-
-grow:
-	status = sys_table_arg->boottime->allocate_pool(EFI_LOADER_DATA,
-				 info_sz, (void **)&info);
-	if (status != EFI_SUCCESS) {
-		efi_printk(sys_table_arg, "Failed to alloc mem for file info\n");
-		return status;
-	}
-
-	status = h->get_info(h, &info_guid, &info_sz,
-						   info);
-	if (status == EFI_BUFFER_TOO_SMALL) {
-		sys_table_arg->boottime->free_pool(info);
-		goto grow;
-	}
-
-	*file_sz = info->file_size;
-	sys_table_arg->boottime->free_pool(info);
-
-	if (status != EFI_SUCCESS)
-		efi_printk(sys_table_arg, "Failed to get initrd info\n");
-
-	return status;
-}
-
-
-
 void efi_char16_printk(efi_system_table_t *sys_table_arg,
 			      efi_char16_t *str)
 {
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 757badc..6ee9164 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -338,6 +338,69 @@ void efi_free(efi_system_table_t *sys_table_arg, unsigned long size,
 	efi_call_early(free_pages, addr, nr_pages);
 }
 
+static efi_status_t efi_file_size(efi_system_table_t *sys_table_arg, void *__fh,
+				  efi_char16_t *filename_16, void **handle,
+				  u64 *file_sz)
+{
+	efi_file_handle_t *h, *fh = __fh;
+	efi_file_info_t *info;
+	efi_status_t status;
+	efi_guid_t info_guid = EFI_FILE_INFO_ID;
+	unsigned long info_sz;
+
+	status = efi_call_proto(efi_file_handle, open, fh, &h, filename_16,
+				EFI_FILE_MODE_READ, (u64)0);
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table_arg, "Failed to open file: ");
+		efi_char16_printk(sys_table_arg, filename_16);
+		efi_printk(sys_table_arg, "\n");
+		return status;
+	}
+
+	*handle = h;
+
+	info_sz = 0;
+	status = efi_call_proto(efi_file_handle, get_info, h, &info_guid,
+				&info_sz, NULL);
+	if (status != EFI_BUFFER_TOO_SMALL) {
+		efi_printk(sys_table_arg, "Failed to get file info size\n");
+		return status;
+	}
+
+grow:
+	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
+				info_sz, (void **)&info);
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table_arg, "Failed to alloc mem for file info\n");
+		return status;
+	}
+
+	status = efi_call_proto(efi_file_handle, get_info, h, &info_guid,
+				&info_sz, info);
+	if (status == EFI_BUFFER_TOO_SMALL) {
+		efi_call_early(free_pool, info);
+		goto grow;
+	}
+
+	*file_sz = info->file_size;
+	efi_call_early(free_pool, info);
+
+	if (status != EFI_SUCCESS)
+		efi_printk(sys_table_arg, "Failed to get initrd info\n");
+
+	return status;
+}
+
+static efi_status_t efi_file_read(void *handle, unsigned long *size, void *addr)
+{
+	return efi_call_proto(efi_file_handle, read, handle, size, addr);
+}
+
+static efi_status_t efi_file_close(void *handle)
+{
+	return efi_call_proto(efi_file_handle, close, handle);
+}
+
 /*
  * Parse the ASCII string 'cmdline' for EFI options, denoted by the efi=
  * option, e.g. efi=nochunk.
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index b98824e..2fe7746 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -29,14 +29,6 @@ void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
 efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg, void *__image,
 			     void **__fh);
 
-efi_status_t efi_file_size(efi_system_table_t *sys_table_arg, void *__fh,
-			   efi_char16_t *filename_16, void **handle,
-			   u64 *file_sz);
-
-efi_status_t efi_file_read(void *handle, unsigned long *size, void *addr);
-
-efi_status_t efi_file_close(void *handle);
-
 unsigned long get_dram_base(efi_system_table_t *sys_table_arg);
 
 efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
-- 
2.10.1
