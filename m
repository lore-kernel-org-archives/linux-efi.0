From: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH V2 1/4] efi/libstub: Allocate headspace in
 efi_get_memory_map()
Date: Wed, 27 Jul 2016 10:22:17 -0600
Message-ID: <e9d8f0b1-4894-7473-00d1-a28331a17e91@codeaurora.org>
References: <1469132894-17103-1-git-send-email-jhugo@codeaurora.org>
 <1469132894-17103-2-git-send-email-jhugo@codeaurora.org>
 <20160727145750.GH31759@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160727145750.GH31759-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 7/27/2016 8:57 AM, Matt Fleming wrote:
> On Thu, 21 Jul, at 02:28:11PM, Jeffrey Hugo wrote:
>> efi_get_memory_map() allocates a buffer to store the memory map that it
>> retrieves.  This buffer may need to be reused by the client after
>> ExitBootServices() is called, at which point allocations are not longer
>> permitted.  To support this usecase, provide the allocated buffer size back
>> to the client, and allocate some additional headroom to account for any
>> reasonable growth in the map that is likely to happen between the call to
>> efi_get_memory_map() and the client reusing the buffer.
>>
>> Change-Id: Ib0686811581c59eee2eb60b4b62e1628e649d6f0
>
> Please don't include these tags in your patch submission - they don't
> mean anything in the upstream kernel and there's always the chance
> I'll forget to strip it before applying your patch.

Doh, sorry about that.  I apparently was not as vigilant as I should 
have been.  I'll make sure to strip it.

>
>> Signed-off-by: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>> ---
>>  arch/x86/boot/compressed/eboot.c               |  4 +--
>>  drivers/firmware/efi/libstub/efi-stub-helper.c | 36 +++++++++++++++++++-------
>>  drivers/firmware/efi/libstub/fdt.c             |  8 +++---
>>  drivers/firmware/efi/libstub/random.c          |  3 ++-
>>  include/linux/efi.h                            |  3 ++-
>>  5 files changed, 37 insertions(+), 17 deletions(-)
>
> [...]
>
>> index 3bd127f9..3071269 100644
>> --- a/drivers/firmware/efi/libstub/efi-stub-helper.c
>> +++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
>> @@ -41,6 +41,8 @@ static unsigned long __chunk_size = EFI_READ_CHUNK_SIZE;
>>  #define EFI_ALLOC_ALIGN		EFI_PAGE_SIZE
>>  #endif
>>
>> +#define EFI_MMAP_NR_SLACK_SLOTS	8
>> +
>>  struct file_info {
>>  	efi_file_handle_t *handle;
>>  	u64 size;
>> @@ -68,20 +70,24 @@ efi_status_t efi_get_memory_map(efi_system_table_t *sys_table_arg,
>>  				unsigned long *map_size,
>>  				unsigned long *desc_size,
>>  				u32 *desc_ver,
>> -				unsigned long *key_ptr)
>> +				unsigned long *key_ptr,
>> +				unsigned long *buff_size)
>>  {
>>  	efi_memory_desc_t *m = NULL;
>>  	efi_status_t status;
>>  	unsigned long key;
>>  	u32 desc_version;
>>
>> -	*map_size = sizeof(*m) * 32;
>> +	*desc_size = sizeof(*m);
>> +	*map_size = *desc_size * 32;
>> +	*buff_size = *map_size;
>>  again:
>>  	/*
>>  	 * Add an additional efi_memory_desc_t because we're doing an
>>  	 * allocation which may be in a new descriptor region.
>>  	 */
>> -	*map_size += sizeof(*m);
>> +	*map_size += *desc_size;
>> +	*buff_size = *map_size;
>>  	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
>>  				*map_size, (void **)&m);
>>  	if (status != EFI_SUCCESS)
>
> Isn't this chunk of code unnecessary now? If we think 8 entries is
> enough headroom for all scenarios then there's no need to allocate 9.

I guess the original logic still made a bit of sense to me at the time, 
but I'm not attached to it.  Will change.

>
>> @@ -91,8 +97,17 @@ again:
>>  	key = 0;
>>  	status = efi_call_early(get_memory_map, map_size, m,
>>  				&key, desc_size, &desc_version);
>> -	if (status == EFI_BUFFER_TOO_SMALL) {
>> +	if (status == EFI_BUFFER_TOO_SMALL ||
>> +				(*buff_size - *map_size) / *desc_size < 8) {
>
> Please pull this expression into a static inline wrapper, e.g.
>
> static inline bool mmap_has_headroom(unsigned long buff_size,
> 				     unsigned long map_size,
> 				     unsigned long desc_size)
> {
> 	unsigned long slack = buff_size - map_size;
>
>     	return slack / desc_size >= EFI_MMAP_NR_SLACK_SLOTS;
> }
>
> ...
>
> 	if (status == EFI_BUFFER_TOO_SMALL ||
> 	    !mmap_has_headroom(*buff_size, *map_size, *desc_size)) {
>

Sure.


-- 
Jeffrey Hugo
Qualcomm Datacenter Technologies as an affiliate of Qualcomm 
Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
