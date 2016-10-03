From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH -next v2] arm*/efi: efi_init error handling fix
Date: Mon, 3 Oct 2016 20:51:31 +0100
Message-ID: <20161003195131.GK16071@codeblueprint.co.uk>
References: <1474371593-10250-1-git-send-email-xieyisheng1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1474371593-10250-1-git-send-email-xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yisheng Xie <xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: will.deacon-5wv7dgnIgG8@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, guohanjun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, 20 Sep, at 07:39:53PM, Yisheng Xie wrote:
> There's an early memmap leak in efi_init error path, fix it.
> 
> Signed-off-by: Yisheng Xie <xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  drivers/firmware/efi/arm-init.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
> index 9f8d996..7c2fe57 100644
> --- a/drivers/firmware/efi/arm-init.c
> +++ b/drivers/firmware/efi/arm-init.c
> @@ -245,8 +245,10 @@ void __init efi_init(void)
>  	     "Unexpected EFI_MEMORY_DESCRIPTOR version %ld",
>  	      efi.memmap.desc_version);
>  
> -	if (uefi_init() < 0)
> +	if (uefi_init() < 0) {
> +		efi_memmap_unmap();
>  		return;
> +	}
>  
>  	reserve_regions();
>  	efi_memattr_init();

Thanks, applied to 'next'.
