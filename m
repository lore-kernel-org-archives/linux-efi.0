From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 6/6] arm64/efi: remove idmap manipulations from UEFI code
Date: Fri, 24 Oct 2014 15:53:21 +0200
Message-ID: <CAKv+Gu8x3GGo=GeMWK4P8grTmZPq6dh3K-WZDmaWq=G-cKJhNA@mail.gmail.com>
References: <1414154384-15385-1-git-send-email-ard.biesheuvel@linaro.org>
	<1414154384-15385-7-git-send-email-ard.biesheuvel@linaro.org>
	<CACxGe6uc9VZs4fMS+U9W=wG3bJr2pm=tREQsqvF91LgKdsXjqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACxGe6uc9VZs4fMS+U9W=wG3bJr2pm=tREQsqvF91LgKdsXjqw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "Fleming, Matt (matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org)" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 24 October 2014 15:41, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On Fri, Oct 24, 2014 at 1:39 PM, Ard Biesheuvel
> <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
>> Now that we have moved the call to SetVirtualAddressMap() to the stub,
>> UEFI has no use for the ID map, so we can drop the code that installs
>> ID mappings for UEFI memory regions.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>
> I have to say, this series makes me happy. :-)
>
> This method will go a long way to catching UEFI implementations that
> do incorrect things after exitbootservices is called. I'm assuming
> that any attempt to access a region that boot services has not
> requested will get trapped by the kernel, correct?
>

If we really want to catch firmware problems, we should probably wipe
all boot services regions between the calls to ExitBootServices() and
SetVirtualAddressMap(). Mark Salter's original approach here was
fairly cautious here, i.e., reserving boot services regions until
after the call to SetVirtualAddressMap(), but there is no point in
doing that for kexec, that's why I removed it.

-- 
Ard.



>> ---
>>  arch/arm64/include/asm/efi.h |  4 ++--
>>  arch/arm64/include/asm/mmu.h |  2 --
>>  arch/arm64/kernel/efi.c      | 26 +-------------------------
>>  arch/arm64/kernel/setup.c    |  2 +-
>>  arch/arm64/mm/mmu.c          | 10 ----------
>>  5 files changed, 4 insertions(+), 40 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
>> index d752e5480096..09854df5a2a1 100644
>> --- a/arch/arm64/include/asm/efi.h
>> +++ b/arch/arm64/include/asm/efi.h
>> @@ -6,10 +6,10 @@
>>
>>  #ifdef CONFIG_EFI
>>  extern void efi_init(void);
>> -extern void efi_idmap_init(void);
>> +extern void efi_virtmap_init(void);
>>  #else
>>  #define efi_init()
>> -#define efi_idmap_init()
>> +#define efi_virtmap_init()
>>  #endif
>>
>>  void efi_load_rt_mapping(void);
>> diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
>> index bcf166043a8b..df33cf02300a 100644
>> --- a/arch/arm64/include/asm/mmu.h
>> +++ b/arch/arm64/include/asm/mmu.h
>> @@ -31,8 +31,6 @@ extern void paging_init(void);
>>  extern void setup_mm_for_reboot(void);
>>  extern void __iomem *early_io_map(phys_addr_t phys, unsigned long virt);
>>  extern void init_mem_pgprot(void);
>> -/* create an identity mapping for memory (or io if map_io is true) */
>> -extern void create_id_mapping(phys_addr_t addr, phys_addr_t size, int map_io);
>>  extern void create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
>>                                unsigned long virt, phys_addr_t size,
>>                                int map_io, int map_xn);
>> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
>> index cbff3e8eff11..02bd7e877f0b 100644
>> --- a/arch/arm64/kernel/efi.c
>> +++ b/arch/arm64/kernel/efi.c
>> @@ -53,27 +53,6 @@ static int __init is_normal_ram(efi_memory_desc_t *md)
>>         return 0;
>>  }
>>
>> -static void __init efi_setup_idmap(void)
>> -{
>> -       struct memblock_region *r;
>> -       efi_memory_desc_t *md;
>> -       u64 paddr, npages, size;
>> -
>> -       for_each_memblock(memory, r)
>> -               create_id_mapping(r->base, r->size, 0);
>> -
>> -       /* map runtime io spaces */
>> -       for_each_efi_memory_desc(&memmap, md) {
>> -               if (!(md->attribute & EFI_MEMORY_RUNTIME) || is_normal_ram(md))
>> -                       continue;
>> -               paddr = md->phys_addr;
>> -               npages = md->num_pages;
>> -               memrange_efi_to_native(&paddr, &npages);
>> -               size = npages << PAGE_SHIFT;
>> -               create_id_mapping(paddr, size, 1);
>> -       }
>> -}
>> -
>>  /*
>>   * Translate a EFI virtual address into a physical address: this is necessary,
>>   * as some data members of the EFI system table are virtually remapped after
>> @@ -251,16 +230,13 @@ static struct mm_struct efi_mm = {
>>         INIT_MM_CONTEXT(efi_mm)
>>  };
>>
>> -void __init efi_idmap_init(void)
>> +void __init efi_virtmap_init(void)
>>  {
>>         efi_memory_desc_t *md;
>>
>>         if (!efi_enabled(EFI_BOOT))
>>                 return;
>>
>> -       /* boot time idmap_pg_dir is incomplete, so fill in missing parts */
>> -       efi_setup_idmap();
>> -
>>         for_each_efi_memory_desc(&memmap, md) {
>>                 u64 paddr, npages, size;
>>
>> diff --git a/arch/arm64/kernel/setup.c b/arch/arm64/kernel/setup.c
>> index 2437196cc5d4..a6028490a28f 100644
>> --- a/arch/arm64/kernel/setup.c
>> +++ b/arch/arm64/kernel/setup.c
>> @@ -392,7 +392,7 @@ void __init setup_arch(char **cmdline_p)
>>         paging_init();
>>         request_standard_resources();
>>
>> -       efi_idmap_init();
>> +       efi_virtmap_init();
>>
>>         unflatten_device_tree();
>>
>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>> index f7d17a5a1f56..19eae06aab81 100644
>> --- a/arch/arm64/mm/mmu.c
>> +++ b/arch/arm64/mm/mmu.c
>> @@ -282,16 +282,6 @@ static void __init create_mapping(phys_addr_t phys, unsigned long virt,
>>                          size, 0, 0);
>>  }
>>
>> -void __init create_id_mapping(phys_addr_t addr, phys_addr_t size, int map_io)
>> -{
>> -       if ((addr >> PGDIR_SHIFT) >= ARRAY_SIZE(idmap_pg_dir)) {
>> -               pr_warn("BUG: not creating id mapping for %pa\n", &addr);
>> -               return;
>> -       }
>> -       __create_mapping(&init_mm, &idmap_pg_dir[pgd_index(addr)],
>> -                        addr, addr, size, map_io, 0);
>> -}
>> -
>>  void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
>>                                unsigned long virt, phys_addr_t size,
>>                                int map_io, int map_xn)
>> --
>> 1.8.3.2
>>
