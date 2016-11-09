From: Robert Richter <robert.richter@cavium.com>
Subject: Re: [PATCH] arm64: mm: Fix memmap to be initialized for the entire
 section
Date: Wed, 9 Nov 2016 20:51:32 +0100
Message-ID: <20161109195132.GZ22012@rric.localdomain>
References: <1475747527-32387-1-git-send-email-rrichter@cavium.com>
 <CAKv+Gu-oYzSn_eeqaX3QVFeQjBGkaX-Wh7+oPcQFcXv7J6GOFQ@mail.gmail.com>
 <20161006161114.GH22012@rric.localdomain>
 <20161017185801.GT25086@rric.localdomain>
 <20161027160136.GD24290@arm.com>
 <20161028091905.GM22012@rric.localdomain>
 <20161107210514.GP20591@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20161107210514.GP20591@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Robert Richter <rric@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, David Daney <david.daney@cavium.com>, Hanjun Guo <hanjun.guo@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

Will,

On 07.11.16 21:05:14, Will Deacon wrote:
> Just to reiterate here, but your patch as it stands will break other parts
> of the kernel. For example, acpi_os_ioremap relies on being able to ioremap
> these regions afaict.
> 
> I think any solution involving pfn_valid is just going to move the crash
> around.

Let me describe the crash more detailed.

Following range is marked nomap (full efi map below):

[    0.000000] efi:   0x010ffffb9000-0x010ffffccfff [Runtime Code       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC]*
[    0.000000] efi:   0x010ffffcd000-0x010fffffefff [Runtime Data       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC]*

The mem belongs to this nodes:

[    0.000000] NUMA: Adding memblock [0x1400000 - 0xfffffffff] on node 0
[    0.000000] NUMA: Adding memblock [0x10000400000 - 0x10fffffffff] on node 1

The following mem ranges are created:

[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000001400000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x0000010fffffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000001400000-0x00000000fffdffff]
[    0.000000]   node   0: [mem 0x00000000fffe0000-0x00000000ffffffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x0000000fffffffff]
[    0.000000]   node   1: [mem 0x0000010000400000-0x0000010ff9e7ffff]
[    0.000000]   node   1: [mem 0x0000010ff9e80000-0x0000010ff9f1ffff]
[    0.000000]   node   1: [mem 0x0000010ff9f20000-0x0000010ffaeaffff]
[    0.000000]   node   1: [mem 0x0000010ffaeb0000-0x0000010ffaffffff]
[    0.000000]   node   1: [mem 0x0000010ffb000000-0x0000010ffffaffff]
[    0.000000]   node   1: [mem 0x0000010ffffb0000-0x0000010fffffffff]

The last range 0x0000010ffffb0000-0x0000010fffffffff is correctly
marked as a nomap area.

Paging is then initalized in free_area_init_core() (mm/page_alloc.c)
which calls memmap_init_zone(). This initializes all pages (struct
page) of the zones for each node except for pfns from nomap memory. It
uses early_pfn_valid() which is bound to pfn_valid().

In 4.4 *all* pages of a zone were initialized. Now page from nomap
ranges are skipped, and e.g. pfn 0x10ffffb has an uninitalized struct
page.  Note that nomap mem ranges are still part of the memblock list
and also part of the zone ranges within start_pfn and end_pfn, but
those don't have a valid struct page now. IMO this is a bug.

Later on all mappable memory is reserved and all pages of it are freed
by adding them to the free-pages list except for the reserved
memblocks.

Now the initrd is loaded. This reserves free memory by calling
move_freepages_block(). A block has the size of pageblock_nr_pages
which is in my configuration 0x2000. The kernel choses the block

 0x0000010fe0000000-0x0000010fffffffff

that also contains the nomap region around 10ffb000000.

In move_freepages() the pages of the zone are freed. The code accesses
pfn #10fffff but the struct page is uninitialized and thus node is 0.
This is different to #10fe000 and the zone which is node 1. This
causes the BUG_ON() to trigger:

[    4.173521] Unpacking initramfs...
[    8.420710] ------------[ cut here ]------------
[    8.425344] kernel BUG at mm/page_alloc.c:1844!
[    8.429870] Internal error: Oops - BUG: 0 [#1] SMP

I believe this is not the only case where the mm code relies on a
valid struct page for all pfns of a zone, thus modifying mm code to
make this case work is not an option. (E.g. this could be done by
moving the early_pfn_valid() check at the beginning of the loop in
memmap_init_zone().)

So for a fix we need to change early_pfn_valid() which is mapped to
pfn_valid() for SPARSEMEM. Using a different function than pfn_valid()
for this does not look reasonable. The only option is to revert
pfn_valid() to it's original bahaviour.

My fix now uses again memblock_is_memory() for pfn_valid() instead of
memblock_is_map_memory(). So I needed to change some users of
pfn_valid() to use memblock_is_map_memory() there necessary. This is
only required for arch specific code, all other uses of pfn_valid()
are save to use memblock_is_memory().

Thus, I don't see where my patch breaks code. Even acpi_os_ioremap()
keeps the same behaviour as before since it still uses memblock_is_
memory(). Could you more describe your concerns why do you think this
patch breaks the kernel and moves the problem somewhere else? I
believe it fixes the problem at all.

Thanks,

-Robert



[    0.000000] efi: Processing EFI memory map:
[    0.000000] MEMBLOCK configuration:
[    0.000000]  memory size = 0x1ffe800000 reserved size = 0x10537
[    0.000000]  memory.cnt  = 0x2
[    0.000000]  memory[0x0]     [0x00000001400000-0x00000fffffffff], 0xffec00000 bytes flags: 0x0
[    0.000000]  memory[0x1]     [0x00010000400000-0x00010fffffffff], 0xfffc00000 bytes flags: 0x0
[    0.000000]  reserved.cnt  = 0x1
[    0.000000]  reserved[0x0]   [0x00000021200000-0x00000021210536], 0x10537 bytes flags: 0x0
[    0.000000] efi:   0x000001400000-0x00000147ffff [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] memblock_add: [0x00000001400000-0x0000000147ffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x000001480000-0x0000024affff [Loader Data        |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] memblock_add: [0x00000001480000-0x000000024affff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x0000024b0000-0x0000211fffff [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] memblock_add: [0x000000024b0000-0x000000211fffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x000021200000-0x00002121ffff [Loader Data        |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] memblock_add: [0x00000021200000-0x0000002121ffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x000021220000-0x0000fffebfff [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] memblock_add: [0x00000021220000-0x000000fffeffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x0000fffec000-0x0000ffff5fff [ACPI Reclaim Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]*
[    0.000000] memblock_add: [0x000000fffe0000-0x000000ffffffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x0000ffff6000-0x0000ffff6fff [ACPI Memory NVS    |   |  |  |  |  |  |  |   |WB|WT|WC|UC]*
[    0.000000] memblock_add: [0x000000ffff0000-0x000000ffffffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x0000ffff7000-0x0000ffffffff [ACPI Reclaim Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]*
[    0.000000] memblock_add: [0x000000ffff0000-0x000000ffffffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x000100000000-0x000ff7ffffff [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] memblock_add: [0x00000100000000-0x00000ff7ffffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x000ff8000000-0x000ff801ffff [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] memblock_add: [0x00000ff8000000-0x00000ff801ffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x000ff8020000-0x000fffa9efff [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] memblock_add: [0x00000ff8020000-0x00000fffa9ffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x000fffa9f000-0x000fffffffff [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] memblock_add: [0x00000fffa90000-0x00000fffffffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x010000400000-0x010f812b3fff [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] memblock_add: [0x00010000400000-0x00010f812bffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x010f812b4000-0x010f812b6fff [Loader Data        |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] memblock_add: [0x00010f812b0000-0x00010f812bffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x010f812b7000-0x010f822e6fff [Loader Code        |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] memblock_add: [0x00010f812b0000-0x00010f822effff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x010f822e7000-0x010f822f6fff [Loader Data        |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] memblock_add: [0x00010f822e0000-0x00010f822fffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x010f822f7000-0x010f82342fff [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] memblock_add: [0x00010f822f0000-0x00010f8234ffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x010f82343000-0x010f91e73fff [Loader Data        |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] memblock_add: [0x00010f82340000-0x00010f91e7ffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x010f91e74000-0x010f91e74fff [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] memblock_add: [0x00010f91e70000-0x00010f91e7ffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x010f91e75000-0x010f92c98fff [Loader Data        |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] memblock_add: [0x00010f91e70000-0x00010f92c9ffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x010f92c99000-0x010f93880fff [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] memblock_add: [0x00010f92c90000-0x00010f9388ffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x010f93881000-0x010ff7880fff [Loader Data        |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] memblock_add: [0x00010f93880000-0x00010ff788ffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x010ff7881000-0x010ff7886fff [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] memblock_add: [0x00010ff7880000-0x00010ff788ffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x010ff7887000-0x010ff78a3fff [Loader Code        |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] memblock_add: [0x00010ff7880000-0x00010ff78affff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x010ff78a4000-0x010ff9e8dfff [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] memblock_add: [0x00010ff78a0000-0x00010ff9e8ffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x010ff9e8e000-0x010ff9f16fff [Runtime Data       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC]*
[    0.000000] memblock_add: [0x00010ff9e80000-0x00010ff9f1ffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x010ff9f17000-0x010ffaeb5fff [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] memblock_add: [0x00010ff9f10000-0x00010ffaebffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x010ffaeb6000-0x010ffafc8fff [Runtime Data       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC]*
[    0.000000] memblock_add: [0x00010ffaeb0000-0x00010ffafcffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x010ffafc9000-0x010ffafccfff [Runtime Code       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC]*
[    0.000000] memblock_add: [0x00010ffafc0000-0x00010ffafcffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x010ffafcd000-0x010ffaff4fff [Runtime Data       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC]*
[    0.000000] memblock_add: [0x00010ffafc0000-0x00010ffaffffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x010ffaff5000-0x010ffb008fff [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] memblock_add: [0x00010ffaff0000-0x00010ffb00ffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x010ffb009000-0x010fffe28fff [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] memblock_add: [0x00010ffb000000-0x00010fffe2ffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x010fffe29000-0x010fffe3ffff [Conventional Memory|   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] memblock_add: [0x00010fffe20000-0x00010fffe3ffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x010fffe40000-0x010fffe53fff [Loader Data        |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] memblock_add: [0x00010fffe40000-0x00010fffe5ffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x010fffe54000-0x010ffffb8fff [Boot Code          |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] memblock_add: [0x00010fffe50000-0x00010ffffbffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x010ffffb9000-0x010ffffccfff [Runtime Code       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC]*
[    0.000000] memblock_add: [0x00010ffffb0000-0x00010ffffcffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x010ffffcd000-0x010fffffefff [Runtime Data       |RUN|  |  |  |  |  |  |   |WB|WT|WC|UC]*
[    0.000000] memblock_add: [0x00010ffffc0000-0x00010fffffffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x010ffffff000-0x010fffffffff [Boot Data          |   |  |  |  |  |  |  |   |WB|WT|WC|UC]
[    0.000000] memblock_add: [0x00010fffff0000-0x00010fffffffff] flags 0x0 early_init_dt_add_memory_arch+0x54/0x5c
[    0.000000] efi:   0x804000001000-0x804000001fff [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC]
[    0.000000] efi:   0x87e0d0001000-0x87e0d0001fff [Memory Mapped I/O  |RUN|  |  |  |  |  |  |   |  |  |  |UC]
[    0.000000] memblock_reserve: [0x00010f812b0000-0x00010f812bffff] flags 0x0 efi_init+0x208/0x2c8
[    0.000000] memblock_add: [0x00010f82340000-0x00010f91e7ffff] flags 0x0 arm64_memblock_init+0x16c/0x248
[    0.000000] memblock_reserve: [0x00010f82340000-0x00010f91e7ffff] flags 0x0 arm64_memblock_init+0x178/0x248
[    0.000000] memblock_reserve: [0x00000001480000-0x000000024affff] flags 0x0 arm64_memblock_init+0x1b0/0x248
[    0.000000] memblock_reserve: [0x00010f82343000-0x00010f91e73613] flags 0x0 arm64_memblock_init+0x1cc/0x248
[    0.000000] memblock_reserve: [0x000000c0000000-0x000000dfffffff] flags 0x0 memblock_alloc_range_nid+0x30/0x58
[    0.000000] cma: Reserved 512 MiB at 0x00000000c0000000
[    0.000000] memblock_reserve: [0x00010ffffa0000-0x00010ffffaffff] flags 0x0 memblock_alloc_range_nid+0x30/0x58
[    0.000000] memblock_reserve: [0x00010ffff90000-0x00010ffff9ffff] flags 0x0 memblock_alloc_range_nid+0x30/0x58
[    0.000000] memblock_reserve: [0x00010ffff80000-0x00010ffff8ffff] flags 0x0 memblock_alloc_range_nid+0x30/0x58
[    0.000000] memblock_reserve: [0x00010ffff70000-0x00010ffff7ffff] flags 0x0 memblock_alloc_range_nid+0x30/0x58
[    0.000000] memblock_reserve: [0x00010ffff60000-0x00010ffff6ffff] flags 0x0 memblock_alloc_range_nid+0x30/0x58
[    0.000000] memblock_reserve: [0x00010ffff50000-0x00010ffff5ffff] flags 0x0 memblock_alloc_range_nid+0x30/0x58
[    0.000000] memblock_reserve: [0x00010ffff40000-0x00010ffff4ffff] flags 0x0 memblock_alloc_range_nid+0x30/0x58
[    0.000000] memblock_reserve: [0x00010ffff30000-0x00010ffff3ffff] flags 0x0 memblock_alloc_range_nid+0x30/0x58
[    0.000000]    memblock_free: [0x00010ffffa0000-0x00010ffffaffff] paging_init+0x5c0/0x610
[    0.000000]    memblock_free: [0x00000002490000-0x000000024affff] paging_init+0x5f4/0x610
[    0.000000] memblock_reserve: [0x00010fffefed80-0x00010ffff2fffb] flags 0x0 memblock_alloc_range_nid+0x30/0x58
[    0.000000] memblock_reserve: [0x00010ffffaffd0-0x00010ffffafffe] flags 0x0 memblock_alloc_range_nid+0x30/0x58
[    0.000000] memblock_reserve: [0x00010ffffaffa0-0x00010ffffaffce] flags 0x0 memblock_alloc_range_nid+0x30/0x58
[    0.000000] memblock_reserve: [0x00010ffffa0000-0x00010ffffa000f] flags 0x0 numa_init+0x88/0x3f0
[    0.000000] NUMA: Adding memblock [0x1400000 - 0xfffffffff] on node 0
[    0.000000] NUMA: Adding memblock [0x10000400000 - 0x10fffffffff] on node 1
[    0.000000] NUMA: parsing numa-distance-map-v1
[    0.000000] NUMA: Initmem setup node 0 [mem 0x01400000-0xfffffffff]
[    0.000000] memblock_reserve: [0x00000fffffe500-0x00000fffffffff] flags 0x0 memblock_alloc_range_nid+0x30/0x58
[    0.000000] NUMA: NODE_DATA [mem 0xfffffe500-0xfffffffff]
[    0.000000] NUMA: Initmem setup node 1 [mem 0x10000400000-0x10fffffffff]
[    0.000000] memblock_reserve: [0x00010ffffae480-0x00010ffffaff7f] flags 0x0 memblock_alloc_range_nid+0x30/0x58
[    0.000000] NUMA: NODE_DATA [mem 0x10ffffae480-0x10ffffaff7f]
...
[    8.420710] ------------[ cut here ]------------
[    8.425344] kernel BUG at mm/page_alloc.c:1844!
[    8.429870] Internal error: Oops - BUG: 0 [#1] SMP
[    8.434654] Modules linked in:
[    8.437712] CPU: 72 PID: 1 Comm: swapper/0 Tainted: G        W       4.8.1.4.vanilla10-00007-g9eb3a76b8b88 #111
[    8.447788] Hardware name: www.cavium.com ThunderX CRB-2S/ThunderX CRB-2S, BIOS 0.3 Sep 13 2016
[    8.456474] task: ffff800fee626800 task.stack: ffff800fec02c000
[    8.462404] PC is at move_freepages+0x198/0x1b0
[    8.466924] LR is at move_freepages_block+0xa8/0xb8
[    8.471791] pc : [<ffff0000081e5dd0>] lr : [<ffff0000081e5e90>] pstate: 000000c5
[    8.479174] sp : ffff800fec02f4d0
[    8.482478] x29: ffff800fec02f4d0 x28: 0000000000000001 
[    8.487786] x27: 0000000000000000 x26: 0000000000000000 
[    8.493093] x25: 000000000000000a x24: ffff7fe043fd0020 
[    8.498401] x23: ffff810ffffaec00 x22: 0000000000000000 
[    8.503708] x21: ffff7fe043ffffc0 x20: 0000000000000000 
[    8.509015] x19: ffff7fe043f80000 x18: ffff8100102f2548 
[    8.514322] x17: 0000000000000000 x16: 0000000100000000 
[    8.519630] x15: 0000000000000007 x14: 0000010200000000 
[    8.524938] x13: 0004a41400000000 x12: 00032c920000001a 
[    8.530245] x11: 0000010200000000 x10: 0004a40800000000 
[    8.535553] x9 : 0000000000000040 x8 : 0000000000000000 
[    8.540860] x7 : 0000000000000000 x6 : ffff810ffffaf120 
[    8.546168] x5 : 0000000000000001 x4 : ffff000008d70c48 
[    8.551475] x3 : ffff810ffffae480 x2 : 0000000000000000 
[    8.556782] x1 : 0000000000000001 x0 : ffff810ffffaec00 
[    8.562089] 
[    8.563571] Process swapper/0 (pid: 1, stack limit = 0xffff800fec02c020)
[    8.570261] Stack: (0xffff800fec02f4d0 to 0xffff800fec030000)
...
[    9.279652] Call trace:
[    9.282091] Exception stack(0xffff800fec02f300 to 0xffff800fec02f430)
[    9.288520] f300: ffff7fe043f80000 0001000000000000 ffff800fec02f4d0 ffff0000081e5dd0
[    9.296339] f320: 0000000000000001 ffff800fee626800 0000000000000000 00000000026012d0
[    9.304157] f340: 0000000100000000 ffffffffffffffff 0000000000000130 0000000000000040
[    9.311976] f360: 0000001200000000 ffff000008cf8198 0000000100000000 0000000000000001
[    9.319794] f380: 00000000026012d0 ffff810ff9a1e8e8 0000000000000000 0000000000000040
[    9.327613] f3a0: ffff810ffffaec00 0000000000000001 0000000000000000 ffff810ffffae480
[    9.335431] f3c0: ffff000008d70c48 0000000000000001 ffff810ffffaf120 0000000000000000
[    9.343250] f3e0: 0000000000000000 0000000000000040 0004a40800000000 0000010200000000
[    9.351068] f400: 00032c920000001a 0004a41400000000 0000010200000000 0000000000000007
[    9.358885] f420: 0000000100000000 0000000000000000
[    9.363756] [<ffff0000081e5dd0>] move_freepages+0x198/0x1b0
[    9.369318] [<ffff0000081e5e90>] move_freepages_block+0xa8/0xb8
[    9.375227] [<ffff0000081e657c>] __rmqueue+0x604/0x650
[    9.380355] [<ffff0000081e7898>] get_page_from_freelist+0x3f0/0xb88
[    9.386612] [<ffff0000081e860c>] __alloc_pages_nodemask+0x12c/0xce8
[    9.392876] [<ffff00000823dc1c>] alloc_page_interleave+0x64/0xc0
[    9.398873] [<ffff00000823e2f8>] alloc_pages_current+0x108/0x168
[    9.404870] [<ffff0000081de1cc>] __page_cache_alloc+0x104/0x140
[    9.410779] [<ffff0000081de31c>] pagecache_get_page+0x114/0x300
[    9.416688] [<ffff0000081de550>] grab_cache_page_write_begin+0x48/0x68
[    9.423207] [<ffff00000828e5f8>] simple_write_begin+0x40/0x150
[    9.429029] [<ffff0000081ddfe0>] generic_perform_write+0xb8/0x1a0
[    9.435112] [<ffff0000081df8c8>] __generic_file_write_iter+0x170/0x1b0
[    9.441628] [<ffff0000081df9d4>] generic_file_write_iter+0xcc/0x1c8
[    9.447893] [<ffff000008262eb4>] __vfs_write+0xcc/0x140
[    9.453108] [<ffff000008263b84>] vfs_write+0xa4/0x1c0
[    9.458150] [<ffff000008264bc4>] SyS_write+0x54/0xb0
[    9.463108] [<ffff000008be1fe4>] xwrite+0x34/0x7c
[    9.467801] [<ffff000008be20c8>] do_copy+0x9c/0xf4
[    9.472583] [<ffff000008be1da4>] write_buffer+0x34/0x50
[    9.477796] [<ffff000008be1e08>] flush_buffer+0x48/0xb4
[    9.483016] [<ffff000008c0fe08>] __gunzip+0x288/0x334
[    9.488057] [<ffff000008c0fecc>] gunzip+0x18/0x20
[    9.492750] [<ffff000008be26bc>] unpack_to_rootfs+0x168/0x284
[    9.498486] [<ffff000008be2848>] populate_rootfs+0x70/0x138
[    9.504051] [<ffff000008082ff4>] do_one_initcall+0x44/0x138
[    9.509613] [<ffff000008be0d04>] kernel_init_freeable+0x1ac/0x24c
[    9.515699] [<ffff000008847f20>] kernel_init+0x20/0xf8
[    9.520826] [<ffff000008082b80>] ret_from_fork+0x10/0x50
[    9.526129] Code: 910a0021 9400b47d d4210000 d503201f (d4210000) 
[    9.532233] ---[ end trace c3040dccdcf12d3a ]---
[    9.536889] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b
