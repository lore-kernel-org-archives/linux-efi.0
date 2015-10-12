From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 05/11] efifb: Add support for 64-bit frame buffer addresses
Date: Mon, 12 Oct 2015 14:56:08 +0100
Message-ID: <1444658174-23378-6-git-send-email-matt@codeblueprint.co.uk>
References: <1444658174-23378-1-git-send-email-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444658174-23378-1-git-send-email-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Matt Fleming <matt.fleming@intel.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Pete Hawkins <pete.hawkins@znyx.com>, Matthew Garrett <mjg59@srcf.ucam.org>, Geert Uytterhoeven <geert@linux-m68k.org>, Chad Page <chad.page@znyx.com>, Peter Jones <pjones@redhat.com>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

The EFI Graphics Output Protocol uses 64-bit frame buffer addresses
but these get truncated to 32-bit by the EFI boot stub when storing
the address in the 'lfb_base' field of 'struct screen_info'.

Add a 'ext_lfb_base' field for the upper 32-bits of the frame buffer
address and set VIDEO_TYPE_CAPABILITY_64BIT_BASE when the field is
useable.

It turns out that the reason no one has required this support so far
is that there's actually code in tianocore to "downgrade" PCI
resources that have option ROMs and 64-bit BARS from 64-bit to 32-bit
to cope with legacy option ROMs that can't handle 64-bit addresses.
The upshot is that basically all GOP devices in the wild use a 32-bit
frame buffer address.

Still, it is possible to build firmware that uses a full 64-bit GOP
frame buffer address. Chad did, which led to him reporting this issue.

Add support in anticipation of GOP devices using 64-bit addresses more
widely, and so that efifb works out of the box when that happens.

Reported-by: Chad Page <chad.page@znyx.com>
Cc: Pete Hawkins <pete.hawkins@znyx.com>
Acked-by: Peter Jones <pjones@redhat.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/compressed/eboot.c | 24 ++++++++++++++++++++----
 drivers/video/fbdev/efifb.c      | 24 +++++++++++++++++++++++-
 include/uapi/linux/screen_info.h |  5 +++--
 3 files changed, 46 insertions(+), 7 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 7d69afd8b6fa..43473bb86ac0 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -624,7 +624,7 @@ setup_pixel_info(struct screen_info *si, u32 pixels_per_scan_line,
 static efi_status_t
 __gop_query32(struct efi_graphics_output_protocol_32 *gop32,
 	      struct efi_graphics_output_mode_info **info,
-	      unsigned long *size, u32 *fb_base)
+	      unsigned long *size, u64 *fb_base)
 {
 	struct efi_graphics_output_protocol_mode_32 *mode;
 	efi_status_t status;
@@ -650,7 +650,8 @@ setup_gop32(struct screen_info *si, efi_guid_t *proto,
 	unsigned long nr_gops;
 	u16 width, height;
 	u32 pixels_per_scan_line;
-	u32 fb_base;
+	u32 ext_lfb_base;
+	u64 fb_base;
 	struct efi_pixel_bitmask pixel_info;
 	int pixel_format;
 	efi_status_t status;
@@ -713,6 +714,13 @@ setup_gop32(struct screen_info *si, efi_guid_t *proto,
 	si->lfb_width = width;
 	si->lfb_height = height;
 	si->lfb_base = fb_base;
+
+	ext_lfb_base = (u64)(unsigned long)fb_base >> 32;
+	if (ext_lfb_base) {
+		si->capabilities |= VIDEO_CAPABILITY_64BIT_BASE;
+		si->ext_lfb_base = ext_lfb_base;
+	}
+
 	si->pages = 1;
 
 	setup_pixel_info(si, pixels_per_scan_line, pixel_info, pixel_format);
@@ -727,7 +735,7 @@ out:
 static efi_status_t
 __gop_query64(struct efi_graphics_output_protocol_64 *gop64,
 	      struct efi_graphics_output_mode_info **info,
-	      unsigned long *size, u32 *fb_base)
+	      unsigned long *size, u64 *fb_base)
 {
 	struct efi_graphics_output_protocol_mode_64 *mode;
 	efi_status_t status;
@@ -753,7 +761,8 @@ setup_gop64(struct screen_info *si, efi_guid_t *proto,
 	unsigned long nr_gops;
 	u16 width, height;
 	u32 pixels_per_scan_line;
-	u32 fb_base;
+	u32 ext_lfb_base;
+	u64 fb_base;
 	struct efi_pixel_bitmask pixel_info;
 	int pixel_format;
 	efi_status_t status;
@@ -816,6 +825,13 @@ setup_gop64(struct screen_info *si, efi_guid_t *proto,
 	si->lfb_width = width;
 	si->lfb_height = height;
 	si->lfb_base = fb_base;
+
+	ext_lfb_base = (u64)(unsigned long)fb_base >> 32;
+	if (ext_lfb_base) {
+		si->capabilities |= VIDEO_CAPABILITY_64BIT_BASE;
+		si->ext_lfb_base = ext_lfb_base;
+	}
+
 	si->pages = 1;
 
 	setup_pixel_info(si, pixels_per_scan_line, pixel_info, pixel_format);
diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
index 4bfff349b1fb..95d293b7445a 100644
--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -114,6 +114,20 @@ static int efifb_setup(char *options)
 	return 0;
 }
 
+static inline bool fb_base_is_valid(void)
+{
+	if (screen_info.lfb_base)
+		return true;
+
+	if (!(screen_info.capabilities & VIDEO_CAPABILITY_64BIT_BASE))
+		return false;
+
+	if (screen_info.ext_lfb_base)
+		return true;
+
+	return false;
+}
+
 static int efifb_probe(struct platform_device *dev)
 {
 	struct fb_info *info;
@@ -141,7 +155,7 @@ static int efifb_probe(struct platform_device *dev)
 		screen_info.lfb_depth = 32;
 	if (!screen_info.pages)
 		screen_info.pages = 1;
-	if (!screen_info.lfb_base) {
+	if (!fb_base_is_valid()) {
 		printk(KERN_DEBUG "efifb: invalid framebuffer address\n");
 		return -ENODEV;
 	}
@@ -160,6 +174,14 @@ static int efifb_probe(struct platform_device *dev)
 	}
 
 	efifb_fix.smem_start = screen_info.lfb_base;
+
+	if (screen_info.capabilities & VIDEO_CAPABILITY_64BIT_BASE) {
+		u64 ext_lfb_base;
+
+		ext_lfb_base = (u64)(unsigned long)screen_info.ext_lfb_base << 32;
+		efifb_fix.smem_start |= ext_lfb_base;
+	}
+
 	efifb_defined.bits_per_pixel = screen_info.lfb_depth;
 	efifb_defined.xres = screen_info.lfb_width;
 	efifb_defined.yres = screen_info.lfb_height;
diff --git a/include/uapi/linux/screen_info.h b/include/uapi/linux/screen_info.h
index 7530e7447620..8b8d39dfb67f 100644
--- a/include/uapi/linux/screen_info.h
+++ b/include/uapi/linux/screen_info.h
@@ -43,7 +43,8 @@ struct screen_info {
 	__u16 pages;		/* 0x32 */
 	__u16 vesa_attributes;	/* 0x34 */
 	__u32 capabilities;     /* 0x36 */
-	__u8  _reserved[6];	/* 0x3a */
+	__u32 ext_lfb_base;	/* 0x3a */
+	__u8  _reserved[2];	/* 0x3e */
 } __attribute__((packed));
 
 #define VIDEO_TYPE_MDA		0x10	/* Monochrome Text Display	*/
@@ -69,6 +70,6 @@ struct screen_info {
 #define VIDEO_FLAGS_NOCURSOR	(1 << 0) /* The video mode has no cursor set */
 
 #define VIDEO_CAPABILITY_SKIP_QUIRKS	(1 << 0)
-
+#define VIDEO_CAPABILITY_64BIT_BASE	(1 << 1)	/* Frame buffer base is 64-bit */
 
 #endif /* _UAPI_SCREEN_INFO_H */
-- 
2.1.0
