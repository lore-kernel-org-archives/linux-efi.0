From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi/arm32-stub: allow boottime allocations in the vmlinux region
Date: Thu, 16 Mar 2017 22:02:32 +0000
Message-ID: <CAKv+Gu-=Q3aiECtT7krscjUcBsmDZsRRCUTjpOUfdg_NgV90=Q@mail.gmail.com>
References: <1489661776-12946-1-git-send-email-ard.biesheuvel@linaro.org>
 <20170316112653.GA16034@bivouac.eciton.net> <CAKWsp+whVJxoCrycACjWXRmK6rYvcOhLMeHKYYKRMXhhQ8A8Og@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKWsp+whVJxoCrycACjWXRmK6rYvcOhLMeHKYYKRMXhhQ8A8Og-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roy Franz <rfranz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Cohen, Eugene" <eugene-VXdhtT5mjnY@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 16 March 2017 at 21:56, Roy Franz <rfranz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, Mar 16, 2017 at 4:26 AM, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> On Thu, Mar 16, 2017 at 10:56:16AM +0000, Ard Biesheuvel wrote:
>>> The arm32 kernel decompresses itself to the base of DRAM unconditionally,
>>> and so it is the EFI stub's job to ensure that the region is available.
>>>
>>> Currently, we do this by creating an allocation there, and giving up if
>>> that fails. However, any boot services regions occupying this area are
>>> not an issue, given that the decompressor executes strictly after the
>>> stub calls ExitBootServices().
>>>
>>> So let's try a bit harder to proceed if the initial allocation fails,
>>> and check whether any memory map entries occupying the region may be
>>> considered safe.
>>>
>>> Reported-by: Eugene Cohen <eugene-VXdhtT5mjnY@public.gmane.org>
>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>> ---
>>>
>>> NOTE: This patch appears to have uncovered a bug in DxeCore's AllocatePages
>>> routine. If the first allocate_pages(EFI_ALLOCATE_ADDRESS) call fails, we may
>>> still end up with a memory map that reflects a kind of limbo state where the
>>> intended allocation is carved out and partially converted.
>>>
>>> For example, starting from
>>>
>>> 0x000040000000-0x00004007ffff [ConventionalMemory ]
>>> 0x000040080000-0x00004009ffff [Boot Data          ]
>>> 0x0000400a0000-0x000047ffffff [ConventionalMemory ]
>>>
>>> the failed allocation of 32 MB of LoaderData @ 0x4000_0000 will result in
>>>
>>> 0x000040000000-0x00004007ffff [Loader Data        ]
>>> 0x000040080000-0x00004009ffff [Boot Data          ]
>>> 0x0000400a0000-0x000047ffffff [ConventionalMemory ]
>>>
>>> after which scanning the region for LoaderData regions (which we should reject
>>> given that they could be freed and replaced with, e.g., runtime services data
>>> regions) will always fail.
>>>
>>> For this reason, the allocate_pages(EFI_ALLOCATE_ADDRESS) has been modified to
>>> use EfiBootServicesData instead. In the mean time, I will report this to the
>>> EDK2 development mailing list.
>>
>> That feels a little bit eeew, but I can't see it breaking anything.
>>
> (Sorry for HTML the first time...)
>
> Would it be reasonable to do a trial allocation with
>  EFI_BOOT_SERVICES_DATA first, and if that passes then free
> it and do the allocation with EFI_LOADER_DATA?  This keeps the final
> allocation of the desired type,
> but since this allocation is short lived I don't think it matters that much.
> If left as is, I think it deserves a comment in the source so this
> non-standard allocation is identified (and not copied).
>
> Also, if the fallback case fails, we may leave a bunch of memory allocated,
> which could interfere with something
> run after a failed kernel boot.  I'm guessing in practice there won't be
> anything run that needs a lot of memory,
> but we're not being a good citizen in this regard.
>

The thing is that we are not actually allocating anything there, we
only allocate it to ensure that nothing else uses the region. This
means the second time around (e.g., if the stub exits to the uefi
shell for some reason, and is invoked again), we will not reserve even
more memory, but simply notice that the region we want to claim for
the decompressed kernels has already been claimed.

> I don't feel strongly about either of the above, as they are more
> theoretical problems.
>
> Reviewed-by: Roy Franz <roy.franz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
>>>  drivers/firmware/efi/libstub/arm32-stub.c | 137 +++++++++++++++++---
>>>  1 file changed, 117 insertions(+), 20 deletions(-)
>>>
>>> diff --git a/drivers/firmware/efi/libstub/arm32-stub.c b/drivers/firmware/efi/libstub/arm32-stub.c
>>> index e1f0b28e1dcb..4e1b6478986e 100644
>>> --- a/drivers/firmware/efi/libstub/arm32-stub.c
>>> +++ b/drivers/firmware/efi/libstub/arm32-stub.c
>>> @@ -63,6 +63,121 @@ void free_screen_info(efi_system_table_t *sys_table_arg, struct screen_info *si)
>>>       efi_call_early(free_pool, si);
>>>  }
>>>
>>> +static efi_status_t reserve_kernel_base(efi_system_table_t *sys_table_arg,
>>> +                                     unsigned long dram_base,
>>> +                                     unsigned long *reserve_addr,
>>> +                                     unsigned long *reserve_size)
>>> +{
>>> +     efi_physical_addr_t alloc_addr;
>>> +     efi_memory_desc_t *memory_map;
>>> +     unsigned long nr_pages, map_size, desc_size, buff_size;
>>> +     efi_status_t status;
>>> +     unsigned long l;
>>> +
>>> +     struct efi_boot_memmap map = {
>>> +             .map            = &memory_map,
>>> +             .map_size       = &map_size,
>>> +             .desc_size      = &desc_size,
>>> +             .desc_ver       = NULL,
>>> +             .key_ptr        = NULL,
>>> +             .buff_size      = &buff_size,
>>> +     };
>>> +
>>> +     /*
>>> +      * Reserve memory for the uncompressed kernel image. This is
>>> +      * all that prevents any future allocations from conflicting
>>> +      * with the kernel. Since we can't tell from the compressed
>>> +      * image how much DRAM the kernel actually uses (due to BSS
>>> +      * size uncertainty) we allocate the maximum possible size.
>>> +      * Do this very early, as prints can cause memory allocations
>>> +      * that may conflict with this.
>>> +      */
>>> +     alloc_addr = dram_base;
>>> +     *reserve_size = MAX_UNCOMP_KERNEL_SIZE;
>>> +     nr_pages = round_up(*reserve_size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
>>> +     status = sys_table_arg->boottime->allocate_pages(EFI_ALLOCATE_ADDRESS,
>>> +                                                      EFI_BOOT_SERVICES_DATA,
>>> +                                                      nr_pages, &alloc_addr);
>
> This should use efi_call_early() to be consistent with the rest of the
> file.  (It was
> the only direct call before, so we should fix that now.)
>

Good point, I will change that
