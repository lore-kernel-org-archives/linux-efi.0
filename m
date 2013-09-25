From: "Borislav Petkov" <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH -v2] EFI: Runtime services virtual mapping
Date: Wed, 25 Sep 2013 11:24:54 +0200 (CEST)
Message-ID: <1c45cce8ceb98b178976751a1d7db8be.squirrel@www.skyhub.de>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
    <1379602494-26684-12-git-send-email-bp@alien8.de>
    <20130921113929.GB1587@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130921113929.GB1587-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, James Bottomley <james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Sat, September 21, 2013 1:39 pm, Borislav Petkov wrote:
> diff --git a/arch/x86/platform/efi/efi_32.c
> b/arch/x86/platform/efi/efi_32.c
> index 40e446941dd7..661663b08eaf 100644
> --- a/arch/x86/platform/efi/efi_32.c
> +++ b/arch/x86/platform/efi/efi_32.c
> @@ -37,9 +37,36 @@
>   * claim EFI runtime service handler exclusively and to duplicate a
> memory in
>   * low memory space say 0 - 3G.
>   */
> -
>  static unsigned long efi_rt_eflags;
>
> +void efi_sync_low_kernel_mappings(void) {}
> +
> +void __init efi_map_region(efi_memory_desc_t *md)
> +{
> +	u64 start_pfn, end_pfn, end;
> +	unsigned long size;
> +	void *va;
> +
> +	start_pfn = PFN_DOWN(md->phys_addr);
> +	size	  = md->num_pages << PAGE_SHIFT;
> +	end	  = md->phys_addr + size;
> +	end_pfn   = PFN_UP(end);
> +
> +	if (pfn_range_is_mapped(start_pfn, end_pfn)) {
> +		va = __va(md->phys_addr);
> +
> +		if (!(md->attribute & EFI_MEMORY_WB))
> +			efi_memory_uc((u64)(unsigned long)va, size);
> +	} else
> +		va = efi_ioremap(md->phys_addr, size,
> +				 md->type, md->attribute);
> +
> +	md->virt_addr = (u64) (unsigned long) va;
> +	if (!va)
> +		pr_err("ioremap of 0x%llX failed!\n",
> +		       (unsigned long long)md->phys_addr);
> +}
> +

Another note-to-self, while I'm here: it is probably prudent to
be conservative here and keep the old runtime mapping method
in generic EFI code and behind a chicken bit, something like
"efi.use_old_runtime_mapping" or shorter so that people whose systems
break from the new mapping can fall back to the old, well-tested method.

Thanks.

-- 
Regards/Gruss,
Boris.
