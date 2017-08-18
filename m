From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 07/14] drivers/fbdev: efifb: allow BAR to be moved instead of claiming it
Date: Fri, 18 Aug 2017 20:49:40 +0100
Message-ID: <20170818194947.19347-8-ard.biesheuvel@linaro.org>
References: <20170818194947.19347-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170818194947.19347-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, Matt Fleming <matt@codeblueprint.co.uk>
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
on, and if it turns out to have moved by the time we probe the efifb
driver, update the framebuffer address accordingly.

While this is less likely to occur on x86, given that the firmware's
PCI resource allocation is more likely to be preserved, this is a
worthwhile sanity check to have in place, and so let's remove the
preprocessor conditional that makes it !X86 only.

Cc: Matt Fleming <matt@codeblueprint.co.uk>
Reviewed-by: Peter Jones <pjones@redhat.com>
Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/video/fbdev/efifb.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
index ff01bed7112f..994b5f3a4d73 100644
--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -146,6 +146,10 @@ ATTRIBUTE_GROUPS(efifb);
 
 static bool pci_dev_disabled;	/* FB base matches BAR of a disabled device */
 
+static struct pci_dev *efifb_pci_dev;	/* dev with BAR covering the efifb */
+static struct resource *bar_resource;
+static u64 bar_offset;
+
 static int efifb_probe(struct platform_device *dev)
 {
 	struct fb_info *info;
@@ -200,6 +204,13 @@ static int efifb_probe(struct platform_device *dev)
 		efifb_fix.smem_start |= ext_lfb_base;
 	}
 
+	if (bar_resource &&
+	    bar_resource->start + bar_offset != efifb_fix.smem_start) {
+		dev_info(&efifb_pci_dev->dev,
+			 "BAR has moved, updating efifb address\n");
+		efifb_fix.smem_start = bar_resource->start + bar_offset;
+	}
+
 	efifb_defined.bits_per_pixel = screen_info.lfb_depth;
 	efifb_defined.xres = screen_info.lfb_width;
 	efifb_defined.yres = screen_info.lfb_height;
@@ -364,15 +375,13 @@ static struct platform_driver efifb_driver = {
 
 builtin_platform_driver(efifb_driver);
 
-#if defined(CONFIG_PCI) && !defined(CONFIG_X86)
-
-static bool pci_bar_found;	/* did we find a BAR matching the efifb base? */
+#if defined(CONFIG_PCI)
 
-static void claim_efifb_bar(struct pci_dev *dev, int idx)
+static void record_efifb_bar_resource(struct pci_dev *dev, int idx, u64 offset)
 {
 	u16 word;
 
-	pci_bar_found = true;
+	efifb_pci_dev = dev;
 
 	pci_read_config_word(dev, PCI_COMMAND, &word);
 	if (!(word & PCI_COMMAND_MEMORY)) {
@@ -383,12 +392,8 @@ static void claim_efifb_bar(struct pci_dev *dev, int idx)
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
@@ -399,7 +404,7 @@ static void efifb_fixup_resources(struct pci_dev *dev)
 	u64 size = screen_info.lfb_size;
 	int i;
 
-	if (pci_bar_found || screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
+	if (efifb_pci_dev || screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
 		return;
 
 	if (screen_info.capabilities & VIDEO_CAPABILITY_64BIT_BASE)
@@ -415,7 +420,7 @@ static void efifb_fixup_resources(struct pci_dev *dev)
 			continue;
 
 		if (res->start <= base && res->end >= base + size - 1) {
-			claim_efifb_bar(dev, i);
+			record_efifb_bar_resource(dev, i, base - res->start);
 			break;
 		}
 	}
-- 
2.11.0
