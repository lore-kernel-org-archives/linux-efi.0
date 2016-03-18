From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/8] efi: make install_configuration_table() boot service usable
Date: Fri, 18 Mar 2016 12:02:25 +0100
Message-ID: <CAKv+Gu9tS9fKM_dHK7J+TraotfEwRXbQ7vzNrErb1CteP4eu4g@mail.gmail.com>
References: <1457588408-19309-1-git-send-email-ard.biesheuvel@linaro.org>
	<1457588408-19309-2-git-send-email-ard.biesheuvel@linaro.org>
	<20160318105939.GO2619@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160318105939.GO2619-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 18 March 2016 at 11:59, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Thu, 10 Mar, at 12:40:01PM, Ard Biesheuvel wrote:
>> This patch redeclares efi_boot_services_t::install_configuration_table
>> as a function pointer so that the boot service is callable as a function.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  include/linux/efi.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Any chance you could fold this patch into the one that actually uses
> install_configuration_table() on ARM? That way it's clear to see where
> the users are.
>

Sure. Patch #2 actually does the same for locate_handle()


>> diff --git a/include/linux/efi.h b/include/linux/efi.h
>> index e747eb08b2be..8ba6eb7863aa 100644
>> --- a/include/linux/efi.h
>> +++ b/include/linux/efi.h
>> @@ -283,7 +283,7 @@ typedef struct {
>>       void *register_protocol_notify;
>>       void *locate_handle;
>>       void *locate_device_path;
>> -     void *install_configuration_table;
>> +     efi_status_t (*install_configuration_table)(efi_guid_t *, void *);
>>       void *load_image;
>>       void *start_image;
>>       void *exit;
>> --
>> 1.9.1
>>
