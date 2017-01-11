From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 5/8] efi: Get the secure boot status [ver #6]
Date: Wed, 11 Jan 2017 14:33:04 +0000
Message-ID: <20170111143304.GA29649@codeblueprint.co.uk>
References: <148120020832.5854.5448601415491330495.stgit@warthog.procyon.org.uk>
 <148120024570.5854.10638278395097394138.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <148120024570.5854.10638278395097394138.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Thu, 08 Dec, at 12:30:45PM, David Howells wrote:
> Get the firmware's secure-boot status in the kernel boot wrapper and stash
> it somewhere that the main kernel image can find.
> 
> The efi_get_secureboot() function is extracted from the arm stub and (a)
> generalised so that it can be called from x86 and (b) made to use
> efi_call_runtime() so that it can be run in mixed-mode.
> 
> Suggested-by: Lukas Wunner <lukas-JFq808J9C/izQB+pC5nmwQ@public.gmane.org>
> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> 
>  Documentation/x86/zero-page.txt           |    2 +
>  arch/x86/boot/compressed/eboot.c          |    2 +
>  arch/x86/boot/compressed/head_32.S        |    1 
>  arch/x86/boot/compressed/head_64.S        |    1 
>  arch/x86/include/asm/bootparam_utils.h    |    5 +-
>  arch/x86/include/uapi/asm/bootparam.h     |    3 +
>  arch/x86/kernel/asm-offsets.c             |    1 
>  drivers/firmware/efi/libstub/Makefile     |    2 -
>  drivers/firmware/efi/libstub/arm-stub.c   |   63 +++--------------------------
>  drivers/firmware/efi/libstub/secureboot.c |   63 +++++++++++++++++++++++++++++
>  include/linux/efi.h                       |    8 ++++
>  11 files changed, 90 insertions(+), 61 deletions(-)
>  create mode 100644 drivers/firmware/efi/libstub/secureboot.c
 
[...]

> diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
> index d85b9625e836..c635f7e32f5c 100644
> --- a/arch/x86/boot/compressed/head_32.S
> +++ b/arch/x86/boot/compressed/head_32.S
> @@ -61,6 +61,7 @@
>  
>  	__HEAD
>  ENTRY(startup_32)
> +	movb	$0, BP_secure_boot(%esi)
>  #ifdef CONFIG_EFI_STUB
>  	jmp	preferred_addr
>  
> diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
> index beab8322f72a..ccd2c7461b7f 100644
> --- a/arch/x86/boot/compressed/head_64.S
> +++ b/arch/x86/boot/compressed/head_64.S
> @@ -244,6 +244,7 @@ ENTRY(startup_64)
>  	 * that maps our entire kernel(text+data+bss+brk), zero page
>  	 * and command line.
>  	 */
> +	movb	$0, BP_secure_boot(%rsi)
>  #ifdef CONFIG_EFI_STUB
>  	/*
>  	 * The entry point for the PE/COFF executable is efi_pe_entry, so

Is clearing ::secure_boot really necessary? Any code path that goes
via efi_main() will set it correctly and all other code paths should
get it cleared in sanitize_boot_params(), no?

> diff --git a/include/linux/efi.h b/include/linux/efi.h
> index c7904556d7a8..92e23f03045e 100644
> --- a/include/linux/efi.h
> +++ b/include/linux/efi.h
> @@ -1477,6 +1477,14 @@ efi_status_t efi_setup_gop(efi_system_table_t *sys_table_arg,
>  bool efi_runtime_disabled(void);
>  extern void efi_call_virt_check_flags(unsigned long flags, const char *call);
>  
> +enum efi_secureboot_mode {
> +	efi_secureboot_mode_unset,
> +	efi_secureboot_mode_unknown,
> +	efi_secureboot_mode_disabled,
> +	efi_secureboot_mode_enabled,
> +};
> +enum efi_secureboot_mode efi_get_secureboot(efi_system_table_t *sys_table);
> +
>  /*
>   * Arch code can implement the following three template macros, avoiding
>   * reptition for the void/non-void return cases of {__,}efi_call_virt():
> 

What's the distinction between the unset and unknown enums?
