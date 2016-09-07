From: Yisheng Xie <xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] arm64/efi: efi_init error handling fix
Date: Wed, 7 Sep 2016 19:15:48 +0800
Message-ID: <c57dfbbe-a2a7-e8af-7d94-20f86126053c@huawei.com>
References: <1472811519-4897-1-git-send-email-xieyisheng1@huawei.com>
 <20160902102618.GC17482@arm.com> <20160905135723.GK32579@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160905135723.GK32579-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, guohanjun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org



On 2016/9/5 21:57, Matt Fleming wrote:
> On Fri, 02 Sep, at 11:26:18AM, Will Deacon wrote:
>> On Fri, Sep 02, 2016 at 06:18:39PM +0800, Xie Yisheng wrote:
>>> From: Yisheng Xie <xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>>
>>> diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
>>> index c49d50e..5080e40 100644
>>> --- a/drivers/firmware/efi/arm-init.c
>>> +++ b/drivers/firmware/efi/arm-init.c
>>> @@ -243,8 +243,10 @@ void __init efi_init(void)
>>>  	     "Unexpected EFI_MEMORY_DESCRIPTOR version %ld",
>>>  	      efi.memmap.desc_version);
>>>  
>>> -	if (uefi_init() < 0)
>>> +	if (uefi_init() < 0) {
>>> +		early_memunmap(efi.memmap.map, params.mmap_size);
>>>  		return;
>>> +	}
> 
> This should be a call to efi_memmap_unmap() because the EFI_MEMMAP
> flag also needs clearing.
> 
Hi Matt,
Thanks for your reply.
You mean call the function efi_unmap_memmap() like x86?

however, it seems no need to clear EFI_MEMMAP here. For arm*, the flag
EFI_MEMMAP is set in function reserve_regions(), which is called
only when uefi_init() return 0:

efi_init()
   -> reserve_regions()
       -> set_bit(EFI_MEMMAP, &efi.flags);
Thanks
Xie Yisheng.

> .
> 
