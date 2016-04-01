From: "Zheng, Lv" <lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC PATCH 10/10] acpi: add support for loading SSDTs via
 configfs
Date: Fri, 1 Apr 2016 04:55:41 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E883BB66233@SHSMSX101.ccr.corp.intel.com>
References: <1459417026-6697-1-git-send-email-octavian.purdila@intel.com>
 <1459417026-6697-11-git-send-email-octavian.purdila@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1459417026-6697-11-git-send-email-octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>
Cc: Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Tirdea, Irina" <irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Purdila, Octavian" <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi,

> From: linux-acpi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-acpi-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Octavian Purdila
> Subject: [RFC PATCH 10/10] acpi: add support for loading SSDTs via configfs
> 
> Add support for acpi_user_table configfs items that allows the user to
> load new tables. The data attributes contains the table data and once it
> is filled from userspace the table is loaded and ACPI devices are
> enumerated.
[Lv Zheng] 
We've been considering to implement this facility before.
The 2 alternative solutions are:
1. implement LOAD/UNLOAD ioctl for /sys/kernel/debug/acpi/acpidbg - this will be useful for extracting AML byte stream from kernel to be used by a userspace disassembler.
2. transition /sys/firmware/acpi/tables/xxx into directory and implement /sys/firmware/acpi/tables/load, /sys/firmware/acpi/tables/unload - this should be able to meet your requirement.

So my first question is:
Why do you use configfs rather than the existing mechanisms?

> 
> Signed-off-by: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  Documentation/ABI/testing/configfs-acpi |  16 +++++
>  Documentation/acpi/ssdt-overlays.txt    |  14 +++++
>  drivers/acpi/configfs.c                 | 104 ++++++++++++++++++++++++++++++++
>  3 files changed, 134 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/configfs-acpi
> b/Documentation/ABI/testing/configfs-acpi
> index 0c806aa..34a205e 100644
> --- a/Documentation/ABI/testing/configfs-acpi
> +++ b/Documentation/ABI/testing/configfs-acpi
> @@ -5,3 +5,19 @@ Contact:	linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>  Description:
>  		This represents the ACPI subsystem entry point directory. It
>  		contains sub-groups corresponding to ACPI configurable
> options.
> +
> +What:		/config/acpi/table
> +Date:		April 2016
> +KernelVersion:	4.6
> +Description:
> +
> +		This group contains the configuration for user defined ACPI
> +		tables. The attributes of a user define table are:
> +
> +		data - a binary write only attribute that the user can use to
> +		       fill in the ACPI aml definitions. Once the aml data is
> +		       written to this file and the file is closed the table
> +		       will be loaded and ACPI device will be enumerated. To
> +		       check if the operation is successful the user must check
> +		       the error code for close(). If the operation is
> +		       successful, subsequent writes to this attribute will fail.
> diff --git a/Documentation/acpi/ssdt-overlays.txt b/Documentation/acpi/ssdt-
> overlays.txt
> index 7c588be..a88a2ce 100644
> --- a/Documentation/acpi/ssdt-overlays.txt
> +++ b/Documentation/acpi/ssdt-overlays.txt
> @@ -158,3 +158,17 @@ tmp=$(mktemp)
>  /bin/echo -ne "\007\000\000\000" | cat - $filename > $tmp
>  dd if=$tmp of="$EFIVARFS/$name-$guid" bs=$(stat -c %s $tmp)
>  rm $tmp
> +
> +== Loading ACPI SSDTs from configfs ==
> +
> +This option allows loading of user defined SSDTs from userspace via the
> configfs
> +interface. The CONFIG_ACPI_CONFIGFS option must be select and configfs
> must be
> +mounted. In the following examples, we assume that configfs has been
> mounted in
> +/config.
> +
> +New tables can be loading by creating new directories in /config/acpi/table/
> and
> +writing the SSDT aml code in the data attribute:
> +
> +cd /config/acpi/table
> +mkdir my_ssdt
> +cat ~/ssdt.aml > my_ssdt/data
[Lv Zheng] 
Good to see the table as a directory.
So that we can put more attributes under it.

Thanks
-Lv

> diff --git a/drivers/acpi/configfs.c b/drivers/acpi/configfs.c
> index 96aa3d8..3a194806 100644
> --- a/drivers/acpi/configfs.c
> +++ b/drivers/acpi/configfs.c
> @@ -13,6 +13,104 @@
>  #include <linux/configfs.h>
>  #include <linux/acpi.h>
> 
> +static struct config_group *acpi_table_group;
> +
> +struct acpi_user_table {
> +	struct config_item cfg;
> +	struct acpi_table_header *table;
> +};
> +
> +static ssize_t acpi_table_data_write(struct config_item *cfg,
> +				     const void *data, size_t size)
> +{
> +	struct acpi_table_header *header = (struct acpi_table_header *)data;
> +	struct acpi_user_table *table;
> +	int ret;
> +
> +	table = container_of(cfg, struct acpi_user_table, cfg);
> +
> +	if (table->table) {
> +		pr_err("ACPI configfs table: table already loaded\n");
> +		return -EBUSY;
> +	}
> +
> +	if (header->length != size) {
> +		pr_err("ACPI configfs table: invalid table length\n");
> +		return -EINVAL;
> +	}
> +
> +	if (memcmp(header->signature, ACPI_SIG_SSDT, 4)) {
> +		pr_err("ACPI configfs table: invalid table signature\n");
> +		return -EINVAL;
> +	}
> +
> +	table = container_of(cfg, struct acpi_user_table, cfg);
> +
> +	table->table = kmemdup(header, header->length, GFP_KERNEL);
> +	if (!table->table)
> +		return -ENOMEM;
> +
> +	ret = acpi_load_table(table->table);
> +	if (ret) {
> +		kfree(table->table);
> +		table->table = NULL;
> +	}
> +
> +	add_taint(TAINT_OVERLAY_ACPI_TABLE, LOCKDEP_STILL_OK);
> +
> +	return ret;
> +}
> +
> +#define MAX_ACPI_TABLE_SIZE (128 * 1024)
> +
> +CONFIGFS_BIN_ATTR_WO(acpi_table_, data, NULL, MAX_ACPI_TABLE_SIZE);
> +
> +struct configfs_bin_attribute *acpi_table_bin_attrs[] = {
> +	&acpi_table_attr_data,
> +	NULL,
> +};
> +
> +static struct config_item_type acpi_table_type = {
> +	.ct_owner = THIS_MODULE,
> +	.ct_bin_attrs = acpi_table_bin_attrs,
> +};
> +
> +static struct config_item *acpi_table_make_item(struct config_group *group,
> +						const char *name)
> +{
> +	struct acpi_user_table *table;
> +
> +	table = kzalloc(sizeof(*table), GFP_KERNEL);
> +	if (!table)
> +		return ERR_PTR(-ENOMEM);
> +
> +	config_item_init_type_name(&table->cfg, name, &acpi_table_type);
> +	return &table->cfg;
> +}
> +
> +struct configfs_group_operations acpi_table_group_ops = {
> +	.make_item = acpi_table_make_item,
> +};
> +
> +static struct config_item_type acpi_tables_type = {
> +	.ct_owner = THIS_MODULE,
> +	.ct_group_ops = &acpi_table_group_ops,
> +};
> +
> +static struct config_item_type acpi_root_group_type = {
> +	.ct_owner	= THIS_MODULE,
> +};
> +
> +static struct configfs_subsystem acpi_configfs = {
> +	.su_group = {
> +		.cg_item = {
> +			.ci_namebuf = "acpi",
> +			.ci_type = &acpi_root_group_type,
> +		},
> +	},
> +	.su_mutex = __MUTEX_INITIALIZER(acpi_configfs.su_mutex),
> +};
> +
>  static int __init acpi_configfs_init(void)
>  {
>  	int ret;
> @@ -24,12 +122,18 @@ static int __init acpi_configfs_init(void)
>  	if (ret)
>  		return ret;
> 
> +	acpi_table_group = configfs_register_default_group(root, "table",
> +							   &acpi_tables_type);
> +	if (IS_ERR(acpi_table_group))
> +		return PTR_ERR(acpi_table_group);
> +
>  	return 0;
>  }
>  module_init(acpi_configfs_init);
> 
>  static void __exit acpi_configfs_exit(void)
>  {
> +	configfs_unregister_default_group(acpi_table_group);
>  	configfs_unregister_subsystem(&acpi_configfs);
>  }
>  module_exit(acpi_configfs_exit);
> --
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
