From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 1/2] efi: arch, x86: arch, ia64: rearrange EFI memmap
 related functions
Date: Wed, 27 May 2015 13:31:03 +0100
Message-ID: <20150527123103.GC3030@codeblueprint.co.uk>
References: <1430773335-22897-1-git-send-email-zjzhang@codeaurora.org>
 <1430773335-22897-2-git-send-email-zjzhang@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1430773335-22897-2-git-send-email-zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linaro-acpi-cunTk1MwBs8s++Sfvej+rw@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 04 May, at 02:02:14PM, Jonathan (Zhixiong) Zhang wrote:
> From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> 
> Both x86 and ia64 implemented efi_mem_attributs function, which is architecture
> agnositc. This function is moved to efi subsystem.
> 
> efi_remap() function is added. If EFI memmap feature is enabled, and if a
> memory region has attribute of EFI_MEMORY_UC, map it as uncached.
> 
> ---
> This patch was tested on an arm64 platform. It was built on x86 platform.
> 
> Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> ---
>  arch/ia64/kernel/efi.c      | 11 -----------
>  arch/x86/platform/efi/efi.c | 18 ------------------
>  drivers/firmware/efi/efi.c  | 27 +++++++++++++++++++++++++++
>  include/linux/efi.h         |  1 +
>  4 files changed, 28 insertions(+), 29 deletions(-)
> 
> diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
> index c52d7540dc05..ef20ec784b04 100644
> --- a/arch/ia64/kernel/efi.c
> +++ b/arch/ia64/kernel/efi.c
> @@ -771,17 +771,6 @@ efi_mem_type (unsigned long phys_addr)
>  }
>  
>  u64
> -efi_mem_attributes (unsigned long phys_addr)
> -{
> -	efi_memory_desc_t *md = efi_memory_descriptor(phys_addr);
> -
> -	if (md)
> -		return md->attribute;
> -	return 0;
> -}
> -EXPORT_SYMBOL(efi_mem_attributes);
> -
> -u64
>  efi_mem_attribute (unsigned long phys_addr, unsigned long size)
>  {
>  	unsigned long end = phys_addr + size;
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index dbc8627a5cdf..88b3ebaeb72f 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -917,24 +917,6 @@ u32 efi_mem_type(unsigned long phys_addr)
>  	return 0;
>  }
>  
> -u64 efi_mem_attributes(unsigned long phys_addr)
> -{
> -	efi_memory_desc_t *md;
> -	void *p;
> -
> -	if (!efi_enabled(EFI_MEMMAP))
> -		return 0;
> -
> -	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
> -		md = p;
> -		if ((md->phys_addr <= phys_addr) &&
> -		    (phys_addr < (md->phys_addr +
> -				  (md->num_pages << EFI_PAGE_SHIFT))))
> -			return md->attribute;
> -	}
> -	return 0;
> -}
> -
>  static int __init arch_parse_efi_cmdline(char *str)
>  {
>  	if (parse_option_str(str, "old_map"))

This should be split into two patches, one to remove the duplicate
efi_mem_attributes() and the other to create the new efi_ioremap()
function.

> +void __iomem *efi_remap(phys_addr_t phys_addr, size_t size)
> +{
> +	if (efi_enabled(EFI_MEMMAP) &&
> +	    (efi_mem_attributes(phys_addr) & EFI_MEMORY_UC))
> +		return ioremap(phys_addr, size);
> +	else
> +		return ioremap_cache(phys_addr, size);
> +}

Note that on x86 we don't leave the EFI memmap mapped throughout
runtime, it gets unmapped in efi_free_boot_services().

Which means that the second patch in this series isn't going to work
correctly if an error is reported after the kernel has finished booting.

It looks like arm64 leaves the EFI memmap mapped at runtime, right?

-- 
Matt Fleming, Intel Open Source Technology Center
