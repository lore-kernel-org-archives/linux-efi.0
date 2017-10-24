From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi/libstub: arm: omit sorting of the UEFI memory map
Date: Tue, 24 Oct 2017 12:09:59 +0100
Message-ID: <CAKv+Gu8gPHj1jV1ZyW8u1qSb5F=L6HDrmCcVueo0szy+2USsXA@mail.gmail.com>
References: <20171022141457.28769-1-ard.biesheuvel@linaro.org> <20171024110519.GE20805@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171024110519.GE20805-l+eeeJia6m9URfEZ8mYm6t73F7V6hmMc@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Russell King - ARM Linux <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Chris Zhong <zyw-TNX95d0MmH7DzftRWevZcw@public.gmane.org>, Jeffy Chen <jeffy.chen-TNX95d0MmH7DzftRWevZcw@public.gmane.org>, Gregory CLEMENT <gregory.clement-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Matthias Brugger <mbrugger-IBi9RG/b67k@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 24 October 2017 at 12:05, Russell King - ARM Linux
<linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org> wrote:
> On Sun, Oct 22, 2017 at 03:14:57PM +0100, Ard Biesheuvel wrote:
>> ARM shares its EFI stub implementation with arm64, which has some
>> special handling in the virtual remapping code to
>> a) make sure that we can map everything even if the OS executes
>>    with 64k page size, and
>> b) make sure that adjacent regions with the same attributes are not
>>    reordered or moved apart in memory.
>>
>> The latter is a workaround for a 'feature' that was shortly recommended
>> by UEFI spec v2.5, but deprecated shortly after, due to the fact that
>> it broke many OS installers, including non-Linux ones, and it was never
>> widely implemented for ARM systems. Before implementing b), the arm64
>> code simply rounded up all regions to 64 KB granularity, but given that
>> that results in moving adjacent regions apart, it had to be refined when
>> b) was implemented.
>>
>> The adjacency check requires a sort() pass, due to the fact that the
>> UEFI spec does not mandate any ordering, and the inclusion of the
>> lib/sort.c code into the ARM EFI stub is causing some trouble with
>> the decompressor build due to the fact that its EXPORT_SYMBOL() call
>> triggers the creation of ksymtab/kcrctab sections.
>>
>> So let's simply do away with the adjacency check for ARM, and simply put
>> all UEFI runtime regions together if they have the same memory attributes.
>> This is guaranteed to work, given that ARM only supports 4 KB pages,
>> and allows us to remove the sort() call entirely.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>
> I guess as this is shared between ARM and ARM64, ARM64 folk should ack
> this before I merge it - can I have an ack from that side please?
>

Note that the patch does not touch arch/arm64, nor does it affect
arm64, given that the change is a no-op if CONFIG_ARM64=y. That said,
I welcome any acks from the arm64 maintainers, but I don't think they
are actually required here.

>> ---
>>  drivers/firmware/efi/libstub/Makefile   | 6 +++---
>>  drivers/firmware/efi/libstub/arm-stub.c | 7 +++++--
>>  2 files changed, 8 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
>> index dedf9bde44db..f3e8431565ea 100644
>> --- a/drivers/firmware/efi/libstub/Makefile
>> +++ b/drivers/firmware/efi/libstub/Makefile
>> @@ -33,13 +33,14 @@ lib-y                             := efi-stub-helper.o gop.o secureboot.o
>>  lib-$(CONFIG_RESET_ATTACK_MITIGATION) += tpm.o
>>
>>  # include the stub's generic dependencies from lib/ when building for ARM/arm64
>> -arm-deps := fdt_rw.c fdt_ro.c fdt_wip.c fdt.c fdt_empty_tree.c fdt_sw.c sort.c
>> +arm-deps-y := fdt_rw.c fdt_ro.c fdt_wip.c fdt.c fdt_empty_tree.c fdt_sw.c
>> +arm-deps-$(CONFIG_ARM64) += sort.c
>>
>>  $(obj)/lib-%.o: $(srctree)/lib/%.c FORCE
>>       $(call if_changed_rule,cc_o_c)
>>
>>  lib-$(CONFIG_EFI_ARMSTUB)    += arm-stub.o fdt.o string.o random.o \
>> -                                $(patsubst %.c,lib-%.o,$(arm-deps))
>> +                                $(patsubst %.c,lib-%.o,$(arm-deps-y))
>>
>>  lib-$(CONFIG_ARM)            += arm32-stub.o
>>  lib-$(CONFIG_ARM64)          += arm64-stub.o
>> @@ -90,5 +91,4 @@ quiet_cmd_stubcopy = STUBCPY $@
>>  # explicitly by the decompressor linker script.
>>  #
>>  STUBCOPY_FLAGS-$(CONFIG_ARM) += --rename-section .data=.data.efistub
>> -STUBCOPY_RM-$(CONFIG_ARM)    += -R ___ksymtab+sort -R ___kcrctab+sort
>>  STUBCOPY_RELOC-$(CONFIG_ARM) := R_ARM_ABS
>> diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
>> index 1cb2d1c070c3..3061e4057483 100644
>> --- a/drivers/firmware/efi/libstub/arm-stub.c
>> +++ b/drivers/firmware/efi/libstub/arm-stub.c
>> @@ -349,7 +349,9 @@ void efi_get_virtmap(efi_memory_desc_t *memory_map, unsigned long map_size,
>>        * The easiest way to find adjacent regions is to sort the memory map
>>        * before traversing it.
>>        */
>> -     sort(memory_map, map_size / desc_size, desc_size, cmp_mem_desc, NULL);
>> +     if (IS_ENABLED(CONFIG_ARM64))
>> +             sort(memory_map, map_size / desc_size, desc_size, cmp_mem_desc,
>> +                  NULL);
>>
>>       for (l = 0; l < map_size; l += desc_size, prev = in) {
>>               u64 paddr, size;
>> @@ -366,7 +368,8 @@ void efi_get_virtmap(efi_memory_desc_t *memory_map, unsigned long map_size,
>>                * a 4k page size kernel to kexec a 64k page size kernel and
>>                * vice versa.
>>                */
>> -             if (!regions_are_adjacent(prev, in) ||
>> +             if ((IS_ENABLED(CONFIG_ARM64) &&
>> +                  !regions_are_adjacent(prev, in)) ||
>>                   !regions_have_compatible_memory_type_attrs(prev, in)) {
>>
>>                       paddr = round_down(in->phys_addr, SZ_64K);
>> --
>> 2.11.0
>>
>
> --
> RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
> According to speedtest.net: 8.21Mbps down 510kbps up
