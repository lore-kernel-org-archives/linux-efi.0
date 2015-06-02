From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH V2 1/3] efi: arch, x86: arch, ia64: move
 efi_mem_attributes()
Date: Tue, 2 Jun 2015 14:36:47 +0100
Message-ID: <20150602133647.GC6826@codeblueprint.co.uk>
References: <1433185940-24770-1-git-send-email-zjzhang@codeaurora.org>
 <1433185940-24770-2-git-send-email-zjzhang@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1433185940-24770-2-git-send-email-zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, al.stone-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linaro-acpi-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, vgandhi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Tony Luck <tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

(Cc'ing Tony for ia64 input)

On Mon, 01 Jun, at 12:12:18PM, Jonathan (Zhixiong) Zhang wrote:
> From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> 
> Both x86 and ia64 implemented efi_mem_attributs(), which is architecture
> agnositc. This function is moved from arch/x86 and arch/ia64 to
> drivers/firmware/efi.
> 
> Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
> ---
>  arch/ia64/kernel/efi.c      | 11 -----------
>  arch/x86/platform/efi/efi.c | 18 ------------------
>  drivers/firmware/efi/efi.c  | 18 ++++++++++++++++++
>  3 files changed, 18 insertions(+), 29 deletions(-)
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
> index 02744df576d5..10bd5289c593 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -926,24 +926,6 @@ u32 efi_mem_type(unsigned long phys_addr)
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
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 3061bb8629dc..86da85368778 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -517,3 +517,21 @@ char * __init efi_md_typeattr_format(char *buf, size_t size,
>  			 attr & EFI_MEMORY_UC      ? "UC"  : "");
>  	return buf;
>  }
> +
> +u64 efi_mem_attributes(unsigned long phys_addr)
> +{
> +	efi_memory_desc_t *md;
> +	void *p;
> +
> +	if (!efi_enabled(EFI_MEMMAP))
> +		return 0;
> +

Umm... ia64 doesn't appear to set EFI_MEMMAP. So doesn't this change
actively break ia64?

While I like the idea of de-duplication, the two implementations of
efi_mem_attributes() are not equivalent.

-- 
Matt Fleming, Intel Open Source Technology Center
