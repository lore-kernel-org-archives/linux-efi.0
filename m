From: Octavian Purdila <octavian.purdila@intel.com>
Subject: [PATCH v4 8/8] acpi: add support for loading SSDTs via configfs
Date: Fri, 17 Jun 2016 14:52:16 +0300
Message-ID: <1466164336-9508-9-git-send-email-octavian.purdila@intel.com>
References: <1466164336-9508-1-git-send-email-octavian.purdila@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1466164336-9508-1-git-send-email-octavian.purdila@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Brown <broonie@kernel.org>, Wolfram Sang <wsa@the-dreams.de>
Cc: Joel Becker <jlbec@evilplan.org>, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org, irina.tirdea@intel.com, leonard.crestez@intel.com, Octavian Purdila <octavian.purdila@intel.com>
List-Id: linux-efi@vger.kernel.org

New tables can be loaded by creating directories under /config/table/
and writing the AML code into the aml table attribute. Various table
attributes will be readable once the table is successfully loaded.

Unloading tables is not supported at the moment, but it can be easily
implemented once ACPI loading functions provide a table handle to be
used for unloading.

Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
---
 Documentation/ABI/testing/configfs-acpi |  29 +++++
 Documentation/acpi/ssdt-overlays.txt    |  14 +++
 drivers/acpi/configfs.c                 | 216 +++++++++++++++++++++++++++++++-
 3 files changed, 258 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/configfs-acpi b/Documentation/ABI/testing/configfs-acpi
index 17b19dc..4ab4e99 100644
--- a/Documentation/ABI/testing/configfs-acpi
+++ b/Documentation/ABI/testing/configfs-acpi
@@ -5,3 +5,32 @@ Contact:	linux-acpi@vger.kernel.org
 Description:
 		This represents the ACPI subsystem entry point directory. It
 		contains sub-groups corresponding to ACPI configurable options.
+
+What:		/config/acpi/table
+Date:		July 2016
+KernelVersion:	4.8
+Description:
+
+		This group contains the configuration for user defined ACPI
+		tables. The attributes of a user define table are:
+
+		aml 		- a binary attribute that the user can use to
+				fill in the ACPI aml definitions. Once the aml
+				data is written to this file and the file is
+				closed the table will be loaded and ACPI devices
+				will be enumerated. To check if the operation is
+				successful the user must check the error code
+				for close(). If the operation is successful,
+				subsequent writes to this attribute will fail.
+
+		The rest of the attributes are read-only and are valid only
+		after the table has been loaded by filling the aml entry:
+
+		signature 	- ASCII table signature
+		length 		- length of table in bytes, including the header
+		revision 	- ACPI Specification minor version number
+		oem_id 		- ASCII OEM identification
+		oem_table_id 	- ASCII OEM table identification
+		oem_revision 	- OEM revision number
+		asl_compiler_id - ASCII ASL compiler vendor ID
+		asl_compiler_revision - ASL compiler version
diff --git a/Documentation/acpi/ssdt-overlays.txt b/Documentation/acpi/ssdt-overlays.txt
index c4b57ba..5ae13f1 100644
--- a/Documentation/acpi/ssdt-overlays.txt
+++ b/Documentation/acpi/ssdt-overlays.txt
@@ -156,3 +156,17 @@ tmp=$(mktemp)
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
+writing the SSDT aml code in the aml attribute:
+
+cd /config/acpi/table
+mkdir my_ssdt
+cat ~/ssdt.aml > my_ssdt/aml
diff --git a/drivers/acpi/configfs.c b/drivers/acpi/configfs.c
index 44a72ff..135cc0e 100644
--- a/drivers/acpi/configfs.c
+++ b/drivers/acpi/configfs.c
@@ -8,11 +8,222 @@
  * the Free Software Foundation.
  */
 
+#define pr_fmt(fmt) "ACPI configfs: " fmt
+
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/configfs.h>
 #include <linux/acpi.h>
 
+static struct config_group *acpi_table_group;
+
+struct acpi_table {
+	struct config_item cfg;
+	struct acpi_table_header *header;
+};
+
+static ssize_t acpi_table_aml_write(struct config_item *cfg,
+				    const void *data, size_t size)
+{
+	const struct acpi_table_header *header = data;
+	struct acpi_table *table;
+	int ret;
+
+	table = container_of(cfg, struct acpi_table, cfg);
+
+	if (table->header) {
+		pr_err("table already loaded\n");
+		return -EBUSY;
+	}
+
+	if (header->length != size) {
+		pr_err("invalid table length\n");
+		return -EINVAL;
+	}
+
+	if (memcmp(header->signature, ACPI_SIG_SSDT, 4)) {
+		pr_err("invalid table signature\n");
+		return -EINVAL;
+	}
+
+	table = container_of(cfg, struct acpi_table, cfg);
+
+	table->header = kmemdup(header, header->length, GFP_KERNEL);
+	if (!table->header)
+		return -ENOMEM;
+
+	ret = acpi_load_table(table->header);
+	if (ret) {
+		kfree(table->header);
+		table->header = NULL;
+	}
+
+	return ret;
+}
+
+static inline struct acpi_table_header *get_header(struct config_item *cfg)
+{
+	struct acpi_table *table = container_of(cfg, struct acpi_table, cfg);
+
+	if (!table->header)
+		pr_err("table not loaded\n");
+
+	return table->header;
+}
+
+static ssize_t acpi_table_aml_read(struct config_item *cfg,
+				   void *data, size_t size)
+{
+	struct acpi_table_header *h = get_header(cfg);
+
+	if (!h)
+		return -EINVAL;
+
+	if (data)
+		memcpy(data, h, h->length);
+
+	return h->length;
+}
+
+#define MAX_ACPI_TABLE_SIZE (128 * 1024)
+
+CONFIGFS_BIN_ATTR(acpi_table_, aml, NULL, MAX_ACPI_TABLE_SIZE);
+
+struct configfs_bin_attribute *acpi_table_bin_attrs[] = {
+	&acpi_table_attr_aml,
+	NULL,
+};
+
+ssize_t acpi_table_signature_show(struct config_item *cfg, char *str)
+{
+	struct acpi_table_header *h = get_header(cfg);
+
+	if (!h)
+		return -EINVAL;
+
+	return sprintf(str, "%.*s\n", ACPI_NAME_SIZE, h->signature);
+}
+
+ssize_t acpi_table_length_show(struct config_item *cfg, char *str)
+{
+	struct acpi_table_header *h = get_header(cfg);
+
+	if (!h)
+		return -EINVAL;
+
+	return sprintf(str, "%d\n", h->length);
+}
+
+ssize_t acpi_table_revision_show(struct config_item *cfg, char *str)
+{
+	struct acpi_table_header *h = get_header(cfg);
+
+	if (!h)
+		return -EINVAL;
+
+	return sprintf(str, "%d\n", h->revision);
+}
+
+ssize_t acpi_table_oem_id_show(struct config_item *cfg, char *str)
+{
+	struct acpi_table_header *h = get_header(cfg);
+
+	if (!h)
+		return -EINVAL;
+
+	return sprintf(str, "%.*s\n", ACPI_OEM_ID_SIZE, h->oem_id);
+}
+
+ssize_t acpi_table_oem_table_id_show(struct config_item *cfg, char *str)
+{
+	struct acpi_table_header *h = get_header(cfg);
+
+	if (!h)
+		return -EINVAL;
+
+	return sprintf(str, "%.*s\n", ACPI_OEM_TABLE_ID_SIZE, h->oem_table_id);
+}
+
+ssize_t acpi_table_oem_revision_show(struct config_item *cfg, char *str)
+{
+	struct acpi_table_header *h = get_header(cfg);
+
+	if (!h)
+		return -EINVAL;
+
+	return sprintf(str, "%d\n", h->oem_revision);
+}
+
+ssize_t acpi_table_asl_compiler_id_show(struct config_item *cfg, char *str)
+{
+	struct acpi_table_header *h = get_header(cfg);
+
+	if (!h)
+		return -EINVAL;
+
+	return sprintf(str, "%.*s\n", ACPI_NAME_SIZE, h->asl_compiler_id);
+}
+
+ssize_t acpi_table_asl_compiler_revision_show(struct config_item *cfg,
+					      char *str)
+{
+	struct acpi_table_header *h = get_header(cfg);
+
+	if (!h)
+		return -EINVAL;
+
+	return sprintf(str, "%d\n", h->asl_compiler_revision);
+}
+
+CONFIGFS_ATTR_RO(acpi_table_, signature);
+CONFIGFS_ATTR_RO(acpi_table_, length);
+CONFIGFS_ATTR_RO(acpi_table_, revision);
+CONFIGFS_ATTR_RO(acpi_table_, oem_id);
+CONFIGFS_ATTR_RO(acpi_table_, oem_table_id);
+CONFIGFS_ATTR_RO(acpi_table_, oem_revision);
+CONFIGFS_ATTR_RO(acpi_table_, asl_compiler_id);
+CONFIGFS_ATTR_RO(acpi_table_, asl_compiler_revision);
+
+struct configfs_attribute *acpi_table_attrs[] = {
+	&acpi_table_attr_signature,
+	&acpi_table_attr_length,
+	&acpi_table_attr_revision,
+	&acpi_table_attr_oem_id,
+	&acpi_table_attr_oem_table_id,
+	&acpi_table_attr_oem_revision,
+	&acpi_table_attr_asl_compiler_id,
+	&acpi_table_attr_asl_compiler_revision,
+	NULL,
+};
+
+static struct config_item_type acpi_table_type = {
+	.ct_owner = THIS_MODULE,
+	.ct_bin_attrs = acpi_table_bin_attrs,
+	.ct_attrs = acpi_table_attrs,
+};
+
+static struct config_item *acpi_table_make_item(struct config_group *group,
+						const char *name)
+{
+	struct acpi_table *table;
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
 static struct config_item_type acpi_root_group_type = {
 	.ct_owner = THIS_MODULE,
 };
@@ -38,12 +249,15 @@ static int __init acpi_configfs_init(void)
 	if (ret)
 		return ret;
 
-	return 0;
+	acpi_table_group = configfs_register_default_group(root, "table",
+							   &acpi_tables_type);
+	return PTR_ERR_OR_ZERO(acpi_table_group);
 }
 module_init(acpi_configfs_init);
 
 static void __exit acpi_configfs_exit(void)
 {
+	configfs_unregister_default_group(acpi_table_group);
 	configfs_unregister_subsystem(&acpi_configfs);
 }
 module_exit(acpi_configfs_exit);
-- 
2.7.4
