From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] x86/efi: skip bgrt init for kexec reboot
Date: Thu, 4 Feb 2016 05:42:00 +0800
Message-ID: <20160203214200.GA15110@dhcp-128-65.nay.redhat.com>
References: <20160127112044.GA2961@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160127112044.GA2961-0VdLhd/A9Pl+NNSt+8eSiB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
Cc: kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


On 01/27/16 at 07:20pm, Dave Young wrote:
> For kexec reboot the bgrt image address could contains random data because
> we have freed boot service areas in 1st kernel boot phase. One possible
> result is kmalloc fail in efi_bgrt_init due to large random image size.
> 
> So change efi_late_init to avoid efi_bgrt_init in case kexec boot.
> 
> Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- linux-x86.orig/arch/x86/platform/efi/efi.c
> +++ linux-x86/arch/x86/platform/efi/efi.c
> @@ -531,7 +531,8 @@ void __init efi_init(void)
>  
>  void __init efi_late_init(void)
>  {
> -	efi_bgrt_init();
> +	if (!efi_setup)
> +		efi_bgrt_init();
>  }
>  
>  void __init efi_set_executable(efi_memory_desc_t *md, bool executable)

Matt, opinions about this patch?

Thanks
Dave
