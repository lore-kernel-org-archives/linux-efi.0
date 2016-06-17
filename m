From: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 7/8] acpi: add support for configfs
Date: Fri, 17 Jun 2016 14:52:15 +0300
Message-ID: <1466164336-9508-8-git-send-email-octavian.purdila@intel.com>
References: <1466164336-9508-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466164336-9508-1-git-send-email-octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-spi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Rafael J . Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>
Cc: Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, leonard.crestez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Register the ACPI subsystem with configfs.

Signed-off-by: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 Documentation/ABI/testing/configfs-acpi |  7 +++++
 MAINTAINERS                             |  1 +
 drivers/acpi/Kconfig                    |  9 ++++++
 drivers/acpi/Makefile                   |  1 +
 drivers/acpi/configfs.c                 | 53 +++++++++++++++++++++++++++++++++
 5 files changed, 71 insertions(+)
 create mode 100644 Documentation/ABI/testing/configfs-acpi
 create mode 100644 drivers/acpi/configfs.c

diff --git a/Documentation/ABI/testing/configfs-acpi b/Documentation/ABI/testing/configfs-acpi
new file mode 100644
index 0000000..17b19dc
--- /dev/null
+++ b/Documentation/ABI/testing/configfs-acpi
@@ -0,0 +1,7 @@
+What:		/config/acpi
+Date:		July 2016
+KernelVersion:	4.8
+Contact:	linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+Description:
+		This represents the ACPI subsystem entry point directory. It
+		contains sub-groups corresponding to ACPI configurable options.
diff --git a/MAINTAINERS b/MAINTAINERS
index 16700e4..9c5365f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -288,6 +288,7 @@ F:	include/linux/acpi.h
 F:	include/acpi/
 F:	Documentation/acpi/
 F:	Documentation/ABI/testing/sysfs-bus-acpi
+F:	Documentation/ABI/testing/configfs-acpi
 F:	drivers/pci/*acpi*
 F:	drivers/pci/*/*acpi*
 F:	drivers/pci/*/*/*acpi*
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index b7e2e77..a039433 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -521,4 +521,13 @@ config XPOWER_PMIC_OPREGION
 
 endif
 
+config ACPI_CONFIGFS
+	tristate "ACPI configfs support"
+	select CONFIGFS_FS
+	default n
+	help
+	  Select this option to enable support for ACPI configuration from
+	  userspace. The configurable ACPI groups will be visible under
+	  /config/acpi, assuming configfs is mounted under /config.
+
 endif	# ACPI
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 251ce85..1dc2173 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -99,5 +99,6 @@ obj-$(CONFIG_ACPI_EXTLOG)	+= acpi_extlog.o
 obj-$(CONFIG_PMIC_OPREGION)	+= pmic/intel_pmic.o
 obj-$(CONFIG_CRC_PMIC_OPREGION) += pmic/intel_pmic_crc.o
 obj-$(CONFIG_XPOWER_PMIC_OPREGION) += pmic/intel_pmic_xpower.o
+obj-$(CONFIG_ACPI_CONFIGFS)	+= configfs.o
 
 video-objs			+= acpi_video.o video_detect.o
diff --git a/drivers/acpi/configfs.c b/drivers/acpi/configfs.c
new file mode 100644
index 0000000..44a72ff
--- /dev/null
+++ b/drivers/acpi/configfs.c
@@ -0,0 +1,53 @@
+/*
+ * ACPI configfs support
+ *
+ * Copyright (c) 2015 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/configfs.h>
+#include <linux/acpi.h>
+
+static struct config_item_type acpi_root_group_type = {
+	.ct_owner = THIS_MODULE,
+};
+
+static struct configfs_subsystem acpi_configfs = {
+	.su_group = {
+		.cg_item = {
+			.ci_namebuf = "acpi",
+			.ci_type = &acpi_root_group_type,
+		},
+	},
+	.su_mutex = __MUTEX_INITIALIZER(acpi_configfs.su_mutex),
+};
+
+static int __init acpi_configfs_init(void)
+{
+	int ret;
+	struct config_group *root = &acpi_configfs.su_group;
+
+	config_group_init(root);
+
+	ret = configfs_register_subsystem(&acpi_configfs);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+module_init(acpi_configfs_init);
+
+static void __exit acpi_configfs_exit(void)
+{
+	configfs_unregister_subsystem(&acpi_configfs);
+}
+module_exit(acpi_configfs_exit);
+
+MODULE_AUTHOR("Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>");
+MODULE_DESCRIPTION("ACPI configfs support");
+MODULE_LICENSE("GPL v2");
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-spi" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
