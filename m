From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [patch 1/7 v2] Add function efi_remap_region for remapping to
 saved virt address
Date: Thu, 14 Nov 2013 09:38:19 +0800
Message-ID: <20131114013818.GB4081@dhcp-16-126.nay.redhat.com>
References: <20131105082007.872550445@dhcp-16-126.nay.redhat.com>
 <20131105082715.502723229@dhcp-16-126.nay.redhat.com>
 <20131113155008.GA17248@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131113155008.GA17248-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 11/13/13 at 03:50pm, Matt Fleming wrote:
> On Tue, 05 Nov, at 04:20:08PM, dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
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
> >  arch/x86/platform/efi/efi_32.c |    3 +++
> >  arch/x86/platform/efi/efi_64.c |   19 +++++++++++++++++++
> >  3 files changed, 23 insertions(+)
> 
> [...]
> 
> > @@ -203,6 +203,25 @@ void __init efi_map_region(efi_memory_de
> >  	md->virt_addr = efi_va;
> >  }
> >  
> > +/*
> > + * kexec kernel will use efi_map_region_fixed to map efi
> > + * runtime memory ranges. md->virt_addr is the original virtual
> > + * address which had been mapped in kexec 1st kernel.
> > + */
> > +void __init efi_map_region_fixed(efi_memory_desc_t *md)
> > +{
> > +	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
> > +	unsigned long pf = 0;
> > +
> > +	if (!(md->attribute & EFI_MEMORY_WB))
> > +		pf |= _PAGE_PCD;
> > +
> > +	if (kernel_map_pages_in_pgd(pgd, md->phys_addr, md->virt_addr,
> > +			md->num_pages, pf))
> > +		pr_warn("Error mapping PA 0x%llx -> VA 0x%llx!\n",
> > +			   md->phys_addr, md->virt_addr);
> > +}
> > +
> 
> This function is almost identical to __map_region(). Please implement
> efi_map_region_fixed() in terms of __map_region(), e.g.
> 
> void __init efi_map_region_fixed(efi_memory_desc_t *md)
> {
> 	__map_region(md, md->virt_addr);
> }

Good suggestion, will do

> 
> > @@ -47,6 +47,9 @@ void __init efi_map_region(efi_memory_de
> >  	old_map_region(md);
> >  }
> >  
> > +void __init efi_map_region_fixed(efi_memory_desc_t *md)
> > +{}
> > +
> 
> The braces should be on the same line as the rest of the function
> prototype. Look at how it's done elsewhere in this file.

Ok, will do

> 
> -- 
> Matt Fleming, Intel Open Source Technology Center
