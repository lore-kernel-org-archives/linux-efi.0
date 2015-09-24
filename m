From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] arm64/efi: remove /chosen/linux,uefi-stub-kern-ver DT property
Date: Thu, 24 Sep 2015 16:23:30 -0700
Message-ID: <CAKv+Gu9kR+xph2PFN0XFVAx0XjHNLZ5U=wKWN8SLk6bc3=PmFw@mail.gmail.com>
References: <1443131190-17790-1-git-send-email-ard.biesheuvel@linaro.org>
	<20150924231309.GA1650@svinekod>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150924231309.GA1650@svinekod>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Shannon Zhao <zhaoshenglong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Stefano Stabellini <stefano.stabellini-mvvWK6WmYclDPfheJLI6IQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 24 September 2015 at 16:13, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> Hi Ard,
>
> On Thu, Sep 24, 2015 at 10:46:30PM +0100, Ard Biesheuvel wrote:
>> With the stub to kernel interface being promoted to a proper interface
>> so that other agents than the stub can boot the kernel proper in EFI
>> mode, we can remove the linux,uefi-stub-kern-ver field, considering
>> that its original purpose was to prevent this from happening in the
>> first place.
>
> I'm not oppposed to this, but this change needs to be folded together with the
> other documentation updates necessary for this to become a stable ABI, as
> discussed in the other thread [1].
>

Yes, you are quite right (and apologies to Stefano and Shannon for not
cc'ing them on this patch)

It would be good to remove this /before/ promoting any of this to stable ABI.

-- 
Ard.



> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2015-September/369001.html
>
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  Documentation/arm/uefi.txt         | 2 --
>>  drivers/firmware/efi/libstub/fdt.c | 9 ---------
>>  2 files changed, 11 deletions(-)
>>
>> diff --git a/Documentation/arm/uefi.txt b/Documentation/arm/uefi.txt
>> index 7b3fdfe0f7ba..6543a0adea8a 100644
>> --- a/Documentation/arm/uefi.txt
>> +++ b/Documentation/arm/uefi.txt
>> @@ -58,5 +58,3 @@ linux,uefi-mmap-desc-size | 32-bit | Size in bytes of each entry in the UEFI
>>  --------------------------------------------------------------------------------
>>  linux,uefi-mmap-desc-ver  | 32-bit | Version of the mmap descriptor format.
>>  --------------------------------------------------------------------------------
>> -linux,uefi-stub-kern-ver  | string | Copy of linux_banner from build.
>> ---------------------------------------------------------------------------------
>> diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
>> index a7e87cd582f2..60a11551fc15 100644
>> --- a/drivers/firmware/efi/libstub/fdt.c
>> +++ b/drivers/firmware/efi/libstub/fdt.c
>> @@ -116,15 +116,6 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
>>       if (status)
>>               goto fdt_set_fail;
>>
>> -     /*
>> -      * Add kernel version banner so stub/kernel match can be
>> -      * verified.
>> -      */
>> -     status = fdt_setprop_string(fdt, node, "linux,uefi-stub-kern-ver",
>> -                          linux_banner);
>> -     if (status)
>> -             goto fdt_set_fail;
>> -
>>       return EFI_SUCCESS;
>>
>>  fdt_set_fail:
>> --
>> 1.9.1
>>
