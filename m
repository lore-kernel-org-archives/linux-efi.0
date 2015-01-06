From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] arm64: call early_ioremap_reset() in paging_init()
Date: Tue, 6 Jan 2015 09:39:52 +0000
Message-ID: <CAKv+Gu9G8R7CscCBw9Xg1SrJgUMjDtbOCaTSw+3BOAFXBmBVcg@mail.gmail.com>
References: <1420482835-6444-1-git-send-email-leif.lindholm@linaro.org>
	<1420482835-6444-3-git-send-email-leif.lindholm@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1420482835-6444-3-git-send-email-leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 5 January 2015 at 18:33, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> arm64 does not support early_memremap/memunmap/ioremap/iounmap after
> paging_init() has been called. The core early_*remap code handles this
> via the after_paging_init variable, which is set by a call to
> early_ioremap_reset().
>
> However, arm64 currently does not call early_ioremap_reset(), which
> has made it possible to poke around in the fixmap region after kmap
> is enabled. Add the required call.
>
> Signed-off-by: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Acked-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Perhaps add 'Fixes' and 'Cc: stable' tags as well?


> ---
>  arch/arm64/mm/mmu.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index 6032f3e..506544f 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -348,6 +348,7 @@ void __init paging_init(void)
>  {
>         void *zero_page;
>
> +       early_ioremap_reset();
>         map_mem();
>
>         /*
> --
> 2.1.3
>
