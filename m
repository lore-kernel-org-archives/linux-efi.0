From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] efi: make const array 'apple' static
Date: Fri, 2 Mar 2018 15:56:34 +0000
Message-ID: <CAKv+Gu9+hBnu9BF1MrwD7PWn9uqpbQqcwZVq9LdxhBUJC+9vDg@mail.gmail.com>
References: <20180302143530.1713-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180302143530.1713-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, linux-efi@vger.kernel.org, kernel-janitors@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 2 March 2018 at 14:35, Colin King <colin.king@canonical.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
>
> Don't populate the const read-only array 'buf' on the stack but instead
> make it static. Makes the object code smaller by 64 bytes:
>
> Before:
>    text    data     bss     dec     hex filename
>    9264       1      16    9281    2441 arch/x86/boot/compressed/eboot.o
>
> After:
>    text    data     bss     dec     hex filename
>    9200       1      16    9217    2401 arch/x86/boot/compressed/eboot.o
>
> (gcc version 7.2.0 x86_64)
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Thanks Colin

Queued in efi-next.


> ---
>  arch/x86/boot/compressed/eboot.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index 886a9115af62..f2251c1c9853 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -423,7 +423,7 @@ static void retrieve_apple_device_properties(struct boot_params *boot_params)
>
>  static void setup_quirks(struct boot_params *boot_params)
>  {
> -       efi_char16_t const apple[] = { 'A', 'p', 'p', 'l', 'e', 0 };
> +       static efi_char16_t const apple[] = { 'A', 'p', 'p', 'l', 'e', 0 };
>         efi_char16_t *fw_vendor = (efi_char16_t *)(unsigned long)
>                 efi_table_attr(efi_system_table, fw_vendor, sys_table);
>
> --
> 2.15.1
>
