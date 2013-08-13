From: Roy Franz <roy.franz@linaro.org>
Subject: Re: [PATCH 16/16] Add config EFI_STUB for ARM to Kconfig
Date: Tue, 13 Aug 2013 10:37:13 -0700
Message-ID: <CAFECyb8m=5kExhusmepcebyUyBN5R9f7Kjah8NzXJ26Pmo=MNA@mail.gmail.com>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
	<1376090777-20090-17-git-send-email-roy.franz@linaro.org>
	<20130813131857.GE2823@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130813131857.GE2823@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Martin <Dave.Martin@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, matt.fleming@intel.com, Russell King - ARM Linux <linux@arm.linux.org.uk>, Leif Lindholm <leif.lindholm@linaro.org>, Mark Salter <msalter@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Aug 13, 2013 at 6:18 AM, Dave Martin <Dave.Martin@arm.com> wrote:
> On Fri, Aug 09, 2013 at 04:26:17PM -0700, Roy Franz wrote:
>> Signed-off-by: Roy Franz <roy.franz@linaro.org>
>> ---
>>  arch/arm/Kconfig |   11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>
>> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
>> index 43594d5..8607d03 100644
>> --- a/arch/arm/Kconfig
>> +++ b/arch/arm/Kconfig
>> @@ -1805,6 +1805,17 @@ config UACCESS_WITH_MEMCPY
>>         However, if the CPU data cache is using a write-allocate mode,
>>         this option is unlikely to provide any performance gain.
>>
>> +config EFI_STUB
>> +     bool "EFI stub support"
>> +     depends on EFI
>
> && !CPU_BIG_ENDIAN, in case you didn't get around to that.
>
> Sooner or later, someone may try to fix that, so there should be a
> comment somewhere explaining what is broken for BE.
>
> Either in efi-stub.c or in the commit message accompanying this patch, I
> guess.
>
EFI will be !CPU_BIG_ENDIAN, so we will get the dependency
transitively through EFI.
That said, I think it may be better to have both be explicitly
!CPU_BIG_ENDIAN, as even
though the underlying reasons are the same (EFI services calls being
little endian), both
the stub and runtime services would need to be fixed to enable the
stub to run in BE mode.
I'll make this explicit in the stub Kconfig, and add a comment by the
PE/COFF magic number
regarding the LE requirement.

Thanks,
Roy




> Cheers
> ---Dave
>
>> +     ---help---
>> +       This kernel feature allows a zImage to be loaded directly
>> +       by EFI firmware without the use of a bootloader.  A PE/COFF
>> +       header is added to the zImage in a way that makes the binary
>> +       both a Linux zImage and an PE/COFF executable that can be
>> +       executed directly by EFI firmware.
>> +       See Documentation/efi-stub.txt for more information.
>> +
>>  config SECCOMP
>>       bool
>>       prompt "Enable seccomp to safely compute untrusted bytecode"
>> --
>> 1.7.10.4
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
