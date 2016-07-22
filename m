From: Prarit Bhargava <prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: ESRT failures ... was Re: [PATCH 04/11] efi: Add efi_memmap_init_late()
 for permanent EFI memmap
Date: Fri, 22 Jul 2016 09:31:20 -0400
Message-ID: <57922028.7070103@redhat.com>
References: <57867F32.8040001@redhat.com> <20160721121136.GF26504@codeblueprint.co.uk> <5790DFD0.4020806@redhat.com> <20160722131101.GJ26504@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160722131101.GJ26504-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Lenny Szubowicz <lszubowi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



On 07/22/2016 09:11 AM, Matt Fleming wrote:
> On Thu, 21 Jul, at 10:44:32AM, Prarit Bhargava wrote:
>>
>>
>> On 07/21/2016 08:11 AM, Matt Fleming wrote:
>>>
>>> efi_mem_desc_lookup() should just return the correct EFI memory
>>> descriptor now that we have efi_mem_reserve() coming in v4.9.
>>>
>>> What does the EFI memmap (as printed with efi=debug) look like on your
>>> machine?
>>>
>>
>> [    0.000000] efi: EFI v2.40 by Dell Inc.
>> [    0.000000] efi:  ESRT=0x8eb1c000  ACPI=0x8efe7000  ACPI 2.0=0x8efe7014
>> SMBIOS=0x8ef69000
>>
>> and
>>
>> [    0.000000] efi: mem249: [Reserved           |   |  |  |  |  |  |  |
>> |WB|WT|WC|UC] range=[0x000000008d6df000-0x000000008ef69fff] (24MB)
> 
> Yeah, that's a Dell firmware bug. This should be EFI boot services
> data. Quoting the spec Section 22.3 EFI System Resource Table,
> 
>   "See Section 4.6 for description of how to publish ESRT using
>    EFI_CONFIGURATION_TABLE. The ESRT shall be stored in memory of type
>    EfiBootServicesData."
> 
> We do not use regions mark EFI_RESERVED_TYPE because they're basically
> supposed to be unusable by the OS, AFAIK. I guess we'll have to update
> efi_mem_desc_lookup() to return reserved regions and make sure they're
> always contained within the memmap.
> 

Hmm ... maybe just a Dell specific quirk?

P.
