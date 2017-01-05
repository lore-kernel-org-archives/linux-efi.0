From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2 1/2] x86/efi: don't allocate memmap through memblock
 after mm_init()
Date: Thu, 5 Jan 2017 09:39:01 +0000
Message-ID: <CAKv+Gu9AabgVMQ+uZkmiJZt9shBB=j4XUccRoRJcv5+T8X7eAw@mail.gmail.com>
References: <20161222102340.2689-1-nicstange@gmail.com> <20161223145206.GC16838@codeblueprint.co.uk>
 <878tr6jqoa.fsf@gmail.com> <20170105074221.GA1777@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170105074221.GA1777@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Nicolai Stange <nicstange@gmail.com>, Matt Fleming <matt@codeblueprint.co.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-efi@vger.kernel.org

On 5 January 2017 at 07:42, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Nicolai Stange <nicstange@gmail.com> wrote:
>
>> Matt Fleming <matt@codeblueprint.co.uk> writes:
>>
>> > On Thu, 22 Dec, at 11:23:39AM, Nicolai Stange wrote:
>> >> So, after memblock is gone, allocations should be done through the "normal"
>> >> page allocator. Introduce a helper, efi_memmap_alloc() for this. Use
>> >> it from efi_arch_mem_reserve() and from efi_free_boot_services() as well.
>> >>
>> >> Fixes: 4bc9f92e64c8 ("x86/efi-bgrt: Use efi_mem_reserve() to avoid copying image data")
>> >> Signed-off-by: Nicolai Stange <nicstange@gmail.com>
>>
>> > Could you also modify efi_fake_memmap() to use your new
>> > efi_memmap_alloc() function for consistency
>>
>> Sure.
>>
>> I'm planning to submit another set of patches addressing the (bounded)
>> memmap leaking in anything calling efi_memmap_unmap() though. In the
>> course of doing so, the memmap allocation sites will get touched anyway:
>> I'll have to store some information about how the memmap's memory has
>> been obtained.
>
> Will that patch be intrusive?
>

Given that memblock_alloc() calls memblock_reserve() on its
allocations, we could simply consult the memblock_reserved table to
infer whether the allocation being freed was created with
memblock_alloc() or with alloc_pages(). So I don't think such a patch
should be that intrusive. But the normal case is that the EFI memory
map remains mapped during the lifetime of the system, and unmapping
the EFI memory map does not necessarily imply that it should be freed.
This is especially true on ARM systems, where the memory map is
allocated and populated by the stub, and never modified by the kernel
proper, and so any freeing logic in generic code should take this into
account as well (i.e., the memory map allocation is not
memblock_reserve()'d, nor is it allocated using alloc_pages())

> If yes then we'll need to keep this a separate urgent patch to fix the v4.9
> regression that Dan Williams reported. I can apply the fix to efi/urgent and get
> it to Linus straight away if you guys agree.
>

Considering the severity of the issue it solves, and the obvious
correctness of the fix, my preference would be to spin a v3 of this
patch taking Matt's feedback into account, and merging that as a fix
for v4.10 with a cc stable. The 2/2 can wait a bit longer imo
