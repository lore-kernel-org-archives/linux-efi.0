From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/5] x86/mm/pageattr: Ensure cpa->pfn only contains
 page frame numbers
Date: Wed, 18 Nov 2015 09:14:23 +0100
Message-ID: <20151118081423.GA23844@gmail.com>
References: <1447538451-5793-1-git-send-email-matt@codeblueprint.co.uk>
 <1447538451-5793-2-git-send-email-matt@codeblueprint.co.uk>
 <alpine.DEB.2.11.1511162010120.3761@nanos>
 <20151117094509.GB2727@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151117094509.GB2727-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Toshi Kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sai Praneeth Prakhya <sai.praneeth.prakhya-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:

> > > +	npages = (_end - _text) >> PAGE_SHIFT;
> > 
> > You really need to PFN_ALIGN _end and _text. Has been wrong in the
> > existing code as well.
>  
> Hmm... very good point.

So I think we should instead guarantee that _end and _text are page aligned.

_text is already page aligned:

SECTIONS
{
#ifdef CONFIG_X86_32
        . = LOAD_OFFSET + LOAD_PHYSICAL_ADDR;
        phys_startup_32 = startup_32 - LOAD_OFFSET;
#else
        . = __START_KERNEL;
        phys_startup_64 = startup_64 - LOAD_OFFSET;
#endif

        /* Text and read-only data */
        .text :  AT(ADDR(.text) - LOAD_OFFSET) {
                _text = .;

The reason for aligning _end as well is that we already page-align the BSS and BRK 
sections of the kernel and its various section boundary symbols:

        /* BSS */
        . = ALIGN(PAGE_SIZE);
        .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
                __bss_start = .;
                *(.bss..page_aligned)
                *(.bss)
                . = ALIGN(PAGE_SIZE);
                __bss_stop = .;
        }

        . = ALIGN(PAGE_SIZE);
        .brk : AT(ADDR(.brk) - LOAD_OFFSET) {
                __brk_base = .;
                . += 64 * 1024;         /* 64k alignment slop space */
                *(.brk_reservation)     /* areas brk users have reserved */
                __brk_limit = .;
        }

        _end = .;

        STABS_DEBUG
        DWARF_DEBUG

_end is the only odd one out, so we should align it as well - because it's easy to 
make such pfn conversion bugs.

This will also make it easier to mark STABS_DEBUG and DWARF_DEBUG as read-only, 
which they should fundamentally be I think. Alternatively they could be moved to 
the read-only section - at which point _end becomes page aligned 'for free'.

Thanks,

	Ingo
