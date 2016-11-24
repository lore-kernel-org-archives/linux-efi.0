From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] arm64: mm: Fix memmap to be initialized for the entire section
Date: Thu, 24 Nov 2016 19:42:47 +0000
Message-ID: <CAKv+Gu_C_17RtAiw2U0OOzVik3G7KkwUTo5eiGK-HDo-maQ-bA@mail.gmail.com>
References: <CAKv+Gu-2uGJGovqQL-gbB54u=fQ9L9YUbDdRo6u3oWqF6znn6Q@mail.gmail.com>
 <20161123211538.GH10776@rric.localdomain> <CAKv+Gu8aWpz5vXSWdKHwL5Xk2aWyQBOoR1WHOnVPaWZOwqojBQ@mail.gmail.com>
 <20161124134238.GI10776@rric.localdomain> <CAKv+Gu_Ug3XOD6jy5xziy1pS7WV=TC0RLD4j3DT6nytujQDzRQ@mail.gmail.com>
 <20161124135151.GJ10776@rric.localdomain> <CAKv+Gu9qB7P2epMGdwFJ3vJR3vt-bBxU0nKwmKdpaOpTKdqzzA@mail.gmail.com>
 <20161124141149.GE2213@rric.localdomain> <CAKv+Gu-SXX_Vv1Wi1Nm=5vdaXSS0MBp20QBpQVacSKPLfdH0-A@mail.gmail.com>
 <20161124150918.GF2213@rric.localdomain> <20161124192659.GH2213@rric.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161124192659.GH2213@rric.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Robert Richter <robert.richter@cavium.com>
Cc: Will Deacon <will.deacon@arm.com>, Robert Richter <rric@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, David Daney <david.daney@cavium.com>, Hanjun Guo <hanjun.guo@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 24 November 2016 at 19:26, Robert Richter <robert.richter@cavium.com> wrote:
> Ard,
>
>> > >> On 24 November 2016 at 13:51, Robert Richter <robert.richter@cavium.com> wrote:
>> > >> > On 24.11.16 13:44:31, Ard Biesheuvel wrote:
>
>> > >> Regions containing firmware tables are owned by the firmware, and it
>> > >> is the firmware that tells us which memory attributes we are allowed
>> > >> to use. If those attributes include WB, it is perfectly legal to use a
>> > >> cacheable mapping. That does *not* mean they should be covered by the
>> > >> linear mapping. The linear mapping is read-write-non-exec, for
>> > >> instance, and we may prefer to use a read-only mapping and/or
>> > >> executable mapping.
>> > >
>> > > Ok, I am going to fix try_ram_remap().
>
> I revisited the code and it is working well already since:
>
>  e7cd190385d1 arm64: mark reserved memblock regions explicitly in iomem
>
> Now, try_ram_remap() is only called if the region to be mapped is
> entirely in IORESOURCE_SYSTEM_RAM. This is only true for normal mem
> ranges and not NOMAP mem. region_intersects() then returns
> REGION_INTERSECTS and calls try_ram_remap(). For the NOMAP memory case
> REGION_DISJOINT would be returned and thus arch_memremap_wb() being
> called directly. Before the e7cd190385d1 change try_ram_remap() was
> called also for nomap regions.
>
> So we can leave memremap() as it is and just apply this patch
> unmodified. What do you think?

I agree. The pfn_valid() check in try_ram_remap() is still appropriate
simply because the PageHighmem check requires a valid struct page. But
if we don't enter that code path anymore for NOMAP regions, I think
we're ok.

> Please ack.
>

I still don't fully understand how it is guaranteed that *all* memory
(i.e., all regions for which memblock_is_memory() returns true) is
covered by a struct page, but marked as reserved. Are we relying on
the fact that NOMAP memory is also memblock_reserve()'d?

> I am going to prepare the pfn_is_ram() change in addition to this
> patch, but that should not be required for this fix to work correcly.
>

I don't think you need to bother with page_is_ram() then. The only
place we use it is in devmem_is_allowed(), and there it makes sense to
allow NOMAP regions to be accessed (provided that you think /dev/mem
is a good idea in the first place).
