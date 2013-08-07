From: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 12/17] Add proper definitions for some EFI function pointers.
Date: Wed, 7 Aug 2013 10:20:42 -0700
Message-ID: <CAFECyb_ZoCCMs75FLtGewfFQy1m5aVw6s5Jv1H1vaxg976qFNA@mail.gmail.com>
References: <1375847113-24884-1-git-send-email-roy.franz@linaro.org>
	<1375847113-24884-13-git-send-email-roy.franz@linaro.org>
	<20130807130950.GF2515@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130807130950.GF2515-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dave Martin <dave.martin-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Aug 7, 2013 at 6:09 AM, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org> wrote:
> On Tue, 06 Aug, at 08:45:08PM, Roy Franz wrote:
>> The x86/AMD64 EFI stubs must us a call wrapper to convert between
>> the Linux and EFI ABIs, so void pointers are sufficient.  For ARM,
>> the ABIs are compatible, so we can directly invoke the function
>> pointers.  The functions that are used by the ARM stub are updated
>> to match the EFI definitions.
>>
>> Signed-off-by: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  include/linux/efi.h |   42 +++++++++++++++++++++++++-----------------
>>  1 file changed, 25 insertions(+), 17 deletions(-)
>>
>> diff --git a/include/linux/efi.h b/include/linux/efi.h
>> index 51f5641..96bb866 100644
>> --- a/include/linux/efi.h
>> +++ b/include/linux/efi.h
>> @@ -39,6 +39,8 @@
>>  typedef unsigned long efi_status_t;
>>  typedef u8 efi_bool_t;
>>  typedef u16 efi_char16_t;            /* UNICODE character */
>> +typedef u64 efi_physical_addr_t;
>> +typedef void *efi_handle_t;
>>
>>
>>  typedef struct {
>> @@ -96,6 +98,7 @@ typedef     struct {
>>  #define EFI_MEMORY_DESCRIPTOR_VERSION        1
>>
>>  #define EFI_PAGE_SHIFT               12
>> +#define EFI_PAGE_SIZE                (1UL << EFI_PAGE_SHIFT)
>
> It would be worth getting rid of the EFI_PAGE_SIZE definition in
> arch/x86/boot/compressed/eboot.h now that we have one here.
>
> --
> Matt Fleming, Intel Open Source Technology Center

I'll get this in the next version.

Thanks,
Roy
