From: ivanhu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: ACK: [PATCH] efi/efi_test: Prevent an Oops in
 efi_runtime_query_capsulecaps()
Date: Wed, 11 Oct 2017 14:26:57 +0800
Message-ID: <449b17c1-2c97-fd7c-3073-5cb20e1c3672@canonical.com>
References: <20170930081732.x6g4b2mwxwt5xzql@mwanda>
 <20171006121939.GC3314@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006121939.GC3314-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Content-Language: en-GB
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org



On 10/06/2017 08:19 PM, Matt Fleming wrote:
> On Sat, 30 Sep, at 11:17:32AM, Dan Carpenter wrote:
>> If "qcaps.capsule_count" is ULONG_MAX then "qcaps.capsule_count + 1"
>> will overflow to zero and kcalloc() will return the ZERO_SIZE_PTR.  We
>> try to dereference it inside the loop and crash.
>>
>> Fixes: ff6301dabc3c ("efi: Add efi_test driver for exporting UEFI runtime service interfaces")
>> Signed-off-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>
>> diff --git a/drivers/firmware/efi/test/efi_test.c b/drivers/firmware/efi/test/efi_test.c
>> index 08129b7b80ab..41c48a1e8baa 100644
>> --- a/drivers/firmware/efi/test/efi_test.c
>> +++ b/drivers/firmware/efi/test/efi_test.c
>> @@ -593,6 +593,9 @@ static long efi_runtime_query_capsulecaps(unsigned long arg)
>>   	if (copy_from_user(&qcaps, qcaps_user, sizeof(qcaps)))
>>   		return -EFAULT;
>>   
>> +	if (qcaps.capsule_count == ULONG_MAX)
>> +		return -EINVAL;
>> +
>>   	capsules = kcalloc(qcaps.capsule_count + 1,
>>   			   sizeof(efi_capsule_header_t), GFP_KERNEL);
>>   	if (!capsules)
> 
> This looks OK to me. Ivan?
> 


Acked-by: Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
