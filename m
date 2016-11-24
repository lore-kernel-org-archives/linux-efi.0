From: Robert Richter <robert.richter@cavium.com>
Subject: Re: [PATCH] arm64: mm: Fix memmap to be initialized for the entire
 section
Date: Thu, 24 Nov 2016 16:09:18 +0100
Message-ID: <20161124150918.GF2213@rric.localdomain>
References: <20161117151805.GJ2151@rric.localdomain>
 <CAKv+Gu-2uGJGovqQL-gbB54u=fQ9L9YUbDdRo6u3oWqF6znn6Q@mail.gmail.com>
 <20161123211538.GH10776@rric.localdomain>
 <CAKv+Gu8aWpz5vXSWdKHwL5Xk2aWyQBOoR1WHOnVPaWZOwqojBQ@mail.gmail.com>
 <20161124134238.GI10776@rric.localdomain>
 <CAKv+Gu_Ug3XOD6jy5xziy1pS7WV=TC0RLD4j3DT6nytujQDzRQ@mail.gmail.com>
 <20161124135151.GJ10776@rric.localdomain>
 <CAKv+Gu9qB7P2epMGdwFJ3vJR3vt-bBxU0nKwmKdpaOpTKdqzzA@mail.gmail.com>
 <20161124141149.GE2213@rric.localdomain>
 <CAKv+Gu-SXX_Vv1Wi1Nm=5vdaXSS0MBp20QBpQVacSKPLfdH0-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-SXX_Vv1Wi1Nm=5vdaXSS0MBp20QBpQVacSKPLfdH0-A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>, Robert Richter <rric@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, David Daney <david.daney@cavium.com>, Hanjun Guo <hanjun.guo@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 24.11.16 14:23:16, Ard Biesheuvel wrote:
> On 24 November 2016 at 14:11, Robert Richter <robert.richter@cavium.com> wrote:
> > On 24.11.16 13:58:30, Ard Biesheuvel wrote:
> >> On 24 November 2016 at 13:51, Robert Richter <robert.richter@cavium.com> wrote:
> >> > On 24.11.16 13:44:31, Ard Biesheuvel wrote:
> >> >> On 24 November 2016 at 13:42, Robert Richter <robert.richter@cavium.com> wrote:
> >> >> > On 23.11.16 21:25:06, Ard Biesheuvel wrote:
> >> >> >> Why? MEMREMAP_WB is used often, among other things for mapping
> >> >> >> firmware tables, which are marked as NOMAP, so in these cases, the
> >> >> >> linear address is not mapped.
> >> >> >
> >> >> > If fw tables are mapped wb, that is wrong and needs a separate fix.
> >> >> >
> >> >>
> >> >> Why is that wrong?
> >> >
> >> > The whole issue with mapping acpi tables is not marking them cachable,
> >> > what wb does.
> >>
> >> What 'issue'?
> >>
> >> > Otherwise we could just use linear mapping for those mem
> >> > ranges.
> >> >
> >>
> >> Regions containing firmware tables are owned by the firmware, and it
> >> is the firmware that tells us which memory attributes we are allowed
> >> to use. If those attributes include WB, it is perfectly legal to use a
> >> cacheable mapping. That does *not* mean they should be covered by the
> >> linear mapping. The linear mapping is read-write-non-exec, for
> >> instance, and we may prefer to use a read-only mapping and/or
> >> executable mapping.
> >
> > Ok, I am going to fix try_ram_remap().
> >
> 
> Thanks. Could you also add an arm64 version of page_is_ram() that uses
> memblock_is_memory() while you're at it? I think using memblock
> directly in try_ram_remap() may not be the best approach

Sure. I also want to mark the patches as stable.

> > Are there other concerns with this patch?
> >
> 
> I think we all agree that pfn_valid() should return whether a pfn has
> a struct page associated with it, the debate is about whether it makes
> sense to allocate struct pages for memory that the kernel does not
> own. But given that it does not really hurt to do so for small holes,
> I think your suggestion makes sense.

Thanks for your comments and the review.

> Should we be doing anything more to ensure that those pages are not
> dereferenced inadvertently? Is there a page flag we should be setting?

I don't think so. Boot mem is initialized in free_low_memory_core_
early(). The PageReserved flag is set for pages from reserved memory
ranges, and memory ranges not marked NOMAP is just freed. Since pages
are either reservered or in the free_list of pages, pages from other
memory ranges (NOMAP) is not visible to mm.

-Robert
