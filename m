From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 10/16] Move EFI_READ_CHUNK_SIZE define to shared location.
Date: Fri, 30 Aug 2013 15:49:46 -0700
Message-ID: <CAFECyb-cdnr0rC167-14gYw0rXD42i3BXzCaZWsUJ6RvE0hz=Q@mail.gmail.com>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
	<1376090777-20090-11-git-send-email-roy.franz@linaro.org>
	<20130830133302.E163A3E102A@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130830133302.E163A3E102A@localhost>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>
Cc: Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dave Martin <dave.martin-5wv7dgnIgG8@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Aug 30, 2013 at 6:33 AM, Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org> wrote:
> On Fri,  9 Aug 2013 16:26:11 -0700, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> This #define is only used the the shared code, so move
>> it there.
>>
>> Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>
> Can this be squashed into patch 1?

Yes, that makes sense.

>
> g.
>
>> ---
>>  arch/x86/boot/compressed/eboot.h       |    1 -
>>  drivers/firmware/efi/efi-stub-helper.c |    2 +-
>>  2 files changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/boot/compressed/eboot.h b/arch/x86/boot/compressed/eboot.h
>> index faa0bdf..bafbd94 100644
>> --- a/arch/x86/boot/compressed/eboot.h
>> +++ b/arch/x86/boot/compressed/eboot.h
>> @@ -12,7 +12,6 @@
>>  #define DESC_TYPE_CODE_DATA  (1 << 0)
>>
>>  #define EFI_PAGE_SIZE                (1UL << EFI_PAGE_SHIFT)
>> -#define EFI_READ_CHUNK_SIZE  (1024 * 1024)
>>
>>  #define EFI_CONSOLE_OUT_DEVICE_GUID    \
>>       EFI_GUID(0xd3b36f2c, 0xd551, 0x11d4, 0x9a, 0x46, 0x0, 0x90, 0x27, \
>> diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
>> index 0f4d6e6..b707a9f 100644
>> --- a/drivers/firmware/efi/efi-stub-helper.c
>> +++ b/drivers/firmware/efi/efi-stub-helper.c
>> @@ -9,7 +9,7 @@
>>   * under the terms of the GNU General Public License version 2.
>>   *
>>   */
>> -
>> +#define EFI_READ_CHUNK_SIZE  (1024 * 1024)
>>
>>  struct file_info {
>>       efi_file_handle_t *handle;
>> --
>> 1.7.10.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
