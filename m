From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 1/3] arm64/efi: remove /chosen/linux,uefi-stub-kern-ver
 DT property
Date: Mon, 12 Oct 2015 18:18:46 -0700
Message-ID: <CAFECyb-4k_HwpBn_PHtAFNcrPkTPLDnqrb0oUOzwMWsBfa0xNA@mail.gmail.com>
References: <1444129424-8284-1-git-send-email-ard.biesheuvel@linaro.org>
	<1444129424-8284-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444129424-8284-2-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Oct 6, 2015 at 4:03 AM, Ard Biesheuvel
<ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> With the stub to kernel interface being promoted to a proper interface
> so that other agents than the stub can boot the kernel proper in EFI
> mode, we can remove the linux,uefi-stub-kern-ver field, considering
> that its original purpose was to prevent this from happening in the
> first place.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Acked-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  Documentation/arm/uefi.txt         | 2 --
>  drivers/firmware/efi/libstub/fdt.c | 9 ---------
>  2 files changed, 11 deletions(-)
>
> diff --git a/Documentation/arm/uefi.txt b/Documentation/arm/uefi.txt
> index d60030a1b909..7f1bed8872f3 100644
> --- a/Documentation/arm/uefi.txt
> +++ b/Documentation/arm/uefi.txt
> @@ -58,7 +58,5 @@ linux,uefi-mmap-desc-size | 32-bit | Size in bytes of each entry in the UEFI
>  --------------------------------------------------------------------------------
>  linux,uefi-mmap-desc-ver  | 32-bit | Version of the mmap descriptor format.
>  --------------------------------------------------------------------------------
> -linux,uefi-stub-kern-ver  | string | Copy of linux_banner from build.
> ---------------------------------------------------------------------------------
>
>  For verbose debug messages, specify 'uefi_debug' on the kernel command line.
> diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
> index ef5d764e2a27..b62e2f5dcab3 100644
> --- a/drivers/firmware/efi/libstub/fdt.c
> +++ b/drivers/firmware/efi/libstub/fdt.c
> @@ -147,15 +147,6 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
>         if (status)
>                 goto fdt_set_fail;
>
> -       /*
> -        * Add kernel version banner so stub/kernel match can be
> -        * verified.
> -        */
> -       status = fdt_setprop_string(fdt, node, "linux,uefi-stub-kern-ver",
> -                            linux_banner);
> -       if (status)
> -               goto fdt_set_fail;
> -
>         return EFI_SUCCESS;
>
>  fdt_set_fail:
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
