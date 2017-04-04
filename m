From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 2/2] efifb: Avoid reconfiguration of BAR that covers the framebuffer
Date: Tue,  4 Apr 2017 16:27:44 +0100
Message-ID: <20170404152744.26687-3-ard.biesheuvel@linaro.org>
References: <20170404152744.26687-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170404152744.26687-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: leif.lindholm@linaro.org, lorenzo.pieralisi@arm.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org
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

So add a non-x86 quirk to the EFI fb driver to find the BAR associated
with the GOP base address, and claim the BAR resource so that the PCI
core will not move it.

Fixes: 9822504c1fa5 ("efifb: Enable the efi-framebuffer platform driver ...")
Cc: <stable@vger.kernel.org> # v4.7+
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Peter Jones <pjones@redhat.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/video/fbdev/efifb.c | 66 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 65 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
index 8c4dc1e1f94f..758960b6aec9 100644
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
@@ -143,6 +144,8 @@ static struct attribute *efifb_attrs[] = {
 };
 ATTRIBUTE_GROUPS(efifb);
 
+static bool pci_dev_disabled;	/* FB base matches BAR of a disabled device */
+
 static int efifb_probe(struct platform_device *dev)
 {
 	struct fb_info *info;
@@ -152,7 +155,7 @@ static int efifb_probe(struct platform_device *dev)
 	unsigned int size_total;
 	char *option = NULL;
 
-	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
+	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI || pci_dev_disabled)
 		return -ENODEV;
 
 	if (fb_get_options("efifb", &option))
@@ -360,3 +363,64 @@ static struct platform_driver efifb_driver = {
 };
 
 builtin_platform_driver(efifb_driver);
+
+#ifndef CONFIG_X86
+
+static bool pci_bar_found;	/* did we find a BAR matching the efifb base? */
+
+static void claim_efifb_bar(struct pci_dev *dev, int idx)
+{
+	u16 word;
+
+	pci_bar_found = true;
+
+	pci_read_config_word(dev, PCI_COMMAND, &word);
+	if (!(word & PCI_COMMAND_MEMORY)) {
+		pci_dev_disabled = true;
+		dev_err(&dev->dev,
+			"BAR %d: assigned to efifb but device is disabled!\n",
+			idx);
+		return;
+	}
+
+	if (pci_claim_resource(dev, idx)) {
+		pci_dev_disabled = true;
+		dev_err(&dev->dev,
+			"BAR %d: failed to claim resource for efifb!\n", idx);
+		return;
+	}
+
+	dev_info(&dev->dev, "BAR %d: assigned to efifb\n", idx);
+}
+
+static void efifb_fixup_resources(struct pci_dev *dev)
+{
+	u64 base = screen_info.lfb_base;
+	u64 size = screen_info.lfb_size;
+	int i;
+
+	if (pci_bar_found || screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
+		return;
+
+	if (screen_info.capabilities & VIDEO_CAPABILITY_64BIT_BASE)
+		base |= (u64)screen_info.ext_lfb_base << 32;
+
+	if (!base)
+		return;
+
+	for (i = 0; i < PCI_STD_RESOURCE_END; i++) {
+		struct resource *res = &dev->resource[i];
+
+		if (!(res->flags & IORESOURCE_MEM))
+			continue;
+
+		if (res->start <= base && res->end >= base + size - 1) {
+			claim_efifb_bar(dev, i);
+			break;
+		}
+	}
+}
+DECLARE_PCI_FIXUP_CLASS_HEADER(PCI_ANY_ID, PCI_ANY_ID, PCI_BASE_CLASS_DISPLAY,
+			       16, efifb_fixup_resources);
+
+#endif
-- 
2.9.3
