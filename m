From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] EFI: move efi_mem_type() to common code
Date: Thu, 24 Aug 2017 10:52:37 +0100
Message-ID: <CAKv+Gu8WEO_T9bUiCz-QdBOj1pFw-tdit=ZW2kxpk124+_mMLw@mail.gmail.com>
References: <599EB46E02000078001730B1@prv-mh.provo.novell.com>
 <CAKv+Gu9W12HqA+oK4p0COXpgSi=HWUg_xv5s=mO1YQf7oVtjMA@mail.gmail.com> <599EBCF102000078001730F3@prv-mh.provo.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <599EBCF102000078001730F3-rw/UEucdPrvD8XXLLHKrIiOjQekVJEpY@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 24 August 2017 at 10:48, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org> wrote:
>>>> On 24.08.17 at 11:18, <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> On 24 August 2017 at 10:11, Jan Beulich <JBeulich-IBi9RG/b67k@public.gmane.org> wrote:
>>> --- 4.13-rc6-EFI.orig/drivers/firmware/efi/efi.c
>>> +++ 4.13-rc6-EFI/drivers/firmware/efi/efi.c
>>> @@ -819,6 +819,35 @@ u64 __weak efi_mem_attributes(unsigned l
>>>         return 0;
>>>  }
>>>
>>> +/*
>>> + * efi_mem_type - lookup memmap type for physical address
>>> + * @phys_addr: the physical address to lookup
>>> + *
>>> + * Search in the EFI memory map for the region covering @phys_addr.
>>> + * Returns the EFI memory type if the region was found in the memory
>>> + * map, EFI_RESERVED_TYPE (zero) otherwise.
>>> + *
>>> + * Despite being marked __weak, most architectures should *not*
>>> + * override this function. It is __weak solely for the benefit
>>> + * of ia64 which has a funky EFI memory map that doesn't work
>>> + * the same way as other architectures.
>>> + */
>>> +u32 __weak efi_mem_type(unsigned long phys_addr)
>>
>> Why is this __weak now?
>
> As the comment (matching the one ahead of efi_mem_attributes())
> says, in particular for ia64 to be able to override it.
>

Apologies. I don't know how I could miss that ...

If it already has its own version, I'd prefer we just add #ifndef
CONFIG_IA64 around it instead.
