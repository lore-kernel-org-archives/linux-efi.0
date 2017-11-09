From: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH 3/3] arm64: Add software workaround for Falkor erratum
 1041
Date: Thu, 09 Nov 2017 11:08:27 +0000
Message-ID: <5A04372B.2090902@arm.com>
References: <1509679664-3749-1-git-send-email-shankerd@codeaurora.org> <1509679664-3749-4-git-send-email-shankerd@codeaurora.org> <1f4a523c-608b-b46b-527a-bc1e02e7db5e@arm.com> <2ef66b5c-d1b7-a5fc-a19d-88dddff95bad@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2ef66b5c-d1b7-a5fc-a19d-88dddff95bad-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shankerd-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, Christoffer Dall <christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi Shanker, Robin,

On 04/11/17 21:43, Shanker Donthineni wrote:
> On 11/03/2017 10:11 AM, Robin Murphy wrote:
>> On 03/11/17 03:27, Shanker Donthineni wrote:
>>> The ARM architecture defines the memory locations that are permitted
>>> to be accessed as the result of a speculative instruction fetch from
>>> an exception level for which all stages of translation are disabled.
>>> Specifically, the core is permitted to speculatively fetch from the
>>> 4KB region containing the current program counter and next 4KB.
>>>
>>> When translation is changed from enabled to disabled for the running
>>> exception level (SCTLR_ELn[M] changed from a value of 1 to 0), the
>>> Falkor core may errantly speculatively access memory locations outside
>>> of the 4KB region permitted by the architecture. The errant memory
>>> access may lead to one of the following unexpected behaviors.
>>>
>>> 1) A System Error Interrupt (SEI) being raised by the Falkor core due
>>>    to the errant memory access attempting to access a region of memory
>>>    that is protected by a slave-side memory protection unit.
>>> 2) Unpredictable device behavior due to a speculative read from device
>>>    memory. This behavior may only occur if the instruction cache is
>>>    disabled prior to or coincident with translation being changed from
>>>    enabled to disabled.
>>>
>>> To avoid the errant behavior, software must execute an ISB immediately
>>> prior to executing the MSR that will change SCTLR_ELn[M] from 1 to 0.


>>> diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
>>> index b6dfb4f..4c91efb 100644
>>> --- a/arch/arm64/include/asm/assembler.h
>>> +++ b/arch/arm64/include/asm/assembler.h
>>> @@ -30,6 +30,7 @@
>>>  #include <asm/pgtable-hwdef.h>
>>>  #include <asm/ptrace.h>
>>>  #include <asm/thread_info.h>
>>> +#include <asm/alternative.h>
>>>  
>>>  /*
>>>   * Enable and disable interrupts.
>>> @@ -514,6 +515,22 @@
>>>   *   reg: the value to be written.
>>>   */
>>>  	.macro	write_sctlr, eln, reg
>>> +#ifdef CONFIG_QCOM_FALKOR_ERRATUM_1041
>>> +alternative_if ARM64_WORKAROUND_QCOM_FALKOR_E1041
>>> +	tbnz    \reg, #0, 8000f          // enable MMU?

Won't this match any change that leaves the MMU enabled?

I think the macro is making this more confusing. Disabling the MMU is obvious
from the call-site, (and really rare!). Trying to work it out from a macro makes
it more complicated than necessary.


>> Do we really need the branch here? It's not like enabling the MMU is
>> something we do on the syscall fastpath, and I can't imagine an extra
>> ISB hurts much (and is probably comparable to a mispredicted branch

> I don't have any strong opinion on whether to use an ISB conditionally
> or unconditionally. Yes, the current kernel code is not touching
> SCTLR_ELn register on the system call fast path. I would like to keep
> it as a conditional ISB in case if the future kernel accesses the
> SCTLR_ELn on the fast path. An extra ISB should not hurt a lot but I
> believe it has more overhead than the TBZ+branch mis-prediction on Falkor
> CPU. This patch has been tested on the real hardware to fix the problem.

> I'm open to change to an unconditional ISB if it's the better fix.
> 
>> anyway). In fact, is there any noticeable hit on other
>> microarchitectures if we save the alternative bother and just do it
>> unconditionally always?
>>
> 
> I can't comment on the performance impacts of other CPUs since I don't
> have access to their development platforms. I'll prefer alternatives
> just to avoid the unnecessary overhead on future Qualcomm Datacenter
> server CPUs and regression on other CPUs because of inserting an ISB

I think hiding errata on other CPUs is a good argument.

My suggestion would be:
> #ifdef CONFIG_QCOM_FALKOR_ERRATUM_1041
> 	isb
> #endif

In head.S and efi-entry.S, as these run before alternatives.
Then use alternatives to add just the isb in the mmu-off path for the other callers.


> prior to SCTLR_ELn register update. Let's see what rest of the ARM 
> maintainers think about always using an ISB instead of alternatives.


Thanks,

James
