From: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH V2 2/4] efi/libstub: Introduce ExitBootServices helper
Date: Wed, 27 Jul 2016 13:21:17 -0600
Message-ID: <32feffc6-a789-fcce-0e53-cc473247bb76@codeaurora.org>
References: <1469132894-17103-1-git-send-email-jhugo@codeaurora.org>
 <1469132894-17103-3-git-send-email-jhugo@codeaurora.org>
 <20160727180318.GI31759@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160727180318.GI31759-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, timur-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 7/27/2016 12:03 PM, Matt Fleming wrote:
> On Thu, 21 Jul, at 02:28:12PM, Jeffrey Hugo wrote:
>> The spec allows ExitBootServices to fail with EFI_INVALID_PARAMETER if a
>> race condition has occurred where the EFI has updated the memory map after
>> the stub grabbed a reference to the map.  The spec defines a retry
>> proceedure with specific requirements to handle this scenario.
>>
>> No current stub implementation correctly follows the spec in this regard,
>> so add a helper to the stub library that correctly adhears to the spec and
>> abstracts the complexity from stubs.
>
> The thing missing from this changelog is the fact that you have run
> into this problem in the real world - it's not just a matter of spec
> conformance, this is required to boot machines in the wild.
>
> In other words, the current changelog does not reflect the importance
> of these patches.

Sure, I'll amend the text here to clarify that point.

>
>> Signed-off-by: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
>> ---
>>  drivers/firmware/efi/libstub/efi-stub-helper.c | 93 ++++++++++++++++++++++++++
>>  include/linux/efi.h                            | 19 ++++++
>>  2 files changed, 112 insertions(+)
>>
>> diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
>> index 3071269..d5be0b5 100644
>> --- a/drivers/firmware/efi/libstub/efi-stub-helper.c
>> +++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
>> @@ -720,3 +720,96 @@ char *efi_convert_cmdline(efi_system_table_t *sys_table_arg,
>>  	*cmd_line_len = options_bytes;
>>  	return (char *)cmdline_addr;
>>  }
>> +
>> +/*
>> + * Handle calling ExitBootServices according to the requirements set out by the
>> + * spec.  Obtains the current memory map, and returns that info after calling
>> + * ExitBootServices.  Client has the option to specify a function to process the
>> + * memory map data.  A client specific structure may be passed to the function
>> + * via priv.  The client function may be called multiple times.
>> + */
>
> Why have you made priv_func optional? This series does not contain any
> callers of efi_exit_boot_services() that pass NULL for 'priv_func', so
> making it optional is over-engineering.

It seemed trivial to make it optional, and reasonable that some future 
client may not require the functionality, so passing in a do nothing 
function seemed inelegant.

Since you feel this is over-engineering, I'll make it mandatory.

>
>> +efi_status_t efi_exit_boot_services(efi_system_table_t *sys_table,
>> +				    void *handle,
>> +				    efi_memory_desc_t **memory_map,
>> +				    unsigned long *map_size,
>> +				    unsigned long *desc_size,
>> +				    u32 *desc_ver,
>> +				    unsigned long *mmap_key,
>> +				    void *priv,
>> +				    efi_status_t (*priv_func)(
>> +						efi_system_table_t *sys_table,
>> +						void *handle,
>> +						efi_memory_desc_t *memory_map,
>> +						unsigned long *map_size,
>> +						unsigned long *desc_size,
>> +						u32 *desc_ver,
>> +						unsigned long *mmap_key,
>> +						unsigned long buff_size,
>> +						void *priv))
>
> This needs a struct passing as the parameter not this huge list.
>
> In fact, efi_get_memory_map() would also benefit from passing a single
> struct as an argument.
>
> Also, don't define the function signature inside of another function's
> prototype - use a typedef instead.

Sure, I'll look at addressing the function signature here.

>
>> +{
>> +	efi_status_t status;
>> +	unsigned long buff_size;
>> +
>> +	status = efi_get_memory_map(sys_table, memory_map, map_size,
>> +				    desc_size, desc_ver, mmap_key, &buff_size);
>> +
>> +	if (status != EFI_SUCCESS)
>> +		goto fail;
>> +
>> +	if (priv_func) {
>> +		status = priv_func(sys_table, handle, *memory_map, map_size,
>> +				   desc_size, desc_ver, mmap_key, buff_size,
>> +				   priv);
>> +		if (status != EFI_SUCCESS)
>> +			goto free_map;
>> +	}
>> +
>
> Why not move the priv_func call until after we know ExitBootServices()
> returned successfully? That way we don't have to make two calls and
> the callee doesn't need to handle that.
>

It keeps the code flow for FDT (patch 3 in the series) and x86 (patch 4) 
the same as before, and x86 seems to require that its function occurs 
before ExitBootServices().

exit_boot() calls alloc_e820ext() based on the contents of the current 
memory map, which invokes allocate_pool().  Per my understanding of the 
spec, allocate_pool() should not be called after ExitBootServices(), and 
per my understanding of the x86 code, alloc_e820ext() needs to be called 
between getting the current memory map, and ExitBootServices().  Am I 
incorrect, and there is an option to restructure the x86 code so that 
this ordering is not required?

-- 
Jeffrey Hugo
Qualcomm Datacenter Technologies as an affiliate of Qualcomm 
Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
