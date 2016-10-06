From: Robert Richter <robert.richter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] arm64: mm: Fix memmap to be initialized for the entire
 section
Date: Thu, 6 Oct 2016 18:11:14 +0200
Message-ID: <20161006161114.GH22012@rric.localdomain>
References: <1475747527-32387-1-git-send-email-rrichter@cavium.com>
 <CAKv+Gu-oYzSn_eeqaX3QVFeQjBGkaX-Wh7+oPcQFcXv7J6GOFQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-oYzSn_eeqaX3QVFeQjBGkaX-Wh7+oPcQFcXv7J6GOFQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Ard,

thank you for your answer and you explanation.

On 06.10.16 11:00:33, Ard Biesheuvel wrote:
> On 6 October 2016 at 10:52, Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org> wrote:
> > There is a memory setup problem on ThunderX systems with certain
> > memory configurations. The symptom is
> >
> >  kernel BUG at mm/page_alloc.c:1848!
> >
> > This happens for some configs with 64k page size enabled. The bug
> > triggers for page zones with some pages in the zone not assigned to
> > this particular zone. In my case some pages that are marked as nomap
> > were not reassigned to the new zone of node 1, so those are still
> > assigned to node 0.
> >
> > The reason for the mis-configuration is a change in pfn_valid() which
> > reports pages marked nomap as invalid:
> >
> >  68709f45385a arm64: only consider memblocks with NOMAP cleared for linear mapping
> >
> 
> These pages are owned by the firmware, which may map it with
> attributes that conflict with the attributes we use for the linear
> mapping. This means they should not be covered by the linear mapping.
> 
> > This causes pages marked as nomap being no long reassigned to the new
> > zone in memmap_init_zone() by calling __init_single_pfn().
> >
> 
> This sounds like the root cause of your issue. Could we not fix that instead?

Yes, this is proposal b) from my last mail that would work too: I
implemented an arm64 private early_pfn_valid() function that uses
memblock_is_memory() to setup all pages of a zone. Though, I think
this is the wrong way and thus I prefer this patch instead. I see
serveral reasons for this:

Inconsistent use of struct *page, it is initialized but never used
again.

Other archs only do a basic range check in pfn_valid(), the default
implementation just returns if the whole section is valid. As I
understand the code, if the mem range is not aligned to the section,
then there will be pfn's in the section that don't have physical mem
attached. The page is then just initialized, it's not marked reserved
nor the refcount is non-zero. It is then simply not used. This is how
no-map pages should be handled too.

I think pfn_valid() is just a quick check if the pfn's struct *page
can be used. There is a good description for this in include/linux/
mmzone.h. So there can be memory holes that have a valid pfn.

If the no-map memory needs special handling, then additional checks
need to be added to the particular code (as in ioremap.c). It's imo
wrong to (mis-)use pfn_valid for that.

Variant b) involves generic mm code to fix it for arm64, this patch is
an arm64 change only. This makes it harder to get a fix for it.
(Though maybe only a problem of patch logistics.)

> 
> > Fixing this by restoring the old behavior of pfn_valid() to use
> > memblock_is_memory().
> 
> This is incorrect imo. In general, pfn_valid() means ordinary memory
> covered by the linear mapping and the struct page array. Returning
> reserved ranges that the kernel should not even touch only to please
> the NUMA code seems like an inappropriate way to deal with this issue.

As said above, it is not marked as reserved, it is treated like
non-existing memory.

This has been observed for non-numa kernels too and can happen for
each zone that is only partly initialized.

I think the patch addresses your concerns. I can't see there the
kernel uses memory marked as nomap in a wrong way.

Thanks,

-Robert

> 
> > Also changing users of pfn_valid() in arm64 code
> > to use memblock_is_map_memory() where necessary. This only affects
> > code in ioremap.c. The code in mmu.c still can use the new version of
> > pfn_valid().
> >
> > Should be marked stable v4.5..
> >
> > Signed-off-by: Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> > ---
> >  arch/arm64/mm/init.c    | 2 +-
> >  arch/arm64/mm/ioremap.c | 5 +++--
> >  2 files changed, 4 insertions(+), 3 deletions(-)
