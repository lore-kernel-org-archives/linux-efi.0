From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: [PATCH 4.9 25/69] efi/fb: Avoid reconfiguration of BAR that covers the framebuffer
Date: Wed, 19 Apr 2017 16:42:41 +0200
Message-ID: <20170419141617.990168205@linuxfoundation.org>
References: <20170419141616.919951169@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170419141616.919951169-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

4.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

commit 55d728a40d368ba80443be85c02e641fc9082a3f upstream.

On UEFI systems, the PCI subsystem is enumerated by the firmware,
and if a graphical framebuffer is exposed via a PCI device, its base
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

Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: lorenzo.pieralisi-5wv7dgnIgG8@public.gmane.org
Fixes: 9822504c1fa5 ("efifb: Enable the efi-framebuffer platform driver ...")
Link: http://lkml.kernel.org/r/20170404152744.26687-3-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Signed-off-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>

---
 drivers/video/fbdev/efifb.c |   66 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 65 insertions(+), 1 deletion(-)

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
@@ -118,6 +119,8 @@ static inline bool fb_base_is_valid(void
 	return false;
 }
 
+static bool pci_dev_disabled;	/* FB base matches BAR of a disabled device */
+
 static int efifb_probe(struct platform_device *dev)
 {
 	struct fb_info *info;
@@ -127,7 +130,7 @@ static int efifb_probe(struct platform_d
 	unsigned int size_total;
 	char *option = NULL;
 
-	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI)
+	if (screen_info.orig_video_isVGA != VIDEO_TYPE_EFI || pci_dev_disabled)
 		return -ENODEV;
 
 	if (fb_get_options("efifb", &option))
@@ -327,3 +330,64 @@ static struct platform_driver efifb_driv
 };
 
 builtin_platform_driver(efifb_driver);
+
+#if defined(CONFIG_PCI) && !defined(CONFIG_X86)
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
