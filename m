From: Steve McIntyre <steve-nt0JYOx6u4DQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Expose underlying UEFI firmware platform size to userland
Date: Fri,  9 Jan 2015 15:29:53 +0000
Message-ID: <1420817394-12922-1-git-send-email-steve@einval.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, Steve McIntyre <steve-nt0JYOx6u4DQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

In some cases (e.g. Intel Bay Trail machines), the kernel will happily
run in 64-bit even if the underlying UEFI firmware platform is
32-bit. That's great, but it's difficult for userland utilities like
grub-install to do the right thing in such a situation.

The kernel already knows about the size of the firmware via
efi_enabled(EFI_64BIT). Add an extra sysfs interface
/sys/firmware/efi/fw_platform_size to expose that information to
userland for low-level utilities to use.

Signed-off-by: Steve McIntyre <steve-nt0JYOx6u4DQT0dZR+AlfA@public.gmane.org>
---
 drivers/firmware/efi/efi.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 9035c1b..4495e3e 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -115,15 +115,24 @@ EFI_ATTR_SHOW(fw_vendor);
 EFI_ATTR_SHOW(runtime);
 EFI_ATTR_SHOW(config_table);
 
+static ssize_t fw_platform_size_show(struct kobject *kobj,
+				     struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", efi_enabled(EFI_64BIT) ? 64 : 32);
+}
+
 static struct kobj_attribute efi_attr_fw_vendor = __ATTR_RO(fw_vendor);
 static struct kobj_attribute efi_attr_runtime = __ATTR_RO(runtime);
 static struct kobj_attribute efi_attr_config_table = __ATTR_RO(config_table);
+static struct kobj_attribute efi_attr_fw_platform_size =
+	__ATTR_RO(fw_platform_size);
 
 static struct attribute *efi_subsys_attrs[] = {
 	&efi_attr_systab.attr,
 	&efi_attr_fw_vendor.attr,
 	&efi_attr_runtime.attr,
 	&efi_attr_config_table.attr,
+	&efi_attr_fw_platform_size.attr,
 	NULL,
 };
 
-- 
1.7.10.4
