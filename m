From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] x86/efi: fix boot panic because of invalid bgrt image address
Date: Thu, 8 Jun 2017 14:24:43 +0000
Message-ID: <CAKv+Gu9vFZ6MFasT-4OtGGpBCDgMWgCRwtn_t5--n0SG2D-h1A@mail.gmail.com>
References: <20170608053239.GA31232@dhcp-128-65.nay.redhat.com>
 <CAKv+Gu_mHpuvC4X_SeY-BLw7AiAnnmTcE0QyPvYiJRtLY4rr_g@mail.gmail.com> <20170608142026.GA4205@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170608142026.GA4205@dhcp-128-65.nay.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, tripleshiftone@gmail.com
List-Id: linux-efi@vger.kernel.org

On 8 June 2017 at 14:20, Dave Young <dyoung@redhat.com> wrote:
> On 06/08/17 at 10:02am, Ard Biesheuvel wrote:
>> On 8 June 2017 at 05:32, Dave Young <dyoung@redhat.com> wrote:
>> > Maniaxx <tripleshiftone@gmail.com> reported kernel boot panic similar to below:
>> > (emulated the panic with using same invalid phys addr in a uefi vm)
>> > There are also a bug in bugzilla.kernel.org:
>> > https://bugzilla.kernel.org/show_bug.cgi?id=195633
>> >
>> > This happens after below commit:
>> > 7b0a911 efi/x86: Move the EFI BGRT init code to early init code
>> >
>> > The root cause is the firmware on those machines provides invalid bgrt
>> > image addresses.
>> >
>> > With original efi bgrt code we initialize bgrt late
>> > and use ioremap to map the image address. In ioremap code we check the
>> > address is a valid physical address or not before really map it.
>> >
>> > With current new efi bgrt code we moved the initialization to early code
>> > so we switch to early_memremap which does not check the phys_addr like
>> > ioremap does. This lead to the early kernel panics.
>> >
>> > Fix this by checking the image physical address, if it is not within
>> > any EFI_BOOT_SERVICES_DATA areas then we just bail out. It is stronger
>> > then the original ioremap checking, according to spec the BGRT data
>> > should fall into EFI_BOOT_SERVICES_DATA.
>> >
>>
>> Which spec? The UEFI spec does not mention BGRT, and given that it is
>
> It is mentioned in ACPI spec, see 6.1 spec section 5.2.22.4
> http://www.uefi.org/sites/default/files/resources/ACPI_6_1.pdf
>

I understand that. The reason for asking 'which spec' was your claim
that 'according to spec the BGRT data should fall into
EFI_BOOT_SERVICES_DATA'

>> an ACPI table, I would expect an ACPI reclaim region to be the most
>> appropriate. A quick test with QEMU confirms this:
>>
>> ACPI: BGRT 0x000000013A5E0000 000038 (v01 INTEL  EDK2     00000002
>>  01000013)
>>
>> and
>>
>> efi:   0x00013a5e0000-0x00013a5effff [ACPI Reclaim Memory|   |  |  |
>> |  |  |  |   |WB|  |  |  ]
>>
>> So while I agree that we have to fix this, and that checking the BGRT
>> address against the UEFI memory map is the most appropriate course of
>> action, requiring a certain region type is probably not what we want.
>>
>> We have a similar check for ESRT, in efi_mem_desc_lookup(), which
>> looks a bit dodgy tbh, given that it allows any region type (including
>> MMIO), as long as it has the EFI_MEMORY_RUNTIME attribute, which is
>> almost certainly incorrect.
>
> Yes, I had that in mind but it delayed for something else ..
>
>>
>> So what I would like to see is a function that can tell you whether a
>> certain address is covered by a region of a type that is normal
>> memory, and is occupied, i.e.,
>>
>> EFI_RESERVED_TYPE
>> EFI_LOADER_CODE
>> EFI_LOADER_DATA
>> EFI_BOOT_SERVICES_CODE
>> EFI_BOOT_SERVICES_DATA
>> EFI_RUNTIME_SERVICES_CODE
>> EFI_RUNTIME_SERVICES_DATA
>> EFI_ACPI_RECLAIM_MEMORY
>> EFI_ACPI_MEMORY_NVS
>>
>> The EFI_MEMORY_RUNTIME attribute is irrelevant: the firmware itself
>> does not have to read these tables at runtime, so it doesn't matter
>> whether the O/S maps them on its behalf.
>>
>> If you could please stick that in drivers/firmware/efi/efi.c, and
>> rework the patch to use it instead? I will move the ESRT code to it as
>> well once this is merged.
>
> Will think about this, I had some plan to change the desc lookup
> function but it was delayed for something else. For this bgrt issue since
> acpi spec clearly said it is in boot data, can we just check the boot
> data areas?
>

The BGRT *table* does not reside in EFI_BOOT_SERVICES_DATA, but
usually in ACPI reclaim memory. The BGRT *image* it points to must
reside in EFI_BOOT_SERVICES_DATA according to the ACPI spec, but this
region is disjoint from the ACPI table.
