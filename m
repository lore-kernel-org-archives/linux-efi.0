From: Shanker Donthineni <shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH 3/3] arm64: Add software workaround for Falkor erratum
 1041
Date: Sun, 12 Nov 2017 19:06:25 -0600
Message-ID: <c5491ade-5da3-89e7-89df-048f8ba3fada@codeaurora.org>
References: <1509679664-3749-1-git-send-email-shankerd@codeaurora.org>
 <1509679664-3749-4-git-send-email-shankerd@codeaurora.org>
 <1f4a523c-608b-b46b-527a-bc1e02e7db5e@arm.com>
 <2ef66b5c-d1b7-a5fc-a19d-88dddff95bad@codeaurora.org>
 <5A04372B.2090902@arm.com>
 <93801988-e785-bd49-796e-4a73e0b77413@codeaurora.org>
 <5A057E44.3050109@arm.com>
Reply-To: shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5A057E44.3050109-5wv7dgnIgG8@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi James,

On 11/10/2017 04:24 AM, James Morse wrote:
> Hi Shanker,
> 
> On 09/11/17 15:22, Shanker Donthineni wrote:
>> On 11/09/2017 05:08 AM, James Morse wrote:
>>> On 04/11/17 21:43, Shanker Donthineni wrote:
>>>> On 11/03/2017 10:11 AM, Robin Murphy wrote:
>>>>> On 03/11/17 03:27, Shanker Donthineni wrote:
>>>>>> The ARM architecture defines the memory locations that are permitted
>>>>>> to be accessed as the result of a speculative instruction fetch from
>>>>>> an exception level for which all stages of translation are disabled.
>>>>>> Specifically, the core is permitted to speculatively fetch from the
>>>>>> 4KB region containing the current program counter and next 4KB.
>>>>>>
>>>>>> When translation is changed from enabled to disabled for the running
>>>>>> exception level (SCTLR_ELn[M] changed from a value of 1 to 0), the
>>>>>> Falkor core may errantly speculatively access memory locations outside
>>>>>> of the 4KB region permitted by the architecture. The errant memory
>>>>>> access may lead to one of the following unexpected behaviors.
>>>>>>
>>>>>> 1) A System Error Interrupt (SEI) being raised by the Falkor core due
>>>>>>    to the errant memory access attempting to access a region of memory
>>>>>>    that is protected by a slave-side memory protection unit.
>>>>>> 2) Unpredictable device behavior due to a speculative read from device
>>>>>>    memory. This behavior may only occur if the instruction cache is
>>>>>>    disabled prior to or coincident with translation being changed from
>>>>>>    enabled to disabled.
>>>>>>
>>>>>> To avoid the errant behavior, software must execute an ISB immediately
>>>>>> prior to executing the MSR that will change SCTLR_ELn[M] from 1 to 0.
> 
>>>>>> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
>>>>>> index b6dfb4f..4c91efb 100644
>>>>>> --- a/arch/arm64/include/asm/assembler.h
>>>>>> +++ b/arch/arm64/include/asm/assembler.h
>>>>>> @@ -514,6 +515,22 @@
>>>>>>   *   reg: the value to be written.
>>>>>>   */
>>>>>>  	.macro	write_sctlr, eln, reg
>>>>>> +#ifdef CONFIG_QCOM_FALKOR_ERRATUM_1041
>>>>>> +alternative_if ARM64_WORKAROUND_QCOM_FALKOR_E1041
>>>>>> +	tbnz    \reg, #0, 8000f          // enable MMU?
>>>
>>> Won't this match any change that leaves the MMU enabled?
>>
>> Yes. No need to apply workaround if the MMU is going to be enabled.
> 
> (Sorry, looks like I had this upside down)
> 
> My badly-made-point is you can't know if the MMU is being disabled unless you
> have both the old and new values.
> 
> As an example, in el2_setup, (where the MMU is disabled), we set the EE/E0E bits
> to match the kernel's endianness. Won't your macro will insert an unnecessary
> isb? Is this needed for the errata workaround?
> 

Yes, It's not required in this case. I'll post a v2 patch and apply the workaround
where it's absolutely required. Seems handling a workaround inside helper macros
causing confusion.

> 
>>> I think the macro is making this more confusing. Disabling the MMU is obvious
>>> from the call-site, (and really rare!). Trying to work it out from a macro makes
>>> it more complicated than necessary.
> 
>> Not clear, are you suggesting not to use read{write}_sctlr() macros instead apply 
>> the workaround from the call-site based on the MMU-on status?
> 
> Yes. This is the only way to patch only the locations that turn the MMU off.
> 
> 
>> If yes, It simplifies
>> the code logic but CONFIG_QCOM_FALKOR_ERRATUM_1041 references are scatter everywhere. 
> 
> Wouldn't they only appear in the places that are affected by the errata?
> This is exactly what we want, anyone touching that code now knows they need to
> double check this behaviour, (and ask you to test it!).
> 
> Otherwise we have a macro second guessing what is happening, if its not quite
> right (because some information has been lost), we're now not sure what we need
> to do if we ever refactor any of this code.
> 
> [...]
> 
>>>> I'll prefer alternatives
>>>> just to avoid the unnecessary overhead on future Qualcomm Datacenter
>>>> server CPUs and regression on other CPUs because of inserting an ISB
>>>
>>> I think hiding errata on other CPUs is a good argument.
>>>
>>> My suggestion would be:
>>>> #ifdef CONFIG_QCOM_FALKOR_ERRATUM_1041
>>>> 	isb
>>>> #endif
>>>
>>> In head.S and efi-entry.S, as these run before alternatives.
>>> Then use alternatives to add just the isb in the mmu-off path for the other callers.
> 
>> Thanks for your opinion on this one, I'll change to an unconditional ISB in v2 patch.
>> After this change the enable_mmu() issues two ISBs before writing to SCTLR_EL1.
> 
> Another great reason not to wrap this in a macro, there may already be a
> suitable isb, in which case a comment will suffice.
> 
> 
>> Are you okay with this behavior?
> 
> Back-to-back isb doesn't sound like a good idea.
> 
> 
>>  ENTRY(__enable_mmu)
>>         mrs     x1, ID_AA64MMFR0_EL1
>>         ubfx    x2, x1, #ID_AA64MMFR0_TGRAN_SHIFT, 4
>>         cmp     x2, #ID_AA64MMFR0_TGRAN_SUPPORTED
>>         b.ne    __no_granule_support
>>         update_early_cpu_boot_status 0, x1, x2
>>         adrp    x1, idmap_pg_dir
>>         adrp    x2, swapper_pg_dir
>>         msr     ttbr0_el1, x1                   // load TTBR0
>>         msr     ttbr1_el1, x2                   // load TTBR1
>>         isb
>>         write_sctlr el1, x0
>>         isb
> 
> Now I'm thoroughly confused. Isn't this one of the sequences that doesn't hit
> the issue? Here we're switching SCTLR.M from 0 to 1.
> 
> 
> Thanks,
> 
> James
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
Shanker Donthineni
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
