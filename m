From: Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/5] efi/x86: efistub: move shared dependencies to
 <asm/efi.h>
Date: Wed, 02 Jul 2014 08:59:56 -0400
Message-ID: <1404305996.19665.7.camel@deneb.redhat.com>
References: <1403792617-25792-1-git-send-email-ard.biesheuvel@linaro.org>
	 <1403792617-25792-3-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403792617-25792-3-git-send-email-ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 2014-06-26 at 16:23 +0200, Ard Biesheuvel wrote:
> This moves definitions depended upon both by code under arch/x86/boot and
> under drivers/firmware/efi to <asm/efi.h>. This is in preparation of turning
> the stub code under drivers/firmware/efi into a static library.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
> ---
>  arch/x86/boot/compressed/eboot.c |  5 +----
>  arch/x86/boot/compressed/eboot.h | 16 ----------------
>  arch/x86/include/asm/efi.h       | 25 +++++++++++++++++++++++++
>  3 files changed, 26 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index 0331d765c2bb..2fd5e2643623 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -19,10 +19,7 @@
>  
>  static efi_system_table_t *sys_table;
>  
> -static struct efi_config *efi_early;
> -
> -#define efi_call_early(f, ...)						\
> -	efi_early->call(efi_early->f, __VA_ARGS__);
> +struct efi_config *efi_early;
>  
>  #define BOOT_SERVICES(bits)						\
>  static void setup_boot_services##bits(struct efi_config *c)		\
> diff --git a/arch/x86/boot/compressed/eboot.h b/arch/x86/boot/compressed/eboot.h
> index c88c31ecad12..d487e727f1ec 100644
> --- a/arch/x86/boot/compressed/eboot.h
> +++ b/arch/x86/boot/compressed/eboot.h
> @@ -103,20 +103,4 @@ struct efi_uga_draw_protocol {
>  	void *blt;
>  };
>  
> -struct efi_config {
> -	u64 image_handle;
> -	u64 table;
> -	u64 allocate_pool;
> -	u64 allocate_pages;
> -	u64 get_memory_map;
> -	u64 free_pool;
> -	u64 free_pages;
> -	u64 locate_handle;
> -	u64 handle_protocol;
> -	u64 exit_boot_services;
> -	u64 text_output;
> -	efi_status_t (*call)(unsigned long, ...);
> -	bool is64;
> -} __packed;
> -
>  #endif /* BOOT_COMPRESSED_EBOOT_H */
> diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
> index 1eb5f6433ad8..55059a50a01f 100644
> --- a/arch/x86/include/asm/efi.h
> +++ b/arch/x86/include/asm/efi.h
> @@ -156,6 +156,31 @@ static inline efi_status_t efi_thunk_set_virtual_address_map(
>  	return EFI_SUCCESS;
>  }
>  #endif /* CONFIG_EFI_MIXED */
> +
> +
> +/* arch specific definitions used by the stub code */
> +
> +struct efi_config {
> +	u64 image_handle;
> +	u64 table;
> +	u64 allocate_pool;
> +	u64 allocate_pages;
> +	u64 get_memory_map;
> +	u64 free_pool;
> +	u64 free_pages;
> +	u64 locate_handle;
> +	u64 handle_protocol;
> +	u64 exit_boot_services;
> +	u64 text_output;
> +	efi_status_t (*call)(unsigned long, ...);
> +	bool is64;
> +} __packed;
> +
> +extern struct efi_config *efi_early;
> +
> +#define efi_call_early(f, ...)						\
> +	efi_early->call(efi_early->f, __VA_ARGS__);

That shouldn't have the trailing ;

> +
>  #else
>  /*
>   * IF EFI is not configured, have the EFI calls return -ENOSYS.
