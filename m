From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] efi: implement mandatory locking for UEFI Runtime Services
Date: Tue, 8 Jul 2014 13:23:55 +0200
Message-ID: <CAKv+Gu86W0hBEZhz_Aw07TmRHv8kgQN7JeRMC0Qs6FL0m6BrOQ@mail.gmail.com>
References: <1404818508-17537-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1404818508-17537-1-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 8 July 2014 13:21, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> According to section 7.1 of the UEFI spec, Runtime Services are not fully
> reentrant, and there are particular combinations of calls that need to be
> serialized.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>
> So this is v2 of the UEFI Runtime Services serialization patch: this time, I use
> a single spinlock rather than a set of mutexes, resulting in all services to be
> serialized with respect to all others. Also added handling of NMI state, as this
> results in some of the restrictions being lifted (x86, ia64 only)
>
> One question remains: with the NMI deadlock handling in place, is it really
> necessary to disable interrupts in all cases?
>

I omitted this hunk from the patch by accident:

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 55059a50a01f..d8ee5bb527e5 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -2,6 +2,7 @@
 #define _ASM_X86_EFI_H

 #include <asm/i387.h>
+#include <asm/nmi.h>
 /*
  * We map the EFI regions needed for runtime services non-contiguously,
  * with preserved alignment on virtual addresses starting from -4G down
@@ -52,6 +53,8 @@ extern unsigned long asmlinkage efi_call_phys(void *, ...);
        kernel_fpu_end();                                               \
 })

+#define efi_in_nmi()   in_nmi()
+
 #define efi_ioremap(addr, size, type, attr)    ioremap_cache(addr, size)

 #else /* !CONFIG_X86_32 */

>  drivers/firmware/efi/runtime-wrappers.c | 167 +++++++++++++++++++++++++++++---
>  1 file changed, 155 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
> index 10daa4bbb258..5ee3b16498a2 100644
> --- a/drivers/firmware/efi/runtime-wrappers.c
> +++ b/drivers/firmware/efi/runtime-wrappers.c
> @@ -14,11 +14,76 @@
>   * This file is released under the GPLv2.
>   */
>
> +#include <linux/bug.h>
>  #include <linux/efi.h>
> -#include <linux/spinlock.h>             /* spinlock_t */
> +#include <linux/mutex.h>
> +#include <linux/spinlock.h>
>  #include <asm/efi.h>
>
>  /*
> + * According to section 7.1 of the UEFI spec, Runtime Services are not fully
> + * reentrant, and there are particular combinations of calls that need to be
> + * serialized.
> + *
> + * Table 31. Rules for Reentry Into Runtime Services
> + * +------------------------------------+-------------------------------+
> + * | If previous call is busy in       | Forbidden to call             |
> + * +------------------------------------+-------------------------------+
> + * | Any                               | SetVirtualAddressMap()        |
> + * +------------------------------------+-------------------------------+
> + * | ConvertPointer()                  | ConvertPointer()              |
> + * +------------------------------------+-------------------------------+
> + * | SetVariable()                     | ResetSystem()                 |
> + * | UpdateCapsule()                   |                               |
> + * | SetTime()                         |                               |
> + * | SetWakeupTime()                   |                               |
> + * | GetNextHighMonotonicCount()       |                               |
> + * +------------------------------------+-------------------------------+
> + * | GetVariable()                     | GetVariable()                 |
> + * | GetNextVariableName()             | GetNextVariableName()         |
> + * | SetVariable()                     | SetVariable()                 |
> + * | QueryVariableInfo()               | QueryVariableInfo()           |
> + * | UpdateCapsule()                   | UpdateCapsule()               |
> + * | QueryCapsuleCapabilities()                | QueryCapsuleCapabilities()    |
> + * | GetNextHighMonotonicCount()       | GetNextHighMonotonicCount()   |
> + * +------------------------------------+-------------------------------+
> + * | GetTime()                         | GetTime()                     |
> + * | SetTime()                         | SetTime()                     |
> + * | GetWakeupTime()                   | GetWakeupTime()               |
> + * | SetWakeupTime()                   | SetWakeupTime()               |
> + * +------------------------------------+-------------------------------+
> + *
> + * Instead of adding locks for each of the groups, we add a single spinlock
> + * that serializes all runtime services calls with respect to all others.
> + */
> +static DEFINE_SPINLOCK(efi_runtime_lock);
> +
> +/*
> + * Some runtime services calls can be reentrant under NMI, even if the table
> + * above says they are not.
> + *
> + * Table 32. Functions that may be called after Machine Check ,INIT and NMI
> + * +----------------------------+------------------------------------------+
> + * | Function                  | Called after Machine Check, INIT and NMI |
> + * +----------------------------+------------------------------------------+
> + * | GetTime()                 | Yes, even if previously busy.            |
> + * | GetVariable()             | Yes, even if previously busy             |
> + * | GetNextVariableName()     | Yes, even if previously busy             |
> + * | QueryVariableInfo()       | Yes, even if previously busy             |
> + * | SetVariable()             | Yes, even if previously busy             |
> + * | UpdateCapsule()           | Yes, even if previously busy             |
> + * | QueryCapsuleCapabilities()        | Yes, even if previously busy             |
> + * | ResetSystem()             | Yes, even if previously busy             |
> + * +----------------------------+------------------------------------------+
> + *
> + * In order to prevent deadlocks under NMI, the wrappers for these functions
> + * only grab the efi_runtime_lock or rtc_lock spinlocks if !efi_in_nmi().
> + */
> +#ifndef efi_in_nmi
> +#define efi_in_nmi()   (0)
> +#endif
> +
> +/*
>   * As per commit ef68c8f87ed1 ("x86: Serialize EFI time accesses on rtc_lock"),
>   * the EFI specification requires that callers of the time related runtime
>   * functions serialize with other CMOS accesses in the kernel, as the EFI time
> @@ -31,9 +96,15 @@ static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
>         unsigned long flags;
>         efi_status_t status;
>
> -       spin_lock_irqsave(&rtc_lock, flags);
> +       if (!efi_in_nmi()) {
> +               spin_lock_irqsave(&rtc_lock, flags);
> +               spin_lock(&efi_runtime_lock);
> +       }
>         status = efi_call_virt(get_time, tm, tc);
> -       spin_unlock_irqrestore(&rtc_lock, flags);
> +       if (!efi_in_nmi()) {
> +               spin_unlock(&efi_runtime_lock);
> +               spin_unlock_irqrestore(&rtc_lock, flags);
> +       }
>         return status;
>  }
>
> @@ -42,8 +113,11 @@ static efi_status_t virt_efi_set_time(efi_time_t *tm)
>         unsigned long flags;
>         efi_status_t status;
>
> +       BUG_ON(efi_in_nmi());
>         spin_lock_irqsave(&rtc_lock, flags);
> +       spin_lock(&efi_runtime_lock);
>         status = efi_call_virt(set_time, tm);
> +       spin_unlock(&efi_runtime_lock);
>         spin_unlock_irqrestore(&rtc_lock, flags);
>         return status;
>  }
> @@ -55,8 +129,11 @@ static efi_status_t virt_efi_get_wakeup_time(efi_bool_t *enabled,
>         unsigned long flags;
>         efi_status_t status;
>
> +       BUG_ON(efi_in_nmi());
>         spin_lock_irqsave(&rtc_lock, flags);
> +       spin_lock(&efi_runtime_lock);
>         status = efi_call_virt(get_wakeup_time, enabled, pending, tm);
> +       spin_unlock(&efi_runtime_lock);
>         spin_unlock_irqrestore(&rtc_lock, flags);
>         return status;
>  }
> @@ -66,8 +143,11 @@ static efi_status_t virt_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
>         unsigned long flags;
>         efi_status_t status;
>
> +       BUG_ON(efi_in_nmi());
>         spin_lock_irqsave(&rtc_lock, flags);
> +       spin_lock(&efi_runtime_lock);
>         status = efi_call_virt(set_wakeup_time, enabled, tm);
> +       spin_unlock(&efi_runtime_lock);
>         spin_unlock_irqrestore(&rtc_lock, flags);
>         return status;
>  }
> @@ -78,14 +158,31 @@ static efi_status_t virt_efi_get_variable(efi_char16_t *name,
>                                           unsigned long *data_size,
>                                           void *data)
>  {
> -       return efi_call_virt(get_variable, name, vendor, attr, data_size, data);
> +       unsigned long flags;
> +       efi_status_t status;
> +
> +       if (!efi_in_nmi())
> +               spin_lock_irqsave(&efi_runtime_lock, flags);
> +       status = efi_call_virt(get_variable, name, vendor, attr, data_size,
> +                              data);
> +       if (!efi_in_nmi())
> +               spin_unlock_irqrestore(&efi_runtime_lock, flags);
> +       return status;
>  }
>
>  static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
>                                                efi_char16_t *name,
>                                                efi_guid_t *vendor)
>  {
> -       return efi_call_virt(get_next_variable, name_size, name, vendor);
> +       unsigned long flags;
> +       efi_status_t status;
> +
> +       if (!efi_in_nmi())
> +               spin_lock_irqsave(&efi_runtime_lock, flags);
> +       status = efi_call_virt(get_next_variable, name_size, name, vendor);
> +       if (!efi_in_nmi())
> +               spin_unlock_irqrestore(&efi_runtime_lock, flags);
> +       return status;
>  }
>
>  static efi_status_t virt_efi_set_variable(efi_char16_t *name,
> @@ -94,7 +191,16 @@ static efi_status_t virt_efi_set_variable(efi_char16_t *name,
>                                           unsigned long data_size,
>                                           void *data)
>  {
> -       return efi_call_virt(set_variable, name, vendor, attr, data_size, data);
> +       unsigned long flags;
> +       efi_status_t status;
> +
> +       if (!efi_in_nmi())
> +               spin_lock_irqsave(&efi_runtime_lock, flags);
> +       status = efi_call_virt(set_variable, name, vendor, attr, data_size,
> +                              data);
> +       if (!efi_in_nmi())
> +               spin_unlock_irqrestore(&efi_runtime_lock, flags);
> +       return status;
>  }
>
>  static efi_status_t virt_efi_query_variable_info(u32 attr,
> @@ -102,16 +208,31 @@ static efi_status_t virt_efi_query_variable_info(u32 attr,
>                                                  u64 *remaining_space,
>                                                  u64 *max_variable_size)
>  {
> +       unsigned long flags;
> +       efi_status_t status;
> +
>         if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
>                 return EFI_UNSUPPORTED;
>
> -       return efi_call_virt(query_variable_info, attr, storage_space,
> -                            remaining_space, max_variable_size);
> +       if (!efi_in_nmi())
> +               spin_lock_irqsave(&efi_runtime_lock, flags);
> +       status = efi_call_virt(query_variable_info, attr, storage_space,
> +                              remaining_space, max_variable_size);
> +       if (!efi_in_nmi())
> +               spin_unlock_irqrestore(&efi_runtime_lock, flags);
> +       return status;
>  }
>
>  static efi_status_t virt_efi_get_next_high_mono_count(u32 *count)
>  {
> -       return efi_call_virt(get_next_high_mono_count, count);
> +       unsigned long flags;
> +       efi_status_t status;
> +
> +       BUG_ON(efi_in_nmi());
> +       spin_lock_irqsave(&efi_runtime_lock, flags);
> +       status = efi_call_virt(get_next_high_mono_count, count);
> +       spin_unlock_irqrestore(&efi_runtime_lock, flags);
> +       return status;
>  }
>
>  static void virt_efi_reset_system(int reset_type,
> @@ -119,17 +240,31 @@ static void virt_efi_reset_system(int reset_type,
>                                   unsigned long data_size,
>                                   efi_char16_t *data)
>  {
> +       unsigned long flags;
> +
> +       if (!efi_in_nmi())
> +               spin_lock_irqsave(&efi_runtime_lock, flags);
>         __efi_call_virt(reset_system, reset_type, status, data_size, data);
> +       if (!efi_in_nmi())
> +               spin_unlock_irqrestore(&efi_runtime_lock, flags);
>  }
>
>  static efi_status_t virt_efi_update_capsule(efi_capsule_header_t **capsules,
>                                             unsigned long count,
>                                             unsigned long sg_list)
>  {
> +       unsigned long flags;
> +       efi_status_t status;
> +
>         if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
>                 return EFI_UNSUPPORTED;
>
> -       return efi_call_virt(update_capsule, capsules, count, sg_list);
> +       if (!efi_in_nmi())
> +               spin_lock_irqsave(&efi_runtime_lock, flags);
> +       status = efi_call_virt(update_capsule, capsules, count, sg_list);
> +       if (!efi_in_nmi())
> +               spin_unlock_irqrestore(&efi_runtime_lock, flags);
> +       return status;
>  }
>
>  static efi_status_t virt_efi_query_capsule_caps(efi_capsule_header_t **capsules,
> @@ -137,11 +272,19 @@ static efi_status_t virt_efi_query_capsule_caps(efi_capsule_header_t **capsules,
>                                                 u64 *max_size,
>                                                 int *reset_type)
>  {
> +       unsigned long flags;
> +       efi_status_t status;
> +
>         if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
>                 return EFI_UNSUPPORTED;
>
> -       return efi_call_virt(query_capsule_caps, capsules, count, max_size,
> -                            reset_type);
> +       if (!efi_in_nmi())
> +               spin_lock_irqsave(&efi_runtime_lock, flags);
> +       status = efi_call_virt(query_capsule_caps, capsules, count, max_size,
> +                              reset_type);
> +       if (!efi_in_nmi())
> +               spin_unlock_irqrestore(&efi_runtime_lock, flags);
> +       return status;
>  }
>
>  void efi_native_runtime_setup(void)
> --
> 1.8.3.2
>
