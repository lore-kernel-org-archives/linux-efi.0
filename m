From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi: fdt: avoid FDT manipulation after ExitBootServices()
Date: Wed, 1 Feb 2017 19:28:24 +0000
Message-ID: <CAKv+Gu9-Ug8oUv56oyzb7VxgRac2iv1xQcZ+jU-0NdcQr5226A@mail.gmail.com>
References: <1485971102-23330-1-git-send-email-ard.biesheuvel@linaro.org>
 <1485971102-23330-2-git-send-email-ard.biesheuvel@linaro.org> <20170201190341.GA1060@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170201190341.GA1060-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Riku Voipio <riku.voipio-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 1 February 2017 at 19:03, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> * Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>
>> Some AArch64 UEFI implementations disable the MMU in ExitBootServices(),
>> after which unaligned accesses to RAM are no longer supported.
>>
>> Commit abfb7b686a3e ("efi/libstub/arm*: Pass latest memory map to the
>> kernel") fixed an issue in the memory map handling of the stub FDT code,
>> but inadvertently created an issue with such firmwares, by moving some
>> of the FDT manipulation to after the invocation of ExitBootServices().
>> Given that the stub's libfdt implementation uses the ordinary, accelerated
>> string functions, which rely on hardware handling of unaligned accesses,
>> manipulating the FDT with the MMU off may result in alignment faults.
>>
>> So fix the situation by moving the update_fdt_memmap() call into the
>> callback function invoked by efi_exit_boot_services() right before it
>> calls the ExitBootServices() UEFI service (which is arguably a better
>> place for it anyway)
>>
>> Note that disabling the MMU in ExitBootServices() is not compliant with
>> the UEFI spec, and carries great risk due to the fact that switching from
>> cached to uncached memory accesses halfway through compiler generated code
>> (i.e., involving a stack) can never be done in a way that is architecturally
>> safe.
>>
>> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
>> Fixes: abfb7b686a3e ("efi/libstub/arm*: Pass latest memory map to the kernel")
>> Tested-by: Riku Voipio <riku.voipio-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  drivers/firmware/efi/libstub/fdt.c | 14 +++-----------
>>  1 file changed, 3 insertions(+), 11 deletions(-)
>>
>> diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
>> index 921dfa047202..260c4b4b492e 100644
>> --- a/drivers/firmware/efi/libstub/fdt.c
>> +++ b/drivers/firmware/efi/libstub/fdt.c
>> @@ -187,6 +187,7 @@ static efi_status_t update_fdt_memmap(void *fdt, struct efi_boot_memmap *map)
>>  struct exit_boot_struct {
>>       efi_memory_desc_t *runtime_map;
>>       int *runtime_entry_count;
>> +     void *new_fdt_addr;
>>  };
>>
>>  static efi_status_t exit_boot_func(efi_system_table_t *sys_table_arg,
>> @@ -202,7 +203,7 @@ static efi_status_t exit_boot_func(efi_system_table_t *sys_table_arg,
>>       efi_get_virtmap(*map->map, *map->map_size, *map->desc_size,
>>                       p->runtime_map, p->runtime_entry_count);
>>
>> -     return EFI_SUCCESS;
>> +     return update_fdt_memmap(p->new_fdt_addr, map);
>>  }
>>
>>  /*
>> @@ -300,22 +301,13 @@ efi_status_t allocate_new_fdt_and_exit_boot(efi_system_table_t *sys_table,
>>
>>       priv.runtime_map = runtime_map;
>>       priv.runtime_entry_count = &runtime_entry_count;
>> +     priv.new_fdt_addr = (void *)*new_fdt_addr;
>
> Nit: could the type cast by dropped?
>

new_fdt_addr is a pointer to unsigned long, so we can't drop the cast
here without introducing it somewhere else.
