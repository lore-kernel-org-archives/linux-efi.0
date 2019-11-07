Return-Path: <SRS0=vceF=Y7=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EC67C5DF61
	for <linux-efi@archiver.kernel.org>; Thu,  7 Nov 2019 08:03:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78E98206DF
	for <linux-efi@archiver.kernel.org>; Thu,  7 Nov 2019 08:03:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbfKGIDT (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Thu, 7 Nov 2019 03:03:19 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:5740 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726734AbfKGIDS (ORCPT <rfc822;linux-efi@vger.kernel.org>);
        Thu, 7 Nov 2019 03:03:18 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6EEA48D711EBFC8BF3D0;
        Thu,  7 Nov 2019 16:03:16 +0800 (CST)
Received: from [127.0.0.1] (10.57.64.164) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.439.0; Thu, 7 Nov 2019
 16:03:07 +0800
Subject: Re: [PATCH] EFI/stub: tpm: enable tpm eventlog function for ARM64
 platform
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
CC:     Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
        "Kate Stewart" <kstewart@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steve Capper <steve.capper@arm.com>,
        linux-efi <linux-efi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>, <zoucao@linux.alibaba.com>,
        Xinwei Kong <kong.kongxinwei@hisilicon.com>
References: <20191105082924.289-1-kong.kongxinwei@hisilicon.com>
 <CAKv+Gu-V0S9EZeCjna5+P6v53evV-6uuG0rAShUA+uWb=NgH4g@mail.gmail.com>
 <CAKv+Gu9X4vCiS+BABs34t05MdF6GaFJr4jBTeaamngx3s=sPBg@mail.gmail.com>
From:   kongxinwei <kong.kongxinwei@hisilicon.com>
Message-ID: <9ffbc8d5-cd95-1978-c5df-eedd4fe2b850@hisilicon.com>
Date:   Thu, 7 Nov 2019 16:03:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu9X4vCiS+BABs34t05MdF6GaFJr4jBTeaamngx3s=sPBg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.57.64.164]
X-CFilter-Loop: Reflected
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org

On 2019/11/6 22:59, Ard Biesheuvel wrote:
> On Wed, 6 Nov 2019 at 15:56, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>>
>> On Tue, 5 Nov 2019 at 09:29, Xinwei Kong <kong.kongxinwei@hisilicon.com> wrote:
>>>
>>> this patch gets tpm eventlog information such as device boot status,event guid
>>> and so on, which will be from bios stage. it use "efi_retrieve_tpm2_eventlog"
>>> functions to get it for ARM64 platorm.
>>>
>>> Signed-off-by: Xinwei Kong <kong.kongxinwei@hisilicon.com>
>>> Signed-off-by: Zou Cao <zoucao@linux.alibaba.com>
>>> ---
>>>  drivers/firmware/efi/libstub/arm-stub.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
>>> index c382a48..37c8f81 100644
>>> --- a/drivers/firmware/efi/libstub/arm-stub.c
>>> +++ b/drivers/firmware/efi/libstub/arm-stub.c
>>> @@ -139,6 +139,8 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
>>>         if (status != EFI_SUCCESS)
>>>                 goto fail;
>>>
>>> +       efi_retrieve_tpm2_eventlog(sys_table);
>>> +
>>
>> This function allocates memory, so calling it should be deferred until
>> after we relocate the kernel, to prevent these allocations from using
>> up space that we'd rather use for the kernel.
>>
>> Does it work for you if we move this call further down, right before
>> the call to efi_enable_reset_attack_mitigation()? Please confirm.
>>

ok，I will confirm it and send V2 version patch :

> 
> Also, your S-o-b chain is incorrect. If Zou Cao provided you with the
> patch, please credit her/him as the author (using git --reset-author)
> and move your S-o-b last. If Zou Cao was a co-author [which seems
> unlikely for a single line patch], use Co-developed-by+Signed-off-by.
> In any case, the S-o-b of the person sending out the patch via email
> should come last.
> 
I will deal it.
> .
> 

