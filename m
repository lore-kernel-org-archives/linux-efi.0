From: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>
Subject: Re: [PATCH 1/4] Documentation: arm: [U]EFI runtime services
Date: Wed, 26 Jun 2013 14:20:23 +0100
Message-ID: <CACxGe6vsBKnbipR-Zd1T9Ox1J2ugFmShrGXGUzPa_=D9TJvFQw@mail.gmail.com>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org>
 <1372183863-11333-2-git-send-email-leif.lindholm@linaro.org> <51CA2B03.4080106@wwwdotorg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51CA2B03.4080106-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Warren <swarren-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Jun 26, 2013 at 12:42 AM, Stephen Warren <swarren-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org> wrote:
> On 06/25/2013 12:11 PM, Leif Lindholm wrote:
>> This patch provides documentation of the [U]EFI runtime services and
>> configuration features.
>
>
>> diff --git a/Documentation/arm/uefi.txt b/Documentation/arm/uefi.txt
>
>> +The implementation depends on receiving pointers to the UEFI memory map
>> +and System Table in a Flattened Device Tree - so is only available with
>> +CONFIG_OF.
>> +
>> +It (early) parses the FDT for the following parameters:
>
> Part of this document (the raw requirements for DT content, rather than
> the discussion of OS implementation/behaviour in parsing/interpreting
> the properties) should be part of a file in
> Documentation/devicetree/bindings/ (arm/uefi.txt?).
>
> What node are these properties expected to be contained within?
>
> Shouldn't that node be required to contain a compatible value, which
> would define the schema for the other properties?

Typically, a compatible property isn't only used for nodes that
represent a device or a so-called 'virtual' device (ie. such as to
describe how all the sound complex is wired together) since that
should be the clue to an OS that a device driver will bind against the
node. I think these properties can be dropped into /chosen without
defining a new compatible value.

>> +- 'efi-system-table':
>> +  Physical address of the system table. (required)
>> +- 'efi-runtime-mmap':
>> +  Physical address of an EFI memory map, containing at least
>> +  the regions to be preserved. (required)
>> +- 'efi-runtime-mmap-size':
>> +  Size in bytes of the provided memory map. (required)
>> +- 'efi-mmap-desc-size':
>> +  Size of each descriptor in the memory map. (override default)
>> +- 'efi-mmap-desc-ver':
>> +  Memory descriptor format version. (override default)
>> +
>> +Since UEFI firmware on ARM systems are required to use a 1:1 memory map
>> +even on LPAE-capable systems, the above fields are 32-bit regardless.
>
> What about ARMv8? Is the intention to have a separate definition for the
> UEFI bindings on ARMv8, so that compatibility isn't an issue? What if a
> future version of UEFI allows LPAE usage?

It is unlikely that will happen on v7 since newer versions of UEFI are
expected to remain backwards compatible with the current spec.

> It may be better to explicitly state that the size of those properties
> is either #address-cells from the parent node (presumably the top-level
> of the DT), and/or introduce some property to explicitly state the size
> of the properties. Those mechanisms would allow forward-compatibility to
> LPAE usage or ARMv8 without requiring the text of the binding definition
> to change.
>
> Also, it seems legal to state the physical addresses using 64-bits even
> if the actual values themselves are restricted to 32-bit range by the
> UEFI spec. Illegal values would presumably cause SW that interprets them
> to fail error-checks, and be rejected.
>
>> +After the kernel has mapped the required regions into its address space,
>> +a SetVirtualAddressMap() call is made into UEFI in order to update
>> +relocations. This call must be performed with all the code in a 1:1
>
> Presumably "all the code" also includes "all .data and .bss", or
> whatever the UEFI-equivalent may be? I'm not familiar with UEFI at all;
> does the "EFI memory map" mentioned above describe all the memory
> regions that must be mapped to use UEFI?

yes. Actually, there is an API for retrieving the memory map from UEFI
at runtime, but it is difficult to call from within the kernel.
Actually, my preference would be to not require GRUB or the Linux
Loader to add the above properties at all and instead have the kernel
proper retrieve the memory map directly. That would reduce the
dependency on GRUB/LinuxLoader doing things correctly, but Leif knows
better how feasible that would be.

>
>> +mapping. This implementation achieves this by temporarily disabling the
>> +MMU for the duration of this call. This can only be done safely:
>> +- before secondary CPUs are brought online.
>> +- after early_initcalls have completed, sinze it uses setup_mm_for_reboot().
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
