From: Octavian Purdila <octavian.purdila@intel.com>
Subject: [RFC PATCH 10/10] acpi: add support for loading SSDTs via configfs
Date: Thu, 31 Mar 2016 12:37:06 +0300
Message-ID: <1459417026-6697-11-git-send-email-octavian.purdila@intel.com>
References: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Brown <broonie@kernel.org>, Wolfram Sang <wsa@the-dreams.de>
Cc: Joel Becker <jlbec@evilplan.org>, Christoph Hellwig <hch@lst.de>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org, irina.tirdea@intel.com, Octavian Purdila <octavian.purdila@intel.com>
List-Id: linux-efi@vger.kernel.org

Add support for acpi_user_table configfs items that allows the user to
load new tables. The data attributes contains the table data and once it
is filled from userspace the table is loaded and ACPI devices are
enumerated.

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 Documentation/ABI/testing/configfs-acpi |  16 +++++
 Documentation/acpi/ssdt-overlays.txt    |  14 +++++
 drivers/acpi/configfs.c                 | 104 ++++++++++++++++++++++++++++++++
 3 files changed, 134 insertions(+)

diff --git a/Documentation/ABI/testing/configfs-acpi b/Documentation/ABI/testing/configfs-acpi
index 0c806aa..34a205e 100644
--- a/Documentation/ABI/testing/configfs-acpi
+++ b/Documentation/ABI/testing/configfs-acpi
@@ -5,3 +5,19 @@ Contact:	linux-acpi@vger.kernel.org
 Description:
 		This represents the ACPI subsystem entry point directory. It
 		contains sub-groups corresponding to ACPI configurable options.
+
+What:		/config/acpi/table
+Date:		April 2016
+KernelVersion:	4.6
+Description:
+
+		This group contains the configuration for user defined ACPI
+		tables. The attributes of a user define table are:
+
+		data - a binary write only attribute that the user can use to
+		       fill in the ACPI aml definitions. Once the aml data is
+		       written to this file and the file is closed the table
+		       will be loaded and ACPI device will be enumerated. To
+		       check if the operation is successful the user must check
+		       the error code for close(). If the operation is
+		       successful, subsequent writes to this attribute will fail.
diff --git a/Documentation/acpi/ssdt-overlays.txt b/Documentation/acpi/ssdt-overlays.txt
index 7c588be..a88a2ce 100644
--- a/Documentation/acpi/ssdt-overlays.txt
+++ b/Documentation/acpi/ssdt-overlays.txt
@@ -158,3 +158,17 @@ tmp=$(mktemp)
 /bin/echo -ne "\007\000\000\000" | cat - $filename > $tmp
 dd if=$tmp of="$EFIVARFS/$name-$guid" bs=$(stat -c %s $tmp)
 rm $tmp
+
+== Loading ACPI SSDTs from configfs ==
+
+This option allows loading of user defined SSDTs from userspace via the configfs
+interface. The CONFIG_ACPI_CONFIGFS option must be select and configfs must be
+mounted. In the following examples, we assume that configfs has been mounted in
+/config.
+
+New tables can be loading by creating new directories in /config/acpi/table/ and
+writing the SSDT aml code in the data attribute:
+
+cd /config/acpi/table
+mkdir my_ssdt
+cat ~/ssdt.aml > my_ssdt/data
diff --git a/drivers/acpi/configfs.c b/drivers/acpi/configfs.c
index 96aa3d8..3a194806 100644
--- a/drivers/acpi/configfs.c
+++ b/drivers/acpi/configfs.c
@@ -13,6 +13,104 @@
 #include <linux/configfs.h>
 #include <linux/acpi.h>
 
+static struct config_group *acpi_table_group;
+
+struct acpi_user_table {
+	struct config_item cfg;
+	struct acpi_table_header *table;
+};
+
+static ssize_t acpi_table_data_write(struct config_item *cfg,
+				     const void *data, size_t size)
+{
+	struct acpi_table_header *header = (struct acpi_table_header *)data;
+	struct acpi_user_table *table;
+	int ret;
+
+	table = container_of(cfg, struct acpi_user_table, cfg);
+
+	if (table->table) {
+		pr_err("ACPI configfs table: table already loaded\n");
+		return -EBUSY;
+	}
+
+	if (header->length != size) {
+		pr_err("ACPI configfs table: invalid table length\n");
+		return -EINVAL;
+	}
+
+	if (memcmp(header->signature, ACPI_SIG_SSDT, 4)) {
+		pr_err("ACPI configfs table: invalid table signature\n");
+		return -EINVAL;
+	}
+
+	table = container_of(cfg, struct acpi_user_table, cfg);
+
+	table->table = kmemdup(header, header->length, GFP_KERNEL);
+	if (!table->table)
+		return -ENOMEM;
+
+	ret = acpi_load_table(table->table);
+	if (ret) {
+		kfree(table->table);
+		table->table = NULL;
+	}
+
+	add_taint(TAINT_OVERLAY_ACPI_TABLE, LOCKDEP_STILL_OK);
+
+	return ret;
+}
+
+#define MAX_ACPI_TABLE_SIZE (128 * 1024)
+
+CONFIGFS_BIN_ATTR_WO(acpi_table_, data, NULL, MAX_ACPI_TABLE_SIZE);
+
+struct configfs_bin_attribute *acpi_table_bin_attrs[] = {
+	&acpi_table_attr_data,
+	NULL,
+};
+
+static struct config_item_type acpi_table_type = {
+	.ct_owner = THIS_MODULE,
+	.ct_bin_attrs = acpi_table_bin_attrs,
+};
+
+static struct config_item *acpi_table_make_item(struct config_group *group,
+						const char *name)
+{
+	struct acpi_user_table *table;
+
+	table = kzalloc(sizeof(*table), GFP_KERNEL);
+	if (!table)
+		return ERR_PTR(-ENOMEM);
+
+	config_item_init_type_name(&table->cfg, name, &acpi_table_type);
+	return &table->cfg;
+}
+
+struct configfs_group_operations acpi_table_group_ops = {
+	.make_item = acpi_table_make_item,
+};
+
+static struct config_item_type acpi_tables_type = {
+	.ct_owner = THIS_MODULE,
+	.ct_group_ops = &acpi_table_group_ops,
+};
+
+static struct config_item_type acpi_root_group_type = {
+	.ct_owner	= THIS_MODULE,
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
 static int __init acpi_configfs_init(void)
 {
 	int ret;
@@ -24,12 +122,18 @@ static int __init acpi_configfs_init(void)
 	if (ret)
 		return ret;
 
+	acpi_table_group = configfs_register_default_group(root, "table",
+							   &acpi_tables_type);
+	if (IS_ERR(acpi_table_group))
+		return PTR_ERR(acpi_table_group);
+
 	return 0;
 }
 module_init(acpi_configfs_init);
 
 static void __exit acpi_configfs_exit(void)
 {
+	configfs_unregister_default_group(acpi_table_group);
 	configfs_unregister_subsystem(&acpi_configfs);
 }
 module_exit(acpi_configfs_exit);
-- 
1.9.1
