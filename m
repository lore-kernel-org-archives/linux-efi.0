From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/9] arm64/efi: refactor EFI init and runtime code for
 reuse by 32-bit ARM
Date: Wed, 4 Nov 2015 12:44:19 +0100
Message-ID: <CAKv+Gu-WT0Kw=X-0=r3aKK_Bn8X7q0_=bDNHqPuoR1-FjQqsBQ@mail.gmail.com>
References: <1443719063-6832-1-git-send-email-ard.biesheuvel@linaro.org>
	<1443719063-6832-3-git-send-email-ard.biesheuvel@linaro.org>
	<20151010210037.GG2723@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151010210037.GG2723-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Ryan Harkin <ryan.harkin-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 10 October 2015 at 23:00, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Thu, 01 Oct, at 07:04:16PM, Ard Biesheuvel wrote:
>> This refactors the EFI init and runtime code that will be shared
>> between arm64 and ARM so that it can be built for both archs.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  arch/arm64/include/asm/efi.h       |  16 ++++
>>  arch/arm64/kernel/efi.c            |  51 ++++++++++
>>  drivers/firmware/efi/arm-init.c    |  11 ++-
>>  drivers/firmware/efi/arm-runtime.c | 101 ++++++--------------
>>  drivers/firmware/efi/efi.c         |   4 +-
>>  5 files changed, 105 insertions(+), 78 deletions(-)
>
> [...]
>
>> diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
>> index 56987a5b9033..235677b86e4e 100644
>> --- a/drivers/firmware/efi/arm-init.c
>> +++ b/drivers/firmware/efi/arm-init.c
>> @@ -66,7 +66,7 @@ static int __init uefi_init(void)
>>  {
>>       efi_char16_t *c16;
>>       void *config_tables;
>> -     u64 table_size;
>> +     int table_size;
>>       char vendor[100] = "unknown";
>>       int i, retval;
>
> Perhaps 'table_size' should be unsigned long? At the very least it
> should be size_t, not int.
>

OK, I will change that.

>> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
>> index f5e586bd3b24..2eb31e28a35c 100644
>> --- a/drivers/firmware/efi/efi.c
>> +++ b/drivers/firmware/efi/efi.c
>> @@ -23,6 +23,8 @@
>>  #include <linux/io.h>
>>  #include <linux/platform_device.h>
>>
>> +#include <asm/efi.h>
>> +
>>  struct efi __read_mostly efi = {
>>       .mps                    = EFI_INVALID_TABLE_ADDR,
>>       .acpi                   = EFI_INVALID_TABLE_ADDR,
>
> Hmm... not quite sure why this new include is required?
>

I need this or the file won't build on ARM.

We are currently relying on a transitive include of
<asm/early_ioremap.h>, which does not exist on IA-64. This is a bit of
a kludge, and I am open to better ways of dealing with this.
(IA-64 declares early_ioremap() in asm/io.h, and #define's
early_memremap() as an alias of it) and I am reluctant to include
asm/early_ioremap.h in ARM's asm/io.h (as the other archs do)

-- 
Ard.
