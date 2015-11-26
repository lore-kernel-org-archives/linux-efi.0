From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/4] efi: runtime-wrappers: run UEFI Runtime Services with
 interrupts enabled
Date: Thu, 26 Nov 2015 13:09:27 +0100
Message-ID: <CAKv+Gu80NdLLfXWJ4R9CvSpH6REnsirbUFfo6DTDr7DUT2OpDg@mail.gmail.com>
References: <1447940191-30705-1-git-send-email-ard.biesheuvel@linaro.org>
	<1447940191-30705-5-git-send-email-ard.biesheuvel@linaro.org>
	<20151126102345.GD2765@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151126102345.GD2765-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 26 November 2015 at 11:23, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Thu, 19 Nov, at 02:36:31PM, Ard Biesheuvel wrote:
>> The UEFI spec allows Runtime Services to be invoked with interrupts
>> enabled. The only reason we were disabling interrupts was to prevent
>> recursive calls into the services on the same CPU, which will lead to
>> deadlock. However, the only context where such invocations may occur
>> legally is from efi-pstore via efivars, and that code has been updated
>> to call a non-blocking alternative when invoked from a non-interruptible
>> context.
>>
>> So instead, update the ordinary, blocking UEFI Runtime Services wrappers
>> to execute with interrupts enabled.
>
> Please document the justification for this change; why do you *need*
> interrupts enabled as opposed to doing it because the spec allows it.
>

The primary concern is EFI writes on a UP system to a variable store
that is backed by RPMB/MMC storage through some marshalling layer in
the secure OS. I will add that to the commit log for v2

>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  drivers/firmware/efi/runtime-wrappers.c | 88 +++++++++++---------
>>  1 file changed, 49 insertions(+), 39 deletions(-)
>>
>> diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
>> index a624f7445d11..31e131f09530 100644
>> --- a/drivers/firmware/efi/runtime-wrappers.c
>> +++ b/drivers/firmware/efi/runtime-wrappers.c
>> @@ -71,27 +71,29 @@ __weak DEFINE_SPINLOCK(rtc_lock);
>>
>>  static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
>>  {
>> -     unsigned long flags;
>>       efi_status_t status;
>>
>> -     spin_lock_irqsave(&rtc_lock, flags);
>> +     BUG_ON(in_irq());
>> +
>> +     spin_lock(&rtc_lock);
>>       spin_lock(&efi_runtime_lock);
>>       status = efi_call_virt(get_time, tm, tc);
>>       spin_unlock(&efi_runtime_lock);
>> -     spin_unlock_irqrestore(&rtc_lock, flags);
>> +     spin_unlock(&rtc_lock);
>>       return status;
>>  }
>
> This looks wrong. rtc_lock can be grabbed from IRQ context. Maybe now
> is the time to rip out rtc_lock? It's __weak for arm64 anyway and x86
> doesn't even use these functions. Though I notice that arm also has an
> rtc_lock.
>
>>  static efi_status_t virt_efi_set_time(efi_time_t *tm)
>>  {
>> -     unsigned long flags;
>>       efi_status_t status;
>>
>> -     spin_lock_irqsave(&rtc_lock, flags);
>> +     BUG_ON(in_irq());
>> +
>> +     spin_lock(&rtc_lock);
>
> The thing about using BUG_ON() here is that you get no LOCKDEP info if
> you trigger it, nor any stack traces from the softlockup detector.
> It's much better to leave spin_lock() alone to do its thing.
