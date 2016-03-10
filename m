From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 6/8] efi/arm*: libstub: wire up GOP handling into the ARM UEFI stub
Date: Thu, 10 Mar 2016 12:40:06 +0700
Message-ID: <1457588408-19309-7-git-send-email-ard.biesheuvel@linaro.org>
References: <1457588408-19309-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457588408-19309-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This enables the EFI stub side of handling the EFI Graphics Output
Protocol. It involves invoking the generic GOP code to discover the GOP
handle that also drives the console, and using its metadata to populate
the screen_info structure.

For arm64, the stub and the kernel proper live in the same executable, so
we can simply access screen_info directly.

For ARM, we need to allocate a struct screen_info in the stub, and install
it as a configuration table so that the core kernel can go and fetch it to
copy its contents into the real screen_info structure.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm/include/asm/efi.h                | 12 +++++++
 arch/arm/kernel/setup.c                   |  3 +-
 arch/arm64/include/asm/efi.h              |  3 ++
 arch/arm64/kernel/efi.c                   |  3 ++
 arch/arm64/kernel/image.h                 |  1 +
 drivers/firmware/efi/libstub/arm-stub.c   | 23 ++++++++++++
 drivers/firmware/efi/libstub/arm32-stub.c | 38 ++++++++++++++++++++
 7 files changed, 82 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/efi.h b/arch/arm/include/asm/efi.h
index daebcfe6c35a..6329b5be1eca 100644
--- a/arch/arm/include/asm/efi.h
+++ b/arch/arm/include/asm/efi.h
@@ -63,6 +63,18 @@ void efi_virtmap_unload(void);
 #define __efi_call_early(f, ...)	f(__VA_ARGS__)
 #define efi_is_64bit()			(0)
 
+struct screen_info *alloc_screen_info(efi_system_table_t *sys_table_arg);
+void free_screen_info(efi_system_table_t *sys_table, struct screen_info *si);
+
+/*
+ * This GUID is used to pass to the kernel proper the struct screen_info
+ * structure that was populated by the stub based on the GOP protocol instance
+ * associated with ConOut
+ */
+#define LINUX_ARM32_SCREEN_INFO_TABLE_GUID \
+	EFI_GUID(0xe03fc20a, 0x85dc, 0x406e, \
+		 0xb9, 0xe, 0x4a, 0xb5, 0x02, 0x37, 0x1d, 0x95)
+
 /*
  * A reasonable upper bound for the uncompressed kernel size is 32 MBytes,
  * so we will reserve that amount of memory. We have no easy way to tell what
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 7d0cba6f1cc5..149a7787b40f 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -881,7 +881,8 @@ static void __init request_standard_resources(const struct machine_desc *mdesc)
 		request_resource(&ioport_resource, &lp2);
 }
 
-#if defined(CONFIG_VGA_CONSOLE) || defined(CONFIG_DUMMY_CONSOLE)
+#if defined(CONFIG_VGA_CONSOLE) || defined(CONFIG_DUMMY_CONSOLE) || \
+    defined(CONFIG_EFI)
 struct screen_info screen_info = {
  .orig_video_lines	= 30,
  .orig_video_cols	= 80,
diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index e3d707131bba..a6c14f29b970 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -54,6 +54,9 @@ int efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md);
 #define __efi_call_early(f, ...)	f(__VA_ARGS__)
 #define efi_is_64bit()			(1)
 
+#define alloc_screen_info(x...)		&screen_info
+#define free_screen_info(x...)
+
 #define EFI_ALLOC_ALIGN		SZ_64K
 
 /*
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index b6abc852f2a1..6f4b3ea359db 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -17,6 +17,9 @@
 
 #include <asm/efi.h>
 
+/* we will fill this structure from the stub, so don't put it in .bss */
+struct screen_info screen_info __section(.data);
+
 int __init efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md)
 {
 	pteval_t prot_val;
diff --git a/arch/arm64/kernel/image.h b/arch/arm64/kernel/image.h
index 5ff892f40a0a..fa52ebdfc93e 100644
--- a/arch/arm64/kernel/image.h
+++ b/arch/arm64/kernel/image.h
@@ -115,6 +115,7 @@ __efistub___memset		= KALLSYMS_HIDE(__pi_memset);
 __efistub__text			= KALLSYMS_HIDE(_text);
 __efistub__end			= KALLSYMS_HIDE(_end);
 __efistub__edata		= KALLSYMS_HIDE(_edata);
+__efistub_screen_info		= KALLSYMS_HIDE(screen_info);
 
 #endif
 
diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 4deb3e7faa0e..94bd51cfb71e 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -147,6 +147,25 @@ void efi_char16_printk(efi_system_table_t *sys_table_arg,
 	out->output_string(out, str);
 }
 
+static struct screen_info *setup_graphics(efi_system_table_t *sys_table_arg)
+{
+	efi_guid_t gop_proto = EFI_GRAPHICS_OUTPUT_PROTOCOL_GUID;
+	efi_status_t status;
+	unsigned long size;
+	void **gop_handle = NULL;
+	struct screen_info *si = NULL;
+
+	size = 0;
+	status = efi_call_early(locate_handle, EFI_LOCATE_BY_PROTOCOL,
+				&gop_proto, NULL, &size, gop_handle);
+	if (status == EFI_BUFFER_TOO_SMALL) {
+		si = alloc_screen_info(sys_table_arg);
+		if (!si)
+			return NULL;
+		efi_setup_gop(sys_table_arg, si, &gop_proto, size);
+	}
+	return si;
+}
 
 /*
  * This function handles the architcture specific differences between arm and
@@ -185,6 +204,7 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 	efi_guid_t loaded_image_proto = LOADED_IMAGE_PROTOCOL_GUID;
 	unsigned long reserve_addr = 0;
 	unsigned long reserve_size = 0;
+	struct screen_info *si;
 
 	/* Check if we were booted by the EFI firmware */
 	if (sys_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
@@ -233,6 +253,8 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
 			__nokaslr = true;
 	}
 
+	si = setup_graphics(sys_table);
+
 	status = handle_kernel_image(sys_table, image_addr, &image_size,
 				     &reserve_addr,
 				     &reserve_size,
@@ -305,6 +327,7 @@ fail_free_image:
 	efi_free(sys_table, image_size, *image_addr);
 	efi_free(sys_table, reserve_size, reserve_addr);
 fail_free_cmdline:
+	free_screen_info(sys_table, si);
 	efi_free(sys_table, cmdline_size, (unsigned long)cmdline_ptr);
 fail:
 	return EFI_ERROR;
diff --git a/drivers/firmware/efi/libstub/arm32-stub.c b/drivers/firmware/efi/libstub/arm32-stub.c
index 495ebd657e38..0fbe00f13186 100644
--- a/drivers/firmware/efi/libstub/arm32-stub.c
+++ b/drivers/firmware/efi/libstub/arm32-stub.c
@@ -9,6 +9,44 @@
 #include <linux/efi.h>
 #include <asm/efi.h>
 
+static const efi_guid_t screen_info_guid = LINUX_ARM32_SCREEN_INFO_TABLE_GUID;
+
+struct screen_info *alloc_screen_info(efi_system_table_t *sys_table_arg)
+{
+	struct screen_info *si;
+	efi_status_t status;
+
+	/*
+	 * Unlike on arm64, where we can directly fill out the screen_info
+	 * structure from the stub, we need to allocate a buffer to hold
+	 * its contents while we hand over to the kernel proper from the
+	 * decompressor.
+	 */
+	status = efi_call_early(allocate_pool, EFI_RUNTIME_SERVICES_DATA,
+				sizeof(*si), (void **)&si);
+
+	if (status != EFI_SUCCESS)
+		return NULL;
+
+	status = efi_call_early(install_configuration_table,
+				(efi_guid_t *)&screen_info_guid, si);
+	if (status == EFI_SUCCESS)
+		return si;
+
+	efi_call_early(free_pool, si);
+	return NULL;
+}
+
+void free_screen_info(efi_system_table_t *sys_table_arg, struct screen_info *si)
+{
+	if (!si)
+		return;
+
+	efi_call_early(install_configuration_table,
+		       (efi_guid_t *)&screen_info_guid, NULL);
+	efi_call_early(free_pool, si);
+}
+
 efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
 				 unsigned long *image_addr,
 				 unsigned long *image_size,
-- 
1.9.1
