From: Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Always map boot service regions into new EFI
 page tables
Date: Tue, 15 Mar 2016 17:25:25 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1603151723560.2531@hadrien>
References: <1457695163-29632-1-git-send-email-matt@codeblueprint.co.uk> <1457695163-29632-2-git-send-email-matt@codeblueprint.co.uk> <1457888975.3884.9.camel@talk21.com> <20160313215847.GA2619@codeblueprint.co.uk> <20160313230736.GB2619@codeblueprint.co.uk>
 <20160314103019.GA32573@gmail.com> <20160314113502.GC2619@codeblueprint.co.uk> <20160314120502.GA17388@gmail.com> <20160314142734.GE2619@codeblueprint.co.uk> <20160314164700.GA21726@gmail.com> <20160315155418.GH2619@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160315155418.GH2619-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Scott Ashcroft <scott.ashcroft-qw6QB7/foO7QT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, Raphael Hertzog <hertzog-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>, Roger Shimizu <rogershimizu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexis Murzeau <amurzeau-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



On Tue, 15 Mar 2016, Matt Fleming wrote:

> On Mon, 14 Mar, at 05:47:00PM, Ingo Molnar wrote:
> >
> > * Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> >
> > > Running the attached semantic patch across arch/x86/mm yields a few
> > > more places where we get the data type wrong for PAE,
> >
> > Very nice!
> >
> > > * file: arch/x86/mm/mmap.c:43 shifting int '( ( - 1UL ) & STACK_RND_MASK )' by PAGE_SHIFT is truncated to 32-bits
> > > * file: arch/x86/mm/pageattr-test.c:57 shifting long 'i' by PAGE_SHIFT is truncated to 32-bits for PAE
> > > * file: arch/x86/mm/pageattr-test.c:138 shifting unsigned long 'pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
> > > * file: arch/x86/mm/gup.c:422 shifting int 'nr' by PAGE_SHIFT is truncated to 32-bits
> > > * file: arch/x86/mm/gup.c:303 shifting unsigned long '( unsigned long ) nr_pages' by PAGE_SHIFT is truncated to 32-bits for PAE
> > > * file: arch/x86/mm/gup.c:370 shifting unsigned long '( unsigned long ) nr_pages' by PAGE_SHIFT is truncated to 32-bits for PAE
> > > * file: arch/x86/mm/pat.c:751 shifting unsigned long 'pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
> > > * file: arch/x86/mm/pageattr-test.c:57 shifting long 'i' by PAGE_SHIFT is truncated to 32-bits for PAE
> > > * file: arch/x86/mm/pageattr.c:947 shifting unsigned 'num_pages' by PAGE_SHIFT is truncated to 32-bits
> > > * file: arch/x86/mm/pageattr.c:1995 shifting unsigned 'numpages' by PAGE_SHIFT is truncated to 32-bits
> > > * file: arch/x86/mm/pageattr-test.c:138 shifting unsigned long 'pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
> > > * file: arch/x86/mm/pageattr.c:1117 shifting unsigned long 'cpa -> numpages' by PAGE_SHIFT is truncated to 32-bits for PAE
> > > * file: arch/x86/mm/pageattr.c:1017 shifting unsigned long 'cpa -> numpages' by PAGE_SHIFT is truncated to 32-bits for PAE
> > > * file: arch/x86/mm/pageattr.c:1277 shifting unsigned long 'cpa -> pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
> > > * file: arch/x86/mm/pageattr.c:1318 shifting unsigned long 'cpa -> pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
> > > * file: arch/x86/mm/pageattr.c:986 shifting unsigned long 'cpa -> pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
> > > * file: arch/x86/mm/pageattr.c:1059 shifting unsigned long 'cpa -> pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
> > > * file: arch/x86/mm/init.c:197 shifting unsigned long 'end_pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
> > > * file: arch/x86/mm/init.c:100 shifting unsigned long 'min_pfn_mapped' by PAGE_SHIFT is truncated to 32-bits for PAE
> > > * file: arch/x86/mm/init.c:641 shifting unsigned long 'pagenr' by PAGE_SHIFT is truncated to 32-bits for PAE
> > > * file: arch/x86/mm/init.c:111 shifting unsigned long 'pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
> > > * file: arch/x86/mm/init.c:121 shifting unsigned long 'pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
> > > * file: arch/x86/mm/init.c:111 shifting unsigned long __initdata 'pgt_buf_end' by PAGE_SHIFT is truncated to 32-bits
> > > * file: arch/x86/mm/init.c:196 shifting unsigned long 'start_pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
> > > * file: arch/x86/mm/init.c:91 shifting unsigned long '( unsigned long ) num' by PAGE_SHIFT is truncated to 32-bits for PAE
> > > * file: arch/x86/mm/init.c:117 shifting unsigned long '( pfn + i )' by PAGE_SHIFT is truncated to 32-bits for PAE
> > > * file: arch/x86/mm/init_32.c:293 shifting unsigned long 'pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
> > > * file: arch/x86/mm/init_32.c:301 shifting unsigned long 'pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
> > > * file: arch/x86/mm/init_32.c:344 shifting unsigned long 'pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
> > > * file: arch/x86/mm/init_32.c:361 shifting unsigned long 'pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
> > > * file: arch/x86/mm/init_32.c:471 shifting unsigned long 'pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
> > >
> > > The coccinelle script isn't perfect, and there are a number of false
> > > positives. For example, the first hit is bogus and looks like a
> > > coccinelle bug, but the results do show some things that need to be
> > > investigated.
> >
> > So I checked a few random examples in your list, and the false positive rate looks
> > rather low.
> >
> > The current Kbuild integration of Cocci scripts is pretty user-hostile. I'd love
> > to make this Cocci check part of the regular build process in some fashion (if a
> > Kconfig option is enabled), similarly to how we run objtool for example. We could
> > emit the Cocci warnings as a regular compiler 'warning: ' message, so people will
> > notice them as part of the build?
>
> For this type of cocci script where architecture knowledge of bug
> idioms is required (you need to know shifting by "PAGE_SHIFT" is
> usually done to build an address or size of some kind) I think the
> first step would be to automatically lookup scripts to be run on a
> per-directory basis.
>
> For example, running make(1) in arch/x86/kernel should map to
> scripts/coccinelle/arch/x86/kernel, etc.

Considering the current organization of make coccicheck, I think it would
be easier for Coccinelle to just abort on files not in the desired
directories.  This is possible to encode, although perhaps a little bit
awkward.

julia


> And yes, I agree, turning this on via a CONFIG_* symbol would be nice.
>
> > The false positive(s) could either be worked around or annotated away.
> >
> > Obviously we'd only use Cocci scripts that are known to be reliable.
>
> Fengguang, do you run coccinelle scripts currently as part of the
> 0-day lkp build machinery?
>
