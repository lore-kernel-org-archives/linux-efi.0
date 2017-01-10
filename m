From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V6 05/10] acpi: apei: handle SEA notification type for
 ARMv8
Date: Tue, 10 Jan 2017 10:50:53 -0700
Message-ID: <dfb77246-3c13-9e37-d3d5-0975fc7c6567@codeaurora.org>
References: <1481147303-7979-1-git-send-email-tbaicar@codeaurora.org>
 <1481147303-7979-6-git-send-email-tbaicar@codeaurora.org>
 <58594E62.3050003@arm.com>
 <8b7fa162-0d44-025f-758d-d61cfa75c787@codeaurora.org>
 <586F74DB.3020107@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <586F74DB.3020107@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Morse <james.morse@arm.com>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, devel@acpica.org, Suzuki.Po
List-Id: linux-efi@vger.kernel.org

Hello James,


On 1/6/2017 3:43 AM, James Morse wrote:
> On 05/01/17 22:31, Baicar, Tyler wrote:
>> On 12/20/2016 8:29 AM, James Morse wrote:
>>> On 07/12/16 21:48, Tyler Baicar wrote:
>>>> ARM APEI extension proposal added SEA (Synchrounous External
>>>> Abort) notification type for ARMv8.
>>>> Add a new GHES error source handling function for SEA. If an error
>>>> source's notification type is SEA, then this function can be registered
>>>> into the SEA exception handler. That way GHES will parse and report
>>>> SEA exceptions when they occur.
>>>> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
>>>> index 2acbc60..66ab3fd 100644
>>>> --- a/drivers/acpi/apei/ghes.c
>>>> +++ b/drivers/acpi/apei/ghes.c
>>>> @@ -767,6 +771,62 @@ static struct notifier_block ghes_notifier_sci = {
>>>>        .notifier_call = ghes_notify_sci,
>>>>    };
>>>>    +#ifdef CONFIG_HAVE_ACPI_APEI_SEA
>>>> +static LIST_HEAD(ghes_sea);
>>>> +
>>>> +static int ghes_notify_sea(struct notifier_block *this,
>>>> +                  unsigned long event, void *data)
>>>> +{
>>>> +    struct ghes *ghes;
>>>> +    int ret = NOTIFY_DONE;
>>>> +
>>>> +    rcu_read_lock();
>>>> +    list_for_each_entry_rcu(ghes, &ghes_sea, list) {
>>>> +        if (!ghes_proc(ghes))
>>>> +            ret = NOTIFY_OK;
>>>> +    }
>>>> +    rcu_read_unlock();
>>>> +
>>>> +    return ret;
>>>> +}
>>> What stops this from being re-entrant?
>>>
>>> ghes_copy_tofrom_phs() takes the ghes_ioremap_lock_irq spinlock, but there is
>>> nothing to stop a subsequent instruction fetch or memory access causing another
>>> (maybe different) Synchronous External Abort which deadlocks trying to take the
>>> same lock.
>>>
>>> ghes_notify_sea() looks to be based on ghes_notify_sci(), which (if I've found
>>> the right part of the ACPI spec) is a level-low interrupt. spin_lock_irqsave()
>>> would mask interrupts so there is no risk of a different notification firing on
>>> the same CPU, (it looks like they are almost all ultimately an irq).
>>>
>>> NMI is the odd one out because its not maskable like this, but ghes_notify_nmi()
>>> has:
>>>>      if (!atomic_add_unless(&ghes_in_nmi, 1, 1))
>>>>          return ret;
>>> To ensure there is only ever one thread poking around in this code.
>>>
>>> What happens if a system describes two GHES sources, one using an irq the other
>>> SEA? The SEA error can interrupt the irq error while its holding the above lock.
>>> I guess this is also why all the NMI code in that file is separate.
>
>> Let me see if I'm following you right :)
>> I should use spin_lock_irqsave() in ghes_notify_sea() to avoid ghes_notify_sci()
>> from
>> interrupting this process and potentially causing the deadlock?
> This way round you are already safe: The CPU masks interrupts when it takes the
> exception, they should still be masked by the time we get in here...
>
> The other way round is a lot more fun!
>
> What happens if APEI is processing some error record that was notified via an
> interrupt, and then takes the Synchronous External Abort, and ends up back in
> this code? Masking interrupts doesn't stop the external-abort, and trying to
> take the ghes_ioremap_lock_irq will deadlock.
>
> What happens if we interrupt printk() holding all its locks is another thing I
> haven't worked out yet.
>
>
>> This race condition does seem valid. We are using the same acknowledgment for
>> all our
>> HEST table entries, so our firmware will not populate more than one entry at a
>> time. That
>> gets us around this race condition.
> Ah, so your firmware will wait for the interrupt-signalled error to be finished
> before it triggers the Synchronous External Abort. I think this would still be a
> linux bug if the firmware didn't do this.
>
> x86 could have done the same with NMI notifications, but we have all this 'if
> (in_nmi)' to allow interrupts-masked GHES handling to be interrupted.
>
> What do you think to re-using the 'if (in_nmi)' code for SEA? We can argue that
> SEA is NMI-like in that it can't be masked, and it interrupts code that had
> interrupts masked. It 'should' be as simple as putting 'HAVE_NMI' in arm64's
> Kconfig, and wrapping the atomic notifier call with nmi_enter()/nmi_exit() from
> linux/hardirq.h. (...famous last words...)
>
> This probably answers my printk() questions too, but I need to look into it some
> more.

Thanks for the detailed description! I looked through this and it seems 
like re-using the NMI code should work. I'll add the use of the in_nmi 
code in the next patchset.

Thanks,
Tyler

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
