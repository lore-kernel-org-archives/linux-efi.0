From: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH V2 1/2] efi: move ARM CPER code to new file
Date: Thu, 7 Dec 2017 15:07:35 -0500
Message-ID: <972fe421-696b-cd26-9145-20081fb733c9@codeaurora.org>
References: <1512674727-25770-1-git-send-email-tbaicar@codeaurora.org>
 <1512674727-25770-2-git-send-email-tbaicar@codeaurora.org>
 <CAKv+Gu_kM1NLWcOtQSEwEVnncBbrgJ5MP4VrYQVHBoCwSf_FRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu_kM1NLWcOtQSEwEVnncBbrgJ5MP4VrYQVHBoCwSf_FRQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 12/7/2017 2:38 PM, Ard Biesheuvel wrote:
>> diff --git a/include/linux/cper.h b/include/linux/cper.h
>> index 723e952..0a2d5c5 100644
>> --- a/include/linux/cper.h
>> +++ b/include/linux/cper.h
>> @@ -494,6 +494,13 @@ struct cper_sec_pcie {
>>   /* Reset to default packing */
>>   #pragma pack()
>>
>> +static const char * const proc_error_type_strs[] = {
>> +       "cache error",
>> +       "TLB error",
>> +       "bus error",
>> +       "micro-architectural error",
>> +};
>> +
> Could we keep this in cper.c, and replace this with
>
> extern const char * const cper_proc_error_type_strs[];
>
> instead? I'm not too keen on putting definitions (other than static
> inline functions) in header files.
>
Hello Ard,

Yes, I will make this change.

Thanks,
Tyler

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
