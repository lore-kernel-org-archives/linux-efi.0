From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v2 2/5] efi: provide a generic efi_config_init()
Date: Mon, 5 Aug 2013 13:15:40 +0100
Message-ID: <20130805121540.GP2515@console-pimps.org>
References: <1375462582-16423-1-git-send-email-leif.lindholm@linaro.org>
 <1375462582-16423-3-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1375462582-16423-3-git-send-email-leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 02 Aug, at 05:56:19PM, Leif Lindholm wrote:
> Common to (U)EFI support on all platforms is the global "efi" data
> structure, and the code that parses the System Table to locate
> addresses to populate that structure with.
> 
> This patch adds both of these to the global EFI driver code.
> 
> Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/efi.c |  106 ++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/efi.h        |    7 +++
>  2 files changed, 113 insertions(+)

[...]

> +static __init int match_config_table(efi_guid_t *guid,
> +				     unsigned long table,
> +				     efi_config_table_type_t *table_types)
> +{
> +	u8 str[38];

Shouldn't this be 37? You get 36 bytes for your GUID, plus a trailing
NUL? Either way, this should be a #define. The closest thing we have in
include/linux/efi.h is EFI_VARIABLE_GUID_LEN. Perhaps we need a
EFI_GUID_LEN that includes the trailing NUL?

> +	int i;
> +
> +	if (table_types) {
> +		efi_guid_unparse(guid, str);
> +
> +		for (i = 0; efi_guidcmp(table_types[i].guid, NULL_GUID); i++) {
> +			efi_guid_unparse(&table_types[i].guid, str);
> +
> +			if (!efi_guidcmp(*guid, table_types[i].guid)) {
> +				*(table_types[i].ptr) = table;
> +				pr_cont(" %s=0x%lx ",
> +					table_types[i].name, table);
> +				return 1;
> +			}
> +		}
> +	}
> +
> +	return 0;
> +}

One thing I just noticed that's worth pointing out is that 'pr_fmt'
isn't defined in drivers/firmware/efi/efi.c. Before your patch series
you get,

[    0.000000] efi:  SMBIOS=0xbae41a98  ACPI=0xbac6f000  ACPI 2.0=0xbac6f000  MPS=0xfca90 

and after,

[    0.000000]  SMBIOS=0xbae41a98  ACPI=0xbac6f000  ACPI 2.0=0xbac6f000 MPS=0xfca90 

which isn't the end of the world, but it does mean that the error
messages are now much less informative, e.g.

> +	config_tables = early_memremap(efi.systab->tables,
> +				       efi.systab->nr_tables * sz);
> +	if (config_tables == NULL) {
> +		pr_err("could not map configuration table!\n");
> +		return -ENOMEM;
> +	}

Which goes from,

  efi: could not map configuration table!

to become,

  could not map configuration table!

-- 
Matt Fleming, Intel Open Source Technology Center
