From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 1/6] Add function efi_remap_region for remapping to saved
 virt address
Date: Mon, 28 Oct 2013 09:25:16 +0800
Message-ID: <20131028012516.GE4397@dhcp-16-126.nay.redhat.com>
References: <20131027034713.481920209@dhcp-16-126.nay.redhat.com>
 <20131027035922.776610726@dhcp-16-126.nay.redhat.com>
 <20131027115038.GB21868@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131027115038.GB21868-fF5Pk5pvG8Y@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-TuqUDEhatI4ANWPb/1PvSmm0pvjS0E/A@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi, Thanks for review

On 10/27/13 at 12:50pm, Borislav Petkov wrote:
> On Sun, Oct 27, 2013 at 11:47:14AM +0800, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> > Kexec kernel will use saved runtime virtual mapping, so add a
> > new function efi_remap_region to remapping it directly without
> > calculate the virt addr from efi_va.
> > 
> > The md is passed in from 1st kernel, the virtual addr is
> > saved in md->virt_addr.
> > 
> > Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  arch/x86/include/asm/efi.h     |    1 +
> >  arch/x86/platform/efi/efi_32.c |    4 ++++
> >  arch/x86/platform/efi/efi_64.c |   13 +++++++++++++
> >  3 files changed, 18 insertions(+)
> > 
> > --- linux-2.6.orig/arch/x86/include/asm/efi.h
> > +++ linux-2.6/arch/x86/include/asm/efi.h
> > @@ -112,6 +112,7 @@ extern void efi_call_phys_epilog(void);
> >  extern void efi_unmap_memmap(void);
> >  extern void efi_memory_uc(u64 addr, unsigned long size);
> >  extern void __init efi_map_region(efi_memory_desc_t *md);
> > +extern void __init efi_remap_region(efi_memory_desc_t *md);
> >  extern void efi_sync_low_kernel_mappings(void);
> >  extern void __init old_map_region(efi_memory_desc_t *md);
> >  
> > --- linux-2.6.orig/arch/x86/platform/efi/efi_64.c
> > +++ linux-2.6/arch/x86/platform/efi/efi_64.c
> > @@ -177,6 +177,19 @@ void __init efi_map_region(efi_memory_de
> >  	md->virt_addr = efi_va;
> >  }
> >  
> > +void __init efi_remap_region(efi_memory_desc_t *md)
> 
> remap? Why?
> 
> You did have efi_map_region_fixed() which made more sense.

remap here means mapping to same virt addr in 2nd kernel, I feel
it's a little better, but I have no strong opinion.

Will change to _fixed

> 
> > +{
> > +	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
> > +	unsigned long pf = 0;
> > +
> > +	if (!(md->attribute & EFI_MEMORY_WB))
> > +		pf |= _PAGE_PCD;
> > +
> > +	if(kernel_map_pages_in_pgd(pgd, md->phys_addr, md->virt_addr, md->num_pages, pf))
> 
> ERROR: space required before the open parenthesis '('
> #59: FILE: arch/x86/platform/efi/efi_64.c:188:
> +       if(kernel_map_pages_in_pgd(pgd, md->phys_addr, md->virt_addr, md->num_pages, pf))

Will fix

> 
> 
> Please run them all through checkpatch.pl - better yet, integrate
> checkpatch into your workflow like using git hooks, for example.

Hmm, will do. Have been long time being away from sending patches.

> 
> > +		pr_warning("Error mapping PA 0x%llx -> VA 0x%llx!\n",
> 
> WARNING: Prefer pr_warn(... to pr_warning(...
> #60: FILE: arch/x86/platform/efi/efi_64.c:189:
> +               pr_warning("Error mapping PA 0x%llx -> VA 0x%llx!\n",

Will fix

> 
> > +			   md->phys_addr, md->virt_addr);
> > +}
> > +
> >  void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
> >  				 u32 type, u64 attribute)
> >  {
> > --- linux-2.6.orig/arch/x86/platform/efi/efi_32.c
> > +++ linux-2.6/arch/x86/platform/efi/efi_32.c
> > @@ -46,6 +46,10 @@ void __init efi_map_region(efi_memory_de
> >  	old_map_region(md);
> >  }
> >  
> > +void __init efi_remap_region(efi_memory_desc_t *md)
> > +{
> > +}
> 
> Let's keep braces on the same line as the function to save space:

Ok, will update

> 
> void __init efi_remap_region(efi_memory_desc_t *md) {}
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
