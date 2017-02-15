From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V9 09/10] trace, ras: add ARM processor error trace event
Date: Wed, 15 Feb 2017 10:51:43 -0700
Message-ID: <6421d298-0497-1a2c-7aa2-c53e4bc4a466@codeaurora.org>
References: <1487180692-16732-1-git-send-email-tbaicar@codeaurora.org>
 <1487180692-16732-10-git-send-email-tbaicar@codeaurora.org>
 <20170215124743.68343176@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20170215124743.68343176@gandalf.local.home>
Sender: linux-acpi-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org, devel@acpica.org, S
List-Id: linux-efi@vger.kernel.org

On 2/15/2017 10:47 AM, Steven Rostedt wrote:
> On Wed, 15 Feb 2017 10:44:51 -0700
> Tyler Baicar <tbaicar@codeaurora.org> wrote:
>
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
>>
>> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
>> index be365e2..560a172 100644
>> --- a/drivers/acpi/apei/ghes.c
>> +++ b/drivers/acpi/apei/ghes.c
>> @@ -514,7 +514,13 @@ static void ghes_do_proc(struct ghes *ghes,
>>   		}
>>   #endif
>>   #ifdef CONFIG_RAS
>> -		else if(trace_unknown_sec_event_enabled()) {
>> +		else if (!uuid_le_cmp(sec_type, CPER_SEC_PROC_ARM) &&
>> +			 trace_arm_event_enabled()) {
>> +			struct cper_sec_proc_arm *arm_err;
>> +
>> +			arm_err = acpi_hest_generic_data_payload(gdata);
>> +			trace_arm_event(arm_err);
>> +		} else if(trace_unknown_sec_event_enabled()) {
> I think you want a space between "if" and "("
>
> -- Steve
Oops :) I'll add that in.
>>   			void *unknown_err = acpi_hest_generic_data_payload(gdata);
>>   			trace_unknown_sec_event(&sec_type,
>>   					fru_id, fru_text, sec_sev,

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.

