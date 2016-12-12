From: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH] efi/libstub: arm*: Pass latest memory map to the kernel
Date: Mon, 12 Dec 2016 10:00:54 -0700
Message-ID: <f46006fb-2dbb-950a-ae22-6ce275c59644@codeaurora.org>
References: <1481307843-18521-1-git-send-email-ard.biesheuvel@linaro.org>
 <584E6F50.3020901@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <584E6F50.3020901-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 12/12/2016 2:35 AM, James Morse wrote:
> Hi Ard,
>
> On 09/12/16 18:24, Ard Biesheuvel wrote:
>> As reported by James, the current libstub code involving the annotated
>> memory map only works somewhat correctly by accident, due to the fact
>> that a pool allocation happens to be reused immediately, retaining its
>> former contents.
>>
>> Instead of juggling memory maps, which makes the code more complex than
>> it needs to be, simply put a placholder value into the FDT, and only
>> write the actual value after ExitBootServices() has been called.
>
>> diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
>> index a6a93116a8f0..5d39dff77f17 100644
>> --- a/drivers/firmware/efi/libstub/fdt.c
>> +++ b/drivers/firmware/efi/libstub/fdt.c
>> @@ -101,7 +101,7 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
>>  	if (status)
>>  		goto fdt_set_fail;
>>
>> -	fdt_val64 = cpu_to_fdt64((u64)(unsigned long)memory_map);
>> +	fdt_val64 = U64_MAX; /* placeholder */
>>  	status = fdt_setprop(fdt, node, "linux,uefi-mmap-start",
>>  			     &fdt_val64,  sizeof(fdt_val64));
>>  	if (status)
>> @@ -148,6 +148,24 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
>>  	return EFI_LOAD_ERROR;
>>  }
>>
>> +static efi_status_t update_fdt_memmap(void *fdt, u64 memmap)
>> +{
>> +	int node = fdt_path_offset(fdt, "/chosen");
>> +	efi_status_t status;
>> +
>> +	if (node < 0)
>> +		return EFI_LOAD_ERROR;
>> +
>> +	memmap = cpu_to_fdt64(memmap);
>> +	status = fdt_setprop_inplace(fdt, node, "linux,uefi-mmap-start",
>> +				     &memmap, sizeof(memmap));
>> +
>> +	if (status)
>> +		return EFI_LOAD_ERROR;
>> +
>> +	return EFI_SUCCESS;
>> +}
>
> v4.9.0 with this patch doesn't boot on my Seattle (with known buggy UEFI FW)
> [0]. It looks like the memory map is truncated (and missing a runtime region,
> compare with [1]). Should 'linux,uefi-mmap-size' be updated too? (Otherwise its
> the size when we retrieved the runtime mapping, but before we allocated the FDT)
>

Overall this fails for me as well.  It appears to work, until I trigger 
the race condition I fixed, then OOM killer gets triggered the instant 
rootfs starts to initialize.  Since I see James has a number of 
comments, I did not investigate further to determine why the patch is 
not working on my system.

-- 
Jeffrey Hugo
Qualcomm Datacenter Technologies as an affiliate of Qualcomm 
Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
