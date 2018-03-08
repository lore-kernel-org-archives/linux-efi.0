From: Tyler Baicar <tbaicar@codeaurora.org>
Subject: Re: [PATCH 1/2] efi/esrt: fix unsupported version initialization
 failure
Date: Thu, 8 Mar 2018 11:11:18 -0500
Message-ID: <f24bcd25-9d3d-12d6-a42c-ebe0c623dba6@codeaurora.org>
References: <1519414953-5478-1-git-send-email-tbaicar@codeaurora.org>
 <1519414953-5478-2-git-send-email-tbaicar@codeaurora.org>
 <20180224072054.GA3264@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180224072054.GA3264@dhcp-128-65.nay.redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>
Cc: ard.biesheuvel@linaro.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, jhugo@codeaurora.org, sgoel@codeaurora.org, takahiro.akashi@linaro.org, timur@codeaurora.org
List-Id: linux-efi@vger.kernel.org

On 2/24/2018 2:20 AM, Dave Young wrote:
> On 02/23/18 at 12:42pm, Tyler Baicar wrote:
>> If ESRT initialization fails due to an unsupported version, the
>> early_memremap allocation is never unmapped. This will cause an
>> early ioremap leak. So, make sure to unmap the memory allocation
>> before returning from efi_esrt_init().
>>
>> Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
>> ---
>>   drivers/firmware/efi/esrt.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/firmware/efi/esrt.c b/drivers/firmware/efi/esrt.c
>> index c47e0c6..504f3c3 100644
>> --- a/drivers/firmware/efi/esrt.c
>> +++ b/drivers/firmware/efi/esrt.c
>> @@ -285,7 +285,7 @@ void __init efi_esrt_init(void)
>>   	} else {
>>   		pr_err("Unsupported ESRT version %lld.\n",
>>   		       tmpesrt.fw_resource_version);
>> -		return;
>> +		goto err_memunmap;
>>   	}
>>   
>>   	if (tmpesrt.fw_resource_count > 0 && max - size < entry_size) {
>> -- 
> Reviewed-by: Dave Young <dyoung@redhat.com>
Thank you Dave for your review here and input on the other patch.

Ard,

Can this patch be picked up? I understand patch 2 is not acceptable, but this 
one should
be good to go I think.

Thanks,
Tyler

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
