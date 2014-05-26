From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] export efi.flags to sysfs
Date: Mon, 26 May 2014 16:39:35 +0800
Message-ID: <20140526083935.GA19682@dhcp-16-198.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


For efi=old_map and any old_map quirks like SGI UV in current
tree kexec/kdump will fail because it depends on the new 1:1 mapping.

Thus export the mapping method to sysfs so kexec tools can switch
to original way to boot.

Since we have efi.flags for all efi facilities so let's just export the
efi.flags itself, it maybe useful for other arches and use cases.

Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/firmware/efi/efi.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/drivers/firmware/efi/efi.c
===================================================================
--- linux-2.6.orig/drivers/firmware/efi/efi.c
+++ linux-2.6/drivers/firmware/efi/efi.c
@@ -86,16 +86,19 @@ static ssize_t name##_show(struct kobjec
 EFI_ATTR_SHOW(fw_vendor);
 EFI_ATTR_SHOW(runtime);
 EFI_ATTR_SHOW(config_table);
+EFI_ATTR_SHOW(flags);
 
 static struct kobj_attribute efi_attr_fw_vendor = __ATTR_RO(fw_vendor);
 static struct kobj_attribute efi_attr_runtime = __ATTR_RO(runtime);
 static struct kobj_attribute efi_attr_config_table = __ATTR_RO(config_table);
+static struct kobj_attribute efi_attr_flags = __ATTR_RO(flags);
 
 static struct attribute *efi_subsys_attrs[] = {
 	&efi_attr_systab.attr,
 	&efi_attr_fw_vendor.attr,
 	&efi_attr_runtime.attr,
 	&efi_attr_config_table.attr,
+	&efi_attr_flags.attr,
 	NULL,
 };
 
