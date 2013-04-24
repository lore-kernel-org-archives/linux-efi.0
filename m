From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] efi: Check EFI revision in setup_efi_vars
Date: Wed, 24 Apr 2013 15:57:07 +0100
Message-ID: <5177F2C3.5080907@intel.com>
References: <20130424143738.GB15272@hansolo.jdub.homelinux.org> <5177EFCE.80104@intel.com> <20130424145449.GC15272@hansolo.jdub.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130424145449.GC15272-dHPIJuKSOV01V+h/cAXI7w8O6CCKKCg3HZ5vskTnxNA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 24/04/13 15:54, Josh Boyer wrote:
> On Wed, Apr 24, 2013 at 03:44:30PM +0100, Matt Fleming wrote:
>> On 24/04/13 15:37, Josh Boyer wrote:
>>> We need to check the runtime sys_table for the EFI version the firmware
>>> specifies instead of just checking for a NULL QueryVariableInfo.  Older
>>> implementations of EFI don't have QueryVariableInfo but the runtime is
>>> a smaller structure, so the pointer to it may be pointing off into garbage.
>>>
>>> This is apparently the case with several Apple firmwares that support EFI
>>> 1.10, and the current check causes them to no longer boot.  Fix based on
>>> a suggestion from Matthew Garrett.
>>>
>>> Signed-off-by: Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> ---
>>>  arch/x86/boot/compressed/eboot.c | 4 +++-
>>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
>>> index 8615f75..b46efbf 100644
>>> --- a/arch/x86/boot/compressed/eboot.c
>>> +++ b/arch/x86/boot/compressed/eboot.c
>>> @@ -258,7 +258,9 @@ static efi_status_t setup_efi_vars(struct boot_params *params)
>>>  	u64 store_size, remaining_size, var_size;
>>>  	efi_status_t status;
>>>  
>>> -	if (!sys_table->runtime->query_variable_info)
>>> +	if (sys_table->runtime->hdr.revision < EFI_2_00_SYSTEM_TABLE_REVISION)
>>> +		return EFI_UNSUPPORTED;
>>> +	else if(!sys_table->runtime->query_variable_info)
>>>  		return EFI_UNSUPPORTED;
>>>  
>>>  	data = (struct setup_data *)(unsigned long)params->hdr.setup_data;
>>>
>>
>> Thanks Josh, that looks correct.
>>
>> It's a small point, but does the check against NULL actually make sense?
>> I don't think we ever check other system table pointers against NULL.
> 
> That I'm not sure of.  I was going off of the assumption that Matthew
> put it there because someone's EFI 2.0 implementation was crappy and
> didn't actually implement it.  So I left that check in place for now.

I presume that if that were true, virt_efi_query_variable_info() (which
is called indirectly from the efivars code) would have exploded before
now. Matthew?
