From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 2/3] x86/platform/UV: kill uv_bios_call_reentrant() as it
 has no callers
Date: Sat, 26 Jan 2019 15:04:36 +0100
Message-ID: <CAKv+Gu8LZmAsJMGBhvOzZTzwqg_p=y7_GdqB=qmFmpMDaRSqwQ@mail.gmail.com>
References: <20190109104541.25733-1-hedi.berriche@hpe.com> <20190109104541.25733-3-hedi.berriche@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190109104541.25733-3-hedi.berriche@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Hedi Berriche <hedi.berriche@hpe.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Russ Anderson <rja@hpe.com>, Mike Travis <mike.travis@hpe.com>, Dimitri Sivanich <sivanich@hpe.com>, Steve Wahl <steve.wahl@hpe.com>
List-Id: linux-efi@vger.kernel.org

On Wed, 9 Jan 2019 at 11:46, Hedi Berriche <hedi.berriche@hpe.com> wrote:
>
> uv_bios_call_reentrant() has no callers nor is it exported, kill it.
>
> Signed-off-by: Hedi Berriche <hedi.berriche@hpe.com>
> Reviewed-by: Russ Anderson <rja@hpe.com>
> Reviewed-by: Mike Travis <mike.travis@hpe.com>
> Reviewed-by: Dimitri Sivanich <sivanich@hpe.com>
> Reviewed-by: Steve Wahl <steve.wahl@hpe.com>

Please drop these reviewed-bys

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  arch/x86/include/asm/uv/bios.h |  1 -
>  arch/x86/platform/uv/bios_uv.c | 12 ------------
>  2 files changed, 13 deletions(-)
>
> diff --git a/arch/x86/include/asm/uv/bios.h b/arch/x86/include/asm/uv/bios.h
> index e652a7cc6186..4eee646544b2 100644
> --- a/arch/x86/include/asm/uv/bios.h
> +++ b/arch/x86/include/asm/uv/bios.h
> @@ -140,7 +140,6 @@ enum uv_memprotect {
>   */
>  extern s64 uv_bios_call(enum uv_bios_cmd, u64, u64, u64, u64, u64);
>  extern s64 uv_bios_call_irqsave(enum uv_bios_cmd, u64, u64, u64, u64, u64);
> -extern s64 uv_bios_call_reentrant(enum uv_bios_cmd, u64, u64, u64, u64, u64);
>
>  extern s64 uv_bios_get_sn_info(int, int *, long *, long *, long *, long *);
>  extern s64 uv_bios_freq_base(u64, u64 *);
> diff --git a/arch/x86/platform/uv/bios_uv.c b/arch/x86/platform/uv/bios_uv.c
> index 4a6a5a26c582..cd05af157763 100644
> --- a/arch/x86/platform/uv/bios_uv.c
> +++ b/arch/x86/platform/uv/bios_uv.c
> @@ -66,18 +66,6 @@ s64 uv_bios_call_irqsave(enum uv_bios_cmd which, u64 a1, u64 a2, u64 a3,
>         return ret;
>  }
>
> -s64 uv_bios_call_reentrant(enum uv_bios_cmd which, u64 a1, u64 a2, u64 a3,
> -                                       u64 a4, u64 a5)
> -{
> -       s64 ret;
> -
> -       preempt_disable();
> -       ret = uv_bios_call(which, a1, a2, a3, a4, a5);
> -       preempt_enable();
> -
> -       return ret;
> -}
> -
>
>  long sn_partition_id;
>  EXPORT_SYMBOL_GPL(sn_partition_id);
> --
> 2.20.0
>
