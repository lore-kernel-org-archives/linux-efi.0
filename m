From: "Baicar, Tyler" <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH V14 02/10] ras: acpi/apei: cper: generic error data entry
 v3 per ACPI 6.1
Date: Thu, 13 Apr 2017 14:30:21 -0600
Message-ID: <8a31ef45-68f6-d444-f174-4a485cccd696@codeaurora.org>
References: <1490729440-32591-1-git-send-email-tbaicar@codeaurora.org>
 <1490729440-32591-3-git-send-email-tbaicar@codeaurora.org>
 <20170412133447.n2yft7v266v6k6gh@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170412133447.n2yft7v266v6k6gh-fF5Pk5pvG8Y@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: christoffer.dall-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, marc.zyngier-5wv7dgnIgG8@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, james.morse-5wv7dgnIgG8@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, eun.taik.lee-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, sandeepa.s.prabhu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, shijie.huang-5wv7dgnIgG8@public.gmane.org, rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, tn-nYOzD4b6Jr9Wk0Htik3J/w@public.gmane.org, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, kvmarm-FPEHb7Xf0XXUo1n7N8X6UoWGPAHP3yOg@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 4/12/2017 7:34 AM, Borislav Petkov wrote:
>> Subject: [PATCH V14 02/10] ras: acpi/apei: cper: generic error data entry v3 per ACPI 6.1
> Use a verb in your patch subjects: "Add support for ..." or so.
Hello Boris,

Will do in the next version.
>
> On Tue, Mar 28, 2017 at 01:30:32PM -0600, Tyler Baicar wrote:
>> Currently when a RAS error is reported it is not timestamped.
> What is a RAS error? You mean a hardware error?
Will change to hardware error.
>
>> The ACPI 6.1 spec adds the timestamp field to the generic error
>> data entry v3 structure. The timestamp of when the firmware
>> generated the error is now being reported.
> So what this patch does doesn't have a lot to to do with the Subject?
> Please state what the patch does in the Subject.
I'll change the wording to describe it better.
>
> Also, your commit message talks about adding timestamp but the patch
> does more. You need to state that too and explain what this patch does
> actually.
I'll break this up into two patches as you suggest below so that this 
only adds the timestamp and the new patch adds the helper defines and usage.
>> Signed-off-by: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>> CC: Jonathan (Zhixiong) Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>> Reviewed-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
>> Reviewed-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>   drivers/acpi/apei/ghes.c    |  9 ++++---
>>   drivers/firmware/efi/cper.c | 63 +++++++++++++++++++++++++++++++++++----------
>>   include/acpi/ghes.h         | 22 ++++++++++++++++
>>   3 files changed, 77 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
>> index 0241e36..9ddbb93 100644
>> --- a/drivers/acpi/apei/ghes.c
>> +++ b/drivers/acpi/apei/ghes.c
>> @@ -421,7 +421,8 @@ static void ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata, int
>>   	int flags = -1;
>>   	int sec_sev = ghes_severity(gdata->error_severity);
>>   	struct cper_sec_mem_err *mem_err;
>> -	mem_err = (struct cper_sec_mem_err *)(gdata + 1);
>> +
>> +	mem_err = acpi_hest_generic_data_payload(gdata);
>>   
>>   	if (!(mem_err->validation_bits & CPER_MEM_VALID_PA))
>>   		return;
>> @@ -458,7 +459,8 @@ static void ghes_do_proc(struct ghes *ghes,
>>   		if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
>>   				 CPER_SEC_PLATFORM_MEM)) {
>>   			struct cper_sec_mem_err *mem_err;
>> -			mem_err = (struct cper_sec_mem_err *)(gdata+1);
>> +
>> +			mem_err = acpi_hest_generic_data_payload(gdata);
>>   			ghes_edac_report_mem_error(ghes, sev, mem_err);
>>   
>>   			arch_apei_report_mem_error(sev, mem_err);
>> @@ -468,7 +470,8 @@ static void ghes_do_proc(struct ghes *ghes,
>>   		else if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
>>   				      CPER_SEC_PCIE)) {
>>   			struct cper_sec_pcie *pcie_err;
>> -			pcie_err = (struct cper_sec_pcie *)(gdata+1);
>> +
>> +			pcie_err = acpi_hest_generic_data_payload(gdata);
>>   			if (sev == GHES_SEV_RECOVERABLE &&
>>   			    sec_sev == GHES_SEV_RECOVERABLE &&
>>   			    pcie_err->validation_bits & CPER_PCIE_VALID_DEVICE_ID &&
>> diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
>> index d425374..8fa4e23 100644
>> --- a/drivers/firmware/efi/cper.c
>> +++ b/drivers/firmware/efi/cper.c
>> @@ -32,6 +32,9 @@
>>   #include <linux/acpi.h>
>>   #include <linux/pci.h>
>>   #include <linux/aer.h>
>> +#include <linux/printk.h>
>> +#include <linux/bcd.h>
>> +#include <acpi/ghes.h>
>>   
>>   #define INDENT_SP	" "
>>   
>> @@ -386,13 +389,37 @@ static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
>>   	pfx, pcie->bridge.secondary_status, pcie->bridge.control);
>>   }
>>   
>> +static void cper_estatus_print_section_v300(const char *pfx,
>> +	const struct acpi_hest_generic_data_v300 *gdata)
> Yuck, acpi_hest_generic_data_v300. Can we make those struct names smaller pls?
> And v300 is just silly.
>
> And then align args at opening brace.
Will do.
>
>> +{
>> +	__u8 hour, min, sec, day, mon, year, century, *timestamp;
>> +
>> +	if (gdata->validation_bits & ACPI_HEST_GEN_VALID_TIMESTAMP) {
>> +		timestamp = (__u8 *)&(gdata->time_stamp);
>> +		sec = bcd2bin(timestamp[0]);
>> +		min = bcd2bin(timestamp[1]);
>> +		hour = bcd2bin(timestamp[2]);
>> +		day = bcd2bin(timestamp[4]);
>> +		mon = bcd2bin(timestamp[5]);
>> +		year = bcd2bin(timestamp[6]);
>> +		century = bcd2bin(timestamp[7]);
> Align those vertically on the = sign.
Will do.
>
>> +		printk("%stime: %7s %02d%02d-%02d-%02d %02d:%02d:%02d\n", pfx,
>> +			0x01 & *(timestamp + 3) ? "precise" : "",
> Move that test in a separate if-statement - that printk is unreadable as
> it is. Also, the test bit always comes second.
Will do.
>> 			century,
>> +			year, mon, day, hour, min, sec);
>> +	}
>> +}
>> +
>>   static void cper_estatus_print_section(
>> -	const char *pfx, const struct acpi_hest_generic_data *gdata, int sec_no)
>> +	const char *pfx, struct acpi_hest_generic_data *gdata, int sec_no)
> static void
> cper_estatus_print_section(const char *pfx, struct acpi_hest_generic_data *gdata,
> 			   int sec_no)
>
> looks much better.
All I did here was remove the const, but will do.
>>   {
>>   	uuid_le *sec_type = (uuid_le *)gdata->section_type;
>>   	__u16 severity;
>>   	char newpfx[64];
>>   
>> +	if (acpi_hest_generic_data_version(gdata) >= 3)
> Jeez, that macro name is like a one-lined book!
>
> Let's make that "hest_gdata_ver()" or something else shorter.
As Joe mentioned, acpi_hest_generic<foo> is already used throughout this 
code base. I do not see the value in varying from the preexisting naming 
style.
>
>> +		cper_estatus_print_section_v300(pfx,
>> +			(const struct acpi_hest_generic_data_v300 *)gdata);
>> +
>>   	severity = gdata->error_severity;
>>   	printk("%s""Error %d, type: %s\n", pfx, sec_no,
>>   	       cper_severity_str(severity));
>> @@ -403,14 +430,18 @@ static void cper_estatus_print_section(
>>   
>>   	snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
>>   	if (!uuid_le_cmp(*sec_type, CPER_SEC_PROC_GENERIC)) {
>> -		struct cper_sec_proc_generic *proc_err = (void *)(gdata + 1);
>> +		struct cper_sec_proc_generic *proc_err;
>> +
>> +		proc_err = acpi_hest_generic_data_payload(gdata);
> This looks like an unrelated change. The payload function addition and the
> conversion of the code to use it should be a separate patch. And shorten that
> function name too pls.
I'll break this into two patches.
>
>>   		printk("%s""section_type: general processor error\n", newpfx);
>>   		if (gdata->error_data_length >= sizeof(*proc_err))
>>   			cper_print_proc_generic(newpfx, proc_err);
>>   		else
>>   			goto err_section_too_small;
>>   	} else if (!uuid_le_cmp(*sec_type, CPER_SEC_PLATFORM_MEM)) {
>> -		struct cper_sec_mem_err *mem_err = (void *)(gdata + 1);
>> +		struct cper_sec_mem_err *mem_err;
>> +
>> +		mem_err = acpi_hest_generic_data_payload(gdata);
>>   		printk("%s""section_type: memory error\n", newpfx);
>>   		if (gdata->error_data_length >=
>>   		    sizeof(struct cper_sec_mem_err_old))
>> @@ -419,7 +450,9 @@ static void cper_estatus_print_section(
>>   		else
>>   			goto err_section_too_small;
>>   	} else if (!uuid_le_cmp(*sec_type, CPER_SEC_PCIE)) {
>> -		struct cper_sec_pcie *pcie = (void *)(gdata + 1);
>> +		struct cper_sec_pcie *pcie;
>> +
>> +		pcie = acpi_hest_generic_data_payload(gdata);
>>   		printk("%s""section_type: PCIe error\n", newpfx);
>>   		if (gdata->error_data_length >= sizeof(*pcie))
>>   			cper_print_pcie(newpfx, pcie, gdata);
>> @@ -438,7 +471,7 @@ void cper_estatus_print(const char *pfx,
>>   			const struct acpi_hest_generic_status *estatus)
>>   {
>>   	struct acpi_hest_generic_data *gdata;
>> -	unsigned int data_len, gedata_len;
>> +	unsigned int data_len;
>>   	int sec_no = 0;
>>   	char newpfx[64];
>>   	__u16 severity;
>> @@ -451,12 +484,13 @@ void cper_estatus_print(const char *pfx,
>>   	printk("%s""event severity: %s\n", pfx, cper_severity_str(severity));
>>   	data_len = estatus->data_length;
>>   	gdata = (struct acpi_hest_generic_data *)(estatus + 1);
>> +
>>   	snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
>> -	while (data_len >= sizeof(*gdata)) {
>> -		gedata_len = gdata->error_data_length;
>> +
>> +	while (data_len >= acpi_hest_generic_data_size(gdata)) {
>>   		cper_estatus_print_section(newpfx, gdata, sec_no);
>> -		data_len -= gedata_len + sizeof(*gdata);
>> -		gdata = (void *)(gdata + 1) + gedata_len;
>> +		data_len -= acpi_hest_generic_data_record_size(gdata);
>> +		gdata = acpi_hest_generic_data_next(gdata);
>>   		sec_no++;
>>   	}
>>   }
>> @@ -486,12 +520,13 @@ int cper_estatus_check(const struct acpi_hest_generic_status *estatus)
>>   		return rc;
>>   	data_len = estatus->data_length;
>>   	gdata = (struct acpi_hest_generic_data *)(estatus + 1);
>> -	while (data_len >= sizeof(*gdata)) {
>> -		gedata_len = gdata->error_data_length;
>> -		if (gedata_len > data_len - sizeof(*gdata))
>> +
>> +	while (data_len >= acpi_hest_generic_data_size(gdata)) {
>> +		gedata_len = acpi_hest_generic_data_error_length(gdata);
>> +		if (gedata_len > data_len - acpi_hest_generic_data_size(gdata))
>>   			return -EINVAL;
>> -		data_len -= gedata_len + sizeof(*gdata);
>> -		gdata = (void *)(gdata + 1) + gedata_len;
>> +		data_len -= gedata_len + acpi_hest_generic_data_size(gdata);
>> +		gdata = acpi_hest_generic_data_next(gdata);
>>   	}
>>   	if (data_len)
>>   		return -EINVAL;
>> diff --git a/include/acpi/ghes.h b/include/acpi/ghes.h
>> index 68f088a..6ae318b 100644
>> --- a/include/acpi/ghes.h
>> +++ b/include/acpi/ghes.h
>> @@ -12,6 +12,18 @@
>>   #define GHES_TO_CLEAR		0x0001
>>   #define GHES_EXITING		0x0002
>>   
>> +#define acpi_hest_generic_data_error_length(gdata)	\
>> +	(((struct acpi_hest_generic_data *)(gdata))->error_data_length)
>> +#define acpi_hest_generic_data_size(gdata)		\
>> +	((acpi_hest_generic_data_version(gdata) >= 3) ?	\
>> +	sizeof(struct acpi_hest_generic_data_v300) :	\
>> +	sizeof(struct acpi_hest_generic_data))
>> +#define acpi_hest_generic_data_record_size(gdata)	\
>> +	(acpi_hest_generic_data_size(gdata) +		\
>> +	acpi_hest_generic_data_error_length(gdata))
>> +#define acpi_hest_generic_data_next(gdata)		\
>> +	((void *)(gdata) + acpi_hest_generic_data_record_size(gdata))
> This is one unreadable pile of too long names with a clearly redundant
> and too long prefix. Please shorten it all.
>
>> +
>>   struct ghes {
>>   	union {
>>   		struct acpi_hest_generic *generic;
>> @@ -73,3 +85,13 @@ static inline void ghes_edac_unregister(struct ghes *ghes)
>>   {
>>   }
>>   #endif
>> +
>> +#define acpi_hest_generic_data_version(gdata)			\
>> +	(gdata->revision >> 8)
>> +
>> +static inline void *acpi_hest_generic_data_payload(struct acpi_hest_generic_data *gdata)
> Lemme try to shorten it:
>
> static inline void *acpi_hest_get_payload(struct acpi_hest_gdata *d)
> {
> 	if (hest_gdata_ver(d) >= 3)
> 		return (void *)(((struct acpi_hest_gdata_v3 *)d) + 1);
> 	else
> 		return d + 1;
> }
>
> Now this is much more readable IMO. You can actually see what's going
> on. And you still know what the struct names are.
>
> So let's drop all that unnecessary too long prefixing and make the
> code readable. That cper thing needs a lot more scrubbing, of course,
> but some other day.
I do not agree with this. The struct being passed to this function is 
already named acpi_hest_generic_data in the existing code and all over 
this code is named gdata not just d.

Also, these helpers already helped this code be significantly more 
readable. They were added in version 4 of this series to reduce code 
duplication and make iterating over the generic data entries readable. 
https://lkml.org/lkml/2016/10/11/454

Thanks,
Tyler

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
