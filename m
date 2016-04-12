From: Marc Zyngier <marc.zyngier-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH V2 5/9] arm64: exception: handle instruction abort at
 current EL
Date: Tue, 12 Apr 2016 15:17:24 +0100
Message-ID: <570D0374.8090802@arm.com>
References: <1459955578-24602-1-git-send-email-tbaicar@codeaurora.org>
 <1459955578-24602-6-git-send-email-tbaicar@codeaurora.org>
 <57052D0E.5070903@arm.com> <57058140.5040507@codeaurora.org>
 <20160407085414.5be649f0@arm.com> <570C2BD4.6070402@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <570C2BD4.6070402-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Abdulhamid, Harb" <harba-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "Baicar, Tyler" <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, ahs3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-E0kO6a4B6psdnm+yROfE0A@public.gmane.org, Naveen Kaje <nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 11/04/16 23:57, Abdulhamid, Harb wrote:
> On 4/7/2016 3:54 AM, Marc Zyngier wrote:
>> On Wed, 6 Apr 2016 15:36:00 -0600
>> "Baicar, Tyler" <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org> wrote:
>>
>> Hi Tyler,
>>
>>> Hello Marc,
>>>
>>> On 4/6/2016 9:36 AM, Marc Zyngier wrote:
>>>> On 06/04/16 16:12, Tyler Baicar wrote:
>>>>> Add a handler for instruction aborts at the current EL
>>>>> (ESR_ELx_EC_IABT_CUR) so they are no longer handled in el1_inv.
>>>>> This allows firmware first handling for possible SEA
>>>>> (Synchronous External Abort) caused instruction abort at
>>>>> current EL.
>>>>>
>>>>> Signed-off-by: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>>>>> Signed-off-by: Naveen Kaje <nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>>>>> ---
>>>>>   arch/arm64/kernel/entry.S | 19 +++++++++++++++++++
>>>>>   1 file changed, 19 insertions(+)
>>>>>
>>>>> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
>>>>> index 12e8d2b..f257856 100644
>>>>> --- a/arch/arm64/kernel/entry.S
>>>>> +++ b/arch/arm64/kernel/entry.S
>>>>> @@ -336,6 +336,8 @@ el1_sync:
>>>>>   	lsr	x24, x1, #ESR_ELx_EC_SHIFT	// exception class
>>>>>   	cmp	x24, #ESR_ELx_EC_DABT_CUR	// data abort in EL1
>>>>>   	b.eq	el1_da
>>>>> +	cmp	x24, #ESR_ELx_EC_IABT_CUR	// instruction abort in EL1
>>>>> +	b.eq	el1_ia
>>>>>   	cmp	x24, #ESR_ELx_EC_SYS64		// configurable trap
>>>>>   	b.eq	el1_undef
>>>>>   	cmp	x24, #ESR_ELx_EC_SP_ALIGN	// stack alignment exception
>>>>> @@ -363,6 +365,23 @@ el1_da:
>>>>>   	// disable interrupts before pulling preserved data off the stack
>>>>>   	disable_irq
>>>>>   	kernel_exit 1
>>>>> +el1_ia:
>>>>> +	/*
>>>>> +	 * Instruction abort handling
>>>>> +	 */
>>>>> +	mrs	x0, far_el1
>>>>> +	enable_dbg
>>>>> +	// re-enable interrupts if they were enabled in the aborted context
>>>>> +	tbnz	x23, #7, 1f			// PSR_I_BIT
>>>>> +	enable_irq
>>>>> +1:
>>>>> +	orr	x1, x1, #1 << 24		// use reserved ISS bit for instruction aborts
>>>>> +	mov	x2, sp				// struct pt_regs
>>>>> +	bl	do_mem_abort
>>>>> +
>>>>> +	// disable interrupts before pulling preserved data off the stack
>>>>> +	disable_irq
>>>>> +	kernel_exit 1
>>>>>   el1_sp_pc:
>>>>>   	/*
>>>>>   	 * Stack or PC alignment exception handling
>>>>>
>>>> What happens if you were running at EL2 when this faults gets injected?
>>>> It looks like KVM needs something similar, doesn't it?
>>>>
>>>> Thanks,
>>>>
>>>> 	M.
>>> Thank you for your comment. I don't think this case is possible, or at 
>>> least the current KVM code suggests that this case should never happen.  
>>> In the EL1 code, we get to this case via the vector:
>>>
>>> ventry  el1_sync                        // Synchronous EL1h
>>>
>>> The EL2 KVM equivalent appears to be in arch/arm64/kvm/hyp-entry.S and is:
>>>
>>> ventry  el2h_sync_invalid               // Synchronous EL2h
>>>
>>> This vector is defined as an invalid_vector and has a comment suggesting 
>>> that it should never happen:
>>>
>>> /* None of these should ever happen */
>>> ...
>>>          invalid_vector  el2h_sync_invalid
>>>
>>> Please correct me if I am wrong, but it looks like this case should not 
>>> be possible.
>>
>> This comments really means that we shouldn't ever take any of these
>> exception. If we do, we'll crash and burn (just like the kernel didn't
>> expect to take an instruction fault from the kernel itself, up until
>> this patch).
>>
>> I expect that the firmware does inject the fault into the exception
>> level it has preempted. So let me turn the question the other way
>> around: what guarantees that we will never have to handle such a fault
>> at EL2?
>>
> 
> It is definitely possible to take an external abort (instruction or
> data) as well as SError interrupts in EL2.  One would expect that they
> would be trapped in EL2 when running guest VMs.
> 
> However, this patch was not intended to address KVM APEI support at EL2
> (at this point).  The aim here was to enable APEI (namely firmware first
> error handling support) in the host/root kernel.

The problem is that if you enable it on the host, then you cannot ignore
the EL2 code (i.e. KVM). We need to at least be able to pass the fault
down to the host kernel, where we have the infrastructure to handle it.

> The general idea of how APEI would work with Hypervisors may vary
> depending on the specific Hypervisor (e.g. KVM, Xen, HyperV, VMWare,
> etc.).
> 
> For example, if the Hypervisor (i.e. code running at EL2) traps SEI/SEA
> exceptions (either during EL2 code execution or an SEI/SEA exception
> encountered during guest VM execution), the Hypervisor may not have
> built-in APEI support, or the ability to handle such faults directly.
> One option is for the Hypervisor to forward or "replay" SEA/SEI
> exceptions to the host/root kernel for handling of such exceptions.  If
> the root/host kernel happens to support APEI, the kernel will attempt to
> leverage GHES information to identify the severity of the error, and if
> possible, may attempt to recover from the error.  Essentially, the final
> decision on how to handle SEA/SEI faults falls on the root/host kernel.
> 
> Extending APEI support to KVM should be addressed in a separate
> patchset, as the implication would go beyond just the EL2 exception
> handlers we are referencing here.  There would be much more work and
> validation needed.

I wouldn't be keen on seeing this series being merged without at least a
minimum amount of support at EL2 (making sure we don't explode). Having
the infrastructure to report the fault to a guest is a different issue,
and should indeed be addressed separately. But dealing with the EL2 part
of the host kernel should be taken care at the same time as the EL1 code.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
