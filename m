From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v9 2/2] x86/boot/KASLR: Restrict kernel to be randomized
 in mirror regions
Date: Fri, 18 Aug 2017 16:10:40 +0100
Message-ID: <CAKv+Gu-dXN4m1TFjKZ1DKvMG4snR=0WPt98wj2X=gDv4dd4qAw@mail.gmail.com>
References: <1502722464-20614-1-git-send-email-bhe@redhat.com>
 <1502722464-20614-3-git-send-email-bhe@redhat.com> <20170817130405.GE20203@x1>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170817130405.GE20203@x1>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, fanc.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 17 August 2017 at 14:04, Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 08/14/17 at 10:54pm, Baoquan He wrote:
>> Currently KASLR will parse all e820 entries of RAM type and add all
>> candidate position into slots array. Then we will choose one slot
>> randomly as the new position which kernel will be decompressed into
>> and run at.
>>
>> On system with EFI enabled, e820 memory regions are coming from EFI
>> memory regions by combining adjacent regions. While these EFI memory
>> regions have more attributes to mark their different use. Mirror
>> attribute is such kind. The physical memory region whose descriptors
>> in EFI memory map has EFI_MEMORY_MORE_RELIABLE attribute (bit: 16) are
>> mirrored. The address range mirroring feature of kernel arranges such
>> mirror region into normal zone and other region into movable zone. And
>> with mirroring feature enabled, the code and date of kernel can only be
>> located in more reliable mirror region. However, the current KASLR code
>> doesn't check EFI memory entries, and could choose new position in
>> non-mirrored region. This will break the functionality of the address
>> range mirroring feature.
>
> Thanks a lot for helping improving the patch log, Ingo! Will pay more
> attention to the description in words and paragraph partition of log.
>
>>
>> So if EFI is detected, iterate EFI memory map and pick the mirror region
>> to process for adding candidate of randomization slot. If EFI is disabled
>> or no mirror region found, still process e820 memory map.
>>
>> Signed-off-by: Baoquan He <bhe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


Could the x86 people on cc either take these directly, or indicate
whether they are ok with this going in via the EFI tree?

Thanks.

>> ---
>>  arch/x86/boot/compressed/kaslr.c | 68 ++++++++++++++++++++++++++++++++++++++--
>>  1 file changed, 66 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
>> index 99c7194f7ea6..7de23bb279ce 100644
>> --- a/arch/x86/boot/compressed/kaslr.c
>> +++ b/arch/x86/boot/compressed/kaslr.c
>> @@ -37,7 +37,9 @@
>>  #include <linux/uts.h>
>>  #include <linux/utsname.h>
>>  #include <linux/ctype.h>
>> +#include <linux/efi.h>
>>  #include <generated/utsrelease.h>
>> +#include <asm/efi.h>
>>
>>  /* Macros used by the included decompressor code below. */
>>  #define STATIC
>> @@ -558,6 +560,65 @@ static void process_mem_region(struct mem_vector *entry,
>>       }
>>  }
>>
>> +#ifdef CONFIG_EFI
>> +/*
>> + * Returns true if mirror region found (and must have been processed
>> + * for slots adding)
>> + */
>> +static bool
>> +process_efi_entries(unsigned long minimum, unsigned long image_size)
>> +{
>> +     struct efi_info *e = &boot_params->efi_info;
>> +     bool efi_mirror_found = false;
>> +     struct mem_vector region;
>> +     efi_memory_desc_t *md;
>> +     unsigned long pmap;
>> +     char *signature;
>> +     u32 nr_desc;
>> +     int i;
>> +
>> +     signature = (char *)&e->efi_loader_signature;
>> +     if (strncmp(signature, EFI32_LOADER_SIGNATURE, 4) &&
>> +         strncmp(signature, EFI64_LOADER_SIGNATURE, 4))
>> +             return false;
>> +
>> +#ifdef CONFIG_X86_32
>> +     /* Can't handle data above 4GB at this time */
>> +     if (e->efi_memmap_hi) {
>> +             warn("EFI memmap is above 4GB, can't be handled now on x86_32. EFI should be disabled.\n");
>> +             return false;
>> +     }
>> +     pmap =  e->efi_memmap;
>> +#else
>> +     pmap = (e->efi_memmap | ((__u64)e->efi_memmap_hi << 32));
>> +#endif
>> +
>> +     nr_desc = e->efi_memmap_size / e->efi_memdesc_size;
>> +     for (i = 0; i < nr_desc; i++) {
>> +             md = efi_early_memdesc_ptr(pmap, e->efi_memdesc_size, i);
>> +             if (md->attribute & EFI_MEMORY_MORE_RELIABLE) {
>> +                     region.start = md->phys_addr;
>> +                     region.size = md->num_pages << EFI_PAGE_SHIFT;
>> +                     process_mem_region(&region, minimum, image_size);
>> +                     efi_mirror_found = true;
>> +
>> +                     if (slot_area_index == MAX_SLOT_AREA) {
>> +                             debug_putstr("Aborted EFI scan (slot_areas full)!\n");
>> +                             break;
>> +                     }
>> +             }
>> +     }
>> +
>> +     return efi_mirror_found;
>> +}
>> +#else
>> +static inline bool
>> +process_efi_entries(unsigned long minimum, unsigned long image_size)
>> +{
>> +     return false;
>> +}
>> +#endif
>> +
>>  static void process_e820_entries(unsigned long minimum,
>>                                unsigned long image_size)
>>  {
>> @@ -586,13 +647,16 @@ static unsigned long find_random_phys_addr(unsigned long minimum,
>>  {
>>       /* Check if we had too many memmaps. */
>>       if (memmap_too_large) {
>> -             debug_putstr("Aborted e820 scan (more than 4 memmap= args)!\n");
>> +             debug_putstr("Aborted memory entries scan (more than 4 memmap= args)!\n");
>>               return 0;
>>       }
>>
>>       /* Make sure minimum is aligned. */
>>       minimum = ALIGN(minimum, CONFIG_PHYSICAL_ALIGN);
>>
>> +     if (process_efi_entries(minimum, image_size))
>> +             return slots_fetch_random();
>> +
>>       process_e820_entries(minimum, image_size);
>>       return slots_fetch_random();
>>  }
>> @@ -652,7 +716,7 @@ void choose_random_location(unsigned long input,
>>        */
>>       min_addr = min(*output, 512UL << 20);
>>
>> -     /* Walk e820 and find a random address. */
>> +     /* Walk available memory entries to find a random address. */
>>       random_addr = find_random_phys_addr(min_addr, output_size);
>>       if (!random_addr) {
>>               warn("Physical KASLR disabled: no suitable memory region!");
>> --
>> 2.5.5
>>
