From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2 1/5] x86/mm/pageattr: Ensure cpa->pfn only contains
 page frame numbers
Date: Fri, 20 Nov 2015 12:01:29 +0000
Message-ID: <20151120120129.GA2608@codeblueprint.co.uk>
References: <1447538451-5793-1-git-send-email-matt@codeblueprint.co.uk>
 <1447538451-5793-2-git-send-email-matt@codeblueprint.co.uk>
 <alpine.DEB.2.11.1511162010120.3761@nanos>
 <20151117094509.GB2727@codeblueprint.co.uk>
 <20151118081423.GA23844@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151118081423.GA23844-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 18 Nov, at 09:14:23AM, Ingo Molnar wrote:
> 
> * Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> 
> > > > +	npages = (_end - _text) >> PAGE_SHIFT;
> > > 
> > > You really need to PFN_ALIGN _end and _text. Has been wrong in the
> > > existing code as well.
> >  
> > Hmm... very good point.
> 
> So I think we should instead guarantee that _end and _text are page aligned.
> 
> _text is already page aligned:
> 
> SECTIONS
> {
> #ifdef CONFIG_X86_32
>         . = LOAD_OFFSET + LOAD_PHYSICAL_ADDR;
>         phys_startup_32 = startup_32 - LOAD_OFFSET;
> #else
>         . = __START_KERNEL;
>         phys_startup_64 = startup_64 - LOAD_OFFSET;
> #endif
> 
>         /* Text and read-only data */
>         .text :  AT(ADDR(.text) - LOAD_OFFSET) {
>                 _text = .;
> 
> The reason for aligning _end as well is that we already page-align the BSS and BRK 
> sections of the kernel and its various section boundary symbols:
> 
>         /* BSS */
>         . = ALIGN(PAGE_SIZE);
>         .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
>                 __bss_start = .;
>                 *(.bss..page_aligned)
>                 *(.bss)
>                 . = ALIGN(PAGE_SIZE);
>                 __bss_stop = .;
>         }
> 
>         . = ALIGN(PAGE_SIZE);
>         .brk : AT(ADDR(.brk) - LOAD_OFFSET) {
>                 __brk_base = .;
>                 . += 64 * 1024;         /* 64k alignment slop space */
>                 *(.brk_reservation)     /* areas brk users have reserved */
>                 __brk_limit = .;
>         }
> 
>         _end = .;
> 
>         STABS_DEBUG
>         DWARF_DEBUG
> 
> _end is the only odd one out, so we should align it as well - because it's easy to 
> make such pfn conversion bugs.

FWIW, I saw no changes in either 32-bit or 64-bit vmlinux size when
building with the following patch, so it seems like a pretty easy win,

---

>From 25ad518fa52e589f110376ae06e42fb20b3e4188 Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Date: Fri, 20 Nov 2015 11:46:11 +0000
Subject: [PATCH] x86: Page align _end to avoid pfn conversion bugs

Ingo noted that if we can guarantee _end is aligned to PAGE_SIZE we
can automatically avoid bugs along the lines of,

	size = _end - _text >> PAGE_SHIFT

which is missing a call to PFN_ALIGN(). The EFI mixed mode contains
this bug, for example.

_text is already aligned to PAGE_SIZE through the use of
LOAD_PHYSICAL_ADDR, and the BSS and BRK sections are explicitly
aligned in the linker script, so it makes sense to align _end to
match.

Reported-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Signed-off-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
---
 arch/x86/kernel/vmlinux.lds.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 74e4bf11f562..4f1994257a18 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -325,6 +325,7 @@ SECTIONS
 		__brk_limit = .;
 	}
 
+	. = ALIGN(PAGE_SIZE);
 	_end = .;
 
         STABS_DEBUG
-- 
2.6.2
