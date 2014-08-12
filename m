From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/5] efi: move noefi early param code out of x86 arch
 code
Date: Mon, 11 Aug 2014 23:52:35 -0700
Message-ID: <53E9B9B3.1050504@infradead.org>
References: <1407823822-23829-1-git-send-email-dyoung@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1407823822-23829-1-git-send-email-dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 08/11/14 23:10, Dave Young wrote:
> noefi param can be used for arches other than X86 later, thus move it out of
> x86 platform code.
> 
> Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/platform/efi/efi.c | 10 +---------
>  drivers/firmware/efi/efi.c  | 13 +++++++++++++
>  include/linux/efi.h         |  1 +
>  3 files changed, 15 insertions(+), 9 deletions(-)

This line in Documentation/kernel-parameters.txt needs to be updated:

	noefi		[X86] Disable EFI runtime services support.


> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index 850da94..dd7aaa1 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -70,14 +70,6 @@ static efi_config_table_type_t arch_tables[] __initdata = {
>  
>  u64 efi_setup;		/* efi setup_data physical address */
>  
> -static bool disable_runtime __initdata = false;
> -static int __init setup_noefi(char *arg)
> -{
> -	disable_runtime = true;
> -	return 0;
> -}
> -early_param("noefi", setup_noefi);
> -
>  int add_efi_memmap;
>  EXPORT_SYMBOL(add_efi_memmap);
>  
> @@ -492,7 +484,7 @@ void __init efi_init(void)
>  	if (!efi_runtime_supported())
>  		pr_info("No EFI runtime due to 32/64-bit mismatch with kernel\n");
>  	else {
> -		if (disable_runtime || efi_runtime_init())
> +		if (efi_runtime_disabled() || efi_runtime_init())
>  			return;
>  	}
>  	if (efi_memmap_init())
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 64ecbb5..c8f01a7 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -41,6 +41,19 @@ struct efi __read_mostly efi = {
>  };
>  EXPORT_SYMBOL(efi);
>  
> +static bool disable_runtime;
> +static int __init setup_noefi(char *arg)
> +{
> +	disable_runtime = true;
> +	return 0;
> +}
> +early_param("noefi", setup_noefi);
> +
> +bool efi_runtime_disabled(void)
> +{
> +	return disable_runtime;
> +}
> +
>  static struct kobject *efi_kobj;
>  static struct kobject *efivars_kobj;
>  
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 45cb4ff..06d7c03 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -1227,4 +1227,5 @@ efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
>  				  unsigned long *load_addr,
>  				  unsigned long *load_size);
>  
> +bool efi_runtime_disabled(void);
>  #endif /* _LINUX_EFI_H */
> 


-- 
~Randy
