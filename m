From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] x86: move parse_early_param to earlier code for
 add_efi_memmap
Date: Thu, 14 Dec 2017 18:41:19 +0800
Message-ID: <20171214104119.GA2437@dhcp-128-65.nay.redhat.com>
References: <20171130052327.GA3500@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171130052327.GA3500-0VdLhd/A9Pl+NNSt+8eSiB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 11/30/17 at 01:23pm, Dave Young wrote:
> 'add_efi_memmap' is an early param, but do_add_efi_memmap() has no
> chance to run because the code path is before parse_early_param().
> I believe it worked when the param was introduced but probably later
> some other changes caused the wrong order and nobody noticed it.
> 
> Move parse_early_param before efi_memblock_x86_reserve_range to fix
> this.
> 
> Signed-off-by: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  arch/x86/kernel/setup.c |   55 ++++++++++++++++++++++++------------------------
>  1 file changed, 28 insertions(+), 27 deletions(-)
> 
> --- linux-x86.orig/arch/x86/kernel/setup.c
> +++ linux-x86/arch/x86/kernel/setup.c
> @@ -897,6 +897,34 @@ void __init setup_arch(char **cmdline_p)
>  	rd_prompt = ((boot_params.hdr.ram_size & RAMDISK_PROMPT_FLAG) != 0);
>  	rd_doload = ((boot_params.hdr.ram_size & RAMDISK_LOAD_FLAG) != 0);
>  #endif
> +
> +#ifdef CONFIG_CMDLINE_BOOL
> +#ifdef CONFIG_CMDLINE_OVERRIDE
> +	strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
> +#else
> +	if (builtin_cmdline[0]) {
> +		/* append boot loader cmdline to builtin */
> +		strlcat(builtin_cmdline, " ", COMMAND_LINE_SIZE);
> +		strlcat(builtin_cmdline, boot_command_line, COMMAND_LINE_SIZE);
> +		strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
> +	}
> +#endif
> +#endif
> +
> +	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
> +	*cmdline_p = command_line;
> +
> +	/*
> +	 * x86_configure_nx() is called before parse_early_param() to detect
> +	 * whether hardware doesn't support NX (so that the early EHCI debug
> +	 * console setup can safely call set_fixmap()). It may then be called
> +	 * again from within noexec_setup() during parsing early parameters
> +	 * to honor the respective command line option.
> +	 */
> +	x86_configure_nx();
> +
> +	parse_early_param();
> +
>  #ifdef CONFIG_EFI
>  	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
>  		     EFI32_LOADER_SIGNATURE, 4)) {
> @@ -935,33 +963,6 @@ void __init setup_arch(char **cmdline_p)
>  	bss_resource.start = __pa_symbol(__bss_start);
>  	bss_resource.end = __pa_symbol(__bss_stop)-1;
>  
> -#ifdef CONFIG_CMDLINE_BOOL
> -#ifdef CONFIG_CMDLINE_OVERRIDE
> -	strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
> -#else
> -	if (builtin_cmdline[0]) {
> -		/* append boot loader cmdline to builtin */
> -		strlcat(builtin_cmdline, " ", COMMAND_LINE_SIZE);
> -		strlcat(builtin_cmdline, boot_command_line, COMMAND_LINE_SIZE);
> -		strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
> -	}
> -#endif
> -#endif
> -
> -	strlcpy(command_line, boot_command_line, COMMAND_LINE_SIZE);
> -	*cmdline_p = command_line;
> -
> -	/*
> -	 * x86_configure_nx() is called before parse_early_param() to detect
> -	 * whether hardware doesn't support NX (so that the early EHCI debug
> -	 * console setup can safely call set_fixmap()). It may then be called
> -	 * again from within noexec_setup() during parsing early parameters
> -	 * to honor the respective command line option.
> -	 */
> -	x86_configure_nx();
> -
> -	parse_early_param();
> -
>  #ifdef CONFIG_MEMORY_HOTPLUG
>  	/*
>  	 * Memory used by the kernel cannot be hot-removed because Linux
> --
> To unsubscribe from this list: send the line "unsubscribe linux-efi" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Ping for review..

Another way is move "efi_memblock_x86_reserve_range" to later code
Maybe below is better?

---
 arch/x86/kernel/setup.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- linux-x86.orig/arch/x86/kernel/setup.c
+++ linux-x86/arch/x86/kernel/setup.c
@@ -906,9 +906,6 @@ void __init setup_arch(char **cmdline_p)
 		set_bit(EFI_BOOT, &efi.flags);
 		set_bit(EFI_64BIT, &efi.flags);
 	}
-
-	if (efi_enabled(EFI_BOOT))
-		efi_memblock_x86_reserve_range();
 #endif
 
 	x86_init.oem.arch_setup();
@@ -962,6 +959,8 @@ void __init setup_arch(char **cmdline_p)
 
 	parse_early_param();
 
+	if (efi_enabled(EFI_BOOT))
+		efi_memblock_x86_reserve_range();
 #ifdef CONFIG_MEMORY_HOTPLUG
 	/*
 	 * Memory used by the kernel cannot be hot-removed because Linux

Thanks
Dave
