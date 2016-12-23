From: Nicolai Stange <nicstange@gmail.com>
Subject: Re: [PATCH v2 1/2] x86/efi: don't allocate memmap through memblock after mm_init()
Date: Fri, 23 Dec 2016 22:12:21 +0100
Message-ID: <878tr6jqoa.fsf@gmail.com>
References: <20161222102340.2689-1-nicstange@gmail.com>
        <20161223145206.GC16838@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161223145206.GC16838@codeblueprint.co.uk> (Matt Fleming's
        message of "Fri, 23 Dec 2016 14:52:06 +0000")
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Nicolai Stange <nicstange@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Mika =?utf-8?Q?Penttil=C3=A4?= <mika.penttila@nextfour.com>
List-Id: linux-efi@vger.kernel.org

Matt Fleming <matt@codeblueprint.co.uk> writes:

> On Thu, 22 Dec, at 11:23:39AM, Nicolai Stange wrote:
>> So, after memblock is gone, allocations should be done through the "normal"
>> page allocator. Introduce a helper, efi_memmap_alloc() for this. Use
>> it from efi_arch_mem_reserve() and from efi_free_boot_services() as well.
>> 
>> Fixes: 4bc9f92e64c8 ("x86/efi-bgrt: Use efi_mem_reserve() to avoid copying image data")
>> Signed-off-by: Nicolai Stange <nicstange@gmail.com>

> Could you also modify efi_fake_memmap() to use your new
> efi_memmap_alloc() function for consistency

Sure.

I'm planning to submit another set of patches addressing the (bounded)
memmap leaking in anything calling efi_memmap_unmap() though. In the
course of doing so, the memmap allocation sites will get touched anyway:
I'll have to store some information about how the memmap's memory has
been obtained.

> (note that all memblock_alloc()s should probably be PAGE_SIZE aligned
> like the fakemem code)?

Ok, but I'd really like to understand why: I can't find anything in
neither the code nor in the UEFI spec requiring this. And up to now,
efi_arch_mem_reserve() as well as efi_free_boot_services() used to do
those unaligned allocations...

In light of this, is there really a necessity for using whole page
allocations after mm_init() or would kmalloc() suffice here?
Provided that the memremap bits get adjusted accordingly, of course.

So, I'm thinking of turning the ->late boolean into a tristate like the
following:

Memory allocated by | Memory mapped through
--------------------|----------------------
memblock            | early_memremap
memblock            | memremap
kmalloc             | -

Neglecting slub overhead, the use of kmalloc() over alloc_pages() would
save 4096 - 12*40 == 3616 Bytes on my system with its 12 entries under
/sys/firmware/efi/runtime-map/. Not really critical, but if it comes for
free, why not?


Thanks,

Nicolai
