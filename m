From: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] x86/efi: autoload efivars
Date: Wed,  9 Jul 2014 18:39:29 +0800
Message-ID: <1404902369-19434-1-git-send-email-jlee@suse.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The original patch is from Ben Hutchings's contribution to debian
kernel. Got Ben's permission to remove the code of efi-pstore.c and
send to linux-efi:
https://github.com/BlankOn/linux-debian/blob/master/debian/patches/features/all/efi-autoload-efivars.patch

efivars is generally useful to have on EFI systems, and in some cases
it may be impossible to load it after a kernel upgrade in order to
complete a boot loader update. At the same time we don't want to waste
memory on non-EFI systems by making them built-in.

Instead, give them module aliases as if they are platform drivers, and
register a corresponding platform device whenever EFI runtime services
are available.  This should trigger udev to load them.

v2:
Moving platform device register code to drivers/firmware/efi/efi.c
ARM64 folks could also benefit from it.

Cc: Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
---
 drivers/firmware/efi/efi.c     | 15 +++++++++++++++
 drivers/firmware/efi/efivars.c |  1 +
 2 files changed, 16 insertions(+)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index eff1a2f..6fee86b 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -23,6 +23,7 @@
 #include <linux/of.h>
 #include <linux/of_fdt.h>
 #include <linux/io.h>
+#include <linux/platform_device.h>
 
 struct efi __read_mostly efi = {
 	.mps        = EFI_INVALID_TABLE_ADDR,
@@ -321,6 +322,20 @@ int __init efi_config_init(efi_config_table_type_t *arch_tables)
 	return 0;
 }
 
+#ifdef CONFIG_EFI_VARS_MODULE
+static int __init efi_load_efivars(void)
+{
+	struct platform_device *pdev;
+
+	if (!efi_enabled(EFI_RUNTIME_SERVICES))
+		return 0;
+
+	pdev = platform_device_register_simple("efivars", 0, NULL, 0);
+	return IS_ERR(pdev) ? PTR_ERR(pdev) : 0;
+}
+device_initcall(efi_load_efivars);
+#endif
+
 #ifdef CONFIG_EFI_PARAMS_FROM_FDT
 
 #define UEFI_PARAM(name, prop, field)			   \
diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 463c565..f256ecd 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -78,6 +78,7 @@ MODULE_AUTHOR("Matt Domsch <Matt_Domsch-DYMqY+WieiM@public.gmane.org>");
 MODULE_DESCRIPTION("sysfs interface to EFI Variables");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(EFIVARS_VERSION);
+MODULE_ALIAS("platform:efivars");
 
 LIST_HEAD(efivar_sysfs_list);
 EXPORT_SYMBOL_GPL(efivar_sysfs_list);
-- 
1.8.4.5
