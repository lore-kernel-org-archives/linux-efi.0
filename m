From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] efi/x86: make efi_memmap_reserve only insert into
 boot mem areas
Date: Fri, 13 Jan 2017 05:29:52 +0800
Message-ID: <20170112212952.GB2709@dhcp-128-65.nay.redhat.com>
References: <20170112094118.815108042@redhat.com>
 <20170112094214.860924858@redhat.com>
 <87r348r0k9.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87r348r0k9.fsf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, mika.penttila-MRsr7dthA9VWk0Htik3J/w@public.gmane.org, bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 01/12/17 at 12:15pm, Nicolai Stange wrote:
> Hi Dave,
> 
> On Thu, Jan 12 2017, Dave Young wrote:
> 
> > efi_mem_reserve cares only about boot services regions and maybe loader areas.
> > So add a new argument to efi_memmap_insert for this purpose.
> 
> Please see below.
> 
> 
> > --- linux-x86.orig/drivers/firmware/efi/memmap.c
> > +++ linux-x86/drivers/firmware/efi/memmap.c
> > @@ -213,7 +213,7 @@ int __init efi_memmap_split_count(efi_me
> >   * to see how large @buf needs to be.
> >   */
> >  void __init efi_memmap_insert(struct efi_memory_map *old_memmap, void *buf,
> > -			      struct efi_mem_range *mem)
> > +			      struct efi_mem_range *mem, bool boot_only)
> >  {
> >  	u64 m_start, m_end, m_attr;
> >  	efi_memory_desc_t *md;
> > @@ -246,6 +246,12 @@ void __init efi_memmap_insert(struct efi
> >  		start = md->phys_addr;
> >  		end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1;
> >  
> > +		if (boot_only && !(md->type == EFI_LOADER_DATA ||
> > +		    md->type == EFI_LOADER_CODE ||
> > +		    md->type == EFI_BOOT_SERVICES_CODE ||
> > +		    md->type == EFI_BOOT_SERVICES_DATA))
> > +			continue;
> > +
> 
> 
> Actually, the efi_mem_desc_lookup() called from
> efi_arch_memmap_reserve() will only return mds not satisfying the
> following condition:
> 
>   if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
>       md->type != EFI_BOOT_SERVICES_DATA &&
>       md->type != EFI_RUNTIME_SERVICES_DATA) {
>   	continue;
>   }
> 
> Furthermore, efi_arch_mem_reserve() will only accept ranges fully
> contained within such a region.
> 
> I think we can make efi_arch_mem_reserve() return early if
> EFI_MEMORY_RUNTIME has been set already and thus, neglect this case in
> efi_memmap_insert().
> 
> I suppose that we don't want to reserve within EFI_RUNTIME_SERVICES_DATA
> regions in efi_mem_reserve() either -- these won't ever get made
> available as general memory anyway [1]. So efi_arch_mem_reserve() should
> return early here as well imo.
> 
> So, what would remain to be handled from efi_memmap_insert() in case of
> boot_only would be EFI_BOOT_SERVICES_DATA only?

It sounds reasonable though I'm still not sure about EFI_LOADER*.

The main purpose of this patch is to address the invalid mem ranges
case. As Ard mentioned I will test with Peter's patch first, if it works
fine I would like to either drop this patch as a future improvement or add
it at the end of the next post.

Matt, what's your opinion about the boot_only check and the EFI_LOADERS*
question?

> 
> (As a sidenote, Matt pointed out at [1] that the EFI_LOADER_* regions
>  should be reserved early through memblock_reserve() and not through
>  efi_mem_reserve()).
> 
> Thanks,
> 
> Nicolai
> 
> 
> [1] http://lkml.kernel.org/r/20170109130702.GI16838-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org

Thanks
Dave
