From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 11/13] arm64/efi: use plain memblock API for adding and
 removing reserved RAM
Date: Wed, 26 Nov 2014 17:59:07 +0100
Message-ID: <CAKv+Gu_qsx60P-CBJoK=2Efy0w3Ud3xHhBdOQ+V1FuStZRMDkg@mail.gmail.com>
References: <1416315432-8534-1-git-send-email-ard.biesheuvel@linaro.org>
	<1416315432-8534-12-git-send-email-ard.biesheuvel@linaro.org>
	<1416504536.6398.58.camel@deneb.redhat.com>
	<CAKv+Gu9XQWrQyPi+8=vhXWkJXtnJ+8=evNC-Z_MkWR8Wuk6Awg@mail.gmail.com>
	<1416506069.6398.64.camel@deneb.redhat.com>
	<CAKv+Gu_2kn10dh7LMbhVVYu8+LkMoN_Vxi-tnmCEcBTJ7qs_Jg@mail.gmail.com>
	<1416583273.6398.71.camel@deneb.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1416583273.6398.71.camel-PDpCo7skNiwAicBL8TP8PQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Geoff Levand <geoff.levand-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 21 November 2014 at 16:21, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Fri, 2014-11-21 at 13:07 +0100, Ard Biesheuvel wrote:
>> On 20 November 2014 18:54, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> > On Thu, 2014-11-20 at 18:38 +0100, Ard Biesheuvel wrote:
>> >> On 20 November 2014 18:28, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> >> > On Tue, 2014-11-18 at 13:57 +0100, Ard Biesheuvel wrote:
>> >> >> diff --git a/drivers/firmware/efi/virtmap.c
>> >> >> b/drivers/firmware/efi/virtmap.c
>> >> >> index 98735fb43581..4b6a5c31629f 100644
>> >> >> --- a/drivers/firmware/efi/virtmap.c
>> >> >> +++ b/drivers/firmware/efi/virtmap.c
>> >> >> @@ -8,6 +8,7 @@
>> >> >>   */
>> >> >>
>> >> >>  #include <linux/efi.h>
>> >> >> +#include <linux/memblock.h>
>> >> >>  #include <linux/mm_types.h>
>> >> >>  #include <linux/rbtree.h>
>> >> >>  #include <linux/rwsem.h>
>> >> >> @@ -97,8 +98,15 @@ void __init efi_virtmap_init(void)
>> >> >>                 u64 paddr, npages, size;
>> >> >>                 pgprot_t prot;
>> >> >>
>> >> >> -               if (!efi_mem_is_usable_region(md))
>> >> >> +               paddr = md->phys_addr;
>> >> >> +               npages = md->num_pages;
>> >> >> +               memrange_efi_to_native(&paddr, &npages);
>> >> >> +               size = npages << PAGE_SHIFT;
>> >> >> +
>> >> >> +               if (!efi_mem_is_usable_region(md)) {
>> >> >>                         efi_register_mem_resource(md);
>> >> >> +                       memblock_remove(paddr, size);
>> >> >> +               }
>> >> >
>> >> > What exactly is the memblock_remove trying to accomplish? With it, I
>> >> > get:
>> >> >
>> >>
>> >> The idea was pfn_valid() will then return false for those pfns,
>> >> allowing us to distinguish them from memory that the kernel may be
>> >> using, primarily for /dev/mem filtering. But apparently it is causing
>> >> problems for you, so I will have to figure out if there is a better
>> >> way of addressing this.
>> >>
>> > Okay. Well I think that works for pfn_valid, but it is confusing the
>> > mem_cgroup code. I think because you end up with multiple memory regions
>> > after creating the holes. Earlier memory management code saw one memory
>> > region. And because this comes after paging_init(), all of the memory
>> > ends up in the kernel linear mapping which is something we were trying
>> > to avoid.
>> >
>>
>> I will drop the memblock_remove() then. I guess I could make the test
>> in devmem_is_allowed() do
>>
>> if (!memblock_is_memory() || memblock_is_reserved())
>>
>> instead of 'if (!pfn_valid())' so that reserved regions become
>> accessible with having to remove them.
>
> Maybe we should add a new memblock to keep track of uefi tables.
> The memblock_is_reserved() seems overly permissive to me.
>

OK. So instead, I will split reserve_regions() into 2 passes:
- first pass adds all EFI_MEMORY_WB regions (unrounded)
- second pass one removes all reserved regions (rounded up to OS page size)

That way, the devmem stuff should still work as well.

QEMU example:

Processing EFI memory map:
  0x0000b711d000-0x0000b71dffff [Runtime Data       |RUN|  |  |  |
|WB|WT|WC|UC]
  0x0000bfb21000-0x0000bfb34fff [Runtime Code       |RUN|  |  |  |
|WB|WT|WC|UC]
  0x0000bfb35000-0x0000bfb66fff [Runtime Data       |RUN|  |  |  |
|WB|WT|WC|UC]
  0x0000bfb6a000-0x0000bfb6afff [Runtime Data       |RUN|  |  |  |
|WB|WT|WC|UC]
  0x0000bfb82000-0x0000bfb82fff [Runtime Data       |RUN|  |  |  |
|WB|WT|WC|UC]
  0x000004000000-0x000007ffffff [Memory Mapped I/O  |RUN|  |  |  |   |
 |  |  |UC]
  0x000009010000-0x000009010fff [Memory Mapped I/O  |RUN|  |  |  |   |
 |  |  |UC]
  0x000040000000-0x0000407affff [Loader Data        |   |  |  |  |
|WB|WT|WC|UC]
  0x0000b71e0000-0x0000bb77efff [Conventional Memory|   |  |  |  |
|WB|WT|WC|UC]
  0x0000bb77f000-0x0000bbc00fff [Boot Data          |   |  |  |  |
|WB|WT|WC|UC]
  0x0000bbc01000-0x0000bbdc2fff [Conventional Memory|   |  |  |  |
|WB|WT|WC|UC]
  0x0000bbdc3000-0x0000bc01ffff [Boot Data          |   |  |  |  |
|WB|WT|WC|UC]
  0x0000bc020000-0x0000bfa43fff [Conventional Memory|   |  |  |  |
|WB|WT|WC|UC]
  0x0000bfa44000-0x0000bfb20fff [Boot Code          |   |  |  |  |
|WB|WT|WC|UC]
  0x0000407b0000-0x00005fdfffff [Conventional Memory|   |  |  |  |
|WB|WT|WC|UC]
  0x00005fe00000-0x00005fe0ffff [Loader Data        |   |  |  |  |
|WB|WT|WC|UC]
  0x0000bfb67000-0x0000bfb69fff [Boot Data          |   |  |  |  |
|WB|WT|WC|UC]
  0x00005fe10000-0x0000b6337fff [Conventional Memory|   |  |  |  |
|WB|WT|WC|UC]
  0x0000bfb6b000-0x0000bfb7efff [Conventional Memory|   |  |  |  |
|WB|WT|WC|UC]
  0x0000bfb7f000-0x0000bfb81fff [Boot Data          |   |  |  |  |
|WB|WT|WC|UC]
  0x0000b6338000-0x0000b6338fff [Loader Data        |   |  |  |  |
|WB|WT|WC|UC]
  0x0000bfb83000-0x0000bfffffff [Boot Data          |   |  |  |  |
|WB|WT|WC|UC]
  0x0000b6339000-0x0000b6a4bfff [Loader Code        |   |  |  |  |
|WB|WT|WC|UC]
  0x0000b6a4c000-0x0000b711cfff [Boot Code          |   |  |  |  |
|WB|WT|WC|UC]

MEMBLOCK configuration:
 memory size = 0x7fef5000 reserved size = 0x1724000
 memory.cnt  = 0x5
 memory[0x0] [0x00000040000000-0x000000b711cfff], 0x7711d000 bytes flags: 0x0
 memory[0x1] [0x000000b71e0000-0x000000bfb20fff], 0x8941000 bytes flags: 0x0
 memory[0x2] [0x000000bfb67000-0x000000bfb69fff], 0x3000 bytes flags: 0x0
 memory[0x3] [0x000000bfb6b000-0x000000bfb81fff], 0x17000 bytes flags: 0x0
 memory[0x4] [0x000000bfb83000-0x000000bfffffff], 0x47d000 bytes flags: 0x0
 reserved.cnt  = 0x4
 reserved[0x0] [0x00000040080000-0x00000040792fff], 0x713000 bytes flags: 0x0
 reserved[0x1] [0x0000005fe00000-0x0000005fe0ffff], 0x10000 bytes flags: 0x0
 reserved[0x2] [0x000000b6338000-0x000000b6338fff], 0x1000 bytes flags: 0x0
 reserved[0x3] [0x000000be800000-0x000000bf7fffff], 0x1000000 bytes flags: 0x0
   memblock_free: [0x00000040792000-0x00000040792fff]
__create_mapping.isra.6+0x9c/0x2ac

>>
>> Are you happy with the other change in this patch, i.e., using
>> memblock_add() directly so that we don't have to deal with the
>> rounding?
>>
>
> Yeah, I think that's okay. Everything else seems to be working fine
> in my testing.
>

Cheers,
Ard.
