From: Jeffrey Hugo <jhugo-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Subject: Re: [PATCH] efi/libstub: arm*: double cast memory_map to hide
 compiler warning
Date: Tue, 3 Jan 2017 14:11:53 -0700
Message-ID: <976c2a58-7522-96d5-7b37-2baffdaa409d@codeaurora.org>
References: <20161220113956.GB2225@codeblueprint.co.uk>
 <20161220135207.32492-1-james.morse@arm.com>
 <20161220140728.GE2225@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161220140728.GE2225-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 12/20/2016 7:07 AM, Matt Fleming wrote:
> On Tue, 20 Dec, at 01:52:07PM, James Morse wrote:
>> "efi/libstub: arm*: Pass latest memory map to the kernel" added a new
>> call to update fdt in-place. This caused a new warning on 32bit ARM:
>>
>> ../drivers/firmware/efi/libstub/fdt.c: In function 'allocate_new_fdt_and_exit_boot':
>> ../drivers/firmware/efi/libstub/fdt.c:303:9: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
>>          (u64)memory_map, (u32)map_size);
>>          ^
>>
>> Cast to an integer of native pointer size first.
>>
>> Reported-by: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> Signed-off-by: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
>> ---
>> I guess this too needs to go to stable unless you intend to squash it?
>>
>>  drivers/firmware/efi/libstub/fdt.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> Thanks James, I've folded this into your previous patch.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Thanks James.  I'm happy to see this got cleaned up and sorted out while 
I was on vacation.  I see Ard submitted a pull request already, but for 
what its worth, the latest version on the EFI urgent branch tested ok on 
the platforms I have available.

-- 
Jeffrey Hugo
Qualcomm Datacenter Technologies as an affiliate of Qualcomm 
Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the
Code Aurora Forum, a Linux Foundation Collaborative Project.
