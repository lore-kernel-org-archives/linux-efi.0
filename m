From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V3 08/10] ras: acpi / apei: generate trace event for
 unrecognized CPER section
Date: Thu, 13 Oct 2016 14:15:48 -0600
Message-ID: <6d0637b2-3ed5-1392-601d-3cbffd26026a@codeaurora.org>
References: <1475875882-2604-1-git-send-email-tbaicar@codeaurora.org>
 <1475875882-2604-9-git-send-email-tbaicar@codeaurora.org>
 <87mvi8seng.fsf@e105922-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
In-Reply-To: <87mvi8seng.fsf@e105922-lin.cambridge.arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Punit Agrawal <punit.agrawal@arm.com>
Cc: linux-efi@vger.kernel.org, matt@codeblueprint.co.uk, catalin.marinas@arm.com, will.deacon@arm.com, robert.moore@intel.com, paul.gortmaker@windriver.com, lv.zheng@intel.com, kvmarm@lists.cs.columbia.edu, fu.wei@linaro.org, "Jonathan (Zhixiong) Zhang" <zjzhang@codeaurora.org>, linux@armlinux.org.uk, linux-acpi@vger.kernel.org, shijie.huang@arm.com, lenb@kernel.org, marc.zyngier@arm.com, tomasz.nowicki@linaro.org, rostedt@goodmis.org, sandeepa.s.prabhu@gmail.com, Dkvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, devel@acpica.org, rjw@rjwysocki.net, linux-kernel@vger.kernel.org, pbonzini@redhat.com, akpm@linux-foundation.org, bristot@redhat.com
List-Id: linux-efi@vger.kernel.org

Hello Punit,

On 10/13/2016 4:54 AM, Punit Agrawal wrote:
> Hi Tyler,
>
> One last comment...
>
> Tyler Baicar <tbaicar@codeaurora.org> writes:
>
>> UEFI spec allows for non-standard section in Common Platform Error
>> Record. This is defined in section N.2.3 of UEFI version 2.5.
>>
>> Currently if the CPER section's type (UUID) does not match with
>> any section type that the kernel knows how to parse, trace event
>> is not generated for such section. And thus user is not able to know
>> happening of such hardware error, including error record of
>> non-standard section.
>>
>> This commit generates a trace event which contains raw error data
>> for unrecognized CPER section.
>>
>> Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
>> Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
>> ---
>>   drivers/acpi/apei/ghes.c | 18 +++++++++++++++++-
>>   drivers/ras/ras.c        |  1 +
>>   include/ras/ras_event.h  | 45 +++++++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 63 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
>> index 36894c8..cb4c7f4 100644
>> --- a/drivers/acpi/apei/ghes.c
>> +++ b/drivers/acpi/apei/ghes.c
>> @@ -49,6 +49,7 @@
>>   #include <acpi/ghes.h>
>>   #include <acpi/apei.h>
>>   #include <asm/tlbflush.h>
>> +#include <ras/ras_event.h>
>>   
>>   #ifdef CONFIG_HAVE_ACPI_APEI_SEA
>>   #include <asm/system_misc.h>
>> @@ -468,12 +469,21 @@ static void ghes_do_proc(struct ghes *ghes,
>>   	int sev, sec_sev;
>>   	struct acpi_hest_generic_data *gdata;
>>   	uuid_le sec_type;
>> +	uuid_le *fru_id;
>> +	char *fru_text = "";
>>   
>>   	sev = ghes_severity(estatus->error_severity);
>>   	apei_estatus_for_each_section(estatus, gdata) {
>>   		sec_sev = ghes_severity(gdata->error_severity);
>>   		sec_type = *(uuid_le *)gdata->section_type;
>>   
>> +		if (gdata->validation_bits & CPER_SEC_VALID_FRU_ID)
>> +			fru_id = (uuid_le *)gdata->fru_id;
>> +		else
>> +			fru_id = &NULL_UUID_LE;
> fru_id can be initialised at declaration and drop the else here. The
> same is already being done for fru_text.
Yes, I will make this change in the next version.

Thanks,
Tyler
> Thanks,
> Punit
>
>> +		if (gdata->validation_bits & CPER_SEC_VALID_FRU_TEXT)
>> +			fru_text = gdata->fru_text;
>> +
>>   		if (!uuid_le_cmp(sec_type,
>>   				 CPER_SEC_PLATFORM_MEM)) {
>>   			struct cper_sec_mem_err *mem_err;
> [...]
>

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
