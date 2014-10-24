From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/6] arm64/mm: add create_pgd_mapping() to create private
 page tables
Date: Fri, 24 Oct 2014 17:42:15 +0200
Message-ID: <CAKv+Gu_1V2KpxDxg=Na0_OCTGunoOHb5ZZhwAaOcZLn58rGh2Q@mail.gmail.com>
References: <1414154384-15385-1-git-send-email-ard.biesheuvel@linaro.org>
	<1414154384-15385-3-git-send-email-ard.biesheuvel@linaro.org>
	<20141024151743.GA22807@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141024151743.GA22807-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Capper <steve.capper-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 24 October 2014 17:17, Steve Capper <steve.capper-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On Fri, Oct 24, 2014 at 02:39:40PM +0200, Ard Biesheuvel wrote:
>> For UEFI, we need to install the memory mappings used for Runtime Services
>> in a dedicated set of page tables. Add create_pgd_mapping(), which allows
>> us to allocate and install those page table entries early.
>> This also adds a 'map_xn' option, that creates regions with the PXN and
>> UXN bits set.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>
> Hi Ard,
>
> Some comments below...
>
>> ---
>>  arch/arm64/include/asm/mmu.h |  3 +++
>>  arch/arm64/mm/mmu.c          | 28 ++++++++++++++++++++--------
>>  2 files changed, 23 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
>> index c2f006c48bdb..bcf166043a8b 100644
>> --- a/arch/arm64/include/asm/mmu.h
>> +++ b/arch/arm64/include/asm/mmu.h
>> @@ -33,5 +33,8 @@ extern void __iomem *early_io_map(phys_addr_t phys, unsigned long virt);
>>  extern void init_mem_pgprot(void);
>>  /* create an identity mapping for memory (or io if map_io is true) */
>>  extern void create_id_mapping(phys_addr_t addr, phys_addr_t size, int map_io);
>> +extern void create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
>> +                            unsigned long virt, phys_addr_t size,
>> +                            int map_io, int map_xn);
>
> I really don't like these map_io and map_xn parameters.
> Further down we have logic "if (map_io)...", which is out of place, and
> doesn't match the normal style of mapping page table entries.
>
> Could we not instead have something like:
> extern void create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
>                                unsigned long virt, phys_addr_t size,
>                                pgprot_t prot_sect, pgprot_t prot_pte);
>
> Then we can remove all the conditional logic for map_io, map_xn?
>

Yes, you are quite right. I was a bit lazy and made some incremental
changes allowing me to use this code in the way i need to for creating
non-executable mappings for EFI data and config tables etc. But I
agree it would be much better to clean it up the way you suggest.

>>
>>  #endif
>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>> index 7eaa6a8c8467..f7d17a5a1f56 100644
>> --- a/arch/arm64/mm/mmu.c
>> +++ b/arch/arm64/mm/mmu.c
>> @@ -157,7 +157,7 @@ static void __init alloc_init_pte(pmd_t *pmd, unsigned long addr,
>>
>>  static void __init alloc_init_pmd(struct mm_struct *mm, pud_t *pud,
>>                                 unsigned long addr, unsigned long end,
>> -                               phys_addr_t phys, int map_io)
>> +                               phys_addr_t phys, int map_io, int map_xn)
>>  {
>>       pmd_t *pmd;
>>       unsigned long next;
>> @@ -167,6 +167,9 @@ static void __init alloc_init_pmd(struct mm_struct *mm, pud_t *pud,
>>       if (map_io) {
>>               prot_sect = PROT_SECT_DEVICE_nGnRE;
>>               prot_pte = __pgprot(PROT_DEVICE_nGnRE);
>> +     } else if (map_xn) {
>> +             prot_sect = PROT_SECT_NORMAL;
>> +             prot_pte = PAGE_KERNEL;
>>       } else {
>>               prot_sect = PROT_SECT_NORMAL_EXEC;
>>               prot_pte = PAGE_KERNEL_EXEC;
>
> Ideally, this if block should be completely removed.
>
>> @@ -203,7 +206,7 @@ static void __init alloc_init_pmd(struct mm_struct *mm, pud_t *pud,
>>
>>  static void __init alloc_init_pud(struct mm_struct *mm, pgd_t *pgd,
>>                                 unsigned long addr, unsigned long end,
>> -                               unsigned long phys, int map_io)
>> +                               unsigned long phys, int map_io, int map_xn)
>>  {
>>       pud_t *pud;
>>       unsigned long next;
>> @@ -221,7 +224,7 @@ static void __init alloc_init_pud(struct mm_struct *mm, pgd_t *pgd,
>>               /*
>>                * For 4K granule only, attempt to put down a 1GB block
>>                */
>> -             if (!map_io && (PAGE_SHIFT == 12) &&
>> +             if (!map_io && !map_xn && (PAGE_SHIFT == 12) &&
>
> Presumably the !map_io and !map_xn tests are here because of the
> PROT_SECT_NORMAL_EXEC below? Is there another reason why a pud mapping
> would be unsuitable for these?
>

No, it's just highly unlikely that we would encounter one of that size
with map_io or map_xn set.

Cheers,
Ard.



>>                   ((addr | next | phys) & ~PUD_MASK) == 0) {
>>                       pud_t old_pud = *pud;
>>                       set_pud(pud, __pud(phys | PROT_SECT_NORMAL_EXEC));
>> @@ -239,7 +242,8 @@ static void __init alloc_init_pud(struct mm_struct *mm, pgd_t *pgd,
>>                               flush_tlb_all();
>>                       }
>>               } else {
>> -                     alloc_init_pmd(mm, pud, addr, next, phys, map_io);
>> +                     alloc_init_pmd(mm, pud, addr, next, phys, map_io,
>> +                                    map_xn);
>>               }
>>               phys += next - addr;
>>       } while (pud++, addr = next, addr != end);
>> @@ -251,7 +255,7 @@ static void __init alloc_init_pud(struct mm_struct *mm, pgd_t *pgd,
>>   */
>>  static void __init __create_mapping(struct mm_struct *mm, pgd_t *pgd,
>>                                   phys_addr_t phys, unsigned long virt,
>> -                                 phys_addr_t size, int map_io)
>> +                                 phys_addr_t size, int map_io, int map_xn)
>>  {
>>       unsigned long addr, length, end, next;
>>
>> @@ -261,7 +265,7 @@ static void __init __create_mapping(struct mm_struct *mm, pgd_t *pgd,
>>       end = addr + length;
>>       do {
>>               next = pgd_addr_end(addr, end);
>> -             alloc_init_pud(mm, pgd, addr, next, phys, map_io);
>> +             alloc_init_pud(mm, pgd, addr, next, phys, map_io, map_xn);
>>               phys += next - addr;
>>       } while (pgd++, addr = next, addr != end);
>>  }
>> @@ -275,7 +279,7 @@ static void __init create_mapping(phys_addr_t phys, unsigned long virt,
>>               return;
>>       }
>>       __create_mapping(&init_mm, pgd_offset_k(virt & PAGE_MASK), phys, virt,
>> -                      size, 0);
>> +                      size, 0, 0);
>>  }
>>
>>  void __init create_id_mapping(phys_addr_t addr, phys_addr_t size, int map_io)
>> @@ -285,7 +289,15 @@ void __init create_id_mapping(phys_addr_t addr, phys_addr_t size, int map_io)
>>               return;
>>       }
>>       __create_mapping(&init_mm, &idmap_pg_dir[pgd_index(addr)],
>> -                      addr, addr, size, map_io);
>> +                      addr, addr, size, map_io, 0);
>> +}
>> +
>> +void __init create_pgd_mapping(struct mm_struct *mm, phys_addr_t phys,
>> +                            unsigned long virt, phys_addr_t size,
>> +                            int map_io, int map_xn)
>> +{
>> +     __create_mapping(mm, pgd_offset(mm, virt), phys, virt, size, map_io,
>> +                      map_xn);
>>  }
>>
>>  static void __init map_mem(void)
>> --
>> 1.8.3.2
>>
>
> Cheers,
> --
> Steve
