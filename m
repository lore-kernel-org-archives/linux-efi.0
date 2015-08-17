From: "Zhang, Jonathan Zhixiong" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH V2 1/2] arm64: apei: implement
 arch_apei_get_mem_attributes()
Date: Mon, 17 Aug 2015 14:09:58 -0700
Message-ID: <55D24DA6.3080105@codeaurora.org>
References: <1439591850-29002-1-git-send-email-zjzhang@codeaurora.org>
 <20150817130553.GA3233@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150817130553.GA3233-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



On 8/17/2015 6:05 AM, Matt Fleming wrote:
> On Fri, 14 Aug, at 03:37:29PM, Jonathan (Zhixiong) Zhang wrote:
>> From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>>
>> Table 8 of UEFI 2.5 section 2.3.6.1 defines mappings from EFI
>> memory types to MAIR attribute encodings for arm64.
>>
>> If the physical address has memory attributes defined by EFI
>> memmap as EFI_MEMORY_[UC|WC|WT], return approprate page protection
>> type according to the UEFI spec. Otherwise, return PAGE_KERNEL.
>>
>> Reviewed-by: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
>> Acked-by: Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>> Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>> Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Cc: Hanjun Guo <hanjun.guo-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
>> ---
>> V2: Changed arm64's implementation of arch_apei_get_mem_attributes()
>>      from inline function to out of line function, based on Ingo's
>>      feedback.
>>
>>   arch/arm64/include/asm/acpi.h |  5 +++++
>>   arch/arm64/kernel/acpi.c      | 29 +++++++++++++++++++++++++++++
>>   2 files changed, 34 insertions(+)
>>
>
> Looks fine to me, though it appears to be missing Ard's Reviewed-by
> tag (the only change from the previous version is that it's no longer
> inline).
>
> Reviewed-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Thanks. Will add both Reviewed-by.
>
> Ingo, are you going to pick up this patch series and apply it directly
> to tip if you're OK with this version?
>

-- 
Jonathan (Zhixiong) Zhang
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
