From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 11/13] arm64/efi: use plain memblock API for adding
 and removing reserved RAM
Date: Thu, 20 Nov 2014 12:54:29 -0500
Message-ID: <1416506069.6398.64.camel@deneb.redhat.com>
References: <1416315432-8534-1-git-send-email-ard.biesheuvel@linaro.org>
	 <1416315432-8534-12-git-send-email-ard.biesheuvel@linaro.org>
	 <1416504536.6398.58.camel@deneb.redhat.com>
	 <CAKv+Gu9XQWrQyPi+8=vhXWkJXtnJ+8=evNC-Z_MkWR8Wuk6Awg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu9XQWrQyPi+8=vhXWkJXtnJ+8=evNC-Z_MkWR8Wuk6Awg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Geoff Levand <geoff.levand-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 2014-11-20 at 18:38 +0100, Ard Biesheuvel wrote:
> On 20 November 2014 18:28, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > On Tue, 2014-11-18 at 13:57 +0100, Ard Biesheuvel wrote:
> >> diff --git a/drivers/firmware/efi/virtmap.c
> >> b/drivers/firmware/efi/virtmap.c
> >> index 98735fb43581..4b6a5c31629f 100644
> >> --- a/drivers/firmware/efi/virtmap.c
> >> +++ b/drivers/firmware/efi/virtmap.c
> >> @@ -8,6 +8,7 @@
> >>   */
> >>
> >>  #include <linux/efi.h>
> >> +#include <linux/memblock.h>
> >>  #include <linux/mm_types.h>
> >>  #include <linux/rbtree.h>
> >>  #include <linux/rwsem.h>
> >> @@ -97,8 +98,15 @@ void __init efi_virtmap_init(void)
> >>                 u64 paddr, npages, size;
> >>                 pgprot_t prot;
> >>
> >> -               if (!efi_mem_is_usable_region(md))
> >> +               paddr = md->phys_addr;
> >> +               npages = md->num_pages;
> >> +               memrange_efi_to_native(&paddr, &npages);
> >> +               size = npages << PAGE_SHIFT;
> >> +
> >> +               if (!efi_mem_is_usable_region(md)) {
> >>                         efi_register_mem_resource(md);
> >> +                       memblock_remove(paddr, size);
> >> +               }
> >
> > What exactly is the memblock_remove trying to accomplish? With it, I
> > get:
> >
> 
> The idea was pfn_valid() will then return false for those pfns,
> allowing us to distinguish them from memory that the kernel may be
> using, primarily for /dev/mem filtering. But apparently it is causing
> problems for you, so I will have to figure out if there is a better
> way of addressing this.
> 
Okay. Well I think that works for pfn_valid, but it is confusing the
mem_cgroup code. I think because you end up with multiple memory regions
after creating the holes. Earlier memory management code saw one memory
region. And because this comes after paging_init(), all of the memory
ends up in the kernel linear mapping which is something we were trying
to avoid.

> 
> >  Unable to handle kernel NULL pointer dereference at virtual address 00000008
> >  pgd = fffffe03d5890000
> >  [00000008] *pgd=00000043d5ae0003, *pud=00000043d5ae0003, *pmd=00000043d5ae0003, *pte=0000000000000000
> >  Internal error: Oops: 96000007 [#1] SMP
> >  Modules linked in:
> >  CPU: 0 PID: 107 Comm: modprobe Not tainted 3.18.0-rc5+ #8
> >  Hardware name: APM X-Gene Mustang board (DT)
> >  task: fffffe03d5770000 ti: fffffe03dd300000 task.ti: fffffe03dd300000
> >  PC is at mem_cgroup_begin_page_stat+0x40/0x110
> >  LR is at mem_cgroup_begin_page_stat+0x40/0x110
> >  pc : [<fffffe00001ec34c>] lr : [<fffffe00001ec34c>] pstate: 60000145
> >  sp : fffffe03dd303a80
> >  x29: fffffe03dd303a80 x28: 000000000000ffe0
> >  x27: fffffdfef0f56bc0 x26: 0000000000000000
> >  x25: 000003ff89b80000 x24: 0000000000000000
> >  x23: fffffe03dd303ae8 x22: fffffe03dd303ae7
> >  x21: 0000000000000000 x20: fffffe03d58a0420
> >  x19: fffffdfef0004500 x18: 0000000000000000
> >  x17: 000003ff89ba40dc x16: 000003ff89bbff90
> >  x15: 000003ff89ba3b44 x14: 31313030343d6e66
> >  x13: 7020303035343030 x12: 0000000000000006
> >  x11: 0000000000000000 x10: 0000000000000186
> >  x9 : 0000000000000187 x8 : 3030306665666466
> >  x7 : fffffe0001041c18 x6 : 00000000000000ff
> >  x5 : fffffe00004aaf20 x4 : fffffe00004b209c
> >  x3 : 0000000000000000 x2 : 0000000000000000
> >  x1 : fffffe0000f6a5d0 x0 : 0000000000000000
> >
> >  Process modprobe (pid: 107, stack limit = 0xfffffe03dd300058)
> >  Stack: (0xfffffe03dd303a80 to 0xfffffe03dd304000)
> >  3a80: dd303ac0 fffffe03 001c3e20 fffffe00 f0004500 fffffdfe d58a0420 fffffe03
> >  3aa0: f0004500 fffffdfe d58f4dc0 fffffe03 00000000 00000000 001b62d4 fffffe00
> >  3ac0: dd303af0 fffffe03 001b9984 fffffe00 01140f53 00200040 d58a0420 fffffe03
> >  3ae0: d5880000 fffffe03 d58a0420 fffffe03 dd303b40 fffffe03 001b9c4c fffffe00
> >  3b00: d58a0420 fffffe03 89b80000 000003ff f0f56bf0 fffffdfe 00000000 00000000
> >  ...
> >  3fa0: 89b907b7 000003ff 89bbf000 000003ff 89bc16e8 000003ff eb753490 000003ff
> >  3fc0: 89b91f9c 000003ff eb753490 000003ff 89b91fac 000003ff 20000000 00000000
> >  3fe0: 00000000 00000000 ffffffff ffffffff aaaaaaaa aaaaaaaa aaaaaaaa aaaaaaaa
> >  Call trace:
> >  [<fffffe00001ec34c>] mem_cgroup_begin_page_stat+0x40/0x110
> >  [<fffffe00001c3e1c>] page_add_file_rmap+0x24/0x80
> >  [<fffffe00001b9980>] do_set_pte+0x108/0x19c
> >  [<fffffe00001b9c48>] do_read_fault.isra.93+0x234/0x28c
> >  [<fffffe00001ba57c>] handle_mm_fault+0x488/0xd64
> >  [<fffffe00000a0ea0>] do_page_fault+0x224/0x358
> >  [<fffffe0000090128>] do_mem_abort+0x4c/0xb0
> >  Exception stack(0xfffffe03dd303e30 to 0xfffffe03dd303f50)
> >  3e20:                                     00000000 00000000 89bbf000 000003ff
> >  3e40: ffffffff ffffffff 89b91fac 000003ff 01043280 fffffe00 00000002 00000000
> >  3e60: dd303e70 fffffe03 008ce3a0 fffffe00 dd303e90 fffffe03 001c0400 fffffe00
> >  3e80: d5880000 fffffe03 000cbc60 fffffe00 eb753610 000003ff 00092fdc fffffe00
> >  3ea0: 00000000 00000000 89bbf000 000003ff ffffffff ffffffff 89ba4654 000003ff
> >  3ec0: 80000000 00000000 d5521480 fffffe03 89bc16e8 000003ff 89bc1a40 000003ff
> >  3ee0: 00000004 00000000 89b80000 000003ff fefefeff fefefefe 00000000 00000000
> >  3f00: 0000000f 00000000 89bc1028 000003ff 89ba7000 000003ff 0000079c 00000000
> >  3f20: 00400000 00000000 ffff0000 ffffffff 004038a0 00000000 00010000 00000000
> >  3f40: 89ba3c1c 000003ff 89ba3b44 000003ff
> >  Code: b9405835 35000275 aa1303e0 9400065c (f9400413)
> >
> >
