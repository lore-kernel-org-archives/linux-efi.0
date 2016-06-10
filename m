From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] efi: kernel param for legacy NVDIMM support
Date: Fri, 10 Jun 2016 07:27:43 -0700
Message-ID: <CAA9_cmeQUaxShZfnARt=j4iResPTwjxrK_toA6CJgtRAnzEgYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yigal Korman <yigal-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Jun 10, 2016 at 1:48 AM, Yigal Korman <yigal-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org> wrote:
> On Thu, Jun 9, 2016 at 11:27 PM, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>
>> On Thu, Jun 9, 2016 at 10:42 AM, Yigal Korman <yigal-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org> wrote:
>> > The 'efi_legacy_pmem' parameter will convert EFI persistent memory range
>> > (type 14) into E820 legacy NVDIMM (type 12) memory range.
>> >
>> > Background:
>> >
>> > In contrast with the NVDIMM E820 types where we can clearly distinguish
>> > between old NVDIMMs (type-12) and ACPI 6.0 NVDIMMs (type-7), the EFI
>> > memory types for NVDIMMs are the same before ACPI 6.0 and after
>> > (type-14).
>> > This means that old NVDIMMs under EFI aren't supported even though
>> > they work fine if booted with BIOS (E820).
>> >
>> > So allow the user to explicitly request the kernel to identify NVDIMMs
>> > as legacy under EFI.
>> >
>>
>> I'm concerned with the potential for this command line parameter to
>> collide with NFIT defined ranges.  At a minimum it should confirm that
>> there is not already an NFIT describing the same address ranges.
>>
>
> That's a valid concern, but not related to this patch directly, the
> same might happen today when an 'memmap=XX!YY' kernel parameter
> collides with an NFIT on the same range.

We should fix that too, i.e. always prefer NFIT over plain / imprecise
type-12 / efi-type-14 range.  Actually, in the type-12 vs NFIT case we
should be even more strict...

> Or, albeit a far fetched scenario, a platform vendor will decide to
> provide an NFIT for a non-ACPI 6.0 and leave the old E820 type-12.

If a platform has e820 type-12 (without memmap=) and an NFIT we should
throw a WARN_TAINT firmware warning, because that platform has taken
the time to update to ACPI 6.0 NFIT, but still use the out of spec
type-12.  That memory type is something we only supported as a
stop-gap for platforms that had no other option prior to ACPI 6.

>> However, we have the ability to override / inject ACPI tables and
>> methods from the kernel.  Why not use that facility to custom craft an
>> NFIT when the BIOS fails to provide one?  That way EFI type-14
>> maintains a constant interpretation as just a reserved memory range
>> with no other side effects.
>
> That might be an interesting way to implement memmap=XX!YY in general
> and can also replace the funny code in arch/x86/kernel/pmem.c.
>
> But, it's more complex and probably has its own caveats, this patch is
> simpler and straight forward, providing direct value.

No, it makes a bad situation worse.  In the type-12 case it is
obviously out of spec and the only thing that address range could be
is a legacy platform.  The efi-type-14 case is accidentally in-spec
and collides / aliases with the ACPI 6 definition.

We should always look for an NFIT in the type-14 case.  Injecting a
crafted NFIT for this legacy case removes confusion as there is only
one action the kernel takes and no possibility for collisions.  I also
do not want to make it easier for firmware developers to skip the
necessary due diligence to decide whether attributes like numa
topology, posted write queue flush mechanisms, and media health,
etc...  need description.
