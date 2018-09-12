From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] x86/efi: earlyprintk - Add 64bit efi fb address support
Date: Wed, 12 Sep 2018 17:00:16 +0200
Message-ID: <CAKv+Gu_dfQUXDdvk99fe6-qW3wj8e=8wR2aqCtJj1GfkXirzRg@mail.gmail.com>
References: <1536423828-5693-1-git-send-email-aaron.ma@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1536423828-5693-1-git-send-email-aaron.ma@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Aaron Ma <aaron.ma@canonical.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, the arch/x86 maintainers <x86@kernel.org>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 8 September 2018 at 18:23, Aaron Ma <aaron.ma@canonical.com> wrote:
> EFI GOP uses 64-bit frame buffer address in some BIOS.
> Add 64bit address support in efi earlyprintk.
>
> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
> ---
>  arch/x86/platform/efi/early_printk.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/arch/x86/platform/efi/early_printk.c b/arch/x86/platform/efi/early_printk.c
> index 5fdacb322ceb..c0ae25f59acd 100644
> --- a/arch/x86/platform/efi/early_printk.c
> +++ b/arch/x86/platform/efi/early_printk.c
> @@ -32,6 +32,8 @@ static __init int early_efi_map_fb(void)
>                 return 0;
>
>         base = boot_params.screen_info.lfb_base;
> +       if (boot_params.screen_info.capabilities & VIDEO_CAPABILITY_64BIT_BASE)
> +               base |= (u64)boot_params.screen_info.ext_lfb_base << 32;
>         size = boot_params.screen_info.lfb_size;
>         efi_fb = ioremap(base, size);
>
> @@ -49,6 +51,8 @@ static __ref void *early_efi_map(unsigned long start, unsigned long len)
>         unsigned long base;
>
>         base = boot_params.screen_info.lfb_base;
> +       if (boot_params.screen_info.capabilities & VIDEO_CAPABILITY_64BIT_BASE)
> +               base |= (u64)boot_params.screen_info.ext_lfb_base << 32;
>
>         if (efi_fb)
>                 return (efi_fb + start);

Please fix this in a way that works on 32-bit x86/PAE as well (i.e.,
use a suitable type for base)
