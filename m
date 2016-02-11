From: "Abdulhamid, Harb" <harba-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH V1 5/6] arm64: exception: handle instruction abort at
 current EL
Date: Wed, 10 Feb 2016 22:03:54 -0500
Message-ID: <56BBFA1A.7000100@codeaurora.org>
References: <1454699608-22760-1-git-send-email-tbaicar@codeaurora.org>
 <1454699608-22760-6-git-send-email-tbaicar@codeaurora.org>
 <20160210180210.GT1052@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160210180210.GT1052-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, ahs3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Robert Moore <robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lv Zheng <lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-E0kO6a4B6psdnm+yROfE0A@public.gmane.org, Naveen Kaje <nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 2/10/2016 1:02 PM, Will Deacon wrote:
> On Fri, Feb 05, 2016 at 12:13:27PM -0700, Tyler Baicar wrote:
>> Add a handler for instruction aborts at the current EL
>> (ESR_ELx_EC_IABT_CUR) so they are no longer handled in el1_inv.
>> This allows firmware first handling for possible SEA
>> (Synchronous External Abort) caused instruction abort at
>> current EL.
>>
>> Signed-off-by: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>> Signed-off-by: Naveen Kaje <nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>> ---
>>  arch/arm64/kernel/entry.S | 19 +++++++++++++++++++
>>  1 file changed, 19 insertions(+)
>>
>> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
>> index 1f7f5a2..6b7fb14 100644
>> --- a/arch/arm64/kernel/entry.S
>> +++ b/arch/arm64/kernel/entry.S
>> @@ -336,6 +336,8 @@ el1_sync:
>>  	lsr	x24, x1, #ESR_ELx_EC_SHIFT	// exception class
>>  	cmp	x24, #ESR_ELx_EC_DABT_CUR	// data abort in EL1
>>  	b.eq	el1_da
>> +	cmp	x24, #ESR_ELx_EC_IABT_CUR	// instruction abort in EL1
>> +	b.eq	el1_ia
>>  	cmp	x24, #ESR_ELx_EC_SYS64		// configurable trap
>>  	b.eq	el1_undef
>>  	cmp	x24, #ESR_ELx_EC_SP_ALIGN	// stack alignment exception
>> @@ -363,6 +365,23 @@ el1_da:
>>  	// disable interrupts before pulling preserved data off the stack
>>  	disable_irq
>>  	kernel_exit 1
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
> 
> Do we actually need to set this bit (ESR_LNX_EXEC) for aborts from EL1?
> If not, could we just use the same entry code as el1_da?
> 
This is based on what you already do in el0_ia, so the assumption was
that it would be necessary for el1_ia.  Here is an example call flow to
help illustrate why I think this would be needed:
--> el1_ia
  --> do_mem_abort(): determines its a translation fault
    --> do_page_fault(): sets VM_EXEC in vm_flags based on ESR_LNX_EXEC

I admit that I have no idea how the VM_EXEC flag would be used later on
in the guts of the kernel page fault handling code, but we assumed there
is some need to differentiate between instruction and data faults based
on the existence of this flag.

Are you suggesting that this flag does not get used, or is it not really
needed?  If you think this flag adds no value, then we'll do whatever
you suggest.

Harb
-- 
Qualcomm Technologies, Inc.
on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
