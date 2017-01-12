From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 4/4] efi/x86: add debug code to print cooked memmap
Date: Thu, 12 Jan 2017 16:18:21 +0000
Message-ID: <CAKv+Gu-cM4nBk8hFT8asYy7Q1g+woHLF24y+djYwVUY=1xV5gQ@mail.gmail.com>
References: <20170112094118.815108042@redhat.com> <20170112094215.016194745@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170112094215.016194745@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Young <dyoung@redhat.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Nicolai Stange <nicstange@gmail.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>, Dan Williams <dan.j.williams@intel.com>, =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>, bhsharma@redhat.com
List-Id: linux-efi@vger.kernel.org

On 12 January 2017 at 09:41, Dave Young <dyoung@redhat.com> wrote:
> It is not obvious if the reserved boot area are added correctly, add a
> efi_print_memmap to print the new memmap.
>
> Signed-off-by: Dave Young <dyoung@redhat.com>

This sounds useful regardless of the other patches in this series:

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Note that it is appropriate to keep this x86 specific, since we never
modify the memory map on ARM (except for the sorting that occurs in
the stub)

> ---
>  arch/x86/platform/efi/efi.c |    5 +++++
>  1 file changed, 5 insertions(+)
>
> --- linux-x86.orig/arch/x86/platform/efi/efi.c
> +++ linux-x86/arch/x86/platform/efi/efi.c
> @@ -873,6 +873,11 @@ static void __init __efi_enter_virtual_m
>                 return;
>         }
>
> +       if (efi_enabled(EFI_DBG)) {
> +               pr_info("EFI runtime memory map:\n");
> +               efi_print_memmap();
> +       }
> +
>         BUG_ON(!efi.systab);
>
>         if (efi_setup_page_tables(pa, 1 << pg_shift)) {
>
>
