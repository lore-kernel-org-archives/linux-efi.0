From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [GIT PULL] x86/mm changes for v4.4
Date: Tue, 10 Nov 2015 08:08:30 +0100
Message-ID: <CAKv+Gu9ct9Rwi+_-0KtLq3Gw2Rn+QLhSVt_zbn4zBxfk_Qs16g@mail.gmail.com>
References: <20151103111649.GA3477@gmail.com>
	<CA+55aFzcwO+RSLeHOwAYvjZ5AcVvD9Th2=G3R=ZQY1xf+MkDow@mail.gmail.com>
	<20151104233907.GA25925@codemonkey.org.uk>
	<CA+55aFxb14eM6b=ctq65Dx-Ujehj2dbtsVM9rrVOVfLgT=EoHg@mail.gmail.com>
	<20151105021710.GA22941@codemonkey.org.uk>
	<CA+55aFyXNFu_TfmBjGedCRujoAbhqiBcia7XOtzSq0uxbVv6MA@mail.gmail.com>
	<20151106065549.GA2031@gmail.com>
	<20151106123912.GC2651@codeblueprint.co.uk>
	<20151107070922.GC6235@gmail.com>
	<CAKv+Gu-s=91p2hVV-8r5AWQwgjD2sbXC86sPhtmq9UyqqcOz4w@mail.gmail.com>
	<CAGXu5jKBqXCexzBmn9ykqRJkBvexcJ_aSJn-vAt8EQqzjwZ-=A@mail.gmail.com>
	<CAKv+Gu_TMKUBKt2zj7-XYmsN0m=6wPzUhfpvN0jbxGiyYnmgTg@mail.gmail.com>
	<CAGXu5jLsnhhd2bXhfp-u2VKoFFr-Da7ANYz1L_Uyk-y3HLoYEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jLsnhhd2bXhfp-u2VKoFFr-Da7ANYz1L_Uyk-y3HLoYEA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Stephen Smalley <sds@tycho.nsa.gov>, Dave Jones <davej@codemonkey.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Denys Vlasenko <dvlasenk@redhat.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Matthew Garrett <mjg59@coreos.com>
List-Id: linux-efi@vger.kernel.org

On 9 November 2015 at 22:08, Kees Cook <keescook@chromium.org> wrote:
> On Sat, Nov 7, 2015 at 11:55 PM, Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
>> On 8 November 2015 at 07:58, Kees Cook <keescook@chromium.org> wrote:
>>> On Fri, Nov 6, 2015 at 11:39 PM, Ard Biesheuvel
>>> <ard.biesheuvel@linaro.org> wrote:
>>>> On 7 November 2015 at 08:09, Ingo Molnar <mingo@kernel.org> wrote:
>>>>>
>>>>> * Matt Fleming <matt@codeblueprint.co.uk> wrote:
>>>>>
>>>>>> On Fri, 06 Nov, at 07:55:50AM, Ingo Molnar wrote:
>>>>>> >
>>>>>> >  3) We should fix the EFI permission problem without relying on the firmware: it
>>>>>> >     appears we could just mark everything R-X optimistically, and if a write fault
>>>>>> >     happens (it's pretty rare in fact, only triggers when we write to an EFI
>>>>>> >     variable and so), we can mark the faulting page RW- on the fly, because it
>>>>>> >     appears that writable EFI sections, while not enumerated very well in 'old'
>>>>>> >     firmware, are still supposed to be page granular. (Even 'new' firmware I
>>>>>> >     wouldn't automatically trust to get the enumeration right...)
>>>>>>
>>>>>> Sorry, this isn't true. I misled you with one of my earlier posts on
>>>>>> this topic. Let me try and clear things up...
>>>>>>
>>>>>> Writing to EFI regions has to do with every invocation of the EFI
>>>>>> runtime services - it's not limited to when you read/write/delete EFI
>>>>>> variables. In fact, EFI variables really have nothing to do with this
>>>>>> discussion, they're a completely opaque concept to the OS, we have no
>>>>>> idea how the firmware implements them. Everything is done via the EFI
>>>>>> boot/runtime services.
>>>>>>
>>>>>> The firmware itself will attempt to write to EFI regions when we
>>>>>> invoke the EFI services because that's where the PE/COFF ".data" and
>>>>>> ".bss" sections live along with the heap. There's even some relocation
>>>>>> fixups that occur as SetVirtualAddressMap() time so it'll write to
>>>>>> ".text" too.
>>>>>>
>>>>>> Now, the above PE/COFF sections are usually (always?) contained within
>>>>>> EFI regions of type EfiRuntimeServicesCode. We know this is true
>>>>>> because the firmware folks have told us so, and because stopping that
>>>>>> is the motivation behind the new EFI_PROPERTIES_TABLE feature in UEFI
>>>>>> V2.5.
>>>>>>
>>>>>> The data sections within the region are also *not* guaranteed to be
>>>>>> page granular because work was required in Tianocore for emitting
>>>>>> sections with 4k alignment as part of the EFI_PROPERTIES_TABLE
>>>>>> support.
>>>>>>
>>>>>> Ultimately, what this means is that if you were to attempt to
>>>>>> dynamically fixup those regions that required write permission, you'd
>>>>>> have to modify the mappings for the majority of the EFI regions
>>>>>> anyway. And if you're blindly allowing write permission as a fixup,
>>>>>> there's not much security to be had.
>>>>>
>>>>> I think you misunderstood my suggestion: the 'fixup' would be changing it from R-X
>>>>> to RW-, i.e. it would add 'write' permission but remove 'execute' permission.
>>>>>
>>>>> Note that there would be no 'RWX' permission at any given moment - which is the
>>>>> dangerous combination.
>>>>>
>>>>
>>>> The problem with that is that /any/ page in the UEFI runtime region
>>>> may intersect with both .text and .data of any of the PE/COFF images
>>>> that make up the runtime firmware (since the PE/COFF sections are not
>>>> necessarily page aligned). Such pages require RWX permissions. The
>>>> UEFI memory map does not provide the information to identify those
>>>> pages a priori (the entire region containing several PE/COFF images
>>>> could be covered by a single entry) so it is hard to guess which pages
>>>> should be allowed these RWX permissions.
>>>
>>> I'm sad that UEFI was designed without even the most basic of memory
>>> protections in mind. UEFI _itself_ should be setting up protective
>>> page mappings. :(
>>>
>>
>> Well, the 4 KB alignment of sections was considered prohibitive at the
>> time from code size pov. But this was a long time ago, obviously.
>
> Heh, yeah, I'd expect max 4K padding to get code/data correctly
> aligned on a 2MB binary to not be an issue. :)
>

This is not about section sizes on ARM. The PE/COFF format does not
use segments, like ELF, so the payload (the sections) needs to be
completely disjoint from the header. This means, when using 4 KB
alignment, that every PE/COFF image wastes ~4 KB in the header and 4
KB on average in the section padding (assuming a .text/.data/.reloc
layout, as is common with PE/COFF)

Considering that a typical UEFI firmware image consists of numerous
(around 50 on average, I think) PE/COFF images, and some of them
execute from NOR flash, the Tianocore tooling (which is the reference
implementation) has always been geared towards keeping the alignment
as small as possible, typically 32 bytes unless data objects need
more. Since the UEFI runtime services are typically implemented by
several of these PE/COFF images, and since the memory they occupy may
be described by a single UEFI memory map entry, there is simply no
easy way to decide which pages need R-X, RW- or RWX. Even looking for
PE/COFF headers in the memory region is not guaranteed to work, since
the PE/COFF header is part of the file format, not the memory format
(i.e., since the header is disjoint from the payload, a PE/COFF loader
is not required to copy the header to memory)

>>
>>> For a boot firmware, it seems to me that safe page table layout would
>>> be a top priority bug. The "reporting issues" page for TianoCore
>>> doesn't actually seem to link to the "Project Tracker":
>>> https://github.com/tianocore/tianocore.github.io/wiki/Reporting-Issues
>>>
>>> Does anyone know how to get this correctly reported so future UEFI
>>> releases don't suffer from this?
>>>
>>
>> Ugh. Don't get me started on that topic. I have been working with the
>> UEFI forum since July to get a fundamentally broken implementation of
>> memory protections fixed. UEFI v2.5 defines a memory protection scheme
>> that is based on splitting PE/COFF images into separate memory regions
>> so that R-X and RW- permissions can be applied. Unfortunately, that
>> broke every OS in existence (including Windows 8), since the OS is
>> allowed to reorder memory regions when it lays out the virtual
>> remapping of the UEFI regions, resulting in PE/COFF .data and .text
>> potentially appearing out of order.
>>
>> The good news is that we fixed it for the upcoming release (v2.6). I
>> can't disclose any specifics, though :-(
>
> As long as there's motion to getting it fixed, that makes me happy! :)
> Does 2.6 get rid of the (AIUI) 2MB limit too?
>

No, there is no such limit in UEFI. If there is a limit like that, it
is an implementation detail of the UEFI support in the OS.

For arm64 (and the upcoming ARM support), the UEFI runtime services
regions are remapped into a virtual userland range that is only active
during the time runtime services are being invoked. (x86 does
something similar, but it shares the page tables with the
suspend/resume code afaiu) These mappings could be page granularity
(since they don't require splitting PUDs or PMDs in the linear
region), with the side note that arm64 mandates 64 KB alignment (to
interoperate with 64 KB pages OSes). This requirement has been added
to the UEFI spec, i.e., a v2.5 compliant arm64 firmware should not
expose UEFI runtime regions that are not 64 KB aligned.

-- 
Ard.
