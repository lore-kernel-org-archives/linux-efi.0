From: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] efi: add conditional include of asm/early_ioremap.h
Date: Mon, 11 Jan 2016 08:15:42 -0800
Message-ID: <5693D52E.9090407@roeck-us.net>
References: <1452456249-2974-1-git-send-email-ard.biesheuvel@linaro.org>
 <20160111144004.GD2644@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ia64-owner@vger.kernel.org>
In-Reply-To: <20160111144004.GD2644@codeblueprint.co.uk>
Sender: linux-ia64-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Fenghua Yu <fenghua.yu@intel.com>, Tony Luck <tony.luck@intel.com>, linux-ia64@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 01/11/2016 06:40 AM, Matt Fleming wrote:
> (Cc'ing ia64 maintainers)
>
> On Sun, 10 Jan, at 09:04:09PM, Ard Biesheuvel wrote:
>> The code in efi.c uses early_memremap(), but relies on a transitive
>> include rather than including asm/early_ioremap.h directly.
>> Unfortunately, this header does not exist on ia64, so it cannot be
>> included directly.
>>
>> Commit f7d924894265 ("arm64/efi: refactor EFI init and runtime code
>> for reuse by 32-bit ARM") attempted to work around this by including
>> asm/efi.h, which transitively includes asm/early_ioremap.h on most
>> architectures. However, since asm/efi.h does not exist on ia64 either,
>> this is not much of an improvement.
>>
>> So instead, just include asm/early_ioremap.h directly, unless CONFIG_IA64
>> is defined.
>>
>> Fixes: f7d924894265 ("arm64/efi: refactor EFI init and runtime code for reuse by 32-bit ARM")
>> Cc: Will Deacon <will.deacon@arm.com>
>> Reported-by: Guenter Roeck <linux@roeck-us.net>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>>   drivers/firmware/efi/efi.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
>> index cffa89b3317b..53f71177824f 100644
>> --- a/drivers/firmware/efi/efi.c
>> +++ b/drivers/firmware/efi/efi.c
>> @@ -25,7 +25,9 @@
>>   #include <linux/io.h>
>>   #include <linux/platform_device.h>
>>
>> -#include <asm/efi.h>
>> +#ifndef CONFIG_IA64
>> +#include <asm/early_ioremap.h>
>> +#endif
>>
>>   struct efi __read_mostly efi = {
>>   	.mps			= EFI_INVALID_TABLE_ADDR,
>
> I certainly can't think of a better way to fix this right now. Tony,
> Fenghua do you guys have any suggestions?
>

How about including asm/early_ioremap.h from arch/arm/include/asm/io.h,
as it is done by arm64 and x86 ?

Guenter

