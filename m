From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 12/12] efi: make const array 'apple' static
Date: Fri, 9 Mar 2018 08:47:19 +0100
Message-ID: <20180309074719.y33xe4bjkjsjsaa3@gmail.com>
References: <20180308080020.22828-1-ard.biesheuvel@linaro.org>
 <20180308080020.22828-13-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180308080020.22828-13-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-efi@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Colin Ian King <colin.king@canonical.com>, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org


* Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Don't populate the const read-only array 'buf' on the stack but instead
> make it static. Makes the object code smaller by 64 bytes:
> 
> Before:
>    text	   data	    bss	    dec	    hex	filename
>    9264	      1	     16	   9281	   2441	arch/x86/boot/compressed/eboot.o
> 
> After:
>    text	   data	    bss	    dec	    hex	filename
>    9200	      1	     16	   9217	   2401	arch/x86/boot/compressed/eboot.o
> 
> (gcc version 7.2.0 x86_64)
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
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
> -	efi_char16_t const apple[] = { 'A', 'p', 'p', 'l', 'e', 0 };
> +	static efi_char16_t const apple[] = { 'A', 'p', 'p', 'l', 'e', 0 };
>  	efi_char16_t *fw_vendor = (efi_char16_t *)(unsigned long)
>  		efi_table_attr(efi_system_table, fw_vendor, sys_table);

As a general policy, please don't put 'static' variables into the local scope,
use file scope instead - right before setup_quirks() would be fine.

This makes it abundantly clear that it's not on the stack.

Also, would it make sense to rename it to something more descriptive like 
"apple_unicode_str[]" or so?

Plus an unicode string literal initializer would be pretty descriptive as well, 
instead of the weird looking character array, i.e. something like:

  static efi_char16_t const apple_unicode_str[] = u"Apple";

... or so?

Thanks,

	Ingo
