From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [GIT PULL] x86/mm changes for v4.4
Date: Sat, 7 Nov 2015 08:39:35 +0100
Message-ID: <CAKv+Gu-s=91p2hVV-8r5AWQwgjD2sbXC86sPhtmq9UyqqcOz4w@mail.gmail.com>
References: <20151103111649.GA3477@gmail.com>
	<CA+55aFzcwO+RSLeHOwAYvjZ5AcVvD9Th2=G3R=ZQY1xf+MkDow@mail.gmail.com>
	<20151104233907.GA25925@codemonkey.org.uk>
	<CA+55aFxb14eM6b=ctq65Dx-Ujehj2dbtsVM9rrVOVfLgT=EoHg@mail.gmail.com>
	<20151105021710.GA22941@codemonkey.org.uk>
	<CA+55aFyXNFu_TfmBjGedCRujoAbhqiBcia7XOtzSq0uxbVv6MA@mail.gmail.com>
	<20151106065549.GA2031@gmail.com>
	<20151106123912.GC2651@codeblueprint.co.uk>
	<20151107070922.GC6235@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151107070922.GC6235@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ingo Molnar <mingo@kernel.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Stephen Smalley <sds@tycho.nsa.gov>, Dave Jones <davej@codemonkey.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Denys Vlasenko <dvlasenk@redhat.com>, Kees Cook <keescook@chromium.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 7 November 2015 at 08:09, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Matt Fleming <matt@codeblueprint.co.uk> wrote:
>
>> On Fri, 06 Nov, at 07:55:50AM, Ingo Molnar wrote:
>> >
>> >  3) We should fix the EFI permission problem without relying on the firmware: it
>> >     appears we could just mark everything R-X optimistically, and if a write fault
>> >     happens (it's pretty rare in fact, only triggers when we write to an EFI
>> >     variable and so), we can mark the faulting page RW- on the fly, because it
>> >     appears that writable EFI sections, while not enumerated very well in 'old'
>> >     firmware, are still supposed to be page granular. (Even 'new' firmware I
>> >     wouldn't automatically trust to get the enumeration right...)
>>
>> Sorry, this isn't true. I misled you with one of my earlier posts on
>> this topic. Let me try and clear things up...
>>
>> Writing to EFI regions has to do with every invocation of the EFI
>> runtime services - it's not limited to when you read/write/delete EFI
>> variables. In fact, EFI variables really have nothing to do with this
>> discussion, they're a completely opaque concept to the OS, we have no
>> idea how the firmware implements them. Everything is done via the EFI
>> boot/runtime services.
>>
>> The firmware itself will attempt to write to EFI regions when we
>> invoke the EFI services because that's where the PE/COFF ".data" and
>> ".bss" sections live along with the heap. There's even some relocation
>> fixups that occur as SetVirtualAddressMap() time so it'll write to
>> ".text" too.
>>
>> Now, the above PE/COFF sections are usually (always?) contained within
>> EFI regions of type EfiRuntimeServicesCode. We know this is true
>> because the firmware folks have told us so, and because stopping that
>> is the motivation behind the new EFI_PROPERTIES_TABLE feature in UEFI
>> V2.5.
>>
>> The data sections within the region are also *not* guaranteed to be
>> page granular because work was required in Tianocore for emitting
>> sections with 4k alignment as part of the EFI_PROPERTIES_TABLE
>> support.
>>
>> Ultimately, what this means is that if you were to attempt to
>> dynamically fixup those regions that required write permission, you'd
>> have to modify the mappings for the majority of the EFI regions
>> anyway. And if you're blindly allowing write permission as a fixup,
>> there's not much security to be had.
>
> I think you misunderstood my suggestion: the 'fixup' would be changing it from R-X
> to RW-, i.e. it would add 'write' permission but remove 'execute' permission.
>
> Note that there would be no 'RWX' permission at any given moment - which is the
> dangerous combination.
>

The problem with that is that /any/ page in the UEFI runtime region
may intersect with both .text and .data of any of the PE/COFF images
that make up the runtime firmware (since the PE/COFF sections are not
necessarily page aligned). Such pages require RWX permissions. The
UEFI memory map does not provide the information to identify those
pages a priori (the entire region containing several PE/COFF images
could be covered by a single entry) so it is hard to guess which pages
should be allowed these RWX permissions.

>> >     If that 'supposed to be' turns out to be 'not true' (not unheard of in
>> >     firmware land), then plan B would be to mark pages that generate write faults
>> >     RWX as well, to not break functionality. (This 'mark it RWX' is not something
>> >     that exploits would have easy access to, and we could also generate a warning
>> >     [after the EFI call has finished] if it ever triggers.)
>> >
>> >     Admittedly this approach might not be without its own complications, but it
>> >     looks reasonably simple (I don't think we need per EFI call page tables,
>> >     etc.), and does not assume much about the firmware being able to enumerate its
>> >     permissions properly. Were we to merge EFI support today I'd have insisted on
>> >     trying such an approach from day 1 on.
>>
>> We already have separate EFI page tables, though with the caveat that
>> we share some of swapper_pg_dir's PGD entries. The best solution would
>> be to stop sharing entries and isolate the EFI mappings from every
>> other page table structure, so that they're only used during the EFI
>> service calls.
>
> Absolutely. Can you try to fix this for v4.3?
>
> Thanks,
>
>         Ingo
