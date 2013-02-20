From: Satoru Takeuchi <takeuchi_satoru-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH] x86, efi: Make "noefi" really disable EFI runtime serivces
Date: Thu, 21 Feb 2013 08:46:10 +0900
Message-ID: <51256042.5030704@jp.fujitsu.com>
References: <1361392572-25657-1-git-send-email-matt@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1361392572-25657-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Matt,

(2013/02/21 5:36), Matt Fleming wrote:
> From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> commit 1de63d60cd5b ("efi: Clear EFI_RUNTIME_SERVICES rather than
> EFI_BOOT by "noefi" boot parameter") attempted to make "noefi" true to
> its documentation and disable EFI runtime services to prevent the
> bricking bug described in commit e0094244e41c ("samsung-laptop:
> Disable on EFI hardware"). However, it's not possible to clear
> EFI_RUNTIME_SERVICES from an early param function because
> EFI_RUNTIME_SERVICES is set in efi_init() *after* parse_early_param().
> 
> This resulted in "noefi" effectively becoming a no-op and no longer
> providing users with a way to disable EFI, which is bad for those
> users that have buggy machines.

Sorry, my patch was imperfect. This patch looks good to me.

Reviewed-by: Satoru Takeuchi <takeuchi_satoru-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

Thanks,
Satoru

> 
> Reported-by: Walt Nelson Jr <walt0924-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Satoru Takeuchi <takeuchi_satoru-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> Cc: H. Peter Anvin <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 928bf83..e2cd38f 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -85,9 +85,10 @@ int efi_enabled(int facility)
>  }
>  EXPORT_SYMBOL(efi_enabled);
>  
> +static bool disable_runtime = false;
>  static int __init setup_noefi(char *arg)
>  {
> -	clear_bit(EFI_RUNTIME_SERVICES, &x86_efi_facility);
> +	disable_runtime = true;
>  	return 0;
>  }
>  early_param("noefi", setup_noefi);
> @@ -734,7 +735,7 @@ void __init efi_init(void)
>  	if (!efi_is_native())
>  		pr_info("No EFI runtime due to 32/64-bit mismatch with kernel\n");
>  	else {
> -		if (efi_runtime_init())
> +		if (disable_runtime || efi_runtime_init())
>  			return;
>  		set_bit(EFI_RUNTIME_SERVICES, &x86_efi_facility);
>  	}
> 
