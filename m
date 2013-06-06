From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH 2/4] x86, cpa: Map in an arbitrary pgd
Date: Thu, 6 Jun 2013 14:30:23 +0100
Message-ID: <20130606133023.GJ30420@console-pimps.org>
References: <1370177770-26661-1-git-send-email-bp@alien8.de>
 <1370177770-26661-3-git-send-email-bp@alien8.de>
 <20130606102233.GG30420@console-pimps.org>
 <20130606132406.GC20972@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130606132406.GC20972@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Linux EFI <linux-efi@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>, Jiri Kosina <jkosina@suse.cz>, X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
List-Id: linux-efi@vger.kernel.org

On Thu, 06 Jun, at 03:24:06PM, Borislav Petkov wrote:
> On Thu, Jun 06, 2013 at 11:22:33AM +0100, Matt Fleming wrote:
> > > @@ -697,7 +714,10 @@ static int __change_page_attr(struct cpa_data *cpa, int primary)
> > >  	else
> > >  		address = *cpa->vaddr;
> > >  repeat:
> > > -	kpte = lookup_address(address, &level);
> > > +	if (cpa->pgd)
> > > +		kpte = __lookup_address_in_pgd(cpa->pgd, address, &level);
> > > +	else
> > > +		kpte = _lookup_address_cpa(cpa, address, &level);
> > 
> > Don't you also need to initialise .pgd in __set_pages_p() and
> > __set_pages_np()?
> 
> Hmm, I don't think so. The idea is to leave the current functionality in
> pageattr.c untouched. Currently, it maps PTEs in init_mm.pgd by default
> because this is the kernel PGD.

I meant because the .pgd member is uninitialised and contains garbage.

-- 
Matt Fleming, Intel Open Source Technology Center
