From: Yisheng Xie <xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] arm64/efi: efi_init error handling fix
Date: Mon, 5 Sep 2016 19:11:59 +0800
Message-ID: <d8689621-2dc3-ccf8-c33b-68f0d6eab66b@huawei.com>
References: <1472811519-4897-1-git-send-email-xieyisheng1@huawei.com>
 <20160902102618.GC17482@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160902102618.GC17482-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, guohanjun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi all,
Could someone help to give some comments?
Really thanks for that.

Thanks.
Xie Yisheng

On 2016/9/2 18:26, Will Deacon wrote:
> On Fri, Sep 02, 2016 at 06:18:39PM +0800, Xie Yisheng wrote:
>> From: Yisheng Xie <xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>
>> There's an early memmap leak in efi_init error path, fix it.
>>
>> Signed-off-by: Yisheng Xie <xieyisheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>> ---
>>  drivers/firmware/efi/arm-init.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> Adding linux-efi, Ard and Matt. Please try to CC the relevant people in
> future.
> 
Hi Will,
Thank you for your kind help. I will do more check about who to CC next time.

Thanks.

> Will
> 
>> diff --git a/drivers/firmware/efi/arm-init.c b/drivers/firmware/efi/arm-init.c
>> index c49d50e..5080e40 100644
>> --- a/drivers/firmware/efi/arm-init.c
>> +++ b/drivers/firmware/efi/arm-init.c
>> @@ -243,8 +243,10 @@ void __init efi_init(void)
>>  	     "Unexpected EFI_MEMORY_DESCRIPTOR version %ld",
>>  	      efi.memmap.desc_version);
>>  
>> -	if (uefi_init() < 0)
>> +	if (uefi_init() < 0) {
>> +		early_memunmap(efi.memmap.map, params.mmap_size);
>>  		return;
>> +	}
>>  
>>  	reserve_regions();
>>  	efi_memattr_init();
>> -- 
>> 1.7.12.4
>>
> 
> .
> 
