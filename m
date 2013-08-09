From: Roy Franz <roy.franz@linaro.org>
Subject: Re: [PATCH 12/17] Add proper definitions for some EFI function pointers.
Date: Fri, 9 Aug 2013 07:13:01 -0700
Message-ID: <CAFECyb9=zJQ-Fhyc+QojtcCtK_ue+fvn=VoOc6_Sq8D6v0uALA@mail.gmail.com>
References: <1375847113-24884-1-git-send-email-roy.franz@linaro.org>
	<1375847113-24884-13-git-send-email-roy.franz@linaro.org>
	<1376057413.12443.91.camel@t520.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1376057413.12443.91.camel@t520.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, matt.fleming@intel.com, Russell King - ARM Linux <linux@arm.linux.org.uk>, Leif Lindholm <leif.lindholm@linaro.org>, Dave Martin <dave.martin@arm.com>
List-Id: linux-efi@vger.kernel.org

Thanks Mark - I'll get that in the next version of the patches.

On Fri, Aug 9, 2013 at 7:10 AM, Mark Salter <msalter@redhat.com> wrote:
> On Tue, 2013-08-06 at 20:45 -0700, Roy Franz wrote:
>> The x86/AMD64 EFI stubs must us a call wrapper to convert between
>> the Linux and EFI ABIs, so void pointers are sufficient.  For ARM,
>> the ABIs are compatible, so we can directly invoke the function
>> pointers.  The functions that are used by the ARM stub are updated
>> to match the EFI definitions.
>>
>> Signed-off-by: Roy Franz <roy.franz@linaro.org>
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
>>
>>  typedef struct {
>>       u32 type;
>> @@ -157,11 +160,12 @@ typedef struct {
>>       efi_table_hdr_t hdr;
>>       void *raise_tpl;
>>       void *restore_tpl;
>> -     void *allocate_pages;
>> -     void *free_pages;
>> -     void *get_memory_map;
>> -     void *allocate_pool;
>> -     void *free_pool;
>> +     int (*allocate_pages)(int, int, unsigned long, efi_physical_addr_t *);
>> +     int (*free_pages)(efi_physical_addr_t, unsigned long);
>
> All of the actual function pointers that were added should return an
> efi_status_t instead of int. On arm64, I was seeing an unrecognizable
> error status because the truncation from 64 to 32 bits.
>
> --Mark
>
>
