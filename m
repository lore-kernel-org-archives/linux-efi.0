From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi: libstub: treat missing SecureBoot/SetupMode vars as
 SB disabled
Date: Thu, 16 Feb 2017 17:59:42 +0000
Message-ID: <CAKv+Gu_hPfEsZU6LNRFz1UcmzD+55Dv4TY=1pRwnXAZ5A+YESQ@mail.gmail.com>
References: <1487267794-4691-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487267794-4691-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Josh Boyer <jwboyer-rxtnV0ftBwyoClj4AeEUq9i2O/JbrIOy@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 16 February 2017 at 17:56, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> The newly refactored code that infers the firmware's Secure Boot state
> prints the following error when the variables 'SecureBoot' or 'SetupMode'
> are missing.
>
>   EFI stub: ERROR: Could not determine UEFI Secure Boot status.
>
> However, these variables are only guaranteed to be defined on a system
> that is Secure Boot capable to begin with, and so it is not an error if
> they are missing. So report Secure Boot as disabled in this case, without
> printing any error messages.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/libstub/secureboot.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/firmware/efi/libstub/secureboot.c b/drivers/firmware/efi/libstub/secureboot.c
> index 766ac06dac84..1987410e8242 100644
> --- a/drivers/firmware/efi/libstub/secureboot.c
> +++ b/drivers/firmware/efi/libstub/secureboot.c
> @@ -47,12 +47,16 @@ enum efi_secureboot_mode efi_get_secureboot(efi_system_table_t *sys_table_arg)
>         size = sizeof(secboot);
>         status = get_efi_var(efi_SecureBoot_name, &efi_variable_guid,
>                              NULL, &size, &secboot);
> +       if (status == EFI_NOT_FOUND)
> +               return efi_secureboot_mode_disabled;
>         if (status != EFI_SUCCESS)
>                 goto out_efi_err;
>
>         size = sizeof(setupmode);
>         status = get_efi_var(efi_SetupMode_name, &efi_variable_guid,
>                              NULL, &size, &setupmode);
> +       if (status == EFI_NOT_FOUND)
> +               return efi_secureboot_mode_disabled;

Hmm, I hit 'send' a little quick: if SecureBoot exists and SetupMode
doesn't, I think we are in a situation where we should report
'unknown' rather than disabled.

>         if (status != EFI_SUCCESS)
>                 goto out_efi_err;
>
> @@ -80,7 +84,5 @@ enum efi_secureboot_mode efi_get_secureboot(efi_system_table_t *sys_table_arg)
>
>  out_efi_err:
>         pr_efi_err(sys_table_arg, "Could not determine UEFI Secure Boot status.\n");
> -       if (status == EFI_NOT_FOUND)
> -               return efi_secureboot_mode_disabled;
>         return efi_secureboot_mode_unknown;
>  }
> --
> 2.7.4
>
