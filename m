From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/9] arm64/efi: split off EFI init and runtime code for
 reuse by 32-bit ARM
Date: Mon, 12 Oct 2015 09:57:40 +0200
Message-ID: <CAKv+Gu8ESCXWnzz-7T9YGCn_cBT_Knx7u17P0uky31mU22j1EA@mail.gmail.com>
References: <1443719063-6832-1-git-send-email-ard.biesheuvel@linaro.org>
	<1443719063-6832-2-git-send-email-ard.biesheuvel@linaro.org>
	<20151010205311.GF2723@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151010205311.GF2723-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Ryan Harkin <ryan.harkin-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 10 October 2015 at 22:53, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Thu, 01 Oct, at 07:04:15PM, Ard Biesheuvel wrote:
>> This splits off the early EFI init and runtime code that
>> - discovers the EFI params and the memory map from the FDT, and installs
>>   the memblocks and config tables.
>> - prepares and installs the EFI page tables so that UEFI Runtime Services
>>   can be invoked at the virtual address installed by the stub.
>>
>> This will allow it to be reused for 32-bit ARM.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  arch/arm64/kernel/efi.c            | 363 +-------------------
>>  drivers/firmware/efi/Makefile      |   4 +-
>>  drivers/firmware/efi/arm-init.c    | 214 ++++++++++++
>>  drivers/firmware/efi/arm-runtime.c | 191 ++++++++++
>>  4 files changed, 409 insertions(+), 363 deletions(-)
>
> [...]
>
>> +static int uefi_debug __initdata;
>> +static int __init uefi_debug_setup(char *str)
>> +{
>> +     uefi_debug = 1;
>> +
>> +     return 0;
>> +}
>> +early_param("uefi_debug", uefi_debug_setup);
>
> Was this hunk an unintentional reintroduction of the code Leif deleted
> in commit a9cc0cf5701b ("arm64: Use core efi=debug instead of
> uefi_debug command line parameter")?
>

Indeed. I will get rid of it on v2
