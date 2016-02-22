From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] arm*: efi: drop permanent mapping of the UEFI System table
Date: Mon, 22 Feb 2016 16:56:57 +0100
Message-ID: <CAKv+Gu_pnjL557dE1xez_y2tESOjZj9_2XEbNtm_b4yAA-WdYg@mail.gmail.com>
References: <1456153179-27214-1-git-send-email-ard.biesheuvel@linaro.org>
	<20160222154314.GJ3435@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160222154314.GJ3435@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 22 February 2016 at 16:43, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> On Mon, Feb 22, 2016 at 03:59:39PM +0100, Ard Biesheuvel wrote:
>> The permanent, writable mapping of the UEFI System table is only
>> referenced during invocations of UEFI Runtime Services, at which time
>> the UEFI virtual mapping is available, which also covers the system
>> table (since the runtime services themselves need access to it)
>
> I'm not sure it's strictly true that the runtime services themselves
> need access to the system table. Why would that be necessary? Are
> runtime services mandated to indirect calls via the system table?
>

They don't need access per se, but they are allowed to reference it,
and so the memory remapping layer must make it accessible after
SetVirtualAddressMap(). The spec lists explicitly which fields are
still valid after ExitBootServices()

> I would expect that the EFI system table and EFI runtime services table
> are not in EfiConventionalMemory, but I'm not sure that we have the
> guarnatee that they're both in EfiRuntimeServices* memory..
>

SetVirtualAddressMap() is a runtime service, and one of the things it
does is update the pointers in the system table, hence it must be
located in RuntimeService memory, because anything else may be gone by
this time.

> From the spec, I couldn't find a mandate that the system table (nor the
> runtime services table) were in a region of EfiRuntimeServicesData
> memory. I suspect I'm looking in the wrong place...
>

We should clarify it if it is not clear (or if I turn out to be wrong)

>> So instead of creating this permanent mapping, record the virtual
>> address of the system table inside the UEFI virtual mapping, and
>> use that instead. This protects the contents of the system table
>> from inadvertent (or deliberate) modification.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>
>> Something I spotted while working on the memory attribute table stuff.
>> Since this is low hanging fruit and otherwise completely unrelated to it,
>> I am posting it as a separate patch
>>
>>  drivers/firmware/efi/arm-init.c    |  2 ++
>>  drivers/firmware/efi/arm-runtime.c | 24 ++++++++++----------
>>  2 files changed, 14 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
>> index 022f11157acd..e995d61da747 100644
>> --- a/drivers/firmware/efi/arm-init.c
>> +++ b/drivers/firmware/efi/arm-init.c
>> @@ -85,6 +85,8 @@ static int __init uefi_init(void)
>>                       efi.systab->hdr.revision >> 16,
>>                       efi.systab->hdr.revision & 0xffff);
>>
>> +     efi.runtime_version = efi.systab->hdr.revision;
>> +
>>       /* Show what we know for posterity */
>>       c16 = early_memremap_ro(efi_to_phys(efi.systab->fw_vendor),
>>                               sizeof(vendor) * sizeof(efi_char16_t));
>> diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
>> index 848ede1587dc..6ce13d6b7122 100644
>> --- a/drivers/firmware/efi/arm-runtime.c
>> +++ b/drivers/firmware/efi/arm-runtime.c
>> @@ -64,6 +64,16 @@ static bool __init efi_virtmap_init(void)
>>                               &phys, ret);
>>                       return false;
>>               }
>> +             /*
>> +              * If this entry covers the address of the UEFI system table,
>> +              * calculate and record its virtual address.
>> +              */
>> +             if (efi_system_table >= phys &&
>> +                 efi_system_table < phys + (md->num_pages * EFI_PAGE_SIZE)) {
>> +                     efi.systab = (void *)(efi_system_table - phys +
>> +                                           md->virt_addr);
>> +                     set_bit(EFI_SYSTEM_TABLES, &efi.flags);
>> +             }
>
> It seems very odd to me to set this given it's currently unused, and we
> don't have permanent access to the table. That sounds like we're just
> setting ourselves up for future fragility as users appear.
>

I wondered about the purpose as well. It is only ever set, and never
tested (until this patch)

@Matt: any thoughts?
