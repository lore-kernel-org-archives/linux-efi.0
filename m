From: joeyli <jlee@suse.com>
Subject: Re: [PATCH 4/5] efi: Lock down the kernel if booted in secure boot
 mode
Date: Fri, 26 May 2017 16:29:35 +0800
Message-ID: <20170526082935.GE15587@linux-l9pv.suse>
References: <149563711758.9419.11406612723056598045.stgit@warthog.procyon.org.uk>
 <149563715653.9419.12087391202203924792.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <149563715653.9419.12087391202203924792.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: ard.biesheuvel@linaro.org, matthew.garrett@nebula.com, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Wed, May 24, 2017 at 03:45:56PM +0100, David Howells wrote:
> UEFI Secure Boot provides a mechanism for ensuring that the firmware will
> only load signed bootloaders and kernels.  Certain use cases may also
> require that all kernel modules also be signed.  Add a configuration option
> that to lock down the kernel - which includes requiring validly signed
> modules - if the kernel is secure-booted.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: linux-efi@vger.kernel.org

Reviewed-by: Joey Lee <jlee@suse.com>

Regards
Joey Lee

> ---
> 
>  drivers/firmware/efi/Kconfig      |    1 +
>  drivers/firmware/efi/secureboot.c |   10 +++++++++-
>  2 files changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
> index c40fdeaf9a45..d03af2d5f52f 100644
> --- a/drivers/firmware/efi/Kconfig
> +++ b/drivers/firmware/efi/Kconfig
> @@ -87,6 +87,7 @@ config EFI_RUNTIME_WRAPPERS
>  config EFI_SECURE_BOOT
>  	bool "Support UEFI Secure Boot and lock down the kernel in secure boot mode"
>  	default n
> +	select LOCK_DOWN_KERNEL
>  	help
>  	  UEFI Secure Boot provides a mechanism for ensuring that the firmware
>  	  will only load signed bootloaders and kernels.  Secure boot mode may
> diff --git a/drivers/firmware/efi/secureboot.c b/drivers/firmware/efi/secureboot.c
> index 730518061a14..7292a3b832e3 100644
> --- a/drivers/firmware/efi/secureboot.c
> +++ b/drivers/firmware/efi/secureboot.c
> @@ -12,6 +12,7 @@
>  #include <linux/efi.h>
>  #include <linux/kernel.h>
>  #include <linux/printk.h>
> +#include <linux/security.h>
>  
>  /*
>   * Decide what to do when UEFI secure boot mode is enabled.
> @@ -23,10 +24,17 @@ void __init efi_set_secure_boot(enum efi_secureboot_mode mode)
>  		case efi_secureboot_mode_disabled:
>  			pr_info("Secure boot disabled\n");
>  			break;
> +
>  		case efi_secureboot_mode_enabled:
>  			set_bit(EFI_SECURE_BOOT, &efi.flags);
> -			pr_info("Secure boot enabled\n");
> +			if (IS_ENABLED(CONFIG_LOCK_DOWN_KERNEL)) {
> +				lock_kernel_down();
> +				pr_info("Secure boot enabled and kernel locked down\n");
> +			} else {
> +				pr_info("Secure boot enabled\n");
> +			}
>  			break;
> +
>  		default:
>  			pr_info("Secure boot could not be determined\n");
>  			break;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
