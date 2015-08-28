From: Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] x86, efi, kasan: #undef memset/memcpy/memmove per arch.
Date: Fri, 28 Aug 2015 17:57:14 +0300
Message-ID: <CAPAsAGwDQC36yRRPGVqSp6Fy5o2xgO6g7j8Bz_BysMJJAriv3g@mail.gmail.com>
References: <20150828062745.GB1928@gmail.com>
	<1440760199-18111-1-git-send-email-ryabinin.a.a@gmail.com>
	<20150828144358.GI2759@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150828144358.GI2759-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

2015-08-28 17:43 GMT+03:00 Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>:
> On Fri, 28 Aug, at 02:09:59PM, Andrey Ryabinin wrote:
>> In not-instrumented code KASAN replaces instrumented
>> memset/memcpy/memmove with not-instrumented analogues
>> __memset/__memcpy/__memove.
>> However, on x86 the EFI stub is not linked with the kernel.
>> It uses not-instrumented mem*() functions from
>> arch/x86/boot/compressed/string.c
>> So we don't replace them with __mem*() variants in EFI stub.
>>
>> On ARM64 the EFI stub is linked with the kernel, so we should
>> replace mem*() functions with __mem*(), because the EFI stub
>> runs before KASAN sets up early shadow.
>>
>> So let's move these #undef mem* into arch's asm/efi.h which is
>> also included by the EFI stub.
>>
>> Signed-off-by: Andrey Ryabinin <ryabinin.a.a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>  arch/x86/include/asm/efi.h             | 11 +++++++++++
>>  drivers/firmware/efi/libstub/efistub.h |  4 ----
>>  2 files changed, 11 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
>> index 155162e..6862f11 100644
>> --- a/arch/x86/include/asm/efi.h
>> +++ b/arch/x86/include/asm/efi.h
>> @@ -25,6 +25,17 @@
>>  #define EFI32_LOADER_SIGNATURE       "EL32"
>>  #define EFI64_LOADER_SIGNATURE       "EL64"
>>
>> +/*
>> + * Sometimes we may redefine memset to __memset.
>> + * The EFI stub doesn't have __memset() because it's not
>> + * linked with the kernel. So we should use standard
>> + * memset from arch/x86/boot/compressed/string.c
>> + * The same applies to memcpy and memmove.
>> + */
>> +#undef memcpy
>> +#undef memset
>> +#undef memmove
>> +
>
> I think the key piece of information missing in this comment is that
> it's redefined for KASAN, right?
>

Right.

>>  #ifdef CONFIG_X86_32
>>
>>
>> diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
>> index e334a01..6b6548f 100644
>> --- a/drivers/firmware/efi/libstub/efistub.h
>> +++ b/drivers/firmware/efi/libstub/efistub.h
>> @@ -5,10 +5,6 @@
>>  /* error code which can't be mistaken for valid address */
>>  #define EFI_ERROR    (~0UL)
>>
>> -#undef memcpy
>> -#undef memset
>> -#undef memmove
>> -
>>  void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
>>
>>  efi_status_t efi_open_volume(efi_system_table_t *sys_table_arg, void *__image,
>
> Does this patch have any negative consequences for arm64? Can we
> safely remove these #undefs without breaking the arm64 EFI stub?
>

The whole point of this patch is to remove these #undefs on ARM64.
Otherwise we end up calling instrumented memset, which will access to
kasan shadow,
before we set it up
So on ARM64 we should use not-instumented __memset on ARM64, iow we
need to keep #define memset __memset.

> --
> Matt Fleming, Intel Open Source Technology Center
