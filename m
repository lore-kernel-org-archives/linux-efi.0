From: Xie XiuQi <xiexiuqi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V12 09/10] trace, ras: add ARM processor error trace event
Date: Mon, 13 Mar 2017 10:31:33 +0800
Message-ID: <58C60485.2070509@huawei.com>
References: <1488833103-21082-1-git-send-email-tbaicar@codeaurora.org>
 <1488833103-21082-10-git-send-email-tbaicar@codeaurora.org>
 <58C12342.2090701@huawei.com>
 <14545228-7ff1-b31c-1fa5-daacf89a44b9@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <14545228-7ff1-b31c-1fa5-daacf89a44b9-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Baicar, Tyler" <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, james.morse-5wv7dgnIgG8@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, eun.taik.lee-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, sandeepa.s.prabhu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, shijie.huang-5wv7dgnIgG8@public.gmane.org, rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, tn-nYOzD4b6Jr9Wk0Htik3J/w@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.orgkvm
List-Id: linux-efi@vger.kernel.org

Hi Baicar Tyler,

On 2017/3/11 2:23, Baicar, Tyler wrote:
> Hello Xie XiuQi,
> 
> 
> On 3/9/2017 2:41 AM, Xie XiuQi wrote:
>> On 2017/3/7 4:45, Tyler Baicar wrote:
>>> Currently there are trace events for the various RAS
>>> errors with the exception of ARM processor type errors.
>>> Add a new trace event for such errors so that the user
>>> will know when they occur. These trace events are
>>> consistent with the ARM processor error section type
>>> defined in UEFI 2.6 spec section N.2.4.4.
>>>
>>> Signed-off-by: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>>> Acked-by: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
>>> ---
>>>   drivers/acpi/apei/ghes.c    |  8 +++++++-
>>>   drivers/firmware/efi/cper.c |  1 +
>>>   drivers/ras/ras.c           |  1 +
>>>   include/ras/ras_event.h     | 34 ++++++++++++++++++++++++++++++++++
>>>   4 files changed, 43 insertions(+), 1 deletion(-)
> 
>>> diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
>>> index 5861b6f..b36db48 100644
>>> --- a/include/ras/ras_event.h
>>> +++ b/include/ras/ras_event.h
>>> @@ -162,6 +162,40 @@
>>>   );
>>>     /*
>>> + * ARM Processor Events Report
>>> + *
>>> + * This event is generated when hardware detects an ARM processor error
>>> + * has occurred. UEFI 2.6 spec section N.2.4.4.
>>> + */
>>> +TRACE_EVENT(arm_event,
>>> +
>>> +    TP_PROTO(const struct cper_sec_proc_arm *proc),
>>> +
>>> +    TP_ARGS(proc),
>>> +
>>> +    TP_STRUCT__entry(
>>> +        __field(u64, mpidr)
>>> +        __field(u64, midr)
>>> +        __field(u32, running_state)
>>> +        __field(u32, psci_state)
>>> +        __field(u8, affinity)
>>> +    ),
>>> +
>>> +    TP_fast_assign(
>>> +        __entry->affinity = proc->affinity_level;
>>> +        __entry->mpidr = proc->mpidr;
>>> +        __entry->midr = proc->midr;
>>> +        __entry->running_state = proc->running_state;
>>> +        __entry->psci_state = proc->psci_state;
>>> +    ),
>>> +
>>> +    TP_printk("affinity level: %d; MPIDR: %016llx; MIDR: %016llx; "
>>> +          "running state: %d; PSCI state: %d",
>>> +          __entry->affinity, __entry->mpidr, __entry->midr,
>>> +          __entry->running_state, __entry->psci_state)
>>> +);
>>> +
>> I think these fields are not enough, we need also export arm processor error
>> information (UEFI 2.6 spec section N.2.4.4.1), or at least the error type,
>> address, etc. So that the userspace (such as rasdaemon tool) could know what
>> error occurred.
>
> This is something I am planning on adding in later. It is not clear to me how to
> actually do this at this point. If you look at the spec, there is not a single
> error information structure. There is at least one, but possibly a lot. There is
> also an unknown amount of context information structures. In "Table 260. ARM Processor
> Error Section" there are ERR_INFO_NUM and CONTEXT_INFO_NUM which give the number of these
> structures. I think there will need to be separate trace events added in for each of
> these structures because I don't think there is a way to have variable amounts of
> structures inside of a trace event.

Yes, I agree.

Additional, cper_sec_proc_arm has validation bit, which indicates whether or not each of
the fields is valid in this section. How could we show it in this trace event? If the filed
is invalid, we would get a wrong value here.

--
Thanks,
Xie XiuQi

> 
> The ARM processor error section also has a vendor specific error info buffer which will need to be exposed to userspace. This may be something that can reuse the unknown section type trace event or have it's own trace event for.
> 
> Thanks,
> Tyler
> 
