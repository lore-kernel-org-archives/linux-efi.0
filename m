From: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>
Subject: Re: [PATCH 06/16] Enforce minimum alignment of 1 page on allocations. The efi_high_alloc() and efi_low_alloc() functions use the EFI_ALLOCATE_ADDRESS option to the EFI function allocate_pages(), which requires a minimum of page alignment, and rejects all other requests.
Date: Fri, 30 Aug 2013 14:08:11 +0100
Message-ID: <20130830130811.7D7453E102A@localhost>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org> <1376090777-20090-7-git-send-email-roy.franz@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1376090777-20090-7-git-send-email-roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org
Cc: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, dave.martin-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri,  9 Aug 2013 16:26:07 -0700, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> The existing code could fail to allocate depending
> on allocation size, as although repeated allocation
> attempts were made, none were guaranteed to be page
> aligned.

Commit message. Otherwise looks reasonable.

Reviewed-by: Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

> Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/efi-stub-helper.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
> index 1d0a079..647b3ba 100644
> --- a/drivers/firmware/efi/efi-stub-helper.c
> +++ b/drivers/firmware/efi/efi-stub-helper.c
> @@ -105,6 +105,13 @@ static efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
>  	if (status != EFI_SUCCESS)
>  		goto fail;
>  
> +	/* Enforce minimum alignment that EFI requires when requesting
> +	 * a specific address.  We are doing page-based allocations,
> +	 * so we must be aligned to a page.
> +	 */
> +	if (align < EFI_PAGE_SIZE)
> +		align = EFI_PAGE_SIZE;
> +
>  	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
>  again:
>  	for (i = 0; i < map_size / desc_size; i++) {
> @@ -184,6 +191,13 @@ static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
>  	if (status != EFI_SUCCESS)
>  		goto fail;
>  
> +	/* Enforce minimum alignment that EFI requires when requesting
> +	 * a specific address.  We are doing page-based allocations,
> +	 * so we must be aligned to a page.
> +	 */
> +	if (align < EFI_PAGE_SIZE)
> +		align = EFI_PAGE_SIZE;
> +
>  	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
>  	for (i = 0; i < map_size / desc_size; i++) {
>  		efi_memory_desc_t *desc;
> -- 
> 1.7.10.4
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
