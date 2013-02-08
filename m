From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [RFC][PATCH 6/7] efi: Add generic variable operations
Date: Fri,  8 Feb 2013 20:59:17 +0000
Message-ID: <1360357158-8168-7-git-send-email-matt@console-pimps.org>
References: <1360357158-8168-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1360357158-8168-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Some machines have an EFI variable interface that does not conform to
the UEFI specification, e.g. CONFIG_GOOGLE_SMI. Add the necessary code
and Kconfig glue so that it's only possible to choose one set of EFI
variable operations.

Cc: Mike Waychison <mikew-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efi/Kconfig       | 12 +++++++++
 drivers/firmware/efi/Makefile      |  1 +
 drivers/firmware/efi/generic-ops.c | 52 ++++++++++++++++++++++++++++++++++++++
 drivers/firmware/efivars.c         | 19 +-------------
 drivers/firmware/google/Kconfig    |  6 ++---
 5 files changed, 69 insertions(+), 21 deletions(-)
 create mode 100644 drivers/firmware/efi/generic-ops.c

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index f664de2..e83ef8f 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -12,9 +12,21 @@ config EFI_VARS
 
 	  If unsure, say N.
 
+config EFI_VARS_GENERIC_OPS
+	bool "Generic EFI Variable Operations"
+	depends on EFI_VARS
+	default y
+	help
+	  This option enables the use of the generic EFI variable
+	  operations, those that are compliant with the UEFI
+	  specification.
+
+	  If unsure, say Y.
+
 config EFI_VARS_SYSFS
 	tristate "EFI Variable Support via sysfs"
 	depends on EFI_VARS
+	depends on EFI_VARS_GENERIC_OPS || GOOGLE_SMI
 	default n
 	help
 	  If you say Y here, you are able to get EFI (Extensible Firmware
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 0b8d7e0..ef5066f 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -3,3 +3,4 @@
 #
 obj-$(CONFIG_EFI_VARS_SYSFS)		+= sysfs.o
 obj-$(CONFIG_EFI_VARS_PSTORE)		+= pstore.o
+obj-$(CONFIG_EFI_VARS_GENERIC_OPS)	+= generic-ops.o
diff --git a/drivers/firmware/efi/generic-ops.c b/drivers/firmware/efi/generic-ops.c
new file mode 100644
index 0000000..b474800
--- /dev/null
+++ b/drivers/firmware/efi/generic-ops.c
@@ -0,0 +1,52 @@
+/*
+ * Copyright (C) 2013 Intel Corporation <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/efi.h>
+#include <linux/kconfig.h>
+
+extern struct kobject *efi_kobj;
+
+static struct efivars generic_efivars;
+static struct efivar_operations generic_ops;
+
+int generic_register(void)
+{
+	int error;
+
+	generic_ops.get_variable = efi.get_variable;
+	generic_ops.set_variable = efi.set_variable;
+	generic_ops.get_next_variable = efi.get_next_variable;
+	generic_ops.query_variable_info = efi.query_variable_info;
+
+	error = efivars_register(&generic_efivars, &generic_ops);
+	if (error)
+		return error;
+
+#if defined(CONFIG_EFI_VARS_SYSFS) || defined(CONFIG_EFI_VARS_SYSFS_MODULE)
+	efivars_sysfs_init(efi_kobj);
+#endif
+	return 0;
+}
+
+void generic_unregister(void)
+{
+	efivars_unregister(&generic_efivars);
+}
+
+module_init(generic_register);
+module_exit(generic_unregister);
diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index eaaddae..c2275b8 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -40,9 +40,6 @@
 
 #include <asm/uaccess.h>
 
-static struct efivars generic_efivars;
-static struct efivar_operations generic_ops;
-
 /* Private pointer to registered efivars */
 static struct efivars *__efivars;
 
@@ -791,7 +788,7 @@ static struct attribute_group efi_subsys_attr_group = {
 	.attrs = efi_subsys_attrs,
 };
 
-static struct kobject *efi_kobj;
+struct kobject *efi_kobj;
 
 /**
  * efivar_init - build the initial list of EFI variables
@@ -1358,19 +1355,6 @@ efivars_init(void)
 		return -ENOMEM;
 	}
 
-	generic_ops.get_variable = efi.get_variable;
-	generic_ops.set_variable = efi.set_variable;
-	generic_ops.get_next_variable = efi.get_next_variable;
-	generic_ops.query_variable_info = efi.query_variable_info;
-
-	error = efivars_register(&generic_efivars, &generic_ops);
-	if (error)
-		return error;
-
-#if defined(CONFIG_EFI_VARS_SYSFS) || defined(CONFIG_EFI_VARS_SYSFS_MODULE)
-	efivars_sysfs_init(efi_kobj);
-#endif
-
 	efivars_kobject = kobject_create_and_add("efivars", efi_kobj);
 	if (!efivars_kobject) {
 		pr_err("efivars: Subsystem registration failed.\n");
@@ -1395,7 +1379,6 @@ static void __exit
 efivars_exit(void)
 {
 	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
-		efivars_unregister(&generic_efivars);
 		kobject_put(efivars_kobject);
 		kobject_put(efi_kobj);
 	}
diff --git a/drivers/firmware/google/Kconfig b/drivers/firmware/google/Kconfig
index 2f21b0b..8928044 100644
--- a/drivers/firmware/google/Kconfig
+++ b/drivers/firmware/google/Kconfig
@@ -12,9 +12,9 @@ menu "Google Firmware Drivers"
 
 config GOOGLE_SMI
 	tristate "SMI interface for Google platforms"
-	depends on ACPI && DMI
-	select EFI
-	select EFI_VARS
+	depends on ACPI && DMI && EFI
+	depends on !EFI_VARS_GENERIC_OPS
+	select EFI_VARS_SYSFS
 	help
 	  Say Y here if you want to enable SMI callbacks for Google
 	  platforms.  This provides an interface for writing to and
-- 
1.7.11.7
