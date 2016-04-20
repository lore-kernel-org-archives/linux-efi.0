From: "Baicar, Tyler" <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH V2 2/9] ras: acpi/apei: cper: generic error data entry v3
 per ACPI 6.1
Date: Wed, 20 Apr 2016 15:25:23 -0600
Message-ID: <5717F3C3.60102@codeaurora.org>
References: <1459955578-24602-1-git-send-email-tbaicar@codeaurora.org>
 <1459955578-24602-3-git-send-email-tbaicar@codeaurora.org>
 <570F6F76.3060804@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <570F6F76.3060804-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suzuki K Poulose <Suzuki.Poulose-5wv7dgnIgG8@public.gmane.org>, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, harba-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, ahs3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-E0kO6a4B6psdnm+yROfE0A@public.gmane.org
Cc: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Naveen Kaje <nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hello Suzuki,

On 4/14/2016 4:22 AM, Suzuki K Poulose wrote:
> On 06/04/16 16:12, Tyler Baicar wrote:
>> Currently when a RAS error is reported it is not timestamped.
>> The ACPI 6.1 spec adds the timestamp field to the generic error
>> data entry v3 structure. The timestamp of when the firmware
>> generated the error is now being reported.
>>
>> Signed-off-by: Jonathan (Zhixiong) Zhang <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>> Signed-off-by: Richard Ruigrok <rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>> Signed-off-by: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>> Signed-off-by: Naveen Kaje <nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>> ---
>>   drivers/acpi/apei/ghes.c    |  35 ++++++++++++--
>>   drivers/firmware/efi/cper.c | 111 
>> +++++++++++++++++++++++++++++++++++++-------
>>   2 files changed, 126 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
>> index 9b0543e..a6848706 100644
>> --- a/drivers/acpi/apei/ghes.c
>> +++ b/drivers/acpi/apei/ghes.c
>> @@ -419,7 +419,15 @@ static void ghes_handle_memory_failure(struct 
>> acpi_hest_generic_data *gdata, int
>>       int flags = -1;
>>       int sec_sev = ghes_severity(gdata->error_severity);
>>       struct cper_sec_mem_err *mem_err;
>> -    mem_err = (struct cper_sec_mem_err *)(gdata + 1);
>> +    struct acpi_hest_generic_data_v300 *gdata_v3 = NULL;
>> +
>> +    if ((gdata->revision >> 8) >= 0x03)
>
> Could we please make that a macro ? We seem to be using the check 
> everywhere.
Yes, I can make this a macro since we do this several times.
>
>> +        gdata_v3 = (struct acpi_hest_generic_data_v300 *)gdata;
>> +
>> +    if (gdata_v3)
>> +        mem_err = (struct cper_sec_mem_err *)(gdata_v3 + 1);
>> +    else
>> +        mem_err = (struct cper_sec_mem_err *)(gdata + 1);
>>
>>       if (!(mem_err->validation_bits & CPER_MEM_VALID_PA))
>>           return;
>> @@ -449,14 +457,27 @@ static void ghes_do_proc(struct ghes *ghes,
>>   {
>>       int sev, sec_sev;
>>       struct acpi_hest_generic_data *gdata;
>> +    struct acpi_hest_generic_data_v300 *gdata_v3 = NULL;
>> +    uuid_le sec_type;
>>
>>       sev = ghes_severity(estatus->error_severity);
>>       apei_estatus_for_each_section(estatus, gdata) {
>>           sec_sev = ghes_severity(gdata->error_severity);
>> -        if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
>> +        sec_type = *(uuid_le *)gdata->section_type;
>> +
>> +        if ((gdata->revision >> 8) >= 0x03)
>> +            gdata_v3 = (struct acpi_hest_generic_data_v300 *)gdata;
>> +
>> +        if (!uuid_le_cmp(sec_type,
>>                    CPER_SEC_PLATFORM_MEM)) {
>>               struct cper_sec_mem_err *mem_err;
>> -            mem_err = (struct cper_sec_mem_err *)(gdata+1);
>> +
>> +            if (gdata_v3)
>> +                mem_err = (struct cper_sec_mem_err *)
>> +                      (gdata_v3 + 1);
>> +            else
>> +                mem_err = (struct cper_sec_mem_err *)
>> +                      (gdata + 1);
>>               ghes_edac_report_mem_error(ghes, sev, mem_err);
>>
>>               arch_apei_report_mem_error(sev, mem_err);
>> @@ -466,7 +487,13 @@ static void ghes_do_proc(struct ghes *ghes,
>>           else if (!uuid_le_cmp(*(uuid_le *)gdata->section_type,
>>                         CPER_SEC_PCIE)) {
>>               struct cper_sec_pcie *pcie_err;
>> -            pcie_err = (struct cper_sec_pcie *)(gdata+1);
>> +
>> +            if (gdata_v3)
>> +                pcie_err = (struct cper_sec_pcie *)
>> +                       (gdata_v3 + 1);
>> +            else
>> +                pcie_err = (struct cper_sec_pcie *)
>> +                       (gdata + 1);
>>               if (sev == GHES_SEV_RECOVERABLE &&
>>                   sec_sev == GHES_SEV_RECOVERABLE &&
>>                   pcie_err->validation_bits & 
>> CPER_PCIE_VALID_DEVICE_ID &&
>> diff --git a/drivers/firmware/efi/cper.c b/drivers/firmware/efi/cper.c
>> index d425374..23f62962 100644
>> --- a/drivers/firmware/efi/cper.c
>> +++ b/drivers/firmware/efi/cper.c
>> @@ -32,6 +32,8 @@
>>   #include <linux/acpi.h>
>>   #include <linux/pci.h>
>>   #include <linux/aer.h>
>> +#include <linux/printk.h>
>> +#include <linux/bcd.h>
>>
>>   #define INDENT_SP    " "
>>
>> @@ -392,6 +394,10 @@ static void cper_estatus_print_section(
>>       uuid_le *sec_type = (uuid_le *)gdata->section_type;
>>       __u16 severity;
>>       char newpfx[64];
>> +    struct acpi_hest_generic_data_v300 *gdata_v3 = NULL;
>> +
>> +    if ((gdata->revision >> 8) >= 0x03)
>> +        gdata_v3 = (struct acpi_hest_generic_data_v300 *)gdata;
>>
>>       severity = gdata->error_severity;
>>       printk("%s""Error %d, type: %s\n", pfx, sec_no,
>> @@ -403,14 +409,24 @@ static void cper_estatus_print_section(
>>
>>       snprintf(newpfx, sizeof(newpfx), "%s%s", pfx, INDENT_SP);
>>       if (!uuid_le_cmp(*sec_type, CPER_SEC_PROC_GENERIC)) {
>> -        struct cper_sec_proc_generic *proc_err = (void *)(gdata + 1);
>> +        struct cper_sec_proc_generic *proc_err;
>> +
>> +        if (gdata_v3)
>> +            proc_err = (void *)(gdata_v3 + 1);
>> +        else
>> +            proc_err = (void *)(gdata + 1);
>>           printk("%s""section_type: general processor error\n", newpfx);
>>           if (gdata->error_data_length >= sizeof(*proc_err))
>>               cper_print_proc_generic(newpfx, proc_err);
>>           else
>>               goto err_section_too_small;
>>       } else if (!uuid_le_cmp(*sec_type, CPER_SEC_PLATFORM_MEM)) {
>> -        struct cper_sec_mem_err *mem_err = (void *)(gdata + 1);
>> +        struct cper_sec_mem_err *mem_err;
>> +
>> +        if (gdata_v3)
>> +            mem_err = (void *)(gdata_v3 + 1);
>> +        else
>> +            mem_err = (void *)(gdata + 1);
>>           printk("%s""section_type: memory error\n", newpfx);
>>           if (gdata->error_data_length >=
>>               sizeof(struct cper_sec_mem_err_old))
>> @@ -419,7 +435,12 @@ static void cper_estatus_print_section(
>>           else
>>               goto err_section_too_small;
>>       } else if (!uuid_le_cmp(*sec_type, CPER_SEC_PCIE)) {
>> -        struct cper_sec_pcie *pcie = (void *)(gdata + 1);
>> +        struct cper_sec_pcie *pcie;
>> +
>> +        if (gdata_v3)
>> +            pcie = (void *)(gdata_v3 + 1);
>> +        else
>> +            pcie = (void *)(gdata + 1);
>
>
> The only use of the gdata_v3 above cases is to get the payload(or 
> error_record).
> So instead of spilling these checks all over could we use something 
> like :
>
> #define acpi_hest_generic_data_version(gdata) \
>     (gdata->revision >> 8)
>
> static inline void *
> acpi_hest_generic_data_payload(struct acpi_hest_generic_data *gdata)
> {
>     return acpi_hest_generic_data_version(gdata) >= 3 ?
>         ((struct acpi_hest_generic_data_v300 *)(gdata)) + 1 :
>         gdata + 1;
> }
>
> And then do :
>
>     void *payload = acpi_hest_generic_data_payload(gdata);
>
>
Yes, this should simplify the the code to get the payload. This can also 
be done in the ghes.c code above as well.
>>           printk("%s""section_type: PCIe error\n", newpfx);
>>           if (gdata->error_data_length >= sizeof(*pcie))
>>               cper_print_pcie(newpfx, pcie, gdata);
>> @@ -434,10 +455,38 @@ err_section_too_small:
>>       pr_err(FW_WARN "error section length is too small\n");
>>   }
>>
>> +static void cper_estatus_print_section_v300(const char *pfx,
>> +    const struct acpi_hest_generic_data_v300 *gdata, int sec_no)
>> +{
>> +    __u8 hour, min, sec, day, mon, year, century, *timestamp;
>> +
>> +    if (gdata->validation_bits & ACPI_HEST_GEN_VALID_TIMESTAMP) {
>> +        timestamp = (__u8 *)&(gdata->time_stamp);
>> +        memcpy(&sec, timestamp, 1);
>> +        memcpy(&min, timestamp + 1, 1);
>> +        memcpy(&hour, timestamp + 2, 1);
>> +        memcpy(&day, timestamp + 4, 1);
>> +        memcpy(&mon, timestamp + 5, 1);
>> +        memcpy(&year, timestamp + 6, 1);
>> +        memcpy(&century, timestamp + 7, 1);
>> +        printk("%stime: ", pfx);
>> +        printk("%7s", 0x01 & *(timestamp + 3) ? "precise" : "");
>> +        printk(" %02d:%02d:%02d %02d%02d-%02d-%02d\n",
>> +            bcd2bin(hour), bcd2bin(min), bcd2bin(sec),
>> +            bcd2bin(century), bcd2bin(year), bcd2bin(mon),
>> +            bcd2bin(day));
>> +    }
>> +
>> +    cper_estatus_print_section(pfx,
>> +                   (const struct acpi_hest_generic_data *)gdata,
>> +                   sec_no);
>> +}
>
>
> Wouldn't it be better do the v3 header check from 
> cper_erstatus_print_section() and call out
> to cper_erstatus_print_section_v300() ? That way, we can leave the 
> callers unaffected,
> even for future changes.
>
>
>> +    if (gdata_v3) {
>> +        while (data_len >= sizeof(*gdata_v3)) {
>> +            gedata_len = gdata_v3->error_data_length;
>> +            cper_estatus_print_section_v300(newpfx, gdata_v3,
>> +                            sec_no);
>> +            data_len -= gedata_len + sizeof(*gdata_v3);
>> +            gdata_v3 = (void *)(gdata_v3 + 1) + gedata_len;
>> +            sec_no++;
>> +        }
>> +    } else {
>> +        while (data_len >= sizeof(*gdata)) {
>> +            gedata_len = gdata->error_data_length;
>> +            cper_estatus_print_section(newpfx, gdata, sec_no);
>> +            data_len -= gedata_len + sizeof(*gdata);
>> +            gdata = (void *)(gdata + 1) + gedata_len;
>> +            sec_no++;
>> +        }
>
> With the change mentioned above and storing the sizeof(), we could 
> make this
> hunk a bit more cleaner.
This should certainly clean up this code and I agree it is better to 
leave the callers unaffected.

I'll add all these suggested changes in my next patch-set.

Thanks,
Tyler
>
>
> Suzuki

-- 
Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
