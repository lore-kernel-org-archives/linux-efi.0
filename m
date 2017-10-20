From: joeyli <jlee-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 06/27] Copy secure_boot flag in boot params across kexec
 reboot
Date: Fri, 20 Oct 2017 14:40:00 +0800
Message-ID: <20171020064000.GO3285@linux-l9pv.suse>
References: <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
 <150842468009.7923.5512653689857540199.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <150842468009.7923.5512653689857540199.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Oct 19, 2017 at 03:51:20PM +0100, David Howells wrote:
> From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> Kexec reboot in case secure boot being enabled does not keep the secure
> boot mode in new kernel, so later one can load unsigned kernel via legacy
> kexec_load.  In this state, the system is missing the protections provided
> by secure boot.
> 
> Adding a patch to fix this by retain the secure_boot flag in original
> kernel.
> 
> secure_boot flag in boot_params is set in EFI stub, but kexec bypasses the
> stub.  Fixing this issue by copying secure_boot flag across kexec reboot.
> 
> Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> cc: kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org

I have reviewed and tested this patch. Please feel free to add:

Reviewed-by: "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>

Thanks a lot!
Joey Lee

> ---
> 
>  arch/x86/kernel/kexec-bzimage64.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/kernel/kexec-bzimage64.c b/arch/x86/kernel/kexec-bzimage64.c
> index fb095ba0c02f..7d0fac5bcbbe 100644
> --- a/arch/x86/kernel/kexec-bzimage64.c
> +++ b/arch/x86/kernel/kexec-bzimage64.c
> @@ -179,6 +179,7 @@ setup_efi_state(struct boot_params *params, unsigned long params_load_addr,
>  	if (efi_enabled(EFI_OLD_MEMMAP))
>  		return 0;
>  
> +	params->secure_boot = boot_params.secure_boot;
>  	ei->efi_loader_signature = current_ei->efi_loader_signature;
>  	ei->efi_systab = current_ei->efi_systab;
>  	ei->efi_systab_hi = current_ei->efi_systab_hi;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
