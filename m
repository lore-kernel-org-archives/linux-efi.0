From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 6/8] efi/arm*: libstub: wire up GOP handling into the ARM
 UEFI stub
Date: Thu, 10 Mar 2016 09:25:22 +0100
Message-ID: <20160310082522.GB8618@gmail.com>
References: <1457588408-19309-1-git-send-email-ard.biesheuvel@linaro.org>
 <1457588408-19309-7-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1457588408-19309-7-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:

> diff --git a/drivers/firmware/efi/libstub/arm32-stub.c b/drivers/firmware/efi/libstub/arm32-stub.c
> index 495ebd657e38..0fbe00f13186 100644
> --- a/drivers/firmware/efi/libstub/arm32-stub.c
> +++ b/drivers/firmware/efi/libstub/arm32-stub.c
> @@ -9,6 +9,44 @@
>  #include <linux/efi.h>
>  #include <asm/efi.h>
>  
> +static const efi_guid_t screen_info_guid = LINUX_ARM32_SCREEN_INFO_TABLE_GUID;
> +
> +struct screen_info *alloc_screen_info(efi_system_table_t *sys_table_arg)
> +{
> +	struct screen_info *si;
> +	efi_status_t status;
> +
> +	/*
> +	 * Unlike on arm64, where we can directly fill out the screen_info
> +	 * structure from the stub, we need to allocate a buffer to hold
> +	 * its contents while we hand over to the kernel proper from the
> +	 * decompressor.
> +	 */
> +	status = efi_call_early(allocate_pool, EFI_RUNTIME_SERVICES_DATA,
> +				sizeof(*si), (void **)&si);
> +
> +	if (status != EFI_SUCCESS)
> +		return NULL;
> +
> +	status = efi_call_early(install_configuration_table,
> +				(efi_guid_t *)&screen_info_guid, si);
> +	if (status == EFI_SUCCESS)
> +		return si;
> +
> +	efi_call_early(free_pool, si);
> +	return NULL;
> +}
> +
> +void free_screen_info(efi_system_table_t *sys_table_arg, struct screen_info *si)
> +{
> +	if (!si)
> +		return;
> +
> +	efi_call_early(install_configuration_table,
> +		       (efi_guid_t *)&screen_info_guid, NULL);
> +	efi_call_early(free_pool, si);
> +}
> +
>  efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
>  				 unsigned long *image_addr,
>  				 unsigned long *image_size,

So screen_info_guid should probably not be a 'const': you have to cast it away 
anyway, adding artificial linebreaks and uglifying the code. It's also a bad 
practice to cast away const-ness, it hinders move-consts-to-readonly-sections 
efforts.

Otherwise the series looks mostly good to me. Time for new v4.6 merges is short, 
but if Matt acks it I can still take it into tip:efi/core.

Thanks,

	Ingo
