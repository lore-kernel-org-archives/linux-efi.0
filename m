From: Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi/arm64: store Runtime Services revision
Date: Mon, 13 Oct 2014 19:14:15 +0300
Message-ID: <CAGBcZGe2eYUH5i0P+ffkXABdLGYrBciYQLO6Jwd8kKAWtcBkKg@mail.gmail.com>
References: <1408028122-1784-1-git-send-email-semen.protsenko@linaro.org>
	<20140826090533.GA3193@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140826090533.GA3193-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> I doubt it makes any difference

It really does. The whole reason I made this patch is that I was
unable to call UpdateCapsule() runtime service, because when you try
to call it, kernel code first tests if we have UEFI with certain
Runtime Services revision. In this code
(drivers/firmware/efi/runtime.c):

static efi_status_t virt_efi_update_capsule(efi_capsule_header_t **capsules,
                                            unsigned long count,
                                            unsigned long sg_list)
{
        if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
                return EFI_UNSUPPORTED;

        return efi_call_virt(update_capsule, capsules, count, sg_list);
}

Condition is false, because efi.runtime_version == 0. The same stuff
was happening about some other Runtime Services. So this patch just
fixes this.

> but can we assign this before we call efi_native_runtime_setup please?

Yeah, it's quite late for this as patch is already upstreamed :)
Anyway, if you could explain why it's essential -- I can make another
patch moving this code to correct place.

On 26 August 2014 12:05, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org> wrote:
> On Thu, Aug 14, 2014 at 03:55:22PM +0100, Semen Protsenko wrote:
>> "efi" global data structure contains "runtime_version" field which must
>> be assigned in order to use it later in Runtime Services virtual calls
>> (virt_efi_* functions).
>>
>> Before this patch "runtime_version" was unassigned (0), so each
>> Runtime Service virtual call that checks revision would fail.
>>
>> Runtime Services revision being passed in UEFI system table from UEFI
>> to kernel (see efi_entry() function). In UEFI it's being stored at
>> MdePkg/Include/Uefi/UefiSpec.h as EFI_RUNTIME_SERVICES_REVISION.
>>
>> Signed-off-by: Semen Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  arch/arm64/kernel/efi.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
>> index e72f310..5dbb7bd 100644
>> --- a/arch/arm64/kernel/efi.c
>> +++ b/arch/arm64/kernel/efi.c
>> @@ -463,6 +463,8 @@ static int __init arm64_enter_virtual_mode(void)
>>       efi_native_runtime_setup();
>>       set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
>>
>> +     efi.runtime_version = efi.systab->hdr.revision;
>> +
>>       return 0;
>
> I doubt it makes any difference, but can we assign this before we call
> efi_native_runtime_setup please?
>
> Will
