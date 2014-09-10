From: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>
Subject: Re: [RFC PATCH] arm64/efi: use id mapping for Runtime Services
Date: Wed, 10 Sep 2014 14:44:00 +0100
Message-ID: <CACxGe6sKTQndHVTcH0V8mQL6-UuV8CRXLKSyaM7_CPiyCZvUXQ@mail.gmail.com>
References: <1406815909-26825-1-git-send-email-ard.biesheuvel@linaro.org>
 <20140806143632.GV25953@arm.com> <CAKv+Gu9xtGRTbhzzyCbGt7CEL=ORkpEnuipweedzDbBJZGGxuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAKv+Gu9xtGRTbhzzyCbGt7CEL=ORkpEnuipweedzDbBJZGGxuw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <Mark.Rutland-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

I had missed this conversation, but Ard pointed me at it yesterday, so
I'll chime in now.

Ard, you are correct that SetVirtualAddressMap() is optional in the
spec and we could simply not call it. By a strict reading of the spec
that is completely valid. However, the problem is not with the spec,
it is with actual implementations. Vendors are notorious for shipping
hardware that works enough to boot the operating system(s) they care
about even though the implementation is out of spec. If we don't call
SetVirtualAddressMap() it pretty much guarantees that we'll never be
able to reliably call SetVirtualAddressMap() on ARM platforms because
there will be a non-trivial set of platforms that implement it
completely wrong.

In the ARM server space, Linux will be the dominant OS for the near
future, not Windows, so we are in the happy position of hardware
vendors making sure their platform boots Linux instead of trying to
run Linux on a platform only tested with Windows. We want to call
SetVirtualAddressMap() because it is a pretty fundamental part of
runtime services, and we want to make sure it works. I'd even argue
that it would be a good idea to randomize the map layout on each boot
to flush out buggy assumptions about the map it will be given.

That said, putting runtime services into a separate mapping apart from
the kernel mappings is exactly the right thing to do. If runtime
services access any data outside of declared address map, we want to
know about it and prevent it from happening. Otherwise we've got no
idea if UEFI is corrupting kernel data structures.

As for kexec, we can pass the assigned mapping on to the next kernel.
We already are passing the address map via the boot dt. As long as the
kernel can detect if a mapping has already been set, which should be
easy, the new kernel can use it instead of assigning one of it's own.

g.


On Wed, Aug 6, 2014 at 4:15 PM, Ard Biesheuvel
<ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On 6 August 2014 16:36, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org> wrote:
>> On Thu, Jul 31, 2014 at 03:11:49PM +0100, Ard Biesheuvel wrote:
>>> There are 2 interesting pieces of information in the UEFI spec section 2.3.6
>>> regarding the mapping of runtime regions:
>>> (a) the firmware should not request a virtual mapping for configuration tables,
>>>     even though they are marked as EfiRuntimeServicesData;
>>> (b) calling SetVirtualAddressMap() is optional, and it is equally appropriate to
>>>     call Runtime Services using an identity mapping.
>>>
>>> So we can eliminate some of the complexity around UEFI Runtime Services by not
>>> using a virtual mapping at all, and calling the services at their physical
>>> address. This is especially useful under kexec, as SetVirtualAddressMap() may
>>> only be called once, and there is no guarantee that mappings are stable between
>>> different kexec'd kernels.
>>>
>>> The fallout for other in-kernel users of UEFI data structures should be
>>> negligible, as they cannot legally access those data structures through
>>> pre-existing virtual mappings anyway (point (a) above)
>>>
>>> It should also be noted that, as the kernel side of the address space (TTBR1) is
>>> retained, the stack and pointer function arguments remain accessible to the
>>> runtime service while the id mapping is active.
>>>
>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>> ---
>>>  arch/arm64/include/asm/efi.h |  24 ++++++++--
>>>  arch/arm64/kernel/efi.c      | 106 ++-----------------------------------------
>>>  2 files changed, 23 insertions(+), 107 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/efi.h b/arch/arm64/include/asm/efi.h
>>> index a34fd3b12e2b..d42a21e79b39 100644
>>> --- a/arch/arm64/include/asm/efi.h
>>> +++ b/arch/arm64/include/asm/efi.h
>>> @@ -1,8 +1,10 @@
>>>  #ifndef _ASM_EFI_H
>>>  #define _ASM_EFI_H
>>>
>>> +#include <asm/cacheflush.h>
>>>  #include <asm/io.h>
>>>  #include <asm/neon.h>
>>> +#include <asm/tlbflush.h>
>>>
>>>  #ifdef CONFIG_EFI
>>>  extern void efi_init(void);
>>> @@ -12,23 +14,37 @@ extern void efi_idmap_init(void);
>>>  #define efi_idmap_init()
>>>  #endif
>>>
>>> +static inline void switch_pgd(pgd_t *pgd, struct mm_struct *mm)
>>> +{
>>> +     cpu_switch_mm(pgd, mm);
>>> +     flush_tlb_all();
>>> +     if (icache_is_aivivt())
>>> +             __flush_icache_all();
>>> +}
>>> +
>>>  #define efi_call_virt(f, ...)                                                \
>>>  ({                                                                   \
>>> -     efi_##f##_t *__f = efi.systab->runtime->f;                      \
>>> +     efi_##f##_t *__f;                                               \
>>>       efi_status_t __s;                                               \
>>>                                                                       \
>>> -     kernel_neon_begin();                                            \
>>> +     kernel_neon_begin(); /* disables preemption */                  \
>>> +     switch_pgd(idmap_pg_dir, &init_mm);                             \
>>> +     __f =  efi.systab->runtime->f;                                  \
>>>       __s = __f(__VA_ARGS__);                                         \
>>> +     switch_pgd(current->active_mm->pgd, current->active_mm);        \
>>>       kernel_neon_end();                                              \
>>>       __s;                                                            \
>>>  })
>>
>> This scares the bejesus out of me, but I can't put my finger on exactly why.
>> I think it does what you intend and I can't break it myself, so it would be
>> really good if the EFI folks could confirm that this looks good to them.
>>
>
> There is something similar in the x86 code (arch/x86/platform/efi/efi.c)
> """
>  * The new method does a pagetable switch in a preemption-safe manner
>  * so that we're in a different address space when calling a runtime
>  * function. For function arguments passing we do copy the PGDs of the
>  * kernel page table into ->trampoline_pgd prior to each call.
> """
>
> How exactly this will turn out for arm64 (and ARM) is still under
> discussion, though. My position is that if you are going to switch
> pgd's anyway, why not just use the id mapping? And even if you feel it
> is mandatory to install a virtual address mapping into UEFI (which I
> think is /not/ the case), you could install an id mapping as well,
> which means all the related machinery still gets invoked.
> The alternative to using a TTBR0 mapping would be to reserve a slice
> of kernel virtual memory so that the Runtime Services are guaranteed
> to live at the same virtual address after a kexec, ideally the same
> region on 4k and 64k pages ...
>
> We are planning to discuss this further at Linaro Connect next month.
>
> --
> Ard.
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
