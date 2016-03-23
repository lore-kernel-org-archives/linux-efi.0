From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] arm*: efi: drop writable mapping of the UEFI System table
Date: Wed, 23 Mar 2016 23:11:53 +0100
Message-ID: <CAKv+Gu_p=nWMbyciC9QXqnLEgqouxiERn6kcLv1V+2tDc74tbA@mail.gmail.com>
References: <1456496435-12679-1-git-send-email-ard.biesheuvel@linaro.org>
	<1456496435-12679-2-git-send-email-ard.biesheuvel@linaro.org>
	<20160226150156.GC7475@codeblueprint.co.uk>
	<CAKv+Gu8+pYR_jxjcVeXgekVqD_BugtRLgNNhOkvhuaEpddbHRg@mail.gmail.com>
	<20160323161624.GG11676@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160323161624.GG11676-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 23 March 2016 at 17:16, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Tue, 22 Mar, at 04:08:24PM, Ard Biesheuvel wrote:
>>
>> This patch causes a warning I hadn't spotted before sending it out.
>> Could you fold this in please?
>>
>> diff --git a/drivers/firmware/efi/arm-runtime.c
>> b/drivers/firmware/efi/arm-runtime.c
>> index 6c97d4884fc7..fe749da9997e 100644
>> --- a/drivers/firmware/efi/arm-runtime.c
>> +++ b/drivers/firmware/efi/arm-runtime.c
>> @@ -72,8 +72,8 @@ static bool __init efi_virtmap_init(void)
>>                  */
>>                 if (efi_system_table >= phys &&
>>                     efi_system_table < phys + (md->num_pages * EFI_PAGE_SIZE)) {
>> -                       efi.systab = (void *)(efi_system_table - phys +
>> -                                             md->virt_addr);
>> +                       efi.systab = (void *)(unsigned long)(efi_system_table -
>> +                                                         phys + md->virt_addr);
>>                         systab_found = true;
>>                 }
>>         }
>
> Done, please check,
>
>   https://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/commit/?h=next&id=4fd5c619dcf4f3d2c86d4a686ce66fc01e877a08

Looks good to me, thanks.
