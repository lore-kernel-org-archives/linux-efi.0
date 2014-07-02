From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 5/5] efi: efistub: convert into static library
Date: Wed, 2 Jul 2014 13:23:36 +0200
Message-ID: <CAKv+Gu9N_p49603oy0rKaq+G6sX+GS5ueSfJ2B=Yh7DrF301Cg@mail.gmail.com>
References: <1403792617-25792-1-git-send-email-ard.biesheuvel@linaro.org>
	<1403792617-25792-6-git-send-email-ard.biesheuvel@linaro.org>
	<20140702111528.GL7539@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140702111528.GL7539-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 2 July 2014 13:15, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Thu, 26 Jun, at 04:23:37PM, Ard Biesheuvel wrote:
>> This patch changes both x86 and arm64 efistub implementations from #including
>> shared .c files under drivers/firmware/efi to building the shared code as a
>> static library.
>>
>> The x86 code uses a stub built into the boot executable which uncompresses the
>> kernel at boot time. In this case, the library is linked into the decompressor.
>>
>> In the arm64 case, the stub is part of the kernel proper so the library is
>> linked into the kernel proper as well.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>
> OK, this breaks the ia64 build because of the following...
>
> /drivers/firmware/efi/libstub/efi-stub-helper.c:14:21: fatal error: asm/efi.h: No such file or directory
>
>> diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
>> index e1096539eedb..d9abdbc962f1 100644
>> --- a/drivers/firmware/efi/Makefile
>> +++ b/drivers/firmware/efi/Makefile
>> @@ -1,7 +1,7 @@
>>  #
>>  # Makefile for linux kernel
>>  #
>> -obj-$(CONFIG_EFI)                    += efi.o vars.o
>> +obj-$(CONFIG_EFI)                    += efi.o vars.o libstub/
>>  obj-$(CONFIG_EFI_VARS)                       += efivars.o
>>  obj-$(CONFIG_EFI_VARS_PSTORE)                += efi-pstore.o
>>  obj-$(CONFIG_UEFI_CPER)                      += cper.o
>
> I guess what we need is CONFIG_EFI_LIBSTUB selected by both
> CONFIG_EFI_STUB (for x86) and CONFIG_EFI_ARMSTUB (for arm64)? e.g.
>
> obj-$(CONFIG_EFI_LIBSTUB)               libstub/
>

Yes, that seems the appropriate way to deal with this.
Let me respin so I can fix the other thing I mentioned yesterday as well.

-- 
Ard.
