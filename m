From: Tyler Baicar <tbaicar@codeaurora.org>
Subject: Re: [PATCH] efi: parse ARM error information value
Date: Wed, 18 Oct 2017 09:54:26 -0400
Message-ID: <2542de99-0f09-19f5-f81d-d5c4f359d593@codeaurora.org>
References: <1508260992-18014-1-git-send-email-tbaicar@codeaurora.org>
 <1508268613.16112.487.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1508268613.16112.487.camel@linux.intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, matt@codeblueprint.co.uk, ard.biesheuvel@linaro.org, will.deacon@arm.com, james.morse@arm.com, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 10/17/2017 3:30 PM, Andy Shevchenko wrote:
> On Tue, 2017-10-17 at 11:23 -0600, Tyler Baicar wrote:
>> ARM errors just print out the error information value, then the
>> value needs to be manually decoded as per the UEFI spec. Add
>> decoding of the ARM error information value so that the kernel
>> logs capture all of the valid information at first glance.
>>
>> ARM error information value decoding is captured in UEFI 2.7
>> spec tables 263-265.
> Could it be located in separate file?
Hello Andy,

Thank you for the feedback.

Yes, I can break this out into a different file...we may want to break out all 
of the
ARM error parsing to that file then though.
>
>> +			printk("%stransaction type: %s\n", pfx,
>> +			       arm_err_trans_type_strs[trans_type]);
> Plain printk():s?
This is consistent with the other prints in this CPER code.
>
>> +#define CPER_ARM_ERR_VALID_TRANSACTION_TYPE	0x0001
>> +#define CPER_ARM_ERR_VALID_OPERATION_TYPE	0x0002
>> +#define CPER_ARM_ERR_VALID_LEVEL		0x0004
>> +#define CPER_ARM_ERR_VALID_PROC_CONTEXT_CORRUPT	0x0008
>> +#define CPER_ARM_ERR_VALID_CORRECTED		0x0010
>> +#define CPER_ARM_ERR_VALID_PRECISE_PC		0x0020
>> +#define CPER_ARM_ERR_VALID_RESTARTABLE_PC	0x0040
>> +#define CPER_ARM_ERR_VALID_PARTICIPATION_TYPE	0x0080
>> +#define CPER_ARM_ERR_VALID_TIME_OUT		0x0100
>> +#define CPER_ARM_ERR_VALID_ADDRESS_SPACE	0x0200
>> +#define CPER_ARM_ERR_VALID_MEM_ATTRIBUTES	0x0400
>> +#define CPER_ARM_ERR_VALID_ACCESS_MODE		0x0800
> BIT() is already being used in this file.
I'll convert these to use BIT().
>
>> +
>> +#define CPER_ARM_ERR_TRANSACTION_SHIFT		16
>> +#define CPER_ARM_ERR_TRANSACTION_MASK		0x3
> Mask is mask, so GENMASK()
I'll convert the masks to use GENMASK()

Thanks,
Tyler

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
