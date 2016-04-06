From: "Baicar, Tyler" <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH V2 1/9] acpi: apei: read ack upon ghes record consumption
Date: Wed, 6 Apr 2016 14:43:04 -0600
Message-ID: <570574D8.8060402@codeaurora.org>
References: <1459955578-24602-1-git-send-email-tbaicar@codeaurora.org>
 <1459955578-24602-2-git-send-email-tbaicar@codeaurora.org>
 <57053100.7050305@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57053100.7050305-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suzuki K Poulose <Suzuki.Poulose-5wv7dgnIgG8@public.gmane.org>, fu.wei-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, harba-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, rruigrok-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, ahs3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org, lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, robert.moore-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-E0kO6a4B6psdnm+yROfE0A@public.gmane.org
Cc: "Jonathan (Zhixiong) Zhang" <zjzhang-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Naveen Kaje <nkaje-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hello Suzuki,

On 4/6/2016 9:53 AM, Suzuki K Poulose wrote:
> On 06/04/16 16:12, Tyler Baicar wrote:
>> +    hest_hdr = (struct acpi_hest_header *)generic;
>> +    if (hest_hdr->type == ACPI_HEST_TYPE_GENERIC_ERROR_V2) {
>> +        ghes->generic_v2 = (struct acpi_hest_generic_v2 *)generic;
>> +        rc = apei_map_generic_address(
>> +            &ghes->generic_v2->read_ack_register);
>> +        if (rc)
>> +            goto err_unmap;
>> +    } else
>> +        ghes->generic_v2 = NULL;
> ...
>>   err_unmap:
>> apei_unmap_generic_address(&generic->error_status_address);
>> +    if (ghes->generic_v2)
>> +        apei_unmap_generic_address(
>> +            &ghes->generic_v2->read_ack_register);
>>   err_free:
>>       kfree(ghes);
>>       return ERR_PTR(rc);
>> @@ -279,6 +295,9 @@ static void ghes_fini(struct ghes *ghes)
>>   {
>>       kfree(ghes->estatus);
>> apei_unmap_generic_address(&ghes->generic->error_status_address);
>> +    if (ghes->generic_v2)
>> +        apei_unmap_generic_address(
>> +            &ghes->generic_v2->error_status_address);
>
> I am not familiar with the APEI code, but is this error_status_address or
> read_ack_register ? We don't seem to be mapping error_status_address 
> in generic_v2 header
> which is introduced in this patch ? Am I missing something ?
>
> Suzuki

Thank you for your feedback. This does look like an error; it should be 
&ghes->generic_v2->read_ack_register. The variable 
&ghes->generic_v2->error_status_address is the same as 
&ghes->generic->error_status_address which is unmapped on the line above 
the if statement here.

Thanks,
Tyler

-- 
Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
