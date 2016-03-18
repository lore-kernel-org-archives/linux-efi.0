From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 8/8] efi/arm: populate screen_info based on data provided
 by the UEFI stub
Date: Fri, 18 Mar 2016 11:53:13 +0000
Message-ID: <20160318115313.GR2619@codeblueprint.co.uk>
References: <1457588408-19309-1-git-send-email-ard.biesheuvel@linaro.org>
 <1457588408-19309-9-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1457588408-19309-9-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 10 Mar, at 12:40:08PM, Ard Biesheuvel wrote:
> Unlike on arm64, where we can simply access the screen_info struct directly,
> ARM requires an intermediate step to get the information discovered by the
> GOP code in the UEFI stub into the screen_info struct.
> 
> So retrieve the dedicated config table we invented for this purpose, and
> put its contents into the core kernel's copy of struct screen_info.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm/kernel/efi.c           | 24 ++++++++++++++++++++
>  drivers/firmware/efi/arm-init.c |  6 +++++
>  2 files changed, 30 insertions(+)
 
[...]

> diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
> index eca9b4f826ee..689bf65f8ddf 100644
> --- a/drivers/firmware/efi/arm-init.c
> +++ b/drivers/firmware/efi/arm-init.c
> @@ -112,6 +112,12 @@ static int __init uefi_init(void)
>  	retval = efi_config_parse_tables(config_tables, efi.systab->nr_tables,
>  					 sizeof(efi_config_table_t), NULL);
>  
> +	if (IS_ENABLED(CONFIG_ARM)) {
> +		extern void efi_find_screen_info(efi_config_table_t *, u32);
> +
> +		efi_find_screen_info(config_tables, efi.systab->nr_tables);
> +	}
> +
>  	early_memunmap(config_tables, table_size);
>  out:
>  	early_memunmap(efi.systab,  sizeof(efi_system_table_t));

It's unfortunate that this is the first example of putting
arch-specific things in arm-init.c. Is there anyway we can move it out
into arch/arm?

If not, because efi_find_screen_info() uses all standard data types
and function calls, I wouldn't be opposed to just sticking this in
efi_config_parse_tables() like we do for EFI_PROPERTIES_TABLE. It's
certainly nice to have all config table code in one place.

Also, it would save ARM the effort of looping over the config tables
twice.
