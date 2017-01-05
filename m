From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/2] x86/efi: don't allocate memmap through memblock
 after mm_init()
Date: Thu, 5 Jan 2017 11:34:06 +0000
Message-ID: <CAKv+Gu-KEJ3t5kqedbcmkagyxHusuvj2whc5zLY521tRtenUBg@mail.gmail.com>
References: <20161222102340.2689-1-nicstange@gmail.com> <20161223145206.GC16838@codeblueprint.co.uk>
 <878tr6jqoa.fsf@gmail.com> <20170105074221.GA1777@gmail.com>
 <CAKv+Gu9AabgVMQ+uZkmiJZt9shBB=j4XUccRoRJcv5+T8X7eAw@mail.gmail.com> <87inpt6ce7.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87inpt6ce7.fsf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila-MRsr7dthA9VWk0Htik3J/w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 5 January 2017 at 10:15, Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> writes:
>
>> On 5 January 2017 at 07:42, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>>
>>> * Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>>
>>>> Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> writes:
>>>>
>>>> > On Thu, 22 Dec, at 11:23:39AM, Nicolai Stange wrote:
>>>> >> So, after memblock is gone, allocations should be done through
>>>> >> the "normal"
>>>> >> page allocator. Introduce a helper, efi_memmap_alloc() for this. Use
>>>> >> it from efi_arch_mem_reserve() and from efi_free_boot_services() as well.
>>>> >>
>>>> >> Fixes: 4bc9f92e64c8 ("x86/efi-bgrt: Use efi_mem_reserve() to
>>>> >> avoid copying image data")
>>>> >> Signed-off-by: Nicolai Stange <nicstange-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>>>
>>>> > Could you also modify efi_fake_memmap() to use your new
>>>> > efi_memmap_alloc() function for consistency
>>>>
>>>> Sure.
>>>>
>>>> I'm planning to submit another set of patches addressing the (bounded)
>>>> memmap leaking in anything calling efi_memmap_unmap() though. In the
>>>> course of doing so, the memmap allocation sites will get touched anyway:
>>>> I'll have to store some information about how the memmap's memory has
>>>> been obtained.
>>>
>>> Will that patch be intrusive?
>
> Yes, definitely something for 4.11+.
>
>
>> Given that memblock_alloc() calls memblock_reserve() on its
>> allocations, we could simply consult the memblock_reserved table to
>> infer whether the allocation being freed was created with
>> memblock_alloc() or with alloc_pages().
>
> Not sure whether this would work with CONFIG_ARCH_DISCARD_MEMBLOCK=y.
> This is also the reason why 2/2 is needed.
>

OK, I hadn't considered that. It is rather unfortunate that on x86,
each call to efi_arch_mem_reserve() could potentially result in a new
allocation to be created for the entire memory map (consisting of
hundreds of 40-byte entries), leaking the old one. So I agree that
this code needs some work, and I also agree that it is v4.11 material
at the earliest.

>> So I don't think such a patch
>> should be that intrusive. But the normal case is that the EFI memory
>> map remains mapped during the lifetime of the system, and unmapping
>> the EFI memory map does not necessarily imply that it should be freed.
>> This is especially true on ARM systems, where the memory map is
>> allocated and populated by the stub, and never modified by the kernel
>> proper, and so any freeing logic in generic code should take this into
>> account as well (i.e., the memory map allocation is not
>> memblock_reserve()'d, nor is it allocated using alloc_pages())
>
>
>
>>> If yes then we'll need to keep this a separate urgent patch to fix the v4.9
>>> regression that Dan Williams reported. I can apply the fix to
>>> efi/urgent and get
>>> it to Linus straight away if you guys agree.
>>>
>>
>> Considering the severity of the issue it solves, and the obvious
>> correctness of the fix, my preference would be to spin a v3 of this
>> patch taking Matt's feedback into account, and merging that as a fix
>> for v4.10 with a cc stable. The 2/2 can wait a bit longer imo
>
> Matt's Feedback included that
>
>   "all memblock_alloc()s should probably be PAGE_SIZE aligned like the
>    fakemem code"
>
> Unfortunately, I can't see why this would be needed. Furthermore, this
> isn't currently done outside of fakemem and thus, aliging the memmap
> allocations on PAGE_SIZE would be another, quite unrelated change?
>

We use a pool allocation for the memory map on ARM, which is never
page aligned (and page aligned in EFI doesn't mean as much when the OS
page size is 16k or 64k) so I think you are correct here.
> So, are you Ok with only taking the other review comment, namely
>
>   "modify efi_fake_memmap() to use your new efi_memmap_alloc() function
>    for consistency"
>
> into account for a v3?
>

Yes, that should be sufficient for a fix that can be backported.
Anything else can wait for now
