From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3 2/9] efi: libstub: move Graphics Output Protocol handling to generic code
Date: Fri,  1 Apr 2016 18:05:28 +0200
Message-ID: <1459526735-24936-3-git-send-email-ard.biesheuvel@linaro.org>
References: <1459526735-24936-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459526735-24936-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, dh.herrmann-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The Graphics Output Protocol code executes in the stub, so create a generic
version based on the x86 version in libstub so that we can move other archs
to it in subsequent patches. The new source file gop.c is added to the
libstub build for all architectures, but only wired up for x86.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 arch/arm/include/asm/efi.h            |   4 +-
 arch/arm64/include/asm/efi.h          |   4 +-
 arch/x86/boot/compressed/eboot.c      | 318 ------------------
 arch/x86/boot/compressed/eboot.h      |  78 -----
 drivers/firmware/efi/libstub/Makefile |   2 +-
 drivers/firmware/efi/libstub/gop.c    | 354 ++++++++++++++++++++
 include/linux/efi.h                   |  81 ++++-
 7 files changed, 441 insertions(+), 400 deletions(-)

diff --git a/arch/arm/include/asm/efi.h b/arch/arm/include/asm/efi.h
index e0eea72deb87..ce1aa3454ca8 100644
--- a/arch/arm/include/asm/efi.h
+++ b/arch/arm/include/asm/efi.h
@@ -59,7 +59,9 @@ void efi_virtmap_unload(void);
 
 /* arch specific definitions used by the stub code */
 
-#define efi_call_early(f, ...) sys_table_arg->boottime->f(__VA_ARGS__)
+#define efi_call_early(f, ...)		sys_table_arg->boottime->f(__VA_ARGS__)
+#define __efi_call_early(f, ...)	f(__VA_ARGS__)
+#define efi_is_64bit()			(false)
 
 /*
  * A reasonable upper bound for the uncompressed kernel size is 32 MBytes,
diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
index 8e88a696c9cb..bb26f2205973 100644
--- a/arch/arm64/include/asm/efi.h
+++ b/arch/arm64/include/asm/efi.h
@@ -50,7 +50,9 @@ int efi_create_mapping(struct mm_struct *mm, efi_memory_desc_t *md);
 #define EFI_FDT_ALIGN	SZ_2M   /* used by allocate_new_fdt_and_exit_boot() */
 #define MAX_FDT_OFFSET	SZ_512M
 
-#define efi_call_early(f, ...) sys_table_arg->boottime->f(__VA_ARGS__)
+#define efi_call_early(f, ...)		sys_table_arg->boottime->f(__VA_ARGS__)
+#define __efi_call_early(f, ...)	f(__VA_ARGS__)
+#define efi_is_64bit()			(true)
 
 #define EFI_ALLOC_ALIGN		SZ_64K
 
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 10516e22fdcb..52fef606bc54 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -571,324 +571,6 @@ free_handle:
 	efi_call_early(free_pool, pci_handle);
 }
 
-static void
-setup_pixel_info(struct screen_info *si, u32 pixels_per_scan_line,
-		 struct efi_pixel_bitmask pixel_info, int pixel_format)
-{
-	if (pixel_format == PIXEL_RGB_RESERVED_8BIT_PER_COLOR) {
-		si->lfb_depth = 32;
-		si->lfb_linelength = pixels_per_scan_line * 4;
-		si->red_size = 8;
-		si->red_pos = 0;
-		si->green_size = 8;
-		si->green_pos = 8;
-		si->blue_size = 8;
-		si->blue_pos = 16;
-		si->rsvd_size = 8;
-		si->rsvd_pos = 24;
-	} else if (pixel_format == PIXEL_BGR_RESERVED_8BIT_PER_COLOR) {
-		si->lfb_depth = 32;
-		si->lfb_linelength = pixels_per_scan_line * 4;
-		si->red_size = 8;
-		si->red_pos = 16;
-		si->green_size = 8;
-		si->green_pos = 8;
-		si->blue_size = 8;
-		si->blue_pos = 0;
-		si->rsvd_size = 8;
-		si->rsvd_pos = 24;
-	} else if (pixel_format == PIXEL_BIT_MASK) {
-		find_bits(pixel_info.red_mask, &si->red_pos, &si->red_size);
-		find_bits(pixel_info.green_mask, &si->green_pos,
-			  &si->green_size);
-		find_bits(pixel_info.blue_mask, &si->blue_pos, &si->blue_size);
-		find_bits(pixel_info.reserved_mask, &si->rsvd_pos,
-			  &si->rsvd_size);
-		si->lfb_depth = si->red_size + si->green_size +
-			si->blue_size + si->rsvd_size;
-		si->lfb_linelength = (pixels_per_scan_line * si->lfb_depth) / 8;
-	} else {
-		si->lfb_depth = 4;
-		si->lfb_linelength = si->lfb_width / 2;
-		si->red_size = 0;
-		si->red_pos = 0;
-		si->green_size = 0;
-		si->green_pos = 0;
-		si->blue_size = 0;
-		si->blue_pos = 0;
-		si->rsvd_size = 0;
-		si->rsvd_pos = 0;
-	}
-}
-
-static efi_status_t
-__gop_query32(efi_system_table_t *sys_table_arg,
-	      struct efi_graphics_output_protocol_32 *gop32,
-	      struct efi_graphics_output_mode_info **info,
-	      unsigned long *size, u64 *fb_base)
-{
-	struct efi_graphics_output_protocol_mode_32 *mode;
-	efi_graphics_output_protocol_query_mode query_mode;
-	efi_status_t status;
-	unsigned long m;
-
-	m = gop32->mode;
-	mode = (struct efi_graphics_output_protocol_mode_32 *)m;
-	query_mode = (void *)(unsigned long)gop32->query_mode;
-
-	status = __efi_call_early(query_mode, (void *)gop32, mode->mode, size,
-				  info);
-	if (status != EFI_SUCCESS)
-		return status;
-
-	*fb_base = mode->frame_buffer_base;
-	return status;
-}
-
-static efi_status_t
-setup_gop32(efi_system_table_t *sys_table_arg, struct screen_info *si,
-            efi_guid_t *proto, unsigned long size, void **gop_handle)
-{
-	struct efi_graphics_output_protocol_32 *gop32, *first_gop;
-	unsigned long nr_gops;
-	u16 width, height;
-	u32 pixels_per_scan_line;
-	u32 ext_lfb_base;
-	u64 fb_base;
-	struct efi_pixel_bitmask pixel_info;
-	int pixel_format;
-	efi_status_t status = EFI_NOT_FOUND;
-	u32 *handles = (u32 *)(unsigned long)gop_handle;
-	int i;
-
-	first_gop = NULL;
-	gop32 = NULL;
-
-	nr_gops = size / sizeof(u32);
-	for (i = 0; i < nr_gops; i++) {
-		struct efi_graphics_output_mode_info *info = NULL;
-		efi_guid_t conout_proto = EFI_CONSOLE_OUT_DEVICE_GUID;
-		bool conout_found = false;
-		void *dummy = NULL;
-		efi_handle_t h = (efi_handle_t)(unsigned long)handles[i];
-		u64 current_fb_base;
-
-		status = efi_call_early(handle_protocol, h,
-					proto, (void **)&gop32);
-		if (status != EFI_SUCCESS)
-			continue;
-
-		status = efi_call_early(handle_protocol, h,
-					&conout_proto, &dummy);
-		if (status == EFI_SUCCESS)
-			conout_found = true;
-
-		status = __gop_query32(sys_table_arg, gop32, &info, &size,
-				       &current_fb_base);
-		if (status == EFI_SUCCESS && (!first_gop || conout_found)) {
-			/*
-			 * Systems that use the UEFI Console Splitter may
-			 * provide multiple GOP devices, not all of which are
-			 * backed by real hardware. The workaround is to search
-			 * for a GOP implementing the ConOut protocol, and if
-			 * one isn't found, to just fall back to the first GOP.
-			 */
-			width = info->horizontal_resolution;
-			height = info->vertical_resolution;
-			pixel_format = info->pixel_format;
-			pixel_info = info->pixel_information;
-			pixels_per_scan_line = info->pixels_per_scan_line;
-			fb_base = current_fb_base;
-
-			/*
-			 * Once we've found a GOP supporting ConOut,
-			 * don't bother looking any further.
-			 */
-			first_gop = gop32;
-			if (conout_found)
-				break;
-		}
-	}
-
-	/* Did we find any GOPs? */
-	if (!first_gop)
-		goto out;
-
-	/* EFI framebuffer */
-	si->orig_video_isVGA = VIDEO_TYPE_EFI;
-
-	si->lfb_width = width;
-	si->lfb_height = height;
-	si->lfb_base = fb_base;
-
-	ext_lfb_base = (u64)(unsigned long)fb_base >> 32;
-	if (ext_lfb_base) {
-		si->capabilities |= VIDEO_CAPABILITY_64BIT_BASE;
-		si->ext_lfb_base = ext_lfb_base;
-	}
-
-	si->pages = 1;
-
-	setup_pixel_info(si, pixels_per_scan_line, pixel_info, pixel_format);
-
-	si->lfb_size = si->lfb_linelength * si->lfb_height;
-
-	si->capabilities |= VIDEO_CAPABILITY_SKIP_QUIRKS;
-out:
-	return status;
-}
-
-static efi_status_t
-__gop_query64(efi_system_table_t *sys_table_arg,
-	      struct efi_graphics_output_protocol_64 *gop64,
-	      struct efi_graphics_output_mode_info **info,
-	      unsigned long *size, u64 *fb_base)
-{
-	struct efi_graphics_output_protocol_mode_64 *mode;
-	efi_graphics_output_protocol_query_mode query_mode;
-	efi_status_t status;
-	unsigned long m;
-
-	m = gop64->mode;
-	mode = (struct efi_graphics_output_protocol_mode_64 *)m;
-	query_mode = (void *)(unsigned long)gop64->query_mode;
-
-	status = __efi_call_early(query_mode, (void *)gop64, mode->mode, size,
-				  info);
-	if (status != EFI_SUCCESS)
-		return status;
-
-	*fb_base = mode->frame_buffer_base;
-	return status;
-}
-
-static efi_status_t
-setup_gop64(efi_system_table_t *sys_table_arg, struct screen_info *si,
-	    efi_guid_t *proto, unsigned long size, void **gop_handle)
-{
-	struct efi_graphics_output_protocol_64 *gop64, *first_gop;
-	unsigned long nr_gops;
-	u16 width, height;
-	u32 pixels_per_scan_line;
-	u32 ext_lfb_base;
-	u64 fb_base;
-	struct efi_pixel_bitmask pixel_info;
-	int pixel_format;
-	efi_status_t status = EFI_NOT_FOUND;
-	u64 *handles = (u64 *)(unsigned long)gop_handle;
-	int i;
-
-	first_gop = NULL;
-	gop64 = NULL;
-
-	nr_gops = size / sizeof(u64);
-	for (i = 0; i < nr_gops; i++) {
-		struct efi_graphics_output_mode_info *info = NULL;
-		efi_guid_t conout_proto = EFI_CONSOLE_OUT_DEVICE_GUID;
-		bool conout_found = false;
-		void *dummy = NULL;
-		efi_handle_t h = (efi_handle_t)(unsigned long)handles[i];
-		u64 current_fb_base;
-
-		status = efi_call_early(handle_protocol, h,
-					proto, (void **)&gop64);
-		if (status != EFI_SUCCESS)
-			continue;
-
-		status = efi_call_early(handle_protocol, h,
-					&conout_proto, &dummy);
-		if (status == EFI_SUCCESS)
-			conout_found = true;
-
-		status = __gop_query64(sys_table_arg, gop64, &info, &size,
-				       &current_fb_base);
-		if (status == EFI_SUCCESS && (!first_gop || conout_found)) {
-			/*
-			 * Systems that use the UEFI Console Splitter may
-			 * provide multiple GOP devices, not all of which are
-			 * backed by real hardware. The workaround is to search
-			 * for a GOP implementing the ConOut protocol, and if
-			 * one isn't found, to just fall back to the first GOP.
-			 */
-			width = info->horizontal_resolution;
-			height = info->vertical_resolution;
-			pixel_format = info->pixel_format;
-			pixel_info = info->pixel_information;
-			pixels_per_scan_line = info->pixels_per_scan_line;
-			fb_base = current_fb_base;
-
-			/*
-			 * Once we've found a GOP supporting ConOut,
-			 * don't bother looking any further.
-			 */
-			first_gop = gop64;
-			if (conout_found)
-				break;
-		}
-	}
-
-	/* Did we find any GOPs? */
-	if (!first_gop)
-		goto out;
-
-	/* EFI framebuffer */
-	si->orig_video_isVGA = VIDEO_TYPE_EFI;
-
-	si->lfb_width = width;
-	si->lfb_height = height;
-	si->lfb_base = fb_base;
-
-	ext_lfb_base = (u64)(unsigned long)fb_base >> 32;
-	if (ext_lfb_base) {
-		si->capabilities |= VIDEO_CAPABILITY_64BIT_BASE;
-		si->ext_lfb_base = ext_lfb_base;
-	}
-
-	si->pages = 1;
-
-	setup_pixel_info(si, pixels_per_scan_line, pixel_info, pixel_format);
-
-	si->lfb_size = si->lfb_linelength * si->lfb_height;
-
-	si->capabilities |= VIDEO_CAPABILITY_SKIP_QUIRKS;
-out:
-	return status;
-}
-
-/*
- * See if we have Graphics Output Protocol
- */
-efi_status_t efi_setup_gop(efi_system_table_t *sys_table_arg,
-			   struct screen_info *si, efi_guid_t *proto,
-			   unsigned long size)
-{
-	efi_status_t status;
-	void **gop_handle = NULL;
-
-	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
-				size, (void **)&gop_handle);
-	if (status != EFI_SUCCESS)
-		return status;
-
-	status = efi_call_early(locate_handle,
-				EFI_LOCATE_BY_PROTOCOL,
-				proto, NULL, &size, gop_handle);
-	if (status != EFI_SUCCESS)
-		goto free_handle;
-
-	if (efi_is_64bit()) {
-		status = setup_gop64(sys_table_arg, si, proto, size,
-				     gop_handle);
-	} else {
-		status = setup_gop32(sys_table_arg, si, proto, size,
-				     gop_handle);
-	}
-
-free_handle:
-	efi_call_early(free_pool, gop_handle);
-	return status;
-}
-
 static efi_status_t
 setup_uga32(void **uga_handle, unsigned long size, u32 *width, u32 *height)
 {
diff --git a/arch/x86/boot/compressed/eboot.h b/arch/x86/boot/compressed/eboot.h
index 4ee5318d7f28..c0223f1a89d7 100644
--- a/arch/x86/boot/compressed/eboot.h
+++ b/arch/x86/boot/compressed/eboot.h
@@ -11,84 +11,6 @@
 
 #define DESC_TYPE_CODE_DATA	(1 << 0)
 
-#define EFI_CONSOLE_OUT_DEVICE_GUID    \
-	EFI_GUID(0xd3b36f2c, 0xd551, 0x11d4, 0x9a, 0x46, 0x0, 0x90, 0x27, \
-		  0x3f, 0xc1, 0x4d)
-
-#define PIXEL_RGB_RESERVED_8BIT_PER_COLOR		0
-#define PIXEL_BGR_RESERVED_8BIT_PER_COLOR		1
-#define PIXEL_BIT_MASK					2
-#define PIXEL_BLT_ONLY					3
-#define PIXEL_FORMAT_MAX				4
-
-struct efi_pixel_bitmask {
-	u32 red_mask;
-	u32 green_mask;
-	u32 blue_mask;
-	u32 reserved_mask;
-};
-
-struct efi_graphics_output_mode_info {
-	u32 version;
-	u32 horizontal_resolution;
-	u32 vertical_resolution;
-	int pixel_format;
-	struct efi_pixel_bitmask pixel_information;
-	u32 pixels_per_scan_line;
-} __packed;
-
-struct efi_graphics_output_protocol_mode_32 {
-	u32 max_mode;
-	u32 mode;
-	u32 info;
-	u32 size_of_info;
-	u64 frame_buffer_base;
-	u32 frame_buffer_size;
-} __packed;
-
-struct efi_graphics_output_protocol_mode_64 {
-	u32 max_mode;
-	u32 mode;
-	u64 info;
-	u64 size_of_info;
-	u64 frame_buffer_base;
-	u64 frame_buffer_size;
-} __packed;
-
-struct efi_graphics_output_protocol_mode {
-	u32 max_mode;
-	u32 mode;
-	unsigned long info;
-	unsigned long size_of_info;
-	u64 frame_buffer_base;
-	unsigned long frame_buffer_size;
-} __packed;
-
-struct efi_graphics_output_protocol_32 {
-	u32 query_mode;
-	u32 set_mode;
-	u32 blt;
-	u32 mode;
-};
-
-struct efi_graphics_output_protocol_64 {
-	u64 query_mode;
-	u64 set_mode;
-	u64 blt;
-	u64 mode;
-};
-
-struct efi_graphics_output_protocol {
-	void *query_mode;
-	unsigned long set_mode;
-	unsigned long blt;
-	struct efi_graphics_output_protocol_mode *mode;
-};
-
-typedef efi_status_t (*efi_graphics_output_protocol_query_mode)(
-	struct efi_graphics_output_protocol *, u32, unsigned long *,
-	struct efi_graphics_output_mode_info **);
-
 struct efi_uga_draw_protocol_32 {
 	u32 get_mode;
 	u32 set_mode;
diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index a15841eced4e..ad76fb9bb56f 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -25,7 +25,7 @@ KASAN_SANITIZE			:= n
 UBSAN_SANITIZE			:= n
 OBJECT_FILES_NON_STANDARD	:= y
 
-lib-y				:= efi-stub-helper.o
+lib-y				:= efi-stub-helper.o gop.o
 
 # include the stub's generic dependencies from lib/ when building for ARM/arm64
 arm-deps := fdt_rw.c fdt_ro.c fdt_wip.c fdt.c fdt_empty_tree.c fdt_sw.c sort.c
diff --git a/drivers/firmware/efi/libstub/gop.c b/drivers/firmware/efi/libstub/gop.c
new file mode 100644
index 000000000000..932742e4cf23
--- /dev/null
+++ b/drivers/firmware/efi/libstub/gop.c
@@ -0,0 +1,354 @@
+/* -----------------------------------------------------------------------
+ *
+ *   Copyright 2011 Intel Corporation; author Matt Fleming
+ *
+ *   This file is part of the Linux kernel, and is made available under
+ *   the terms of the GNU General Public License version 2.
+ *
+ * ----------------------------------------------------------------------- */
+
+#include <linux/efi.h>
+#include <linux/screen_info.h>
+#include <asm/efi.h>
+#include <asm/setup.h>
+
+static void find_bits(unsigned long mask, u8 *pos, u8 *size)
+{
+	u8 first, len;
+
+	first = 0;
+	len = 0;
+
+	if (mask) {
+		while (!(mask & 0x1)) {
+			mask = mask >> 1;
+			first++;
+		}
+
+		while (mask & 0x1) {
+			mask = mask >> 1;
+			len++;
+		}
+	}
+
+	*pos = first;
+	*size = len;
+}
+
+static void
+setup_pixel_info(struct screen_info *si, u32 pixels_per_scan_line,
+		 struct efi_pixel_bitmask pixel_info, int pixel_format)
+{
+	if (pixel_format == PIXEL_RGB_RESERVED_8BIT_PER_COLOR) {
+		si->lfb_depth = 32;
+		si->lfb_linelength = pixels_per_scan_line * 4;
+		si->red_size = 8;
+		si->red_pos = 0;
+		si->green_size = 8;
+		si->green_pos = 8;
+		si->blue_size = 8;
+		si->blue_pos = 16;
+		si->rsvd_size = 8;
+		si->rsvd_pos = 24;
+	} else if (pixel_format == PIXEL_BGR_RESERVED_8BIT_PER_COLOR) {
+		si->lfb_depth = 32;
+		si->lfb_linelength = pixels_per_scan_line * 4;
+		si->red_size = 8;
+		si->red_pos = 16;
+		si->green_size = 8;
+		si->green_pos = 8;
+		si->blue_size = 8;
+		si->blue_pos = 0;
+		si->rsvd_size = 8;
+		si->rsvd_pos = 24;
+	} else if (pixel_format == PIXEL_BIT_MASK) {
+		find_bits(pixel_info.red_mask, &si->red_pos, &si->red_size);
+		find_bits(pixel_info.green_mask, &si->green_pos,
+			  &si->green_size);
+		find_bits(pixel_info.blue_mask, &si->blue_pos, &si->blue_size);
+		find_bits(pixel_info.reserved_mask, &si->rsvd_pos,
+			  &si->rsvd_size);
+		si->lfb_depth = si->red_size + si->green_size +
+			si->blue_size + si->rsvd_size;
+		si->lfb_linelength = (pixels_per_scan_line * si->lfb_depth) / 8;
+	} else {
+		si->lfb_depth = 4;
+		si->lfb_linelength = si->lfb_width / 2;
+		si->red_size = 0;
+		si->red_pos = 0;
+		si->green_size = 0;
+		si->green_pos = 0;
+		si->blue_size = 0;
+		si->blue_pos = 0;
+		si->rsvd_size = 0;
+		si->rsvd_pos = 0;
+	}
+}
+
+static efi_status_t
+__gop_query32(efi_system_table_t *sys_table_arg,
+	      struct efi_graphics_output_protocol_32 *gop32,
+	      struct efi_graphics_output_mode_info **info,
+	      unsigned long *size, u64 *fb_base)
+{
+	struct efi_graphics_output_protocol_mode_32 *mode;
+	efi_graphics_output_protocol_query_mode query_mode;
+	efi_status_t status;
+	unsigned long m;
+
+	m = gop32->mode;
+	mode = (struct efi_graphics_output_protocol_mode_32 *)m;
+	query_mode = (void *)(unsigned long)gop32->query_mode;
+
+	status = __efi_call_early(query_mode, (void *)gop32, mode->mode, size,
+				  info);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	*fb_base = mode->frame_buffer_base;
+	return status;
+}
+
+static efi_status_t
+setup_gop32(efi_system_table_t *sys_table_arg, struct screen_info *si,
+            efi_guid_t *proto, unsigned long size, void **gop_handle)
+{
+	struct efi_graphics_output_protocol_32 *gop32, *first_gop;
+	unsigned long nr_gops;
+	u16 width, height;
+	u32 pixels_per_scan_line;
+	u32 ext_lfb_base;
+	u64 fb_base;
+	struct efi_pixel_bitmask pixel_info;
+	int pixel_format;
+	efi_status_t status = EFI_NOT_FOUND;
+	u32 *handles = (u32 *)(unsigned long)gop_handle;
+	int i;
+
+	first_gop = NULL;
+	gop32 = NULL;
+
+	nr_gops = size / sizeof(u32);
+	for (i = 0; i < nr_gops; i++) {
+		struct efi_graphics_output_mode_info *info = NULL;
+		efi_guid_t conout_proto = EFI_CONSOLE_OUT_DEVICE_GUID;
+		bool conout_found = false;
+		void *dummy = NULL;
+		efi_handle_t h = (efi_handle_t)(unsigned long)handles[i];
+		u64 current_fb_base;
+
+		status = efi_call_early(handle_protocol, h,
+					proto, (void **)&gop32);
+		if (status != EFI_SUCCESS)
+			continue;
+
+		status = efi_call_early(handle_protocol, h,
+					&conout_proto, &dummy);
+		if (status == EFI_SUCCESS)
+			conout_found = true;
+
+		status = __gop_query32(sys_table_arg, gop32, &info, &size,
+				       &current_fb_base);
+		if (status == EFI_SUCCESS && (!first_gop || conout_found)) {
+			/*
+			 * Systems that use the UEFI Console Splitter may
+			 * provide multiple GOP devices, not all of which are
+			 * backed by real hardware. The workaround is to search
+			 * for a GOP implementing the ConOut protocol, and if
+			 * one isn't found, to just fall back to the first GOP.
+			 */
+			width = info->horizontal_resolution;
+			height = info->vertical_resolution;
+			pixel_format = info->pixel_format;
+			pixel_info = info->pixel_information;
+			pixels_per_scan_line = info->pixels_per_scan_line;
+			fb_base = current_fb_base;
+
+			/*
+			 * Once we've found a GOP supporting ConOut,
+			 * don't bother looking any further.
+			 */
+			first_gop = gop32;
+			if (conout_found)
+				break;
+		}
+	}
+
+	/* Did we find any GOPs? */
+	if (!first_gop)
+		goto out;
+
+	/* EFI framebuffer */
+	si->orig_video_isVGA = VIDEO_TYPE_EFI;
+
+	si->lfb_width = width;
+	si->lfb_height = height;
+	si->lfb_base = fb_base;
+
+	ext_lfb_base = (u64)(unsigned long)fb_base >> 32;
+	if (ext_lfb_base) {
+		si->capabilities |= VIDEO_CAPABILITY_64BIT_BASE;
+		si->ext_lfb_base = ext_lfb_base;
+	}
+
+	si->pages = 1;
+
+	setup_pixel_info(si, pixels_per_scan_line, pixel_info, pixel_format);
+
+	si->lfb_size = si->lfb_linelength * si->lfb_height;
+
+	si->capabilities |= VIDEO_CAPABILITY_SKIP_QUIRKS;
+out:
+	return status;
+}
+
+static efi_status_t
+__gop_query64(efi_system_table_t *sys_table_arg,
+	      struct efi_graphics_output_protocol_64 *gop64,
+	      struct efi_graphics_output_mode_info **info,
+	      unsigned long *size, u64 *fb_base)
+{
+	struct efi_graphics_output_protocol_mode_64 *mode;
+	efi_graphics_output_protocol_query_mode query_mode;
+	efi_status_t status;
+	unsigned long m;
+
+	m = gop64->mode;
+	mode = (struct efi_graphics_output_protocol_mode_64 *)m;
+	query_mode = (void *)(unsigned long)gop64->query_mode;
+
+	status = __efi_call_early(query_mode, (void *)gop64, mode->mode, size,
+				  info);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	*fb_base = mode->frame_buffer_base;
+	return status;
+}
+
+static efi_status_t
+setup_gop64(efi_system_table_t *sys_table_arg, struct screen_info *si,
+	    efi_guid_t *proto, unsigned long size, void **gop_handle)
+{
+	struct efi_graphics_output_protocol_64 *gop64, *first_gop;
+	unsigned long nr_gops;
+	u16 width, height;
+	u32 pixels_per_scan_line;
+	u32 ext_lfb_base;
+	u64 fb_base;
+	struct efi_pixel_bitmask pixel_info;
+	int pixel_format;
+	efi_status_t status = EFI_NOT_FOUND;
+	u64 *handles = (u64 *)(unsigned long)gop_handle;
+	int i;
+
+	first_gop = NULL;
+	gop64 = NULL;
+
+	nr_gops = size / sizeof(u64);
+	for (i = 0; i < nr_gops; i++) {
+		struct efi_graphics_output_mode_info *info = NULL;
+		efi_guid_t conout_proto = EFI_CONSOLE_OUT_DEVICE_GUID;
+		bool conout_found = false;
+		void *dummy = NULL;
+		efi_handle_t h = (efi_handle_t)(unsigned long)handles[i];
+		u64 current_fb_base;
+
+		status = efi_call_early(handle_protocol, h,
+					proto, (void **)&gop64);
+		if (status != EFI_SUCCESS)
+			continue;
+
+		status = efi_call_early(handle_protocol, h,
+					&conout_proto, &dummy);
+		if (status == EFI_SUCCESS)
+			conout_found = true;
+
+		status = __gop_query64(sys_table_arg, gop64, &info, &size,
+				       &current_fb_base);
+		if (status == EFI_SUCCESS && (!first_gop || conout_found)) {
+			/*
+			 * Systems that use the UEFI Console Splitter may
+			 * provide multiple GOP devices, not all of which are
+			 * backed by real hardware. The workaround is to search
+			 * for a GOP implementing the ConOut protocol, and if
+			 * one isn't found, to just fall back to the first GOP.
+			 */
+			width = info->horizontal_resolution;
+			height = info->vertical_resolution;
+			pixel_format = info->pixel_format;
+			pixel_info = info->pixel_information;
+			pixels_per_scan_line = info->pixels_per_scan_line;
+			fb_base = current_fb_base;
+
+			/*
+			 * Once we've found a GOP supporting ConOut,
+			 * don't bother looking any further.
+			 */
+			first_gop = gop64;
+			if (conout_found)
+				break;
+		}
+	}
+
+	/* Did we find any GOPs? */
+	if (!first_gop)
+		goto out;
+
+	/* EFI framebuffer */
+	si->orig_video_isVGA = VIDEO_TYPE_EFI;
+
+	si->lfb_width = width;
+	si->lfb_height = height;
+	si->lfb_base = fb_base;
+
+	ext_lfb_base = (u64)(unsigned long)fb_base >> 32;
+	if (ext_lfb_base) {
+		si->capabilities |= VIDEO_CAPABILITY_64BIT_BASE;
+		si->ext_lfb_base = ext_lfb_base;
+	}
+
+	si->pages = 1;
+
+	setup_pixel_info(si, pixels_per_scan_line, pixel_info, pixel_format);
+
+	si->lfb_size = si->lfb_linelength * si->lfb_height;
+
+	si->capabilities |= VIDEO_CAPABILITY_SKIP_QUIRKS;
+out:
+	return status;
+}
+
+/*
+ * See if we have Graphics Output Protocol
+ */
+efi_status_t efi_setup_gop(efi_system_table_t *sys_table_arg,
+			   struct screen_info *si, efi_guid_t *proto,
+			   unsigned long size)
+{
+	efi_status_t status;
+	void **gop_handle = NULL;
+
+	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
+				size, (void **)&gop_handle);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	status = efi_call_early(locate_handle,
+				EFI_LOCATE_BY_PROTOCOL,
+				proto, NULL, &size, gop_handle);
+	if (status != EFI_SUCCESS)
+		goto free_handle;
+
+	if (efi_is_64bit()) {
+		status = setup_gop64(sys_table_arg, si, proto, size,
+				     gop_handle);
+	} else {
+		status = setup_gop32(sys_table_arg, si, proto, size,
+				     gop_handle);
+	}
+
+free_handle:
+	efi_call_early(free_pool, gop_handle);
+	return status;
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index f6e7724451ca..647827c113f7 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -283,7 +283,8 @@ typedef struct {
 	efi_status_t (*handle_protocol)(efi_handle_t, efi_guid_t *, void **);
 	void *__reserved;
 	void *register_protocol_notify;
-	void *locate_handle;
+	efi_status_t (*locate_handle)(int, efi_guid_t *, void *,
+				      unsigned long *, efi_handle_t *);
 	void *locate_device_path;
 	void *install_configuration_table;
 	void *load_image;
@@ -624,6 +625,10 @@ void efi_native_runtime_setup(void);
 	EFI_GUID(0x3152bca5, 0xeade, 0x433d, \
 		 0x86, 0x2e, 0xc0, 0x1c, 0xdc, 0x29, 0x1f, 0x44)
 
+#define EFI_CONSOLE_OUT_DEVICE_GUID \
+	EFI_GUID(0xd3b36f2c, 0xd551, 0x11d4, \
+		 0x9a, 0x46, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
+
 typedef struct {
 	efi_guid_t guid;
 	u64 table;
@@ -1180,6 +1185,80 @@ struct efi_simple_text_output_protocol {
 	void *test_string;
 };
 
+#define PIXEL_RGB_RESERVED_8BIT_PER_COLOR		0
+#define PIXEL_BGR_RESERVED_8BIT_PER_COLOR		1
+#define PIXEL_BIT_MASK					2
+#define PIXEL_BLT_ONLY					3
+#define PIXEL_FORMAT_MAX				4
+
+struct efi_pixel_bitmask {
+	u32 red_mask;
+	u32 green_mask;
+	u32 blue_mask;
+	u32 reserved_mask;
+};
+
+struct efi_graphics_output_mode_info {
+	u32 version;
+	u32 horizontal_resolution;
+	u32 vertical_resolution;
+	int pixel_format;
+	struct efi_pixel_bitmask pixel_information;
+	u32 pixels_per_scan_line;
+} __packed;
+
+struct efi_graphics_output_protocol_mode_32 {
+	u32 max_mode;
+	u32 mode;
+	u32 info;
+	u32 size_of_info;
+	u64 frame_buffer_base;
+	u32 frame_buffer_size;
+} __packed;
+
+struct efi_graphics_output_protocol_mode_64 {
+	u32 max_mode;
+	u32 mode;
+	u64 info;
+	u64 size_of_info;
+	u64 frame_buffer_base;
+	u64 frame_buffer_size;
+} __packed;
+
+struct efi_graphics_output_protocol_mode {
+	u32 max_mode;
+	u32 mode;
+	unsigned long info;
+	unsigned long size_of_info;
+	u64 frame_buffer_base;
+	unsigned long frame_buffer_size;
+} __packed;
+
+struct efi_graphics_output_protocol_32 {
+	u32 query_mode;
+	u32 set_mode;
+	u32 blt;
+	u32 mode;
+};
+
+struct efi_graphics_output_protocol_64 {
+	u64 query_mode;
+	u64 set_mode;
+	u64 blt;
+	u64 mode;
+};
+
+struct efi_graphics_output_protocol {
+	unsigned long query_mode;
+	unsigned long set_mode;
+	unsigned long blt;
+	struct efi_graphics_output_protocol_mode *mode;
+};
+
+typedef efi_status_t (*efi_graphics_output_protocol_query_mode)(
+	struct efi_graphics_output_protocol *, u32, unsigned long *,
+	struct efi_graphics_output_mode_info **);
+
 extern struct list_head efivar_sysfs_list;
 
 static inline void
-- 
2.5.0
