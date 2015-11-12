From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 2/6] x86/mm/pageattr: Do not strip pte flags from cpa->pfn
Date: Thu, 12 Nov 2015 19:28:51 +0000
Message-ID: <20151112192851.GD2681@codeblueprint.co.uk>
References: <1447342823-3612-1-git-send-email-matt@codeblueprint.co.uk>
 <1447342823-3612-3-git-send-email-matt@codeblueprint.co.uk>
 <20151112184730.GI3838@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151112184730.GI3838@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H . Peter Anvin" <hpa@zytor.com>, Toshi Kani <toshi.kani@hp.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
List-Id: linux-efi@vger.kernel.org

On Thu, 12 Nov, at 07:47:30PM, Borislav Petkov wrote:
> On Thu, Nov 12, 2015 at 03:40:19PM +0000, Matt Fleming wrote:
> > Removing the PAGE_NX bit from cpa->pfn will corrupt the page frame
> > number address rather than removing PAGE_NX as the code intends. This
> > is unlikley to be a problem in practice because _PAGE_BIT_NX is bit 63
> > and most machines do not have page frame numbers that reach that high.
> > 
> > Still, pte flags are never stored in cpa->pfn so we can safely delete
> > the code.
> > 
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
> > Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
> > ---
> >  arch/x86/mm/pageattr.c | 5 -----
> >  1 file changed, 5 deletions(-)
> > 
> > diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> > index 893921b12272..d5240be55915 100644
> > --- a/arch/x86/mm/pageattr.c
> > +++ b/arch/x86/mm/pageattr.c
> > @@ -885,11 +885,6 @@ static void populate_pte(struct cpa_data *cpa,
> >  	pte = pte_offset_kernel(pmd, start);
> >  
> >  	while (num_pages-- && start < end) {
> > -
> > -		/* deal with the NX bit */
> > -		if (!(pgprot_val(pgprot) & _PAGE_NX))
> > -			cpa->pfn &= ~_PAGE_NX;
> > -
> >  		set_pte(pte, pfn_pte(cpa->pfn, pgprot));
> >  
> >  		start	 += PAGE_SIZE;
> > -- 
> 
> I think this should be part of the 1st patch because there you're
> correcting ->pfn to actually be a pfn.

OK, that's fine by me. I split this out into a separate patch so that
this single logical change could be debated independently of the other
->pfn change, and because I was less certain on this one.

I fold it into the first patch.
