From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH 7/8] efifb: show framebuffer layout as device attributes
Date: Tue, 18 Oct 2016 15:33:17 +0100
Message-ID: <20161018143318.15673-8-matt@codeblueprint.co.uk>
References: <20161018143318.15673-1-matt@codeblueprint.co.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161018143318.15673-1-matt@codeblueprint.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>
Cc: Peter Jones <pjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

From: Peter Jones <pjones@redhat.com>

Userland sometimes needs to know what the framebuffer configuration was
when the firmware was running. This enables us to render localized
status strings during firmware updates using the data from the ACPI BGRT
table and the protocol described at the url below:

https://msdn.microsoft.com/en-us/windows/hardware/drivers/bringup/boot-screen-components

This patch also fixes up efifb's printk() usage to use pr_warn() /
pr_info() / pr_err() instead.

Signed-off-by: Peter Jones <pjones@redhat.com>
Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/video/fbdev/efifb.c | 59 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 46 insertions(+), 13 deletions(-)

diff --git a/drivers/video/fbdev/efifb.c b/drivers/video/fbdev/efifb.c
index 924bad45c176..099b76b3e8b6 100644
--- a/drivers/video/fbdev/efifb.c
+++ b/drivers/video/fbdev/efifb.c
@@ -118,6 +118,31 @@ static inline bool fb_base_is_valid(void)
 	return false;
 }
 
+#define efifb_attr_decl(name, fmt)					\
+static ssize_t name##_show(struct device *dev,				\
+			   struct device_attribute *attr,		\
+			   char *buf)					\
+{									\
+	return sprintf(buf, fmt "\n", (screen_info.lfb_##name));	\
+}									\
+static DEVICE_ATTR_RO(name)
+
+efifb_attr_decl(base, "0x%x");
+efifb_attr_decl(linelength, "%u");
+efifb_attr_decl(height, "%u");
+efifb_attr_decl(width, "%u");
+efifb_attr_decl(depth, "%u");
+
+static struct attribute *efifb_attrs[] = {
+	&dev_attr_base.attr,
+	&dev_attr_linelength.attr,
+	&dev_attr_width.attr,
+	&dev_attr_height.attr,
+	&dev_attr_depth.attr,
+	NULL
+};
+ATTRIBUTE_GROUPS(efifb);
+
 static int efifb_probe(struct platform_device *dev)
 {
 	struct fb_info *info;
@@ -205,14 +230,13 @@ static int efifb_probe(struct platform_device *dev)
 	} else {
 		/* We cannot make this fatal. Sometimes this comes from magic
 		   spaces our resource handlers simply don't know about */
-		printk(KERN_WARNING
-		       "efifb: cannot reserve video memory at 0x%lx\n",
+		pr_warn("efifb: cannot reserve video memory at 0x%lx\n",
 			efifb_fix.smem_start);
 	}
 
 	info = framebuffer_alloc(sizeof(u32) * 16, &dev->dev);
 	if (!info) {
-		printk(KERN_ERR "efifb: cannot allocate framebuffer\n");
+		pr_err("efifb: cannot allocate framebuffer\n");
 		err = -ENOMEM;
 		goto err_release_mem;
 	}
@@ -230,16 +254,15 @@ static int efifb_probe(struct platform_device *dev)
 
 	info->screen_base = ioremap_wc(efifb_fix.smem_start, efifb_fix.smem_len);
 	if (!info->screen_base) {
-		printk(KERN_ERR "efifb: abort, cannot ioremap video memory "
-				"0x%x @ 0x%lx\n",
+		pr_err("efifb: abort, cannot ioremap video memory 0x%x @ 0x%lx\n",
 			efifb_fix.smem_len, efifb_fix.smem_start);
 		err = -EIO;
 		goto err_release_fb;
 	}
 
-	printk(KERN_INFO "efifb: framebuffer at 0x%lx, using %dk, total %dk\n",
+	pr_info("efifb: framebuffer at 0x%lx, using %dk, total %dk\n",
 	       efifb_fix.smem_start, size_remap/1024, size_total/1024);
-	printk(KERN_INFO "efifb: mode is %dx%dx%d, linelength=%d, pages=%d\n",
+	pr_info("efifb: mode is %dx%dx%d, linelength=%d, pages=%d\n",
 	       efifb_defined.xres, efifb_defined.yres,
 	       efifb_defined.bits_per_pixel, efifb_fix.line_length,
 	       screen_info.pages);
@@ -247,7 +270,7 @@ static int efifb_probe(struct platform_device *dev)
 	efifb_defined.xres_virtual = efifb_defined.xres;
 	efifb_defined.yres_virtual = efifb_fix.smem_len /
 					efifb_fix.line_length;
-	printk(KERN_INFO "efifb: scrolling: redraw\n");
+	pr_info("efifb: scrolling: redraw\n");
 	efifb_defined.yres_virtual = efifb_defined.yres;
 
 	/* some dummy values for timing to make fbset happy */
@@ -265,7 +288,7 @@ static int efifb_probe(struct platform_device *dev)
 	efifb_defined.transp.offset = screen_info.rsvd_pos;
 	efifb_defined.transp.length = screen_info.rsvd_size;
 
-	printk(KERN_INFO "efifb: %s: "
+	pr_info("efifb: %s: "
 	       "size=%d:%d:%d:%d, shift=%d:%d:%d:%d\n",
 	       "Truecolor",
 	       screen_info.rsvd_size,
@@ -285,12 +308,19 @@ static int efifb_probe(struct platform_device *dev)
 	info->fix = efifb_fix;
 	info->flags = FBINFO_FLAG_DEFAULT | FBINFO_MISC_FIRMWARE;
 
-	if ((err = fb_alloc_cmap(&info->cmap, 256, 0)) < 0) {
-		printk(KERN_ERR "efifb: cannot allocate colormap\n");
+	err = sysfs_create_groups(&dev->dev.kobj, efifb_groups);
+	if (err) {
+		pr_err("efifb: cannot add sysfs attrs\n");
 		goto err_unmap;
 	}
-	if ((err = register_framebuffer(info)) < 0) {
-		printk(KERN_ERR "efifb: cannot register framebuffer\n");
+	err = fb_alloc_cmap(&info->cmap, 256, 0);
+	if (err < 0) {
+		pr_err("efifb: cannot allocate colormap\n");
+		goto err_groups;
+	}
+	err = register_framebuffer(info);
+	if (err < 0) {
+		pr_err("efifb: cannot register framebuffer\n");
 		goto err_fb_dealoc;
 	}
 	fb_info(info, "%s frame buffer device\n", info->fix.id);
@@ -298,6 +328,8 @@ static int efifb_probe(struct platform_device *dev)
 
 err_fb_dealoc:
 	fb_dealloc_cmap(&info->cmap);
+err_groups:
+	sysfs_remove_groups(&dev->dev.kobj, efifb_groups);
 err_unmap:
 	iounmap(info->screen_base);
 err_release_fb:
@@ -313,6 +345,7 @@ static int efifb_remove(struct platform_device *pdev)
 	struct fb_info *info = platform_get_drvdata(pdev);
 
 	unregister_framebuffer(info);
+	sysfs_remove_groups(&pdev->dev.kobj, efifb_groups);
 	framebuffer_release(info);
 
 	return 0;
-- 
2.10.0
