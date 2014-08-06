From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [RFC PATCH] arm64/efi: use id mapping for Runtime Services
Date: Wed, 6 Aug 2014 15:36:32 +0100
Message-ID: <20140806143632.GV25953@arm.com>
References: <1406815909-26825-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1406815909-26825-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Mark Rutland <Mark.Rutland-5wv7dgnIgG8@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Jul 31, 2014 at 03:11:49PM +0100, Ard Biesheuvel wrote:
> There are 2 interesting pieces of information in the UEFI spec section 2.3.6
> regarding the mapping of runtime regions:
> (a) the firmware should not request a virtual mapping for configuration tables,
>     even though they are marked as EfiRuntimeServicesData;
> (b) calling SetVirtualAddressMap() is optional, and it is equally appropriate to
>     call Runtime Services using an identity mapping.
> 
> So we can eliminate some of the complexity around UEFI Runtime Services by not
> using a virtual mapping at all, and calling the services at their physical
> address. This is especially useful under kexec, as SetVirtualAddressMap() may
> only be called once, and there is no guarantee that mappings are stable between
> different kexec'd kernels.
> 
> The fallout for other in-kernel users of UEFI data structures should be
> negligible, as they cannot legally access those data structures through
> pre-existing virtual mappings anyway (point (a) above)
> 
> It should also be noted that, as the kernel side of the address space (TTBR1) is
> retained, the stack and pointer function arguments remain accessible to the
> runtime service while the id mapping is active.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/arm64/include/asm/efi.h |  24 ++++++++--
>  arch/arm64/kernel/efi.c      | 106 ++-----------------------------------------
>  2 files changed, 23 insertions(+), 107 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
> index a34fd3b12e2b..d42a21e79b39 100644
> --- a/arch/arm64/include/asm/efi.h
> +++ b/arch/arm64/include/asm/efi.h
> @@ -1,8 +1,10 @@
>  #ifndef _ASM_EFI_H
>  #define _ASM_EFI_H
>  
> +#include <asm/cacheflush.h>
>  #include <asm/io.h>
>  #include <asm/neon.h>
> +#include <asm/tlbflush.h>
>  
>  #ifdef CONFIG_EFI
>  extern void efi_init(void);
> @@ -12,23 +14,37 @@ extern void efi_idmap_init(void);
>  #define efi_idmap_init()
>  #endif
>  
> +static inline void switch_pgd(pgd_t *pgd, struct mm_struct *mm)
> +{
> +	cpu_switch_mm(pgd, mm);
> +	flush_tlb_all();
> +	if (icache_is_aivivt())
> +		__flush_icache_all();
> +}
> +
>  #define efi_call_virt(f, ...)						\
>  ({									\
> -	efi_##f##_t *__f = efi.systab->runtime->f;			\
> +	efi_##f##_t *__f;						\
>  	efi_status_t __s;						\
>  									\
> -	kernel_neon_begin();						\
> +	kernel_neon_begin(); /* disables preemption */			\
> +	switch_pgd(idmap_pg_dir, &init_mm);				\
> +	__f =  efi.systab->runtime->f;					\
>  	__s = __f(__VA_ARGS__);						\
> +	switch_pgd(current->active_mm->pgd, current->active_mm);	\
>  	kernel_neon_end();						\
>  	__s;								\
>  })

This scares the bejesus out of me, but I can't put my finger on exactly why.
I think it does what you intend and I can't break it myself, so it would be
really good if the EFI folks could confirm that this looks good to them.

Cheers,

Will
