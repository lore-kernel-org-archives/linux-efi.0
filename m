From: Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/4] efi/x86: make efi_memmap_reserve only insert into boot mem areas
Date: Thu, 12 Jan 2017 12:15:50 +0100
Message-ID: <87r348r0k9.fsf@gmail.com>
References: <20170112094118.815108042@redhat.com>
        <20170112094214.860924858@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170112094214.860924858-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> (Dave Young's message of
        "Thu, 12 Jan 2017 17:41:19 +0800")
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, mika.penttila-MRsr7dthA9VWk0Htik3J/w@public.gmane.org, bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Dave,

On Thu, Jan 12 2017, Dave Young wrote:

> efi_mem_reserve cares only about boot services regions and maybe loader areas.
> So add a new argument to efi_memmap_insert for this purpose.

Please see below.


> --- linux-x86.orig/drivers/firmware/efi/memmap.c
> +++ linux-x86/drivers/firmware/efi/memmap.c
> @@ -213,7 +213,7 @@ int __init efi_memmap_split_count(efi_me
>   * to see how large @buf needs to be.
>   */
>  void __init efi_memmap_insert(struct efi_memory_map *old_memmap, void *buf,
> -			      struct efi_mem_range *mem)
> +			      struct efi_mem_range *mem, bool boot_only)
>  {
>  	u64 m_start, m_end, m_attr;
>  	efi_memory_desc_t *md;
> @@ -246,6 +246,12 @@ void __init efi_memmap_insert(struct efi
>  		start = md->phys_addr;
>  		end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1;
>  
> +		if (boot_only && !(md->type == EFI_LOADER_DATA ||
> +		    md->type == EFI_LOADER_CODE ||
> +		    md->type == EFI_BOOT_SERVICES_CODE ||
> +		    md->type == EFI_BOOT_SERVICES_DATA))
> +			continue;
> +


Actually, the efi_mem_desc_lookup() called from
efi_arch_memmap_reserve() will only return mds not satisfying the
following condition:

  if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
      md->type != EFI_BOOT_SERVICES_DATA &&
      md->type != EFI_RUNTIME_SERVICES_DATA) {
  	continue;
  }

Furthermore, efi_arch_mem_reserve() will only accept ranges fully
contained within such a region.

I think we can make efi_arch_mem_reserve() return early if
EFI_MEMORY_RUNTIME has been set already and thus, neglect this case in
efi_memmap_insert().

I suppose that we don't want to reserve within EFI_RUNTIME_SERVICES_DATA
regions in efi_mem_reserve() either -- these won't ever get made
available as general memory anyway [1]. So efi_arch_mem_reserve() should
return early here as well imo.

So, what would remain to be handled from efi_memmap_insert() in case of
boot_only would be EFI_BOOT_SERVICES_DATA only?

(As a sidenote, Matt pointed out at [1] that the EFI_LOADER_* regions
 should be reserved early through memblock_reserve() and not through
 efi_mem_reserve()).

Thanks,

Nicolai


[1] http://lkml.kernel.org/r/20170109130702.GI16838-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
