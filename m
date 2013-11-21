From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [patch 2/9 v3] efi: add a wrapper function efi_map_region_fixed
Date: Thu, 21 Nov 2013 17:39:47 +0100
Message-ID: <20131121163947.GL26009@pd.tnic>
References: <20131121061704.363730447@dhcp-16-126.nay.redhat.com>
 <20131121061753.223578092@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131121061753.223578092-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, Nov 21, 2013 at 02:17:06PM +0800, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> Kexec kernel will use saved runtime virtual mapping, so add a
> new function efi_map_region_fixed for directly mapping a md
> to md->virt.
> 
> The md is passed in from 1st kernel, the virtual addr is
> saved in md->virt_addr.
> 
> Matt: coding style
>       reuse __map_region
> 
> Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Except minor nitpick below:

Acked-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>

> ---
>  arch/x86/include/asm/efi.h     |    1 +
>  arch/x86/platform/efi/efi_32.c |    2 ++
>  arch/x86/platform/efi/efi_64.c |   10 ++++++++++
>  3 files changed, 13 insertions(+)
> 
> --- efi.orig/arch/x86/include/asm/efi.h
> +++ efi/arch/x86/include/asm/efi.h
> @@ -128,6 +128,7 @@ extern void efi_call_phys_epilog(void);
>  extern void efi_unmap_memmap(void);
>  extern void efi_memory_uc(u64 addr, unsigned long size);
>  extern void __init efi_map_region(efi_memory_desc_t *md);
> +extern void __init efi_map_region_fixed(efi_memory_desc_t *md);
>  extern void efi_sync_low_kernel_mappings(void);
>  extern void efi_setup_page_tables(void);
>  extern void __init old_map_region(efi_memory_desc_t *md);
> --- efi.orig/arch/x86/platform/efi/efi_64.c
> +++ efi/arch/x86/platform/efi/efi_64.c
> @@ -199,6 +199,16 @@ void __init efi_map_region(efi_memory_de
>  	md->virt_addr = efi_va;
>  }
>  
> +/*
> + * kexec kernel will use efi_map_region_fixed to map efi
> + * runtime memory ranges. md->virt_addr is the original virtual
> + * address which had been mapped in kexec 1st kernel.
> + */

Why not stretch this comment to the full 80 cols?

/*
 * kexec kernel will use efi_map_region_fixed to map efi runtime memory ranges.
 * md->virt_addr is the original virtual address which had been mapped in kexec
 * 1st kernel.
 */

> +void __init efi_map_region_fixed(efi_memory_desc_t *md)
> +{
> +	__map_region(md, md->virt_addr);
> +}
> +
>  void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
>  				 u32 type, u64 attribute)
>  {
> --- efi.orig/arch/x86/platform/efi/efi_32.c
> +++ efi/arch/x86/platform/efi/efi_32.c
> @@ -47,6 +47,8 @@ void __init efi_map_region(efi_memory_de
>  	old_map_region(md);
>  }
>  
> +void __init efi_map_region_fixed(efi_memory_desc_t *md) {}
> +
>  void efi_call_phys_prelog(void)
>  {
>  	struct desc_ptr gdt_descr;
> 
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
