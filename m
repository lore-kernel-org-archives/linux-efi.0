From: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v2] efi: libstub: treat missing SecureBoot variable as
 S/B disabled
Date: Fri, 17 Feb 2017 06:13:55 +0100
Message-ID: <20170217051355.GA1141@wunner.de>
References: <1487268503-21570-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1487268503-21570-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Feb 16, 2017 at 06:08:23PM +0000, Ard Biesheuvel wrote:
> The newly refactored code that infers the firmware's Secure Boot state
> prints the following error when the variables 'SecureBoot' is missing.
> 
>   EFI stub: ERROR: Could not determine UEFI Secure Boot status.
> 
> However, this variable is only guaranteed to be defined on a system that
> is Secure Boot capable to begin with, and so it is not an error if it is
> missing. So report Secure Boot as being disabled in this case, without
> printing any error messages.

In fact I pointed out this change of behaviour on ARM during the
review process:

https://lkml.org/lkml/2016/12/8/702

But David thought otherwise. :-(

Best regards,

Lukas

> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
> v2: treat SecureBoot present but SetupMode missing as 'unknown' not 'disabled'
> 
>  drivers/firmware/efi/libstub/secureboot.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/firmware/efi/libstub/secureboot.c b/drivers/firmware/efi/libstub/secureboot.c
> index 766ac06dac84..8fa8af4b3ca8 100644
> --- a/drivers/firmware/efi/libstub/secureboot.c
> +++ b/drivers/firmware/efi/libstub/secureboot.c
> @@ -47,6 +47,8 @@ enum efi_secureboot_mode efi_get_secureboot(efi_system_table_t *sys_table_arg)
>  	size = sizeof(secboot);
>  	status = get_efi_var(efi_SecureBoot_name, &efi_variable_guid,
>  			     NULL, &size, &secboot);
> +	if (status == EFI_NOT_FOUND)
> +		return efi_secureboot_mode_disabled;
>  	if (status != EFI_SUCCESS)
>  		goto out_efi_err;
>  
> @@ -80,7 +82,5 @@ enum efi_secureboot_mode efi_get_secureboot(efi_system_table_t *sys_table_arg)
>  
>  out_efi_err:
>  	pr_efi_err(sys_table_arg, "Could not determine UEFI Secure Boot status.\n");
> -	if (status == EFI_NOT_FOUND)
> -		return efi_secureboot_mode_disabled;
>  	return efi_secureboot_mode_unknown;
>  }
> -- 
> 2.7.4
