From: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>
Subject: Re: [PATCH 13/16] resolve warnings found on ARM compile
Date: Fri, 30 Aug 2013 14:41:04 +0100
Message-ID: <20130830134104.81C5A3E102A@localhost>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org> <1376090777-20090-14-git-send-email-roy.franz@linaro.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1376090777-20090-14-git-send-email-roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org
Cc: leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dave.martin-5wv7dgnIgG8@public.gmane.org, msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri,  9 Aug 2013 16:26:14 -0700, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> 2 unused labels
> 1 "value computed is not used"
> 
> 
> Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

When posting a patch to fix compile errors or warnings, it is helpful
inlude the output from the compiler with the error/warning message.

g.

> ---
>  drivers/firmware/efi/efi-stub-helper.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
> index 4bb542f..3e82cb0 100644
> --- a/drivers/firmware/efi/efi-stub-helper.c
> +++ b/drivers/firmware/efi/efi-stub-helper.c
> @@ -166,7 +166,6 @@ again:
>  		*addr = max_addr;
>  	}
>  
> -free_pool:
>  	efi_call_phys1(sys_table_arg->boottime->free_pool, map);
>  
>  fail:
> @@ -242,7 +241,6 @@ static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
>  	if (i == map_size / desc_size)
>  		status = EFI_NOT_FOUND;
>  
> -free_pool:
>  	efi_call_phys1(sys_table_arg->boottime->free_pool, map);
>  fail:
>  	return status;
> @@ -357,7 +355,7 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
>  
>  			if (*str == '/') {
>  				*p++ = '\\';
> -				*str++;
> +				str++;
>  			} else {
>  				*p++ = *str++;
>  			}
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
