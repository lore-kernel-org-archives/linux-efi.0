From: Mike Krinkin <krinkin.m.u-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Cannot load linux after recent efi-related changes
Date: Mon, 19 Sep 2016 14:36:36 +0300
Message-ID: <20160919113634.GA4140@gmail.com>
References: <20160917162357.GA4122@gmail.com>
 <20160918011443.GA4475@gmail.com>
 <20160919111424.GB2892@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160919111424.GB2892-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, scott.lawson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Sep 19, 2016 at 12:14:24PM +0100, Matt Fleming wrote:
> On Sun, 18 Sep, at 04:14:45AM, Mike Krinkin wrote:
> > 
> > diff --git a/drivers/firmware/efi/memmap.c b/drivers/firmware/efi/memmap.c
> > index cd96086..34322d1 100644
> > --- a/drivers/firmware/efi/memmap.c
> > +++ b/drivers/firmware/efi/memmap.c
> > @@ -221,8 +221,8 @@ void __init efi_memmap_insert(struct efi_memory_map *old_memmap, void *buf,
> >  	void *old, *new;
> >  
> >  	/* modifying range */
> > -	m_start = mem->range.start;
> > -	m_end = mem->range.end;
> > +	m_start = mem->range.start & ~(u64)EFI_PAGE_SIZE;
> > +	m_end = ALIGN(mem->range.end, EFI_PAGE_SIZE) - 1;
> >  	m_attr = mem->attribute;
> >  
> >  	for (old = old_memmap->map, new = buf;
> 
> Thanks for the analysis and patch Mike, but this needs fixing further
> up the call stack so that we don't map things the caller didn't
> expect.
> 
> This bug was also reported in this thread,
> 
>   https://lkml.kernel.org/r/1474005912.3930.10.camel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Sorry, i haven't seen that.

> 
> Could you try this patch?

Works fine for me.

> 
> ---->8----
> 
> From 7e750e3289a44fe3ad693bde45aea1ad8577dd2a Mon Sep 17 00:00:00 2001
> From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Date: Fri, 16 Sep 2016 15:12:47 +0100
> Subject: [PATCH] x86/efi: Round EFI memmap reservations to EFI_PAGE_SIZE
> 
> Mike Galbraith reported that his machine started rebooting during boot
> after,
> 
>   commit 8e80632fb23f ("efi/esrt: Use efi_mem_reserve() and avoid a kmalloc()")
> 
> The ESRT table on his machine is 56 bytes and at no point in the
> efi_arch_mem_reserve() call path is that size rounded up to
> EFI_PAGE_SIZE, nor is the start address on an EFI_PAGE_SIZE boundary.
> 
> Since the EFI memory map only deals with whole pages, inserting an EFI
> memory region with 56 bytes results in a new entry covering zero
> pages, and completely screws up the calculations for the old regions
> that were trimmed.
> 
> Round all sizes upwards, and start addresses downwards, to the nearest
> EFI_PAGE_SIZE boundary.
> 
> Additionally, efi_memmap_insert() expects the mem::range::end value to
> be one less than the end address for the region.
> 
> Reported-by: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Reported-by: Mike Krinkin <krinkin.m.u-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> Cc: Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> ---
>  arch/x86/platform/efi/quirks.c |  6 +++++-
>  drivers/firmware/efi/memmap.c  | 11 +++++++++++
>  2 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
> index f14b7a9da24b..10aca63a50d7 100644
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -201,8 +201,12 @@ void __init efi_arch_mem_reserve(phys_addr_t addr, u64 size)
>  		return;
>  	}
>  
> +	size += addr % EFI_PAGE_SIZE;
> +	size = round_up(size, EFI_PAGE_SIZE);
> +	addr = round_down(addr, EFI_PAGE_SIZE);
> +
>  	mr.range.start = addr;
> -	mr.range.end = addr + size;
> +	mr.range.end = addr + size - 1;
>  	mr.attribute = md.attribute | EFI_MEMORY_RUNTIME;
>  
>  	num_entries = efi_memmap_split_count(&md, &mr.range);
> diff --git a/drivers/firmware/efi/memmap.c b/drivers/firmware/efi/memmap.c
> index cd96086fd851..f03ddecd232b 100644
> --- a/drivers/firmware/efi/memmap.c
> +++ b/drivers/firmware/efi/memmap.c
> @@ -225,6 +225,17 @@ void __init efi_memmap_insert(struct efi_memory_map *old_memmap, void *buf,
>  	m_end = mem->range.end;
>  	m_attr = mem->attribute;
>  
> +	/*
> +	 * The EFI memory map deals with regions in EFI_PAGE_SIZE
> +	 * units. Ensure that the region described by 'mem' is aligned
> +	 * correctly.
> +	 */
> +	if (!IS_ALIGNED(m_start, EFI_PAGE_SIZE) ||
> +	    !IS_ALIGNED(m_end + 1, EFI_PAGE_SIZE)) {
> +		WARN_ON(1);
> +		return;
> +	}
> +
>  	for (old = old_memmap->map, new = buf;
>  	     old < old_memmap->map_end;
>  	     old += old_memmap->desc_size, new += old_memmap->desc_size) {
> -- 
> 2.9.3
> 
