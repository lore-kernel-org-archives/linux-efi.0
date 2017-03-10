From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V12 09/10] trace, ras: add ARM processor error trace event
Date: Fri, 10 Mar 2017 11:23:13 -0700
Message-ID: <14545228-7ff1-b31c-1fa5-daacf89a44b9@codeaurora.org>
References: <1488833103-21082-1-git-send-email-tbaicar@codeaurora.org>
 <1488833103-21082-10-git-send-email-tbaicar@codeaurora.org>
 <58C12342.2090701@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <58C12342.2090701@huawei.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Xie XiuQi <xiexiuqi@huawei.com>, christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kern
List-Id: linux-efi@vger.kernel.org

Hello Xie XiuQi,


On 3/9/2017 2:41 AM, Xie XiuQi wrote:
> On 2017/3/7 4:45, Tyler Baicar wrote:
>> Currently there are trace events for the various RAS
>> errors with the exception of ARM processor type errors.
>> Add a new trace event for such errors so that the user
>> will know when they occur. These trace events are
>> consistent with the ARM processor error section type
>> defined in UEFI 2.6 spec section N.2.4.4.
>>
>> Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
>> Acked-by: Steven Rostedt <rostedt@goodmis.org>
>> ---
>>   drivers/acpi/apei/ghes.c    |  8 +++++++-
>>   drivers/firmware/efi/cper.c |  1 +
>>   drivers/ras/ras.c           |  1 +
>>   include/ras/ras_event.h     | 34 ++++++++++++++++++++++++++++++++++
>>   4 files changed, 43 insertions(+), 1 deletion(-)

>> diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
>> index 5861b6f..b36db48 100644
>> --- a/include/ras/ras_event.h
>> +++ b/include/ras/ras_event.h
>> @@ -162,6 +162,40 @@
>>   );
>>   
>>   /*
>> + * ARM Processor Events Report
>> + *
>> + * This event is generated when hardware detects an ARM processor error
>> + * has occurred. UEFI 2.6 spec section N.2.4.4.
>> + */
>> +TRACE_EVENT(arm_event,
>> +
>> +	TP_PROTO(const struct cper_sec_proc_arm *proc),
>> +
>> +	TP_ARGS(proc),
>> +
>> +	TP_STRUCT__entry(
>> +		__field(u64, mpidr)
>> +		__field(u64, midr)
>> +		__field(u32, running_state)
>> +		__field(u32, psci_state)
>> +		__field(u8, affinity)
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->affinity = proc->affinity_level;
>> +		__entry->mpidr = proc->mpidr;
>> +		__entry->midr = proc->midr;
>> +		__entry->running_state = proc->running_state;
>> +		__entry->psci_state = proc->psci_state;
>> +	),
>> +
>> +	TP_printk("affinity level: %d; MPIDR: %016llx; MIDR: %016llx; "
>> +		  "running state: %d; PSCI state: %d",
>> +		  __entry->affinity, __entry->mpidr, __entry->midr,
>> +		  __entry->running_state, __entry->psci_state)
>> +);
>> +
> I think these fields are not enough, we need also export arm processor error
> information (UEFI 2.6 spec section N.2.4.4.1), or at least the error type,
> address, etc. So that the userspace (such as rasdaemon tool) could know what
> error occurred.
This is something I am planning on adding in later. It is not clear to 
me how to actually do this at this point. If you look at the spec, there 
is not a single error information structure. There is at least one, but 
possibly a lot. There is also an unknown amount of context information 
structures. In "Table 260. ARM Processor Error Section" there are 
ERR_INFO_NUM and CONTEXT_INFO_NUM which give the number of these 
structures. I think there will need to be separate trace events added in 
for each of these structures because I don't think there is a way to 
have variable amounts of structures inside of a trace event.

The ARM processor error section also has a vendor specific error info 
buffer which will need to be exposed to userspace. This may be something 
that can reuse the unknown section type trace event or have it's own 
trace event for.

Thanks,
Tyler

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.

