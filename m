From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 6/7] efi: Handle secure boot from UEFI-2.6 [ver #7]
Date: Tue, 31 Jan 2017 18:19:52 +0000
Message-ID: <CAKv+Gu8dnKB1sRGb3U+XB1eoA7Eyo4qSFBtPRbvGV912xPViVw@mail.gmail.com>
References: <148587558696.4026.16034622623568539004.stgit@warthog.procyon.org.uk>
 <148587564847.4026.5759345672956585977.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <148587564847.4026.5759345672956585977.stgit@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
To: David Howells <dhowells@redhat.com>, James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, keyrings@vger.kernel.org, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On 31 January 2017 at 15:14, David Howells <dhowells@redhat.com> wrote:
> UEFI-2.6 adds a new variable, DeployedMode.  If it exists, this must be 1
> if we're to engage lockdown mode.
>
> Reported-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> Signed-off-by: David Howells <dhowells@redhat.com>

Interestingly, the string 'DeployedMode' appears zero times in the
EDK2 codebase, so I wonder if it makes any sense to merge this now.
The string 'AuditMode' does appear once, but in a comment

In any case, the logic is not entirely correct either: apologies if it
was me who caused any confusion here, but it seems DeployedMode could
legally be 0 or 1 while secure boot is in fact enabled. It is actually
AuditMode that should be taken into account here, i.e., if AuditMode
== 1, the firmware ignores invalid or missing signatures. If
SecureBoot == 0x1, SetupMode == 0x0 and AuditMode == 0x0 (or
non-existent), signature verification is performed regardless of the
value (or existence) of DeployedMode.

So I propose to respin this patch to treat AuditMode == 0x1 as 'secure
boot disabled', and ignore if it is missing.

> ---
>
>  drivers/firmware/efi/libstub/secureboot.c |   16 +++++++++++++++-
>  include/linux/efi.h                       |    4 ++++
>  2 files changed, 19 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/firmware/efi/libstub/secureboot.c b/drivers/firmware/efi/libstub/secureboot.c
> index 39c91e091f6a..d653f76b9725 100644
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
> @@ -40,7 +43,7 @@ static efi_char16_t const shim_MokSBState_name[] = {
>  enum efi_secureboot_mode efi_get_secureboot(efi_system_table_t *sys_table_arg)
>  {
>         u32 attr;
> -       u8 secboot, setupmode, moksbstate;
> +       u8 secboot, setupmode, deployedmode, moksbstate;
>         unsigned long size;
>         efi_status_t status;
>
> @@ -59,6 +62,17 @@ enum efi_secureboot_mode efi_get_secureboot(efi_system_table_t *sys_table_arg)
>         if (secboot == 0 || setupmode == 1)
>                 return efi_secureboot_mode_disabled;
>
> +       /* UEFI-2.6 requires DeployedMode to be 1. */
> +       if (sys_table_arg->hdr.revision >= EFI_2_60_SYSTEM_TABLE_REVISION) {
> +               size = sizeof(deployedmode);
> +               status = get_efi_var(efi_DeployedMode_name, &efi_variable_guid,
> +                                    NULL, &size, &deployedmode);
> +               if (status != EFI_SUCCESS)
> +                       goto out_efi_err;
> +               if (deployedmode == 0)
> +                       return efi_secureboot_mode_disabled;
> +       }
> +
>         /* See if a user has put shim into insecure mode.  If so, and if the
>          * variable doesn't have the runtime attribute set, we might as well
>          * honor that.
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 1c200cdbdc05..87c1a6993f17 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -646,6 +646,10 @@ typedef struct {
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
>
