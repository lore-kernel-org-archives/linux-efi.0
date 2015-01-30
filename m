From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] efi, x86: Add a "debug" option to the efi= cmdline
Date: Fri, 30 Jan 2015 10:06:13 -0800
Message-ID: <54CBC815.5060502@infradead.org>
References: <20141209095843.GA3990@pd.tnic> <20141210021741.GA3280@darkstar.nay.redhat.com> <20141210104627.GA17053@pd.tnic> <20150105140332.GB3163@console-pimps.org> <54AAA723.1070605@redhat.com> <54BF3DCA.4070708@jonmasters.org> <20150121100633.GC12173@pd.tnic> <20150126104936.GB3320@codeblueprint.co.uk> <20150130164309.GG1451@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150130164309.GG1451-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Cc: Jon Masters <jonathan-Zp4isUonpHBD60Wz+7aTrA@public.gmane.org>, Laszlo Ersek <lersek-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ricardo Neri <ricardo.neri-calderon-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 01/30/15 08:43, Borislav Petkov wrote:
> From: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> Date: Mon, 26 Jan 2015 19:49:59 +0100
> Subject: [PATCH] efi, x86: Add a "debug" option to the efi= cmdline
> 

Please update Documentation/kernel-parameters.txt also.

> ... and hide the memory regions dump behind it. Make it default-off.
> 
> Signed-off-by: Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
> Link: http://lkml.kernel.org/r/20141209095843.GA3990-fF5Pk5pvG8Y@public.gmane.org
> ---
>  arch/x86/platform/efi/efi.c | 5 ++++-
>  include/linux/efi.h         | 1 +
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index dbc8627a5cdf..e859d56ce9f8 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -491,7 +491,8 @@ void __init efi_init(void)
>  	if (efi_memmap_init())
>  		return;
>  
> -	print_efi_memmap();
> +	if (efi_enabled(EFI_DBG))
> +		print_efi_memmap();
>  }
>  
>  void __init efi_late_init(void)
> @@ -939,6 +940,8 @@ static int __init arch_parse_efi_cmdline(char *str)
>  {
>  	if (parse_option_str(str, "old_map"))
>  		set_bit(EFI_OLD_MEMMAP, &efi.flags);
> +	if (parse_option_str(str, "debug"))
> +		set_bit(EFI_DBG, &efi.flags);
>  
>  	return 0;
>  }
> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index 0238d612750e..14cec75d7e74 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -940,6 +940,7 @@ extern int __init efi_setup_pcdp_console(char *);
>  #define EFI_64BIT		5	/* Is the firmware 64-bit? */
>  #define EFI_PARAVIRT		6	/* Access is via a paravirt interface */
>  #define EFI_ARCH_1		7	/* First arch-specific bit */
> +#define EFI_DBG			8	/* Print additional debug info at runtime */
>  
>  #ifdef CONFIG_EFI
>  /*
> 


-- 
~Randy
