From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] efi/arm64: store Runtime Services revision
Date: Fri, 15 Aug 2014 15:38:48 +0200
Message-ID: <CAKv+Gu9ABf9VzMiT-nA1tt8tbjimCZGatiT1ucwcFTnt7qdmfQ@mail.gmail.com>
References: <1408108964-28650-1-git-send-email-semen.protsenko@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1408108964-28650-1-git-send-email-semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Semen Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 15 August 2014 15:22, Semen Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> "efi" global data structure contains "runtime_version" field which must
> be assigned in order to use it later in Runtime Services virtual calls
> (virt_efi_* functions).
>
> Before this patch "runtime_version" was unassigned (0), so each
> Runtime Service virtual call that checks revision would fail.
>
> Signed-off-by: Semen Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Acked-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

@Matt, could you take this?

-- 
Ard.


> ---
>  arch/arm64/kernel/efi.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index e72f310..5dbb7bd 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -463,6 +463,8 @@ static int __init arm64_enter_virtual_mode(void)
>         efi_native_runtime_setup();
>         set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
>
> +       efi.runtime_version = efi.systab->hdr.revision;
> +
>         return 0;
>
>  err_unmap:
> --
> 2.0.1
>
