From: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Subject: Re: [BUG] x86/efi: MMRs no longer properly mapped after switch to
 isolated page table
Date: Wed, 27 Apr 2016 20:41:28 -0500
Message-ID: <20160428014128.GF113599@stormcage.americas.sgi.com>
References: <20160427154132.GB113599@stormcage.americas.sgi.com>
 <20160427225122.GG21282@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160427225122.GG21282-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
Cc: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Russ Anderson <rja-sJ/iWh9BUns@public.gmane.org>, Dimitri Sivanich <sivanich-sJ/iWh9BUns@public.gmane.org>, mike travis <travis-sJ/iWh9BUns@public.gmane.org>, Nathan Zimmer <nzimmer-sJ/iWh9BUns@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, Apr 28, 2016 at 12:51:22AM +0200, Borislav Petkov wrote:
> On Wed, Apr 27, 2016 at 10:41:32AM -0500, Alex Thorlton wrote:
> > A bit of digging will tell us that this is the failing line:
> > 
> > m_n_config.v = uv_read_local_mmr(UVH_RH_GAM_CONFIG_MMR );
> 
> That looks like
> 
> All code
> ========
>    0:   65 48 03 05 1d b8 49    add    %gs:0x7e49b81d(%rip),%rax        # 0x7e49b825
>    7:   7e 
>    8:   80 78 14 02             cmpb   $0x2,0x14(%rax)
>    c:   ba 00 00 00 fa          mov    $0xfa000000,%edx
>   11:   76 0b                   jbe    0x1e
>   13:   48 89 c8                mov    %rcx,%rax
>   16:   65 48 03 05 07 b8 49    add    %gs:0x7e49b807(%rip),%rax        # 0x7e49b825
>   1d:   7e 
>   1e:   48 b8 00 00 60 01 00    movabs $0xffff880001600000,%rax
>   25:   88 ff ff 
>   28:   48 09 d0                or     %rdx,%rax
>   2b:*  48 8b 00                mov    (%rax),%rax              <-- trapping instruction
>   2e:   88 c3                   mov    %al,%bl
>   30:   48 c1 e8 06             shr    $0x6,%rax
>   34:   41 bd 01 00 00 00       mov    $0x1,%r13d
>   3a:   88 c1                   mov    %al,%cl
>   3c:   83 e3 3f                and    $0x3f,%ebx
> 
> but why does this have anything to do with the EFI pagetable, at all?

In this particular instance, it's not using the EFI page table - it's
showing that the register isn't mapped into the main kernel page table,
via the bad paging request.  The issue isn't that there's something
wrong with the EFI page table, but that something appears to be missing
from the kernel table.

> The MMRs should be mapped in the normal kernel page table, right?

Well, quite a while back, these MMRs got mapped in using
init_extra_mapping_uc in map_low_mmrs.  Back then, yes, they were mapped
straight into the kernel page table.

After d2f7cbe7b26a74 ("x86/efi: Runtime services virtual mapping") was
introduced (I'm sure you remember the BIOS issue we had a while back) we
had to fall back to using EFI_OLD_MEMMAP, so for a while we relied on
efi_ioremap.

Eventually we got a BIOS fix that allowed us to start using the new
memmap scheme, at which point we removed the init_extra_mapping_uc()s,
since the efi_map_region code appeared to be doing what we needed.

So, short answer is, they were mapped in and working up until now.

> And your dirty fix of mapping into trampoline_pgd doesn't make any
> sense...

I *think* it does?  This one took me a while to figure out - I wrote the
fix at midnight last night, so please inform me if my logic sounds
insane, haha.

In efi_map_region we first do the __map_region for the physical address,
which will get mapped into the lowest PGD entry of the trampoline_pgd.
I believe the lowest PGD entry in the trampoline_pgd is actually the
same as init_mm.pgd + pgd_index(PAGE_OFFSET) (see setup_real_mode), so
you're effectively mapping into the kernel 1:1 space when you map into
pgd_index 0 of the trampoline_pgd.

By adding the mappings to the trampoline_pgd back in, I think I've also
added them back into the kernel.

> How do the MMRs get mapped on that box exactly?

Believe I covered this above.  Let me know if you have questions!

> And why aren't they
> mapped in the normal kernel page table all of a sudden?

It looks to me like there might be a bit of a complicated chain of
events that led us to this point.  I thought I was close to having this
worked out, but after looking back over it I'm starting to think, "how
was it working in the first place?!"

At this point, considering the fact that my fix definitely gets the UV
to boot, I'm going to stick to my claim that adding the maps back into
the trampoline_pgd fixes at least part of the issue - not saying it's
the right way, but it's an intersting data point.

Despite the fact that my fix might help remedy the situation, I will
admit that my understanding of the mechanics behind said fix could be
flawed :)

I'm going to have to think about this some more tomorrow.  Let me know
if you have any ideas!

- Alex
