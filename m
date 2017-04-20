From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH V15 02/11] ras: acpi/apei: cper: add support for generic
 data v3 structure
Date: Thu, 20 Apr 2017 13:14:51 +0200
Message-ID: <20170420111451.6mo4o2oulwal3j33@pd.tnic>
References: <1492556723-9189-1-git-send-email-tbaicar@codeaurora.org>
 <1492556723-9189-3-git-send-email-tbaicar@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1492556723-9189-3-git-send-email-tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, james.morse-5wv7dgnIgG8@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, eun.taik.lee-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, sandeepa.s.prabhu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, shijie.huang-5wv7dgnIgG8@public.gmane.org, rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, tn-nYOzD4b6Jr9Wk0Htik3J/w@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 18, 2017 at 05:05:14PM -0600, Tyler Baicar wrote:
> The ACPI 6.1 spec adds a new version of the generic data structure.

which data structure? HEST?

> Add support to handle the new structure as well as properly verify
> and iterate through the generic data entries.
> 
> Signed-off-by: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> CC: Jonathan (Zhixiong) Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> Reviewed-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
> Reviewed-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

This is clearly a new version of the patch so Reviewed-by tags don't
apply anymore. Ditto for the next one. Remember to remove such tags in
the future when the patches are changed non-trivially in a following
iteration.

> ---
>  drivers/acpi/apei/ghes.c    |  6 +++---
>  drivers/firmware/efi/cper.c | 37 ++++++++++++++++++++++---------------
>  include/acpi/ghes.h         | 22 ++++++++++++++++++++++
>  3 files changed, 47 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index 6d87ab7..dfb7dd2 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -429,7 +429,7 @@ static void ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata, int
>  	int flags = -1;
>  	int sec_sev = ghes_severity(gdata->error_severity);
>  	struct cper_sec_mem_err *mem_err;
> -	mem_err = (struct cper_sec_mem_err *)(gdata + 1);
> +	mem_err = acpi_hest_get_payload(gdata);

        struct cper_sec_mem_err *mem_err = acpi_hest_get_payload(gdata);

while you're at it.

>  	if (!(mem_err->validation_bits & CPER_MEM_VALID_PA))
>  		return;
> @@ -466,7 +466,7 @@ static void ghes_do_proc(struct ghes *ghes,
>  		if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
>  				 CPER_SEC_PLATFORM_MEM)) {
>  			struct cper_sec_mem_err *mem_err;
> -			mem_err = (struct cper_sec_mem_err *)(gdata+1);
> +			mem_err = acpi_hest_get_payload(gdata);

Ditto

+ add a \n here.

>  			ghes_edac_report_mem_error(ghes, sev, mem_err);
>  
>  			arch_apei_report_mem_error(sev, mem_err);
> @@ -476,7 +476,7 @@ static void ghes_do_proc(struct ghes *ghes,
>  		else if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
>  				      CPER_SEC_PCIE)) {
>  			struct cper_sec_pcie *pcie_err;
> -			pcie_err = (struct cper_sec_pcie *)(gdata+1);
> +			pcie_err = acpi_hest_get_payload(gdata);

Ditto.

>  			if (sev == GHES_SEV_RECOVERABLE &&
>  			    sec_sev == GHES_SEV_RECOVERABLE &&
>  			    pcie_err->validation_bits & CPER_PCIE_VALID_DEVICE_ID &&
> diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
> index d425374..8328a6f 100644
> --- a/drivers/firmware/efi/cper.c
> +++ b/drivers/firmware/efi/cper.c
> @@ -32,6 +32,7 @@
>  #include <linux/acpi.h>
>  #include <linux/pci.h>
>  #include <linux/aer.h>
> +#include <acpi/ghes.h>
>  
>  #define INDENT_SP	" "
>  
> @@ -386,8 +387,9 @@ static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
>  	pfx, pcie->bridge.secondary_status, pcie->bridge.control);
>  }
>  
> -static void cper_estatus_print_section(
> -	const char *pfx, const struct acpi_hest_generic_data *gdata, int sec_no)
> +static void
> +cper_estatus_print_section(const char *pfx, struct acpi_hest_generic_data *gdata,
> +			   int sec_no)
>  {
>  	uuid_le *sec_type = (uuid_le *)gdata->section_type;
>  	__u16 severity;
> @@ -403,14 +405,18 @@ static void cper_estatus_print_section(
>  
>  	snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
>  	if (!uuid_le_cmp(*sec_type, CPER_SEC_PROC_GENERIC)) {
> -		struct cper_sec_proc_generic *proc_err = (void *)(gdata + 1);
> +		struct cper_sec_proc_generic *proc_err;
> +
> +		proc_err = acpi_hest_get_payload(gdata);

Ditto.

>  		printk("%s""section_type: general processor error\n", newpfx);
>  		if (gdata->error_data_length >= sizeof(*proc_err))
>  			cper_print_proc_generic(newpfx, proc_err);
>  		else
>  			goto err_section_too_small;
>  	} else if (!uuid_le_cmp(*sec_type, CPER_SEC_PLATFORM_MEM)) {
> -		struct cper_sec_mem_err *mem_err = (void *)(gdata + 1);
> +		struct cper_sec_mem_err *mem_err;
> +
> +		mem_err = acpi_hest_get_payload(gdata);

Ditto.

>  		printk("%s""section_type: memory error\n", newpfx);
>  		if (gdata->error_data_length >=
>  		    sizeof(struct cper_sec_mem_err_old))
> @@ -419,7 +425,9 @@ static void cper_estatus_print_section(
>  		else
>  			goto err_section_too_small;
>  	} else if (!uuid_le_cmp(*sec_type, CPER_SEC_PCIE)) {
> -		struct cper_sec_pcie *pcie = (void *)(gdata + 1);
> +		struct cper_sec_pcie *pcie;
> +
> +		pcie = acpi_hest_get_payload(gdata);

Ditto.

>  		printk("%s""section_type: PCIe error\n", newpfx);
>  		if (gdata->error_data_length >= sizeof(*pcie))
>  			cper_print_pcie(newpfx, pcie, gdata);
> @@ -438,7 +446,7 @@ void cper_estatus_print(const char *pfx,
>  			const struct acpi_hest_generic_status *estatus)
>  {
>  	struct acpi_hest_generic_data *gdata;
> -	unsigned int data_len, gedata_len;
> +	unsigned int data_len;
>  	int sec_no = 0;
>  	char newpfx[64];
>  	__u16 severity;
> @@ -452,11 +460,10 @@ void cper_estatus_print(const char *pfx,
>  	data_len = estatus->data_length;
>  	gdata = (struct acpi_hest_generic_data *)(estatus + 1);
>  	snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
> -	while (data_len >= sizeof(*gdata)) {
> -		gedata_len = gdata->error_data_length;

<-- \n here while you're at it.

We have to start making this code more readable. It looks write-only
right now.

> +	while (data_len >= acpi_hest_get_size(gdata)) {
>  		cper_estatus_print_section(newpfx, gdata, sec_no);
> -		data_len -= gedata_len + sizeof(*gdata);
> -		gdata = (void *)(gdata + 1) + gedata_len;
> +		data_len -= acpi_hest_get_record_size(gdata);
> +		gdata = acpi_hest_get_next(gdata);
>  		sec_no++;
>  	}
>  }
> @@ -486,12 +493,12 @@ int cper_estatus_check(const struct acpi_hest_generic_status *estatus)
>  		return rc;
>  	data_len = estatus->data_length;
>  	gdata = (struct acpi_hest_generic_data *)(estatus + 1);
> -	while (data_len >= sizeof(*gdata)) {
> -		gedata_len = gdata->error_data_length;
> -		if (gedata_len > data_len - sizeof(*gdata))

Ditto.

> +	while (data_len >= acpi_hest_get_size(gdata)) {
> +		gedata_len = acpi_hest_get_error_length(gdata);
> +		if (gedata_len > data_len - acpi_hest_get_size(gdata))
>  			return -EINVAL;

<-- \n here too

> -		data_len -= gedata_len + sizeof(*gdata);
> -		gdata = (void *)(gdata + 1) + gedata_len;
> +		data_len -= acpi_hest_get_record_size(gdata);
> +		gdata = acpi_hest_get_next(gdata);
>  	}
>  	if (data_len)
>  		return -EINVAL;
> diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
> index 68f088a..b89361a 100644
> --- a/include/acpi/ghes.h
> +++ b/include/acpi/ghes.h
> @@ -12,6 +12,20 @@
>  #define GHES_TO_CLEAR		0x0001
>  #define GHES_EXITING		0x0002
>  
> +#define acpi_hest_get_error_length(gdata)	\
> +	(((struct acpi_hest_generic_data *)(gdata))->error_data_length)
> +#define acpi_hest_get_size(gdata)		\
> +	((acpi_hest_get_version(gdata) >= 3) ?	\
> +	sizeof(struct acpi_hest_generic_data_v300) :	\
> +	sizeof(struct acpi_hest_generic_data))
> +#define acpi_hest_get_record_size(gdata)	\
> +	(acpi_hest_get_size(gdata) +		\
> +	acpi_hest_get_error_length(gdata))
> +#define acpi_hest_get_next(gdata)		\
> +	((void *)(gdata) + acpi_hest_get_record_size(gdata))
> +#define acpi_hest_get_version(gdata)			\
> +	(gdata->revision >> 8)

Make all those inline functions.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
