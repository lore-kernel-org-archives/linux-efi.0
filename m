From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2 1/5] x86/mm/pageattr: Ensure cpa->pfn only contains
 page frame numbers
Date: Tue, 17 Nov 2015 09:44:10 +0000
Message-ID: <20151117094410.GA2727@codeblueprint.co.uk>
References: <1447538451-5793-1-git-send-email-matt@codeblueprint.co.uk>
 <1447538451-5793-2-git-send-email-matt@codeblueprint.co.uk>
 <5649FCA1.1000600@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5649FCA1.1000600-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 16 Nov, at 07:56:17AM, Dave Hansen wrote:
> I'm glad you're looking at this. It obviously needed some love. :)
> 
> On 11/14/2015 02:00 PM, Matt Fleming wrote:
> > +	npages = (_end - _text) >> PAGE_SHIFT;
> > +	text = __pa(_text);
> > +	pfn = text >> PAGE_SHIFT;
> > +
> > +	if (kernel_map_pages_in_pgd(pgd, pfn, text, npages, 0)) {
> > +		pr_err("Failed to map kernel text 1:1\n");
> > +		return 1;
> > +	}
> 
> Are _end and _text guaranteed to be aligned?  If not, I think the
> calculation might be wrong.  Just for fun, imagine that _end=0xfff and
> _text=0x1001.  npages would be 0.
 
Bugger. Good catch, thanks.

> Some other code like set_kernel_text_rw() does alignment on _text.
> 
> One nit is that there's quite a bit going on here, like rearranging the
> phys_stack arithmetic ordering that is far beyond just simplifying the
> paddr vs. pfn issue, but that isn't called out in the changelog at all.
 
Yeah, the phys_stack hunk actually slipped into this patch by
accident. It ensures the stack is mapped into the EFI page tables.
I'll split this out.

> Your fixes all look correct to me, fwiw.

Thanks! If you could respond to the next version with an ACK or
Reviewed-by tag, that'd be great.
