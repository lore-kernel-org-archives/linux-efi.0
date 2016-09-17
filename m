From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [tip regression]  efi: Allow drivers to reserve boot services
 forever == toxic
Date: Sat, 17 Sep 2016 20:58:54 +0100
Message-ID: <20160917195853.GG16797@codeblueprint.co.uk>
References: <1474005912.3930.10.camel@gmail.com>
 <20160916093149.GC16797@codeblueprint.co.uk>
 <1474020059.3881.3.camel@gmail.com>
 <20160916143007.GF16797@codeblueprint.co.uk>
 <1474043695.3854.3.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1474043695.3854.3.camel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 16 Sep, at 06:34:55PM, Mike Galbraith wrote:
> On Fri, 2016-09-16 at 15:30 +0100, Matt Fleming wrote:
> > On Fri, 16 Sep, at 12:00:59PM, Mike Galbraith wrote:
> > > 
> > > Ok, here's the whole thing just in case.  Hope it's not too big.
> >  
> > [...]
> > 
> > > [    0.000000] esrt: Reserving ESRT space from 0x00000000def87998 to 0x00000000def879d0.
> > 
> > OK, that's 56 bytes and yet I realise that at no point in the
> > efi_mem_reserve() call path do we round up to the nearest page size
> > even though the EFI memory map only deals with EFI_PAGE_SIZE regions.
> > 
> > Could you try this patch?
> 
> No dice.  The numbers changed, but box still goes *poof*.
> 
> ---
>  arch/x86/platform/efi/quirks.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> --- a/arch/x86/platform/efi/quirks.c
> +++ b/arch/x86/platform/efi/quirks.c
> @@ -227,7 +227,11 @@ void __init efi_arch_mem_reserve(phys_ad
>  	efi_memmap_insert(&efi.memmap, new, &mr);
>  	early_memunmap(new, new_size);
>  
> +#if 0
>  	efi_memmap_install(new_phys, num_entries);
> +#else
> +	printk(KERN_DEBUG "MIKE efi_memmap_install(0x%Lx, %d);\n", new_phys, num_entries);
> +#endif
>  }
>  
>  /*
> 
> homer:..debug/tracing # journalctl|grep MIKE
> virgin+above
> Sep 16 15:51:15 homer kernel: MIKE efi_memmap_install(0x9d640, 51);
> Sep 16 15:55:07 homer kernel: MIKE efi_memmap_install(0x9d640, 51);
> +patch+above
> Sep 16 18:13:46 homer kernel: MIKE efi_memmap_install(0x9d600, 53);

These addresses are pretty low. Can you try the hacky patch plus
Ricardo's change in commit 3dad6f7f6975 ("x86/efi: Defer efi_esrt_init
until after memblock_x86_fill"). He fixed a bug where it's possible to
run out of memblock regions.
