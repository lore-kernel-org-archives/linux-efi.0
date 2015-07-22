From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH 1/2] efi: parse vendor proprietary CPER section
Date: Wed, 22 Jul 2015 09:30:21 +0200
Message-ID: <20150722073021.GB7979@nazgul.tnic>
References: <1437521807-27571-1-git-send-email-zjzhang@codeaurora.org>
 <1437521807-27571-2-git-send-email-zjzhang@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1437521807-27571-2-git-send-email-zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, al.stone-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, mchehab-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linaro-acpi-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, vgandhi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Jul 21, 2015 at 04:36:46PM -0700, Jonathan (Zhixiong) Zhang wrote:
> From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> 
> UEFI spec allows for non-standard section in Common Platform Error
> Record. This is defined in section N.2.3 of UEFI version 2.5.
> 
> If Section Type field of Generic Error Data Entry indicates a
> non-standard section (eg. matchs a vendor proprietary GUID as defined
> in include/linux/cper.h), print out the raw data in hex in dmesg
> buffer. Data length is taken from Error Data length field of
> Generic Error Data Entry.
> 
> Following is a sample output from dmesg:
> {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 2
> {1}[Hardware Error]: It has been corrected by h/w and requires no further action
> {1}[Hardware Error]: event severity: corrected
> {1}[Hardware Error]:  Error 0, type: corrected
> {1}[Hardware Error]:  fru_id: 00000000-0000-0000-0000-000000000000
> {1}[Hardware Error]:  fru_text:
> {1}[Hardware Error]:   section_type: Qualcomm Technologies Inc. proprietary error
> {1}[Hardware Error]:   section length: 88
> {1}[Hardware Error]:   00000000: 01002011 20150416 01000001 00000002
> {1}[Hardware Error]:   00000010: 5f434345 525f4543 0000574d 00000000
> {1}[Hardware Error]:   00000020: 00000000 00000000 00000000 00000000
> {1}[Hardware Error]:   00000030: 00000000 00000000 00000000 00000000
> {1}[Hardware Error]:   00000040: 00000000 00000000 fe800000 00000000
> {1}[Hardware Error]:   00000050: 00000004 5f434345
> 
> ---
> checkpatch.pl gives following warnings on this patch:
>     WARNING: printk() should include KERN_ facility level
> This is a false warning as pfx parameter includes KERN_ facility
> level. Also such practice is consistent with the rest of the file.
> ---
> 
> Change-Id: I9a5bb6039beef1c0a36097765268b382e6a28498
> Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> ---
>  drivers/firmware/efi/cper.c | 61 +++++++++++++++++++++++++++++++++++++++++++--
>  include/linux/cper.h        |  4 +++
>  2 files changed, 63 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
> index 4fd9961d552e..29af8846ffd1 100644
> --- a/drivers/firmware/efi/cper.c
> +++ b/drivers/firmware/efi/cper.c
> @@ -32,12 +32,50 @@
>  #include <linux/acpi.h>
>  #include <linux/pci.h>
>  #include <linux/aer.h>
> +#include <linux/printk.h>
>  
>  #define INDENT_SP	" "
>  
> +#define ROW_SIZE 16
> +#define GROUP_SIZE 4
> +
> +struct sec_vendor {
> +	uuid_le         guid;
> +	const char      *name;
> +};
> +
> +static struct sec_vendor sec_vendors[] = {
> +	{CPER_SEC_QTI_ERR, "Qualcomm Technologies Inc. proprietary error"},
> +	{NULL_UUID_LE, NULL},
> +};

No, no vendor-specific stuff like that. This becomes a nightmare to
maintain...

> +
>  static char rcd_decode_str[CPER_REC_LEN];
>  
>  /*
> + * In case of CPER error record, there should be only two message
> + * levels: KERN_ERR and KERN_WARNING
> + */
> +static const char *cper_kern_level(const char *pfx)
> +{
> +	switch (printk_get_level(pfx)) {
> +	case '3': return KERN_ERR;
> +	case '4': return KERN_WARNING;
> +	default:  return KERN_DEFAULT;
> +	}


We already pass down const char *pfx - no need for retranslation.

> +
> +/*
> + * cper_print_hex - print hex from a binary buffer
> + * @pfx: prefix for each line, including log level and prefix string
> + * @buf: buffer pointer
> + * @len: size of buffer
> + */
> +#define cper_print_hex(pfx, buf, len)					\
> +	print_hex_dump(cper_kern_level(pfx), printk_skip_level(pfx),	\
> +		DUMP_PREFIX_OFFSET, ROW_SIZE, GROUP_SIZE,		\
> +		buf, len, 0)
> +
> +/*
>   * CPER record ID need to be unique even after reboot, because record
>   * ID is used as index for ERST storage, while CPER records from
>   * multiple boot may co-exist in ERST.
> @@ -379,6 +417,12 @@ static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
>  	pfx, pcie->bridge.secondary_status, pcie->bridge.control);
>  }
>  
> +static void cper_print_vendor(const char *pfx, __u8 *vendor_err, __u32 len)
> +{
> +	printk("%ssection length: %d\n", pfx, len);
> +	cper_print_hex(pfx, vendor_err, len);
> +}
> +
>  static void cper_estatus_print_section(
>  	const char *pfx, const struct acpi_hest_generic_data *gdata, int sec_no)
>  {
> @@ -416,9 +460,22 @@ static void cper_estatus_print_section(
>  			cper_print_pcie(newpfx, pcie, gdata);
>  		else
>  			goto err_section_too_small;
> -	} else
> +	} else {
> +		int i;
> +		__u8 *vendor_err = (void *)(gdata + 1);
> +
> +		for (i = 0; uuid_le_cmp(sec_vendors[i].guid,
> +		     NULL_UUID_LE); i++) {
> +			if (!uuid_le_cmp(*sec_type, sec_vendors[i].guid)) {
> +				printk("%ssection_type: %s", newpfx,
> +					sec_vendors[i].name);
> +				cper_print_vendor(newpfx, vendor_err,
> +					gdata->error_data_length);
> +				return;
> +			}
> +		}
>  		printk("%s""section type: unknown, %pUl\n", newpfx, sec_type);

... you simply dump the section in binary if none of the standard
UUIDs match. And you can then turn the "unknown" message into a
vendor-specific one.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
