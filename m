From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] x86/efi: Always map boot service regions into new EFI
 page tables
Date: Tue, 15 Mar 2016 15:54:18 +0000
Message-ID: <20160315155418.GH2619@codeblueprint.co.uk>
References: <1457695163-29632-1-git-send-email-matt@codeblueprint.co.uk>
 <1457695163-29632-2-git-send-email-matt@codeblueprint.co.uk>
 <1457888975.3884.9.camel@talk21.com>
 <20160313215847.GA2619@codeblueprint.co.uk>
 <20160313230736.GB2619@codeblueprint.co.uk>
 <20160314103019.GA32573@gmail.com>
 <20160314113502.GC2619@codeblueprint.co.uk>
 <20160314120502.GA17388@gmail.com>
 <20160314142734.GE2619@codeblueprint.co.uk>
 <20160314164700.GA21726@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160314164700.GA21726@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Scott Ashcroft <scott.ashcroft@talk21.com>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Matthew Garrett <mjg59@srcf.ucam.org>, Borislav Petkov <bp@alien8.de>, Ben Hutchings <ben@decadent.org.uk>, Raphael Hertzog <hertzog@debian.org>, Roger Shimizu <rogershimizu@gmail.com>, Alexis Murzeau <amurzeau@gmail.com>, Julia Lawall <julia.lawall@lip6.fr>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Josh Poimboeuf <jpoimboe@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>
List-Id: linux-efi@vger.kernel.org

On Mon, 14 Mar, at 05:47:00PM, Ingo Molnar wrote:
> 
> * Matt Fleming <matt@codeblueprint.co.uk> wrote:
> 
> > Running the attached semantic patch across arch/x86/mm yields a few
> > more places where we get the data type wrong for PAE,
> 
> Very nice!
> 
> > * file: arch/x86/mm/mmap.c:43 shifting int '( ( - 1UL ) & STACK_RND_MASK )' by PAGE_SHIFT is truncated to 32-bits
> > * file: arch/x86/mm/pageattr-test.c:57 shifting long 'i' by PAGE_SHIFT is truncated to 32-bits for PAE
> > * file: arch/x86/mm/pageattr-test.c:138 shifting unsigned long 'pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
> > * file: arch/x86/mm/gup.c:422 shifting int 'nr' by PAGE_SHIFT is truncated to 32-bits
> > * file: arch/x86/mm/gup.c:303 shifting unsigned long '( unsigned long ) nr_pages' by PAGE_SHIFT is truncated to 32-bits for PAE
> > * file: arch/x86/mm/gup.c:370 shifting unsigned long '( unsigned long ) nr_pages' by PAGE_SHIFT is truncated to 32-bits for PAE
> > * file: arch/x86/mm/pat.c:751 shifting unsigned long 'pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
> > * file: arch/x86/mm/pageattr-test.c:57 shifting long 'i' by PAGE_SHIFT is truncated to 32-bits for PAE
> > * file: arch/x86/mm/pageattr.c:947 shifting unsigned 'num_pages' by PAGE_SHIFT is truncated to 32-bits
> > * file: arch/x86/mm/pageattr.c:1995 shifting unsigned 'numpages' by PAGE_SHIFT is truncated to 32-bits
> > * file: arch/x86/mm/pageattr-test.c:138 shifting unsigned long 'pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
> > * file: arch/x86/mm/pageattr.c:1117 shifting unsigned long 'cpa -> numpages' by PAGE_SHIFT is truncated to 32-bits for PAE
> > * file: arch/x86/mm/pageattr.c:1017 shifting unsigned long 'cpa -> numpages' by PAGE_SHIFT is truncated to 32-bits for PAE
> > * file: arch/x86/mm/pageattr.c:1277 shifting unsigned long 'cpa -> pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
> > * file: arch/x86/mm/pageattr.c:1318 shifting unsigned long 'cpa -> pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
> > * file: arch/x86/mm/pageattr.c:986 shifting unsigned long 'cpa -> pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
> > * file: arch/x86/mm/pageattr.c:1059 shifting unsigned long 'cpa -> pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
> > * file: arch/x86/mm/init.c:197 shifting unsigned long 'end_pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
> > * file: arch/x86/mm/init.c:100 shifting unsigned long 'min_pfn_mapped' by PAGE_SHIFT is truncated to 32-bits for PAE
> > * file: arch/x86/mm/init.c:641 shifting unsigned long 'pagenr' by PAGE_SHIFT is truncated to 32-bits for PAE
> > * file: arch/x86/mm/init.c:111 shifting unsigned long 'pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
> > * file: arch/x86/mm/init.c:121 shifting unsigned long 'pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
> > * file: arch/x86/mm/init.c:111 shifting unsigned long __initdata 'pgt_buf_end' by PAGE_SHIFT is truncated to 32-bits
> > * file: arch/x86/mm/init.c:196 shifting unsigned long 'start_pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
> > * file: arch/x86/mm/init.c:91 shifting unsigned long '( unsigned long ) num' by PAGE_SHIFT is truncated to 32-bits for PAE
> > * file: arch/x86/mm/init.c:117 shifting unsigned long '( pfn + i )' by PAGE_SHIFT is truncated to 32-bits for PAE
> > * file: arch/x86/mm/init_32.c:293 shifting unsigned long 'pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
> > * file: arch/x86/mm/init_32.c:301 shifting unsigned long 'pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
> > * file: arch/x86/mm/init_32.c:344 shifting unsigned long 'pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
> > * file: arch/x86/mm/init_32.c:361 shifting unsigned long 'pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
> > * file: arch/x86/mm/init_32.c:471 shifting unsigned long 'pfn' by PAGE_SHIFT is truncated to 32-bits for PAE
> > 
> > The coccinelle script isn't perfect, and there are a number of false
> > positives. For example, the first hit is bogus and looks like a
> > coccinelle bug, but the results do show some things that need to be
> > investigated.
> 
> So I checked a few random examples in your list, and the false positive rate looks 
> rather low.
> 
> The current Kbuild integration of Cocci scripts is pretty user-hostile. I'd love 
> to make this Cocci check part of the regular build process in some fashion (if a 
> Kconfig option is enabled), similarly to how we run objtool for example. We could 
> emit the Cocci warnings as a regular compiler 'warning: ' message, so people will 
> notice them as part of the build?

For this type of cocci script where architecture knowledge of bug
idioms is required (you need to know shifting by "PAGE_SHIFT" is
usually done to build an address or size of some kind) I think the
first step would be to automatically lookup scripts to be run on a
per-directory basis.

For example, running make(1) in arch/x86/kernel should map to
scripts/coccinelle/arch/x86/kernel, etc.
 
And yes, I agree, turning this on via a CONFIG_* symbol would be nice.

> The false positive(s) could either be worked around or annotated away.
> 
> Obviously we'd only use Cocci scripts that are known to be reliable.

Fengguang, do you run coccinelle scripts currently as part of the
0-day lkp build machinery?
