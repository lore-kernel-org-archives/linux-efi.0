From: "Baicar, Tyler" <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH V8 06/10] acpi: apei: panic OS with fatal error status
 block
Date: Mon, 13 Feb 2017 15:45:44 -0700
Message-ID: <5b06372d-e389-5157-ccb4-a7b023990d4d@codeaurora.org>
References: <1485969413-23577-1-git-send-email-tbaicar@codeaurora.org>
 <1485969413-23577-7-git-send-email-tbaicar@codeaurora.org>
 <589C490A.9080109@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <589C490A.9080109-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
Cc: christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, eun.taik.lee-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, sandeepa.s.prabhu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, shijie.huang-5wv7dgnIgG8@public.gmane.org, rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, tn-nYOzD4b6Jr9Wk0Htik3J/w@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-E0kO6a4B6psdnm+yROfE0A@public.gmane.org, Suzuki.Poulose-5wv7dgnIgG8@public.gmane.org, punit.agr
List-Id: linux-efi@vger.kernel.org

Hello James,


On 2/9/2017 3:48 AM, James Morse wrote:
> Hi Jonathan, Tyler,
>
> On 01/02/17 17:16, Tyler Baicar wrote:
>> From: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>>
>> Even if an error status block's severity is fatal, the kernel does not
>> honor the severity level and panic.
>>
>> With the firmware first model, the platform could inform the OS about a
>> fatal hardware error through the non-NMI GHES notification type. The OS
>> should panic when a hardware error record is received with this
>> severity.
>>
>> Call panic() after CPER data in error status block is printed if
>> severity is fatal, before each error section is handled.
>> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
>> index 8756172..86c1f15 100644
>> --- a/drivers/acpi/apei/ghes.c
>> +++ b/drivers/acpi/apei/ghes.c
>> @@ -687,6 +689,13 @@ static int ghes_ack_error(struct acpi_hest_generic_v2 *generic_v2)
>>   	return rc;
>>   }
>>   
>> +static void __ghes_call_panic(void)
>> +{
>> +	if (panic_timeout == 0)
>> +		panic_timeout = ghes_panic_timeout;
>> +	panic("Fatal hardware error!");
>> +}
>> +
> __ghes_panic() also has:
>> 	__ghes_print_estatus(KERN_EMERG, ghes->generic, ghes->estatus);
> Which prints this estatus regardless of rate limiting and cache-ing.
>
> [ ... ]
>
>> @@ -698,6 +707,10 @@ static int ghes_proc(struct ghes *ghes)
>>   		if (ghes_print_estatus(NULL, ghes->generic, ghes->estatus))
> ghes_print_estatus() uses some custom rate limiting '2 messages every 5
> seconds', GHES_SEV_PANIC shares the same limit as GHES_SEV_RECOVERABLE.
>
> I think its possible to get 2 recoverable messages, then a panic in a 5 second
> window. The rate limit will kick in to stop the panic estatus block being
> printed, but we still go on to call panic() without the real reason being printed...
>
> (the caching thing only seems to consider identical messages, given we would
> never see two panic messages, I don't think that will cause any problems.)
>
>>   			ghes_estatus_cache_add(ghes->generic, ghes->estatus);
>>   	}
>> +	if (ghes_severity(ghes->estatus->error_severity) >= GHES_SEV_PANIC) {
>> +		__ghes_call_panic();
>> +	}
>> +
> I think this ghes_severity() then panic() should go above the:
>> 	if (!ghes_estatus_cached(ghes->estatus)) {
> and we should call __ghes_print_estatus() here too, to make sure the message
> definitely got out!
Okay, that makes sense. If we move this up, is there a problem with 
calling __ghes_panic() instead of making the __ghes_print_estatus() and 
__ghes_call_panic() calls here? It looks like that will just add a call 
to oops_begin() and ghes_print_queued_estatus() as well, but this is 
what ghes_notify_nmi() does if the severity is panic.

Thanks,
Tyler
> With that,
> Reviewed-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
>
>
> Thanks,
>
> James

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
