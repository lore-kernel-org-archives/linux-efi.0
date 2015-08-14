From: "Zhang, Jonathan Zhixiong" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH 2/2] acpi, apei: use appropriate pgprot_t to map GHES
 memory
Date: Fri, 14 Aug 2015 12:09:15 -0700
Message-ID: <55CE3CDB.7020303@codeaurora.org>
References: <1439396234-22863-1-git-send-email-matt@codeblueprint.co.uk>
 <1439396234-22863-3-git-send-email-matt@codeblueprint.co.uk>
 <20150813081917.GA14610@gmail.com>
 <20150813092432.GA2797@codeblueprint.co.uk> <20150813111422.GE10280@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150813111422.GE10280-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



On 8/13/2015 4:14 AM, Will Deacon wrote:
> On Thu, Aug 13, 2015 at 10:24:32AM +0100, Matt Fleming wrote:
>> On Thu, 13 Aug, at 10:19:17AM, Ingo Molnar wrote:
>>> * Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
>>>
>>>> From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>>>>
>>>> With ACPI APEI firmware first handling, generic hardware error
>>>> record is updated by firmware in GHES memory region. On an arm64
>>>> platform, firmware updates GHES memory region with uncached
>>>> access attribute, and then Linux reads stale data from cache.
>>>
>>> So this paragraph does not parse for me ...
I will update the paragraph to explain that with current code,
PAGE_KERNEL is always used, this means that the kernel assumes
cache coherency to the memory region is maintained by firmware;
such assumption is not always correct.
>>>
>>> If it tries to explain a bug it falls very short of doing a proper job of that.
>>
>> I'll let Jonathan provide more details but I understood the problem to
>> be a cache (in)coherency issue.
>>
>> The kernel currently maps the the GHES memory region as cacheable
>> (PAGE_KERNEL) for all architectures. This memory region is used as a
>> communication buffer for reporting hardware errors from the firmware to
>> kernel. Essentially the firmware writes hardware error records there,
>> trigger an NMI/interrupt, and the GHES driver goes off and grabs the
>> error record from the GHES region.
>>
>> Since the firmware gets first crack at inspecting the error this
>> mechanism is referred to as "firmware first" in the ACPI spec.
>>
>> Now, there's a mismatch on arm64 platforms between how the kernel maps
>> the GHES region (PAGE_KERNEL) and how the firmware maps it
>> (EFI_MEMORY_UC, i.e. uncacheable), leading to the possibility of the
>> kernel GHES driver reading stale data from the cache when it receives
>> the NMI/interrupt.
>>
>> As for exactly why the arm64 firmware uses an uncached mapping, I
>> presume it's to avoid relying on the kernel to get the necessary cache
>> flushing correct.
>>
>> The proposed solution is to query the EFI memory map to ensure the
>> kernel uses a compatible mapping.
>>
>> None of this should affect x86, it still uses PAGE_KERNEL because we're
>> yet to see any hardware that has an EFI memory map entry for the GHES
>> region that's incompatible with PAGE_KERNEL.
>>
>> Jonathan, would you like to provide more details?
Not really. Matt and Will articulated it to the points.
>
> FWIW, that matches my understanding of the problem too. The ARM architecture
> refers to this situation as "mismatched memory attributes" and typically
> requires some explicit cache maintenance to achieve portable behaviour in
> this scenario.
>
> It's much better to avoid the mismatch in the first place, if you can,
> which is what this is all about.
>
> Will
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
Jonathan (Zhixiong) Zhang
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
