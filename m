From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/2] efi/esrt: fix unsupported version initialization failure
Date: Thu, 8 Mar 2018 18:34:58 +0000
Message-ID: <CAKv+Gu-KaMpyrbBiFYR0tZVSNSMV0awS9PTPXXWcjpi-1nmZ7w@mail.gmail.com>
References: <1519414953-5478-1-git-send-email-tbaicar@codeaurora.org>
 <1519414953-5478-2-git-send-email-tbaicar@codeaurora.org> <20180224072054.GA3264@dhcp-128-65.nay.redhat.com>
 <f24bcd25-9d3d-12d6-a42c-ebe0c623dba6@codeaurora.org> <CAKv+Gu8U67_6Fpj+REUc5rgThuAXac=p0U_EOdU8_=K_xj1KSQ@mail.gmail.com>
 <CAKv+Gu_=YSXTMR3eeCXKpz2WfmMJjT2oF6KoUzWB1HDXy5sQCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu_=YSXTMR3eeCXKpz2WfmMJjT2oF6KoUzWB1HDXy5sQCg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Tyler Baicar <tbaicar@codeaurora.org>, Peter Jones <pjones@redhat.com>
Cc: Dave Young <dyoung@redhat.com>, linux-efi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jeff Hugo <jhugo@codeaurora.org>, Sameer Goel <sgoel@codeaurora.org>, AKASHI Takahiro <takahiro.akashi@linaro.org>, Timur Tabi <timur@codeaurora.org>
List-Id: linux-efi@vger.kernel.org

On 8 March 2018 at 18:15, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> On 8 March 2018 at 18:00, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>> On 8 March 2018 at 16:11, Tyler Baicar <tbaicar@codeaurora.org> wrote:
>>> On 2/24/2018 2:20 AM, Dave Young wrote:
>>>>
>>>> On 02/23/18 at 12:42pm, Tyler Baicar wrote:
>>>>>
>>>>> If ESRT initialization fails due to an unsupported version, the
>>>>> early_memremap allocation is never unmapped. This will cause an
>>>>> early ioremap leak. So, make sure to unmap the memory allocation
>>>>> before returning from efi_esrt_init().
>>>>>
>>>>> Signed-off-by: Tyler Baicar <tbaicar@codeaurora.org>
>>>>> ---
>>>>>   drivers/firmware/efi/esrt.c | 2 +-
>>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/firmware/efi/esrt.c b/drivers/firmware/efi/esrt.c
>>>>> index c47e0c6..504f3c3 100644
>>>>> --- a/drivers/firmware/efi/esrt.c
>>>>> +++ b/drivers/firmware/efi/esrt.c
>>>>> @@ -285,7 +285,7 @@ void __init efi_esrt_init(void)
>>>>>         } else {
>>>>>                 pr_err("Unsupported ESRT version %lld.\n",
>>>>>                        tmpesrt.fw_resource_version);
>>>>> -               return;
>>>>> +               goto err_memunmap;
>>>>>         }
>>>>>         if (tmpesrt.fw_resource_count > 0 && max - size < entry_size) {
>>>>> --
>>>>
>>>> Reviewed-by: Dave Young <dyoung@redhat.com>
>>>
>>> Thank you Dave for your review here and input on the other patch.
>>>
>>> Ard,
>>>
>>> Can this patch be picked up? I understand patch 2 is not acceptable, but
>>> this one should
>>> be good to go I think.
>>>
>>
>> Yeah you're right. I'll pick it up as a bugfix.
>
> Actually, on second thought, could you respin this patch, and just
> move the memunamp() to right after the memcpy()? That way, we can get
> rid of all the 'goto err_memunmap's afaict
>

OK, now I'm confused. Does anyone have a clue why in efi_esrt_init()
the memremap() is done a second time? AFAICT it just reserves the
region, it does not actually access the second mapping at all.
