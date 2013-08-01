From: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/4] efi: x86: make efi_lookup_mapped_addr() a common
 function
Date: Thu, 1 Aug 2013 12:11:55 +0200
Message-ID: <20130801101155.GK18151@rocoto.smurfnet.nu>
References: <1375202858-28470-1-git-send-email-leif.lindholm@linaro.org>
 <1375202858-28470-5-git-send-email-leif.lindholm@linaro.org>
 <51F8D1AC.4040501@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <51F8D1AC.4040501-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Jul 31, 2013 at 09:58:20AM +0100, Matt Fleming wrote:
> On 07/30/2013 05:47 PM, Leif Lindholm wrote:
> > efi_lookup_mapped_addr() is a handy utility for other platforms
> > than x86. Move it from arch/x86 to drivers/firmware/efi.
> > 
> > This function will be used by future ARM patches.
> > 
> > Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> > ---
> >  arch/x86/platform/efi/efi.c |   28 ----------------------------
> >  drivers/firmware/efi/efi.c  |   30 ++++++++++++++++++++++++++++++
> >  2 files changed, 30 insertions(+), 28 deletions(-)
> > 
> 
> [...]
> 
> > +#if defined(CONFIG_X86)
> > +/*
> > + * We can't ioremap data in EFI boot services RAM, because we've already mapped
> > + * it as RAM.  So, look it up in the existing EFI memory map instead.  Only
> > + * callable after efi_enter_virtual_mode and before efi_free_boot_services.
> > + */
> > +void __iomem *efi_lookup_mapped_addr(u64 phys_addr)
> > +{
> > +	void *p;
> > +	if (WARN_ON(!memmap.map))
> > +		return NULL;
> > +	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
> > +		efi_memory_desc_t *md = p;
> > +		u64 size = md->num_pages << EFI_PAGE_SHIFT;
> > +		u64 end = md->phys_addr + size;
> > +		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
> > +		    md->type != EFI_BOOT_SERVICES_CODE &&
> > +		    md->type != EFI_BOOT_SERVICES_DATA)
> > +			continue;
> > +		if (!md->virt_addr)
> > +			continue;
> > +		if (phys_addr >= md->phys_addr && phys_addr < end) {
> > +			phys_addr += md->virt_addr - md->phys_addr;
> > +			return (__force void __iomem *)(unsigned long)phys_addr;
> > +		}
> > +	}
> > +	return NULL;
> > +}
> > +#endif
> > +
> 
> If we hang a 'struct efi_memory_map' off of 'struct efi', can we get rid
> of this #ifdef?

Sure.

It would just be a small bit of wasted memory for IA64 (struct +
code). On the flip side, having that on all platforms could lend
itself to making a little bit more code common.

Tony?

/
    Leif
