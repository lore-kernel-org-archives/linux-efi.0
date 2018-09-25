From: Chao Fan <fanc.fnst@cn.fujitsu.com>
Subject: Re: [PATCH v7 3/3] x86/boot/KASLR: Limit kaslr to choosing the
 immovable memory
Date: Tue, 25 Sep 2018 09:04:11 +0800
Message-ID: <20180925010411.GA12561@localhost.localdomain>
References: <20180913104629.5179-1-fanc.fnst@cn.fujitsu.com>
 <20180913104629.5179-4-fanc.fnst@cn.fujitsu.com>
 <CAGXu5jK13F7EY--zAVWq-=P2-Lt7n-K05ctL-vH7S=rcWKQoOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGXu5jK13F7EY--zAVWq-=P2-Lt7n-K05ctL-vH7S=rcWKQoOw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: linux-efi <linux-efi@vger.kernel.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Baoquan He <bhe@redhat.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, indou.takao@jp.fujitsu.com, caoj.fnst@cn.fujitsu.com
List-Id: linux-efi@vger.kernel.org

On Sat, Sep 22, 2018 at 08:48:53AM -0700, Kees Cook wrote:
>On Thu, Sep 13, 2018 at 3:46 AM, Chao Fan <fanc.fnst@cn.fujitsu.com> wrote:
>> +#ifdef CONFIG_MEMORY_HOTREMOVE
>> +       /*
>> +        * If immovable memory found, filter the intersection between
>> +        * immovable memory and region to slots_count.
>> +        * Otherwise, go on old code.
>> +        */
>> +       for (i = 0; i < num_immovable_mem; i++) {
>> +               struct mem_vector entry;
>> +               unsigned long long start, end, entry_end, region_end;
>> +
>> +               start = immovable_mem[i].start;
>> +               end = start + immovable_mem[i].size;
>> +               region_end = region->start + region->size;
>> +
>> +               entry.start = clamp(region->start, start, end);
>> +               entry_end = clamp(region_end, start, end);
>> +
>> +               if (entry.start + image_size < entry_end) {
>
>Can this logic be rewritten to use the existing mem_overlaps() check
>instead? I think that would make it much more readable.
>

Sure, I will reuse mem_overlaps() instead of this logical.

>Otherwise, yes, this all looks fine.

Thank you for the review.

Thanks,
Chao Fan

>
>-Kees
>
>> +                       entry.size = entry_end - entry.start;
>> +                       slots_count(&entry, minimum, image_size);
>> +
>> +                       if (slot_area_index == MAX_SLOT_AREA) {
>> +                               debug_putstr("Aborted e820/efi memmap scan (slot_areas full)!\n");
>> +                               return 1;
>> +                       }
>> +               }
>> +       }
>> +       return 0;
>> +#endif
>> +}
>> +
>>  #ifdef CONFIG_EFI
>>  /*
>>   * Returns true if mirror region found (and must have been processed
>> @@ -720,11 +775,8 @@ process_efi_entries(unsigned long minimum, unsigned long image_size)
>>
>>                 region.start = md->phys_addr;
>>                 region.size = md->num_pages << EFI_PAGE_SHIFT;
>> -               process_mem_region(&region, minimum, image_size);
>> -               if (slot_area_index == MAX_SLOT_AREA) {
>> -                       debug_putstr("Aborted EFI scan (slot_areas full)!\n");
>> +               if (process_mem_region(&region, minimum, image_size))
>>                         break;
>> -               }
>>         }
>>         return true;
>>  }
>> @@ -751,11 +803,8 @@ static void process_e820_entries(unsigned long minimum,
>>                         continue;
>>                 region.start = entry->addr;
>>                 region.size = entry->size;
>> -               process_mem_region(&region, minimum, image_size);
>> -               if (slot_area_index == MAX_SLOT_AREA) {
>> -                       debug_putstr("Aborted e820 scan (slot_areas full)!\n");
>> +               if (process_mem_region(&region, minimum, image_size))
>>                         break;
>> -               }
>>         }
>>  }
>>
>> --
>> 2.17.1
>>
>>
>>
>
>
>
>-- 
>Kees Cook
>Pixel Security
>
>
