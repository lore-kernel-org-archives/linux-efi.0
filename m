From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] arm64: mm: Fix memmap to be initialized for the entire section
Date: Fri, 25 Nov 2016 12:28:50 +0000
Message-ID: <CAKv+Gu9h2YWJd8-+FhSYSftUsddj1f-HTA2D-6nC=8Wk6U1iAg@mail.gmail.com>
References: <CAKv+Gu8aWpz5vXSWdKHwL5Xk2aWyQBOoR1WHOnVPaWZOwqojBQ@mail.gmail.com>
 <20161124134238.GI10776@rric.localdomain> <CAKv+Gu_Ug3XOD6jy5xziy1pS7WV=TC0RLD4j3DT6nytujQDzRQ@mail.gmail.com>
 <20161124135151.GJ10776@rric.localdomain> <CAKv+Gu9qB7P2epMGdwFJ3vJR3vt-bBxU0nKwmKdpaOpTKdqzzA@mail.gmail.com>
 <20161124141149.GE2213@rric.localdomain> <CAKv+Gu-SXX_Vv1Wi1Nm=5vdaXSS0MBp20QBpQVacSKPLfdH0-A@mail.gmail.com>
 <20161124150918.GF2213@rric.localdomain> <20161124192659.GH2213@rric.localdomain>
 <CAKv+Gu_C_17RtAiw2U0OOzVik3G7KkwUTo5eiGK-HDo-maQ-bA@mail.gmail.com> <20161125112914.GI2213@rric.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161125112914.GI2213-vWBEXY7mpu582hYKe6nXyg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Richter <robert.richter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Robert Richter <rric-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 25 November 2016 at 11:29, Robert Richter <robert.richter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org> wrote:
> On 24.11.16 19:42:47, Ard Biesheuvel wrote:
>> On 24 November 2016 at 19:26, Robert Richter <robert.richter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org> wrote:
>
>> > I revisited the code and it is working well already since:
>> >
>> >  e7cd190385d1 arm64: mark reserved memblock regions explicitly in iomem
>> >
>> > Now, try_ram_remap() is only called if the region to be mapped is
>> > entirely in IORESOURCE_SYSTEM_RAM. This is only true for normal mem
>> > ranges and not NOMAP mem. region_intersects() then returns
>> > REGION_INTERSECTS and calls try_ram_remap(). For the NOMAP memory case
>> > REGION_DISJOINT would be returned and thus arch_memremap_wb() being
>> > called directly. Before the e7cd190385d1 change try_ram_remap() was
>> > called also for nomap regions.
>> >
>> > So we can leave memremap() as it is and just apply this patch
>> > unmodified. What do you think?
>>
>> I agree. The pfn_valid() check in try_ram_remap() is still appropriate
>> simply because the PageHighmem check requires a valid struct page. But
>> if we don't enter that code path anymore for NOMAP regions, I think
>> we're ok.
>>
>> > Please ack.
>> >
>>
>> I still don't fully understand how it is guaranteed that *all* memory
>> (i.e., all regions for which memblock_is_memory() returns true) is
>> covered by a struct page, but marked as reserved. Are we relying on
>> the fact that NOMAP memory is also memblock_reserve()'d?
>
> See free_low_memory_core_early():
>
> ----
>         for_each_free_mem_range(i, NUMA_NO_NODE, MEMBLOCK_NONE, &start, &end,
>                                 NULL)
>                 count += __free_memory_core(start, end);
> ----
>
> Only mem with the MEMBLOCK_NONE flag is added. And NOMAP pages are
> also *not* marked reserved. So nothing at all from NOMAP mem is
> reported to mm, it is not present (see below for a mem config, note
> flags: 0x4 mem regions).
>

OK, thanks for clearing that up. But that still does not explain how
we can be certain that NOMAP regions are guaranteed to be covered by a
struct page, does it? Because that is ultimately what pfn_valid()
means, that it is safe to, e.g., look at the page flags.


> [    0.000000] efi: Processing EFI memory map:
> [    0.000000] efi:   0x000001400000-0x00000147ffff [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x000001480000-0x0000024bffff [Loader Data        |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x0000024c0000-0x0000211fffff [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x000021200000-0x00002121ffff [Loader Data        |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x000021220000-0x0000fffebfff [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x0000fffec000-0x0000ffff5fff [ACPI Reclaim Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x0000ffff6000-0x0000ffff6fff [ACPI Memory NVS    |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x0000ffff7000-0x0000ffffffff [ACPI Reclaim Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x000100000000-0x000ff7ffffff [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x000ff8000000-0x000ff801ffff [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x000ff8020000-0x000fffa9efff [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x000fffa9f000-0x000fffffffff [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x010000400000-0x010f816aefff [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x010f816af000-0x010f816b1fff [Loader Data        |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x010f816b2000-0x010f826f1fff [Loader Code        |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x010f826f2000-0x010f82701fff [Loader Data        |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x010f82702000-0x010f82787fff [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x010f82788000-0x010f9276bfff [Loader Data        |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x010f9276c000-0x010f9276cfff [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x010f9276d000-0x010f935a8fff [Loader Data        |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x010f935a9000-0x010f93880fff [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x010f93881000-0x010ff7880fff [Loader Data        |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x010ff7881000-0x010ff7886fff [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x010ff7887000-0x010ff78a3fff [Loader Code        |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x010ff78a4000-0x010ff9e8dfff [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x010ff9e8e000-0x010ff9f16fff [Runtime Data       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x010ff9f17000-0x010ffaeb5fff [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x010ffaeb6000-0x010ffafc8fff [Runtime Data       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x010ffafc9000-0x010ffafccfff [Runtime Code       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x010ffafcd000-0x010ffaff4fff [Runtime Data       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x010ffaff5000-0x010ffb008fff [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x010ffb009000-0x010fffe28fff [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x010fffe29000-0x010fffe3ffff [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x010fffe40000-0x010fffe53fff [Loader Data        |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x010fffe54000-0x010ffffb8fff [Boot Code          |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x010ffffb9000-0x010ffffccfff [Runtime Code       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x010ffffcd000-0x010fffffefff [Runtime Data       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x010ffffff000-0x010fffffffff [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
> [    0.000000] efi:   0x804000001000-0x804000001fff [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC]
> [    0.000000] efi:   0x87e0d0001000-0x87e0d0001fff [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC]
>
> [    0.000000] MEMBLOCK configuration:
> [    0.000000]  memory size = 0x1ffe800000 reserved size = 0x39146a21
> [    0.000000]  memory.cnt  = 0x9
> [    0.000000]  memory[0x0]     [0x00000001400000-0x000000fffdffff], 0xfebe0000 bytes on node 0 flags: 0x0
> [    0.000000]  memory[0x1]     [0x000000fffe0000-0x000000ffffffff], 0x20000 bytes on node 0 flags: 0x4
> [    0.000000]  memory[0x2]     [0x00000100000000-0x00000fffffffff], 0xf00000000 bytes on node 0 flags: 0x0
> [    0.000000]  memory[0x3]     [0x00010000400000-0x00010ff9e7ffff], 0xff9a80000 bytes on node 1 flags: 0x0
> [    0.000000]  memory[0x4]     [0x00010ff9e80000-0x00010ff9f1ffff], 0xa0000 bytes on node 1 flags: 0x4
> [    0.000000]  memory[0x5]     [0x00010ff9f20000-0x00010ffaeaffff], 0xf90000 bytes on node 1 flags: 0x0
> [    0.000000]  memory[0x6]     [0x00010ffaeb0000-0x00010ffaffffff], 0x150000 bytes on node 1 flags: 0x4
> [    0.000000]  memory[0x7]     [0x00010ffb000000-0x00010ffffaffff], 0x4fb0000 bytes on node 1 flags: 0x0
> [    0.000000]  memory[0x8]     [0x00010ffffb0000-0x00010fffffffff], 0x50000 bytes on node 1 flags: 0x4
> [    0.000000]  reserved.cnt  = 0xd
> [    0.000000]  reserved[0x0]   [0x00000001480000-0x0000000249ffff], 0x1020000 bytes flags: 0x0
> [    0.000000]  reserved[0x1]   [0x00000021200000-0x00000021210536], 0x10537 bytes flags: 0x0
> [    0.000000]  reserved[0x2]   [0x000000c0000000-0x000000dfffffff], 0x20000000 bytes flags: 0x0
> [    0.000000]  reserved[0x3]   [0x00000ffbfb8000-0x00000ffffdffff], 0x4028000 bytes flags: 0x0
> [    0.000000]  reserved[0x4]   [0x00000ffffecb00-0x00000fffffffff], 0x13500 bytes flags: 0x0
> [    0.000000]  reserved[0x5]   [0x00010f81780000-0x00010f8178ffff], 0x10000 bytes flags: 0x0
> [    0.000000]  reserved[0x6]   [0x00010f82870000-0x00010f9286ffff], 0x10000000 bytes flags: 0x0
> [    0.000000]  reserved[0x7]   [0x00010ffbce0000-0x00010fffceffff], 0x4010000 bytes flags: 0x0
> [    0.000000]  reserved[0x8]   [0x00010fffee6d80-0x00010ffff2fffb], 0x4927c bytes flags: 0x0
> [    0.000000]  reserved[0x9]   [0x00010ffff30000-0x00010ffffa000f], 0x70010 bytes flags: 0x0
> [    0.000000]  reserved[0xa]   [0x00010ffffae280-0x00010ffffaff7f], 0x1d00 bytes flags: 0x0
> [    0.000000]  reserved[0xb]   [0x00010ffffaffa0-0x00010ffffaffce], 0x2f bytes flags: 0x0
> [    0.000000]  reserved[0xc]   [0x00010ffffaffd0-0x00010ffffafffe], 0x2f bytes flags: 0x0
