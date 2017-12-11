From: Tyler Baicar <tbaicar-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH V2 1/2] efi: move ARM CPER code to new file
Date: Mon, 11 Dec 2017 16:06:11 -0500
Message-ID: <1bcd0462-5df9-fd90-c487-4e8958a9e27d@codeaurora.org>
References: <1512674727-25770-1-git-send-email-tbaicar@codeaurora.org>
 <1512674727-25770-2-git-send-email-tbaicar@codeaurora.org>
 <CAKv+Gu_kM1NLWcOtQSEwEVnncBbrgJ5MP4VrYQVHBoCwSf_FRQ@mail.gmail.com>
 <972fe421-696b-cd26-9145-20081fb733c9@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <972fe421-696b-cd26-9145-20081fb733c9-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 12/7/2017 3:07 PM, Tyler Baicar wrote:
> On 12/7/2017 2:38 PM, Ard Biesheuvel wrote:
>>> diff --git a/include/linux/cper.h b/include/linux/cper.h
>>> index 723e952..0a2d5c5 100644
>>> --- a/include/linux/cper.h
>>> +++ b/include/linux/cper.h
>>> @@ -494,6 +494,13 @@ struct cper_sec_pcie {
>>>   /* Reset to default packing */
>>>   #pragma pack()
>>>
>>> +static const char * const proc_error_type_strs[] = {
>>> +       "cache error",
>>> +       "TLB error",
>>> +       "bus error",
>>> +       "micro-architectural error",
>>> +};
>>> +
>> Could we keep this in cper.c, and replace this with
>>
>> extern const char * const cper_proc_error_type_strs[];
>>
>> instead? I'm not too keen on putting definitions (other than static
>> inline functions) in header files.
>>
> Yes, I will make this change.
Hello Ard,

This actually won't work because of the ARRAY_SIZE use. If this definition is in 
cper.c, then cper-arm.c won't be able to use ARRAY_SIZE even with the extern 
statement in cper.h.

drivers/firmware/efi/cper-arm.c: In function ‘cper_print_proc_arm’:
./include/linux/kernel.h:71:32: error: invalid application of ‘sizeof’ to 
incomplete type ‘const char * const[]’
  #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
                                 ^
drivers/firmware/efi/cper-arm.c:103:21: note: in expansion of macro ‘ARRAY_SIZE’
     err_info->type < ARRAY_SIZE(cper_proc_error_type_strs) ?
                      ^~~~~~~~~~

Any other suggestions?

Thanks,
Tyler

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
