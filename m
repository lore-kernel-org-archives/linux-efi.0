From: "Baicar, Tyler" <tbaicar@codeaurora.org>
Subject: Re: [PATCH V14 03/10] efi: parse ARM processor error
Date: Thu, 13 Apr 2017 14:32:17 -0600
Message-ID: <c11b8966-f11d-38f9-044c-60a410feb7c8@codeaurora.org>
References: <1490729440-32591-1-git-send-email-tbaicar@codeaurora.org>
 <1490729440-32591-4-git-send-email-tbaicar@codeaurora.org>
 <20170412165125.xzsovuficgbygkfp@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170412165125.xzsovuficgbygkfp@pd.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com, pbonzini@redhat.com, rkrcmar@redhat.com, linux@armlinux.org.uk, catalin.marinas@arm.com, will.deacon@arm.com, rjw@rjwysocki.net, lenb@kernel.org, matt@codeblueprint.co.uk, robert.moore@intel.com, lv.zheng@intel.com, nkaje@codeaurora.org, zjzhang@codeaurora.org, mark.rutland@arm.com, james.morse@arm.com, akpm@linux-foundation.org, eun.taik.lee@samsung.com, sandeepa.s.prabhu@gmail.com, labbott@redhat.com, shijie.huang@arm.com, rruigrok@codeaurora.org, paul.gortmaker@windriver.com, tn@semihalf.com, fu.wei@linaro.org, rostedt@goodmis.org, bristot@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 4/12/2017 10:51 AM, Borislav Petkov wrote:
> On Tue, Mar 28, 2017 at 01:30:33PM -0600, Tyler Baicar wrote:
>> Add support for ARM Common Platform Error Record (CPER).
>> UEFI 2.6 specification adds support for ARM specific
>> processor error information to be reported as part of the
>> CPER records. This provides more detail on for processor error logs.
>>
>> Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
>> CC: Jonathan (Zhixiong) Zhang <zjzhang@codeaurora.org>
>> Reviewed-by: James Morse <james.morse@arm.com>
>> Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> ---
>>   drivers/firmware/efi/cper.c | 133 ++++++++++++++++++++++++++++++++++++++++++++
>>   include/linux/cper.h        |  54 ++++++++++++++++++
>>   2 files changed, 187 insertions(+)
>>
>> diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
>> index 8fa4e23..56aa516 100644
>> --- a/drivers/firmware/efi/cper.c
>> +++ b/drivers/firmware/efi/cper.c
>> @@ -110,12 +110,15 @@ void cper_print_bits(const char *pfx, unsigned int bits,
>>   static const char * const proc_type_strs[] = {
>>   	"IA32/X64",
>>   	"IA64",
>> +	"ARM",
>>   };
>>   
>>   static const char * const proc_isa_strs[] = {
>>   	"IA32",
>>   	"IA64",
>>   	"X64",
>> +	"ARM A32/T32",
>> +	"ARM A64",
>>   };
>>   
>>   static const char * const proc_error_type_strs[] = {
>> @@ -139,6 +142,18 @@ void cper_print_bits(const char *pfx, unsigned int bits,
>>   	"corrected",
>>   };
>>   
>> +static const char * const arm_reg_ctx_strs[] = {
>> +	"AArch32 general purpose registers",
>> +	"AArch32 EL1 context registers",
>> +	"AArch32 EL2 context registers",
>> +	"AArch32 secure context registers",
>> +	"AArch64 general purpose registers",
>> +	"AArch64 EL1 context registers",
>> +	"AArch64 EL2 context registers",
>> +	"AArch64 EL3 context registers",
>> +	"Misc. system register structure",
>> +};
> That...
>
>> +
>>   static void cper_print_proc_generic(const char *pfx,
>>   				    const struct cper_sec_proc_generic *proc)
>>   {
>> @@ -184,6 +199,114 @@ static void cper_print_proc_generic(const char *pfx,
>>   		printk("%s""IP: 0x%016llx\n", pfx, proc->ip);
>>   }
>>   
>> +static void cper_print_proc_arm(const char *pfx,
>> +				const struct cper_sec_proc_arm *proc)
> ... and that function should go into:
>
> #if defined(CONFIG_ARM64) || defined(CONFIG_ARM)
>
> Just put them close together so that you don't have too much ifdeffery.
Hello Boris,

I will move them close together and add the ifdef.

Thanks,
Tyler

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
