From: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>
Subject: Re: [PATCH 05/16] rename __get_map() to efi_get_memory_map(), add parameter to optionally return mmap key. The mmap key is required to exit EFI boot services, and allows efi_get_memory_map() to be used for getting final memory map.
Date: Fri, 30 Aug 2013 14:06:14 +0100
Message-ID: <20130830130614.C6D2F3E102A@localhost>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org> <1376090777-20090-6-git-send-email-roy.franz@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1376090777-20090-6-git-send-email-roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org
Cc: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, dave.martin-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri,  9 Aug 2013 16:26:06 -0700, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Same issue with the commit message here as for patch 4. Please include a
comment stating what is intended to use this new feature.

> ---
>  drivers/firmware/efi/efi-stub-helper.c |   17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
> index 40cd16e..1d0a079 100644
> --- a/drivers/firmware/efi/efi-stub-helper.c
> +++ b/drivers/firmware/efi/efi-stub-helper.c
> @@ -46,10 +46,11 @@ static void efi_printk(efi_system_table_t *sys_table_arg, char *str)
>  }
>  
>  
> -static efi_status_t __get_map(efi_system_table_t *sys_table_arg,
> -			      efi_memory_desc_t **map,
> -			      unsigned long *map_size,
> -			      unsigned long *desc_size)
> +static efi_status_t efi_get_memory_map(efi_system_table_t *sys_table_arg,
> +				       efi_memory_desc_t **map,
> +				       unsigned long *map_size,
> +				       unsigned long *desc_size,
> +				       unsigned long *key_ptr)
>  {
>  	efi_memory_desc_t *m = NULL;
>  	efi_status_t status;
> @@ -77,6 +78,8 @@ again:
>  
>  	if (status != EFI_SUCCESS)
>  		efi_call_phys1(sys_table_arg->boottime->free_pool, m);
> +	if (key_ptr && status == EFI_SUCCESS)
> +		*key_ptr = key;
>  
>  fail:
>  	*map = m;
> @@ -97,7 +100,8 @@ static efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
>  	u64 max_addr = 0;
>  	int i;
>  
> -	status = __get_map(sys_table_arg, &map, &map_size, &desc_size);
> +	status = efi_get_memory_map(sys_table_arg, &map, &map_size, &desc_size,
> +				    NULL);
>  	if (status != EFI_SUCCESS)
>  		goto fail;
>  
> @@ -175,7 +179,8 @@ static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
>  	unsigned long nr_pages;
>  	int i;
>  
> -	status = __get_map(sys_table_arg, &map, &map_size, &desc_size);
> +	status = efi_get_memory_map(sys_table_arg, &map, &map_size, &desc_size,
> +				    NULL);
>  	if (status != EFI_SUCCESS)
>  		goto fail;
>  
> -- 
> 1.7.10.4
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
