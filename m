From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH] arm64/efi: use id mapping for Runtime Services
Date: Thu, 31 Jul 2014 20:37:44 +0200
Message-ID: <CAKv+Gu9kKvLar6jFiggRDozzjga0J=5-VtUqoFmJ4SDPiMAKcQ@mail.gmail.com>
References: <1406815909-26825-1-git-send-email-ard.biesheuvel@linaro.org>
	<1406818960.3200.10.camel@deneb.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1406818960.3200.10.camel-PDpCo7skNiwAicBL8TP8PQ@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 31 July 2014 17:02, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, 2014-07-31 at 16:11 +0200, Ard Biesheuvel wrote:
>> There are 2 interesting pieces of information in the UEFI spec section 2.3.6
>> regarding the mapping of runtime regions:
>> (a) the firmware should not request a virtual mapping for configuration tables,
>>     even though they are marked as EfiRuntimeServicesData;
>> (b) calling SetVirtualAddressMap() is optional, and it is equally appropriate to
>>     call Runtime Services using an identity mapping.
>>
>> So we can eliminate some of the complexity around UEFI Runtime Services by not
>> using a virtual mapping at all, and calling the services at their physical
>> address. This is especially useful under kexec, as SetVirtualAddressMap() may
>> only be called once, and there is no guarantee that mappings are stable between
>> different kexec'd kernels.
>>
>> The fallout for other in-kernel users of UEFI data structures should be
>> negligible, as they cannot legally access those data structures through
>> pre-existing virtual mappings anyway (point (a) above)
>>
>> It should also be noted that, as the kernel side of the address space (TTBR1) is
>> retained, the stack and pointer function arguments remain accessible to the
>> runtime service while the id mapping is active.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  arch/arm64/include/asm/efi.h |  24 ++++++++--
>>  arch/arm64/kernel/efi.c      | 106 ++-----------------------------------------
>>  2 files changed, 23 insertions(+), 107 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
>> index a34fd3b12e2b..d42a21e79b39 100644
>> --- a/arch/arm64/include/asm/efi.h
>> +++ b/arch/arm64/include/asm/efi.h
>> @@ -1,8 +1,10 @@
>>  #ifndef _ASM_EFI_H
>>  #define _ASM_EFI_H
>>
>> +#include <asm/cacheflush.h>
>>  #include <asm/io.h>
>>  #include <asm/neon.h>
>> +#include <asm/tlbflush.h>
>>
>>  #ifdef CONFIG_EFI
>>  extern void efi_init(void);
>> @@ -12,23 +14,37 @@ extern void efi_idmap_init(void);
>>  #define efi_idmap_init()
>>  #endif
>>
>> +static inline void switch_pgd(pgd_t *pgd, struct mm_struct *mm)
>> +{
>> +     cpu_switch_mm(pgd, mm);
>> +     flush_tlb_all();
>> +     if (icache_is_aivivt())
>> +             __flush_icache_all();
>> +}
>> +
>>  #define efi_call_virt(f, ...)                                                \
>>  ({                                                                   \
>> -     efi_##f##_t *__f = efi.systab->runtime->f;                      \
>> +     efi_##f##_t *__f;                                               \
>>       efi_status_t __s;                                               \
>>                                                                       \
>> -     kernel_neon_begin();                                            \
>> +     kernel_neon_begin(); /* disables preemption */                  \
>> +     switch_pgd(idmap_pg_dir, &init_mm);                             \
>> +     __f =  efi.systab->runtime->f;                                  \
>>       __s = __f(__VA_ARGS__);                                         \
>> +     switch_pgd(current->active_mm->pgd, current->active_mm);        \
>>       kernel_neon_end();                                              \
>>       __s;                                                            \
>>  })
>>
>>  #define __efi_call_virt(f, ...)                                              \
>>  ({                                                                   \
>> -     efi_##f##_t *__f = efi.systab->runtime->f;                      \
>> +     efi_##f##_t *__f;                                               \
>>                                                                       \
>> -     kernel_neon_begin();                                            \
>> +     kernel_neon_begin(); /* disables preemption */                  \
>> +     switch_pgd(idmap_pg_dir, &init_mm);                             \
>> +     __f =  efi.systab->runtime->f;                                  \
>>       __f(__VA_ARGS__);                                               \
>> +     switch_pgd(current->active_mm->pgd, current->active_mm);        \
>>       kernel_neon_end();                                              \
>>  })
>
> If you replace the current user pgd with idmap pgd and there is
> an exception in the firmware which would lead to the user task
> being killed, what happens?
>

Changing the function pointer for GetNextVariable() to 0 gives me this:

root@genericarmv8:~# insmod ./efivars.ko
EFI Variables Facility v0.08 2004-May-17
Bad mode in Synchronous Abort handler detected, code 0x86000006
CPU: 0 PID: 829 Comm: insmod Not tainted 3.16.0-rc4+ #48
task: ffffffc8787d2c00 ti: ffffffc07e68c000 task.ti: ffffffc07e68c000
PC is at 0x0
LR is at virt_efi_get_next_variable+0x84/0xe8
pc : [<0000000000000000>] lr : [<ffffffc0003d5910>] pstate: 800001c5
sp : ffffffc07e68fb40
x29: ffffffc07e68fb40 x28: 0000000000000001
x27: ffffffc0006a3000 x26: 0000000000000000
x25: 0000000000000000 x24: ffffffc0006f9388
x23: 0000000000000400 x22: ffffffc07e655000
x21: ffffffc07e68fc10 x20: ffffffc0006d7000
x19: ffffffc0006d7000 x18: 0000007fd99f2770
x17: 0000007f9f904e20 x16: ffffffc0001bc768
x15: 0000007f9f982598 x14: 0fffffffffffffff
x13: 0000000000000020 x12: 0000000000000020
x11: 0101010101010101 x10: ffffffff7f7f7f7f
x9 : 0000000000000000 x8 : ffffffc07e655400
x7 : 0000000000000000 x6 : 00000000000003ff
x5 : 0000000000000000 x4 : 0000000000000008
x3 : 0000000000000000 x2 : ffffffc07e68fc00
x1 : ffffffc07e655000 x0 : ffffffc07e68fc10

Internal error: Oops - bad mode: 0 [#1] PREEMPT SMP
Modules linked in: efivars(+)
CPU: 0 PID: 829 Comm: insmod Not tainted 3.16.0-rc4+ #48
task: ffffffc8787d2c00 ti: ffffffc07e68c000 task.ti: ffffffc07e68c000
PC is at 0x0
LR is at virt_efi_get_next_variable+0x84/0xe8
pc : [<0000000000000000>] lr : [<ffffffc0003d5910>] pstate: 800001c5
sp : ffffffc07e68fb40
x29: ffffffc07e68fb40 x28: 0000000000000001
x27: ffffffc0006a3000 x26: 0000000000000000
x25: 0000000000000000 x24: ffffffc0006f9388
x23: 0000000000000400 x22: ffffffc07e655000
x21: ffffffc07e68fc10 x20: ffffffc0006d7000
x19: ffffffc0006d7000 x18: 0000007fd99f2770
x17: 0000007f9f904e20 x16: ffffffc0001bc768
x15: 0000007f9f982598 x14: 0fffffffffffffff
x13: 0000000000000020 x12: 0000000000000020
x11: 0101010101010101 x10: ffffffff7f7f7f7f
x9 : 0000000000000000 x8 : ffffffc07e655400
x7 : 0000000000000000 x6 : 00000000000003ff
x5 : 0000000000000000 x4 : 0000000000000008
x3 : 0000000000000000 x2 : ffffffc07e68fc00
x1 : ffffffc07e655000 x0 : ffffffc07e68fc10

Process insmod (pid: 829, stack limit = 0xffffffc07e68c058)
Stack: (0xffffffc07e68fb40 to 0xffffffc07e690000)
[...]
Call trace:
[<          (null)>]           (null)
[<ffffffc0003d47d4>] efivar_init+0x88/0x2d8
[<ffffffbffc000ddc>] init_module+0xb4/0x20c [efivars]
[<ffffffc0000814a4>] do_one_initcall+0x88/0x198
[<ffffffc000102204>] load_module+0x16e8/0x1ce4
[<ffffffc0001028bc>] SyS_init_module+0xbc/0xf0
Code: bad PC value
---[ end trace a3d5e8b14467fa1f ]---
note: insmod[829] exited with preempt_count 2
Segmentation fault
root@genericarmv8:~#

so it appears to handle this fairly well. The SIGSEV is not delivered
in the ordinary way, but do_exit(SIGSEGV) is called when taking (and
not handling) an exception at EL1 in process context, so the process
is terminated immediately. Data aborts will not trigger the page fault
handling for lack of fixups.

-- 
Ard.


>>
>> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
>> index e72f3100958f..d620a031e7bf 100644
>> --- a/arch/arm64/kernel/efi.c
>> +++ b/arch/arm64/kernel/efi.c
>> @@ -27,8 +27,6 @@
>>
>>  struct efi_memory_map memmap;
>>
>> -static efi_runtime_services_t *runtime;
>> -
>>  static u64 efi_system_table;
>>
>>  static int uefi_debug __initdata;
>> @@ -340,51 +338,9 @@ void __init efi_idmap_init(void)
>>       efi_setup_idmap();
>>  }
>>
>> -static int __init remap_region(efi_memory_desc_t *md, void **new)
>> -{
>> -     u64 paddr, vaddr, npages, size;
>> -
>> -     paddr = md->phys_addr;
>> -     npages = md->num_pages;
>> -     memrange_efi_to_native(&paddr, &npages);
>> -     size = npages << PAGE_SHIFT;
>> -
>> -     if (is_normal_ram(md))
>> -             vaddr = (__force u64)ioremap_cache(paddr, size);
>> -     else
>> -             vaddr = (__force u64)ioremap(paddr, size);
>> -
>> -     if (!vaddr) {
>> -             pr_err("Unable to remap 0x%llx pages @ %p\n",
>> -                    npages, (void *)paddr);
>> -             return 0;
>> -     }
>> -
>> -     /* adjust for any rounding when EFI and system pagesize differs */
>> -     md->virt_addr = vaddr + (md->phys_addr - paddr);
>> -
>> -     if (uefi_debug)
>> -             pr_info("  EFI remap 0x%012llx => %p\n",
>> -                     md->phys_addr, (void *)md->virt_addr);
>> -
>> -     memcpy(*new, md, memmap.desc_size);
>> -     *new += memmap.desc_size;
>> -
>> -     return 1;
>> -}
>> -
>> -/*
>> - * Switch UEFI from an identity map to a kernel virtual map
>> - */
>>  static int __init arm64_enter_virtual_mode(void)
>>  {
>> -     efi_memory_desc_t *md;
>> -     phys_addr_t virtmap_phys;
>> -     void *virtmap, *virt_md;
>> -     efi_status_t status;
>>       u64 mapsize;
>> -     int count = 0;
>> -     unsigned long flags;
>>
>>       if (!efi_enabled(EFI_BOOT)) {
>>               pr_info("EFI services will not be available.\n");
>> @@ -402,76 +358,20 @@ static int __init arm64_enter_virtual_mode(void)
>>
>>       efi.memmap = &memmap;
>>
>> -     /* Map the runtime regions */
>> -     virtmap = kmalloc(mapsize, GFP_KERNEL);
>> -     if (!virtmap) {
>> -             pr_err("Failed to allocate EFI virtual memmap\n");
>> -             return -1;
>> -     }
>> -     virtmap_phys = virt_to_phys(virtmap);
>> -     virt_md = virtmap;
>> -
>> -     for_each_efi_memory_desc(&memmap, md) {
>> -             if (!(md->attribute & EFI_MEMORY_RUNTIME))
>> -                     continue;
>> -             if (!remap_region(md, &virt_md))
>> -                     goto err_unmap;
>> -             ++count;
>> -     }
>> -
>> -     efi.systab = (__force void *)efi_lookup_mapped_addr(efi_system_table);
>> +     efi.systab = (__force void *)ioremap_cache(efi_system_table,
>> +                                                sizeof(efi_system_table_t));
>>       if (!efi.systab) {
>> -             /*
>> -              * If we have no virtual mapping for the System Table at this
>> -              * point, the memory map doesn't cover the physical offset where
>> -              * it resides. This means the System Table will be inaccessible
>> -              * to Runtime Services themselves once the virtual mapping is
>> -              * installed.
>> -              */
>>               pr_err("Failed to remap EFI System Table -- buggy firmware?\n");
>> -             goto err_unmap;
>> +             return -1;
>>       }
>>       set_bit(EFI_SYSTEM_TABLES, &efi.flags);
>>
>> -     local_irq_save(flags);
>> -     cpu_switch_mm(idmap_pg_dir, &init_mm);
>> -
>> -     /* Call SetVirtualAddressMap with the physical address of the map */
>> -     runtime = efi.systab->runtime;
>> -     efi.set_virtual_address_map = runtime->set_virtual_address_map;
>> -
>> -     status = efi.set_virtual_address_map(count * memmap.desc_size,
>> -                                          memmap.desc_size,
>> -                                          memmap.desc_version,
>> -                                          (efi_memory_desc_t *)virtmap_phys);
>> -     cpu_set_reserved_ttbr0();
>> -     flush_tlb_all();
>> -     local_irq_restore(flags);
>> -
>> -     kfree(virtmap);
>> -
>>       free_boot_services();
>>
>> -     if (status != EFI_SUCCESS) {
>> -             pr_err("Failed to set EFI virtual address map! [%lx]\n",
>> -                     status);
>> -             return -1;
>> -     }
>> -
>>       /* Set up runtime services function pointers */
>> -     runtime = efi.systab->runtime;
>>       efi_native_runtime_setup();
>>       set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
>>
>>       return 0;
>> -
>> -err_unmap:
>> -     /* unmap all mappings that succeeded: there are 'count' of those */
>> -     for (virt_md = virtmap; count--; virt_md += memmap.desc_size) {
>> -             md = virt_md;
>> -             iounmap((__force void __iomem *)md->virt_addr);
>> -     }
>> -     kfree(virtmap);
>> -     return -1;
>>  }
>>  early_initcall(arm64_enter_virtual_mode);
>
>
