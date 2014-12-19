From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [RFC PATCH] Add esrt support.
Date: Fri, 19 Dec 2014 16:27:11 +0100
Message-ID: <20141219152711.GE7772@pd.tnic>
References: <20141211202119.GG17171@fenchurch.internal.datastacks.com>
 <1418329324-8975-1-git-send-email-pjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1418329324-8975-1-git-send-email-pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Dec 11, 2014 at 03:22:04PM -0500, Peter Jones wrote:
> Add sysfs files for EFI System Resource Table under
> /sys/firmware/efi/esrt and for each EFI System Resource Entry under
> entries/ as a subdir.
> 
> v2 with suggestions from bpetkov.
> v3 with me remembering checkpatch.
> v4 without me typing struct decls completely wrong somehow.
> 
> Signed-off-by: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Looks good, just minor nitpicks and some big-picture questions:

> ---
>  drivers/firmware/efi/Makefile |   2 +-
>  drivers/firmware/efi/efi.c    |  46 ++++-
>  drivers/firmware/efi/esrt.c   | 393 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/efi.h           |   6 +
>  4 files changed, 445 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/firmware/efi/esrt.c
> 
> diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
> index aef6a95..0d61089 100644
> --- a/drivers/firmware/efi/Makefile
> +++ b/drivers/firmware/efi/Makefile
> @@ -1,7 +1,7 @@
>  #
>  # Makefile for linux kernel
>  #
> -obj-$(CONFIG_EFI)			+= efi.o vars.o reboot.o
> +obj-$(CONFIG_EFI)			+= efi.o esrt.o vars.o reboot.o

Ok, so this enables it by default on CONFIG_EFI.

Since this is an addition to the spec and there are UEFIs without it,
maybe we should make it a default y Kconfig option...

Distros will enable it by default but we might still want to be able to
turn it off, if not required.

>  obj-$(CONFIG_EFI_VARS)			+= efivars.o
>  obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
>  obj-$(CONFIG_UEFI_CPER)			+= cper.o
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 8590099..68002d8 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -38,6 +38,7 @@ struct efi __read_mostly efi = {
>  	.fw_vendor  = EFI_INVALID_TABLE_ADDR,
>  	.runtime    = EFI_INVALID_TABLE_ADDR,
>  	.config_table  = EFI_INVALID_TABLE_ADDR,
> +	.esrt       = EFI_INVALID_TABLE_ADDR,
>  };
>  EXPORT_SYMBOL(efi);
>  
> @@ -63,7 +64,7 @@ static int __init parse_efi_cmdline(char *str)
>  }
>  early_param("efi", parse_efi_cmdline);
>  
> -static struct kobject *efi_kobj;
> +struct kobject *efi_kobj;
>  static struct kobject *efivars_kobj;
>  
>  /*
> @@ -92,6 +93,8 @@ static ssize_t systab_show(struct kobject *kobj,
>  		str += sprintf(str, "BOOTINFO=0x%lx\n", efi.boot_info);
>  	if (efi.uga != EFI_INVALID_TABLE_ADDR)
>  		str += sprintf(str, "UGA=0x%lx\n", efi.uga);
> +	if (efi.esrt != EFI_INVALID_TABLE_ADDR)
> +		str += sprintf(str, "ESRT=0x%lx\n", efi.esrt);
>  
>  	return str - buf;
>  }
> @@ -220,6 +223,46 @@ err_put:
>  
>  subsys_initcall(efisubsys_init);
>  
> +/*
> + * Given a physicall address, determine if it exists within an EFI Memory Map
> + * entry, and if so, how much of that map exists at a higher address.  That
> + * is, if this is the address of something in an EFI map, what's the highest
> + * address at which it's likely to end.
> + */
> +u64 efi_mem_max_reasonable_size(u64 phys_addr)

Ok, I'm reading your other explanation in the reply to my review and I
see what you mean. How about:

efi_sanity_check_table_region()

or so? A negative value means the table region is insane. :)

> +{
> +	struct efi_memory_map *map = efi.memmap;
> +	void *p, *e;
> +
> +	if (!map)
> +		return -1;
> +	if (WARN_ON(!map->phys_map))
> +		return -1;
> +	if (WARN_ON(map->nr_map == 0) || WARN_ON(map->desc_size == 0))
> +		return -1;

Pasting here the previous discussion:

>> If this is going to be called pretty often maybe use WARN_ON_ONCE().
>> Also, you probably want to return a negative value here so that caller
>> can stop further processing. I mean, it does so now too but a negative
>> value makes it more explicit.
>
> Yeah, the negative number is a good point.  Right now I think, if I make
> it stop iterating when that happens, then the WARN_ON won't be triggered
> more than once per piece of code using it.  Right now that's once piece
> of code.  I think even if it becomes more, that's probably the right thing,
> because it indicates the calling code has done something wrong with the
> data in the first place.

Just be careful so that this doesn't start spewing too much and filling
up logs. If you want to be able to debug this, you probably should turn
those checks in normal pr_warning() calls with the required information
needed for debugging. It'll be a lot less output than the WARN_ON splats.

> +	e = map->phys_map + map->nr_map * map->desc_size;
> +	for (p = map->phys_map; p < e; p += map->desc_size) {
> +		/*
> +		 * If a driver calls this after efi_free_boot_services,
> +		 * ->map will be NULL.
> +		 * So just always get our own virtual map on the CPU.
> +		 */
> +		efi_memory_desc_t *md = phys_to_virt((phys_addr_t)p);
> +		u64 size = md->num_pages << EFI_PAGE_SHIFT;
> +		u64 end = md->phys_addr + size;
> +
> +		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
> +		    md->type != EFI_BOOT_SERVICES_CODE &&
> +		    md->type != EFI_BOOT_SERVICES_DATA)
> +			continue;
> +		if (!md->virt_addr)
> +			continue;
> +		if (phys_addr >= md->phys_addr && phys_addr < end)
> +			return end - phys_addr;
> +	}
> +	return -1;
> +}
>  
>  /*
>   * We can't ioremap data in EFI boot services RAM, because we've already mapped
> @@ -261,6 +304,7 @@ static __initdata efi_config_table_type_t common_tables[] = {
>  	{SAL_SYSTEM_TABLE_GUID, "SALsystab", &efi.sal_systab},
>  	{SMBIOS_TABLE_GUID, "SMBIOS", &efi.smbios},
>  	{UGA_IO_PROTOCOL_GUID, "UGA", &efi.uga},
> +	{EFI_SYSTEM_RESOURCE_TABLE_GUID, "ESRT", &efi.esrt},
>  	{NULL_GUID, NULL, NULL},
>  };
>  
> diff --git a/drivers/firmware/efi/esrt.c b/drivers/firmware/efi/esrt.c
> new file mode 100644
> index 0000000..a58065b
> --- /dev/null
> +++ b/drivers/firmware/efi/esrt.c
> @@ -0,0 +1,393 @@
> +/*
> + * esrt.c
> + *
> + * This module exports EFI System Resource Table (ESRT) entries into userspace
> + * through the sysfs file system. The ESRT provides a read-only catalog of
> + * system components for which the system accepts firmware upgrades via UEFI's
> + * "Capsule Update" feature. This module allows userland utilities to evaluate
> + * what firmware updates can be applied to this system, and potentially arrange
> + * for those updates to occur.

Btw, another stupid question: are we going to use this interface to
upload capsules through too or how are we going to do UpdateCapsule()?

Or are the different subsystems/drivers going to provide their own
methods to upload capsules and we'll have a generic UEFI mechanism
for that which will do UpdateCapsule() in the end, similar to what
request_firmware* does nowadays.

You said something about preparing an UEFI binary to do the fw update on
the next reboot but have we thought about updating fw during runtime,
the way we do microcode updates?

Or this is not the use case and we're talking only about updating the
UEFI image itself?

> + *
> + * Data is currently found below /sys/firmware/efi/esrt/...
> + */
> +#define pr_fmt(fmt) "esrt: " fmt

...

> +/*
> + * ioremap the table, copy it to kmalloced pages, and unmap it.
> + */
> +static int esrt_duplicate_pages(void)
> +{
> +	struct efi_system_resource_table *tmpesrt;
> +	struct efi_system_resource_entry *entries;
> +	size_t size, max;
> +	int err = -EINVAL;
> +
> +	if (!esrt_table_exists())
> +		return err;
> +
> +	max = efi_mem_max_reasonable_size(efi.esrt);
> +	if (max < 0) {
> +		pr_err("ESRT header is not in the memory map.\n");
> +		return err;
> +	}
> +	size = sizeof(*esrt);
> +
> +	if (max < size) {
> +		pr_err("ESRT header doen't fit on single memory map entry.\n");
> +		return err;
> +	}
> +
> +	tmpesrt = ioremap(efi.esrt, size);
> +	if (!tmpesrt) {
> +		pr_err("ioremap failed.\n");
> +		return -ENOMEM;
> +	}
> +
> +	if (tmpesrt->fw_resource_count > 0 && max - size < sizeof(*entries)) {
> +		pr_err("ESRT memory map entry can only hold the header.\n");
> +		goto err_iounmap;
> +	}
> +
> +	/*
> +	 * The format doesn't really give us any boundary to test here,
> +	 * so I'm making up 128 as the max number of individually updatable
> +	 * components we support.
> +	 * 128 should be pretty excessive, but there's still some chance
> +	 * somebody will do that someday and we'll need to raise this.
> +	 */
> +	if (tmpesrt->fw_resource_count > 128) {

I guess we want that magic number 128 as a macro along with the comment
somewhere towards the beginning of this file. Something like

#define ERST_MAX_RESOURCES

or so.

> +		pr_err("ESRT says fw_resource_count has very large value %d.\n",

			"Resource count overflow" ?

> +		       tmpesrt->fw_resource_count);
> +		goto err_iounmap;
> +	}
> +
> +	/*
> +	 * We know it can't be larger than N * sizeof() here, and N is limited
> +	 * by the previous test to a small number, so there's no overflow.
> +	 */
> +	size += tmpesrt->fw_resource_count * sizeof(*entries);
> +	if (max < size) {
> +		pr_err("ESRT does not fit on single memory map entry.\n");
> +		goto err_iounmap;
> +	}
> +
> +	esrt = kmalloc(size, GFP_KERNEL);
> +	if (!esrt) {
> +		err = -ENOMEM;
> +		goto err_iounmap;
> +	}
> +
> +	memcpy(esrt, tmpesrt, size);
> +	err = 0;
> +err_iounmap:
> +	iounmap(tmpesrt);
> +	return err;
> +}
> +
> +static int register_entries(void)
> +{
> +	struct efi_system_resource_entry *entries = esrt->entries;
> +	int i, rc;
> +
> +	if (!esrt_table_exists())
> +		return 0;
> +
> +	for (i = 0; i < le32_to_cpu(esrt->fw_resource_count); i++) {
> +		rc = esre_create_sysfs_entry(&entries[i]);
> +		if (rc < 0) {
> +			pr_err("ESRT entry creation failed with error %d.\n",
> +			       rc);

No need for the linebreak here, just let it stick outta 80 cols.

> +			return rc;
> +		}
> +	}
> +	return 0;
> +}
> +
> +static void cleanup_entry_list(void)
> +{
> +	struct esre_entry *entry, *next;
> +
> +	list_for_each_entry_safe(entry, next, &entry_list, list) {
> +		kobject_put(&entry->kobj);
> +	}
> +}
> +
> +static int __init esrt_sysfs_init(void)
> +{
> +	int error;
> +
> +	error = esrt_duplicate_pages();
> +	if (error)
> +		return error;
> +
> +	esrt_kobj = kobject_create_and_add("esrt", efi_kobj);
> +	if (!esrt_kobj) {
> +		pr_err("Firmware table registration failed.\n");
> +		error = -ENOMEM;
> +		goto err;
> +	}
> +
> +	error = sysfs_create_group(esrt_kobj, &esrt_attr_group);
> +	if (error) {
> +		pr_err("Sysfs attribute export failed with error %d.\n",
> +		       error);

No need to break the line.

> +		goto err_remove_esrt;
> +	}
> +
> +	esrt_kset = kset_create_and_add("entries", NULL, esrt_kobj);
> +	if (!esrt_kset) {
> +		pr_err("kset creation failed.\n");
> +		error = -ENOMEM;
> +		goto err_remove_group;
> +	}
> +
> +	error = register_entries();
> +	if (error)
> +		goto err_cleanup_list;
> +
> +	pr_debug("esrt-sysfs: loaded.\n");
> +
> +	return 0;

newline here please.

> +err_cleanup_list:
> +	cleanup_entry_list();
> +	kset_unregister(esrt_kset);
> +err_remove_group:
> +	sysfs_remove_group(esrt_kobj, &esrt_attr_group);
> +err_remove_esrt:
> +	kobject_put(esrt_kobj);
> +err:
> +	kfree(esrt);
> +	esrt = NULL;
> +	return error;
> +}

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
