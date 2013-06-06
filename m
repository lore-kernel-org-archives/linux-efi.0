From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH 2/4] x86, cpa: Map in an arbitrary pgd
Date: Thu, 6 Jun 2013 15:24:06 +0200
Message-ID: <20130606132406.GC20972@pd.tnic>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <1370177770-26661-3-git-send-email-bp@alien8.de>
 <20130606102233.GG30420@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130606102233.GG30420-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, X86-ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 06, 2013 at 11:22:33AM +0100, Matt Fleming wrote:
> > @@ -697,7 +714,10 @@ static int __change_page_attr(struct cpa_data *cpa, int primary)
> >  	else
> >  		address = *cpa->vaddr;
> >  repeat:
> > -	kpte = lookup_address(address, &level);
> > +	if (cpa->pgd)
> > +		kpte = __lookup_address_in_pgd(cpa->pgd, address, &level);
> > +	else
> > +		kpte = _lookup_address_cpa(cpa, address, &level);
> 
> Don't you also need to initialise .pgd in __set_pages_p() and
> __set_pages_np()?

Hmm, I don't think so. The idea is to leave the current functionality in
pageattr.c untouched. Currently, it maps PTEs in init_mm.pgd by default
because this is the kernel PGD.

For EFI, we switch the PGD and we want to map the PTEs in this other
PGD, thus we have our own kernel_map_pages_in_pgd() which passes in the
PGD we want to map in through struct cpa_data.

Then, we differentiate the PGD down that code by looking at cpa->pgd.

This was at least the idea.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
