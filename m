From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 09/10] arm64/efi: enable minimal UEFI Runtime Services
 for big endian
Date: Wed, 23 Jul 2014 12:59:04 +0200
Message-ID: <CAKv+Gu8DgAAoxb58K9dtQAKyt0zfRV5naAzMTi=7OLYD-ZZd9g@mail.gmail.com>
References: <1405955785-13477-1-git-send-email-ard.biesheuvel@linaro.org>
	<1405955785-13477-10-git-send-email-ard.biesheuvel@linaro.org>
	<20140723093409.GB2714@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140723093409.GB2714@leverpostej>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "victor.kamensky-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <victor.kamensky-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "steve.capper-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <steve.capper-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 23 July 2014 11:34, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
> Hi Ard,
>
> This is certainly a neat feature, and I definitely want to be able to
> boot BE kernels via UEFI.
>

Good!

> However, I'm wary of calling EFI in a physical (i.e. idmap with dcaches
> off) context. I'm not sure anyone else does that, and I'm not sure
> whether that's going to work (both because of the cache maintenance
> requirements and the expectations of a given UEFI implementation w.r.t.
> memory cacheability).
>

I have developed an alternate version in the mean time that switches
to a LE idmap (so with D-cache enabled), but this is an imperfect
solution as well, as (like in the MMU off case), the vector base
virtual address cannot be resolved when the EE bit is cleared (as
TTBR1 points to a BE page table) so any exception taken locks the
machine hard. I am not sure if this can be solved in any way other
than changing exception levels. Or install an alternate vector table
for the duration of the runtime services call that flips the EE bit
back, restores VBAR to its original address, and jumps into it. None
of this is very sexy, though ...

> I'd hoped we'd be able to use a LE EL0 context to call the runtime
> services in, but I'm not sure that's possible by the spec :(
>

Nope, they should be called at the exception level UEFI was started in
(as Leif tells me)

> As I understand it, we shouldn't need these runtime services to simply
> boot a BE kernel.
>

Well, the significance of the variable store related Runtime Services
is that they are used by an installer (through efibootmgr) to program
the kernel command line. Hence the choice for just these services in
the minimal implementation.

-- 
Ard.


> On Mon, Jul 21, 2014 at 04:16:24PM +0100, Ard Biesheuvel wrote:
>> This enables the UEFI Runtime Services needed to manipulate the
>> non-volatile variable store when running under a BE kernel.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> ---
>>  arch/arm64/include/asm/efi.h       |   2 +
>>  arch/arm64/kernel/efi-be-call.S    |  55 ++++++++++++++++++++
>>  arch/arm64/kernel/efi-be-runtime.c | 104 +++++++++++++++++++++++++++++++++++++
>>  arch/arm64/kernel/efi.c            |  15 ++++++
>>  4 files changed, 176 insertions(+)
>>  create mode 100644 arch/arm64/kernel/efi-be-call.S
>>  create mode 100644 arch/arm64/kernel/efi-be-runtime.c
>>
>> diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
>> index a34fd3b12e2b..44e642b6ab61 100644
>> --- a/arch/arm64/include/asm/efi.h
>> +++ b/arch/arm64/include/asm/efi.h
>> @@ -44,4 +44,6 @@ extern void efi_idmap_init(void);
>>
>>  #define efi_call_early(f, ...) sys_table_arg->boottime->f(__VA_ARGS__)
>>
>> +extern void efi_be_runtime_setup(void);
>> +
>>  #endif /* _ASM_EFI_H */
>> diff --git a/arch/arm64/kernel/efi-be-call.S b/arch/arm64/kernel/efi-be-call.S
>> new file mode 100644
>> index 000000000000..24c92a4c352b
>> --- /dev/null
>> +++ b/arch/arm64/kernel/efi-be-call.S
>> @@ -0,0 +1,55 @@
>> +
>> +#include <linux/linkage.h>
>> +
>> +     .text
>> +     .align          3
>> +ENTRY(efi_be_phys_call)
>> +     /*
>> +      * Entered at physical address with 1:1 mapping enabled.
>> +      */
>> +     stp     x29, x30, [sp, #-96]!
>> +     mov     x29, sp
>> +     str     x27, [sp, #16]
>> +
>> +     ldr     x8, =efi_be_phys_call   // virt address of this function
>> +     adr     x9, efi_be_phys_call    // phys address of this function
>> +     sub     x9, x8, x9              // calculate virt to phys offset in x9
>> +
>> +     /* preserve all inputs */
>> +     stp     x0, x1, [sp, #32]
>> +     stp     x2, x3, [sp, #48]
>> +     stp     x4, x5, [sp, #64]
>> +     stp     x6, x7, [sp, #80]
>> +
>> +     /* get phys address of stack */
>> +     sub     sp, sp, x9
>> +
>> +     /* switch to LE, disable MMU and D-cache but leave I-cache enabled */
>> +     mrs     x27, sctlr_el1
>> +     bic     x8, x27, #1 << 2        // clear SCTLR.C
>> +     msr     sctlr_el1, x8
>> +
>> +     bl      flush_cache_all
>
> What is the cache flush for?
>
> The only thing that flush_cache_all can do is empty the local
> architected caches, and it can only do that when said caches are
> disabled. Any other use is unsafe; we have no guarantee that the cache
> is empty (or even clean), and we have no guarantee that prior writes
> have made it to the PoC.
>
> Even when the caches are disabled, flush_cache_all can only guarantee
> that the local architected caches are empty. There is no guarantee that
> the dirty data made it to the PoC.
>
>> +
>> +     /* restore inputs but rotated by 1 register */
>> +     ldp     x7, x0, [sp, #32]
>> +     ldp     x1, x2, [sp, #48]
>> +     ldp     x3, x4, [sp, #64]
>> +     ldp     x5, x6, [sp, #80]
>> +
>> +     bic     x8, x27, #1 << 2        // clear SCTLR.C
>> +     bic     x8, x8, #1 << 0         // clear SCTLR.M
>> +     bic     x8, x8, #1 << 25        // clear SCTLR.EE
>> +     msr     sctlr_el1, x8
>> +     isb
>> +
>> +     blr     x7
>
> Is it safe to call EFI functions with the D-cache disabled?
>
> Do the functions not care about the memory attributes for their own sue
> (e.g. for exclusives)?
>
> Do they not care about IO? If IO to/from storage for variables is
> cache-coherent EFI and the device won't have a coherent view of memory.
>
>> +
>> +     /* switch back to BE and reenable MMU and D-cache */
>> +     msr     sctlr_el1, x27
>> +
>
> Missing ISB?
>
>> +     mov     sp, x29
>> +     ldr     x27, [sp, #16]
>> +     ldp     x29, x30, [sp], #96
>> +     ret
>> +ENDPROC(efi_be_phys_call)
>> diff --git a/arch/arm64/kernel/efi-be-runtime.c b/arch/arm64/kernel/efi-be-runtime.c
>> new file mode 100644
>> index 000000000000..62e6c441b77b
>> --- /dev/null
>> +++ b/arch/arm64/kernel/efi-be-runtime.c
>> @@ -0,0 +1,104 @@
>> +
>> +#include <linux/efi.h>
>> +#include <linux/spinlock.h>
>> +#include <asm/efi.h>
>> +#include <asm/neon.h>
>> +#include <asm/tlbflush.h>
>> +
>> +static efi_runtime_services_t *runtime;
>> +static efi_status_t (*efi_be_call)(phys_addr_t func, ...);
>> +
>> +static DEFINE_SPINLOCK(efi_be_rt_lock);
>> +
>> +static unsigned long efi_be_call_pre(void)
>> +{
>> +     unsigned long flags;
>> +
>> +     kernel_neon_begin();
>> +     spin_lock_irqsave(&efi_be_rt_lock, flags);
>
> At this point we might still have DA_F unmasked, and I don't think we
> expect to be able to handle any of those when the CPU is in the wrong
> endianness for the kernel.
>
>> +     cpu_switch_mm(idmap_pg_dir, &init_mm);
>> +     flush_tlb_all();
>> +     return flags;
>> +}
>> +
>> +static void efi_be_call_post(unsigned long flags)
>> +{
>> +     cpu_switch_mm(current, current->active_mm);
>> +     flush_tlb_all();
>> +     spin_unlock_irqrestore(&efi_be_rt_lock, flags);
>> +     kernel_neon_end();
>> +}
>> +
>> +static efi_status_t efi_be_get_variable(efi_char16_t *name,
>> +                                     efi_guid_t *vendor,
>> +                                     u32 *attr,
>> +                                     unsigned long *data_size,
>> +                                     void *data)
>> +{
>> +     unsigned long flags;
>> +     efi_status_t status;
>> +
>> +     *data_size = cpu_to_le64(*data_size);
>> +     flags = efi_be_call_pre();
>> +     status = efi_be_call(le64_to_cpu(runtime->get_variable),
>> +                          virt_to_phys(name), virt_to_phys(vendor),
>> +                          virt_to_phys(attr), virt_to_phys(data_size),
>> +                          virt_to_phys(data));
>> +     efi_be_call_post(flags);
>> +     *attr = le32_to_cpu(*attr);
>> +     *data_size = le64_to_cpu(*data_size);
>> +     return status;
>
> No cache maintenance? EFI Could have written to a physical mapping which
> could be shadowed by old cache entries. Similarly any buffers that we
> pass to UEFI aren't guaranteed to have been hit the PoC, so UEFI might
> read stale data.
>
> I think that's true for all of the efi_be_* calls below.
>
>> +}
>> +
>> +static efi_status_t efi_be_get_next_variable(unsigned long *name_size,
>> +                                          efi_char16_t *name,
>> +                                          efi_guid_t *vendor)
>> +{
>> +     unsigned long flags;
>> +     efi_status_t status;
>> +
>> +     *name_size = cpu_to_le64(*name_size);
>> +     flags = efi_be_call_pre();
>> +     status = efi_be_call(le64_to_cpu(runtime->get_next_variable),
>> +                          virt_to_phys(name_size), virt_to_phys(name),
>> +                          virt_to_phys(vendor));
>> +     efi_be_call_post(flags);
>> +     *name_size = le64_to_cpu(*name_size);
>> +     return status;
>> +}
>> +
>> +static efi_status_t efi_be_set_variable(efi_char16_t *name,
>> +                                     efi_guid_t *vendor,
>> +                                     u32 attr,
>> +                                     unsigned long data_size,
>> +                                     void *data)
>> +{
>> +     unsigned long flags;
>> +     efi_status_t status;
>> +
>> +     flags = efi_be_call_pre();
>> +     status = efi_be_call(le64_to_cpu(runtime->set_variable),
>> +                          virt_to_phys(name), virt_to_phys(vendor),
>> +                          cpu_to_le32(attr), cpu_to_le64(data_size),
>> +                          virt_to_phys(data));
>> +     efi_be_call_post(flags);
>> +     return status;
>> +}
>> +
>> +void efi_be_runtime_setup(void)
>> +{
>> +     extern u8 efi_be_phys_call[];
>> +
>> +     runtime = ioremap_cache(le64_to_cpu(efi.systab->runtime),
>> +                             sizeof(efi_runtime_services_t));
>> +     if (!runtime) {
>> +             pr_err("Failed to set up BE wrappers for UEFI Runtime Services!\n");
>> +             return;
>> +     }
>
> Might it be worth propagating the error code?
>
>> +
>> +     efi_be_call = (void *)virt_to_phys(efi_be_phys_call);
>> +
>> +     efi.get_variable = efi_be_get_variable;
>> +     efi.get_next_variable = efi_be_get_next_variable;
>> +     efi.set_variable = efi_be_set_variable;
>> +}
>> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
>> index 96df58824189..21e98810c5dd 100644
>> --- a/arch/arm64/kernel/efi.c
>> +++ b/arch/arm64/kernel/efi.c
>> @@ -406,6 +406,21 @@ static int __init arm64_enter_virtual_mode(void)
>>
>>       efi.memmap = &memmap;
>>
>> +     if (IS_ENABLED(CONFIG_CPU_BIG_ENDIAN)) {
>> +             efi.systab = ioremap_cache(efi_system_table,
>> +                                        sizeof(efi_system_table_t));
>> +             if (!efi.systab) {
>> +                     pr_err("Failed to remap EFI system table!\n");
>> +                     return -1;
>> +             }
>> +             free_boot_services();
>> +             efi_be_runtime_setup();
>
> We can fail here, but we'll still set the bits below, which doesn't seem
> right.
>
>> +
>> +             set_bit(EFI_SYSTEM_TABLES, &efi.flags);
>> +             set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
>> +             return 0;
>> +     }
>> +
>>       /* Map the runtime regions */
>>       virtmap = kmalloc(mapsize, GFP_KERNEL);
>>       if (!virtmap) {
>> --
>> 1.8.3.2
>
> Cheers,
> Mark.
