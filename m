From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 4/4] efi/x86: make efi_memmap_reserve only insert into
 boot mem areas
Date: Wed, 18 Jan 2017 19:06:12 +0800
Message-ID: <20170118110612.GA7487@dhcp-128-65.nay.redhat.com>
References: <20170116024554.461236678@redhat.com>
 <20170116025026.586405871@redhat.com>
 <CAKv+Gu8C2btUOOO28LVUJ3umiS-BvEk6xi7a_OMTsuh28hoDbQ@mail.gmail.com>
 <871sw131t7.fsf@gmail.com>
 <20170118110105.GA7377@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170118110105.GA7377-0VdLhd/A9Pl+NNSt+8eSiB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila-MRsr7dthA9VWk0Htik3J/w@public.gmane.org>, Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 01/18/17 at 07:01pm, Dave Young wrote:
> On 01/17/17 at 08:48pm, Nicolai Stange wrote:
> > On Tue, Jan 17 2017, Ard Biesheuvel wrote:
> > 
> > > On 16 January 2017 at 02:45, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > >> efi_mem_reserve cares only about boot services regions, for making sure
> > >> later efi_free_boot_services does not free areas which are still useful,
> > >> such as bgrt image buffer.
> > >>
> > >> So add a new argument to efi_memmap_insert for this purpose.
> > >>
> > >
> > > So what happens is we try to efi_mem_reserve() a regions that is not
> > > bootservices code or data?
> > > We shouldn't simply ignore it, because it is a serious condition.
> > 
> > The efi_mem_desc_lookup() call in efi_arch_mem_reserve() wouldn't return
> > anything and the latter would
> > 
> >   pr_err("Failed to lookup EFI memory descriptor for %pa\n", &addr);
> > 
> > then.
> > 
> > This is so because efi_mem_desc_lookup() searches only for regions that
> > either
> > - are of type EFI_BOOT_SERVICES_DATA or EFI_RUNTIME_SERVICES_DATA
> > - or which have EFI_MEMORY_RUNTIME set already:
> > 
> > 	if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
> > 	    md->type != EFI_BOOT_SERVICES_DATA &&
> > 	    md->type != EFI_RUNTIME_SERVICES_DATA) {
> > 		continue;
> > 	}
> > 
> > For EFI_RUNTIME_SERVICES_DATA and EFI_MEMORY_RUNTIME,
> > efi_arch_mem_reserve() would be a nop.
> > 
> > So we're fine here? Do you want to have a more descriptive error message
> > than "Failed to lookup EFI memory descriptor"?
> > 
> > 
> > For the other checks you suggested in that other thread, i.e. for the
> > post-slab_is_available() condition and so: let me wait until Dave's
> > series has stabilized (or even picked) and I'll submit patches for
> > what remains to be sanity checked then.
> > 
> > Also, since Dave eliminated the need for late efi_mem_reserve()'s,
> > my 20b1e22d01a4 ("x86/efi: Don't allocate memmap through memblock after
> > mm_init()") should certainly get reverted at some point.
> 
> While testing my patches with latest edk2, I found another thing to be
> fixed, I will repost bgrt patch according to Ard's comment tomorrow,
> maybe with below patch as another fix to the memblock_alloc late
> callback.
> 
> ---
>  arch/x86/platform/efi/quirks.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-x86.orig/arch/x86/platform/efi/quirks.c
> +++ linux-x86/arch/x86/platform/efi/quirks.c
> @@ -355,7 +355,7 @@ void __init efi_free_boot_services(void)
>  	}
>  
>  	new_size = efi.memmap.desc_size * num_entries;
> -	new_phys = kzalloc(new_size, GFP_KERNEL);

Oops, it was memblock_alloc(), this is a middle test code used for
debugging. Just ignore it.

> +	new_phys = efi_memmap_alloc(num_entries);

Maybe a efi_memmap_late_alloc is enough, will see if I can get a better
version, maybe your previous patch can be dropped partially or just
kept.

>  	if (!new_phys) {
>  		pr_err("Failed to allocate new EFI memmap\n");
>  		return;
> 
> > 
> > 
> > Thanks,
> > 
> > Nicolai
