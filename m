From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 1/9] efi/x86: prepare GOP handling code for reuse as generic code
Date: Fri,  1 Apr 2016 18:05:27 +0200
Message-ID: <1459526735-24936-2-git-send-email-ard.biesheuvel@linaro.org>
References: <1459526735-24936-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459526735-24936-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

In preparation of moving this code to drivers/firmware/efi and reusing
it on ARM and arm64, apply any changes that will be required to make this
code build for other architectures. This should make it easier to track
down problems that this move may cause to its operation on x86.

Note that the generic version uses slightly different ways of casting the
protocol methods and some other variables to the correct types, since such
method calls are not loosely typed on ARM and arm64 as they are on x86.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/x86/boot/compressed/eboot.c | 58 ++++++++++++--------
 arch/x86/boot/compressed/eboot.h |  4 ++
 arch/x86/include/asm/efi.h       |  5 ++
 include/linux/efi.h              |  5 ++
 4 files changed, 49 insertions(+), 23 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 583d539a4197..10516e22fdcb 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -622,19 +622,22 @@ setup_pixel_info(struct screen_info *si, u32 pixels_per_scan_line,
 }
 
 static efi_status_t
-__gop_query32(struct efi_graphics_output_protocol_32 *gop32,
+__gop_query32(efi_system_table_t *sys_table_arg,
+	      struct efi_graphics_output_protocol_32 *gop32,
 	      struct efi_graphics_output_mode_info **info,
 	      unsigned long *size, u64 *fb_base)
 {
 	struct efi_graphics_output_protocol_mode_32 *mode;
+	efi_graphics_output_protocol_query_mode query_mode;
 	efi_status_t status;
 	unsigned long m;
 
 	m = gop32->mode;
 	mode = (struct efi_graphics_output_protocol_mode_32 *)m;
+	query_mode = (void *)(unsigned long)gop32->query_mode;
 
-	status = efi_early->call(gop32->query_mode, gop32,
-				 mode->mode, size, info);
+	status = __efi_call_early(query_mode, (void *)gop32, mode->mode, size,
+				  info);
 	if (status != EFI_SUCCESS)
 		return status;
 
@@ -643,8 +646,8 @@ __gop_query32(struct efi_graphics_output_protocol_32 *gop32,
 }
 
 static efi_status_t
-setup_gop32(struct screen_info *si, efi_guid_t *proto,
-	    unsigned long size, void **gop_handle)
+setup_gop32(efi_system_table_t *sys_table_arg, struct screen_info *si,
+            efi_guid_t *proto, unsigned long size, void **gop_handle)
 {
 	struct efi_graphics_output_protocol_32 *gop32, *first_gop;
 	unsigned long nr_gops;
@@ -654,7 +657,7 @@ setup_gop32(struct screen_info *si, efi_guid_t *proto,
 	u64 fb_base;
 	struct efi_pixel_bitmask pixel_info;
 	int pixel_format;
-	efi_status_t status;
+	efi_status_t status = EFI_NOT_FOUND;
 	u32 *handles = (u32 *)(unsigned long)gop_handle;
 	int i;
 
@@ -667,7 +670,7 @@ setup_gop32(struct screen_info *si, efi_guid_t *proto,
 		efi_guid_t conout_proto = EFI_CONSOLE_OUT_DEVICE_GUID;
 		bool conout_found = false;
 		void *dummy = NULL;
-		u32 h = handles[i];
+		efi_handle_t h = (efi_handle_t)(unsigned long)handles[i];
 		u64 current_fb_base;
 
 		status = efi_call_early(handle_protocol, h,
@@ -680,7 +683,8 @@ setup_gop32(struct screen_info *si, efi_guid_t *proto,
 		if (status == EFI_SUCCESS)
 			conout_found = true;
 
-		status = __gop_query32(gop32, &info, &size, &current_fb_base);
+		status = __gop_query32(sys_table_arg, gop32, &info, &size,
+				       &current_fb_base);
 		if (status == EFI_SUCCESS && (!first_gop || conout_found)) {
 			/*
 			 * Systems that use the UEFI Console Splitter may
@@ -735,19 +739,22 @@ out:
 }
 
 static efi_status_t
-__gop_query64(struct efi_graphics_output_protocol_64 *gop64,
+__gop_query64(efi_system_table_t *sys_table_arg,
+	      struct efi_graphics_output_protocol_64 *gop64,
 	      struct efi_graphics_output_mode_info **info,
 	      unsigned long *size, u64 *fb_base)
 {
 	struct efi_graphics_output_protocol_mode_64 *mode;
+	efi_graphics_output_protocol_query_mode query_mode;
 	efi_status_t status;
 	unsigned long m;
 
 	m = gop64->mode;
 	mode = (struct efi_graphics_output_protocol_mode_64 *)m;
+	query_mode = (void *)(unsigned long)gop64->query_mode;
 
-	status = efi_early->call(gop64->query_mode, gop64,
-				 mode->mode, size, info);
+	status = __efi_call_early(query_mode, (void *)gop64, mode->mode, size,
+				  info);
 	if (status != EFI_SUCCESS)
 		return status;
 
@@ -756,8 +763,8 @@ __gop_query64(struct efi_graphics_output_protocol_64 *gop64,
 }
 
 static efi_status_t
-setup_gop64(struct screen_info *si, efi_guid_t *proto,
-	    unsigned long size, void **gop_handle)
+setup_gop64(efi_system_table_t *sys_table_arg, struct screen_info *si,
+	    efi_guid_t *proto, unsigned long size, void **gop_handle)
 {
 	struct efi_graphics_output_protocol_64 *gop64, *first_gop;
 	unsigned long nr_gops;
@@ -767,7 +774,7 @@ setup_gop64(struct screen_info *si, efi_guid_t *proto,
 	u64 fb_base;
 	struct efi_pixel_bitmask pixel_info;
 	int pixel_format;
-	efi_status_t status;
+	efi_status_t status = EFI_NOT_FOUND;
 	u64 *handles = (u64 *)(unsigned long)gop_handle;
 	int i;
 
@@ -780,7 +787,7 @@ setup_gop64(struct screen_info *si, efi_guid_t *proto,
 		efi_guid_t conout_proto = EFI_CONSOLE_OUT_DEVICE_GUID;
 		bool conout_found = false;
 		void *dummy = NULL;
-		u64 h = handles[i];
+		efi_handle_t h = (efi_handle_t)(unsigned long)handles[i];
 		u64 current_fb_base;
 
 		status = efi_call_early(handle_protocol, h,
@@ -793,7 +800,8 @@ setup_gop64(struct screen_info *si, efi_guid_t *proto,
 		if (status == EFI_SUCCESS)
 			conout_found = true;
 
-		status = __gop_query64(gop64, &info, &size, &current_fb_base);
+		status = __gop_query64(sys_table_arg, gop64, &info, &size,
+				       &current_fb_base);
 		if (status == EFI_SUCCESS && (!first_gop || conout_found)) {
 			/*
 			 * Systems that use the UEFI Console Splitter may
@@ -850,8 +858,9 @@ out:
 /*
  * See if we have Graphics Output Protocol
  */
-static efi_status_t setup_gop(struct screen_info *si, efi_guid_t *proto,
-			      unsigned long size)
+efi_status_t efi_setup_gop(efi_system_table_t *sys_table_arg,
+			   struct screen_info *si, efi_guid_t *proto,
+			   unsigned long size)
 {
 	efi_status_t status;
 	void **gop_handle = NULL;
@@ -867,10 +876,13 @@ static efi_status_t setup_gop(struct screen_info *si, efi_guid_t *proto,
 	if (status != EFI_SUCCESS)
 		goto free_handle;
 
-	if (efi_early->is64)
-		status = setup_gop64(si, proto, size, gop_handle);
-	else
-		status = setup_gop32(si, proto, size, gop_handle);
+	if (efi_is_64bit()) {
+		status = setup_gop64(sys_table_arg, si, proto, size,
+				     gop_handle);
+	} else {
+		status = setup_gop32(sys_table_arg, si, proto, size,
+				     gop_handle);
+	}
 
 free_handle:
 	efi_call_early(free_pool, gop_handle);
@@ -1038,7 +1050,7 @@ void setup_graphics(struct boot_params *boot_params)
 				EFI_LOCATE_BY_PROTOCOL,
 				&graphics_proto, NULL, &size, gop_handle);
 	if (status == EFI_BUFFER_TOO_SMALL)
-		status = setup_gop(si, &graphics_proto, size);
+		status = efi_setup_gop(NULL, si, &graphics_proto, size);
 
 	if (status != EFI_SUCCESS) {
 		size = 0;
diff --git a/arch/x86/boot/compressed/eboot.h b/arch/x86/boot/compressed/eboot.h
index d487e727f1ec..4ee5318d7f28 100644
--- a/arch/x86/boot/compressed/eboot.h
+++ b/arch/x86/boot/compressed/eboot.h
@@ -85,6 +85,10 @@ struct efi_graphics_output_protocol {
 	struct efi_graphics_output_protocol_mode *mode;
 };
 
+typedef efi_status_t (*efi_graphics_output_protocol_query_mode)(
+	struct efi_graphics_output_protocol *, u32, unsigned long *,
+	struct efi_graphics_output_mode_info **);
+
 struct efi_uga_draw_protocol_32 {
 	u32 get_mode;
 	u32 set_mode;
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 53748c45e488..10e440770371 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -225,6 +225,11 @@ __pure const struct efi_config *__efi_early(void);
 #define efi_call_early(f, ...)						\
 	__efi_early()->call(__efi_early()->f, __VA_ARGS__);
 
+#define __efi_call_early(f, ...)					\
+	__efi_early()->call((unsigned long)f, __VA_ARGS__);
+
+#define efi_is_64bit()		__efi_early()->is64
+
 extern bool efi_reboot_required(void);
 
 #else
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 1545098b0565..f6e7724451ca 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -21,6 +21,7 @@
 #include <linux/pfn.h>
 #include <linux/pstore.h>
 #include <linux/reboot.h>
+#include <linux/screen_info.h>
 
 #include <asm/page.h>
 
@@ -1318,5 +1319,9 @@ efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 
 efi_status_t efi_parse_options(char *cmdline);
 
+efi_status_t efi_setup_gop(efi_system_table_t *sys_table_arg,
+			   struct screen_info *si, efi_guid_t *proto,
+			   unsigned long size);
+
 bool efi_runtime_disabled(void);
 #endif /* _LINUX_EFI_H */
-- 
2.5.0
