From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 2/2] efi/cper: Avoid possible OOB when checking generic
 data block
Date: Wed, 23 Jan 2019 12:54:02 +0100
Message-ID: <20190123115402.GB3227@zn.tnic>
References: <20190122160912.27312-1-ross.lagerwall@citrix.com>
 <20190122160912.27312-3-ross.lagerwall@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190122160912.27312-3-ross.lagerwall@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ross Lagerwall <ross.lagerwall@citrix.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Tony Luck <tony.luck@intel.com>, Huang Ying <ying.huang@intel.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Jan 22, 2019 at 04:09:12PM +0000, Ross Lagerwall wrote:
> When checking a generic status block, we iterate over all the generic
> data blocks. The loop condition only checks that the start of the
> generic data block is valid (within estatus->data_length) but not the
> whole block. Because the size of data blocks (excluding error data) may
> vary depending on the revision and the revision is contained within the
> data block, ensure that enough of the current data block is valid before
> dereferencing any members otherwise an OOB access may occur if

Please write out the OOB abbreviation in your commit messages.

> estatus->data_length is invalid. This relies on the fact that
> struct acpi_hest_generic_data_v300 is a superset of the earlier version.
> Also rework the other checks to avoid potential underflow.
> 
> Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
> ---
>  drivers/firmware/efi/cper.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
> index a7902fccdcfa..7cc18874b9d0 100644
> --- a/drivers/firmware/efi/cper.c
> +++ b/drivers/firmware/efi/cper.c
> @@ -546,7 +546,7 @@ EXPORT_SYMBOL_GPL(cper_estatus_check_header);
>  int cper_estatus_check(const struct acpi_hest_generic_status *estatus)
>  {
>  	struct acpi_hest_generic_data *gdata;
> -	unsigned int data_len, gedata_len;
> +	unsigned int data_len, record_len;
>  	int rc;
>  
>  	rc = cper_estatus_check_header(estatus);
> @@ -555,10 +555,12 @@ int cper_estatus_check(const struct acpi_hest_generic_status *estatus)
>  	data_len = estatus->data_length;
>  
>  	apei_estatus_for_each_section(estatus, gdata) {
> -		gedata_len = acpi_hest_get_error_length(gdata);
> -		if (gedata_len > data_len - acpi_hest_get_size(gdata))
> +		if (sizeof(struct acpi_hest_generic_data) > data_len)
>  			return -EINVAL;

<---- newline here.

Also, add a new line before the data_len assignment above, in the function.

> -		data_len -= acpi_hest_get_record_size(gdata);
> +		record_len = acpi_hest_get_record_size(gdata);

record_size so that it matches the function name it is used to compute
this.

Btw, trying to grok this code is making my head spin.

> +		if (record_len > data_len)
> +			return -EINVAL;

<---- newline here.

Btw, those checks in the loop you can abstract away into a separate
function so that you end up with something more readable like:

        apei_estatus_for_each_section(estatus, gdata) {
                record_size = check_hest_record_size(gdata, data_len);
                if (!record_size)
                        return -EINVAL;

                data_len -= record_size;
        }

for example.

> +		data_len -= record_len;
>  	}
>  	if (data_len)
>  		return -EINVAL;
> -- 

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
