From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv2 5/5] efi/runtime-wrappers: detect FW irq flag corruption
Date: Thu, 21 Apr 2016 19:05:32 +0200
Message-ID: <CAKv+Gu-Sou_-UgBwrj939JQr8M5=ScZZ4M9Y-hRUa8WrkwBK7Q@mail.gmail.com>
References: <1461238529-12810-1-git-send-email-mark.rutland@arm.com>
	<1461238529-12810-6-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1461238529-12810-6-git-send-email-mark.rutland-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Russell King - ARM Linux <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org" <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 21 April 2016 at 13:35, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org> wrote:
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
> Signed-off-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  drivers/firmware/efi/runtime-wrappers.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>
> diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
> index 1b9fa54..aeb65f2 100644
> --- a/drivers/firmware/efi/runtime-wrappers.c
> +++ b/drivers/firmware/efi/runtime-wrappers.c
> @@ -16,8 +16,10 @@
>
>  #include <linux/bug.h>
>  #include <linux/efi.h>
> +#include <linux/irqflags.h>
>  #include <linux/mutex.h>
>  #include <linux/spinlock.h>
> +#include <linux/stringify.h>
>  #include <asm/efi.h>
>
>
> @@ -25,8 +27,11 @@
>  #define efi_call_virt(f, args...)                                      \
>  ({                                                                     \
>         efi_status_t __s;                                               \
> +       unsigned long flags;                                            \
>         arch_efi_call_virt_setup();                                     \
> +       local_save_flags(flags);                                        \
>         __s = arch_efi_call_virt(f, args);                              \
> +       efi_call_virt_check_flags(flags, __stringify(f));               \
>         arch_efi_call_virt_teardown();                                  \
>         __s;                                                            \
>  })
> @@ -35,12 +40,29 @@
>  #ifndef __efi_call_virt
>  #define __efi_call_virt(f, args...)                                    \
>  ({                                                                     \
> +       unsigned long flags;                                            \
>         arch_efi_call_virt_setup();                                     \
> +       local_irq_save(flags);                                          \

We shouldn't disable interrupts here. I assume this is a typo, and you
intended to use local_save_flags() as above?

>         arch_efi_call_virt(f, args);                                    \
> +       efi_call_virt_check_flags(flags, __stringify(f));               \
>         arch_efi_call_virt_teardown();                                  \
>  })
>  #endif
>
> +static void efi_call_virt_check_flags(unsigned long flags, const char *call)
> +{
> +       unsigned long cur_flags;
> +
> +       local_save_flags(cur_flags);
> +       if (!WARN_ON_ONCE(cur_flags != flags))
> +               return;
> +
> +       add_taint(TAINT_FIRMWARE_WORKAROUND, LOCKDEP_NOW_UNRELIABLE);
> +       pr_err_ratelimited(FW_BUG "IRQ flags corrupted (0x%08lx=>0x%08lx) by EFI %s\n",
> +                          flags, cur_flags, call);
> +       local_irq_restore(flags);
> +}
> +
>  /*
>   * According to section 7.1 of the UEFI spec, Runtime Services are not fully
>   * reentrant, and there are particular combinations of calls that need to be

Other than that, this series looks fine to me.

With the above fixed:

For the series (except the x86 patch)

Reviewed-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
