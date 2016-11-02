From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2] EFI loader: remove redundant code
Date: Wed, 2 Nov 2016 09:25:18 +0000
Message-ID: <CAKv+Gu8xkxPSkA+3Sqo-kcL=b6ex6MNQ7DrDV_sqcQrfmqkvCw@mail.gmail.com>
References: <20161102041855.GA4479@vnote>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161102041855.GA4479@vnote>
Sender: linux-kernel-owner@vger.kernel.org
To: Eugene Korenevsky <ekorenevsky@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Linn Crosetto <linn@hpe.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-efi@vger.kernel.org

Hello Eugene,

On 2 November 2016 at 04:18, Eugene Korenevsky <ekorenevsky@gmail.com> wrote:
> *e820ext is always NULL in 'alloc_e820ext()' (see the code of 'exit_boot()').
> Without loss of generality we can replace freeing with returning
> EFI_INVALID_PARAMETER. So if the caller would ever incorrectly pass non-NULL
> *e820ext, he will obtain a returned error code.
>

What exactly are you trying to fix here? Adding new artificial failure
modes is hardly worth it when all you are doing is cleaning up code
that by itself is correct to begin with, but is simply never called.


> ---
>  arch/x86/boot/compressed/eboot.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index cc69e37..6cc66c7 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -956,11 +956,8 @@ static efi_status_t alloc_e820ext(u32 nr_desc, struct setup_data **e820ext,
>         size = sizeof(struct setup_data) +
>                 sizeof(struct e820entry) * nr_desc;
>
> -       if (*e820ext) {
> -               efi_call_early(free_pool, *e820ext);
> -               *e820ext = NULL;
> -               *e820ext_size = 0;
> -       }
> +       if (*e820ext)
> +               return EFI_INVALID_PARAMETER;
>
>         status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
>                                 size, (void **)e820ext);
> --
> 2.10.2
>
