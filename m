From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V8 08/10] ras: acpi / apei: generate trace event for
 unrecognized CPER section
Date: Wed, 15 Feb 2017 09:54:09 -0700
Message-ID: <e50b7673-a441-3a6b-cf75-c267881c1a92@codeaurora.org>
References: <1485969413-23577-1-git-send-email-tbaicar@codeaurora.org>
 <1485969413-23577-9-git-send-email-tbaicar@codeaurora.org>
 <20170215105234.4921db1f@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <20170215105234.4921db1f@gandalf.local.home>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-efi@vger.kernel.org, kvm@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, zjzhang@codeaurora.org, linux@armlinux.org.uk, linux-acpi@vger.kernel.org, eun.taik.lee@samsung.com, shijie.huang@arm.com, labbott@redhat.com, lenb@kernel.org, harba@codeaurora.org, john.garry@huawei.com, marc.zyngier@arm.com, punit.agrawal@arm.com, nkaje@codeaurora.org, sandeepa.s.prabhu@gmail.com, linux-arm-kernel@lists.infradead.org, devel@acpica.org, rjw@rjwysocki.net, rruigrok@codeaurora.org, linux-kernel@vger.kernel.org, astone@redhat.com, hanjun.guo@linaro.org, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com, shiju.jose@huawei.com
List-Id: linux-efi@vger.kernel.org

On 2/15/2017 8:52 AM, Steven Rostedt wrote:
> On Wed,  1 Feb 2017 10:16:51 -0700
> Tyler Baicar <tbaicar@codeaurora.org> wrote:
>
>> @@ -452,11 +454,21 @@ static void ghes_do_proc(struct ghes *ghes,
>>   {
>>   	int sev, sec_sev;
>>   	struct acpi_hest_generic_data *gdata;
>> +	uuid_le sec_type;
>> +	uuid_le *fru_id = &NULL_UUID_LE;
>> +	char *fru_text = "";
>>   
>>   	sev = ghes_severity(estatus->error_severity);
>>   	apei_estatus_for_each_section(estatus, gdata) {
>>   		sec_sev = ghes_severity(gdata->error_severity);
>> -		if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
>> +		sec_type = *(uuid_le *)gdata->section_type;
>> +
>> +		if (gdata->validation_bits & CPER_SEC_VALID_FRU_ID)
>> +			fru_id = (uuid_le *)gdata->fru_id;
>> +		if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
>> +			fru_text = gdata->fru_text;
>> +
>> +		if (!uuid_le_cmp(sec_type,
>>   				 CPER_SEC_PLATFORM_MEM)) {
>>   			struct cper_sec_mem_err *mem_err;
>>   
>> @@ -467,7 +479,7 @@ static void ghes_do_proc(struct ghes *ghes,
>>   			ghes_handle_memory_failure(gdata, sev);
>>   		}
>>   #ifdef CONFIG_ACPI_APEI_PCIEAER
>> -		else if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
>> +		else if (!uuid_le_cmp(sec_type,
>>   				      CPER_SEC_PCIE)) {
>>   			struct cper_sec_pcie *pcie_err;
>>   
>> @@ -500,6 +512,12 @@ static void ghes_do_proc(struct ghes *ghes,
>>   
>>   		}
>>   #endif
>> +		else {
> As an optimization, you can add:
>
> 		else if (trace_unknown_sec_event_enabled()) {
>
> instead, as then this wont be called unless the tracepoint is
> activated. Will keep the logic from doing anything with
> acpi_hest_generic_data_payload().
>
> Note, that trace_*_enabled() is activated via a jump_label, thus
> there's no branches involved.
>
> -- Steve
Hello Steve,

In v9 I currently have this and the ARM trace event from this series 
both wrapped in an
ifdef verifying that CONFIG_RAS is enabled. This resolves the kbuild 
failures and
will have this code compiled out when that config isn't enabled. Do you 
think I
should use the ifdef or use these *_enabled() functions?

Thanks,
Tyler
>> +			void *unknown_err = acpi_hest_generic_data_payload(gdata);
>> +			trace_unknown_sec_event(&sec_type,
>> +					fru_id, fru_text, sec_sev,
>> +					unknown_err, gdata->error_data_length);
>> +		}
>>   	}
>>   }
>>   
>>

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
