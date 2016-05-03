From: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
Subject: [PATCH v2] x86/efi-bgrt: Switch all pr_err() to pr_notice() for invalid BGRT
Date: Tue,  3 May 2016 13:47:04 -0400
Message-ID: <1462297624-3003-1-git-send-email-jwboyer@fedoraproject.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

The promise of pretty boot splashes from firmware via BGRT was at
best only that; a promise.  The kernel diligently checks to make
sure the BGRT data firmware gives it is valid, and dutifully warns
the user when it isn't.  However, it does so via the pr_err log
level which seems unnecessary.  The user cannot do anything about
this and there really isn't an error on the part of Linux to
correct.

This lowers the log level by using pr_notice instead.  Users will
no longer have their boot process uglified by the kernel reminding
us that firmware can and often is broken when the 'quiet' kernel
parameter is specified.  Ironic, considering BGRT is supposed to
make boot pretty to begin with.

Signed-off-by: Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>
---

v2: Switch to using pr_notice instead of pr_debug

 arch/x86/platform/efi/efi-bgrt.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
index a2433817c987..6a2f5691b1ab 100644
--- a/arch/x86/platform/efi/efi-bgrt.c
+++ b/arch/x86/platform/efi/efi-bgrt.c
@@ -43,40 +43,40 @@ void __init efi_bgrt_init(void)
 		return;
 
 	if (bgrt_tab->header.length < sizeof(*bgrt_tab)) {
-		pr_err("Ignoring BGRT: invalid length %u (expected %zu)\n",
+		pr_notice("Ignoring BGRT: invalid length %u (expected %zu)\n",
 		       bgrt_tab->header.length, sizeof(*bgrt_tab));
 		return;
 	}
 	if (bgrt_tab->version != 1) {
-		pr_err("Ignoring BGRT: invalid version %u (expected 1)\n",
+		pr_notice("Ignoring BGRT: invalid version %u (expected 1)\n",
 		       bgrt_tab->version);
 		return;
 	}
 	if (bgrt_tab->status & 0xfe) {
-		pr_err("Ignoring BGRT: reserved status bits are non-zero %u\n",
+		pr_notice("Ignoring BGRT: reserved status bits are non-zero %u\n",
 		       bgrt_tab->status);
 		return;
 	}
 	if (bgrt_tab->image_type != 0) {
-		pr_err("Ignoring BGRT: invalid image type %u (expected 0)\n",
+		pr_notice("Ignoring BGRT: invalid image type %u (expected 0)\n",
 		       bgrt_tab->image_type);
 		return;
 	}
 	if (!bgrt_tab->image_address) {
-		pr_err("Ignoring BGRT: null image address\n");
+		pr_notice("Ignoring BGRT: null image address\n");
 		return;
 	}
 
 	image = memremap(bgrt_tab->image_address, sizeof(bmp_header), MEMREMAP_WB);
 	if (!image) {
-		pr_err("Ignoring BGRT: failed to map image header memory\n");
+		pr_notice("Ignoring BGRT: failed to map image header memory\n");
 		return;
 	}
 
 	memcpy(&bmp_header, image, sizeof(bmp_header));
 	memunmap(image);
 	if (bmp_header.id != 0x4d42) {
-		pr_err("Ignoring BGRT: Incorrect BMP magic number 0x%x (expected 0x4d42)\n",
+		pr_notice("Ignoring BGRT: Incorrect BMP magic number 0x%x (expected 0x4d42)\n",
 			bmp_header.id);
 		return;
 	}
@@ -84,14 +84,14 @@ void __init efi_bgrt_init(void)
 
 	bgrt_image = kmalloc(bgrt_image_size, GFP_KERNEL | __GFP_NOWARN);
 	if (!bgrt_image) {
-		pr_err("Ignoring BGRT: failed to allocate memory for image (wanted %zu bytes)\n",
+		pr_notice("Ignoring BGRT: failed to allocate memory for image (wanted %zu bytes)\n",
 		       bgrt_image_size);
 		return;
 	}
 
 	image = memremap(bgrt_tab->image_address, bmp_header.size, MEMREMAP_WB);
 	if (!image) {
-		pr_err("Ignoring BGRT: failed to map image memory\n");
+		pr_notice("Ignoring BGRT: failed to map image memory\n");
 		kfree(bgrt_image);
 		bgrt_image = NULL;
 		return;
-- 
2.5.5
