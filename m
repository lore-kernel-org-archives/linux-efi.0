From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/7] efi: Get the secure boot status [ver #3]
Date: Fri, 25 Nov 2016 13:50:13 +0000
Message-ID: <CAKv+Gu9qkPrq1rXN_7=BbZ=8v14Px+oHBqST0OnarUWVwhtZyg@mail.gmail.com>
References: <147990561294.7576.6464430479448167484.stgit@warthog.procyon.org.uk>
 <147990565051.7576.9673287945782426886.stgit@warthog.procyon.org.uk>
 <1480016487.2444.18.camel@HansenPartnership.com> <15173.1480066220@warthog.procyon.org.uk>
 <CAKv+Gu_JxNLDjaK5jGbX9ACzM0uHJYMOFx7XDo4t7DtBMtFRGA@mail.gmail.com>
 <16661.1480075392@warthog.procyon.org.uk> <CAKv+Gu_d5+Kvo7Tptnpg7kfjpqxhQ3a3nsQ0Ufsm6rBOFry+mQ@mail.gmail.com>
 <17565.1480077303@warthog.procyon.org.uk> <CAKv+Gu9c-C2uXZ0fVatCM8ffXJZDgjBcDb_T0nsFecGqgrF11Q@mail.gmail.com>
 <31374.1480078855@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <31374.1480078855-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 25 November 2016 at 13:00, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> Okay, how about the attached?
>
> Can these variables every be anything other than 1 or 0?  E.g. should the
> check on SetupMode be that it isn't 0 rather than it is 1?
>

The firmware will ensure that these variables only ever assume the
documented values.

> David
> ---
> commit 6d4bb08e376045e27706c2740c0fdff0a6ec43f7
> Author: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Date:   Fri Nov 25 11:52:05 2016 +0000
>
>     efi: Handle secure boot from UEFI-2.6
>
>     UEFI-2.6 adds a new variable, DeployedMode.  If it exists, this must be 1
>     if we're to engage lockdown mode.
>
>     Reported-by: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
>     Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>
> diff --git a/drivers/firmware/efi/libstub/secureboot.c b/drivers/firmware/efi/libstub/secureboot.c
> index ca643eba5a4b..157782d1c552 100644
> --- a/drivers/firmware/efi/libstub/secureboot.c
> +++ b/drivers/firmware/efi/libstub/secureboot.c
> @@ -22,6 +22,9 @@ static const efi_char16_t const efi_SecureBoot_name[] = {
>  static const efi_char16_t const efi_SetupMode_name[] = {
>         'S', 'e', 't', 'u', 'p', 'M', 'o', 'd', 'e', 0
>  };
> +static const efi_char16_t const efi_DeployedMode_name[] = {
> +       'D', 'e', 'p', 'l', 'o', 'y', 'e', 'd', 'M', 'o', 'd', 'e', 0
> +};
>
>  /* SHIM variables */
>  static const efi_guid_t shim_guid = EFI_SHIM_LOCK_GUID;
> @@ -62,6 +65,17 @@ int efi_get_secureboot(efi_system_table_t *sys_table_arg)
>         if (val == 1)
>                 return 0;
>
> +       /* UEFI-2.6 requires DeployedMode to be 1. */
> +       if (sys_table_arg->hdr.revision == EFI_2_60_SYSTEM_TABLE_REVISION) {

>=

> +               status = get_efi_var(efi_DeployedMode_name, &efi_variable_guid,
> +                                    NULL, &size, &val);
> +               if (status != EFI_SUCCESS)
> +                       goto out_efi_err;
> +
> +               if (val != 1)
> +                       return 0;

val == 0 is better imo, since that will prevent unexpected values from
being interpreted as 'secure boot disabled'

> +       }
> +
>         /* See if a user has put shim into insecure mode.  If so, and if the
>          * variable doesn't have the runtime attribute set, we might as well
>          * honor that.
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 333d31bf55bf..563abb37f03f 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -645,6 +645,10 @@ typedef struct {
>
>  #define EFI_SYSTEM_TABLE_SIGNATURE ((u64)0x5453595320494249ULL)
>
> +#define EFI_2_60_SYSTEM_TABLE_REVISION  ((2 << 16) | (60))
> +#define EFI_2_50_SYSTEM_TABLE_REVISION  ((2 << 16) | (50))
> +#define EFI_2_40_SYSTEM_TABLE_REVISION  ((2 << 16) | (40))
> +#define EFI_2_31_SYSTEM_TABLE_REVISION  ((2 << 16) | (31))
>  #define EFI_2_30_SYSTEM_TABLE_REVISION  ((2 << 16) | (30))
>  #define EFI_2_20_SYSTEM_TABLE_REVISION  ((2 << 16) | (20))
>  #define EFI_2_10_SYSTEM_TABLE_REVISION  ((2 << 16) | (10))
