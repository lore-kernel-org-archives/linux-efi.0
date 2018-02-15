From: Joe Konno <joe.konno-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 2/2] efi: restrict top-level attribute permissions
Date: Thu, 15 Feb 2018 10:22:08 -0800
Message-ID: <20180215182208.35003-3-joe.konno@linux.intel.com>
References: <20180215182208.35003-1-joe.konno@linux.intel.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180215182208.35003-1-joe.konno-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org, ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

From: Joe Konno <joe.konno-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Restrict four top-level (/sys/firmware/efi) attributes to match systab.
This is for consistency's sake, as well as hygiene.

Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Joe Konno <joe.konno-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efi/efi.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index cd42f66a7c85..9a1f6c85c8c7 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -167,11 +167,13 @@ static ssize_t fw_platform_size_show(struct kobject *kobj,
 	return sprintf(buf, "%d\n", efi_enabled(EFI_64BIT) ? 64 : 32);
 }
 
-static struct kobj_attribute efi_attr_fw_vendor = __ATTR_RO(fw_vendor);
-static struct kobj_attribute efi_attr_runtime = __ATTR_RO(runtime);
-static struct kobj_attribute efi_attr_config_table = __ATTR_RO(config_table);
+static struct kobj_attribute efi_attr_fw_vendor =
+	__ATTR_RO_MODE(fw_vendor, 0400);
+static struct kobj_attribute efi_attr_runtime = __ATTR_RO_MODE(runtime, 0400);
+static struct kobj_attribute efi_attr_config_table =
+	__ATTR_RO_MODE(config_table, 0400);
 static struct kobj_attribute efi_attr_fw_platform_size =
-	__ATTR_RO(fw_platform_size);
+	__ATTR_RO_MODE(fw_platform_size, 0400);
 
 static struct attribute *efi_subsys_attrs[] = {
 	&efi_attr_systab.attr,
-- 
2.14.1
