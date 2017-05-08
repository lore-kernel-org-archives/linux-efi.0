From: "Baicar, Tyler" <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH V15 06/11] acpi: apei: handle SEA notification type for
 ARMv8
Date: Mon, 8 May 2017 13:59:37 -0600
Message-ID: <9e26f779-5eae-2558-6045-10c1afde9bf2@codeaurora.org>
References: <1492556723-9189-1-git-send-email-tbaicar@codeaurora.org>
 <1492556723-9189-7-git-send-email-tbaicar@codeaurora.org>
 <5910AAB8.8070703@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5910AAB8.8070703-5wv7dgnIgG8@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Cc: christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, eun.taik.lee-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, sandeepa.s.prabhu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, shijie.huang-5wv7dgnIgG8@public.gmane.org, rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, tn-nYOzD4b6Jr9Wk0Htik3J/w@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-E0kO6a4B6psdnm+yROfE0A@public.gmane.org, Suzuki.Po
List-Id: linux-efi@vger.kernel.org

On 5/8/2017 11:28 AM, James Morse wrote:
> Hi Tyler,
>
> On 19/04/17 00:05, Tyler Baicar wrote:
>> ARM APEI extension proposal added SEA (Synchronous External Abort)
>> notification type for ARMv8.
>> Add a new GHES error source handling function for SEA. If an error
>> source's notification type is SEA, then this function can be registered
>> into the SEA exception handler. That way GHES will parse and report
>> SEA exceptions when they occur.
>> An SEA can interrupt code that had interrupts masked and is treated as
>> an NMI. To aid this the page of address space for mapping APEI buffers
>> while in_nmi() is always reserved, and ghes_ioremap_pfn_nmi() is
>> changed to use the helper methods to find the prot_t to map with in
>> the same way as ghes_ioremap_pfn_irq().
>> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
>> index b74d8b7..10013ff 100644
>> --- a/arch/arm64/mm/fault.c
>> +++ b/arch/arm64/mm/fault.c
>> @@ -518,6 +520,17 @@ static int do_sea(unsigned long addr, unsigned int esr, struct pt_regs *regs)
>>   	pr_err("Synchronous External Abort: %s (0x%08x) at 0x%016lx\n",
>>   		inf->name, esr, addr);
>>   
>> +	/*
>> +	 * Synchronous aborts may interrupt code which had interrupts masked.
>> +	 * Before calling out into the wider kernel tell the interested
>> +	 * subsystems.
>> +	 */
>> +	if (IS_ENABLED(CONFIG_ACPI_APEI_SEA)) {
>> +		nmi_enter();
>> +		ghes_notify_sea();
>> +		nmi_exit();
>> +	}
>> +
>>   	info.si_signo = SIGBUS;
>>   	info.si_errno = 0;
>>   	info.si_code  = 0;
>
> I was tidying up the masking/unmasking in entry.S, something I wasn't aware of
> that leads to a bug:
> entry.S will unmask interrupts for instruction/data aborts that came from a
> context with interrupts enabled. This makes sense for get_user() and friends...
> For do_sea() we pull nmi_enter() as this can interrupt interrupts-masked code,
> such as APEI, but if we end up in here with interrupts unmasked we can take an
> IRQ from this 'NMI' context, which will inherit the in_nmi() and could lead to
> the deadlock we were originally trying to avoid.
>
> Teaching entry.S to spot external aborts is messy. I think the two choices are
> to either mask interrupts when calling nmi_enter() (as these things should be
> mutually exclusive), or to conditionally call nmi_enter() based on
> interrupts_enabled(regs). I prefer the second one as it matches the notify_sea()
> while interruptible that happens when KVM takes one of these.
Hello James,

So it would need to be like this?

         if(interrupts_enabled(regs))
             nmi_enter();
         ghes_notify_sea();
         if(interrupts_enabled(regs))
             nmi_exit();

Thanks,
Tyler

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
