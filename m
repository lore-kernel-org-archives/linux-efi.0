From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 6/9] efi: Deduplicate efi_open_volume()
Date: Fri, 20 Jul 2018 10:47:23 +0900
Message-ID: <20180720014726.24031-7-ard.biesheuvel@linaro.org>
References: <20180720014726.24031-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180720014726.24031-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Hans de Goede <hdegoede@redhat.com>, Lukas Wunner <lukas@wunner.de>
List-Id: linux-efi@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

There's one ARM, one x86_32 and one x86_64 version of efi_open_volume()
which can be folded into a single shared version by masking their
differences with the efi_call_proto() macro introduced by commit

  3552fdf29f01 ("efi: Allow bitness-agnostic protocol calls").

To be able to dereference the device_handle attribute from the
efi_loaded_image_t table in an arch- and bitness-agnostic manner,
introduce the efi_table_attr() macro (which already exists for x86)
to arm and arm64.

No functional change intended.

Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/include/asm/efi.h                    |  3 +
 arch/arm64/include/asm/efi.h                  |  3 +
 arch/x86/boot/compressed/eboot.c              | 63 -------------------
 drivers/firmware/efi/libstub/arm-stub.c       | 25 --------
 .../firmware/efi/libstub/efi-stub-helper.c    | 31 ++++++++-
 drivers/firmware/efi/libstub/efistub.h        |  3 -
 include/linux/efi.h                           | 10 +++
 7 files changed, 45 insertions(+), 93 deletions(-)

diff --git a/arch/arm/include/asm/efi.h b/arch/arm/include/asm/efi.h
index 17f1f1a814ff..38badaae8d9d 100644
--- a/arch/arm/include/asm/efi.h
+++ b/arch/arm/include/asm/efi.h
@@ -58,6 +58,9 @@ void efi_virtmap_unload(void);
 #define efi_call_runtime(f, ...)	sys_table_arg->runtime->f(__VA_ARGS__)
 #define efi_is_64bit()			(false)
 
+#define efi_table_attr(table, attr, instance)				\
+	((table##_t *)instance)->attr
+
 #define efi_call_proto(protocol, f, instance, ...)			\
 	((protocol##_t *)instance)->f(instance, ##__VA_ARGS__)
 
diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index 192d791f1103..7ed320895d1f 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -87,6 +87,9 @@ static inline unsigned long efi_get_max_initrd_addr(unsigned long dram_base,
 #define efi_call_runtime(f, ...)	sys_table_arg->runtime->f(__VA_ARGS__)
 #define efi_is_64bit()			(true)
 
+#define efi_table_attr(table, attr, instance)				\
+	((table##_t *)instance)->attr
+
 #define efi_call_proto(protocol, f, instance, ...)			\
 	((protocol##_t *)instance)->f(instance, ##__VA_ARGS__)
 
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 92b573fd239c..915c64edbe8e 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -41,69 +41,6 @@ static void setup_boot_services##bits(struct efi_config *c)		\
 BOOT_SERVICES(32);
 BOOT_SERVICES(64);
 
-static inline efi_status_t __open_volume32(void *__image, void **__fh)
-{
-	efi_file_io_interface_t *io;
-	efi_loaded_image_32_t *image = __image;
-	efi_file_handle_32_t *fh;
-	efi_guid_t fs_proto = EFI_FILE_SYSTEM_GUID;
-	efi_status_t status;
-	void *handle = (void *)(unsigned long)image->device_handle;
-	unsigned long func;
-
-	status = efi_call_early(handle_protocol, handle,
-				&fs_proto, (void **)&io);
-	if (status != EFI_SUCCESS) {
-		efi_printk(sys_table, "Failed to handle fs_proto\n");
-		return status;
-	}
-
-	func = (unsigned long)io->open_volume;
-	status = efi_early->call(func, io, &fh);
-	if (status != EFI_SUCCESS)
-		efi_printk(sys_table, "Failed to open volume\n");
-
-	*__fh = fh;
-
-	return status;
-}
-
-static inline efi_status_t __open_volume64(void *__image, void **__fh)
-{
-	efi_file_io_interface_t *io;
-	efi_loaded_image_64_t *image = __image;
-	efi_file_handle_64_t *fh;
-	efi_guid_t fs_proto = EFI_FILE_SYSTEM_GUID;
-	efi_status_t status;
-	void *handle = (void *)(unsigned long)image->device_handle;
-	unsigned long func;
-
-	status = efi_call_early(handle_protocol, handle,
-				&fs_proto, (void **)&io);
-	if (status != EFI_SUCCESS) {
-		efi_printk(sys_table, "Failed to handle fs_proto\n");
-		return status;
-	}
-
-	func = (unsigned long)io->open_volume;
-	status = efi_early->call(func, io, &fh);
-	if (status != EFI_SUCCESS)
-		efi_printk(sys_table, "Failed to open volume\n");
-
-	*__fh = fh;
-
-	return status;
-}
-
-efi_status_t
-efi_open_volume(efi_system_table_t *sys_table, void *__image, void **__fh)
-{
-	if (efi_early->is64)
-		return __open_volume64(__image, __fh);
-
-	return __open_volume32(__image, __fh);
-}
-
 void efi_char16_printk(efi_system_table_t *table, efi_char16_t *str)
 {
 	efi_call_proto(efi_simple_text_output_protocol, output_string,
diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index c98b1856fc3d..6920033de6d4 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -40,31 +40,6 @@
 
 static u64 virtmap_base = EFI_RT_VIRTUAL_BASE;
 
-efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg,
-			     void *__image, void **__fh)
-{
-	efi_file_io_interface_t *io;
-	efi_loaded_image_t *image = __image;
-	efi_file_handle_t *fh;
-	efi_guid_t fs_proto = EFI_FILE_SYSTEM_GUID;
-	efi_status_t status;
-	void *handle = (void *)(unsigned long)image->device_handle;
-
-	status = sys_table_arg->boottime->handle_protocol(handle,
-				 &fs_proto, (void **)&io);
-	if (status != EFI_SUCCESS) {
-		efi_printk(sys_table_arg, "Failed to handle fs_proto\n");
-		return status;
-	}
-
-	status = io->open_volume(io, &fh);
-	if (status != EFI_SUCCESS)
-		efi_printk(sys_table_arg, "Failed to open volume\n");
-
-	*__fh = fh;
-	return status;
-}
-
 void efi_char16_printk(efi_system_table_t *sys_table_arg,
 			      efi_char16_t *str)
 {
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 50a9cab5a834..e94975f4655b 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -413,6 +413,34 @@ static efi_status_t efi_file_close(void *handle)
 	return efi_call_proto(efi_file_handle, close, handle);
 }
 
+static efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg,
+				    efi_loaded_image_t *image,
+				    efi_file_handle_t **__fh)
+{
+	efi_file_io_interface_t *io;
+	efi_file_handle_t *fh;
+	efi_guid_t fs_proto = EFI_FILE_SYSTEM_GUID;
+	efi_status_t status;
+	void *handle = (void *)(unsigned long)efi_table_attr(efi_loaded_image,
+							     device_handle,
+							     image);
+
+	status = efi_call_early(handle_protocol, handle,
+				&fs_proto, (void **)&io);
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table_arg, "Failed to handle fs_proto\n");
+		return status;
+	}
+
+	status = efi_call_proto(efi_file_io_interface, open_volume, io, &fh);
+	if (status != EFI_SUCCESS)
+		efi_printk(sys_table_arg, "Failed to open volume\n");
+	else
+		*__fh = fh;
+
+	return status;
+}
+
 /*
  * Parse the ASCII string 'cmdline' for EFI options, denoted by the efi=
  * option, e.g. efi=nochunk.
@@ -563,8 +591,7 @@ efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 
 		/* Only open the volume once. */
 		if (!i) {
-			status = efi_open_volume(sys_table_arg, image,
-						 (void **)&fh);
+			status = efi_open_volume(sys_table_arg, image, &fh);
 			if (status != EFI_SUCCESS)
 				goto free_files;
 		}
diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index f59564b72ddc..32799cf039ef 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -36,9 +36,6 @@ extern int __pure is_quiet(void);
 
 void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
 
-efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg, void *__image,
-			     void **__fh);
-
 unsigned long get_dram_base(efi_system_table_t *sys_table_arg);
 
 efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
diff --git a/include/linux/efi.h b/include/linux/efi.h
index e190652f5ef9..401e4b254e30 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -894,6 +894,16 @@ typedef struct _efi_file_handle {
 	void *flush;
 } efi_file_handle_t;
 
+typedef struct {
+	u64 revision;
+	u32 open_volume;
+} efi_file_io_interface_32_t;
+
+typedef struct {
+	u64 revision;
+	u64 open_volume;
+} efi_file_io_interface_64_t;
+
 typedef struct _efi_file_io_interface {
 	u64 revision;
 	int (*open_volume)(struct _efi_file_io_interface *,
-- 
2.17.1
