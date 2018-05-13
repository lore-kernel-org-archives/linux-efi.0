From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v5 2/5] efi: Add embedded peripheral firmware support
Date: Sun, 13 May 2018 13:43:08 +0200
Message-ID: <CAKv+Gu-tEtnXrA=guuW=JtX=LcN8kme6MB1esBQP122559ye7Q@mail.gmail.com>
References: <20180429093558.5411-1-hdegoede@redhat.com> <20180429093558.5411-3-hdegoede@redhat.com>
 <CAKv+Gu-+4weyNzExQPF75+WNUwQbbwd2mVk0mL1zH96Q16Sf6w@mail.gmail.com> <7bc779ac-864c-cf43-dda7-bd9705f76be6@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7bc779ac-864c-cf43-dda7-bd9705f76be6@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Martin Fuzzey <mfuzzey@parkeon.com>, Kalle Valo <kvalo@codeaurora.org>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Linus Torvalds <torvalds@linux-foundation.org>, Nicolas Broeking <nbroeking@me.com>, Bjorn
List-Id: linux-efi@vger.kernel.org

On 13 May 2018 at 13:03, Hans de Goede <hdegoede@redhat.com> wrote:
> Hi,
>
>
> On 05/04/2018 06:56 AM, Ard Biesheuvel wrote:
>>
>> Hi Hans,
>>
>> One comment below, which I missed in review before.
>>
>> On 29 April 2018 at 11:35, Hans de Goede <hdegoede@redhat.com> wrote:
>>>
>>> Just like with PCI options ROMs, which we save in the setup_efi_pci*
>>> functions from arch/x86/boot/compressed/eboot.c, the EFI code / ROM
>>> itself
>>> sometimes may contain data which is useful/necessary for peripheral
>>> drivers
>>> to have access to.
>>>
>>> Specifically the EFI code may contain an embedded copy of firmware which
>>> needs to be (re)loaded into the peripheral. Normally such firmware would
>>> be
>>> part of linux-firmware, but in some cases this is not feasible, for 2
>>> reasons:
>>>
>>> 1) The firmware is customized for a specific use-case of the chipset /
>>> use
>>> with a specific hardware model, so we cannot have a single firmware file
>>> for the chipset. E.g. touchscreen controller firmwares are compiled
>>> specifically for the hardware model they are used with, as they are
>>> calibrated for a specific model digitizer.
>>>
>>> 2) Despite repeated attempts we have failed to get permission to
>>> redistribute the firmware. This is especially a problem with customized
>>> firmwares, these get created by the chip vendor for a specific ODM and
>>> the
>>> copyright may partially belong with the ODM, so the chip vendor cannot
>>> give a blanket permission to distribute these.
>>>
>>> This commit adds support for finding peripheral firmware embedded in the
>>> EFI code and making this available to peripheral drivers through the
>>> standard firmware loading mechanism.
>>>
>>> Note we check the EFI_BOOT_SERVICES_CODE for embedded firmware near the
>>> end
>>> of start_kernel(), just before calling rest_init(), this is on purpose
>>> because the typical EFI_BOOT_SERVICES_CODE memory-segment is too large
>>> for
>>> early_memremap(), so the check must be done after mm_init(). This relies
>>> on EFI_BOOT_SERVICES_CODE not being free-ed until
>>> efi_free_boot_services()
>>> is called, which means that this will only work on x86 for now.
>>>
>>> Reported-by: Dave Olsthoorn <dave@bewaar.me>
>>> Suggested-by: Peter Jones <pjones@redhat.com>
>>> Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>>> ---
>>
>> [...]
>>>
>>> diff --git a/drivers/firmware/efi/embedded-firmware.c
>>> b/drivers/firmware/efi/embedded-firmware.c
>>> new file mode 100644
>>> index 000000000000..22a0f598b53d
>>> --- /dev/null
>>> +++ b/drivers/firmware/efi/embedded-firmware.c
>>> @@ -0,0 +1,149 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/*
>>> + * Support for extracting embedded firmware for peripherals from EFI
>>> code,
>>> + *
>>> + * Copyright (c) 2018 Hans de Goede <hdegoede@redhat.com>
>>> + */
>>> +
>>> +#include <linux/crc32.h>
>>> +#include <linux/dmi.h>
>>> +#include <linux/efi.h>
>>> +#include <linux/efi_embedded_fw.h>
>>> +#include <linux/io.h>
>>> +#include <linux/types.h>
>>> +#include <linux/vmalloc.h>
>>> +
>>> +struct embedded_fw {
>>> +       struct list_head list;
>>> +       const char *name;
>>> +       void *data;
>>> +       size_t length;
>>> +};
>>> +
>>> +static LIST_HEAD(found_fw_list);
>>> +
>>> +static const struct dmi_system_id * const embedded_fw_table[] = {
>>> +       NULL
>>> +};
>>> +
>>> +/*
>>> + * Note the efi_check_for_embedded_firmwares() code currently makes the
>>> + * following 2 assumptions. This may needs to be revisited if embedded
>>> firmware
>>> + * is found where this is not true:
>>> + * 1) The firmware is only found in EFI_BOOT_SERVICES_CODE memory
>>> segments
>>> + * 2) The firmware always starts at an offset which is a multiple of 8
>>> bytes
>>> + */
>>> +static int __init efi_check_md_for_embedded_firmware(
>>> +       efi_memory_desc_t *md, const struct efi_embedded_fw_desc *desc)
>>> +{
>>> +       struct embedded_fw *fw;
>>> +       u64 i, size;
>>> +       u32 crc;
>>> +       u8 *mem;
>>> +
>>> +       size = md->num_pages << EFI_PAGE_SHIFT;
>>> +       mem = memremap(md->phys_addr, size, MEMREMAP_WB);
>>> +       if (!mem) {
>>> +               pr_err("Error mapping EFI mem at %#llx\n",
>>> md->phys_addr);
>>> +               return -ENOMEM;
>>> +       }
>>> +
>>> +       size -= desc->length;
>>> +       for (i = 0; i < size; i += 8) {
>>> +               if (*((u64 *)(mem + i)) != *((u64 *)desc->prefix))
>>> +                       continue;
>>> +
>>
>>
>> Please use the proper APIs here to cast u8* to u64*, i.e., either use
>> get_unaligned64() or use memcmp()
>
>
> But we know the memory addresses are 64 bit aligned, so using
> get_unaligned64 seems wrong, and I'm not sure if the compiler is
> smart enough to optimize a memcmp to the single 64 bit integer comparison
> we want done here.
>

Fair enough. The memory regions are indeed guaranteed to be 4k aligned.

So in that case, please make mem a u64* and cast the other way where needed.

>>
>>> +               /* Seed with ~0, invert to match crc32 userspace utility
>>> */
>>> +               crc = ~crc32(~0, mem + i, desc->length);
>>> +               if (crc == desc->crc)
>>> +                       break;
>>> +       }
>>> +
>>> +       memunmap(mem);
>>> +
>>> +       if (i >= size)
>>> +               return -ENOENT;
>>> +
>>> +       pr_info("Found EFI embedded fw '%s' crc %08x\n", desc->name,
>>> desc->crc);
>>> +
>>> +       fw = kmalloc(sizeof(*fw), GFP_KERNEL);
>>> +       if (!fw)
>>> +               return -ENOMEM;
>>> +
>>> +       mem = memremap(md->phys_addr + i, desc->length, MEMREMAP_WB);
>>> +       if (!mem) {
>>> +               pr_err("Error mapping embedded firmware\n");
>>> +               goto error_free_fw;
>>> +       }
>>> +       fw->data = kmemdup(mem, desc->length, GFP_KERNEL);
>>> +       memunmap(mem);
>>> +       if (!fw->data)
>>> +               goto error_free_fw;
>>> +
>>> +       fw->name = desc->name;
>>> +       fw->length = desc->length;
>>> +       list_add(&fw->list, &found_fw_list);
>>> +
>>> +       return 0;
>>> +
>>> +error_free_fw:
>>> +       kfree(fw);
>>> +       return -ENOMEM;
>>> +}
>>> +
>>> +void __init efi_check_for_embedded_firmwares(void)
>>> +{
>>> +       const struct efi_embedded_fw_desc *fw_desc;
>>> +       const struct dmi_system_id *dmi_id;
>>> +       efi_memory_desc_t *md;
>>> +       int i, r;
>>> +
>>> +       for (i = 0; embedded_fw_table[i]; i++) {
>>> +               dmi_id = dmi_first_match(embedded_fw_table[i]);
>>> +               if (!dmi_id)
>>> +                       continue;
>>> +
>>> +               fw_desc = dmi_id->driver_data;
>>> +               for_each_efi_memory_desc(md) {
>>> +                       if (md->type != EFI_BOOT_SERVICES_CODE)
>>> +                               continue;
>>> +
>>> +                       r = efi_check_md_for_embedded_firmware(md,
>>> fw_desc);
>>> +                       if (r == 0)
>>> +                               break;
>>> +               }
>>> +       }
>>> +}
>>> +
>>> +int efi_get_embedded_fw(const char *name, void **data, size_t *size,
>>> +                       size_t msize)
>>> +{
>>> +       struct embedded_fw *iter, *fw = NULL;
>>> +       void *buf = *data;
>>> +
>>> +       list_for_each_entry(iter, &found_fw_list, list) {
>>> +               if (strcmp(name, iter->name) == 0) {
>>> +                       fw = iter;
>>> +                       break;
>>> +               }
>>> +       }
>>> +
>>> +       if (!fw)
>>> +               return -ENOENT;
>>> +
>>> +       if (msize && msize < fw->length)
>>> +               return -EFBIG;
>>> +
>>> +       if (!buf) {
>>> +               buf = vmalloc(fw->length);
>>> +               if (!buf)
>>> +                       return -ENOMEM;
>>> +       }
>>> +
>>> +       memcpy(buf, fw->data, fw->length);
>>> +       *size = fw->length;
>>> +       *data = buf;
>>> +
>>> +       return 0;
>>> +}
>>> +EXPORT_SYMBOL_GPL(efi_get_embedded_fw);
>>> diff --git a/include/linux/efi.h b/include/linux/efi.h
>>> index 791088360c1e..23e8a9c26ce2 100644
>>> --- a/include/linux/efi.h
>>> +++ b/include/linux/efi.h
>>> @@ -1575,6 +1575,12 @@ static inline void
>>>   efi_enable_reset_attack_mitigation(efi_system_table_t *sys_table_arg) {
>>> }
>>>   #endif
>>>
>>> +#ifdef CONFIG_EFI_EMBEDDED_FIRMWARE
>>> +void efi_check_for_embedded_firmwares(void);
>>> +#else
>>> +static inline void efi_check_for_embedded_firmwares(void) { }
>>> +#endif
>>> +
>>>   void efi_retrieve_tpm2_eventlog(efi_system_table_t *sys_table);
>>>
>>>   /*
>>> diff --git a/include/linux/efi_embedded_fw.h
>>> b/include/linux/efi_embedded_fw.h
>>> new file mode 100644
>>> index 000000000000..0f7d4df3f57a
>>> --- /dev/null
>>> +++ b/include/linux/efi_embedded_fw.h
>>> @@ -0,0 +1,25 @@
>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>> +#ifndef _LINUX_EFI_EMBEDDED_FW_H
>>> +#define _LINUX_EFI_EMBEDDED_FW_H
>>> +
>>> +#include <linux/mod_devicetable.h>
>>> +
>>> +/**
>>> + * struct efi_embedded_fw_desc - This struct is used by the EFI
>>> embedded-fw
>>> + *                               code to search for embedded firmwares.
>>> + *
>>> + * @name:   Name to register the firmware with if found
>>> + * @prefix: First 8 bytes of the firmware
>>> + * @length: Length of the firmware in bytes including prefix
>>> + * @crc:    Inverted little endian Ethernet style CRC32, with 0xffffffff
>>> seed
>>> + */
>>> +struct efi_embedded_fw_desc {
>>> +       const char *name;
>>> +       u8 prefix[8];
>>> +       u32 length;
>>> +       u32 crc;
>>> +};
>>> +
>>> +int efi_get_embedded_fw(const char *name, void **dat, size_t *sz, size_t
>>> msize);
>>> +
>>> +#endif
>>> diff --git a/init/main.c b/init/main.c
>>> index b795aa341a3a..ab29775b35db 100644
>>> --- a/init/main.c
>>> +++ b/init/main.c
>>> @@ -729,6 +729,9 @@ asmlinkage __visible void __init start_kernel(void)
>>>          arch_post_acpi_subsys_init();
>>>          sfi_init_late();
>>>
>>> +       if (efi_enabled(EFI_PRESERVE_BS_REGIONS))
>>> +               efi_check_for_embedded_firmwares();
>>> +
>>>          if (efi_enabled(EFI_RUNTIME_SERVICES)) {
>>>                  efi_free_boot_services();
>>>          }
>>> --
>>> 2.17.0
>>>
>
