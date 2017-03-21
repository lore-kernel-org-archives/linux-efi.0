From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi/libstub: arm/arm64: make debug prints dependent on efi=debug
Date: Tue, 21 Mar 2017 12:12:55 +0000
Message-ID: <CAKv+Gu-MZwRSpdmSshqC6nfBGwBa-C3hXRmbbf5pjWVb8xcOHw@mail.gmail.com>
References: <1490043425-20118-1-git-send-email-ard.biesheuvel@linaro.org> <20170321115805.GC22188@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170321115805.GC22188@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Roy Franz <rfranz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 21 March 2017 at 11:58, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> On Mon, Mar 20, 2017 at 08:57:05PM +0000, Ard Biesheuvel wrote:
>> The EFI stub currently prints a number of diagnostic messages that do
>> not carry a lot of information. Since these prints are not controlled
>> by 'loglevel' or other command line parameters, and since they appear on
>> the EFI framebuffer as well (if enabled), it would be nice if we could
>> turn them off.
>>
>> So let's only print them if 'efi=debug' is passed on the command line,
>> or when CONFIG_DEBUG_EFI is set in the kernel build configuration.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  drivers/firmware/efi/libstub/arm32-stub.c      |  2 ++
>>  drivers/firmware/efi/libstub/efi-stub-helper.c | 23 ++++++++++++++---------
>>  drivers/firmware/efi/libstub/efistub.h         |  9 +++++++++
>>  drivers/firmware/efi/libstub/secureboot.c      |  2 ++
>>  include/linux/efi.h                            |  3 ---
>>  5 files changed, 27 insertions(+), 12 deletions(-)
>
>> diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
>> index 71c4d0e3c4ed..5ed16e6e166f 100644
>> --- a/drivers/firmware/efi/libstub/efistub.h
>> +++ b/drivers/firmware/efi/libstub/efistub.h
>> @@ -24,6 +24,15 @@
>>  #define EFI_ALLOC_ALIGN              EFI_PAGE_SIZE
>>  #endif
>>
>> +extern int __pure debug_enabled(void);
>> +
>> +#define pr_efi(sys_table, msg)               do {                            \
>> +     if (debug_enabled()) efi_printk(sys_table, "EFI stub: "msg);    \
>> +} while (0)
>
> I was going to say that it's somewhat unfortunate to lose some of these
> messages by default, but I guess this only adds one additional
> round-trip when debugging a remote issue, and gives us the freedom to
> add more comprehensive debug messages in future.
>
> Is the idea is to make the EFI stub completely silent in the successful
> case, or is the aim just to minimise the number of messages?
>
> If it's only the latter, we could log a message regarding the existence
> of efi=debug in the default case, which might help with bug reports.
>
> No strong feelings from me.
>

I guess we could simply look for 'quiet' instead, and invert the logic
so we keep the current situation, but still allow for a pretty boot
splash uncorrupted by meaningless printk's if we want to (and distros
already use 'quiet' for exactly that purpose)
