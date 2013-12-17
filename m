From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH 3/3] efi: Make efi virtual runtime map passing more robust
Date: Tue, 17 Dec 2013 12:23:34 +0100
Message-ID: <20131217112334.GB30592@pd.tnic>
References: <1387236997-26975-1-git-send-email-bp@alien8.de>
 <1387236997-26975-4-git-send-email-bp@alien8.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1387236997-26975-4-git-send-email-bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, Arjan van de Ven <arjan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Dec 17, 2013 at 12:36:37AM +0100, Borislav Petkov wrote:
> @@ -880,6 +906,19 @@ void __init efi_enter_virtual_mode(void)
>  
>  	efi_dump_pagetable();
>  
> +	/*
> +	 * It can happen that the physical address of new_memmap lands in memory
> +	 * which is not mapped in the EFI page table. Therefore we need to go
> +	 * and ident-map those pages containing the map before calling
> +	 * phys_efi_set_virtual_address_map().
> +	 */
> +	if (kernel_map_pages_in_pgd(pgd, __pa(new_memmap), __pa(new_memmap),
> +				    1 << new_memmap_shift, _PAGE_NX)) {
> +		pr_err("Error ident-mapping new memmap (0x%lx)!\n",
> +		       __pa(new_memmap));
> +		goto err_out;
> +	}
> +
>  	status = phys_efi_set_virtual_address_map(
>  		memmap.desc_size * count,
>  		memmap.desc_size,
> @@ -916,7 +955,7 @@ void __init efi_enter_virtual_mode(void)
>  	if (efi_enabled(EFI_OLD_MEMMAP) && (__supported_pte_mask & _PAGE_NX))
>  		runtime_code_page_mkexec();
>  
> -	kfree(new_memmap);
> +	__free_pages(new_memmap, new_memmap_shift);

Note to self: carve out the error path of populate_pgd() into a separate
function and call it here to unmap the pages previously mapped above as
we're freeing them here.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
