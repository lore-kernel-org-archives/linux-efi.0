From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] drivers/fbdev: efifb: allow BAR to be moved instead of claiming it
Date: Tue, 27 Jun 2017 16:19:36 +0000
Message-ID: <20170627161936.2301-1-ard.biesheuvel@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-fbdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org, bhelgaas-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On UEFI systems, the firmware may expose a Graphics Output Protocol (GOP)
instance to which the efifb driver attempts to attach in order to provide
a minimal, unaccelerated framebuffer. The GOP protocol itself is not very
sophisticated, and only describes the offset and size of the framebuffer
in memory, and the pixel format.

If the GOP framebuffer is provided by a PCI device, it will have been
configured and enabled by the UEFI firmware, and the GOP protocol will
simply point into a live BAR region. However, the GOP protocol itself does
not describe this relation, and so we have to take care not to reconfigure
the BAR without taking efifb's dependency on it into account.

Commit 55d728a40d36 ("efi/fb: Avoid reconfiguration of BAR that covers
the framebuffer") attempted to do so by claiming the BAR resource early
on, which prevents the PCI resource allocation routines from changing it.
However, it turns out that this only works if the PCI device is not
behind any bridges, since the bridge resources need to be claimed first.

So instead, allow the BAR to be moved, but make the efifb driver deal
with that gracefully. So record the resource that covers the BAR early
on, and if it turns out the have moved by the time we probe the efifb
driver, update the framebuffer address accordingly.

While this is less likely to occur on x86, given that the firmware's
PCI resource allocation is more likely to be preserved, this is a
worthwhile sanity check to have in place, and so let's remove the

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
---
 drivers/video/fbdev/efifb.c | 24 ++++++++++++--------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
index b827a8113e26..6220de3e25d3 100644
--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -146,6 +146,9 @@ ATTRIBUTE_GROUPS(efifb);
 
 static bool pci_dev_disabled;	/* FB base matches BAR of a disabled device */
 
+static struct resource *bar_resource;
+static u64 bar_offset;
+
 static int efifb_probe(struct platform_device *dev)
 {
 	struct fb_info *info;
@@ -200,6 +203,13 @@ static int efifb_probe(struct platform_device *dev)
 		efifb_fix.smem_start |= ext_lfb_base;
 	}
 
+	if (bar_resource &&
+	    bar_resource->start + bar_offset != efifb_fix.smem_start) {
+
+		pr_warn("efifb: PCI BAR has moved, updating fb address\n");
+		efifb_fix.smem_start = bar_resource->start + bar_offset;
+	}
+
 	efifb_defined.bits_per_pixel = screen_info.lfb_depth;
 	efifb_defined.xres = screen_info.lfb_width;
 	efifb_defined.yres = screen_info.lfb_height;
@@ -364,11 +374,11 @@ static struct platform_driver efifb_driver = {
 
 builtin_platform_driver(efifb_driver);
 
-#if defined(CONFIG_PCI) && !defined(CONFIG_X86)
+#if defined(CONFIG_PCI)
 
 static bool pci_bar_found;	/* did we find a BAR matching the efifb base? */
 
-static void claim_efifb_bar(struct pci_dev *dev, int idx)
+static void record_efifb_bar_resource(struct pci_dev *dev, int idx, u64 offset)
 {
 	u16 word;
 
@@ -383,12 +393,8 @@ static void claim_efifb_bar(struct pci_dev *dev, int idx)
 		return;
 	}
 
-	if (pci_claim_resource(dev, idx)) {
-		pci_dev_disabled = true;
-		dev_err(&dev->dev,
-			"BAR %d: failed to claim resource for efifb!\n", idx);
-		return;
-	}
+	bar_resource = &dev->resource[idx];
+	bar_offset = offset;
 
 	dev_info(&dev->dev, "BAR %d: assigned to efifb\n", idx);
 }
@@ -415,7 +421,7 @@ static void efifb_fixup_resources(struct pci_dev *dev)
 			continue;
 
 		if (res->start <= base && res->end >= base + size - 1) {
-			claim_efifb_bar(dev, i);
+			record_efifb_bar_resource(dev, i, base - res->start);
 			break;
 		}
 	}
-- 
2.9.3
