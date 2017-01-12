From: Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH 3/4] efi/x86: move efi_print_memmap to
 drivers/firmware/efi/memmap.c
Date: Fri, 13 Jan 2017 05:40:29 +0800
Message-ID: <20170112214029.GE2709@dhcp-128-65.nay.redhat.com>
References: <20170112094118.815108042@redhat.com>
 <20170112094214.964092881@redhat.com>
 <87wpe0o50c.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87wpe0o50c.fsf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicolai Stange <nicstange@gmail.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com, Dan Williams <dan.j.williams@intel.com>, mika.penttila@nextfour.com, bhsharma@redhat.com
List-Id: linux-efi@vger.kernel.org

On 01/12/17 at 01:08pm, Nicolai Stange wrote:
> On Thu, Jan 12 2017, Dave Young wrote:
> 
> > Signed-off-by: Dave Young <dyoung@redhat.com>
> > ---
> >  arch/x86/platform/efi/efi.c   |   16 ----------------
> >  drivers/firmware/efi/memmap.c |   16 ++++++++++++++++
> >  2 files changed, 16 insertions(+), 16 deletions(-)
> >
> > --- linux-x86.orig/arch/x86/platform/efi/efi.c
> > +++ linux-x86/arch/x86/platform/efi/efi.c
> > @@ -210,22 +210,6 @@ int __init efi_memblock_x86_reserve_rang
> >  	return 0;
> >  }
> >  
> > -void __init efi_print_memmap(void)
> > -{
> > -	efi_memory_desc_t *md;
> > -	int i = 0;
> > -
> > -	for_each_efi_memory_desc(md) {
> > -		char buf[64];
> > -
> > -		pr_info("mem%02u: %s range=[0x%016llx-0x%016llx] (%lluMB)\n",
> > -			i++, efi_md_typeattr_format(buf, sizeof(buf), md),
> > -			md->phys_addr,
> > -			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1,
> > -			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
> > -	}
> > -}
> > -
> >  static int __init efi_systab_init(void *phys)
> >  {
> >  	if (efi_enabled(EFI_64BIT)) {
> > --- linux-x86.orig/drivers/firmware/efi/memmap.c
> > +++ linux-x86/drivers/firmware/efi/memmap.c
> > @@ -10,6 +10,22 @@
> >  #include <linux/io.h>
> >  #include <asm/early_ioremap.h>
> >  
> > +void __init efi_print_memmap(void)
> > +{
> > +	efi_memory_desc_t *md;
> > +	int i = 0;
> > +
> > +	for_each_efi_memory_desc(md) {
> > +		char buf[64];
> > +
> > +		pr_info("mem%02u: %s range=[0x%016llx-0x%016llx] (%lluMB)\n",
> > +			i++, efi_md_typeattr_format(buf, sizeof(buf), md),
> > +			md->phys_addr,
> > +			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1,
> > +			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
> > +	}
> > +}
> > +
> >  /**
> >   * __efi_memmap_init - Common code for mapping the EFI memory map
> >   * @data: EFI memory map data
> 
> Shouldn't the declaration in arch/x86/include/asm/efi.h get moved as well?

Good catch, will change it as well

Thanks
Dave
