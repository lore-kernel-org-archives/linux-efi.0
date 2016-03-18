From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 1/8] efi: make install_configuration_table() boot service
 usable
Date: Fri, 18 Mar 2016 10:59:39 +0000
Message-ID: <20160318105939.GO2619@codeblueprint.co.uk>
References: <1457588408-19309-1-git-send-email-ard.biesheuvel@linaro.org>
 <1457588408-19309-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1457588408-19309-2-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 10 Mar, at 12:40:01PM, Ard Biesheuvel wrote:
> This patch redeclares efi_boot_services_t::install_configuration_table
> as a function pointer so that the boot service is callable as a function.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  include/linux/efi.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
 
Any chance you could fold this patch into the one that actually uses
install_configuration_table() on ARM? That way it's clear to see where
the users are.

> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index e747eb08b2be..8ba6eb7863aa 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -283,7 +283,7 @@ typedef struct {
>  	void *register_protocol_notify;
>  	void *locate_handle;
>  	void *locate_device_path;
> -	void *install_configuration_table;
> +	efi_status_t (*install_configuration_table)(efi_guid_t *, void *);
>  	void *load_image;
>  	void *start_image;
>  	void *exit;
> -- 
> 1.9.1
> 
