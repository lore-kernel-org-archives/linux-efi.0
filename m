From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 04/10] arm64/efi: invert UEFI memory region reservation logic
Date: Wed, 29 Oct 2014 17:28:06 -0700
Message-ID: <CAFECyb-xNMh=Qx4fCiQizrag-YfwcVy3ph5+do-kEBnDE-1sfw@mail.gmail.com>
References: <1414513123-20400-1-git-send-email-ard.biesheuvel@linaro.org>
	<1414513123-20400-5-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1414513123-20400-5-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yi Li <yi.li-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Oct 28, 2014 at 9:18 AM, Ard Biesheuvel
<ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> Instead of reserving the memory regions based on which types we know
> need to be reserved, consider only regions of the following types as
> free for general use by the OS:
>
> EFI_LOADER_CODE
> EFI_LOADER_DATA
> EFI_BOOT_SERVICES_CODE
> EFI_BOOT_SERVICES_DATA
> EFI_CONVENTIONAL_MEMORY
>
> Note that this also fixes a problem with the original code, which would
> misidentify a EFI_RUNTIME_SERVICES_DATA region as not reserved if it
> does not have the EFI_MEMORY_RUNTIME attribute set. However, it is
> perfectly legal for the firmware not to request a virtual mapping for
> EFI_RUNTIME_SERVICES_DATA regions that contain configuration tables, in
> which case the EFI_MEMORY_RUNTIME attribute would not be set.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm64/kernel/efi.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index 95c49ebc660d..2e829148fb36 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -125,17 +125,17 @@ out:
>   */
>  static __init int is_reserve_region(efi_memory_desc_t *md)
>  {
> -       if (!is_normal_ram(md))
> +       switch (md->type) {
> +       case EFI_LOADER_CODE:
> +       case EFI_LOADER_DATA:
> +       case EFI_BOOT_SERVICES_CODE:
> +       case EFI_BOOT_SERVICES_DATA:
> +       case EFI_CONVENTIONAL_MEMORY:
>                 return 0;
> -
> -       if (md->attribute & EFI_MEMORY_RUNTIME)
> -               return 1;
> -
> -       if (md->type == EFI_ACPI_RECLAIM_MEMORY ||
> -           md->type == EFI_RESERVED_TYPE)
> -               return 1;
> -
> -       return 0;
> +       default:
> +               break;
> +       }
> +       return is_normal_ram(md);
>  }
>
>  static __init void reserve_regions(void)
> --
> 1.8.3.2
>
Acked-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Looks good, as I expect most new types of memory that are added will
need some special treatment, and shouldn't just
be added to the available general use memory.
