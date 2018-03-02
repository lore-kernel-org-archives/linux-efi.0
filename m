From: Tyler Baicar <tbaicar@codeaurora.org>
Subject: Re: [PATCH 0/2] ESRT fixes for relocatable kexec'd kernel
Date: Fri, 2 Mar 2018 08:27:11 -0500
Message-ID: <4d21342c-a81e-c3ef-8c5f-9d952c7d8fac@codeaurora.org>
References: <1519414953-5478-1-git-send-email-tbaicar@codeaurora.org>
 <20180228061901.GJ6019@linaro.org>
 <1f03865f-2d22-8ba1-a276-a6b49d7c14de@codeaurora.org>
 <20180301025026.GK6019@linaro.org>
 <7cd3f462-c619-9d82-73a0-2f3bc9de095e@codeaurora.org>
 <20180302055325.GQ6019@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180302055325.GQ6019@linaro.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: AKASHI Takahiro <takahiro.akashi@linaro.org>, Jeffrey Hugo <jhugo@codeaurora.org>, ard.biesheuvel@linaro.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, sgoel@codeaurora.org, timur@codeaurora.org
List-Id: linux-efi@vger.kernel.org

On 3/2/2018 12:53 AM, AKASHI Takahiro wrote:
> Tyler, Jeffrey,
>
> [Note: This issue takes place in kexec, not kdump. So to be precise,
> it is not the same phenomenon as what I addressed in [1],[2]:
>    [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2018-February/557254.html
>    [2] http://lists.infradead.org/pipermail/linux-arm-kernel/2018-January/553098.html
> ]
>
> On Thu, Mar 01, 2018 at 12:56:38PM -0500, Tyler Baicar wrote:
>> Hello,
>>
>> On 2/28/2018 9:50 PM, AKASHI Takahiro wrote:
>>> Hi,
>>>
>>> On Wed, Feb 28, 2018 at 08:39:42AM -0700, Jeffrey Hugo wrote:
>>>> On 2/27/2018 11:19 PM, AKASHI Takahiro wrote:
>>>>> Tyler,
>>>>>
>>>>> # I missed catching your patch as its subject doesn't contain arm64.
>>>>>
>>>>> On Fri, Feb 23, 2018 at 12:42:31PM -0700, Tyler Baicar wrote:
>>>>>> Currently on arm64 ESRT memory does not appear to be properly blocked off.
>>>>>> Upon successful initialization, ESRT prints out the memory region that it
>>>>>> exists in like:
>>>>>>
>>>>>> esrt: Reserving ESRT space from 0x000000000a4c1c18 to 0x000000000a4c1cf0.
>>>>>>
>>>>>> But then by dumping /proc/iomem this region appears as part of System RAM
>>>>>> rather than being reserved:
>>>>>>
>>>>>> 08f10000-0deeffff : System RAM
>>>>>>
>>>>>> This causes issues when trying to kexec if the kernel is relocatable. When
>>>>>> kexec tries to execute, this memory can be selected to relocate the kernel to
>>>>>> which then overwrites all the ESRT information. Then when the kexec'd kernel
>>>>>> tries to initialize ESRT, it doesn't recognize the ESRT version number and
>>>>>> just returns from efi_esrt_init().
>>>>> I'm not sure what is the root cause of your problem.
>>>>> Do you have good confidence that the kernel (2nd kernel image in this case?)
>>>>> really overwrite ESRT region?
>>>> According to my debug, yes.
>>>> Using JTAG, I was able to determine that the ESRT memory region was getting
>>>> overwritten by the secondary kernel in
>>>> kernel/arch/arm64/kernel/relocate_kernel.S - specifically the "copy_page"
>>>> line of arm64_relocate_new_kernel()
>>>>
>>>>> To my best knowledge, kexec is carefully designed not to do such a thing
>>>>> as it allocates a temporary buffer for kernel image and copies it to the
>>>>> final destination at the very end of the 1st kernel.
>>>>>
>>>>> My guess is that kexec, or rather kexec-tools, tries to load the kernel image
>>>>> at 0x8f80000 (or 0x9080000?, not sure) in your case. It may or may not be
>>>>> overlapped with ESRT.
>>>>> (Try "-d" option when executing kexec command for confirmation.)
>>>> With -d, I see
>>>>
>>>> get_memory_ranges_iomem_cb: 0000000009611000 - 000000000e5fffff : System RAM
>>>>
>>>> That overlaps the ESRT reservation -
>>>> [ 0.000000] esrt: Reserving ESRT space from 0x000000000b708718 to
>>>> 0x000000000b7087f0
>>>>
>>>>> Are you using initrd with kexec?
>>>> Yes
>>> To make the things clear, can you show me, if possible, the followings:
>> I have attached all of these:
> Many thanks.
> According to the data, ESRT was overwritten by initrd, not the kernel image.
> It doesn't matter to you though :)
>
> The solution would be, as Ard suggested, that more information be
> added to /proc/iomem.
> I'm going to fix the issue as quickly as possible.
Great, thank you!! Please add us to the fix and we will gladly test it out.

Thanks,
Tyler

-- 
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project.
