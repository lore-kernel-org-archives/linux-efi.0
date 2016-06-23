From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v4 6/8] efi: load SSTDs from EFI variables
Date: Thu, 23 Jun 2016 14:22:37 +0100
Message-ID: <20160623132237.GG8415@codeblueprint.co.uk>
References: <1466164336-9508-1-git-send-email-octavian.purdila@intel.com>
 <1466164336-9508-7-git-send-email-octavian.purdila@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1466164336-9508-7-git-send-email-octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Rafael J . Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>, Joel Becker <jlbec-aKy9MeLSZ9dg9hUCZPvPmw@public.gmane.org>, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-spi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, leonard.crestez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 17 Jun, at 02:52:14PM, Octavian Purdila wrote:
> This patch allows SSDTs to be loaded from EFI variables. It works by
> specifying the EFI variable name containing the SSDT to be loaded. All
> variables with the same name (regardless of the vendor GUID) will be
> loaded.
> 
> Note that we can't use acpi_install_table and we must rely on the
> dynamic ACPI table loading and bus re-scanning mechanisms. That is
> because I2C/SPI controllers are initialized earlier then the EFI
> subsystems and all I2C/SPI ACPI devices are enumerated when the
> I2C/SPI controllers are initialized.
> 
> Signed-off-by: Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  Documentation/acpi/ssdt-overlays.txt |  67 ++++++++++++++++++++++
>  Documentation/kernel-parameters.txt  |   7 +++
>  drivers/firmware/efi/efi.c           | 106 +++++++++++++++++++++++++++++++++++
>  3 files changed, 180 insertions(+)

[...]

> @@ -195,6 +197,107 @@ static void generic_ops_unregister(void)
>  	efivars_unregister(&generic_efivars);
>  }
>  
> +#if IS_ENABLED(CONFIG_ACPI)
> +#define EFIVAR_SSDT_NAME_MAX	16
> +static char efivar_ssdt[EFIVAR_SSDT_NAME_MAX];
> +static int __init efivar_ssdt_setup(char *str)
> +{
> +	if (strlen(str) < sizeof(efivar_ssdt))
> +		memcpy(efivar_ssdt, str, strlen(str));
> +	else
> +		pr_warn("efivar_ssdt: name too long: %s\n", str);
> +	return 0;
> +}
> +__setup("efivar_ssdt=", efivar_ssdt_setup);
> +
> +static LIST_HEAD(efivar_ssdts);
> +
> +static inline void pr_efivar_name(efi_char16_t *name16)
> +{
> +	char name[EFIVAR_SSDT_NAME_MAX];
> +	int i;
> +
> +	for (i = 0; i < EFIVAR_SSDT_NAME_MAX - 1; i++)
> +		name[i] = name16[i] & 0xFF;
> +	name[i] = 0;
> +	pr_cont("%s", name);
> +}

Please use the various ucs2_* functions we already have in lib/.

> +static __init int efivar_acpi_iter(efi_char16_t *name, efi_guid_t vendor,
> +				   unsigned long name_size, void *data)
> +{
> +	int i;
> +	int str_len = name_size / sizeof(efi_char16_t);
> +	struct efivar_entry *entry;
> +
> +	if (str_len != strlen(efivar_ssdt) + 1)
> +		return 0;
> +
> +	for (i = 0; i < str_len; i++)
> +		if ((name[i] & 0xFF) != efivar_ssdt[i])
> +			return 0;
> +
> +	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> +	if (!entry)
> +		return -ENOMEM;
> +
> +	memcpy(entry->var.VariableName, name, name_size);
> +	memcpy(&entry->var.VendorGuid, &vendor, sizeof(efi_guid_t));
> +
> +	efivar_entry_add(entry, &efivar_ssdts);
> +
> +	return 0;
> +}
> +
> +static __init int efivar_ssdt_load(void)
> +{
> +	struct efivar_entry *i;
> +	int err;
> +
> +	err = efivar_init(efivar_acpi_iter, NULL, true, &efivar_ssdts);
> +	if (err) {
> +		pr_err("%s: efivar_init failed: %d\n", __func__, err);
> +		return err;
> +	}
> +
> +	list_for_each_entry(i, &efivar_ssdts, list) {
> +		void *data;
> +		unsigned long size;
> +
> +		pr_info("loading SSDT from EFI variable ");
> +		pr_efivar_name(i->var.VariableName); pr_cont("\n");
> +
> +		err = efivar_entry_size(i, &size);
> +		if (err) {
> +			pr_err("failed to get size\n");
> +			continue;
> +		}
> +
> +		data = kmalloc(size, GFP_KERNEL);
> +		if (!data)
> +			continue;
> +
> +		err = efivar_entry_get(i, NULL, &size, data);
> +		if (err) {
> +			pr_err("failed to get data\n");
> +			kfree(data);
> +			continue;
> +		}
> +
> +		err = acpi_load_table(data);
> +		if (err) {
> +			pr_err("failed to load table: %d\n", err);
> +			kfree(data);
> +			continue;
> +		}
> +	}
> +

Since 'efivar_ssdts' isn't exported to userspace and is never
traversed again after its built in efivar_acpi_iter(), can't you just
fold the code from the above list_for_each_entry() loop into
efivar_acpi_iter()?

You should be able to call efivar_entry_get() without 'entry' actually
being on any list since the list is only used for duplicate variable
detection in this case.
