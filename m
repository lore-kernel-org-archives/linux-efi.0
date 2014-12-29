From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/8] arm64: improved memory map handling for /dev/mem,
 ACPI etc
Date: Mon, 29 Dec 2014 09:22:19 +0000
Message-ID: <CAKv+Gu_1VCJK7y5U9H-mhjjN6AFW8+SGvbKUZfuzx6qGEpVg0A@mail.gmail.com>
References: <1419275322-29811-1-git-send-email-ard.biesheuvel@linaro.org>
	<20141226093528.GA26133@darkstar.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141226093528.GA26133-4/PLUo9XfK/1wF9wiOj0lkEOCMrvLtNR@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 26 December 2014 at 09:35, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On 12/22/14 at 07:08pm, Ard Biesheuvel wrote:
>> This series was split off from the UEFI virtmap for kexec series that I posted
>> earlier today. The main purpose is to deal with the need to classify memory
>> ranges as RAM or non-RAM in a consistent and comprehensive manner. This series
>> applies on top of the other series.
>>
>> Patch #1 avoids an early panic if the UEFI memory map is available but UEFI
>> support itself fails to initialize. In this case, there is no need to panic
>> early, and we have a better chance of being able to inform the user if we deal
>> with this error condition at a later time.
>>
>> Patch #2 adds iomem resource registration of UEFI memory regions. This is
>> necessary because otherwise, drivers could potentially claim regions that
>> are in active use by the firmware. This applies to both MMIO (NOR flash, RTC)
>> and RAM ranges (runtime services code and data).
>>
>> Patch #3-6 adds support to UEFI and non-UEFI code paths to record all memory
>> known to the system in the 'physmem' memblock table (if enabled). This fulfils
>> a need in the /dev/mem and (upcoming) ACPI layers to be able to classify ranges
>> as being backed by normal RAM even if they are not covered by the 'memory'
>> memblock table, and are hence not covered by the linear direct mapping.
>> The physmem code is pre-existing code that only needs minor tweaking to be made
>> suitable for this purpose.
>>
>> Patch #7 enables the 'physmem' memblock table for arm64, and wires it into the
>> handling of /dev/mem mappings, both to decide whether it should be mapped as
>> MT_NORMAL, and whether read-write access can be allowed. (Non-RAM regions can
>> be mapped read-write as long as they are not claimed by a driver in the iomem
>> resource table. RAM regions can only be mapped read-only, and only if they are
>> not covered by the 'memory' memblock table, and hence not covered by the linear
>> mapping)
>>
>> Finally, patch #8 changes the way the virtual memory map is handled by the
>> early UEFI code. Specifically, it memblock_remove()s rather than _reserves()
>> UEFI reserved RAM regions, so that they are removed entirely from the linear
>> mapping.
>>
>> Ard Biesheuvel (8):
>>   arm64/efi: use UEFI memory map unconditionally if available
>>   arm64/efi: register UEFI reserved regions as iomem resources
>>   memblock: add physmem to memblock_dump_all() output
>>   memblock: introduce memblock_add_phys() and memblock_is_physmem()
>>   of: fdt: register physmem in early_init_dt_scan_memory()
>>   arm64/efi: register physmem in reserve_regions()
>>   arm64: use 'physmem' memblock to improve CONFIG_STRICT_DEVMEM handling
>>   arm64/efi: memblock_remove rather than _reserve UEFI reserved RAM
>
> Ard, It is much cleaner for this splitting.
>

Thanks for having a look.

> I wonder if some of them can become general code such as register reserved
> regions as iomem resources?
>

AFAICT, the x86 code adds reservations for such regions to the E820
memory map, which in turn is used to memblock_reserve() the actual
memory. Also, sharing of the RTC is handled with a dedicated mutex in
the runtime services wrapper code (and x86 does not even use the time
related runtime services as they are broken on many firmware
implementations) so blindly applying the same logic to x86 or ia64
would likely break stuff.

Do you (or Mark) have any feedback on the utility of this series in
the ACPI context? I failed to mention in the cover letter that
memblock_is_physmem() now serves the purpose of page_is_ram(), i.e.,
whether a physical region is backed by a slice of RAM that was left
out of the kernel's linear mapping.

Thanks,
Ard.
