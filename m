From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH v3 1/5] efi: Export boot-services code and data as
 debugfs-blobs
Date: Tue, 24 Apr 2018 15:11:26 +0200
Message-ID: <3919feeb-cdad-7ce0-4fdf-1bf0004b63b5@redhat.com>
References: <20180408174014.21908-1-hdegoede@redhat.com>
 <20180408174014.21908-2-hdegoede@redhat.com>
 <CAKv+Gu-DZ86y5pmQ+-gQWLHAcs47H-cixCM1pBKmKZXA=+jRmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu-DZ86y5pmQ+-gQWLHAcs47H-cixCM1pBKmKZXA=+jRmg@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Darren Hart <dvhart@infradead.org>, Andy Shevchenko <andy@infradead.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, platform-driver-x86@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Martin Fuzzey <mfuzzey@parkeon.com>, Kees
List-Id: linux-efi@vger.kernel.org

Hi,

On 16-04-18 10:23, Ard Biesheuvel wrote:
> Hallo Hans,
> 
> On 8 April 2018 at 19:40, Hans de Goede <hdegoede@redhat.com> wrote:
>> Sometimes it is useful to be able to dump the efi boot-services code and
>> data. This commit adds these as debugfs-blobs to /sys/kernel/debug/efi,
>> but only if efi=debug is passed on the kernel-commandline as this requires
>> not freeing those memory-regions, which costs 20+ MB of RAM.
>>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>> ---
>> Changes in v2:
>> -Do not call pr_err on debugfs call failures
>> ---
>>   arch/x86/platform/efi/quirks.c |  4 +++
>>   drivers/firmware/efi/efi.c     | 53 ++++++++++++++++++++++++++++++++++
>>   2 files changed, 57 insertions(+)
>>
>> diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
>> index 5b513ccffde4..0f968c7bcfec 100644
>> --- a/arch/x86/platform/efi/quirks.c
>> +++ b/arch/x86/platform/efi/quirks.c
>> @@ -374,6 +374,10 @@ void __init efi_free_boot_services(void)
>>          int num_entries = 0;
>>          void *new, *new_md;
>>
>> +       /* Keep all regions for /sys/kernel/debug/efi */
>> +       if (efi_enabled(EFI_DBG))
>> +               return;
>> +
>>          for_each_efi_memory_desc(md) {
>>                  unsigned long long start = md->phys_addr;
>>                  unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
>> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
>> index cd42f66a7c85..10c896e8b82b 100644
>> --- a/drivers/firmware/efi/efi.c
>> +++ b/drivers/firmware/efi/efi.c
>> @@ -18,6 +18,7 @@
>>   #include <linux/kobject.h>
>>   #include <linux/module.h>
>>   #include <linux/init.h>
>> +#include <linux/debugfs.h>
>>   #include <linux/device.h>
>>   #include <linux/efi.h>
>>   #include <linux/of.h>
>> @@ -316,6 +317,55 @@ static __init int efivar_ssdt_load(void)
>>   static inline int efivar_ssdt_load(void) { return 0; }
>>   #endif
>>
>> +#ifdef CONFIG_DEBUG_FS
>> +
>> +#define EFI_DEBUGFS_MAX_BLOBS 32
>> +
>> +static struct debugfs_blob_wrapper debugfs_blob[EFI_DEBUGFS_MAX_BLOBS];
>> +
>> +static void __init efi_debugfs_init(void)
>> +{
>> +       struct dentry *efi_debugfs;
>> +       efi_memory_desc_t *md;
>> +       char name[32];
>> +       int type_count[EFI_BOOT_SERVICES_DATA + 1] = {};
>> +       int i = 0;
>> +
>> +       efi_debugfs = debugfs_create_dir("efi", NULL);
>> +       if (IS_ERR_OR_NULL(efi_debugfs))
>> +               return;
>> +
>> +       for_each_efi_memory_desc(md) {
>> +               switch (md->type) {
>> +               case EFI_BOOT_SERVICES_CODE:
>> +                       snprintf(name, sizeof(name), "boot_services_code%d",
>> +                                type_count[md->type]++);
>> +                       break;
>> +               case EFI_BOOT_SERVICES_DATA:
>> +                       snprintf(name, sizeof(name), "boot_services_data%d",
>> +                                type_count[md->type]++);
>> +                       break;
>> +               default:
>> +                       continue;
>> +               }
>> +
>> +               debugfs_blob[i].size = md->num_pages << EFI_PAGE_SHIFT;
>> +               debugfs_blob[i].data = memremap(md->phys_addr,
>> +                                               debugfs_blob[i].size,
>> +                                               MEMREMAP_WB);
>> +               if (!debugfs_blob[i].data)
>> +                       continue;
>> +
>> +               debugfs_create_blob(name, 0400, efi_debugfs, &debugfs_blob[i]);
>> +               i++;
>> +               if (i == EFI_DEBUGFS_MAX_BLOBS)
>> +                       break;
>> +       }
>> +}
>> +#else
>> +static inline void efi_debugfs_init(void) {}
>> +#endif
>> +
>>   /*
>>    * We register the efi subsystem with the firmware subsystem and the
>>    * efivars subsystem with the efi subsystem, if the system was booted with
>> @@ -360,6 +410,9 @@ static int __init efisubsys_init(void)
>>                  goto err_remove_group;
>>          }
>>
>> +       if (efi_enabled(EFI_DBG))
>> +               efi_debugfs_init();
>> +
> 
> This doesn't really make any sense on non-x86. The boot services
> regions are released to the kernel for general allocation, and so
> exposing them this way only makes sense if you keep them as you do for
> x86.
> 
> Could you please try to make this call specific to situations where it
> makes sense? I don't mind allocating a new EFI_xxx flag for preserving
> the boot services regions so we could decide to set it for ARM/arm64
> as well in certain cases in the future.

Ok, I've added a new EFI_BOOT_SERVICES flag for this for v4 of this
patchset, mirroring the existing EFI_RUNTIME_SERVICES flag in naming.

Regards,

Hans
