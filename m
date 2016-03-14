From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Always map boot service regions into new EFI
 page tables
Date: Mon, 14 Mar 2016 14:27:34 +0000
Message-ID: <20160314142734.GE2619@codeblueprint.co.uk>
References: <1457695163-29632-1-git-send-email-matt@codeblueprint.co.uk>
 <1457695163-29632-2-git-send-email-matt@codeblueprint.co.uk>
 <1457888975.3884.9.camel@talk21.com>
 <20160313215847.GA2619@codeblueprint.co.uk>
 <20160313230736.GB2619@codeblueprint.co.uk>
 <20160314103019.GA32573@gmail.com>
 <20160314113502.GC2619@codeblueprint.co.uk>
 <20160314120502.GA17388@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="tKW2IUtsqtDRztdT"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160314120502.GA17388-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Scott Ashcroft <scott.ashcroft-qw6QB7/foO7QT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, Raphael Hertzog <hertzog-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>, Roger Shimizu <rogershimizu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexis Murzeau <amurzeau-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, 14 Mar, at 01:05:02PM, Ingo Molnar wrote:
> 
> There's a number of such occurences that look suspicious:
> 
>  triton:~/tip> git grep 'cpa->pfn.*<<.*PAGE_SHIFT' arch/x86/
>  arch/x86/mm/pageattr.c:         set_pmd(pmd, __pmd(cpa->pfn << PAGE_SHIFT | _PAGE_PSE |
>  arch/x86/mm/pageattr.c:         set_pud(pud, __pud(cpa->pfn << PAGE_SHIFT | _PAGE_PSE |
>  arch/x86/mm/pageattr.c: unsigned long laddr = (unsigned long)__va(cpa->pfn << PAGE_SHIFT);
>  arch/x86/mm/pageattr.c:         unsigned long temp_cpa_vaddr = (cpa->pfn << PAGE_SHIFT) +
> 
> are you sure none of the code runs on 32-bit?

The following occurrences do not run on 32-bit,

>  arch/x86/mm/pageattr.c:         set_pmd(pmd, __pmd(cpa->pfn << PAGE_SHIFT | _PAGE_PSE |
>  arch/x86/mm/pageattr.c:         set_pud(pud, __pud(cpa->pfn << PAGE_SHIFT | _PAGE_PSE |

but these might,

>  arch/x86/mm/pageattr.c: unsigned long laddr = (unsigned long)__va(cpa->pfn << PAGE_SHIFT);
>  arch/x86/mm/pageattr.c:         unsigned long temp_cpa_vaddr = (cpa->pfn << PAGE_SHIFT) +

> All this got introduced with:
> 
> | commit edc3b9129cecd0f0857112136f5b8b1bc1d45918
> | Author: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> | Date:   Fri Nov 27 21:09:31 2015 +0000
> |
> |    x86/mm/pat: Ensure cpa->pfn only contains page frame numbers
> 
> AFAICS.
 
Kinda. The bugs that do not run on 32-bit were introduced with this
commit. The ones that will run on 32-bit existed before this.

Running the attached semantic patch across arch/x86/mm yields a few
more places where we get the data type wrong for PAE,
 
* file: arch/x86/mm/mmap.c:43 shifting int '( ( - 1UL ) & STACK_RND_MASK )' by PAGE_SHIFT is truncated to 32-bits
* file: arch/x86/mm/pageattr-test.c:57 shifting long 'i' by PAGE_SHIFT is truncated to 32-bits for PAE
* file: arch/x86/mm/pageattr-test.c:138 shifting unsigned long 'pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
* file: arch/x86/mm/gup.c:422 shifting int 'nr' by PAGE_SHIFT is truncated to 32-bits
* file: arch/x86/mm/gup.c:303 shifting unsigned long '( unsigned long ) nr_pages' by PAGE_SHIFT is truncated to 32-bits for PAE
* file: arch/x86/mm/gup.c:370 shifting unsigned long '( unsigned long ) nr_pages' by PAGE_SHIFT is truncated to 32-bits for PAE
* file: arch/x86/mm/pat.c:751 shifting unsigned long 'pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
* file: arch/x86/mm/pageattr-test.c:57 shifting long 'i' by PAGE_SHIFT is truncated to 32-bits for PAE
* file: arch/x86/mm/pageattr.c:947 shifting unsigned 'num_pages' by PAGE_SHIFT is truncated to 32-bits
* file: arch/x86/mm/pageattr.c:1995 shifting unsigned 'numpages' by PAGE_SHIFT is truncated to 32-bits
* file: arch/x86/mm/pageattr-test.c:138 shifting unsigned long 'pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
* file: arch/x86/mm/pageattr.c:1117 shifting unsigned long 'cpa -> numpages' by PAGE_SHIFT is truncated to 32-bits for PAE
* file: arch/x86/mm/pageattr.c:1017 shifting unsigned long 'cpa -> numpages' by PAGE_SHIFT is truncated to 32-bits for PAE
* file: arch/x86/mm/pageattr.c:1277 shifting unsigned long 'cpa -> pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
* file: arch/x86/mm/pageattr.c:1318 shifting unsigned long 'cpa -> pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
* file: arch/x86/mm/pageattr.c:986 shifting unsigned long 'cpa -> pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
* file: arch/x86/mm/pageattr.c:1059 shifting unsigned long 'cpa -> pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
* file: arch/x86/mm/init.c:197 shifting unsigned long 'end_pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
* file: arch/x86/mm/init.c:100 shifting unsigned long 'min_pfn_mapped' by PAGE_SHIFT is truncated to 32-bits for PAE
* file: arch/x86/mm/init.c:641 shifting unsigned long 'pagenr' by PAGE_SHIFT is truncated to 32-bits for PAE
* file: arch/x86/mm/init.c:111 shifting unsigned long 'pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
* file: arch/x86/mm/init.c:121 shifting unsigned long 'pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
* file: arch/x86/mm/init.c:111 shifting unsigned long __initdata 'pgt_buf_end' by PAGE_SHIFT is truncated to 32-bits
* file: arch/x86/mm/init.c:196 shifting unsigned long 'start_pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
* file: arch/x86/mm/init.c:91 shifting unsigned long '( unsigned long ) num' by PAGE_SHIFT is truncated to 32-bits for PAE
* file: arch/x86/mm/init.c:117 shifting unsigned long '( pfn + i )' by PAGE_SHIFT is truncated to 32-bits for PAE
* file: arch/x86/mm/init_32.c:293 shifting unsigned long 'pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
* file: arch/x86/mm/init_32.c:301 shifting unsigned long 'pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
* file: arch/x86/mm/init_32.c:344 shifting unsigned long 'pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
* file: arch/x86/mm/init_32.c:361 shifting unsigned long 'pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
* file: arch/x86/mm/init_32.c:471 shifting unsigned long 'pfn' by PAGE_SHIFT is truncated to 32-bits for PAE

The coccinelle script isn't perfect, and there are a number of false
positives. For example, the first hit is bogus and looks like a
coccinelle bug, but the results do show some things that need to be
investigated.

Running it over arch/x86/ turns up 66 potential issues.

--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="page-shift.cocci"

// A variable declared as a 32-bit data type should not be shifted by
// PAGE_SHIFT because the result may not fit in sizeof(T) for large
// numbers of pages, or high page frame numbers, e.g. both of these
// are potentially bogus:
//
//	unsigned long pfn;
//	unsigned int numpages;
//	...
//	unsigned long pa = pfn << PAGE_SHIFT;
//	unsigned long size = numpages << PAGE_SHIFT;
//
// Options: --no-includes --include-headers

virtual context
virtual report
virtual org

@inttrunc@
{int, unsigned int, size_t, signed int, long, unsigned long, signed long} i;
position p;
type tt; tt i1;
@@

 \(i@p\&i1\) << PAGE_SHIFT

@script:python@
p << inttrunc.p;
i << inttrunc.i;
tt << inttrunc.tt;
@@
pae_types = ["unsigned long", "signed long", "long"]

print "* file: %s:%s shifting %s '%s' by PAGE_SHIFT is truncated to 32-bits%s" % \
	(p[0].file, p[0].line, tt, i, \
		" for PAE" if tt in pae_types else "")

--tKW2IUtsqtDRztdT--
