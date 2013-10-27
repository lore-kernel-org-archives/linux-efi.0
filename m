From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [patch 1/6] Add function efi_remap_region for remapping to saved
 virt address
Date: Sun, 27 Oct 2013 12:50:39 +0100
Message-ID: <20131027115038.GB21868@pd.tnic>
References: <20131027034713.481920209@dhcp-16-126.nay.redhat.com>
 <20131027035922.776610726@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131027035922.776610726-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sun, Oct 27, 2013 at 11:47:14AM +0800, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> Kexec kernel will use saved runtime virtual mapping, so add a
> new function efi_remap_region to remapping it directly without
> calculate the virt addr from efi_va.
> 
> The md is passed in from 1st kernel, the virtual addr is
> saved in md->virt_addr.
> 
> Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/include/asm/efi.h     |    1 +
>  arch/x86/platform/efi/efi_32.c |    4 ++++
>  arch/x86/platform/efi/efi_64.c |   13 +++++++++++++
>  3 files changed, 18 insertions(+)
> 
> --- linux-2.6.orig/arch/x86/include/asm/efi.h
> +++ linux-2.6/arch/x86/include/asm/efi.h
> @@ -112,6 +112,7 @@ extern void efi_call_phys_epilog(void);
>  extern void efi_unmap_memmap(void);
>  extern void efi_memory_uc(u64 addr, unsigned long size);
>  extern void __init efi_map_region(efi_memory_desc_t *md);
> +extern void __init efi_remap_region(efi_memory_desc_t *md);
>  extern void efi_sync_low_kernel_mappings(void);
>  extern void __init old_map_region(efi_memory_desc_t *md);
>  
> --- linux-2.6.orig/arch/x86/platform/efi/efi_64.c
> +++ linux-2.6/arch/x86/platform/efi/efi_64.c
> @@ -177,6 +177,19 @@ void __init efi_map_region(efi_memory_de
>  	md->virt_addr = efi_va;
>  }
>  
> +void __init efi_remap_region(efi_memory_desc_t *md)

remap? Why?

You did have efi_map_region_fixed() which made more sense.

> +{
> +	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
> +	unsigned long pf = 0;
> +
> +	if (!(md->attribute & EFI_MEMORY_WB))
> +		pf |= _PAGE_PCD;
> +
> +	if(kernel_map_pages_in_pgd(pgd, md->phys_addr, md->virt_addr, md->num_pages, pf))

ERROR: space required before the open parenthesis '('
#59: FILE: arch/x86/platform/efi/efi_64.c:188:
+       if(kernel_map_pages_in_pgd(pgd, md->phys_addr, md->virt_addr, md->num_pages, pf))


Please run them all through checkpatch.pl - better yet, integrate
checkpatch into your workflow like using git hooks, for example.

> +		pr_warning("Error mapping PA 0x%llx -> VA 0x%llx!\n",

WARNING: Prefer pr_warn(... to pr_warning(...
#60: FILE: arch/x86/platform/efi/efi_64.c:189:
+               pr_warning("Error mapping PA 0x%llx -> VA 0x%llx!\n",

> +			   md->phys_addr, md->virt_addr);
> +}
> +
>  void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
>  				 u32 type, u64 attribute)
>  {
> --- linux-2.6.orig/arch/x86/platform/efi/efi_32.c
> +++ linux-2.6/arch/x86/platform/efi/efi_32.c
> @@ -46,6 +46,10 @@ void __init efi_map_region(efi_memory_de
>  	old_map_region(md);
>  }
>  
> +void __init efi_remap_region(efi_memory_desc_t *md)
> +{
> +}

Let's keep braces on the same line as the function to save space:

void __init efi_remap_region(efi_memory_desc_t *md) {}

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
