From: Thomas Renninger <trenn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 1/2] ACPI ec_sys: Do not allow write access to EC in secure boot mode
Date: Wed,  7 Nov 2012 22:28:18 +0100
Message-ID: <1352323699-52400-2-git-send-email-trenn@suse.de>
References: <1352323699-52400-1-git-send-email-trenn@suse.de>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1352323699-52400-1-git-send-email-trenn-l3A5Bk7waGM@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jlee-IBi9RG/b67k@public.gmane.org, Thomas Renninger <trenn-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Signed-off-by: Thomas Renninger <trenn-l3A5Bk7waGM@public.gmane.org>
---
 drivers/acpi/ec_sys.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/ec_sys.c b/drivers/acpi/ec_sys.c
index 7586544..51dea3b 100644
--- a/drivers/acpi/ec_sys.c
+++ b/drivers/acpi/ec_sys.c
@@ -12,6 +12,8 @@
 #include <linux/acpi.h>
 #include <linux/debugfs.h>
 #include <linux/module.h>
+#include <linux/capability.h>
+
 #include "internal.h"
 
 MODULE_AUTHOR("Thomas Renninger <trenn-l3A5Bk7waGM@public.gmane.org>");
@@ -68,6 +70,9 @@ static ssize_t acpi_ec_write_io(struct file *f, const char __user *buf,
 	u8 *data = (u8 *) buf;
 	int err = 0;
 
+	if (!capable(CAP_COMPROMISE_KERNEL))
+		return -EPERM;
+
 	if (*off >= EC_SPACE_SIZE)
 		return 0;
 	if (*off + count >= EC_SPACE_SIZE) {
@@ -121,8 +126,13 @@ int acpi_ec_add_debugfs(struct acpi_ec *ec, unsigned int ec_device_count)
 				 (u32 *)&first_ec->global_lock))
 		goto error;
 
-	if (write_support)
-		mode = 0600;
+	if (write_support) {
+		if (!capable(CAP_COMPROMISE_KERNEL))
+			pr_err("No write access to EC\n");
+		else
+			mode = 0600;
+	}
+
 	if (!debugfs_create_file("io", mode, dev_dir, ec, &acpi_ec_io_ops))
 		goto error;
 
-- 
1.7.6.1
