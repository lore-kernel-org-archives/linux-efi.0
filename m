From: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
Subject: [PATCH] efi-bgrt: Add error handling; inform the user when ignoring
 the BGRT
Date: Wed, 30 Jul 2014 12:23:32 -0700
Message-ID: <20140730192331.GA23730@jtriplet-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Gracefully handle failures to allocate memory for the image, which might
be arbitrarily large.

efi_bgrt_init can fail in various ways as well, usually because the
BIOS-provided BGRT structure does not match expectations.  Add
appropriate error messages rather than failing silently.

Reported-by: Srihari Vijayaraghavan
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=81321
Signed-off-by: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
---
 arch/x86/platform/efi/efi-bgrt.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
index f15103d..d143d21 100644
--- a/arch/x86/platform/efi/efi-bgrt.c
+++ b/arch/x86/platform/efi/efi-bgrt.c
@@ -40,20 +40,40 @@ void __init efi_bgrt_init(void)
 	if (ACPI_FAILURE(status))
 		return;
 
-	if (bgrt_tab->header.length < sizeof(*bgrt_tab))
+	if (bgrt_tab->header.length < sizeof(*bgrt_tab)) {
+		pr_err("Ignoring BGRT: invalid length %u (expected %zu)\n",
+		       bgrt_tab->header.length, sizeof(*bgrt_tab));
 		return;
-	if (bgrt_tab->version != 1 || bgrt_tab->status != 1)
+	}
+	if (bgrt_tab->version != 1) {
+		pr_err("Ignoring BGRT: invalid version %u (expected 1)\n",
+		       bgrt_tab->version);
+		return;
+	}
+	if (bgrt_tab->status != 1) {
+		pr_err("Ignoring BGRT: invalid status %u (expected 1)\n",
+		       bgrt_tab->status);
+		return;
+	}
+	if (bgrt_tab->image_type != 0) {
+		pr_err("Ignoring BGRT: invalid image type %u (expected 0)\n",
+		       bgrt_tab->image_type);
 		return;
-	if (bgrt_tab->image_type != 0 || !bgrt_tab->image_address)
+	}
+	if (!bgrt_tab->image_address) {
+		pr_err("Ignoring BGRT: null image address\n");
 		return;
+	}
 
 	image = efi_lookup_mapped_addr(bgrt_tab->image_address);
 	if (!image) {
 		image = early_memremap(bgrt_tab->image_address,
 				       sizeof(bmp_header));
 		ioremapped = true;
-		if (!image)
+		if (!image) {
+			pr_err("Ignoring BGRT: failed to map image header memory\n");
 			return;
+		}
 	}
 
 	memcpy_fromio(&bmp_header, image, sizeof(bmp_header));
@@ -61,14 +81,18 @@ void __init efi_bgrt_init(void)
 		early_iounmap(image, sizeof(bmp_header));
 	bgrt_image_size = bmp_header.size;
 
-	bgrt_image = kmalloc(bgrt_image_size, GFP_KERNEL);
-	if (!bgrt_image)
+	bgrt_image = kmalloc(bgrt_image_size, GFP_KERNEL | __GFP_NOWARN);
+	if (!bgrt_image) {
+		pr_err("Ignoring BGRT: failed to allocate memory for image (wanted %zu bytes)\n",
+		       bgrt_image_size);
 		return;
+	}
 
 	if (ioremapped) {
 		image = early_memremap(bgrt_tab->image_address,
 				       bmp_header.size);
 		if (!image) {
+			pr_err("Ignoring BGRT: failed to map image memory\n");
 			kfree(bgrt_image);
 			bgrt_image = NULL;
 			return;
-- 
2.0.1
