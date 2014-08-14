From: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v2 3/3] arm64/efi: efistub: don't abort if base of DRAM
 is occupied
Date: Thu, 14 Aug 2014 12:32:05 +0100
Message-ID: <20140814113204.GE24018@leverpostej>
References: <1406717944-24725-1-git-send-email-ard.biesheuvel@linaro.org>
 <1406717944-24725-4-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1406717944-24725-4-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Jul 30, 2014 at 11:59:04AM +0100, Ard Biesheuvel wrote:
> If we cannot relocate the kernel Image to its preferred offset of base of DRAM
> plus TEXT_OFFSET, instead relocate it to the lowest available 2 MB boundary plus
> TEXT_OFFSET. We may lose a bit of memory at the low end, but we can still
> proceed normally otherwise.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Acked-by: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Acked-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>

> ---
>  arch/arm64/kernel/efi-stub.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
> index 1317fef8dde9..d27dd982ff26 100644
> --- a/arch/arm64/kernel/efi-stub.c
> +++ b/arch/arm64/kernel/efi-stub.c
> @@ -28,20 +28,16 @@ efi_status_t handle_kernel_image(efi_system_table_t *sys_table,
>  	kernel_size = _edata - _text;
>  	if (*image_addr != (dram_base + TEXT_OFFSET)) {
>  		kernel_memsize = kernel_size + (_end - _edata);
> -		status = efi_relocate_kernel(sys_table, image_addr,
> -					     kernel_size, kernel_memsize,
> -					     dram_base + TEXT_OFFSET,
> -					     PAGE_SIZE);
> +		status = efi_low_alloc(sys_table, kernel_memsize + TEXT_OFFSET,
> +				       SZ_2M, reserve_addr);
>  		if (status != EFI_SUCCESS) {
>  			pr_efi_err(sys_table, "Failed to relocate kernel\n");
>  			return status;
>  		}
> -		if (*image_addr != (dram_base + TEXT_OFFSET)) {
> -			pr_efi_err(sys_table, "Failed to alloc kernel memory\n");
> -			efi_free(sys_table, kernel_memsize, *image_addr);
> -			return EFI_LOAD_ERROR;
> -		}
> -		*image_size = kernel_memsize;
> +		memcpy((void *)*reserve_addr + TEXT_OFFSET, (void *)*image_addr,
> +		       kernel_size);
> +		*image_addr = *reserve_addr + TEXT_OFFSET;
> +		*reserve_size = kernel_memsize + TEXT_OFFSET;
>  	}
>  
>  
> -- 
> 1.8.3.2
> 
> 
