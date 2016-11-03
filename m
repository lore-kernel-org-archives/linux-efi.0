From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v3 2/3] x86/efi: Retrieve and assign Apple device
 properties
Date: Thu, 3 Nov 2016 23:31:00 +0000
Message-ID: <20161103233100.GC8845@codeblueprint.co.uk>
References: <cover.1478145888.git.lukas@wunner.de>
 <495c463bcb78131bf04ece648719fc8b3e9bd4ba.1478145888.git.lukas@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <495c463bcb78131bf04ece648719fc8b3e9bd4ba.1478145888.git.lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andreas Noever <andreas.noever-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Looks OK, just some minor comments below.

On Thu, 03 Nov, at 11:18:48AM, Lukas Wunner wrote:
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index cc69e37..ff01637 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -537,6 +537,63 @@ static void setup_efi_pci(struct boot_params *params)
>  	efi_call_early(free_pool, pci_handle);
>  }
>  
> +static void retrieve_apple_device_properties(struct boot_params *params)
> +{
> +	efi_guid_t guid = APPLE_PROPERTIES_PROTOCOL_GUID;
> +	struct setup_data *data, *new;
> +	efi_status_t status;
> +	void *properties;
> +	u32 size = 0;
> +
> +	status = efi_call_early(locate_protocol, &guid, NULL, &properties);
> +	if (status != EFI_SUCCESS)
> +		return;
> +
> +	if ((efi_is_64bit() ?
> +			((apple_properties_protocol_64 *)properties)->version :
> +			((apple_properties_protocol_32 *)properties)->version)
> +								   != 0x10000) {
> +		efi_printk(sys_table, "Unsupported properties proto version\n");
> +		return;
> +	}

It's a minor point, but please don't write the 32/64 code like this.
Either use two separate functions, like __file_size32() and
__file_size64(), or if that's two much code duplication stash the
version field and get_all pointer in stack-local variables at the
start of the function.

> +	efi_early->call(efi_is_64bit() ?
> +			((apple_properties_protocol_64 *)properties)->get_all :
> +			((apple_properties_protocol_32 *)properties)->get_all,
> +			properties, NULL, &size);
> +	if (!size)
> +		return;
> +
> +	do {
> +		status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
> +			size + sizeof(struct setup_data), &new);
> +		if (status != EFI_SUCCESS) {
> +			efi_printk(sys_table,
> +				   "Failed to alloc mem for properties\n");
> +			return;
> +		}

Newline here please.

> +		status = efi_early->call(efi_is_64bit() ?
> +			((apple_properties_protocol_64 *)properties)->get_all :
> +			((apple_properties_protocol_32 *)properties)->get_all,
> +			properties, new->data, &size);

And a newline here.

> +		if (status == EFI_BUFFER_TOO_SMALL)
> +			efi_call_early(free_pool, new);
> +	} while (status == EFI_BUFFER_TOO_SMALL);
> +
> +	new->type = SETUP_APPLE_PROPERTIES;
> +	new->len  = size;
> +	new->next = 0;
> +
> +	data = (struct setup_data *)(unsigned long)params->hdr.setup_data;
> +	if (!data)
> +		params->hdr.setup_data = (unsigned long)new;
> +	else {
> +		while (data->next)
> +			data = (struct setup_data *)(unsigned long)data->next;
> +		data->next = (unsigned long)new;
> +	}
> +}
> +
>  static efi_status_t
>  setup_uga32(void **uga_handle, unsigned long size, u32 *width, u32 *height)
>  {
> @@ -1068,6 +1125,7 @@ static efi_status_t exit_boot(struct boot_params *boot_params,
>  struct boot_params *efi_main(struct efi_config *c,
>  			     struct boot_params *boot_params)
>  {
> +	efi_char16_t const apple[] = { 'A', 'p', 'p', 'l', 'e', 0 };
>  	struct desc_ptr *gdt = NULL;
>  	efi_loaded_image_t *image;
>  	struct setup_header *hdr = &boot_params->hdr;
> @@ -1098,6 +1156,11 @@ struct boot_params *efi_main(struct efi_config *c,
>  
>  	setup_efi_pci(boot_params);
>  
> +	if (!memcmp((void *)sys_table->fw_vendor, apple, sizeof(apple))) {
> +		if (IS_ENABLED(CONFIG_APPLE_PROPERTIES))
> +			retrieve_apple_device_properties(boot_params);
> +	}
> +
>  	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
>  				sizeof(*gdt), (void **)&gdt);
>  	if (status != EFI_SUCCESS) {

Could you split this off into a setup_apple_properties() function to
mirror setup_efi_pci()?

> diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
> index c18ce67..b10bf31 100644
> --- a/arch/x86/include/uapi/asm/bootparam.h
> +++ b/arch/x86/include/uapi/asm/bootparam.h
> @@ -7,6 +7,7 @@
>  #define SETUP_DTB			2
>  #define SETUP_PCI			3
>  #define SETUP_EFI			4
> +#define SETUP_APPLE_PROPERTIES		5
>  
>  /* ram_size flags */
>  #define RAMDISK_IMAGE_START_MASK	0x07FF
> diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
> index 893fda4..2e78b0b 100644
> --- a/drivers/firmware/efi/Kconfig
> +++ b/drivers/firmware/efi/Kconfig
> @@ -129,6 +129,19 @@ config EFI_TEST
>  	  Say Y here to enable the runtime services support via /dev/efi_test.
>  	  If unsure, say N.
>  
> +config APPLE_PROPERTIES
> +	bool "Apple Device Properties"
> +	depends on EFI_STUB && X86
> +	select EFI_DEV_PATH_PARSER
> +	select UCS2_STRING
> +	help
> +	  Retrieve properties from EFI on Apple Macs and assign them to
> +	  devices, allowing for improved support of Apple hardware.
> +	  Properties that would otherwise be missing include the
> +	  Thunderbolt Device ROM and GPU configuration data.
> +
> +	  If unsure, say Y if you have a Mac.  Otherwise N.
> +
>  endmenu
>  
>  config UEFI_CPER
> diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
> index 3e91ae3..ad67342 100644
> --- a/drivers/firmware/efi/Makefile
> +++ b/drivers/firmware/efi/Makefile
> @@ -22,6 +22,7 @@ obj-$(CONFIG_EFI_FAKE_MEMMAP)		+= fake_mem.o
>  obj-$(CONFIG_EFI_BOOTLOADER_CONTROL)	+= efibc.o
>  obj-$(CONFIG_EFI_TEST)			+= test/
>  obj-$(CONFIG_EFI_DEV_PATH_PARSER)	+= dev-path-parser.o
> +obj-$(CONFIG_APPLE_PROPERTIES)		+= apple-properties.o
>  
>  arm-obj-$(CONFIG_EFI)			:= arm-init.o arm-runtime.o
>  obj-$(CONFIG_ARM)			+= $(arm-obj-y)
> diff --git a/drivers/firmware/efi/apple-properties.c b/drivers/firmware/efi/apple-properties.c
> new file mode 100644
> index 0000000..3b4d6a2
> --- /dev/null
> +++ b/drivers/firmware/efi/apple-properties.c
> @@ -0,0 +1,239 @@
> +/*
> + * apple-properties.c - EFI device properties on Macs
> + * Copyright (C) 2016 Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License (version 2) as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#define pr_fmt(fmt) "apple-properties: " fmt
> +
> +#include <linux/bootmem.h>
> +#include <linux/dmi.h>
> +#include <linux/efi.h>
> +#include <linux/property.h>
> +#include <linux/slab.h>
> +#include <linux/ucs2_string.h>
> +#include <asm/setup.h>
> +
> +static bool dump_properties __initdata;
> +
> +static int __init dump_properties_enable(char *arg)
> +{
> +	dump_properties = true;
> +	return 0;
> +}
> +
> +__setup("dump_apple_properties", dump_properties_enable);
> +
> +struct dev_header {
> +	u32 len;
> +	u32 prop_count;
> +	struct efi_dev_path path[0];
> +	/*
> +	 * followed by key/value pairs, each key and value preceded by u32 len,
> +	 * len includes itself, value may be empty (in which case its len is 4)
> +	 */
> +};
> +
> +struct properties_header {
> +	u32 len;
> +	u32 version;
> +	u32 dev_count;
> +	struct dev_header dev_header[0];
> +};
> +
> +static u8 one __initdata = 1;
> +
> +static void __init unmarshal_key_value_pairs(struct dev_header *dev_header,
> +					     struct device *dev, void *ptr,
> +					     struct property_entry entry[])
> +{
> +	int i;
> +
> +	for (i = 0; i < dev_header->prop_count; i++) {
> +		int remaining = dev_header->len - (ptr - (void *)dev_header);
> +		u32 key_len, val_len;
> +		char *key;
> +
> +		if (sizeof(key_len) > remaining)
> +			break;
> +		key_len = *(typeof(key_len) *)ptr;
> +		if (key_len + sizeof(val_len) > remaining ||
> +		    key_len < sizeof(key_len) + sizeof(efi_char16_t) ||
> +		    *(efi_char16_t *)(ptr + sizeof(key_len)) == 0) {
> +			dev_err(dev, "invalid property name len at %#zx\n",
> +				ptr - (void *)dev_header);
> +			break;
> +		}
> +		val_len = *(typeof(val_len) *)(ptr + key_len);
> +		if (key_len + val_len > remaining ||
> +		    val_len < sizeof(val_len)) {
> +			dev_err(dev, "invalid property val len at %#zx\n",
> +				ptr - (void *)dev_header + key_len);
> +			break;
> +		}

Please sprinkle a few newlines to make this more readable.

> +
> +		key = kzalloc((key_len - sizeof(key_len)) * 4 + 1, GFP_KERNEL);
> +		if (!key) {
> +			dev_err(dev, "cannot allocate property name\n");
> +			break;
> +		}

Could you add a comment to document the kzalloc() size argument above?

> +		ucs2_as_utf8(key, ptr + sizeof(key_len),
> +			     key_len - sizeof(key_len));
> +
> +		entry[i].name = key;
> +		entry[i].is_array = true;
> +		entry[i].length = val_len - sizeof(val_len);
> +		entry[i].pointer.raw_data = ptr + key_len + sizeof(val_len);
> +		if (!entry[i].length) {
> +			/* driver core doesn't accept empty properties */
> +			entry[i].length = 1;
> +			entry[i].pointer.raw_data = &one;
> +		}
> +
> +		if (dump_properties) {
> +			dev_info(dev, "property: %s\n", entry[i].name);
> +			print_hex_dump(KERN_INFO, pr_fmt(), DUMP_PREFIX_OFFSET,
> +				16, 1, entry[i].pointer.raw_data,
> +				entry[i].length, true);
> +		}
> +
> +		ptr += key_len + val_len;
> +	}
> +
> +	if (i != dev_header->prop_count) {
> +		dev_err(dev, "got %d device properties, expected %u\n", i,
> +			dev_header->prop_count);
> +		print_hex_dump(KERN_ERR, pr_fmt(), DUMP_PREFIX_OFFSET,
> +			16, 1, dev_header, dev_header->len, true);
> +	} else
> +		dev_info(dev, "assigning %d device properties\n", i);

Mismatched braces are frowned upon in the CodingStyle guide. Please
use braces for both the 'if' and 'else'. Alternatively, return early
for one of the conditions (and save a level of indentation too).

> +}
> +
> +static int __init unmarshal_devices(struct properties_header *properties)
> +{
> +	size_t offset = offsetof(struct properties_header, dev_header[0]);
> +
> +	while (offset + sizeof(struct dev_header) < properties->len) {
> +		struct dev_header *dev_header = (void *)properties + offset;
> +		struct property_entry *entry = NULL;
> +		struct device *dev;
> +		size_t len;
> +		int ret, i;
> +		void *ptr;
> +
> +		if (offset + dev_header->len > properties->len ||
> +		    dev_header->len <= sizeof(*dev_header)) {
> +			pr_err("invalid len in dev_header at %#zx\n", offset);
> +			return -EINVAL;
> +		}
> +
> +		ptr = dev_header->path;
> +		len = dev_header->len - sizeof(*dev_header);

Newline please.

> +		dev = efi_get_device_by_path((struct efi_dev_path **)&ptr, &len);
> +		if (IS_ERR(dev)) {
> +			pr_err("device path parse error %ld at %#zx:\n",
> +			       PTR_ERR(dev), ptr - (void *)dev_header);
> +			print_hex_dump(KERN_ERR, pr_fmt(), DUMP_PREFIX_OFFSET,
> +			       16, 1, dev_header, dev_header->len, true);
> +			dev = NULL;
> +			goto skip_device;
> +		}
> +
> +		entry = kcalloc(dev_header->prop_count + 1, sizeof(*entry),
> +				GFP_KERNEL);
> +		if (!entry) {
> +			dev_err(dev, "cannot allocate properties\n");
> +			goto skip_device;
> +		}
> +
> +		unmarshal_key_value_pairs(dev_header, dev, ptr, entry);
> +		if (!entry[0].name)
> +			goto skip_device;
> +
> +		ret = device_add_properties(dev, entry); /* makes deep copy */
> +		if (ret)
> +			dev_err(dev, "error %d assigning properties\n", ret);

Newline.

> +		for (i = 0; entry[i].name; i++)
> +			kfree(entry[i].name);
> +
> +skip_device:
> +		kfree(entry);
> +		put_device(dev);
> +		offset += dev_header->len;
> +	}
> +
> +	return 0;
> +}
> +
> +static int __init map_properties(void)
> +{
> +	struct properties_header *properties;
> +	struct setup_data *data;
> +	u32 data_len;
> +	u64 pa_data;
> +	int ret;
> +
> +	if (!dmi_match(DMI_SYS_VENDOR, "Apple Inc.") &&
> +	    !dmi_match(DMI_SYS_VENDOR, "Apple Computer, Inc."))
> +		return 0;
> +
> +	pa_data = boot_params.hdr.setup_data;
> +	while (pa_data) {
> +		data = ioremap(pa_data, sizeof(*data));
> +		if (!data) {
> +			pr_err("cannot map setup_data header\n");
> +			return -ENOMEM;
> +		}
> +
> +		if (data->type != SETUP_APPLE_PROPERTIES) {
> +			pa_data = data->next;
> +			iounmap(data);
> +			continue;
> +		}
> +
> +		data_len = data->len;
> +		iounmap(data);

Newline.

> +		data = ioremap(pa_data, sizeof(*data) + data_len);
> +		if (!data) {
> +			pr_err("cannot map setup_data payload\n");
> +			return -ENOMEM;
> +		}
> +
> +		properties = (struct properties_header *)data->data;
> +		if (properties->version != 1) {
> +			pr_err("unsupported version:\n");
> +			print_hex_dump(KERN_ERR, pr_fmt(), DUMP_PREFIX_OFFSET,
> +			       16, 1, properties, data_len, true);
> +			ret = -ENOTSUPP;
> +		} else if (properties->len != data_len) {
> +			pr_err("length mismatch, expected %u\n", data_len);
> +			print_hex_dump(KERN_ERR, pr_fmt(), DUMP_PREFIX_OFFSET,
> +			       16, 1, properties, data_len, true);
> +			ret = -EINVAL;
> +		} else
> +			ret = unmarshal_devices(properties);
> +
> +		/*
> +		 * can only free the setup_data payload but not its header
> +		 * to avoid breaking the chain of ->next pointers
> +		 */

Multi-line comments should begin with capital letters and end with
full-stops.

> +		data->len = 0;
> +		iounmap(data);
> +		free_bootmem_late(pa_data + sizeof(*data), data_len);

Newline.

> +		return ret;
> +	}
> +	return 0;
> +}
> +
> +fs_initcall(map_properties);
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 2617672..88f343f 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -443,6 +443,22 @@ typedef struct {
>  #define EFI_PCI_IO_ATTRIBUTE_VGA_PALETTE_IO_16 0x20000
>  #define EFI_PCI_IO_ATTRIBUTE_VGA_IO_16 0x40000
>  
> +typedef struct {
> +	u32 version;
> +	u32 get;
> +	u32 set;
> +	u32 del;
> +	u32 get_all;
> +} apple_properties_protocol_32;
> +
> +typedef struct {
> +	u64 version;
> +	u64 get;
> +	u64 set;
> +	u64 del;
> +	u64 get_all;
> +} apple_properties_protocol_64;
> +

Please append a '_t' to both of these so it's obvious they're types.

>  /*
>   * Types and defines for EFI ResetSystem
>   */
> @@ -592,6 +608,7 @@ void efi_native_runtime_setup(void);
>  #define EFI_RNG_ALGORITHM_RAW			EFI_GUID(0xe43176d7, 0xb6e8, 0x4827,  0xb7, 0x84, 0x7f, 0xfd, 0xc4, 0xb6, 0x85, 0x61)
>  #define EFI_MEMORY_ATTRIBUTES_TABLE_GUID	EFI_GUID(0xdcfa911d, 0x26eb, 0x469f,  0xa2, 0x20, 0x38, 0xb7, 0xdc, 0x46, 0x12, 0x20)
>  #define EFI_CONSOLE_OUT_DEVICE_GUID		EFI_GUID(0xd3b36f2c, 0xd551, 0x11d4,  0x9a, 0x46, 0x00, 0x90, 0x27, 0x3f, 0xc1, 0x4d)
> +#define APPLE_PROPERTIES_PROTOCOL_GUID		EFI_GUID(0x91bd12fe, 0xf6c3, 0x44fb,  0xa5, 0xb7, 0x51, 0x22, 0xab, 0x30, 0x3a, 0xe0)
>  
>  /*
>   * This GUID is used to pass to the kernel proper the struct screen_info
> -- 
> 2.10.1
> 
