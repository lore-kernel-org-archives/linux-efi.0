From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2 3/4] x86/efi: print size and base in binary units in
 efi_print_memmap
Date: Fri, 22 Jan 2016 15:11:00 +0000
Message-ID: <20160122151100.GA3747@codeblueprint.co.uk>
References: <1453389752-68175-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1453389752-68175-3-git-send-email-andriy.shevchenko@linux.intel.com>
 <20160121143558.2ae43ccf550e1693cd05834f@linux-foundation.org>
 <CAHp75VcCvpbamGurVVzXBGcYMCexpTZ4esg8YbKmzAu+iibyrw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHp75VcCvpbamGurVVzXBGcYMCexpTZ4esg8YbKmzAu+iibyrw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rasmus Villemoes <linux-qQsb+v5E8BnlAoU/VqSP6n9LOBIZ5rWg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 22 Jan, at 09:08:00AM, Andy Shevchenko wrote:
> On Fri, Jan 22, 2016 at 12:35 AM, Andrew Morton
> <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> > On Thu, 21 Jan 2016 17:22:31 +0200 Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> >
> >> From: Robert Elliott <elliott-ZPxbGqLxI0U@public.gmane.org>
> >>
> >> Print the base in the best-fit B, KiB, MiB, etc. units rather than
> >> always MiB. This avoids rounding, which can be misleading.
> >>
> >> Use proper IEC binary units (KiB, MiB, etc.) rather than misuse SI
> >> decimal units (KB, MB, etc.).
> >>
> >> old:
> >>     efi: mem61: [Persistent Memory  |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff) (16384MB)
> >>
> >> new:
> >>     efi: mem61: [Persistent Memory  |   |  |  |  |  |  |   |WB|WT|WC|UC] range=[0x0000000880000000-0x0000000c7fffffff] (16 GiB)
> >
> > hm,
> >
> >> @@ -225,21 +235,20 @@ int __init efi_memblock_x86_reserve_range(void)
> >>  void __init efi_print_memmap(void)
> >>  {
> >>  #ifdef EFI_DEBUG
> >> -     efi_memory_desc_t *md;
> >>       void *p;
> >>       int i;
> >>
> >>       for (p = memmap.map, i = 0;
> >>            p < memmap.map_end;
> >>            p += memmap.desc_size, i++) {
> >> -             char buf[64];
> >> +             efi_memory_desc_t *md = p;
> >> +             u64 size = md->num_pages << EFI_PAGE_SHIFT;
> >> +             char buf[64], buf3[32];
> >>
> >> -             md = p;
> >> -             pr_info("mem%02u: %s range=[0x%016llx-0x%016llx] (%lluMB)\n",
> >> +             pr_info("mem%02u: %s range=[0x%016llx-0x%016llx] (%s)\n",
> >>                       i, efi_md_typeattr_format(buf, sizeof(buf), md),
> >> -                     md->phys_addr,
> >> -                     md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1,
> >
> > Where did this " - 1" come from?  I can't find a tree which has this.
> 
> http://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/commit/?h=next&id=b324ee15566d9de933e7926c37a4d091904a513b
> 
> >
> >> -                     (md->num_pages >> (20 - EFI_PAGE_SHIFT)));
> >> +                     md->phys_addr, md->phys_addr + size - 1,
> >
> > So I did s/ - 1// here, but worried.
> 
> I'm pretty sure the series should go via efi tree.

Right, because of the prerequisite patches sat in my tree it makes
sense for them to all be grouped together.

Andrew, would you mind dropping these from your tree and I'll take
everything through the EFI tree?

Additionally, if you and Rasmus wanted to throw a couple of Acked-by
or Reviewed-by tags my way, I'd feel better about the string_helpers
patches.
