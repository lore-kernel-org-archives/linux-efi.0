From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 2/2] arm64: efi: add vmlinux debug link to the Image binary
Date: Wed, 25 Jan 2017 12:00:44 +0000
Message-ID: <CAKv+Gu-GQAQU2Ety+rBvZ-9VbUHe+jQQosFJ-63UTQ7pPHHh0Q@mail.gmail.com>
References: <1485340759-28975-1-git-send-email-ard.biesheuvel@linaro.org>
 <1485340759-28975-3-git-send-email-ard.biesheuvel@linaro.org> <20170125115305.GA29027@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170125115305.GA29027@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 25 January 2017 at 11:53, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> On Wed, Jan 25, 2017 at 10:39:19AM +0000, Ard Biesheuvel wrote:
>> When building with debugging symbols, take the absolute path to the
>> vmlinux binary and add it to the special PE/COFF debug table entry.
>>
>> These entries are used internally by EDK2 based* debug builds of UEFI
>> to populate the DebugImageInfo table, which can be used by debuggers
>> as well as by the OS itself to retrieve information about all loaded
>> PE/COFF executables. This is highly useful for source level debugging
>> of the UEFI stub.
>
> Does that mean EFI_IMAGE_DEBUG_DIRECTORY_ENTRY and friends are
> EDK2-specific?
>
> Or just that the way EDK2 happens to use those is EDK2-specific?
>

Those values are defined by the PE/COFF spec, and I assume that a
CodeView type entry in the debug table usually contains a NUL
terminated string as well, given that the EDK2 crowd is very
Wintel-heavy.

The significance of mentioning EDK2 here was that I thought that the
DebugImageInfo table was a PI construct rather than something
described in the UEFI spec. But looking more carefully, it seems that
this table is in fact a UEFI construct, so I should probably drop this
mention from the commit log

>> * for AArch64, this probably means all of them
>>
>> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  arch/arm64/kernel/Makefile |  4 +++
>>  arch/arm64/kernel/head.S   | 34 +++++++++++++++++++-
>>  arch/arm64/kernel/image.h  |  3 ++
>>  3 files changed, 40 insertions(+), 1 deletion(-)
>
>> +efi_debug_table:
>> +     // EFI_IMAGE_DEBUG_DIRECTORY_ENTRY
>> +     .long   0                       // Characteristics
>> +     .long   0                       // TimeDateStamp
>> +     .short  0                       // MajorVersion
>> +     .short  0                       // MinorVersion
>> +     .long   2                       // Type == EFI_IMAGE_DEBUG_TYPE_CODEVIEW
>
>> +ENTRY(efi_debug_entry)
>> +     // EFI_IMAGE_DEBUG_CODEVIEW_NB10_ENTRY
>> +     .long   0x3031424E              // Signature
>
> Certainly not a blocker for this, but this reminds me that it would be
> nice to de-magic the EFI constants used by the stub.
>
> I took a stab a while back [1], for the existing definitions, but that
> fell by the wayside.
>

Good point.
