From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] arm64/efi: set PE/COFF section alignment to 4 KB
Date: Fri, 10 Oct 2014 17:59:53 +0200
Message-ID: <CAKv+Gu__UGmSWOhVTWqmJAAnC0Zq_p87An-y7JELyu+EKCE=Mg@mail.gmail.com>
References: <1412933124-13018-1-git-send-email-ard.biesheuvel@linaro.org>
	<20141010103301.GC4076@leverpostej>
	<CAKv+Gu9b56r3Ujv342xC5CA3_i4yE6ySd=UjUss2U5Yaho0jAQ@mail.gmail.com>
	<CAFECyb8pkia6NKETNb-v-5iVZEs66D3Wy5t9DngR4TEa1_Nt6g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFECyb8pkia6NKETNb-v-5iVZEs66D3Wy5t9DngR4TEa1_Nt6g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 10 October 2014 17:55, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On Fri, Oct 10, 2014 at 3:37 AM, Ard Biesheuvel
> <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> On 10 October 2014 12:33, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
>>> Hi Ard,
>>>
>>> On Fri, Oct 10, 2014 at 10:25:24AM +0100, Ard Biesheuvel wrote:
>>>> Position independent AArch64 code needs to be linked and loaded at the same
>>>> relative offset from a 4 KB boundary, or adrp/add and adrp/ldr pairs will
>>>> not work correctly. (This is how PC relative symbol references with a 4 GB
>>>> reach are emitted)
>>>>
>>>> We need to declare this in the PE/COFF header, otherwise the PE/COFF loader
>>>> may load the Image and invoke the stub at an offset which violates this rule.
>>>
>>> Has this been observed happening, or was this just found by inspection?
>>>
>>
>> This is also something found by inspection, or rather, by the
>> discussion going on in the other thread. I am not aware of any PE/COFF
>> loaders that may choose an offset that is not 4 KB aligned, even if
>> the header we give it appears to allow it.
>>
>
> This also resolves the problematic FileAlignment that I noticed when reviewing
> the branch to stext patch.
>
> The PE/COFF spec description of FileAlignment
>
> The alignment factor (in bytes) that is
> used to align the raw data of sections
> in the image file. The value should be
> a power of 2 between 512 and 64 K,
> inclusive. The default is 512. If the
> SectionAlignment is less than the
> architecture's page size, then
> FileAlignment must match
> SectionAlignment.
>
> Previously the section alignment was less than the page size,
> and FileAlignment/SectionAlignment didn't match.
>
> Reviewed-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>

Yes, but this also means (as I noticed just now), that our file
alignment is out of spec, as it should be at least 0x200.
Unfortunately, that means we have to pad the kernel .data section to
0x200 alignment as well.

Oh, and our architecture does not have a single page size, so I wonder
if we shouldn't just set both to 0x1000 and be done with it.

Thanks,
Ard.

>>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>>> ---
>>>>  arch/arm64/kernel/head.S | 4 ++--
>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
>>>> index 0a6e4f924df8..5e83e5b8a9de 100644
>>>> --- a/arch/arm64/kernel/head.S
>>>> +++ b/arch/arm64/kernel/head.S
>>>> @@ -159,7 +159,7 @@ optional_header:
>>>>
>>>>  extra_header_fields:
>>>>       .quad   0                               // ImageBase
>>>> -     .long   0x20                            // SectionAlignment
>>>> +     .long   0x1000                          // SectionAlignment
>>>>       .long   0x8                             // FileAlignment
>>>>       .short  0                               // MajorOperatingSystemVersion
>>>>       .short  0                               // MinorOperatingSystemVersion
>>>> @@ -226,7 +226,7 @@ section_table:
>>>>       .short  0               // NumberOfRelocations  (0 for executables)
>>>>       .short  0               // NumberOfLineNumbers  (0 for executables)
>>>>       .long   0xe0500020      // Characteristics (section flags)
>>>> -     .align 5
>>>> +     .align 12
>>>
>>> Can we get a comment explaining why stext needs the additional
>>> alignment? Something like:
>>>
>>>         /*
>>>          * EFI will load stext onwards at the 4k section alignment
>>>          * described in the PE/COFF header. To ensure that instruction
>>>          * sequences using an adrp and a :lo12: immediate will function
>>>          * correctly at this alignment, we must ensure that stext is
>>>          * placed at a 4k boundary in the Image to begin with.
>>>          */
>>>         .align 12
>>>
>>
>> OK
>>
>> --
>> Ard.
