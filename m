From: Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCHv3 1/5] efi/runtime-wrappers: detect FW irq flag corruption
Date: Mon, 25 Apr 2016 15:12:01 +0100
Message-ID: <571E25B1.8070305@arm.com>
References: <1461591994-14918-1-git-send-email-mark.rutland@arm.com>
 <1461591994-14918-2-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461591994-14918-2-git-send-email-mark.rutland-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will.deacon-5wv7dgnIgG8@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi Mark,

On 25/04/16 14:46, Mark Rutland wrote:
> The UEFI spec allows runtime services to be called with interrupts
> masked or unmasked, and if a runtime service function needs to mask
> interrupts, it must restore the mask to its original state before
> returning (i.e. from the PoV of the OS, this does not change across a
> call). Firmware should never unmask exceptions, as these may then be
> taken by the OS unexpectedly.
>
> Unfortunately, some firmware has been seen to unmask IRQs (and
> potentially other maskable exceptions) across runtime services calls,
> leaving irq flags corrupted after returning from a runtime services
> function call. This may be detected by the IRQ tracing code, but often
> goes unnoticed, leaving a potentially disastrous bug hidden.
>
> This patch detects when the irq flags are corrupted by an EFI runtime
> services call, logging the call and specific corruption to the console.
> While restoring the expected value of the flags is insufficient to avoid
> problems, we do so to avoid redundant warnings from elsewhere (e.g. IRQ
> tracing).
>
> The set of bits in flags which we want to check is architecture-specific
> (e.g. we want to check FIQ on arm64, but not the zero flag on x86), so
> each arch must provide ARCH_EFI_IRQ_FLAGS_MASK to describe those. In the
> absence of this mask, the check is a no-op, and we redundantly save the
> flags twice, but that will be short-lived as subsequent patches
> will implement this and remove the scaffolding.
>
> Signed-off-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>   drivers/firmware/efi/runtime-wrappers.c | 32 ++++++++++++++++++++++++++++++++
>   1 file changed, 32 insertions(+)
>
> diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
> index a2c8e70..1f0277e 100644
> --- a/drivers/firmware/efi/runtime-wrappers.c
> +++ b/drivers/firmware/efi/runtime-wrappers.c
> @@ -16,23 +16,55 @@
>
>   #include <linux/bug.h>
>   #include <linux/efi.h>
> +#include <linux/irqflags.h>
>   #include <linux/mutex.h>
>   #include <linux/spinlock.h>
> +#include <linux/stringify.h>
>   #include <asm/efi.h>
>
> +/*
> + * Temporary scaffolding until all users provide ARCH_EFI_IRQ_FLAGS_MASK.
> + */
> +#ifdef ARCH_EFI_IRQ_FLAGS_MASK
> +static void efi_call_virt_check_flags(unsigned long flags, const char *call)
> +{
> +	unsigned long cur_flags;
> +	bool mismatch;
> +
> +	local_save_flags(cur_flags);
> +
> +	mismatch = !!((cur_flags ^ flags) & ARCH_EFI_IRQ_FLAGS_MASK);

nit: the assignment itself is already a conversion to bool, so the 
excitement is redundant here.

Robin.

> +	if (!WARN_ON_ONCE(mismatch))
> +		return;
> +
> +	add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_NOW_UNRELIABLE);
> +	pr_err_ratelimited(FW_BUG "IRQ flags corrupted (0x%08lx=>0x%08lx) by EFI %s\n",
> +			   flags, cur_flags, call);
> +	local_irq_restore(flags);
> +}
> +#else /* ARCH_EFI_IRQ_FLAGS_MASK */
> +static inline void efi_call_virt_check_flags(unsigned long flags, const char *call) {}
> +#endif /* ARCH_EFI_IRQ_FLAGS_MASK */
> +
>   #define efi_call_virt(f, args...)					\
>   ({									\
>   	efi_status_t __s;						\
> +	unsigned long flags;						\
>   	arch_efi_call_virt_setup();					\
> +	local_save_flags(flags);					\
>   	__s = arch_efi_call_virt(f, args);				\
> +	efi_call_virt_check_flags(flags, __stringify(f));		\
>   	arch_efi_call_virt_teardown();					\
>   	__s;								\
>   })
>
>   #define __efi_call_virt(f, args...)					\
>   ({									\
> +	unsigned long flags;						\
>   	arch_efi_call_virt_setup();					\
> +	local_save_flags(flags);					\
>   	arch_efi_call_virt(f, args);					\
> +	efi_call_virt_check_flags(flags, __stringify(f));		\
>   	arch_efi_call_virt_teardown();					\
>   })
>
>
