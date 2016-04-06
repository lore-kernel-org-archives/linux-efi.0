From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V2 5/9] arm64: exception: handle instruction abort at
 current EL
Date: Wed, 6 Apr 2016 15:36:00 -0600
Message-ID: <57058140.5040507@codeaurora.org>
References: <1459955578-24602-1-git-send-email-tbaicar@codeaurora.org>
 <1459955578-24602-6-git-send-email-tbaicar@codeaurora.org>
 <57052D0E.5070903@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <57052D0E.5070903@arm.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, fu.wei@linaro.org, timur@codeaurora.org, harba@codeaurora.org, rruigrok@codeaurora.org, ahs3@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, devel@acpica.org
Cc: Naveen Kaje <nkaje@codeaurora.org>
List-Id: linux-efi@vger.kernel.org

Hello Marc,

On 4/6/2016 9:36 AM, Marc Zyngier wrote:
> On 06/04/16 16:12, Tyler Baicar wrote:
>> Add a handler for instruction aborts at the current EL
>> (ESR_ELx_EC_IABT_CUR) so they are no longer handled in el1_inv.
>> This allows firmware first handling for possible SEA
>> (Synchronous External Abort) caused instruction abort at
>> current EL.
>>
>> Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
>> Signed-off-by: Naveen Kaje <nkaje@codeaurora.org>
>> ---
>>   arch/arm64/kernel/entry.S | 19 +++++++++++++++++++
>>   1 file changed, 19 insertions(+)
>>
>> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
>> index 12e8d2b..f257856 100644
>> --- a/arch/arm64/kernel/entry.S
>> +++ b/arch/arm64/kernel/entry.S
>> @@ -336,6 +336,8 @@ el1_sync:
>>   	lsr	x24, x1, #ESR_ELx_EC_SHIFT	// exception class
>>   	cmp	x24, #ESR_ELx_EC_DABT_CUR	// data abort in EL1
>>   	b.eq	el1_da
>> +	cmp	x24, #ESR_ELx_EC_IABT_CUR	// instruction abort in EL1
>> +	b.eq	el1_ia
>>   	cmp	x24, #ESR_ELx_EC_SYS64		// configurable trap
>>   	b.eq	el1_undef
>>   	cmp	x24, #ESR_ELx_EC_SP_ALIGN	// stack alignment exception
>> @@ -363,6 +365,23 @@ el1_da:
>>   	// disable interrupts before pulling preserved data off the stack
>>   	disable_irq
>>   	kernel_exit 1
>> +el1_ia:
>> +	/*
>> +	 * Instruction abort handling
>> +	 */
>> +	mrs	x0, far_el1
>> +	enable_dbg
>> +	// re-enable interrupts if they were enabled in the aborted context
>> +	tbnz	x23, #7, 1f			// PSR_I_BIT
>> +	enable_irq
>> +1:
>> +	orr	x1, x1, #1 << 24		// use reserved ISS bit for instruction aborts
>> +	mov	x2, sp				// struct pt_regs
>> +	bl	do_mem_abort
>> +
>> +	// disable interrupts before pulling preserved data off the stack
>> +	disable_irq
>> +	kernel_exit 1
>>   el1_sp_pc:
>>   	/*
>>   	 * Stack or PC alignment exception handling
>>
> What happens if you were running at EL2 when this faults gets injected?
> It looks like KVM needs something similar, doesn't it?
>
> Thanks,
>
> 	M.
Thank you for your comment. I don't think this case is possible, or at 
least the current KVM code suggests that this case should never happen.  
In the EL1 code, we get to this case via the vector:

ventry  el1_sync                        // Synchronous EL1h

The EL2 KVM equivalent appears to be in arch/arm64/kvm/hyp-entry.S and is:

ventry  el2h_sync_invalid               // Synchronous EL2h

This vector is defined as an invalid_vector and has a comment suggesting 
that it should never happen:

/* None of these should ever happen */
...
         invalid_vector  el2h_sync_invalid

Please correct me if I am wrong, but it looks like this case should not 
be possible.

Thanks,
Tyler

-- 
Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

