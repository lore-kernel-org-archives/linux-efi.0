From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 3/3] x86/platform/UV: use efi_runtime_sem to serialise
 BIOS calls
Date: Sat, 26 Jan 2019 15:10:49 +0100
Message-ID: <CAKv+Gu97kdYvK+gMF39GXsP-K34OuvhOTODE0F8prb-4tH2FCQ@mail.gmail.com>
References: <20190109104541.25733-1-hedi.berriche@hpe.com> <20190109104541.25733-4-hedi.berriche@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190109104541.25733-4-hedi.berriche@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hedi Berriche <hedi.berriche@hpe.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Russ Anderson <rja@hpe.com>, Mike Travis <mike.travis@hpe.com>, Dimitri Sivanich <sivanich@hpe.com>, Steve Wahl <steve.wahl@hpe.com>
List-Id: linux-efi@vger.kernel.org

On Wed, 9 Jan 2019 at 11:46, Hedi Berriche <hedi.berriche@hpe.com> wrote:
>
> Calls into UV firmware must be protected against concurrency, use the
> now visible efi_runtime_sem lock to serialise them.
>
> Signed-off-by: Hedi Berriche <hedi.berriche@hpe.com>
> Reviewed-by: Russ Anderson <rja@hpe.com>
> Reviewed-by: Mike Travis <mike.travis@hpe.com>
> Reviewed-by: Dimitri Sivanich <sivanich@hpe.com>
> Reviewed-by: Steve Wahl <steve.wahl@hpe.com>

> ---
>  arch/x86/include/asm/uv/bios.h |  3 ++-
>  arch/x86/platform/uv/bios_uv.c | 25 ++++++++++++++++++++++---
>  2 files changed, 24 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/include/asm/uv/bios.h b/arch/x86/include/asm/uv/bios.h
> index 4eee646544b2..33e94aa0b1ff 100644
> --- a/arch/x86/include/asm/uv/bios.h
> +++ b/arch/x86/include/asm/uv/bios.h
> @@ -48,7 +48,8 @@ enum {
>         BIOS_STATUS_SUCCESS             =  0,
>         BIOS_STATUS_UNIMPLEMENTED       = -ENOSYS,
>         BIOS_STATUS_EINVAL              = -EINVAL,
> -       BIOS_STATUS_UNAVAIL             = -EBUSY
> +       BIOS_STATUS_UNAVAIL             = -EBUSY,
> +       BIOS_STATUS_ABORT               = -EINTR

Nit: please add a trailing comma so the next patch looks cleaner.

>  };
>
>  /* Address map parameters */
> diff --git a/arch/x86/platform/uv/bios_uv.c b/arch/x86/platform/uv/bios_uv.c
> index cd05af157763..92f960798e20 100644
> --- a/arch/x86/platform/uv/bios_uv.c
> +++ b/arch/x86/platform/uv/bios_uv.c
> @@ -29,7 +29,8 @@
>
>  struct uv_systab *uv_systab;
>
> -s64 uv_bios_call(enum uv_bios_cmd which, u64 a1, u64 a2, u64 a3, u64 a4, u64 a5)
> +s64 __uv_bios_call(enum uv_bios_cmd which, u64 a1, u64 a2, u64 a3,
> +                       u64 a4, u64 a5)
>  {
>         struct uv_systab *tab = uv_systab;
>         s64 ret;
> @@ -44,13 +45,26 @@ s64 uv_bios_call(enum uv_bios_cmd which, u64 a1, u64 a2, u64 a3, u64 a4, u64 a5)
>          * If EFI_OLD_MEMMAP is set, we need to fall back to using our old EFI
>          * callback method, which uses efi_call() directly, with the kernel page tables:
>          */
> -       if (unlikely(test_bit(EFI_OLD_MEMMAP, &efi.flags)))
> +       if (unlikely(efi_enabled(EFI_OLD_MEMMAP)))

This is an unrelated change. You should at least mention it in the
commit log, or put it in a separate patch.

>                 ret = efi_call((void *)__va(tab->function), (u64)which, a1, a2, a3, a4, a5);
>         else
>                 ret = efi_call_virt_pointer(tab, function, (u64)which, a1, a2, a3, a4, a5);
>
>         return ret;
>  }
> +
> +s64 uv_bios_call(enum uv_bios_cmd which, u64 a1, u64 a2, u64 a3, u64 a4, u64 a5)
> +{
> +       s64 ret;
> +
> +       if (down_interruptible(&efi_runtime_sem))
> +               return BIOS_STATUS_ABORT;
> +
> +       ret = __uv_bios_call(which, a1, a2, a3, a4, a5);
> +       up(&efi_runtime_sem);
> +
> +       return ret;
> +}
>  EXPORT_SYMBOL_GPL(uv_bios_call);
>
>  s64 uv_bios_call_irqsave(enum uv_bios_cmd which, u64 a1, u64 a2, u64 a3,
> @@ -59,10 +73,15 @@ s64 uv_bios_call_irqsave(enum uv_bios_cmd which, u64 a1, u64 a2, u64 a3,
>         unsigned long bios_flags;
>         s64 ret;
>
> +       if (down_interruptible(&efi_runtime_sem))
> +               return BIOS_STATUS_ABORT;
> +
>         local_irq_save(bios_flags);
> -       ret = uv_bios_call(which, a1, a2, a3, a4, a5);
> +       ret = __uv_bios_call(which, a1, a2, a3, a4, a5);
>         local_irq_restore(bios_flags);
>
> +       up(&efi_runtime_sem);
> +
>         return ret;
>  }
>
> --
> 2.20.0
>
