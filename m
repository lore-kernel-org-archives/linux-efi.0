From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] efi/libstub: arm: support building with clang
Date: Tue, 21 Aug 2018 15:34:53 +0200
Message-ID: <CAKv+Gu_3ePOs=Ng-vjD4_LE5vF_wCXZ74c7anQ=6fnYvj-vQng@mail.gmail.com>
References: <20180809164042.210675-1-astrachan@google.com> <32f5ce9b26a386e81857afcd7d135bad@agner.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <32f5ce9b26a386e81857afcd7d135bad@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
To: Stefan Agner <stefan@agner.ch>
Cc: Alistair Strachan <astrachan@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Russell King <linux@armlinux.org.uk>, linux-efi <linux-efi@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On 11 August 2018 at 10:49, Stefan Agner <stefan@agner.ch> wrote:
> On 09.08.2018 18:40, Alistair Strachan wrote:
>> When building with CONFIG_EFI and CONFIG_EFI_STUB on ARM, the libstub
>> Makefile would use -mno-single-pic-base without checking it was
>> supported by the compiler. As the ARM (32-bit) clang backend does not
>> support this flag, the build would fail.
>>
>> This changes the Makefile to check the compiler's support for
>> -mno-single-pic-base before using it, similar to c1c386681bd7 ("ARM:
>> 8767/1: add support for building ARM kernel with clang").
>
> Looks good to me:
>
> Reviewed-by: Stefan Agner <stefan@agner.ch>
>


Thanks. I will queue this after the merge window closes

>>
>> Cc: Stefan Agner <stefan@agner.ch>
>> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Russell King <linux@armlinux.org.uk>
>> Cc: linux-efi@vger.kernel.org
>> Cc: linux-arm-kernel@lists.infradead.org
>> Signed-off-by: Alistair Strachan <astrachan@google.com>
>> ---
>>  drivers/firmware/efi/libstub/Makefile | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/firmware/efi/libstub/Makefile
>> b/drivers/firmware/efi/libstub/Makefile
>> index a34e9290a699..91339d13f2a1 100644
>> --- a/drivers/firmware/efi/libstub/Makefile
>> +++ b/drivers/firmware/efi/libstub/Makefile
>> @@ -13,7 +13,8 @@ cflags-$(CONFIG_X86)                += -m$(BITS) -D__KERNEL__ -O2 \
>>
>>  cflags-$(CONFIG_ARM64)               := $(subst -pg,,$(KBUILD_CFLAGS)) -fpie
>>  cflags-$(CONFIG_ARM)         := $(subst -pg,,$(KBUILD_CFLAGS)) \
>> -                                -fno-builtin -fpic -mno-single-pic-base
>> +                                -fno-builtin -fpic \
>> +                                $(call cc-option,-mno-single-pic-base)
>>
>>  cflags-$(CONFIG_EFI_ARMSTUB) += -I$(srctree)/scripts/dtc/libfdt
