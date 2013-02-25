From: Satoru Takeuchi <takeuchi_satoru-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH] x86, efi: Mark disable_runtime as __initdata
Date: Tue, 26 Feb 2013 08:55:06 +0900
Message-ID: <512BF9DA.2050906@jp.fujitsu.com>
References: <1361545427-26393-1-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1361545427-26393-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(2013/02/23 0:03), Matt Fleming wrote:
> From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> disable_runtime is only referenced from __init functions, so mark it
> as __initdata.
> 
> Reported-by: Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Satoru Takeuchi <takeuchi_satoru-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> Cc: H. Peter Anvin <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

It looks good to me.

Reviewed-by: Satoru Takeuchi <takeuchi_satoru-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

> ---
>  arch/x86/platform/efi/efi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 2f81db4..5ae99f9 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -85,7 +85,7 @@ int efi_enabled(int facility)
>  }
>  EXPORT_SYMBOL(efi_enabled);
>  
> -static bool disable_runtime = false;
> +static bool __initdata disable_runtime = false;
>  static int __init setup_noefi(char *arg)
>  {
>  	disable_runtime = true;
> 
