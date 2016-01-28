From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 1/3] arm64: efistub: drop __init annotation from
 handle_kernel_image()
Date: Thu, 28 Jan 2016 22:58:10 +0000
Message-ID: <20160128225809.GF2571@codeblueprint.co.uk>
References: <1453979254-25374-1-git-send-email-ard.biesheuvel@linaro.org>
 <1453979254-25374-2-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1453979254-25374-2-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 28 Jan, at 12:07:32PM, Ard Biesheuvel wrote:
> After moving arm64-stub.c to libstub/, all of its sections are emitted
> as .init.xxx sections automatically, and the __init annotation of
> handle_kernel_image() causes it to end up in .init.init.text, which is
> not recognized as an __init section by the linker scripts. So drop the
> annotation.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  drivers/firmware/efi/libstub/arm64-stub.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
> index 78dfbd34b6bf..9e0342745e4f 100644
> --- a/drivers/firmware/efi/libstub/arm64-stub.c
> +++ b/drivers/firmware/efi/libstub/arm64-stub.c
> @@ -13,13 +13,13 @@
>  #include <asm/efi.h>
>  #include <asm/sections.h>
>  
> -efi_status_t __init handle_kernel_image(efi_system_table_t *sys_table_arg,
> -					unsigned long *image_addr,
> -					unsigned long *image_size,
> -					unsigned long *reserve_addr,
> -					unsigned long *reserve_size,
> -					unsigned long dram_base,
> -					efi_loaded_image_t *image)
> +efi_status_t handle_kernel_image(efi_system_table_t *sys_table_arg,
> +				 unsigned long *image_addr,
> +				 unsigned long *image_size,
> +				 unsigned long *reserve_addr,
> +				 unsigned long *reserve_size,
> +				 unsigned long dram_base,
> +				 efi_loaded_image_t *image)
>  {
>  	efi_status_t status;
>  	unsigned long kernel_size, kernel_memsize = 0;
> -- 
> 2.5.0
> 

Would it make more sense to #undef __init in one of the arm64 efistub
header files? I'm thinking of the case where some poor unsuspecting
developer writes a new function and marks it as __init, and we miss it
during review.

At least if we do the #undef we can document why __init makes no sense
in the EFI stub, and at the same time automatically fix things up.

An alternative would be to write some Kbuild magic that complains if
it sees __init, but that seems like more work than is reasonable.
