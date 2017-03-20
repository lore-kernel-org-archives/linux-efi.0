From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] efifb: avoid reconfiguration of BAR that covers the framebuffer
Date: Mon, 20 Mar 2017 22:13:57 +0000
Message-ID: <1490048037-1850-1-git-send-email-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org, heyi.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On UEFI systems, the PCI subsystem is enumerated by the firmware,
and if a graphical framebuffer is exposed by a PCI device, its base
address and size are exposed to the OS via the Graphics Output
Protocol (GOP).

On arm64 PCI systems, the entire PCI hierarchy is reconfigured from
scratch at boot. This may result in the GOP framebuffer address to
become stale, if the BAR covering the framebuffer is modified. This
will cause the framebuffer to become unresponsive, and may in some
cases result in unpredictable behavior if the range is reassigned to
another device.

So add a quirk to the EFI fb driver to find the BAR associated with
the GOP base address, and set the IORESOURCE_PCI_FIXED attribute so
that the PCI core will leave it alone.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/video/fbdev/efifb.c | 33 ++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
index 8c4dc1e1f94f..97a3b15b6f04 100644
--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -10,6 +10,7 @@
 #include <linux/efi.h>
 #include <linux/errno.h>
 #include <linux/fb.h>
+#include <linux/pci.h>
 #include <linux/platform_device.h>
 #include <linux/screen_info.h>
 #include <video/vga.h>
@@ -360,3 +361,35 @@ static struct platform_driver efifb_driver = {
 };
 
 builtin_platform_driver(efifb_driver);
+
+static bool resource_found;
+
+static void efifb_fixup_resources(struct pci_dev *dev)
+{
+	u64 fb_base = screen_info.lfb_base;
+	u64 fb_size = screen_info.lfb_size;
+	int i;
+
+	if (resource_found || screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
+		return;
+
+	if (screen_info.capabilities & VIDEO_CAPABILITY_64BIT_BASE)
+		fb_base |= (u64)screen_info.ext_lfb_base << 32;
+
+	if (!fb_base)
+		return;
+
+	for (i = 0; i < PCI_STD_RESOURCE_END; i++) {
+		struct resource *res = &dev->resource[i];
+
+		if (!(res->flags & IORESOURCE_MEM))
+			continue;
+
+		if (res->start <= fb_base && res->end >= fb_base + fb_size) {
+			res->flags |= IORESOURCE_PCI_FIXED;
+			resource_found = true;
+			break;
+		}
+	}
+}
+DECLARE_PCI_FIXUP_HEADER(PCI_ANY_ID, PCI_ANY_ID, efifb_fixup_resources);
-- 
2.7.4
