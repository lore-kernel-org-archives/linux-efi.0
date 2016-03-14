From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Always map boot service regions into new EFI
 page tables
Date: Mon, 14 Mar 2016 13:05:02 +0100
Message-ID: <20160314120502.GA17388@gmail.com>
References: <1457695163-29632-1-git-send-email-matt@codeblueprint.co.uk>
 <1457695163-29632-2-git-send-email-matt@codeblueprint.co.uk>
 <1457888975.3884.9.camel@talk21.com>
 <20160313215847.GA2619@codeblueprint.co.uk>
 <20160313230736.GB2619@codeblueprint.co.uk>
 <20160314103019.GA32573@gmail.com>
 <20160314113502.GC2619@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160314113502.GC2619-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Scott Ashcroft <scott.ashcroft-qw6QB7/foO7QT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, Raphael Hertzog <hertzog-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>, Roger Shimizu <rogershimizu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexis Murzeau <amurzeau-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:

> On Mon, 14 Mar, at 11:30:19AM, Ingo Molnar wrote:
> > 
> > * Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> > 
> > > diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
> > > index 8fee5b6f8f66..af74849e8c0f 100644
> > > --- a/arch/x86/mm/pageattr.c
> > > +++ b/arch/x86/mm/pageattr.c
> > > @@ -1055,7 +1055,7 @@ static int populate_pud(struct cpa_data *cpa, unsigned long start, pgd_t *pgd,
> > >  	/*
> > >  	 * Map everything starting from the Gb boundary, possibly with 1G pages
> > >  	 */
> > > -	while (end - start >= PUD_SIZE) {
> > > +	while (cpu_has_gbpages && end - start >= PUD_SIZE) {
> > >  		set_pud(pud, __pud(cpa->pfn << PAGE_SHIFT | _PAGE_PSE |
> > >  				   massage_pgprot(pud_pgprot)));
> > 
> > Btw., can 'cpa->pfn << PAGE_SHIFT' possibly work on 32-bit systems?
> > 
> > cpa->pfn is unsigned long, so the result gets truncated to 32 bits ...
> > 
> > cpa->pfn should be u64.
> 
> That is a nice catch.
> 
> Note that we never run this code on 32-bit right now. Moving 32-bit to
> this code and away from the old_map scheme is on my TODO list.

There's a number of such occurences that look suspicious:

 triton:~/tip> git grep 'cpa->pfn.*<<.*PAGE_SHIFT' arch/x86/
 arch/x86/mm/pageattr.c:         set_pmd(pmd, __pmd(cpa->pfn << PAGE_SHIFT | _PAGE_PSE |
 arch/x86/mm/pageattr.c:         set_pud(pud, __pud(cpa->pfn << PAGE_SHIFT | _PAGE_PSE |
 arch/x86/mm/pageattr.c: unsigned long laddr = (unsigned long)__va(cpa->pfn << PAGE_SHIFT);
 arch/x86/mm/pageattr.c:         unsigned long temp_cpa_vaddr = (cpa->pfn << PAGE_SHIFT) +

are you sure none of the code runs on 32-bit?

All this got introduced with:

| commit edc3b9129cecd0f0857112136f5b8b1bc1d45918
| Author: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
| Date:   Fri Nov 27 21:09:31 2015 +0000
|
|    x86/mm/pat: Ensure cpa->pfn only contains page frame numbers

AFAICS.

Even if none of this is run on 32-bit, we should really fix it to be u64, because 
the code is really bogus and the fix is easy ...

Thanks,

	Ingo
