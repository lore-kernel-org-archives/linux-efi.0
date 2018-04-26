From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH v4 1/5] efi: Export boot-services code and data as
 debugfs-blobs
Date: Thu, 26 Apr 2018 23:02:39 +0200
Message-ID: <d587af46-72cb-8fc7-8432-36473b67de47@redhat.com>
References: <20180426120637.21258-1-hdegoede@redhat.com>
 <20180426120637.21258-2-hdegoede@redhat.com>
 <CAKv+Gu9sx_TnSvxdO9eGLCqsQufKW6z9p0K8nYWF_KuDBuUwag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu9sx_TnSvxdO9eGLCqsQufKW6z9p0K8nYWF_KuDBuUwag@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Martin Fuzzey <mfuzzey@parkeon.com>, Kalle Valo <kvalo@codeaurora.org>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Linus Torvalds <torvalds@linux-foundation.org>, Nicolas Broeking <nbroeking@me.com>, Bjorn
List-Id: linux-efi@vger.kernel.org

Hi,

On 26-04-18 18:51, Ard Biesheuvel wrote:
> On 26 April 2018 at 14:06, Hans de Goede <hdegoede@redhat.com> wrote:
>> Sometimes it is useful to be able to dump the efi boot-services code and
>> data. This commit adds these as debugfs-blobs to /sys/kernel/debug/efi,
>> but only if efi=debug is passed on the kernel-commandline as this requires
>> not freeing those memory-regions, which costs 20+ MB of RAM.
>>
>> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>> Changes in v4:
>> -Add new EFI_BOOT_SERVICES flag and use it to determine if the boot-services
>>   memory segments are available (and thus if it makes sense to register the
>>   debugfs bits for them)
>>
>> Changes in v2:
>> -Do not call pr_err on debugfs call failures
>> ---
>>   arch/x86/platform/efi/efi.c    |  1 +
>>   arch/x86/platform/efi/quirks.c |  4 +++
>>   drivers/firmware/efi/efi.c     | 53 ++++++++++++++++++++++++++++++++++
>>   include/linux/efi.h            |  1 +
>>   4 files changed, 59 insertions(+)
>>
>> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
>> index 9061babfbc83..568b7ee3d323 100644
>> --- a/arch/x86/platform/efi/efi.c
>> +++ b/arch/x86/platform/efi/efi.c
>> @@ -208,6 +208,7 @@ int __init efi_memblock_x86_reserve_range(void)
>>               efi.memmap.desc_version);
>>
>>          memblock_reserve(pmap, efi.memmap.nr_map * efi.memmap.desc_size);
>> +       set_bit(EFI_BOOT_SERVICES, &efi.flags);
>>
> 
> I think it would be better if the flag conveys whether boot services
> regions are being preserved, because they will always exist when
> EFI_BOOT is set.
> The name should then reflect that as well, e.g., EFI_PRESERVE_BS_REGIONS.

Ok, I will rename the flag to EFI_PRESERVE_BS_REGIONS for v5
(I'm going to wait a bit with sending out v5 to give others a change
  to comment on v4).

>>          return 0;
>>   }
>> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
>> index 36c1f8b9f7e0..16bdb9e3b343 100644
>> --- a/arch/x86/platform/efi/quirks.c
>> +++ b/arch/x86/platform/efi/quirks.c
>> @@ -376,6 +376,10 @@ void __init efi_free_boot_services(void)
>>          int num_entries = 0;
>>          void *new, *new_md;
>>
>> +       /* Keep all regions for /sys/kernel/debug/efi */
>> +       if (efi_enabled(EFI_DBG))
>> +               return;
>> +
> 
> Why is this only necessary when EFI_DBG is enabled? How are you
> ensuring that the firmware is still in memory when the subsequent
> patches start relying on that?

The 2nd patch in this series makes init/main.c call
efi_check_for_embedded_firmwares() before efi_free_boot_services(),
efi_check_for_embedded_firmwares() then walks the dmi_system_id-s
"registered" (its a static list) by drivers and if their is a dmi_match
searches for the firmware described by the dmi_system_id.driver_data
ptr. If a firmware gets found it gets memdup-ed, so that we do not
have to keep all of the boot-services code around.

Regards,

Hans
