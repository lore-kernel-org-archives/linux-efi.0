From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 2/2] efi: Add embedded peripheral firmware support
Date: Thu, 5 Apr 2018 13:51:28 +0200
Message-ID: <b43da07e-5ca6-ce06-c786-5dcbbfc4b300@redhat.com>
References: <20180331121944.8618-1-hdegoede@redhat.com>
 <20180331121944.8618-2-hdegoede@redhat.com>
 <20180403195332.tezh6alee26aic2s@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180403195332.tezh6alee26aic2s@redhat.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Jones <pjones@redhat.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, Dave Olsthoorn <dave@bewaar.me>, x86@kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Hi,

On 03-04-18 21:53, Peter Jones wrote:
> On Sat, Mar 31, 2018 at 02:19:44PM +0200, Hans de Goede wrote:
>> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
>> index fddc5f706fd2..1a5ea950f58f 100644
>> --- a/drivers/firmware/efi/efi.c
>> +++ b/drivers/firmware/efi/efi.c
>> @@ -455,6 +455,7 @@ int __init efi_mem_desc_lookup(u64 phys_addr, efi_memory_desc_t *out_md)
>>   		u64 end;
>>   
>>   		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
>> +		    md->type != EFI_BOOT_SERVICES_CODE &&
>>   		    md->type != EFI_BOOT_SERVICES_DATA &&
>>   		    md->type != EFI_RUNTIME_SERVICES_DATA) {
>>   			continue;
> 
> Might be worth adding a comment here to ensure nobody comes along later
> and adds something like EFI_BOOT_LOADER_DATA or other stuff that's
> allocated later here.  I don't want to accidentally patch our way into
> having the ability to stumble across a firmware blob somebody dumped
> into the middle of a grub config file, especially since you only need to
> collide crc32 (within the same length) to pre-alias a match.

As discussed elsewhere in the thread, I'm going to switch to doing a
kmemdup on the found firmware, so this chunk will go away :)

> 
> ...
>> +static int __init efi_check_md_for_embedded_firmware(
>> +	efi_memory_desc_t *md, const struct embedded_fw_desc *desc)
>> +{
> ...
>> +	if (found_fw_count >= MAX_EMBEDDED_FIRMWARES) {
>> +		pr_err("Error already have %d embedded firmwares\n",
>> +		       MAX_EMBEDDED_FIRMWARES);
>> +		return -ENOSPC;
>> +	}
> 
> Doesn't seem like this needs to be pr_err(); after all we have already
> found a valid match, so the firmware vendor has done something
> moderately stupid, but we have a firmware that will probably work.  Of
> course it still needs to return != 0, but pr_warn() or even pr_info()
> seems more reasonable.

We break from the search loop as soon as a firmware is found, this can
only trigger if someone adds a second firmware to the dmi data and then
does not update MAX_EMBEDDED_FIRMWARES...

But mcgrof wants me to switch to a linked list here, so this is going
away too.

> Aside from those nits, looks good to me.
> 
> Reviewed-by: Peter Jones <pjones@redhat.com>

Thanks, but v2 is going to have so much changes that I don't feel
comfortable bringing this forward to v2.

Regards,

Hans
