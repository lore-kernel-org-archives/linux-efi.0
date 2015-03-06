From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] arm64/efi: use UEFI ResetSystem() Runtime Service for
 system reset
Date: Fri, 6 Mar 2015 13:14:13 +0100
Message-ID: <CAKv+Gu9WW2O3fG+cvmgDtZwbaVo0JyRaha3O10mbbWPHzv-C7w@mail.gmail.com>
References: <1425559871-3433-1-git-send-email-ard.biesheuvel@linaro.org>
	<20150305142244.GD14093@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150305142244.GD14093@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 5 March 2015 at 15:22, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> Hi Ard,
>
> On Thu, Mar 05, 2015 at 12:51:11PM +0000, Ard Biesheuvel wrote:
>> If UEFI Runtime Services are available, the ResetSystem() service should
>> be preferred over direct PSCI calls or other methods to reset the system.
>> The reason is that the UpdateCapsule() UEFI Runtime Service, which is used
>> to perform firmware updates, relies on this.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>> I sent roughly the same patch ~6 months ago, but at the time, we were still
>> waiting for the restart notifier call chain patches to land. Since that code
>> got rejected, I am proposing this again. Note that efi_enabled(x) always
>> evaluates to 'false' on !CONFIG_EFI.
>
> Also, efi_reboot is a static inline for !CONFIG_EFI, so I can't see any
> possibility of a build failure.
>
>> This fixes reboot on my Seattle [although it doesn't make it any faster :-)]
>>
>>  arch/arm64/kernel/process.c | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>>
>> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
>> index fde9923af859..a52bc0c316a8 100644
>> --- a/arch/arm64/kernel/process.c
>> +++ b/arch/arm64/kernel/process.c
>> @@ -21,6 +21,7 @@
>>  #include <stdarg.h>
>>
>>  #include <linux/compat.h>
>> +#include <linux/efi.h>
>>  #include <linux/export.h>
>>  #include <linux/sched.h>
>>  #include <linux/kernel.h>
>> @@ -150,6 +151,14 @@ void machine_restart(char *cmd)
>>       local_irq_disable();
>>       smp_send_stop();
>>
>> +     /*
>> +      * Prefer reboot via EFI if available, so that capsule updates [which
>> +      * rely on UEFI's ResetSystem() being called with the return value of
>> +      * UpdateCapsule()] have a chance of working as expected.
>> +      */
>> +     if (efi_enabled(EFI_RUNTIME_SERVICES))
>> +             efi_reboot(reboot_mode, NULL);
>
> I expect that the particulars of the UpdateCapsule() will be handled
> within efi_reboot and won't require any additions here. So the comment
> could just be trimmed to say that UpdateCapsule() depends on the system
> being reset with ResetSystem().
>

OK.

> Also, we need to make sure we call efi_poweroff to make UpdateCapsule()
> work when shutting the machine down (behind the scenes efi_poweroff
> calls ResetSystem(EfiResetShutdown, ...)).
>
> For that I think adding the following to arch/arm64/kernel/efi.c is
> sufficient:
>
> /*
>  * UpdateCapsule() depends on the system being shutdown via
>  * ResetSystem().
>  */
> bool efi_poweroff_required(void)
> {
>         return efi_enabled(EFI_RUNTIME_SERVICES);
> }
>

Yes. I used to have this as a separate patch as well ~6 months ago,
but I did not realise at the time that UpdateCapsule() depends on
ResetSystem() for poweroff as well.

> I've given the patch a spin (with and without that addition) on Juno and
> Seattle. So with that folded in:
>
> Tested-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> Reviewed-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
>

Thanks. I will fold it in and resend.

-- 
Ard.
