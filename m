From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi: rtc-efi: use correct EFI 'epoch'
Date: Mon, 8 Jun 2015 22:15:11 +0200
Message-ID: <CAKv+Gu-e03H7nP5UOoSR++CkAt96qsVz1YaR4K8wRPhg7LpEqQ@mail.gmail.com>
References: <1433762834-17961-1-git-send-email-ard.biesheuvel@linaro.org>
	<1433791592.2291.83.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433791592.2291.83.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 8 June 2015 at 21:26, James Bottomley
<James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> On Mon, 2015-06-08 at 13:27 +0200, Ard Biesheuvel wrote:
>> The rtc-efi driver declares that the EFI 'epoch' is 1/1/1998, but
>> the UEFI spec does not define it at all. It does define a minimum
>> of 1900 for the 'Year' member of the EFI_TIME struct, so let's use
>> 1900 as the minimum year and not 1998.
>>
>> This prevents rtc_read_time() failures when the RTC that backs the
>> EFI time services is set to a date before 1998.
>>
>> Cc: Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>
>> Cc: Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
>> Cc: rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  drivers/rtc/rtc-efi.c | 13 +++++++------
>>  1 file changed, 7 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
>> index cb989cd00b14..4a93b0bbf22c 100644
>> --- a/drivers/rtc/rtc-efi.c
>> +++ b/drivers/rtc/rtc-efi.c
>> @@ -25,9 +25,12 @@
>>
>>  #define EFI_ISDST (EFI_TIME_ADJUST_DAYLIGHT|EFI_TIME_IN_DAYLIGHT)
>>  /*
>> - * EFI Epoch is 1/1/1998
>> + * The UEFI spec does not literally define an epoch, but it does
>> + * define EFI_TIME::Year as having a value between 1900 and 9999.
>> + * (UEFI spec v2.5 paragraph 7.3)
>> + * So let's use 1900 as the EFI epoch year.
>>   */
>> -#define EFI_RTC_EPOCH                1998
>> +#define EFI_RTC_EPOCH                1900
>>
>>  /*
>>   * returns day of the year [0-365]
>> @@ -40,8 +43,6 @@ compute_yday(efi_time_t *eft)
>>  }
>>  /*
>>   * returns day of the week [0-6] 0=Sunday
>> - *
>> - * Don't try to provide a year that's before 1998, please !
>>   */
>>  static int
>>  compute_wday(efi_time_t *eft)
>> @@ -60,9 +61,9 @@ compute_wday(efi_time_t *eft)
>>       ndays += compute_yday(eft);
>>
>>       /*
>> -      * 4=1/1/1998 was a Thursday
>> +      * 1=1/1/1900 was a Monday
>>        */
>> -     return (ndays + 4) % 7;
>> +     return (ndays + 1) % 7;
>>  }
>
> This is a bit nuts: increasing the for loop by a huge amount every time
> we call the date just so we can cope with the odd early date.  Why not
> just count backwards for the exception case?  That way the epoch becomes
> an optimisation point, every year actually works, but years far before
> the epoch get penalised in the loop, while our current "efficiency"
> remains ... perhaps plus points if we want to move the epoch to 2015?
>

The 'epoch' is defined by the UEFI spec as starting at 1900, and
changing it to 2015 to optimize this for loop is equally silly imo.
Note that the core purpose of the patch is to change the cutoff point
below which years are rejected, but that context does not appear in
the diff.

rtc_time64_to_tm() already has a better way of counting the leap days
between two years. I'd be happy to propose a followup patch that gets
rid of the for loop entirely.
But those are two separate issues imo.

-- 
Ard.
