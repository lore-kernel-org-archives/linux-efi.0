From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/2] efi: Process MEMATTR table only if EFI_MEMMAP
Date: Wed, 21 Jun 2017 09:48:37 +0200
Message-ID: <CAKv+Gu8jrYQpABGRxOYFyuGZ8WsCojBLtGMiXQVVdeRR2x5o9A@mail.gmail.com>
References: <1497989668-6238-1-git-send-email-daniel.kiper@oracle.com> <1497989668-6238-2-git-send-email-daniel.kiper@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1497989668-6238-2-git-send-email-daniel.kiper@oracle.com>
Sender: stable-owner@vger.kernel.org
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, xen-devel@lists.xenproject.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>, Matt Fleming <matt@codeblueprint.co.uk>
List-Id: linux-efi@vger.kernel.org

On 20 June 2017 at 22:14, Daniel Kiper <daniel.kiper@oracle.com> wrote:
> Otherwise e.g. Xen dom0 on x86_64 EFI platforms crashes.
>
> In theory we can check EFI_PARAVIRT too, however,
> EFI_MEMMAP looks more generic and covers more cases.
>
> Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  drivers/firmware/efi/efi.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index b372aad..045d6d3 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -528,7 +528,8 @@ int __init efi_config_parse_tables(void *config_tables, int count, int sz,
>                 }
>         }
>
> -       efi_memattr_init();
> +       if (efi_enabled(EFI_MEMMAP))
> +               efi_memattr_init();
>
>         /* Parse the EFI Properties table if it exists */
>         if (efi.properties_table != EFI_INVALID_TABLE_ADDR) {
> --
> 1.7.10.4
>
