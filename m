From: Octavian Purdila <octavian.purdila@intel.com>
Subject: [RFC PATCH v2 08/10] acpi: add support for configfs
Date: Wed, 20 Apr 2016 01:39:06 +0300
Message-ID: <1461105548-20618-9-git-send-email-octavian.purdila@intel.com>
References: <1461105548-20618-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-i2c-owner@vger.kernel.org>
In-Reply-To: <1461105548-20618-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-i2c-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Brown <broonie@kernel.org>, Wolfram Sang <wsa@the-dreams.de>
Cc: Joel Becker <jlbec@evilplan.org>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org, irina.tirdea@intel.com, Octavian Purdila <octavian.purdila@intel.com>
List-Id: linux-efi@vger.kernel.org

Register the ACPI subsystem with configfs.

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 Documentation/ABI/testing/configfs-acpi |  7 ++++++
 MAINTAINERS                             |  1 +
 drivers/acpi/Kconfig                    |  9 ++++++++
 drivers/acpi/Makefile                   |  1 +
 drivers/acpi/configfs.c                 | 39 +++++++++++++++++++++++++++++++++
 5 files changed, 57 insertions(+)
 create mode 100644 Documentation/ABI/testing/configfs-acpi
 create mode 100644 drivers/acpi/configfs.c

diff --git a/Documentation/ABI/testing/configfs-acpi b/Documentation/ABI/testing/configfs-acpi
new file mode 100644
index 0000000..0c806aa
--- /dev/null
+++ b/Documentation/ABI/testing/configfs-acpi
@@ -0,0 +1,7 @@
+What:		/config/acpi
+Date:		April 2016
+KernelVersion:	4.6
+Contact:	linux-acpi@vger.kernel.org
+Description:
+		This represents the ACPI subsystem entry point directory. It
+		contains sub-groups corresponding to ACPI configurable options.
diff --git a/MAINTAINERS b/MAINTAINERS
index 1c32f8a..6695648 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -289,6 +289,7 @@ F:	include/linux/acpi.h
 F:	include/acpi/
 F:	Documentation/acpi/
 F:	Documentation/ABI/testing/sysfs-bus-acpi
+F:	Documentation/ABI/testing/configfs-acpi
 F:	drivers/pci/*acpi*
 F:	drivers/pci/*/*acpi*
 F:	drivers/pci/*/*/*acpi*
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 82b96ee..7d02816 100644
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
index edeb2d1..319e63d 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -98,5 +98,6 @@ obj-$(CONFIG_ACPI_EXTLOG)	+= acpi_extlog.o
 obj-$(CONFIG_PMIC_OPREGION)	+= pmic/intel_pmic.o
 obj-$(CONFIG_CRC_PMIC_OPREGION) += pmic/intel_pmic_crc.o
 obj-$(CONFIG_XPOWER_PMIC_OPREGION) += pmic/intel_pmic_xpower.o
+obj-$(CONFIG_ACPI_CONFIGFS)	+= configfs.o
 
 video-objs			+= acpi_video.o video_detect.o
diff --git a/drivers/acpi/configfs.c b/drivers/acpi/configfs.c
new file mode 100644
index 0000000..96aa3d8
--- /dev/null
+++ b/drivers/acpi/configfs.c
@@ -0,0 +1,39 @@
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
+MODULE_AUTHOR("Octavian Purdila <octavian.purdila@intel.com>");
+MODULE_DESCRIPTION("ACPI configfs support");
+MODULE_LICENSE("GPL v2");
-- 
1.9.1
